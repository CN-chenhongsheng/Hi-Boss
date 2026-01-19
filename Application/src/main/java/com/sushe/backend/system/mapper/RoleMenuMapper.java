package com.sushe.backend.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.system.entity.RoleMenu;
import org.apache.ibatis.annotations.Mapper;

/**
 * 角色菜单关联Mapper
 * 
 * @author 陈鸿昇
 * @since 2026-01-01
 */
@Mapper
public interface RoleMenuMapper extends BaseMapper<RoleMenu> {
}
