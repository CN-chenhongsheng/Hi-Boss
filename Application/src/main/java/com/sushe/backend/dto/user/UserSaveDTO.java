package com.sushe.backend.dto.user;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 用户保存DTO（新增/编辑）
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Data
@Schema(description = "用户保存请求")
public class UserSaveDTO {

    @Schema(description = "用户ID（编辑时必传）")
    private Long id;

    @Schema(description = "用户名", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "用户名不能为空")
    @Pattern(regexp = "^[a-zA-Z0-9_]{4,20}$", message = "用户名只能包含字母、数字、下划线，长度4-20位")
    private String username;

    @Schema(description = "密码（新增时必传，编辑时不传则不修改）")
    private String password;

    @Schema(description = "昵称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "昵称不能为空")
    private String nickname;

    @Schema(description = "头像URL")
    private String avatar;

    @Schema(description = "邮箱")
    @Email(message = "邮箱格式不正确")
    private String email;

    @Schema(description = "手机号")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    @Schema(description = "管理范围")
    private String manageScope;

    @Schema(description = "状态：1正常 0停用")
    private Integer status;

    @Schema(description = "性别（字典sys_gender）：0未知 1男 2女")
    private Integer gender;

    @Schema(description = "地址")
    private String address;

    @Schema(description = "个人介绍")
    private String introduction;

    @Schema(description = "企业微信ID")
    private String cpUserId;

    @Schema(description = "微信openid")
    private String openid;

    @Schema(description = "角色ID列表")
    private Long[] roleIds;
}

