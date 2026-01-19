package com.sushe.backend.accommodation.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.sushe.backend.entity.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 学生实体
 * 
 * @author 陈鸿�?
 * @since 2026-01-06
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_student")
@Schema(description = "学生实体")
public class Student extends BaseEntity {

    @Schema(description = "学号")
    @TableField("student_no")
    private String studentNo;

    @Schema(description = "姓名")
    @TableField("student_name")
    private String studentName;

    @Schema(description = "性别（字典sys_user_sex）：0未知 1�?2�?)
    @TableField("gender")
    private Integer gender;

    @Schema(description = "身份证号")
    @TableField("id_card")
    private String idCard;

    @Schema(description = "手机�?)
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

    @Schema(description = "学制（年�?)
    @TableField("schooling_length")
    private Integer schoolingLength;

    @Schema(description = "当前年级")
    @TableField("current_grade")
    private String currentGrade;

    @Schema(description = "学籍状态（字典academic_status）：1在读 2休学 3毕业 4退�?)
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

    // ========== 生活习惯字段 ==========
    @Schema(description = "吸烟状态：0不吸�?1吸烟")
    @TableField("smoking_status")
    private Integer smokingStatus;

    @Schema(description = "是否接受室友吸烟�?不接�?1接受")
    @TableField("smoking_tolerance")
    private Integer smokingTolerance;

    @Schema(description = "作息时间�?早睡早起 1正常 2晚睡晚起 3夜猫�?)
    @TableField("sleep_schedule")
    private Integer sleepSchedule;

    @Schema(description = "睡眠质量�?浅睡易醒 1正常 2深睡")
    @TableField("sleep_quality")
    private Integer sleepQuality;

    @Schema(description = "是否打呼噜：0不打 1�?)
    @TableField("snores")
    private Integer snores;

    @Schema(description = "是否对光线敏感：0不敏�?1敏感")
    @TableField("sensitive_to_light")
    private Integer sensitiveToLight;

    @Schema(description = "是否对声音敏感：0不敏�?1敏感")
    @TableField("sensitive_to_sound")
    private Integer sensitiveToSound;

    @Schema(description = "整洁程度�?非常整洁 2整洁 3一�?4随意 5不整�?)
    @TableField("cleanliness_level")
    private Integer cleanlinessLevel;

    @Schema(description = "睡前是否整理�?不整�?1偶尔整理 2经常整理 3总是整理")
    @TableField("bedtime_cleanup")
    private Integer bedtimeCleanup;

    @Schema(description = "社交偏好�?喜欢安静 2中等 3喜欢热闹")
    @TableField("social_preference")
    private Integer socialPreference;

    @Schema(description = "是否允许室友带访客：0不允�?1偶尔可以 2可以")
    @TableField("allow_visitors")
    private Integer allowVisitors;

    @Schema(description = "电话时间偏好�?喜欢在宿舍打电话 1偶尔在宿�?2不在宿舍打电�?)
    @TableField("phone_call_time")
    private Integer phoneCallTime;

    @Schema(description = "是否在宿舍学习：0不在 1偶尔 2经常 3总是")
    @TableField("study_in_room")
    private Integer studyInRoom;

    @Schema(description = "学习环境偏好�?需要安�?2需要轻音乐 3可以接受声音")
    @TableField("study_environment")
    private Integer studyEnvironment;

    @Schema(description = "电脑使用时间�?不用 1很少 2正常 3很多")
    @TableField("computer_usage_time")
    private Integer computerUsageTime;

    @Schema(description = "游戏偏好�?不玩游戏 1偶尔�?2经常�?)
    @TableField("gaming_preference")
    private Integer gamingPreference;

    @Schema(description = "听音乐偏好：0不听 1偶尔�?2经常�?)
    @TableField("music_preference")
    private Integer musicPreference;

    @Schema(description = "音乐音量偏好�?喜欢小声 2中等 3喜欢大声")
    @TableField("music_volume")
    private Integer musicVolume;

    @Schema(description = "是否在宿舍吃东西�?不吃 1偶尔 2经常")
    @TableField("eat_in_room")
    private Integer eatInRoom;

    @Schema(description = "密码（加密）")
    @TableField("password")
    private String password;

    @Schema(description = "微信openid")
    @TableField("openid")
    private String openid;
}


