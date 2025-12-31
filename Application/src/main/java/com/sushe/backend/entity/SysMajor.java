package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 专业实体
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Data
@TableName("sys_major")
@Schema(description = "专业实体")
public class SysMajor implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "专业编码")
    @TableField("major_code")
    private String majorCode;

    @Schema(description = "专业名称")
    @TableField("major_name")
    private String majorName;

    @Schema(description = "所属院系编码")
    @TableField("dept_code")
    private String deptCode;

    @Schema(description = "专业负责人")
    @TableField("director")
    private String director;

    @Schema(description = "学制")
    @TableField("duration")
    private String duration;

    @Schema(description = "培养目标")
    @TableField("goal")
    private String goal;

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

