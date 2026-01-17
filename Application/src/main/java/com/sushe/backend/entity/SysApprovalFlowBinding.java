package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 审批流程绑定表
 * 
 * @author 系统生成
 * @since 2026-01-17
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_approval_flow_binding")
@Schema(description = "审批流程绑定实体")
public class SysApprovalFlowBinding extends BaseEntity {

    @Schema(description = "业务类型(check_in/transfer/check_out/stay)")
    @TableField("business_type")
    private String businessType;

    @Schema(description = "绑定的流程ID")
    @TableField("flow_id")
    private Long flowId;

    @Schema(description = "状态：0停用 1启用")
    @TableField("status")
    private Integer status;

    @Schema(description = "备注")
    @TableField("remark")
    private String remark;
}
