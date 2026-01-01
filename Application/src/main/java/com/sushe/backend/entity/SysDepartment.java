package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 院系实体
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Data
@TableName("sys_department")
@Schema(description = "院系实体")
public class SysDepartment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "院系编码")
    @TableField("dept_code")
    private String deptCode;

    @Schema(description = "院系名称")
    @TableField("dept_name")
    private String deptName;

    @Schema(description = "所属校区编码")
    @TableField("campus_code")
    private String campusCode;

    @Schema(description = "上级院系编码")
    @TableField("parent_code")
    private String parentCode;

    @Schema(description = "院系领导")
    @TableField("leader")
    private String leader;

    @Schema(description = "联系电话")
    @TableField("phone")
    private String phone;

    @Schema(description = "排序")
    @TableField("sort")
    private Integer sort;

    @Schema(description = "状态：1启用 0停用")
    @TableField("status")
    private Integer status;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}

