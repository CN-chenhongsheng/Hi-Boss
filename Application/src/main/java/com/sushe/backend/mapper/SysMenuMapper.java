package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 系统菜单Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Mapper
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    /**
     * 根据用户ID查询权限标识列表
     *
     * @param userId 用户ID
     * @return 权限标识列表
     */
    @Select("SELECT DISTINCT m.permission FROM sys_menu m " +
            "INNER JOIN sys_role_menu rm ON m.id = rm.menu_id " +
            "INNER JOIN sys_user_role ur ON rm.role_id = ur.role_id " +
            "WHERE ur.user_id = #{userId} AND m.status = 1 AND m.permission IS NOT NULL AND m.permission != ''")
    List<String> selectPermissionsByUserId(Long userId);

    /**
     * 根据用户ID查询该用户有权限的菜单列表（包含目录、菜单和按钮）
     * 返回所有正常状态的菜单（包括 visible=0 的隐藏菜单和按钮权限）
     * 前端会根据 visible 字段决定是否显示在菜单中，按钮权限用于权限控制
     *
     * @param userId 用户ID
     * @return 菜单列表
     */
    @Select("SELECT DISTINCT m.* FROM sys_menu m " +
            "INNER JOIN sys_role_menu rm ON m.id = rm.menu_id " +
            "INNER JOIN sys_user_role ur ON rm.role_id = ur.role_id " +
            "WHERE ur.user_id = #{userId} AND m.status = 1 " +
            "ORDER BY m.sort ASC, m.id ASC")
    List<SysMenu> selectMenusByUserId(Long userId);
}

