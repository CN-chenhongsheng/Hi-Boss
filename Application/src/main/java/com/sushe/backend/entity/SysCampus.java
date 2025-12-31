package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 校区实体
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Data
@TableName("sys_campus")
@Schema(description = "校区实体")
public class SysCampus implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "校区编码")
    @TableField("campus_code")
    private String campusCode;

    @Schema(description = "校区名称")
    @TableField("campus_name")
    private String campusName;

    @Schema(description = "上级校区编码")
    @TableField("parent_code")
    private String parentCode;

    @Schema(description = "校区地址")
    @TableField("address")
    private String address;

    @Schema(description = "负责人")
    @TableField("manager")
    private String manager;

    @Schema(description = "状态：1启用 0停用")
    @TableField("status")
    private Integer status;

    @Schema(description = "排序序号")
    @TableField("sort")
    private Integer sort;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}

