package com.sushe.backend.accommodation.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.accommodation.dto.checkin.CheckInQueryDTO;
import com.sushe.backend.accommodation.dto.checkin.CheckInSaveDTO;
import com.sushe.backend.accommodation.entity.CheckIn;
import com.sushe.backend.accommodation.mapper.CheckInMapper;
import com.sushe.backend.accommodation.service.CheckInService;
import com.sushe.backend.accommodation.vo.CheckInVO;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.accommodation.entity.Student;
import com.sushe.backend.accommodation.mapper.StudentMapper;
import com.sushe.backend.organization.entity.Campus;
import com.sushe.backend.organization.mapper.CampusMapper;
import com.sushe.backend.approval.service.ApprovalService;
import com.sushe.backend.approval.mapper.ApprovalInstanceMapper;
import com.sushe.backend.approval.mapper.ApprovalRecordMapper;
import com.sushe.backend.approval.entity.ApprovalInstance;
import com.sushe.backend.approval.entity.ApprovalRecord;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sushe.backend.util.DictUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
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
        // 检查学生是否存在
        Student student = studentMapper.selectById(saveDTO.getStudentId());
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

        return vo;
    }
}
