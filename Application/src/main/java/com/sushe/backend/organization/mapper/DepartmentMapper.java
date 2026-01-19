package com.sushe.backend.organization.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.organization.entity.Department;
import org.apache.ibatis.annotations.Mapper;

/**
 * 院系Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Mapper
public interface DepartmentMapper extends BaseMapper<Department> {
}
