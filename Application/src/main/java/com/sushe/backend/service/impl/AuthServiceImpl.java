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
import com.sushe.backend.vo.LoginVO;
import com.sushe.backend.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

    @Override
    public LoginVO login(LoginDTO loginDTO) {
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
        try {
            StpUtil.login(user.getId());
            userOnlineService.userOnline(user.getId());
            String token = StpUtil.getTokenValue();
            log.info(">>> 步骤4完成: Sa-Token登录成功，token: {}", token);
        } catch (Exception e) {
            log.error(">>> 步骤4异常: Sa-Token登录失败", e);
            throw new BusinessException("登录失败: " + e.getMessage());
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
        // 6. 返回登录信息
        try {
            LoginVO loginVO = LoginVO.builder()
                    .token(StpUtil.getTokenValue())
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
    public void logout() {
        Long userId = StpUtil.getLoginIdAsLong();
        StpUtil.logout();
        userOnlineService.userOffline(userId);
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
}

