package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 字典数据实体
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Data
@TableName("sys_dict_data")
@Schema(description = "字典数据实体")
public class SysDictData implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "字典编码")
    @TableField("dict_code")
    private String dictCode;

    @Schema(description = "字典标签")
    @TableField("label")
    private String label;

    @Schema(description = "字典值")
    @TableField("value")
    private String value;

    @Schema(description = "CSS类名")
    @TableField("css_class")
    private String cssClass;

    @Schema(description = "表格回显样式")
    @TableField("list_class")
    private String listClass;

    @Schema(description = "排序")
    @TableField("sort")
    private Integer sort;

    @Schema(description = "是否默认：1是 0否")
    @TableField("is_default")
    private Integer isDefault;

    @Schema(description = "状态：1正常 0停用")
    @TableField("status")
    private Integer status;

    @Schema(description = "备注")
    @TableField("remark")
    private String remark;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}

