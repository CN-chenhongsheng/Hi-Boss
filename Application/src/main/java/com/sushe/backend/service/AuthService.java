package com.sushe.backend.service;

import com.sushe.backend.dto.auth.LoginDTO;
import com.sushe.backend.vo.LoginVO;
import com.sushe.backend.vo.UserInfoVO;

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
     * @return 登录结果
     */
    LoginVO login(LoginDTO loginDTO);

    /**
     * 用户登出
     */
    void logout();

    /**
     * 获取当前登录用户信息
     *
     * @return 用户信息
     */
    UserInfoVO getCurrentUserInfo();
}

