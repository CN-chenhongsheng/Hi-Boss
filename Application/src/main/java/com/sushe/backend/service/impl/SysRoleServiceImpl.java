package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.role.RoleQueryDTO;
import com.sushe.backend.dto.role.RoleSaveDTO;
import com.sushe.backend.entity.SysMenu;
import com.sushe.backend.entity.SysRole;
import com.sushe.backend.entity.SysRoleMenu;
import com.sushe.backend.entity.SysUserRole;
import com.sushe.backend.mapper.SysMenuMapper;
import com.sushe.backend.mapper.SysRoleMapper;
import com.sushe.backend.mapper.SysRoleMenuMapper;
import com.sushe.backend.mapper.SysUserRoleMapper;
import com.sushe.backend.service.SysRoleService;
import com.sushe.backend.util.BusinessRuleUtils;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.RolePermissionVO;
import com.sushe.backend.vo.RoleVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 系统角色Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysRoleServiceImpl extends ServiceImpl<SysRoleMapper, SysRole> implements SysRoleService {

    private final SysRoleMenuMapper roleMenuMapper;
    private final SysMenuMapper menuMapper;
    private final SysUserRoleMapper userRoleMapper;

    /**
     * 分页查询角色列表
     */
    @Override
    public PageResult<RoleVO> pageList(RoleQueryDTO queryDTO) {
        // 构建查询条件
        LambdaQueryWrapper<SysRole> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getRoleCode()), SysRole::getRoleCode, queryDTO.getRoleCode())
               .like(StrUtil.isNotBlank(queryDTO.getRoleName()), SysRole::getRoleName, queryDTO.getRoleName())
               .eq(queryDTO.getStatus() != null, SysRole::getStatus, queryDTO.getStatus())
               .orderByAsc(SysRole::getSort)
               .orderByDesc(SysRole::getCreateTime);

        // 分页查询
        Page<SysRole> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        // 转换为VO
        List<RoleVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    /**
     * 查询所有角色列表（不分页）
     */
    @Override
    public List<RoleVO> listAll() {
        LambdaQueryWrapper<SysRole> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysRole::getStatus, 1) // 只查询正常状态的角色
               .orderByAsc(SysRole::getSort)
               .orderByDesc(SysRole::getCreateTime);

        return list(wrapper).stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    /**
     * 根据ID获取角色详情
     */
    @Override
    public RoleVO getDetailById(Long id) {
        SysRole role = getById(id);
        if (role == null) {
            throw new BusinessException("角色不存在");
        }
        RoleVO vo = convertToVO(role);

        // 查询角色的菜单权限
        vo.setMenuIds(getRoleMenuIds(id));

        return vo;
    }

    /**
     * 保存角色（新增或编辑）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveRole(RoleSaveDTO saveDTO) {
        // 检查角色编码是否重复
        LambdaQueryWrapper<SysRole> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysRole::getRoleCode, saveDTO.getRoleCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysRole::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("角色编码已存在");
        }

        SysRole role = new SysRole();
        BeanUtil.copyProperties(saveDTO, role);

        // 编辑时，如果是超级管理员，不允许设置为停用
        if (saveDTO.getId() != null) {
            SysRole existingRole = getById(saveDTO.getId());
            if (existingRole != null) {
                BusinessRuleUtils.validateSuperAdminRoleStatus(existingRole.getRoleCode(), saveDTO.getStatus());
            }
        }

        boolean success;
        if (saveDTO.getId() == null) {
            // 新增
            role.setStatus(1); // 默认启用
            success = save(role);
        } else {
            // 编辑
            success = updateById(role);
        }

        // TODO: 保存角色菜单关联
        if (success && saveDTO.getMenuIds() != null && saveDTO.getMenuIds().length > 0) {
            assignMenus(role.getId(), saveDTO.getMenuIds());
        }

        return success;
    }

    /**
     * 删除角色
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteRole(Long id) {
        if (id == null) {
            throw new BusinessException("角色ID不能为空");
        }

        SysRole role = getById(id);
        if (role == null) {
            throw new BusinessException("角色不存在");
        }

        // 不能删除超级管理员角色
        BusinessRuleUtils.validateNotSuperAdminRole(role.getRoleCode(), "不能删除超级管理员角色");

        // 删除用户角色关联
        LambdaQueryWrapper<SysUserRole> userRoleWrapper = new LambdaQueryWrapper<>();
        userRoleWrapper.eq(SysUserRole::getRoleId, id);
        int deletedUserRoles = userRoleMapper.delete(userRoleWrapper);
        log.info("删除角色时，清理用户角色关联 {} 条", deletedUserRoles);

        // 删除角色菜单关联
        LambdaQueryWrapper<SysRoleMenu> roleMenuWrapper = new LambdaQueryWrapper<>();
        roleMenuWrapper.eq(SysRoleMenu::getRoleId, id);
        roleMenuMapper.delete(roleMenuWrapper);

        return removeById(id);
    }

    /**
     * 批量删除角色
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("角色ID不能为空");
        }

        // 检查是否包含超级管理员角色
        for (Long id : ids) {
            SysRole role = getById(id);
            if (role != null) {
                BusinessRuleUtils.validateNotSuperAdminRole(role.getRoleCode(), "不能删除超级管理员角色");
            }
        }

        // 批量删除用户角色关联
        LambdaQueryWrapper<SysUserRole> userRoleWrapper = new LambdaQueryWrapper<>();
        userRoleWrapper.in(SysUserRole::getRoleId, Arrays.asList(ids));
        int deletedUserRoles = userRoleMapper.delete(userRoleWrapper);
        log.info("批量删除角色时，清理用户角色关联 {} 条", deletedUserRoles);

        // 批量删除角色菜单关联
        LambdaQueryWrapper<SysRoleMenu> roleMenuWrapper = new LambdaQueryWrapper<>();
        roleMenuWrapper.in(SysRoleMenu::getRoleId, Arrays.asList(ids));
        roleMenuMapper.delete(roleMenuWrapper);

        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 分配角色菜单权限
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean assignMenus(Long roleId, Long[] menuIds) {
        log.info("分配角色菜单权限，角色ID：{}，菜单IDs：{}", roleId, Arrays.toString(menuIds));

        if (roleId == null) {
            throw new BusinessException("角色ID不能为空");
        }

        // 1. 删除角色原有的菜单权限
        LambdaQueryWrapper<SysRoleMenu> deleteWrapper = new LambdaQueryWrapper<>();
        deleteWrapper.eq(SysRoleMenu::getRoleId, roleId);
        roleMenuMapper.delete(deleteWrapper);

        // 2. 批量插入新的菜单权限
        if (menuIds != null && menuIds.length > 0) {
            for (Long menuId : menuIds) {
                SysRoleMenu roleMenu = new SysRoleMenu();
                roleMenu.setRoleId(roleId);
                roleMenu.setMenuId(menuId);
                roleMenuMapper.insert(roleMenu);
            }
        }

        return true;
    }

    /**
     * 获取角色的菜单ID列表
     */
    @Override
    public List<Long> getRoleMenuIds(Long roleId) {
        if (roleId == null) {
            return List.of();
        }

        LambdaQueryWrapper<SysRoleMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysRoleMenu::getRoleId, roleId);

        List<SysRoleMenu> roleMenus = roleMenuMapper.selectList(wrapper);

        return roleMenus.stream()
                .map(SysRoleMenu::getMenuId)
                .collect(Collectors.toList());
    }

    /**
     * 获取角色的菜单权限列表（包含菜单状态）
     */
    public List<RolePermissionVO> getRolePermissions(Long roleId) {
        if (roleId == null) {
            return List.of();
        }

        // 查询角色关联的菜单
        LambdaQueryWrapper<SysRoleMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysRoleMenu::getRoleId, roleId);
        List<SysRoleMenu> roleMenus = roleMenuMapper.selectList(wrapper);

        if (roleMenus.isEmpty()) {
            return List.of();
        }

        // 批量查询菜单状态
        List<Long> menuIds = roleMenus.stream()
                .map(SysRoleMenu::getMenuId)
                .collect(Collectors.toList());

        LambdaQueryWrapper<SysMenu> menuWrapper = new LambdaQueryWrapper<>();
        menuWrapper.in(SysMenu::getId, menuIds);
        List<SysMenu> menus = menuMapper.selectList(menuWrapper);

        // 构建菜单ID到状态的映射
        java.util.Map<Long, Integer> menuStatusMap = menus.stream()
                .collect(Collectors.toMap(SysMenu::getId, SysMenu::getStatus, (v1, v2) -> v1));

        // 构建返回结果
        return roleMenus.stream()
                .map(roleMenu -> {
                    RolePermissionVO vo = new RolePermissionVO();
                    vo.setMenuId(roleMenu.getMenuId());
                    // 如果菜单已被删除，状态设为0（停用）
                    vo.setStatus(menuStatusMap.getOrDefault(roleMenu.getMenuId(), 0));
                    return vo;
                })
                .collect(Collectors.toList());
    }

    /**
     * 更新角色状态
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysRole role = getById(id);
        if (role == null) {
            throw new BusinessException("角色不存在");
        }

        // 使用通用工具类验证超级管理员角色状态
        BusinessRuleUtils.validateSuperAdminRoleStatus(role.getRoleCode(), status);

        // 如果是停用角色，删除所有用户与该角色的关联
        if (status != null && status == 0) {
            LambdaQueryWrapper<SysUserRole> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysUserRole::getRoleId, id);
            int deletedCount = userRoleMapper.delete(wrapper);
            log.info("角色停用，已清理 {} 条用户角色关联", deletedCount);
        }

        role.setStatus(status);
        return updateById(role);
    }

    /**
     * 实体转VO
     */
    private RoleVO convertToVO(SysRole role) {
        RoleVO vo = new RoleVO();
        BeanUtil.copyProperties(role, vo);

        // 状态文本（使用字典）
        vo.setStatusText(DictUtils.getLabel("sys_user_status", role.getStatus(), "未知"));

        return vo;
    }
}

