package com.sushe.backend.accommodation.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.accommodation.dto.checkout.CheckOutQueryDTO;
import com.sushe.backend.accommodation.dto.checkout.CheckOutSaveDTO;
import com.sushe.backend.accommodation.entity.CheckOut;
import com.sushe.backend.accommodation.mapper.CheckOutMapper;
import com.sushe.backend.accommodation.service.CheckOutService;
import com.sushe.backend.accommodation.vo.CheckOutVO;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.accommodation.entity.Student;
import com.sushe.backend.accommodation.mapper.StudentMapper;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.service.SysApprovalService;
import com.sushe.backend.util.DictUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 退宿管理Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CheckOutServiceImpl extends ServiceImpl<CheckOutMapper, CheckOut> implements CheckOutService {

    private final StudentMapper studentMapper;
    private final SysCampusMapper campusMapper;
    private final SysApprovalService approvalService;

    @Override
    public PageResult<CheckOutVO> pageList(CheckOutQueryDTO queryDTO) {
        LambdaQueryWrapper<CheckOut> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), CheckOut::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), CheckOut::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, CheckOut::getStudentId, queryDTO.getStudentId())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), CheckOut::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getBedId() != null, CheckOut::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getStatus() != null, CheckOut::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, CheckOut::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, CheckOut::getApplyDate, queryDTO.getApplyDateEnd())
               .orderByDesc(CheckOut::getCreateTime);

        Page<CheckOut> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<CheckOutVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public CheckOutVO getDetailById(Long id) {
        CheckOut checkOut = getById(id);
        if (checkOut == null) {
            throw new BusinessException("退宿记录不存在");
        }
        return convertToVO(checkOut);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveCheckOut(CheckOutSaveDTO saveDTO) {
        // 检查学生是否存在
        Student student = studentMapper.selectById(saveDTO.getStudentId());
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        CheckOut checkOut = new CheckOut();
        BeanUtil.copyProperties(saveDTO, checkOut);

        // 填充学生冗余字段
        checkOut.setStudentName(student.getStudentName());
        checkOut.setStudentNo(student.getStudentNo());

        boolean isNew = saveDTO.getId() == null;
        
        if (isNew) {
            // 新增时先保存记录（需要获取ID）
            if (checkOut.getStatus() == null) {
                checkOut.setStatus(1); // 临时状态，后续会根据审批结果更新
            }
            save(checkOut);
            
            // 发起审批流程
            Long instanceId = approvalService.startApproval(
                "check_out",
                checkOut.getId(),
                saveDTO.getStudentId(),
                student.getStudentName()
            );
            
            if (instanceId != null) {
                // 有审批流程，状态设为"待审批"（状态1）
                checkOut.setApprovalInstanceId(instanceId);
                checkOut.setStatus(1);
                log.info("退宿申请已发起审批，申请ID：{}，审批实例ID：{}", checkOut.getId(), instanceId);
            } else {
                // 无审批流程，直接通过，状态设为"已通过"（状态2）
                checkOut.setStatus(2);
                log.info("退宿申请无需审批，直接通过，申请ID：{}", checkOut.getId());
            }
            
            return updateById(checkOut);
        } else {
            return updateById(checkOut);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteCheckOut(Long id) {
        if (id == null) {
            throw new BusinessException("退宿记录ID不能为空");
        }
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("退宿记录ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 撤回退宿申请
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelCheckOut(Long id) {
        if (id == null) {
            throw new BusinessException("退宿记录ID不能为空");
        }

        CheckOut checkOut = getById(id);
        if (checkOut == null) {
            throw new BusinessException("退宿记录不存在");
        }

        // 只有待审核状态才能撤回
        if (checkOut.getStatus() != 1) {
            throw new BusinessException("只有待审核状态的申请才能撤回");
        }

        // 更新状态为已撤回（状态5）
        checkOut.setStatus(5);
        return updateById(checkOut);
    }

    /**
     * 实体转VO
     */
    private CheckOutVO convertToVO(CheckOut checkOut) {
        CheckOutVO vo = new CheckOutVO();
        BeanUtil.copyProperties(checkOut, vo);
        vo.setStatusText(DictUtils.getLabel("check_out_status", checkOut.getStatus(), "未知"));

        // 查询校区名称
        if (StrUtil.isNotBlank(checkOut.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, checkOut.getCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        return vo;
    }
}
