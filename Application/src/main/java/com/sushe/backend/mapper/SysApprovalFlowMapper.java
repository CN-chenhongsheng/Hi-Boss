package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysApprovalFlow;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 审批流程Mapper
 * 
 * @author 系统生成
 * @since 2026-01-17
 */
@Mapper
public interface SysApprovalFlowMapper extends BaseMapper<SysApprovalFlow> {

    /**
     * 根据业务类型查询启用的流程列表
     *
     * @param businessType 业务类型
     * @return 流程列表
     */
    @Select("SELECT * FROM sys_approval_flow WHERE business_type = #{businessType} AND status = 1 ORDER BY create_time DESC")
    List<SysApprovalFlow> selectByBusinessType(String businessType);

    /**
     * 根据流程编码查询流程
     *
     * @param flowCode 流程编码
     * @return 流程
     */
    @Select("SELECT * FROM sys_approval_flow WHERE flow_code = #{flowCode}")
    SysApprovalFlow selectByFlowCode(String flowCode);
}
