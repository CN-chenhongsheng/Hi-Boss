package com.sushe.backend.controller;

import com.sushe.backend.common.annotation.RateLimit;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.auth.LoginDTO;
import com.sushe.backend.service.AuthService;
import com.sushe.backend.vo.LoginVO;
import com.sushe.backend.vo.UserInfoVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 *
 * @author 陈鸿昇
 * @date 2025-12-30
 */
@Slf4j
@Tag(name = "认证管理", description = "登录、登出、获取用户信息")
@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * 用户登录
     */
    @Operation(summary = "用户登录")
    @PostMapping("/login")
    @RateLimit(key = "login", time = 60, count = 5, message = "登录请求过于频繁，请稍后再试")
    public R<LoginVO> login(@Valid @RequestBody LoginDTO loginDTO,
                            HttpServletRequest request,
                            HttpServletResponse response) {
        log.info("========== 收到登录请求 ==========");
        log.info("请求参数 - 用户名: {}", loginDTO.getUsername());
        log.info("请求参数 - 密码: {}", loginDTO.getPassword() != null ? "***" : "null");

        try {
            log.info("开始调用 authService.login()");
            LoginVO loginVO = authService.login(loginDTO, request, response);
            log.info("登录成功，返回Access Token: {}", loginVO.getToken());
            log.info("========== 登录请求处理完成 ==========");
            return R.ok(loginVO);
        } catch (Exception e) {
            log.error("========== 登录请求异常 ==========");
            log.error("异常类型: {}", e.getClass().getName());
            log.error("异常消息: {}", e.getMessage());
            log.error("异常堆栈: ", e);
            log.error("====================================");
            throw e;
        }
    }

    /**
     * 刷新 Access Token
     */
    @Operation(summary = "刷新Access Token")
    @PostMapping("/refresh")
    public R<String> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        log.info("========== 收到Token刷新请求 ==========");
        try {
            String newAccessToken = authService.refreshToken(request, response);
            log.info("Token刷新成功");
            log.info("========== Token刷新请求处理完成 ==========");
            return R.ok(newAccessToken);
        } catch (Exception e) {
            log.error("========== Token刷新请求异常 ==========");
            log.error("异常类型: {}", e.getClass().getName());
            log.error("异常消息: {}", e.getMessage());
            log.error("异常堆栈: ", e);
            log.error("====================================");
            throw e;
        }
    }

    /**
     * 用户登出
     */
    @Operation(summary = "用户登出")
    @PostMapping("/logout")
    public R<Void> logout(HttpServletRequest request, HttpServletResponse response) {
        authService.logout(request, response);
        return R.ok();
    }

    /**
     * 获取当前登录用户信息
     */
    @Operation(summary = "获取当前用户信息")
    @GetMapping("/userinfo")
    public R<UserInfoVO> getUserInfo() {
        UserInfoVO userInfo = authService.getCurrentUserInfo();
        return R.ok(userInfo);
    }
}

