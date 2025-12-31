package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 系统用户表
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Data
@TableName("sys_user")
@Schema(description = "系统用户实体")
public class SysUser implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "用户名")
    @TableField("username")
    private String username;

    @Schema(description = "密码（加密）")
    @TableField("password")
    private String password;

    @Schema(description = "昵称")
    @TableField("nickname")
    private String nickname;

    @Schema(description = "头像URL")
    @TableField("avatar")
    private String avatar;

    @Schema(description = "邮箱")
    @TableField("email")
    private String email;

    @Schema(description = "手机号")
    @TableField("phone")
    private String phone;

    @Schema(description = "所属学院（辅导员、院系管理员）")
    @TableField("college")
    private String college;

    @Schema(description = "状态：1正常 0停用")
    @TableField("status")
    private Integer status;

    @Schema(description = "性别（字典sys_gender）：0未知 1男 2女")
    @TableField("gender")
    private Integer gender;

    @Schema(description = "地址")
    @TableField("address")
    private String address;

    @Schema(description = "个人介绍")
    @TableField("introduction")
    private String introduction;

    @Schema(description = "企业微信ID")
    @TableField("cp_user_id")
    private String cpUserId;

    @Schema(description = "微信openid")
    @TableField("openid")
    private String openid;

    @Schema(description = "删除标志：0正常 1删除")
    @TableField("del_flag")
    @TableLogic(value = "0", delval = "1")
    private Integer delFlag;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @Schema(description = "最后登录时间")
    @TableField("last_login_time")
    private LocalDateTime lastLoginTime;
}

