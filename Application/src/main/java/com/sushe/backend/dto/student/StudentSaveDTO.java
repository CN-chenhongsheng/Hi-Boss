package com.sushe.backend.dto.student;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDate;

/**
 * 学生保存DTO（新增/编辑）
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Data
@Schema(description = "学生保存请求")
public class StudentSaveDTO {

    @Schema(description = "学生ID（编辑时必传）")
    private Long id;

    @Schema(description = "学号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "学号不能为空")
    private String studentNo;

    @Schema(description = "姓名", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "姓名不能为空")
    private String studentName;

    @Schema(description = "性别（字典sys_gender）：0未知 1男 2女")
    private Integer gender;

    @Schema(description = "身份证号")
    private String idCard;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "出生日期")
    private LocalDate birthDate;

    @Schema(description = "民族")
    private String nation;

    @Schema(description = "政治面貌")
    private String politicalStatus;

    @Schema(description = "入学年份")
    private Integer enrollmentYear;

    @Schema(description = "学制（年）")
    private Integer schoolingLength;

    @Schema(description = "当前年级")
    private String currentGrade;

    @Schema(description = "学籍状态（字典academic_status）：1在读 2休学 3毕业 4退学")
    private Integer academicStatus;

    @Schema(description = "家庭地址")
    private String homeAddress;

    @Schema(description = "紧急联系人")
    private String emergencyContact;

    @Schema(description = "紧急联系人电话")
    private String emergencyPhone;

    @Schema(description = "家长姓名")
    private String parentName;

    @Schema(description = "家长电话")
    private String parentPhone;

    @Schema(description = "校区编码")
    private String campusCode;

    @Schema(description = "院系编码")
    private String deptCode;

    @Schema(description = "专业编码")
    private String majorCode;

    @Schema(description = "班级ID")
    private Long classId;

    @Schema(description = "班级编码")
    private String classCode;

    @Schema(description = "楼层ID")
    private Long floorId;

    @Schema(description = "楼层编码")
    private String floorCode;

    @Schema(description = "房间ID")
    private Long roomId;

    @Schema(description = "房间编码")
    private String roomCode;

    @Schema(description = "床位ID")
    private Long bedId;

    @Schema(description = "床位编码")
    private String bedCode;

    @Schema(description = "状态：1启用 0停用")
    private Integer status;

    @Schema(description = "备注")
    private String remark;
}

