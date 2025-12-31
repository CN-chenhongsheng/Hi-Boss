package com.sushe.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 安全配置类
 * 仅用于密码加密，不包含认证框架
 *
 * @author 陈鸿昇
 * @date 2025-12-30
 */
@Configuration
public class SecurityConfig {

    /**
     * BCrypt密码加密器
     */
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

