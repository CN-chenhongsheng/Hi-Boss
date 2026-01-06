package com.sushe.backend.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 学生实体
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_student")
@Schema(description = "学生实体")
public class SysStudent extends BaseEntity {

    @Schema(description = "学号")
    @TableField("student_no")
    private String studentNo;

    @Schema(description = "姓名")
    @TableField("student_name")
    private String studentName;

    @Schema(description = "性别（字典sys_gender）：0未知 1男 2女")
    @TableField("gender")
    private Integer gender;

    @Schema(description = "身份证号")
    @TableField("id_card")
    private String idCard;

    @Schema(description = "手机号")
    @TableField("phone")
    private String phone;

    @Schema(description = "邮箱")
    @TableField("email")
    private String email;

    @Schema(description = "出生日期")
    @TableField("birth_date")
    private LocalDate birthDate;

    @Schema(description = "民族")
    @TableField("nation")
    private String nation;

    @Schema(description = "政治面貌")
    @TableField("political_status")
    private String politicalStatus;

    @Schema(description = "入学年份")
    @TableField("enrollment_year")
    private Integer enrollmentYear;

    @Schema(description = "学制（年）")
    @TableField("schooling_length")
    private Integer schoolingLength;

    @Schema(description = "当前年级")
    @TableField("current_grade")
    private String currentGrade;

    @Schema(description = "学籍状态（字典academic_status）：1在读 2休学 3毕业 4退学")
    @TableField("academic_status")
    private Integer academicStatus;

    @Schema(description = "家庭地址")
    @TableField("home_address")
    private String homeAddress;

    @Schema(description = "紧急联系人")
    @TableField("emergency_contact")
    private String emergencyContact;

    @Schema(description = "紧急联系人电话")
    @TableField("emergency_phone")
    private String emergencyPhone;

    @Schema(description = "家长姓名")
    @TableField("parent_name")
    private String parentName;

    @Schema(description = "家长电话")
    @TableField("parent_phone")
    private String parentPhone;

    @Schema(description = "校区编码")
    @TableField("campus_code")
    private String campusCode;

    @Schema(description = "院系编码")
    @TableField("dept_code")
    private String deptCode;

    @Schema(description = "专业编码")
    @TableField("major_code")
    private String majorCode;

    @Schema(description = "班级ID")
    @TableField("class_id")
    private Long classId;

    @Schema(description = "班级编码")
    @TableField("class_code")
    private String classCode;

    @Schema(description = "楼层ID")
    @TableField("floor_id")
    private Long floorId;

    @Schema(description = "楼层编码")
    @TableField("floor_code")
    private String floorCode;

    @Schema(description = "房间ID")
    @TableField("room_id")
    private Long roomId;

    @Schema(description = "房间编码")
    @TableField("room_code")
    private String roomCode;

    @Schema(description = "床位ID")
    @TableField("bed_id")
    private Long bedId;

    @Schema(description = "床位编码")
    @TableField("bed_code")
    private String bedCode;

    @Schema(description = "状态：1启用 0停用")
    @TableField("status")
    private Integer status;

    @Schema(description = "备注")
    @TableField("remark")
    private String remark;
}

