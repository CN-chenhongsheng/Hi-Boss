package com.sushe.backend.service;

import com.sushe.backend.dto.auth.LoginDTO;
import com.sushe.backend.vo.LoginVO;
import com.sushe.backend.vo.UserInfoVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 认证服务接口
 *
 * @author 陈鸿昇
 * @date 2025-12-30
 */
public interface AuthService {

    /**
     * 用户登录
     *
     * @param loginDTO 登录参数
     * @param request HTTP请求
     * @param response HTTP响应
     * @return 登录结果
     */
    LoginVO login(LoginDTO loginDTO, HttpServletRequest request, HttpServletResponse response);

    /**
     * 刷新 Access Token
     *
     * @param request HTTP请求
     * @param response HTTP响应
     * @return 新的 Access Token
     */
    String refreshToken(HttpServletRequest request, HttpServletResponse response);

    /**
     * 用户登出
     *
     * @param request HTTP请求
     * @param response HTTP响应
     */
    void logout(HttpServletRequest request, HttpServletResponse response);

    /**
     * 获取当前登录用户信息
     *
     * @return 用户信息
     */
    UserInfoVO getCurrentUserInfo();
}

