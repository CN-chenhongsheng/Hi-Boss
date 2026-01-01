package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysOperLog;
import org.apache.ibatis.annotations.Mapper;

/**
 * 操作日志Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Mapper
public interface SysOperLogMapper extends BaseMapper<SysOperLog> {
}

