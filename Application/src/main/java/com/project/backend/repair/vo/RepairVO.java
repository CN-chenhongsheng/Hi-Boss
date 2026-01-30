package com.project.backend.repair.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 报修管理VO
 *
 * @author 陈鸿昇
 * @since 2026-01-29
 */
@Data
@Schema(description = "报修管理VO")
public class RepairVO implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "学生ID")
    private Long studentId;

    @Schema(description = "学生姓名")
    private String studentName;

    @Schema(description = "学号")
    private String studentNo;

    @Schema(description = "房间ID")
    private Long roomId;

    @Schema(description = "房间编码")
    private String roomCode;

    @Schema(description = "床位ID")
    private Long bedId;

    @Schema(description = "床位编码")
    private String bedCode;

    @Schema(description = "维修类型：1-水电 2-门窗 3-家具 4-网络 5-其他")
    private Integer repairType;

    @Schema(description = "维修类型文本")
    private String repairTypeText;

    @Schema(description = "故障描述")
    private String faultDescription;

    @Schema(description = "故障图片列表")
    private List<String> faultImages;

    @Schema(description = "紧急程度：1-一般 2-紧急 3-非常紧急")
    private Integer urgentLevel;

    @Schema(description = "紧急程度文本")
    private String urgentLevelText;

    @Schema(description = "状态：1-待接单 2-已接单 3-维修中 4-已完成 5-已取消")
    private Integer status;

    @Schema(description = "状态文本")
    private String statusText;

    @Schema(description = "维修人员ID")
    private Long repairPersonId;

    @Schema(description = "维修人员姓名")
    private String repairPersonName;

    @Schema(description = "预约时间")
    private LocalDateTime appointmentTime;

    @Schema(description = "完成时间")
    private LocalDateTime completeTime;

    @Schema(description = "维修结果描述")
    private String repairResult;

    @Schema(description = "维修后图片列表")
    private List<String> repairImages;

    @Schema(description = "评分：1-5星")
    private Integer rating;

    @Schema(description = "评分文本")
    private String ratingText;

    @Schema(description = "评价内容")
    private String ratingComment;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    @Schema(description = "创建人ID")
    private Long createBy;

    @Schema(description = "更新人ID")
    private Long updateBy;

    // ==================== 学生信息（与 CheckInVO/StudentVO 对齐，用于列表悬浮卡片与详情） ====================
    @Schema(description = "性别（字典sys_user_sex）：0未知 1男 2女")
    private Integer gender;

    @Schema(description = "性别文本")
    private String genderText;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "身份证号")
    private String idCard;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "出生日期")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate birthDate;

    @Schema(description = "学制（年）")
    private Integer schoolingLength;

    @Schema(description = "民族")
    private String nation;

    @Schema(description = "政治面貌")
    private String politicalStatus;

    @Schema(description = "校区编码")
    private String campusCode;

    @Schema(description = "校区名称")
    private String campusName;

    @Schema(description = "院系编码")
    private String deptCode;

    @Schema(description = "院系名称")
    private String deptName;

    @Schema(description = "专业编码")
    private String majorCode;

    @Schema(description = "专业名称")
    private String majorName;

    @Schema(description = "班级ID")
    private Long classId;

    @Schema(description = "班级编码")
    private String classCode;

    @Schema(description = "班级名称")
    private String className;

    @Schema(description = "楼层ID")
    private Long floorId;

    @Schema(description = "楼层编码")
    private String floorCode;

    @Schema(description = "楼栋/楼层名称")
    private String floorName;

    @Schema(description = "房间名称")
    private String roomName;

    @Schema(description = "床位名称")
    private String bedName;

    @Schema(description = "学籍状态（字典academic_status）：1在读 2休学 3毕业 4退学")
    private Integer academicStatus;

    @Schema(description = "学籍状态文本")
    private String academicStatusText;

    @Schema(description = "入学年份")
    private Integer enrollmentYear;

    @Schema(description = "当前年级")
    private String currentGrade;

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
}
