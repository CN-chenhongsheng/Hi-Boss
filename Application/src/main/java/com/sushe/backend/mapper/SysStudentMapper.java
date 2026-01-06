package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysStudent;
import org.apache.ibatis.annotations.Mapper;

/**
 * 学生Mapper
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Mapper
public interface SysStudentMapper extends BaseMapper<SysStudent> {
}

