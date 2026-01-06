package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysUserMenu;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户菜单关联Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-01-06
 */
@Mapper
public interface SysUserMenuMapper extends BaseMapper<SysUserMenu> {
}

