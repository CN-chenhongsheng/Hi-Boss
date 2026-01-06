package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户菜单关联表
 * 
 * @author 陈鸿昇
 * @since 2025-01-06
 */
@Data
@TableName("sys_user_menu")
@Schema(description = "用户菜单关联实体")
public class SysUserMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "用户ID")
    @TableField("user_id")
    private Long userId;

    @Schema(description = "菜单ID")
    @TableField("menu_id")
    private Long menuId;

    @Schema(description = "创建时间")
    @TableField("create_time")
    private LocalDateTime createTime;
}

