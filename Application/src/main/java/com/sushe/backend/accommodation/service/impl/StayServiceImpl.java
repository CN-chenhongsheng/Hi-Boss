package com.sushe.backend.accommodation.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.accommodation.dto.stay.StayQueryDTO;
import com.sushe.backend.accommodation.dto.stay.StaySaveDTO;
import com.sushe.backend.accommodation.entity.Stay;
import com.sushe.backend.accommodation.mapper.StayMapper;
import com.sushe.backend.accommodation.service.StayService;
import com.sushe.backend.accommodation.vo.StayVO;
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
 * 留宿管理Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class StayServiceImpl extends ServiceImpl<StayMapper, Stay> implements StayService {

    private final StudentMapper studentMapper;
    private final SysCampusMapper campusMapper;
    private final SysApprovalService approvalService;

    @Override
    public PageResult<StayVO> pageList(StayQueryDTO queryDTO) {
        LambdaQueryWrapper<Stay> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), Stay::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), Stay::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, Stay::getStudentId, queryDTO.getStudentId())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), Stay::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getBedId() != null, Stay::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getStatus() != null, Stay::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, Stay::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, Stay::getApplyDate, queryDTO.getApplyDateEnd())
               .ge(queryDTO.getStayStartDateStart() != null, Stay::getStayStartDate, queryDTO.getStayStartDateStart())
               .le(queryDTO.getStayStartDateEnd() != null, Stay::getStayStartDate, queryDTO.getStayStartDateEnd())
               .orderByDesc(Stay::getCreateTime);

        Page<Stay> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<StayVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public StayVO getDetailById(Long id) {
        Stay stay = getById(id);
        if (stay == null) {
            throw new BusinessException("留宿记录不存在");
        }
        return convertToVO(stay);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveStay(StaySaveDTO saveDTO) {
        // 检查学生是否存在
        Student student = studentMapper.selectById(saveDTO.getStudentId());
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        Stay stay = new Stay();
        BeanUtil.copyProperties(saveDTO, stay);

        // 填充学生冗余字段
        stay.setStudentName(student.getStudentName());
        stay.setStudentNo(student.getStudentNo());

        boolean isNew = saveDTO.getId() == null;
        
        if (isNew) {
            // 新增时先保存记录（需要获取ID）
            if (stay.getStatus() == null) {
                stay.setStatus(1); // 临时状态，后续会根据审批结果更新
            }
            save(stay);
            
            // 发起审批流程
            Long instanceId = approvalService.startApproval(
                "stay",
                stay.getId(),
                saveDTO.getStudentId(),
                student.getStudentName()
            );
            
            if (instanceId != null) {
                // 有审批流程，状态设为"待审批"（状态1）
                stay.setApprovalInstanceId(instanceId);
                stay.setStatus(1);
                log.info("留宿申请已发起审批，申请ID：{}，审批实例ID：{}", stay.getId(), instanceId);
            } else {
                // 无审批流程，直接通过，状态设为"已通过"（状态2）
                stay.setStatus(2);
                log.info("留宿申请无需审批，直接通过，申请ID：{}", stay.getId());
            }
            
            return updateById(stay);
        } else {
            return updateById(stay);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteStay(Long id) {
        if (id == null) {
            throw new BusinessException("留宿记录ID不能为空");
        }
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("留宿记录ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 撤回留宿申请
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelStay(Long id) {
        if (id == null) {
            throw new BusinessException("留宿记录ID不能为空");
        }

        Stay stay = getById(id);
        if (stay == null) {
            throw new BusinessException("留宿记录不存在");
        }

        // 只有待审核状态才能撤回
        if (stay.getStatus() != 1) {
            throw new BusinessException("只有待审核状态的申请才能撤回");
        }

        // 更新状态为已撤回（状态5）
        stay.setStatus(5);
        return updateById(stay);
    }

    /**
     * 实体转VO
     */
    private StayVO convertToVO(Stay stay) {
        StayVO vo = new StayVO();
        BeanUtil.copyProperties(stay, vo);
        vo.setStatusText(DictUtils.getLabel("stay_status", stay.getStatus(), "未知"));

        // 查询校区名称
        if (StrUtil.isNotBlank(stay.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, stay.getCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        return vo;
    }
}
