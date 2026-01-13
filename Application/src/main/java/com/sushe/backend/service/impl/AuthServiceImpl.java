package com.sushe.backend.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.dto.auth.LoginDTO;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.mapper.SysMenuMapper;
import com.sushe.backend.mapper.SysRoleMapper;
import com.sushe.backend.mapper.SysUserMapper;
import com.sushe.backend.service.AuthService;
import com.sushe.backend.service.UserOnlineService;
import com.sushe.backend.util.RefreshTokenUtil;
import com.sushe.backend.vo.LoginVO;
import com.sushe.backend.vo.UserInfoVO;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 认证服务实现类
 *
 * @author 陈鸿昇
 * @date 2025-12-30
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final SysMenuMapper menuMapper;
    private final BCryptPasswordEncoder passwordEncoder;
    private final UserOnlineService userOnlineService;

    /**
     * Refresh Token Cookie 名称
     */
    private static final String REFRESH_TOKEN_COOKIE_NAME = "refresh_token";

    /**
     * Refresh Token Cookie 有效期（7天，单位：秒）
     */
    private static final int REFRESH_TOKEN_COOKIE_MAX_AGE = 7 * 24 * 60 * 60;

    /**
     * 是否在生产环境（用于设置 Secure Cookie）
     */
    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    @Override
    public LoginVO login(LoginDTO loginDTO, HttpServletRequest request, HttpServletResponse response) {
        log.info("用户登录: {}", loginDTO.getUsername());

        // 1. 查询并验证用户
        SysUser user = validateUserCredentials(loginDTO);

        // 2. 执行登录并生成令牌
        String accessToken = performLogin(user.getId());

        // 3. 生成并设置 Refresh Token
        generateRefreshToken(user.getId(), response);

        // 4. 更新最后登录时间
        updateLastLoginTime(user);

        // 5. 构建返回数据
        return buildLoginResponse(user, accessToken);
    }

    /**
     * 验证用户凭据
     */
    private SysUser validateUserCredentials(LoginDTO loginDTO) {
        SysUser user = userMapper.selectOne(
                new LambdaQueryWrapper<SysUser>()
                        .eq(SysUser::getUsername, loginDTO.getUsername())
        );

        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }

        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }

        if (user.getStatus() == 0) {
            throw new BusinessException("账号已被停用，请联系管理员");
        }

        return user;
    }

    /**
     * 执行登录并生成 Access Token
     */
    private String performLogin(Long userId) {
        try {
            StpUtil.login(userId);
            userOnlineService.userOnline(userId);
            return StpUtil.getTokenValue();
        } catch (Exception e) {
            log.error("登录失败", e);
            throw new BusinessException("登录失败: " + e.getMessage());
        }
    }

    /**
     * 生成并设置 Refresh Token
     */
    private void generateRefreshToken(Long userId, HttpServletResponse response) {
        try {
            String refreshToken = RefreshTokenUtil.login(userId);
            setRefreshTokenCookie(response, refreshToken);
        } catch (Exception e) {
            log.warn("Refresh Token生成失败，但登录继续", e);
        }
    }

    /**
     * 更新最后登录时间
     */
    private void updateLastLoginTime(SysUser user) {
        try {
            user.setLastLoginTime(LocalDateTime.now());
            userMapper.updateById(user);
        } catch (Exception e) {
            log.warn("更新登录时间失败", e);
        }
    }

    /**
     * 构建登录响应
     */
    private LoginVO buildLoginResponse(SysUser user, String accessToken) {
        return LoginVO.builder()
                .token(accessToken)
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .build();
    }

    @Override
    public String refreshToken(HttpServletRequest request, HttpServletResponse response) {
        log.info("开始刷新 Access Token");

        // 1. 获取并验证 Refresh Token
        String refreshToken = getRefreshTokenFromCookie(request);
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new BusinessException("Refresh Token 不存在，请重新登录");
        }

        // 2. 验证 Token 并获取用户ID
        Long userId = RefreshTokenUtil.getLoginIdByToken(refreshToken);
        if (userId == null) {
            clearRefreshTokenCookie(response);
            throw new BusinessException("Refresh Token 无效或已过期，请重新登录");
        }

        // 3. 验证用户状态
        validateUserStatus(userId, response);

        // 4. 生成新的 Access Token
        return generateNewAccessToken(userId);
    }

    /**
     * 验证用户状态
     */
    private void validateUserStatus(Long userId, HttpServletResponse response) {
        SysUser user = userMapper.selectById(userId);
        if (user == null) {
            clearRefreshTokenCookie(response);
            throw new BusinessException("用户不存在");
        }

        if (user.getStatus() == 0) {
            clearRefreshTokenCookie(response);
            throw new BusinessException("账号已被停用，请联系管理员");
        }
    }

    /**
     * 生成新的 Access Token
     */
    private String generateNewAccessToken(Long userId) {
        try {
            // 先登出旧的 Access Token（如果存在）
            try {
                StpUtil.logout(userId);
            } catch (Exception ignored) {
                // 忽略异常，可能没有旧的 token
            }

            StpUtil.login(userId);
            log.info("Access Token 刷新成功，用户ID: {}", userId);
            return StpUtil.getTokenValue();
        } catch (Exception e) {
            log.error("生成新 Access Token 失败", e);
            throw new BusinessException("刷新 Token 失败: " + e.getMessage());
        }
    }

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response) {
        // 获取用户ID（优先从 Access Token，其次从 Refresh Token）
        Long userId = getUserIdForLogout(request);

        // 清除 Access Token
        try {
            StpUtil.logout();
        } catch (Exception e) {
            log.warn("清除 Access Token 失败: {}", e.getMessage());
        }

        // 清除 Refresh Token
        String refreshToken = getRefreshTokenFromCookie(request);
        if (refreshToken != null) {
            RefreshTokenUtil.logout(refreshToken);
        }

        // 清除 Refresh Token Cookie
        clearRefreshTokenCookie(response);

        // 更新用户在线状态
        if (userId != null) {
            userOnlineService.userOffline(userId);
        }

        log.info("用户登出成功，用户ID: {}", userId);
    }

    /**
     * 获取用户ID用于登出（优先从 Access Token，其次从 Refresh Token）
     */
    private Long getUserIdForLogout(HttpServletRequest request) {
        try {
            return StpUtil.getLoginIdAsLong();
        } catch (Exception e) {
            log.debug("无法从 Access Token 获取用户ID，尝试从 Refresh Token 获取");
            String refreshToken = getRefreshTokenFromCookie(request);
            return refreshToken != null ? RefreshTokenUtil.getLoginIdByToken(refreshToken) : null;
        }
    }


    @Override
    public UserInfoVO getCurrentUserInfo() {
        // 1. 获取当前登录用户ID
        Long userId = StpUtil.getLoginIdAsLong();

        // 2. 查询用户信息
        SysUser user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 3. 查询用户角色
        List<String> roles = roleMapper.selectRoleCodesByUserId(userId);

        // 4. 查询用户权限
        List<String> permissions = menuMapper.selectPermissionsByUserId(userId);

        // 5. 构建返回数据
        return UserInfoVO.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .email(user.getEmail())
                .phone(user.getPhone())
                .manageScope(user.getManageScope())
                .roles(roles)
                .permissions(permissions)
                .build();
    }

    /**
     * 设置 Refresh Token Cookie
     *
     * @param response HTTP响应
     * @param refreshToken Refresh Token 值
     */
    private void setRefreshTokenCookie(HttpServletResponse response, String refreshToken) {
        String cookieHeader = buildCookieHeader(refreshToken, REFRESH_TOKEN_COOKIE_MAX_AGE);
        response.setHeader("Set-Cookie", cookieHeader);
        log.info("设置 Refresh Token Cookie: {} (Max-Age={}, SameSite={})",
                REFRESH_TOKEN_COOKIE_NAME, REFRESH_TOKEN_COOKIE_MAX_AGE,
                isProdEnvironment() ? "Strict" : "Lax");
    }

    /**
     * 从 Cookie 中获取 Refresh Token
     *
     * @param request HTTP请求
     * @return Refresh Token 值，如果不存在返回 null
     */
    private String getRefreshTokenFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REFRESH_TOKEN_COOKIE_NAME.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * 清除 Refresh Token Cookie
     *
     * @param response HTTP响应
     */
    private void clearRefreshTokenCookie(HttpServletResponse response) {
        String cookieHeader = buildCookieHeader("", 0);
        response.setHeader("Set-Cookie", cookieHeader);
        log.debug("清除 Refresh Token Cookie: {}", REFRESH_TOKEN_COOKIE_NAME);
    }

    /**
     * 构建 Cookie Header 字符串
     *
     * @param value Cookie 值
     * @param maxAge Cookie 有效期（秒）
     * @return Cookie Header 字符串
     */
    private String buildCookieHeader(String value, int maxAge) {
        return String.format("%s=%s; Path=/api; Max-Age=%d; HttpOnly; SameSite=%s%s",
                REFRESH_TOKEN_COOKIE_NAME,
                value,
                maxAge,
                isProdEnvironment() ? "Strict" : "Lax",
                isProdEnvironment() ? "; Secure" : "");
    }

    /**
     * 判断是否为生产环境
     */
    private boolean isProdEnvironment() {
        return "prod".equals(activeProfile);
    }
}

