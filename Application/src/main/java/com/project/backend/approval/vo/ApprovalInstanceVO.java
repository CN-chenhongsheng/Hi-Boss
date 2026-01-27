package com.project.backend.approval.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 审批实例展示VO
 * 
 * @author 陈鸿昇
 * @since 2026-01-17
 */
@Data
@Schema(description = "审批实例信息响应")
public class ApprovalInstanceVO implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "流程ID")
    private Long flowId;

    @Schema(description = "流程名称")
    private String flowName;

    @Schema(description = "业务类型")
    private String businessType;

    @Schema(description = "业务类型文本")
    private String businessTypeText;

    @Schema(description = "业务数据ID")
    private Long businessId;

    @Schema(description = "申请人ID")
    private Long applicantId;

    @Schema(description = "申请人姓名")
    private String applicantName;

    @Schema(description = "学号（当业务类型为学生相关业务时返回）")
    private String studentNo;

    @Schema(description = "性别（字典sys_user_sex）：0未知 1男 2女（当业务类型为学生相关业务时返回）")
    private Integer gender;

    @Schema(description = "性别文本（当业务类型为学生相关业务时返回）")
    private String genderText;

    @Schema(description = "手机号（当业务类型为学生相关业务时返回）")
    private String phone;

    @Schema(description = "民族（当业务类型为学生相关业务时返回）")
    private String nation;

    @Schema(description = "政治面貌（当业务类型为学生相关业务时返回）")
    private String politicalStatus;

    @Schema(description = "校区名称（当业务类型为学生相关业务时返回）")
    private String campusName;

    @Schema(description = "院系名称（当业务类型为学生相关业务时返回）")
    private String deptName;

    @Schema(description = "专业名称（当业务类型为学生相关业务时返回）")
    private String majorName;

    @Schema(description = "班级名称（当业务类型为学生相关业务时返回）")
    private String className;

    @Schema(description = "楼层名称（当业务类型为学生相关业务时返回）")
    private String floorName;

    @Schema(description = "房间名称（当业务类型为学生相关业务时返回）")
    private String roomName;

    @Schema(description = "床位名称（当业务类型为学生相关业务时返回）")
    private String bedName;

    @Schema(description = "学籍状态文本（当业务类型为学生相关业务时返回）")
    private String academicStatusText;

    @Schema(description = "入学年份（当业务类型为学生相关业务时返回）")
    private Integer enrollmentYear;

    @Schema(description = "当前年级（当业务类型为学生相关业务时返回）")
    private String currentGrade;

    @Schema(description = "当前节点ID")
    private Long currentNodeId;

    @Schema(description = "当前节点名称")
    private String currentNodeName;

    @Schema(description = "状态：1进行中 2已通过 3已拒绝 4已撤回")
    private Integer status;

    @Schema(description = "状态文本")
    private String statusText;

    @Schema(description = "流程开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;

    @Schema(description = "流程结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "流程节点列表（含审批状态）")
    private List<ApprovalNodeVO> nodes;

    @Schema(description = "审批记录列表")
    private List<ApprovalRecordVO> records;

    @Schema(description = "当前用户是否可审批")
    private Boolean canApprove;

    @Schema(description = "创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
