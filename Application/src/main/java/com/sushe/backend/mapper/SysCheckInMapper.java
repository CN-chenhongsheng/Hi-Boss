package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysCheckIn;
import org.apache.ibatis.annotations.Mapper;

/**
 * 入住管理Mapper
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Mapper
public interface SysCheckInMapper extends BaseMapper<SysCheckIn> {
}

