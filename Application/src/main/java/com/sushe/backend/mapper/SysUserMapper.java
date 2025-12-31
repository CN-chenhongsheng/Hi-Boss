package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 系统用户Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {
}

