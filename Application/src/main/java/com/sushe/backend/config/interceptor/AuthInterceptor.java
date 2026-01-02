package com.sushe.backend.config.interceptor;

import cn.dev33.satoken.stp.StpUtil;
import com.sushe.backend.common.context.UserContext;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.mapper.SysUserMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 认证拦截器
 * 验证 Token 并将用户信息存入 ThreadLocal
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AuthInterceptor implements HandlerInterceptor {

    private final SysUserMapper userMapper;

    /**
     * 白名单路径（不需要登录验证）
     */
    private static final String[] WHITELIST = {
            "/v1/auth/login",
            "/v1/auth/logout",
            "/doc.html",
            "/webjars",
            "/swagger-resources",
            "/v3/api-docs",
            "/favicon.ico"
    };

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestPath = request.getRequestURI();

        // 检查是否为白名单路径
        if (isWhitelist(requestPath)) {
            return true;
        }

        try {
            // 对于 SSE 请求，EventSource 不支持自定义 headers，需要从 URL 参数读取 token
            // 如果请求头中没有 Authorization，且 URL 参数中有 token，则从 URL 参数读取
            String authHeader = request.getHeader("Authorization");
            String tokenParam = request.getParameter("token");

            if ((authHeader == null || authHeader.isEmpty()) && tokenParam != null && !tokenParam.isEmpty()) {
                // 从 URL 参数读取 token，手动验证
                try {
                    // 使用 token 获取用户 ID（getLoginIdByToken 返回 Object，需要转换）
                    Object loginId = StpUtil.getLoginIdByToken(tokenParam);
                    if (loginId == null) {
                        log.warn("从 URL 参数读取的 token 无效");
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        return false;
                    }
                    Long userId = Long.valueOf(loginId.toString());

                    // 查询用户信息
                    SysUser user = userMapper.selectById(userId);
                    if (user == null) {
                        log.warn("用户不存在，用户ID：{}", userId);
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        return false;
                    }

                    // 检查用户状态
                    if (user.getStatus() == 0) {
                        log.warn("用户已被停用，用户ID：{}", userId);
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return false;
                    }

                    // 将用户信息存入 ThreadLocal
                    UserContext.LoginUser loginUser = new UserContext.LoginUser();
                    loginUser.setUserId(user.getId());
                    loginUser.setUsername(user.getUsername());
                    loginUser.setNickname(user.getNickname());
                    loginUser.setAvatar(user.getAvatar());
                    UserContext.setUser(loginUser);

                    log.debug("用户信息已存入 ThreadLocal（从 URL 参数），用户ID：{}，用户名：{}", userId, user.getUsername());
                    return true;
                } catch (Exception e) {
                    log.warn("从 URL 参数读取的 token 验证失败：{}", e.getMessage());
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    return false;
                }
            }

            // 正常流程：验证 Token（Sa-Token 会自动从请求头获取 token-name 配置的字段）
            StpUtil.checkLogin();

            // 获取当前登录用户ID
            Long userId = StpUtil.getLoginIdAsLong();

            // 查询用户信息
            SysUser user = userMapper.selectById(userId);
            if (user == null) {
                log.warn("用户不存在，用户ID：{}", userId);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return false;
            }

            // 检查用户状态
            if (user.getStatus() == 0) {
                log.warn("用户已被停用，用户ID：{}", userId);
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return false;
            }

            // 将用户信息存入 ThreadLocal
            UserContext.LoginUser loginUser = new UserContext.LoginUser();
            loginUser.setUserId(user.getId());
            loginUser.setUsername(user.getUsername());
            loginUser.setNickname(user.getNickname());
            loginUser.setAvatar(user.getAvatar());
            UserContext.setUser(loginUser);

            log.debug("用户信息已存入 ThreadLocal，用户ID：{}，用户名：{}", userId, user.getUsername());
            return true;
        } catch (Exception e) {
            log.warn("Token 验证失败：{}", e.getMessage());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 请求完成后清理 ThreadLocal，防止内存泄漏
        UserContext.clear();
    }

    /**
     * 检查路径是否在白名单中
     */
    private boolean isWhitelist(String path) {
        for (String whitePath : WHITELIST) {
            if (path.startsWith(whitePath)) {
                return true;
            }
        }
        return false;
    }
}

