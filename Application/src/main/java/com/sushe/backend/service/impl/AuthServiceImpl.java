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
        log.info(">>> AuthServiceImpl.login() 开始执行");
        log.info(">>> 步骤1: 查询用户，用户名: {}", loginDTO.getUsername());

        // 1. 根据用户名查询用户
        SysUser user = null;
        try {
            user = userMapper.selectOne(
                    new LambdaQueryWrapper<SysUser>()
                            .eq(SysUser::getUsername, loginDTO.getUsername())
            );
            log.info(">>> 步骤1完成: 查询结果 - {}", user != null ? "找到用户" : "用户不存在");
            if (user != null) {
                log.info(">>> 用户信息 - ID: {}, 用户名: {}, 状态: {}", user.getId(), user.getUsername(), user.getStatus());
                log.info(">>> 密码hash前20字符: {}", user.getPassword() != null ? user.getPassword().substring(0, Math.min(20, user.getPassword().length())) : "null");
            }
        } catch (Exception e) {
            log.error(">>> 步骤1异常: 查询用户失败", e);
            throw new BusinessException("查询用户失败: " + e.getMessage());
        }

        if (user == null) {
            log.warn(">>> 用户不存在，抛出异常");
            throw new BusinessException("用户名或密码错误");
        }

        log.info(">>> 步骤2: 验证密码");
        // 2. 验证密码
        try {
            boolean passwordMatches = passwordEncoder.matches(loginDTO.getPassword(), user.getPassword());
            log.info(">>> 步骤2完成: 密码验证结果 - {}", passwordMatches);
            if (!passwordMatches) {
                log.warn(">>> 密码不匹配，抛出异常");
                throw new BusinessException("用户名或密码错误");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error(">>> 步骤2异常: 密码验证失败", e);
            throw new BusinessException("密码验证失败: " + e.getMessage());
        }

        log.info(">>> 步骤3: 检查用户状态");
        // 3. 检查用户状态
        if (user.getStatus() == 0) {
            log.warn(">>> 账号已停用，抛出异常");
            throw new BusinessException("账号已被停用，请联系管理员");
        }

        log.info(">>> 步骤4: 执行Sa-Token登录");
        // 4. 执行登录（Sa-Token）
        String accessToken;
        try {
            StpUtil.login(user.getId());
            userOnlineService.userOnline(user.getId());
            accessToken = StpUtil.getTokenValue();
            log.info(">>> 步骤4完成: Sa-Token登录成功，Access Token: {}", accessToken);
        } catch (Exception e) {
            log.error(">>> 步骤4异常: Sa-Token登录失败", e);
            throw new BusinessException("登录失败: " + e.getMessage());
        }

        log.info(">>> 步骤4.1: 生成Refresh Token");
        // 4.1. 生成 Refresh Token
        String refreshToken;
        try {
            refreshToken = RefreshTokenUtil.login(user.getId());
            log.info(">>> 步骤4.1完成: Refresh Token生成成功");

            // 设置 Refresh Token 到 HttpOnly Cookie
            setRefreshTokenCookie(response, refreshToken);
            log.info(">>> Refresh Token已设置到Cookie");
        } catch (Exception e) {
            log.error(">>> 步骤4.1异常: Refresh Token生成失败", e);
            // Refresh Token 生成失败不影响登录，但记录警告
            log.warn("Refresh Token生成失败，但登录继续");
        }

        log.info(">>> 步骤5: 更新最后登录时间");
        // 5. 更新最后登录时间
        try {
            user.setLastLoginTime(LocalDateTime.now());
            userMapper.updateById(user);
            log.info(">>> 步骤5完成: 最后登录时间已更新");
        } catch (Exception e) {
            log.error(">>> 步骤5异常: 更新登录时间失败", e);
            // 不抛出异常，登录时间更新失败不影响登录
        }

        log.info(">>> 步骤6: 构建返回数据");
        // 6. 返回登录信息（只返回 Access Token，Refresh Token 在 Cookie 中）
        try {
            LoginVO loginVO = LoginVO.builder()
                    .token(accessToken)
                    .userId(user.getId())
                    .username(user.getUsername())
                    .nickname(user.getNickname())
                    .avatar(user.getAvatar())
                    .build();
            log.info(">>> 步骤6完成: 返回数据构建成功");
            log.info(">>> AuthServiceImpl.login() 执行完成");
            return loginVO;
        } catch (Exception e) {
            log.error(">>> 步骤6异常: 构建返回数据失败", e);
            throw new BusinessException("构建返回数据失败: " + e.getMessage());
        }
    }

    @Override
    public String refreshToken(HttpServletRequest request, HttpServletResponse response) {
        log.info(">>> 开始刷新 Access Token");

        // 1. 从 Cookie 中获取 Refresh Token
        String refreshToken = getRefreshTokenFromCookie(request);
        if (refreshToken == null || refreshToken.isEmpty()) {
            log.warn(">>> Refresh Token 不存在于 Cookie 中");
            // 打印所有 Cookie 名称用于调试
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                log.debug(">>> 请求中的 Cookie 列表:");
                for (Cookie cookie : cookies) {
                    log.debug(">>>   - {}: {}", cookie.getName(), cookie.getValue() != null ? "***" : "null");
                }
            } else {
                log.debug(">>> 请求中没有任何 Cookie");
            }
            throw new BusinessException("Refresh Token 不存在，请重新登录");
        }
        log.debug(">>> 从 Cookie 中获取到 Refresh Token: {}", refreshToken.substring(0, Math.min(10, refreshToken.length())) + "...");

        // 2. 验证 Refresh Token 并获取用户ID
        Long userId = RefreshTokenUtil.getLoginIdByToken(refreshToken);
        if (userId == null) {
            log.warn(">>> Refresh Token 无效或已过期");
            // 清除无效的 Cookie
            clearRefreshTokenCookie(response);
            throw new BusinessException("Refresh Token 无效或已过期，请重新登录");
        }

        // 3. 查询用户信息并检查状态
        SysUser user = userMapper.selectById(userId);
        if (user == null) {
            log.warn(">>> 用户不存在，用户ID: {}", userId);
            clearRefreshTokenCookie(response);
            throw new BusinessException("用户不存在");
        }

        if (user.getStatus() == 0) {
            log.warn(">>> 用户已被停用，用户ID: {}", userId);
            clearRefreshTokenCookie(response);
            throw new BusinessException("账号已被停用，请联系管理员");
        }

        // 4. 生成新的 Access Token
        try {
            // 先登出旧的 Access Token（如果存在）
            try {
                StpUtil.logout(userId);
            } catch (Exception e) {
                // 忽略，可能没有旧的 token
            }

            // 生成新的 Access Token
            StpUtil.login(userId);
            String newAccessToken = StpUtil.getTokenValue();

            log.info(">>> Access Token 刷新成功，用户ID: {}", userId);
            return newAccessToken;
        } catch (Exception e) {
            log.error(">>> 生成新 Access Token 失败", e);
            throw new BusinessException("刷新 Token 失败: " + e.getMessage());
        }
    }

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response) {
        Long userId = null;

        // 尝试从 Access Token 获取用户ID
        try {
            userId = StpUtil.getLoginIdAsLong();
        } catch (Exception e) {
            log.debug("无法从 Access Token 获取用户ID，尝试从 Refresh Token 获取");
        }

        // 如果 Access Token 无效，尝试从 Refresh Token 获取用户ID
        if (userId == null) {
            String refreshToken = getRefreshTokenFromCookie(request);
            if (refreshToken != null) {
                userId = RefreshTokenUtil.getLoginIdByToken(refreshToken);
            }
        }

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

        log.info(">>> 用户登出成功，用户ID: {}", userId);
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
        // 使用响应头直接设置 Cookie，这样可以设置 SameSite 属性
        // Jakarta Servlet API 的 Cookie 类不支持直接设置 SameSite
        StringBuilder cookieHeader = new StringBuilder();
        cookieHeader.append(REFRESH_TOKEN_COOKIE_NAME).append("=").append(refreshToken);
        cookieHeader.append("; Path=/api");  // 设置 Cookie 路径为 /api（与 context-path 一致）
        cookieHeader.append("; Max-Age=").append(REFRESH_TOKEN_COOKIE_MAX_AGE);
        cookieHeader.append("; HttpOnly");

        // 开发环境使用 Lax，生产环境使用 Strict
        if ("prod".equals(activeProfile)) {
            cookieHeader.append("; SameSite=Strict");
            cookieHeader.append("; Secure");
        } else {
            cookieHeader.append("; SameSite=Lax");  // 开发环境更宽松
        }

        response.setHeader("Set-Cookie", cookieHeader.toString());
        log.info("设置 Refresh Token Cookie: {} (Path=/api, Max-Age={}, SameSite={})",
                REFRESH_TOKEN_COOKIE_NAME, REFRESH_TOKEN_COOKIE_MAX_AGE,
                "prod".equals(activeProfile) ? "Strict" : "Lax");
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
        // 通过响应头清除 Cookie
        StringBuilder cookieHeader = new StringBuilder();
        cookieHeader.append(REFRESH_TOKEN_COOKIE_NAME).append("=");
        cookieHeader.append("; Path=/api");  // 设置 Cookie 路径为 /api（与 context-path 一致）
        cookieHeader.append("; Max-Age=0");
        cookieHeader.append("; HttpOnly");
        
        // 开发环境使用 Lax，生产环境使用 Strict
        if ("prod".equals(activeProfile)) {
            cookieHeader.append("; SameSite=Strict");
            cookieHeader.append("; Secure");
        } else {
            cookieHeader.append("; SameSite=Lax");  // 开发环境更宽松
        }

        response.setHeader("Set-Cookie", cookieHeader.toString());
        log.debug("清除 Refresh Token Cookie: {}", REFRESH_TOKEN_COOKIE_NAME);
    }
}

