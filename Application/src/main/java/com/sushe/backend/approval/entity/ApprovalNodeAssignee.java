package com.sushe.backend.approval.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 审批节点审批人表
 * 
 * @author 陈鸿昇
 * @since 2026-01-17
 */
@Data
@TableName("sys_approval_node_assignee")
@Schema(description = "审批节点审批人实体")
public class ApprovalNodeAssignee implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "节点ID")
    @TableField("node_id")
    private Long nodeId;

    @Schema(description = "指派类型：1角色 2用户")
    @TableField("assignee_type")
    private Integer assigneeType;

    @Schema(description = "角色ID或用户ID")
    @TableField("assignee_id")
    private Long assigneeId;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "创建人ID")
    @TableField(value = "create_by", fill = FieldFill.INSERT)
    private Long createBy;
}
