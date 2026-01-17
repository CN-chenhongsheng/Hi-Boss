package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysApprovalRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 审批记录Mapper
 * 
 * @author 系统生成
 * @since 2026-01-17
 */
@Mapper
public interface SysApprovalRecordMapper extends BaseMapper<SysApprovalRecord> {

    /**
     * 根据审批实例ID查询审批记录列表
     *
     * @param instanceId 审批实例ID
     * @return 审批记录列表
     */
    @Select("SELECT * FROM sys_approval_record WHERE instance_id = #{instanceId} ORDER BY approve_time ASC")
    List<SysApprovalRecord> selectByInstanceId(Long instanceId);

    /**
     * 查询指定实例、节点的审批记录数量
     *
     * @param instanceId 实例ID
     * @param nodeId 节点ID
     * @return 审批记录数量
     */
    @Select("SELECT COUNT(*) FROM sys_approval_record WHERE instance_id = #{instanceId} AND node_id = #{nodeId}")
    int countByInstanceAndNode(@Param("instanceId") Long instanceId, @Param("nodeId") Long nodeId);

    /**
     * 查询指定实例、节点的通过记录数量
     *
     * @param instanceId 实例ID
     * @param nodeId 节点ID
     * @return 通过记录数量
     */
    @Select("SELECT COUNT(*) FROM sys_approval_record WHERE instance_id = #{instanceId} AND node_id = #{nodeId} AND action = 1")
    int countApprovedByInstanceAndNode(@Param("instanceId") Long instanceId, @Param("nodeId") Long nodeId);

    /**
     * 根据审批人ID查询审批记录列表
     *
     * @param approverId 审批人ID
     * @return 审批记录列表
     */
    @Select("SELECT * FROM sys_approval_record WHERE approver_id = #{approverId} ORDER BY approve_time DESC")
    List<SysApprovalRecord> selectByApproverId(Long approverId);
}
