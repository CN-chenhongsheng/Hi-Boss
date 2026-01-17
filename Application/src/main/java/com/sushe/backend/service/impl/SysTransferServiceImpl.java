package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.transfer.TransferQueryDTO;
import com.sushe.backend.dto.transfer.TransferSaveDTO;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysStudent;
import com.sushe.backend.entity.SysTransfer;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysStudentMapper;
import com.sushe.backend.mapper.SysTransferMapper;
import com.sushe.backend.service.SysTransferService;
import com.sushe.backend.service.SysApprovalService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.TransferVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 调宿管理Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysTransferServiceImpl extends ServiceImpl<SysTransferMapper, SysTransfer> implements SysTransferService {

    private final SysStudentMapper studentMapper;
    private final SysCampusMapper campusMapper;
    private final SysApprovalService approvalService;

    @Override
    public PageResult<TransferVO> pageList(TransferQueryDTO queryDTO) {
        LambdaQueryWrapper<SysTransfer> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), SysTransfer::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), SysTransfer::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, SysTransfer::getStudentId, queryDTO.getStudentId())
               .eq(StrUtil.isNotBlank(queryDTO.getOriginalCampusCode()), SysTransfer::getOriginalCampusCode, queryDTO.getOriginalCampusCode())
               .eq(StrUtil.isNotBlank(queryDTO.getTargetCampusCode()), SysTransfer::getTargetCampusCode, queryDTO.getTargetCampusCode())
               .eq(queryDTO.getStatus() != null, SysTransfer::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, SysTransfer::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, SysTransfer::getApplyDate, queryDTO.getApplyDateEnd())
               .orderByDesc(SysTransfer::getCreateTime);

        Page<SysTransfer> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<TransferVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public TransferVO getDetailById(Long id) {
        SysTransfer transfer = getById(id);
        if (transfer == null) {
            throw new BusinessException("调宿记录不存在");
        }
        return convertToVO(transfer);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveTransfer(TransferSaveDTO saveDTO) {
        // 检查学生是否存在
        SysStudent student = studentMapper.selectById(saveDTO.getStudentId());
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        SysTransfer transfer = new SysTransfer();
        BeanUtil.copyProperties(saveDTO, transfer);

        // 填充学生冗余字段
        transfer.setStudentName(student.getStudentName());
        transfer.setStudentNo(student.getStudentNo());

        boolean isNew = saveDTO.getId() == null;
        
        if (isNew) {
            // 新增时先保存记录（需要获取ID）
            if (transfer.getStatus() == null) {
                transfer.setStatus(1); // 临时状态，后续会根据审批结果更新
            }
            save(transfer);
            
            // 发起审批流程
            Long instanceId = approvalService.startApproval(
                "transfer",
                transfer.getId(),
                saveDTO.getStudentId(),
                student.getStudentName()
            );
            
            if (instanceId != null) {
                // 有审批流程，状态设为"待审批"（状态1）
                transfer.setApprovalInstanceId(instanceId);
                transfer.setStatus(1);
                log.info("调宿申请已发起审批，申请ID：{}，审批实例ID：{}", transfer.getId(), instanceId);
            } else {
                // 无审批流程，直接通过，状态设为"已通过"（状态2）
                transfer.setStatus(2);
                log.info("调宿申请无需审批，直接通过，申请ID：{}", transfer.getId());
            }
            
            return updateById(transfer);
        } else {
            return updateById(transfer);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteTransfer(Long id) {
        if (id == null) {
            throw new BusinessException("调宿记录ID不能为空");
        }
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("调宿记录ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 撤回调宿申请
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelTransfer(Long id) {
        if (id == null) {
            throw new BusinessException("调宿记录ID不能为空");
        }

        SysTransfer transfer = getById(id);
        if (transfer == null) {
            throw new BusinessException("调宿记录不存在");
        }

        // 只有待审核状态才能撤回
        if (transfer.getStatus() != 1) {
            throw new BusinessException("只有待审核状态的申请才能撤回");
        }

        // 更新状态为已撤回（状态5）
        transfer.setStatus(5);
        return updateById(transfer);
    }

    /**
     * 实体转VO
     */
    private TransferVO convertToVO(SysTransfer transfer) {
        TransferVO vo = new TransferVO();
        BeanUtil.copyProperties(transfer, vo);
        vo.setStatusText(DictUtils.getLabel("transfer_status", transfer.getStatus(), "未知"));

        // 查询原校区名称
        if (StrUtil.isNotBlank(transfer.getOriginalCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, transfer.getOriginalCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setOriginalCampusName(campus.getCampusName());
            }
        }

        // 查询目标校区名称
        if (StrUtil.isNotBlank(transfer.getTargetCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, transfer.getTargetCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setTargetCampusName(campus.getCampusName());
            }
        }

        return vo;
    }
}

