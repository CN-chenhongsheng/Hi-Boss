package com.project.backend.accommodation.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.project.backend.accommodation.dto.checkin.CheckInQueryDTO;
import com.project.backend.accommodation.dto.checkin.CheckInSaveDTO;
import com.project.backend.accommodation.entity.CheckIn;
import com.project.backend.accommodation.mapper.CheckInMapper;
import com.project.backend.accommodation.service.CheckInService;
import com.project.backend.accommodation.vo.CheckInVO;
import com.project.core.exception.BusinessException;
import com.project.core.result.PageResult;
import com.project.core.vo.ApprovalProgress;
import com.project.core.vo.ApprovalProgressNode;
import com.project.backend.approval.vo.ApprovalInstanceVO;
import com.project.backend.approval.vo.ApprovalNodeVO;
import com.project.backend.approval.vo.ApprovalAssigneeVO;
import com.project.backend.approval.vo.ApprovalRecordVO;
import com.project.backend.accommodation.entity.Student;
import com.project.backend.accommodation.mapper.StudentMapper;
import com.project.backend.organization.entity.Campus;
import com.project.backend.organization.mapper.CampusMapper;
import com.project.backend.approval.service.ApprovalService;
import com.project.backend.approval.mapper.ApprovalInstanceMapper;
import com.project.backend.approval.mapper.ApprovalRecordMapper;
import com.project.backend.approval.entity.ApprovalRecord;
import com.project.backend.util.DictUtils;
import com.project.core.context.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 入住管理Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CheckInServiceImpl extends ServiceImpl<CheckInMapper, CheckIn> implements CheckInService {

    private final StudentMapper studentMapper;
    private final CampusMapper campusMapper;
    private final ApprovalService approvalService;
    private final ApprovalInstanceMapper approvalInstanceMapper;
    private final ApprovalRecordMapper approvalRecordMapper;

    @Override
    public PageResult<CheckInVO> pageList(CheckInQueryDTO queryDTO) {
        LambdaQueryWrapper<CheckIn> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), CheckIn::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), CheckIn::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, CheckIn::getStudentId, queryDTO.getStudentId())
               .eq(queryDTO.getCheckInType() != null, CheckIn::getCheckInType, queryDTO.getCheckInType())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), CheckIn::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getBedId() != null, CheckIn::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getStatus() != null, CheckIn::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, CheckIn::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, CheckIn::getApplyDate, queryDTO.getApplyDateEnd())
               .orderByDesc(CheckIn::getCreateTime);

        Page<CheckIn> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<CheckInVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public CheckInVO getDetailById(Long id) {
        CheckIn checkIn = getById(id);
        if (checkIn == null) {
            throw new BusinessException("入住记录不存在");
        }
        return convertToVO(checkIn);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveCheckIn(CheckInSaveDTO saveDTO) {
        // 获取学生ID：优先使用 DTO 中的值（管理端编辑），否则从 UserContext 获取（学生端提交）
        Long studentId = saveDTO.getStudentId();
        if (studentId == null) {
            studentId = UserContext.getUserId();
            if (studentId == null) {
                throw new BusinessException("用户未登录");
            }
            saveDTO.setStudentId(studentId);
        }

        // 检查学生是否存在
        Student student = studentMapper.selectById(studentId);
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        CheckIn checkIn = new CheckIn();
        BeanUtil.copyProperties(saveDTO, checkIn);

        // 填充学生冗余字段
        checkIn.setStudentName(student.getStudentName());
        checkIn.setStudentNo(student.getStudentNo());

        boolean isNew = saveDTO.getId() == null;

        if (isNew) {
            // 新增时先保存记录（需要获取ID）
            if (checkIn.getStatus() == null) {
                checkIn.setStatus(1); // 临时状态，后续会根据审批结果更新
            }
            save(checkIn);

            // 发起审批流程
            Long instanceId = approvalService.startApproval(
                "check_in",
                checkIn.getId(),
                saveDTO.getStudentId(),
                student.getStudentName()
            );

            if (instanceId != null) {
                // 有审批流程，状态设为"待审批"（状态1）
                checkIn.setApprovalInstanceId(instanceId);
                checkIn.setStatus(1);
                log.info("入住申请已发起审批，申请ID：{}，审批实例ID：{}", checkIn.getId(), instanceId);
            } else {
                // 无审批流程，直接通过，状态设为"已通过"（状态2）
                checkIn.setStatus(2);
                log.info("入住申请无需审批，直接通过，申请ID：{}", checkIn.getId());
            }

            return updateById(checkIn);
        } else {
            return updateById(checkIn);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteCheckIn(Long id) {
        if (id == null) {
            throw new BusinessException("入住记录ID不能为空");
        }

        // 查询入住记录
        CheckIn checkIn = getById(id);
        if (checkIn == null) {
            throw new BusinessException("入住记录不存在");
        }

        // 如果存在审批实例，删除关联的审批记录和审批实例
        if (checkIn.getApprovalInstanceId() != null) {
            Long instanceId = checkIn.getApprovalInstanceId();

            // 删除审批记录
            LambdaQueryWrapper<ApprovalRecord> recordWrapper = new LambdaQueryWrapper<>();
            recordWrapper.eq(ApprovalRecord::getInstanceId, instanceId);
            approvalRecordMapper.delete(recordWrapper);

            // 删除审批实例
            approvalInstanceMapper.deleteById(instanceId);

            log.info("删除入住记录时同步删除审批实例，入住记录ID：{}，审批实例ID：{}", id, instanceId);
        }

        // 删除入住记录
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("入住记录ID不能为空");
        }

        // 查询所有入住记录
        List<CheckIn> checkInList = listByIds(Arrays.asList(ids));
        if (checkInList.isEmpty()) {
            throw new BusinessException("入住记录不存在");
        }

        // 收集所有需要删除的审批实例ID
        List<Long> instanceIds = checkInList.stream()
                .map(CheckIn::getApprovalInstanceId)
                .filter(instanceId -> instanceId != null)
                .distinct()
                .collect(Collectors.toList());

        // 批量删除审批记录和审批实例
        if (!instanceIds.isEmpty()) {
            // 删除审批记录
            LambdaQueryWrapper<ApprovalRecord> recordWrapper = new LambdaQueryWrapper<>();
            recordWrapper.in(ApprovalRecord::getInstanceId, instanceIds);
            approvalRecordMapper.delete(recordWrapper);

            // 删除审批实例（循环删除，因为 BaseMapper 没有批量删除方法）
            for (Long instanceId : instanceIds) {
                approvalInstanceMapper.deleteById(instanceId);
            }

            log.info("批量删除入住记录时同步删除审批实例，入住记录数量：{}，审批实例数量：{}",
                    checkInList.size(), instanceIds.size());
        }

        // 批量删除入住记录
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 撤回入住申请
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelCheckIn(Long id) {
        if (id == null) {
            throw new BusinessException("入住记录ID不能为空");
        }

        CheckIn checkIn = getById(id);
        if (checkIn == null) {
            throw new BusinessException("入住记录不存在");
        }

        // 只有待审核状态才能撤回
        if (checkIn.getStatus() != 1) {
            throw new BusinessException("只有待审核状态的申请才能撤回");
        }

        // 更新状态为已撤回（状态5）
        checkIn.setStatus(5);
        return updateById(checkIn);
    }

    /**
     * 实体转VO
     */
    private CheckInVO convertToVO(CheckIn checkIn) {
        CheckInVO vo = new CheckInVO();
        BeanUtil.copyProperties(checkIn, vo);
        vo.setStatusText(DictUtils.getLabel("check_in_status", checkIn.getStatus(), "未知"));
        vo.setCheckInTypeText(checkIn.getCheckInType() != null && checkIn.getCheckInType() == 1 ? "长期住宿" : "临时住宿");

        // 查询校区名称
        if (StrUtil.isNotBlank(checkIn.getCampusCode())) {
            LambdaQueryWrapper<Campus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Campus::getCampusCode, checkIn.getCampusCode());
            Campus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        // 填充审批进度信息
        if (checkIn.getApprovalInstanceId() != null) {
            vo.setApprovalInstanceId(checkIn.getApprovalInstanceId());
            vo.setApprovalProgress(buildApprovalProgress(checkIn.getApprovalInstanceId(), checkIn.getStatus()));
        }

        return vo;
    }

    /**
     * 构建审批进度信息
     */
    private ApprovalProgress buildApprovalProgress(Long approvalInstanceId, Integer status) {
        ApprovalProgress progress = new ApprovalProgress();
        progress.setStatus(status);
        progress.setStatusText(DictUtils.getLabel("check_in_status", status, "未知"));

        ApprovalInstanceVO instance = null;
        try {
            instance = approvalService.getInstanceDetail(approvalInstanceId);
        } catch (Exception e) {
            log.error("获取审批实例详情失败: {}", e.getMessage());
        }

        if (instance != null) {
            progress.setApplicantName(instance.getApplicantName());
            progress.setStartTime(instance.getStartTime());
            progress.setCurrentNodeName(instance.getCurrentNodeName());

            List<ApprovalProgressNode> nodeTimeline = buildNodeTimeline(instance);
            progress.setNodeTimeline(nodeTimeline);
            progress.setTotalNodes(nodeTimeline.size());
            progress.setCompletedNodes((int) nodeTimeline.stream()
                    .filter(node -> node.getStatus() != null && node.getStatus() == 2)
                    .count());

            if (status != null && status != 1) {
                progress.setProgressPercent(100);
            } else if (nodeTimeline.isEmpty()) {
                progress.setProgressPercent(0);
            } else {
                int percent = (int) Math.round(progress.getCompletedNodes() * 100.0 / nodeTimeline.size());
                progress.setProgressPercent(Math.min(100, Math.max(0, percent)));
            }

            if (status != null && status == 1) {
                String nextApproverName = getNextApproverName(instance);
                progress.setNextApproverName(nextApproverName);

                String nodeName = instance.getCurrentNodeName() != null ? instance.getCurrentNodeName() : "待审批";
                String approverName = nextApproverName != null ? nextApproverName : "未指定";
                progress.setProgressText(String.format("%s(%s)", nodeName, approverName));
            } else if (status != null && status == 2) {
                progress.setProgressText("已通过");
            } else if (status != null && status == 3) {
                progress.setProgressText("已拒绝");
            } else if (status != null && status == 4) {
                progress.setProgressText("已完成");
            } else {
                progress.setProgressText("未知进度");
            }
        } else {
            if (status != null && status != 1) {
                progress.setProgressPercent(100);
            } else {
                progress.setProgressPercent(0);
            }
            progress.setProgressText("未知进度");
        }

        return progress;
    }

    /**
     * 获取下一审批人姓名
     */
    private String getNextApproverName(ApprovalInstanceVO instance) {
        if (instance.getNodes() == null || instance.getNodes().isEmpty()) {
            return null;
        }

        // 查找当前节点
        ApprovalNodeVO currentNode = instance.getNodes().stream()
                .filter(node -> node.getId().equals(instance.getCurrentNodeId()))
                .findFirst()
                .orElse(null);

        if (currentNode != null && currentNode.getAssignees() != null && !currentNode.getAssignees().isEmpty()) {
            // 返回第一个审批人姓名（如果是多人会签，可以展示多个）
            List<String> approverNames = currentNode.getAssignees().stream()
                    .map(ApprovalAssigneeVO::getAssigneeName)
                    .collect(Collectors.toList());
            return String.join("、", approverNames);
        }

        return null;
    }

    private List<ApprovalProgressNode> buildNodeTimeline(ApprovalInstanceVO instance) {
        if (instance.getNodes() == null || instance.getNodes().isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, ApprovalRecordVO> recordMap = buildRecordMap(instance.getRecords());

        return instance.getNodes().stream()
                .sorted(Comparator.comparing(
                        ApprovalNodeVO::getNodeOrder,
                        Comparator.nullsLast(Integer::compareTo)
                ))
                .map(node -> {
                    ApprovalProgressNode timelineNode = new ApprovalProgressNode();
                    timelineNode.setNodeId(node.getId());
                    timelineNode.setNodeName(node.getNodeName());
                    timelineNode.setAssigneeNames(getNodeAssigneeNames(node));

                    ApprovalRecordVO record = recordMap.get(node.getId());
                    if (record != null) {
                        if (record.getAction() != null && record.getAction() == 2) {
                            timelineNode.setStatus(3);
                            timelineNode.setStatusText("已拒绝");
                        } else {
                            timelineNode.setStatus(2);
                            timelineNode.setStatusText("已通过");
                        }
                        timelineNode.setActionText(record.getActionText());
                        timelineNode.setApproveTime(record.getApproveTime());
                    } else {
                        timelineNode.setStatus(1);
                        timelineNode.setStatusText("待处理");
                    }

                    return timelineNode;
                })
                .collect(Collectors.toList());
    }

    private Map<Long, ApprovalRecordVO> buildRecordMap(List<ApprovalRecordVO> records) {
        if (records == null || records.isEmpty()) {
            return Collections.emptyMap();
        }

        return records.stream()
                .filter(record -> record.getNodeId() != null)
                .collect(Collectors.toMap(
                        ApprovalRecordVO::getNodeId,
                        record -> record,
                        (first, second) -> {
                            if (first.getApproveTime() == null) {
                                return second;
                            }
                            if (second.getApproveTime() == null) {
                                return first;
                            }
                            return second.getApproveTime().isAfter(first.getApproveTime()) ? second : first;
                        }
                ));
    }

    private String getNodeAssigneeNames(ApprovalNodeVO node) {
        if (node.getAssignees() == null || node.getAssignees().isEmpty()) {
            return "未指定";
        }

        return node.getAssignees().stream()
                .map(ApprovalAssigneeVO::getAssigneeName)
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.joining("、"));
    }
}
