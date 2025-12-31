package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 班级实体
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Data
@TableName("sys_class")
@Schema(description = "班级实体")
public class SysClass implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "班级编码")
    @TableField("class_code")
    private String classCode;

    @Schema(description = "班级名称")
    @TableField("class_name")
    private String className;

    @Schema(description = "所属专业编码")
    @TableField("major_code")
    private String majorCode;

    @Schema(description = "年级")
    @TableField("grade")
    private String grade;

    @Schema(description = "负责人")
    @TableField("teacher")
    private String teacher;

    @Schema(description = "入学年份")
    @TableField("enrollment_year")
    private Integer enrollmentYear;

    @Schema(description = "当前人数")
    @TableField("current_count")
    private Integer currentCount;

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

