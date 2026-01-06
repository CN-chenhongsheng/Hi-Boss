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

        if (saveDTO.getId() == null) {
            // 新增时默认状态为待审核
            if (transfer.getStatus() == null) {
                transfer.setStatus(1);
            }
            return save(transfer);
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

