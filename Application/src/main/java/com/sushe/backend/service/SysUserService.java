package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.user.UserQueryDTO;
import com.sushe.backend.dto.user.UserResetPasswordDTO;
import com.sushe.backend.dto.user.UserSaveDTO;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.vo.UserVO;

/**
 * 系统用户Service
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
public interface SysUserService extends IService<SysUser> {

    /**
     * 分页查询用户列表
     * 
     * @param queryDTO 查询条件
     * @return 用户分页列表
     */
    PageResult<UserVO> pageList(UserQueryDTO queryDTO);

    /**
     * 根据ID获取用户详情
     * 
     * @param id 用户ID
     * @return 用户信息
     */
    UserVO getDetailById(Long id);

    /**
     * 保存用户（新增或编辑）
     * 
     * @param saveDTO 用户保存DTO
     * @return 是否成功
     */
    boolean saveUser(UserSaveDTO saveDTO);

    /**
     * 删除用户
     * 
     * @param id 用户ID
     * @return 是否成功
     */
    boolean deleteUser(Long id);

    /**
     * 批量删除用户
     * 
     * @param ids 用户ID列表
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 重置密码
     * 
     * @param resetDTO 重置密码DTO
     * @return 是否成功
     */
    boolean resetPassword(UserResetPasswordDTO resetDTO);

    /**
     * 修改用户状态
     * 
     * @param id 用户ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);

    /**
     * 获取当前用户个人信息
     * 
     * @return 用户详细信息
     */
    UserVO getCurrentUserProfile();

    /**
     * 更新当前用户个人信息
     * 
     * @param profileDTO 个人信息DTO
     * @return 是否成功
     */
    boolean updateCurrentUserProfile(com.sushe.backend.dto.user.UserProfileDTO profileDTO);

    /**
     * 修改当前用户密码
     * 
     * @param changePasswordDTO 修改密码DTO
     * @return 是否成功
     */
    boolean changeCurrentUserPassword(com.sushe.backend.dto.user.ChangePasswordDTO changePasswordDTO);
}

