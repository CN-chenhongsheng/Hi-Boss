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

        if (saveDTO.getId() == null) {
            // 新增时默认状态为待审核
            if (checkIn.getStatus() == null) {
                checkIn.setStatus(1);
            }
            return save(checkIn);
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

