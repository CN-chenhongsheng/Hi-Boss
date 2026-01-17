package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.entity.SysApprovalFlowBinding;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

/**
 * 审批流程绑定Mapper
 * 
 * @author 系统生成
 * @since 2026-01-17
 */
@Mapper
public interface SysApprovalFlowBindingMapper extends BaseMapper<SysApprovalFlowBinding> {

    /**
     * 根据业务类型查询绑定信息
     *
     * @param businessType 业务类型
     * @return 绑定信息
     */
    @Select("SELECT * FROM sys_approval_flow_binding WHERE business_type = #{businessType} AND status = 1")
    SysApprovalFlowBinding selectByBusinessType(String businessType);

    /**
     * 根据流程ID查询绑定数量
     *
     * @param flowId 流程ID
     * @return 绑定数量
     */
    @Select("SELECT COUNT(*) FROM sys_approval_flow_binding WHERE flow_id = #{flowId}")
    int countByFlowId(Long flowId);
}
