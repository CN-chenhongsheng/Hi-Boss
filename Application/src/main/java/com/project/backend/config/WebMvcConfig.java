package com.project.backend.config;

import com.project.backend.config.interceptor.AuthInterceptor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web MVC 配置
 * 注册拦截器
 *
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/**") // 拦截所有路径
                .excludePathPatterns(
                        "/v1/auth/login",          // 管理员/宿管员登录接口
                        "/v1/auth/student/login",  // 学生登录接口
                        "/v1/auth/wx-login",       // 微信登录接口
                        "/v1/auth/refresh",        // Token刷新接口
                        "/v1/auth/logout",         // 登出接口（虽然可能需要token，但让拦截器内部处理）
                        "/doc.html",               // Swagger 文档
                        "/webjars/**",             // Swagger 静态资源
                        "/swagger-resources/**",   // Swagger 资源
                        "/v3/api-docs/**",         // Swagger API 文档
                        "/favicon.ico",            // 网站图标
                        "/error"                   // 错误页面
                );
    }
}
