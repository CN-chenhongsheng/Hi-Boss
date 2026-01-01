package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.context.UserContext;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.user.ChangePasswordDTO;
import com.sushe.backend.dto.user.RoleUserQueryDTO;
import com.sushe.backend.dto.user.UserProfileDTO;
import com.sushe.backend.dto.user.UserQueryDTO;
import com.sushe.backend.dto.user.UserResetPasswordDTO;
import com.sushe.backend.dto.user.UserSaveDTO;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.entity.SysUserRole;
import com.sushe.backend.entity.SysRole;
import com.sushe.backend.mapper.SysRoleMapper;
import com.sushe.backend.mapper.SysUserMapper;
import com.sushe.backend.mapper.SysUserRoleMapper;
import com.sushe.backend.service.SysUserService;
import com.sushe.backend.util.BusinessRuleUtils;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.UserSimpleVO;
import com.sushe.backend.vo.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 系统用户Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    private final SysUserRoleMapper userRoleMapper;
    private final SysRoleMapper roleMapper;

    /**
     * 分页查询用户列表
     */
    @Override
    public PageResult<UserVO> pageList(UserQueryDTO queryDTO) {
        // 构建查询条件
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getUsername()), SysUser::getUsername, queryDTO.getUsername())
               .like(StrUtil.isNotBlank(queryDTO.getNickname()), SysUser::getNickname, queryDTO.getNickname())
               .like(StrUtil.isNotBlank(queryDTO.getPhone()), SysUser::getPhone, queryDTO.getPhone())
               .eq(StrUtil.isNotBlank(queryDTO.getCollege()), SysUser::getCollege, queryDTO.getCollege())
               .eq(queryDTO.getStatus() != null, SysUser::getStatus, queryDTO.getStatus())
               .orderByDesc(SysUser::getCreateTime);

        // 分页查询
        Page<SysUser> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        // 转换为VO
        List<UserVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    /**
     * 根据ID获取用户详情
     */
    @Override
    public UserVO getDetailById(Long id) {
        SysUser user = getById(id);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        return convertToVO(user);
    }

    /**
     * 保存用户（新增或编辑）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveUser(UserSaveDTO saveDTO) {
        // 检查用户名是否重复
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getUsername, saveDTO.getUsername());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysUser::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("用户名已存在");
        }

        SysUser user = new SysUser();
        BeanUtil.copyProperties(saveDTO, user);

        // 编辑时，如果是超级管理员，不允许设置为停用
        if (saveDTO.getId() != null) {
            SysUser existingUser = getById(saveDTO.getId());
            if (existingUser != null) {
                BusinessRuleUtils.validateSuperAdminUserStatus(existingUser.getUsername(), saveDTO.getStatus());
            }
        }

        boolean success;
        Long userId;

        if (saveDTO.getId() == null) {
            // 新增用户
            if (StrUtil.isBlank(saveDTO.getPassword())) {
                throw new BusinessException("新增用户时密码不能为空");
            }
            // 密码加密
            user.setPassword(BCrypt.hashpw(saveDTO.getPassword()));
            user.setStatus(1); // 默认启用
            success = save(user);
            userId = user.getId();
        } else {
            // 编辑用户
            userId = saveDTO.getId();
            // 如果传了密码，则加密更新
            if (StrUtil.isNotBlank(saveDTO.getPassword())) {
                user.setPassword(BCrypt.hashpw(saveDTO.getPassword()));
            } else {
                // 不更新密码
                user.setPassword(null);
            }
            success = updateById(user);
        }

        // 保存用户角色关联
        if (success && saveDTO.getRoleIds() != null) {
            saveUserRoles(userId, saveDTO.getRoleIds());
        }

        return success;
    }

    /**
     * 保存用户角色关联
     */
    private void saveUserRoles(Long userId, Long[] roleIds) {
        // 1. 删除用户原有的角色关联
        LambdaQueryWrapper<SysUserRole> deleteWrapper = new LambdaQueryWrapper<>();
        deleteWrapper.eq(SysUserRole::getUserId, userId);
        userRoleMapper.delete(deleteWrapper);

        // 2. 批量插入新的角色关联
        if (roleIds != null && roleIds.length > 0) {
            for (Long roleId : roleIds) {
                SysUserRole userRole = new SysUserRole();
                userRole.setUserId(userId);
                userRole.setRoleId(roleId);
                userRoleMapper.insert(userRole);
            }
        }
    }

    /**
     * 删除用户
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteUser(Long id) {
        if (id == null) {
            throw new BusinessException("用户ID不能为空");
        }

        // 检查是否可以删除
        validateUserDeletion(id);

        // 删除用户角色关联
        LambdaQueryWrapper<SysUserRole> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUserRole::getUserId, id);
        userRoleMapper.delete(wrapper);

        // 删除用户
        return removeById(id);
    }

    /**
     * 批量删除用户
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("用户ID不能为空");
        }

        // 逐个检查是否可以删除
        for (Long id : ids) {
            validateUserDeletion(id);
        }

        // 批量删除用户角色关联
        LambdaQueryWrapper<SysUserRole> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(SysUserRole::getUserId, Arrays.asList(ids));
        userRoleMapper.delete(wrapper);

        // 批量删除用户
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 验证用户是否可以删除
     *
     * @param userId 用户ID
     */
    private void validateUserDeletion(Long userId) {
        // 1. 检查用户是否存在
        SysUser user = getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 2. 使用通用工具类验证业务规则（超级管理员、不能删除自己等）
        BusinessRuleUtils.validateUserDeletion(userId, user.getUsername());

        // 3. 可以根据需要添加更多业务规则
        // 例如：检查用户是否有关联的业务数据等
    }

    /**
     * 重置密码
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean resetPassword(UserResetPasswordDTO resetDTO) {
        SysUser user = getById(resetDTO.getUserId());
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 加密新密码
        user.setPassword(BCrypt.hashpw(resetDTO.getNewPassword()));
        return updateById(user);
    }

    /**
     * 修改用户状态
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysUser user = getById(id);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 使用通用工具类验证超级管理员用户状态
        BusinessRuleUtils.validateSuperAdminUserStatus(user.getUsername(), status);

        user.setStatus(status);
        return updateById(user);
    }

    /**
     * 实体转VO
     */
    private UserVO convertToVO(SysUser user) {
        UserVO vo = new UserVO();
        BeanUtil.copyProperties(user, vo);

        // 状态文本（使用字典）
        vo.setStatusText(DictUtils.getLabel("sys_user_status", user.getStatus(), "未知"));

        // 性别文本（使用字典）
        vo.setGenderText(DictUtils.getLabel("sys_user_sex", user.getGender(), "未知"));

        // 查询用户角色信息
        vo.setRoleIds(roleMapper.selectRoleIdsByUserId(user.getId()));
        vo.setRoleNames(roleMapper.selectRoleNamesByUserId(user.getId()));

        return vo;
    }

    /**
     * 获取当前用户个人信息
     */
    @Override
    public UserVO getCurrentUserProfile() {
        Long userId = UserContext.getUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }
        return getDetailById(userId);
    }

    /**
     * 更新当前用户个人信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateCurrentUserProfile(UserProfileDTO profileDTO) {
        Long userId = UserContext.getUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        SysUser user = getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 只更新允许用户自己修改的字段
        if (StrUtil.isNotBlank(profileDTO.getNickname())) {
            user.setNickname(profileDTO.getNickname());
        }
        if (profileDTO.getAvatar() != null) {
            user.setAvatar(profileDTO.getAvatar());
        }
        if (profileDTO.getEmail() != null) {
            user.setEmail(profileDTO.getEmail());
        }
        if (profileDTO.getPhone() != null) {
            user.setPhone(profileDTO.getPhone());
        }
        if (profileDTO.getGender() != null) {
            user.setGender(profileDTO.getGender());
        }
        if (profileDTO.getAddress() != null) {
            user.setAddress(profileDTO.getAddress());
        }
        if (profileDTO.getIntroduction() != null) {
            user.setIntroduction(profileDTO.getIntroduction());
        }

        return updateById(user);
    }

    /**
     * 修改当前用户密码
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean changeCurrentUserPassword(ChangePasswordDTO changePasswordDTO) {
        Long userId = UserContext.getUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        // 验证新密码和确认密码是否一致
        if (!changePasswordDTO.getNewPassword().equals(changePasswordDTO.getConfirmPassword())) {
            throw new BusinessException("新密码和确认密码不一致");
        }

        SysUser user = getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 验证旧密码是否正确
        if (!BCrypt.checkpw(changePasswordDTO.getOldPassword(), user.getPassword())) {
            throw new BusinessException("当前密码错误");
        }

        // 更新密码
        user.setPassword(BCrypt.hashpw(changePasswordDTO.getNewPassword()));
        return updateById(user);
    }

    /**
     * 根据角色代码列表查询用户列表
     */
    @Override
    public Map<String, List<UserSimpleVO>> getUsersByRoleCodes(RoleUserQueryDTO queryDTO) {
        Map<String, List<UserSimpleVO>> result = new HashMap<>();
        
        if (queryDTO == null || queryDTO.getRoleCodes() == null || queryDTO.getRoleCodes().isEmpty()) {
            return result;
        }

        // 查询所有指定角色的用户
        List<SysUserMapper.UserWithRoleCode> userWithRoleCodes = baseMapper.selectUsersByRoleCodes(queryDTO.getRoleCodes());

        // 按角色代码分组
        Map<String, List<SysUserMapper.UserWithRoleCode>> userGroupByRole = userWithRoleCodes.stream()
                .collect(Collectors.groupingBy(SysUserMapper.UserWithRoleCode::getRoleCode));

        // 构建返回结果，key为角色代码，value为用户列表
        for (String roleCode : queryDTO.getRoleCodes()) {
            List<SysUserMapper.UserWithRoleCode> users = userGroupByRole.get(roleCode);
            if (users != null && !users.isEmpty()) {
                List<UserSimpleVO> userList = users.stream().map(userWithRole -> {
                    UserSimpleVO userVO = new UserSimpleVO();
                    userVO.setId(userWithRole.getId());
                    userVO.setUsername(userWithRole.getUsername());
                    userVO.setNickname(userWithRole.getNickname());
                    userVO.setPhone(userWithRole.getPhone());
                    userVO.setEmail(userWithRole.getEmail());
                    return userVO;
                }).collect(Collectors.toList());
                result.put(roleCode, userList);
            } else {
                // 如果角色没有用户，返回空数组
                result.put(roleCode, List.of());
            }
        }

        return result;
    }
}

