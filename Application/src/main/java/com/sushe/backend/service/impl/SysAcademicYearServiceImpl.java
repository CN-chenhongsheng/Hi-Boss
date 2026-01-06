package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.academicyear.AcademicYearQueryDTO;
import com.sushe.backend.dto.academicyear.AcademicYearSaveDTO;
import com.sushe.backend.dto.academicyear.SemesterSaveDTO;
import com.sushe.backend.entity.SysAcademicYear;
import com.sushe.backend.entity.SysSemester;
import com.sushe.backend.mapper.SysAcademicYearMapper;
import com.sushe.backend.mapper.SysSemesterMapper;
import com.sushe.backend.service.SysAcademicYearService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.AcademicYearVO;
import com.sushe.backend.vo.SemesterVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 学年Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysAcademicYearServiceImpl extends ServiceImpl<SysAcademicYearMapper, SysAcademicYear> implements SysAcademicYearService {

    private final SysSemesterMapper semesterMapper;

    @Override
    public PageResult<AcademicYearVO> pageList(AcademicYearQueryDTO queryDTO) {
        LambdaQueryWrapper<SysAcademicYear> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getYearCode()), SysAcademicYear::getYearCode, queryDTO.getYearCode())
               .like(StrUtil.isNotBlank(queryDTO.getYearName()), SysAcademicYear::getYearName, queryDTO.getYearName())
               .eq(queryDTO.getStatus() != null, SysAcademicYear::getStatus, queryDTO.getStatus())
               .orderByDesc(SysAcademicYear::getStartDate)
               .orderByDesc(SysAcademicYear::getId);

        Page<SysAcademicYear> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<AcademicYearVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public AcademicYearVO getDetailById(Long id) {
        SysAcademicYear academicYear = getById(id);
        if (academicYear == null) {
            throw new BusinessException("学年不存在");
        }
        return convertToVO(academicYear);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveAcademicYear(AcademicYearSaveDTO saveDTO) {
        // 验证日期范围
        if (saveDTO.getStartDate() != null && saveDTO.getEndDate() != null) {
            if (saveDTO.getStartDate().isAfter(saveDTO.getEndDate())) {
                throw new BusinessException("开始日期不能晚于结束日期");
            }
        }

        // 检查编码是否重复
        LambdaQueryWrapper<SysAcademicYear> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysAcademicYear::getYearCode, saveDTO.getYearCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysAcademicYear::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("学年编码已存在");
        }

        // 验证学期日期是否在学年日期范围内
        if (saveDTO.getSemesters() != null && !saveDTO.getSemesters().isEmpty()) {
            LocalDate yearStartDate = saveDTO.getStartDate();
            LocalDate yearEndDate = saveDTO.getEndDate();
            for (SemesterSaveDTO semester : saveDTO.getSemesters()) {
                if (semester.getStartDate() != null && semester.getEndDate() != null) {
                    if (semester.getStartDate().isAfter(semester.getEndDate())) {
                        throw new BusinessException("学期开始日期不能晚于结束日期");
                    }
                    if (yearStartDate != null && semester.getStartDate().isBefore(yearStartDate)) {
                        throw new BusinessException("学期开始日期不能早于学年开始日期");
                    }
                    if (yearEndDate != null && semester.getEndDate().isAfter(yearEndDate)) {
                        throw new BusinessException("学期结束日期不能晚于学年结束日期");
                    }
                }
            }
        }

        // 保存或更新学年
        SysAcademicYear academicYear = new SysAcademicYear();
        BeanUtil.copyProperties(saveDTO, academicYear);

        if (saveDTO.getId() == null) {
            // 新增
            academicYear.setStatus(academicYear.getStatus() != null ? academicYear.getStatus() : 1);
            save(academicYear);
        } else {
            // 更新
            updateById(academicYear);
        }

        // 处理学期数据
        if (saveDTO.getSemesters() != null) {
            // 如果是编辑，先删除旧的学期数据
            if (saveDTO.getId() != null) {
                LambdaQueryWrapper<SysSemester> semesterWrapper = new LambdaQueryWrapper<>();
                semesterWrapper.eq(SysSemester::getAcademicYearId, academicYear.getId());
                semesterMapper.delete(semesterWrapper);
            }

            // 保存新的学期数据
            for (SemesterSaveDTO semesterDTO : saveDTO.getSemesters()) {
                // 检查学期编码是否重复（在同一学年内）
                LambdaQueryWrapper<SysSemester> semesterCodeWrapper = new LambdaQueryWrapper<>();
                semesterCodeWrapper.eq(SysSemester::getSemesterCode, semesterDTO.getSemesterCode())
                                  .eq(SysSemester::getAcademicYearId, academicYear.getId());
                if (semesterMapper.selectCount(semesterCodeWrapper) > 0) {
                    throw new BusinessException("学期编码已存在：" + semesterDTO.getSemesterCode());
                }

                SysSemester semester = new SysSemester();
                BeanUtil.copyProperties(semesterDTO, semester);
                semester.setAcademicYearId(academicYear.getId());
                semesterMapper.insert(semester);
            }
        }

        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteAcademicYear(Long id) {
        if (id == null) {
            throw new BusinessException("学年ID不能为空");
        }

        SysAcademicYear academicYear = getById(id);
        if (academicYear == null) {
            throw new BusinessException("学年不存在");
        }

        // 删除关联的学期（外键级联删除，但这里显式删除更安全）
        LambdaQueryWrapper<SysSemester> semesterWrapper = new LambdaQueryWrapper<>();
        semesterWrapper.eq(SysSemester::getAcademicYearId, id);
        semesterMapper.delete(semesterWrapper);

        // 删除学年
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("学年ID不能为空");
        }

        // 批量删除学期
        for (Long id : ids) {
            LambdaQueryWrapper<SysSemester> semesterWrapper = new LambdaQueryWrapper<>();
            semesterWrapper.eq(SysSemester::getAcademicYearId, id);
            semesterMapper.delete(semesterWrapper);
        }

        // 批量删除学年
        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysAcademicYear academicYear = getById(id);
        if (academicYear == null) {
            throw new BusinessException("学年不存在");
        }

        academicYear.setStatus(status);
        return updateById(academicYear);
    }

    /**
     * 实体转VO
     */
    private AcademicYearVO convertToVO(SysAcademicYear academicYear) {
        AcademicYearVO vo = new AcademicYearVO();
        BeanUtil.copyProperties(academicYear, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", academicYear.getStatus(), "未知"));

        // 查询关联的学期列表
        LambdaQueryWrapper<SysSemester> semesterWrapper = new LambdaQueryWrapper<>();
        semesterWrapper.eq(SysSemester::getAcademicYearId, academicYear.getId())
                      .orderByAsc(SysSemester::getStartDate);
        List<SysSemester> semesters = semesterMapper.selectList(semesterWrapper);

        List<SemesterVO> semesterVOList = semesters.stream()
                .map(this::convertSemesterToVO)
                .collect(Collectors.toList());

        vo.setSemesters(semesterVOList);

        return vo;
    }

    /**
     * 学期实体转VO
     */
    private SemesterVO convertSemesterToVO(SysSemester semester) {
        SemesterVO vo = new SemesterVO();
        BeanUtil.copyProperties(semester, vo);
        return vo;
    }
}

