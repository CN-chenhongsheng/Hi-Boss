package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.checkout.CheckOutQueryDTO;
import com.sushe.backend.dto.checkout.CheckOutSaveDTO;
import com.sushe.backend.entity.SysCheckOut;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysStudent;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysCheckOutMapper;
import com.sushe.backend.mapper.SysStudentMapper;
import com.sushe.backend.service.SysCheckOutService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.CheckOutVO;
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
public class SysCheckOutServiceImpl extends ServiceImpl<SysCheckOutMapper, SysCheckOut> implements SysCheckOutService {

    private final SysStudentMapper studentMapper;
    private final SysCampusMapper campusMapper;

    @Override
    public PageResult<CheckOutVO> pageList(CheckOutQueryDTO queryDTO) {
        LambdaQueryWrapper<SysCheckOut> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), SysCheckOut::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), SysCheckOut::getStudentName, queryDTO.getStudentName())
               .eq(queryDTO.getStudentId() != null, SysCheckOut::getStudentId, queryDTO.getStudentId())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysCheckOut::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getBedId() != null, SysCheckOut::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getStatus() != null, SysCheckOut::getStatus, queryDTO.getStatus())
               .ge(queryDTO.getApplyDateStart() != null, SysCheckOut::getApplyDate, queryDTO.getApplyDateStart())
               .le(queryDTO.getApplyDateEnd() != null, SysCheckOut::getApplyDate, queryDTO.getApplyDateEnd())
               .orderByDesc(SysCheckOut::getCreateTime);

        Page<SysCheckOut> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<CheckOutVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public CheckOutVO getDetailById(Long id) {
        SysCheckOut checkOut = getById(id);
        if (checkOut == null) {
            throw new BusinessException("退宿记录不存在");
        }
        return convertToVO(checkOut);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveCheckOut(CheckOutSaveDTO saveDTO) {
        // 检查学生是否存在
        SysStudent student = studentMapper.selectById(saveDTO.getStudentId());
        if (student == null) {
            throw new BusinessException("学生不存在");
        }

        SysCheckOut checkOut = new SysCheckOut();
        BeanUtil.copyProperties(saveDTO, checkOut);

        // 填充学生冗余字段
        checkOut.setStudentName(student.getStudentName());
        checkOut.setStudentNo(student.getStudentNo());

        if (saveDTO.getId() == null) {
            // 新增时默认状态为待审核
            if (checkOut.getStatus() == null) {
                checkOut.setStatus(1);
            }
            return save(checkOut);
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
     * 实体转VO
     */
    private CheckOutVO convertToVO(SysCheckOut checkOut) {
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

