package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.checkin.CheckInQueryDTO;
import com.sushe.backend.dto.checkin.CheckInSaveDTO;
import com.sushe.backend.entity.SysCheckIn;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysStudent;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysCheckInMapper;
import com.sushe.backend.mapper.SysStudentMapper;
import com.sushe.backend.service.SysCheckInService;
import com.sushe.backend.service.SysApprovalService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.CheckInVO;
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
public class SysCheckInServiceImpl extends ServiceImpl<SysCheckInMapper, SysCheckIn> implements SysCheckInService {

    private final SysStudentMapper studentMapper;
    private final SysCampusMapper campusMapper;
    private final SysApprovalService approvalService;

    @Override
    public PageResult<CheckInVO> pageList(CheckInQueryDTO queryDTO) {
        LambdaQueryWrapper<SysCheckIn> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), SysCheckIn::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), SysCheckIn::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, SysCheckIn::getStudentId, queryDTO.getStudentId())
               .eq(queryDTO.getCheckInType() != null, SysCheckIn::getCheckInType, queryDTO.getCheckInType())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysCheckIn::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getBedId() != null, SysCheckIn::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getStatus() != null, SysCheckIn::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, SysCheckIn::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, SysCheckIn::getApplyDate, queryDTO.getApplyDateEnd())
               .orderByDesc(SysCheckIn::getCreateTime);

        Page<SysCheckIn> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<CheckInVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public CheckInVO getDetailById(Long id) {
        SysCheckIn checkIn = getById(id);
        if (checkIn == null) {
            throw new BusinessException("入住记录不存在");
        }
        return convertToVO(checkIn);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveCheckIn(CheckInSaveDTO saveDTO) {
        // 检查学生是否存在
        SysStudent student = studentMapper.selectById(saveDTO.getStudentId());
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        SysCheckIn checkIn = new SysCheckIn();
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
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("入住记录ID不能为空");
        }
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

        SysCheckIn checkIn = getById(id);
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
    private CheckInVO convertToVO(SysCheckIn checkIn) {
        CheckInVO vo = new CheckInVO();
        BeanUtil.copyProperties(checkIn, vo);
        vo.setStatusText(DictUtils.getLabel("check_in_status", checkIn.getStatus(), "未知"));
        vo.setCheckInTypeText(checkIn.getCheckInType() != null && checkIn.getCheckInType() == 1 ? "长期住宿" : "临时住宿");

        // 查询校区名称
        if (StrUtil.isNotBlank(checkIn.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, checkIn.getCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        return vo;
    }
}

