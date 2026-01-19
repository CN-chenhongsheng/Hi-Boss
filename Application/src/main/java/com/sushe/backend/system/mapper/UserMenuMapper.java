package com.sushe.backend.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.system.entity.UserMenu;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户菜单关联Mapper
 * 
 * @author 陈鸿昇
 * @since 2026-01-01
 */
@Mapper
public interface UserMenuMapper extends BaseMapper<UserMenu> {
}
