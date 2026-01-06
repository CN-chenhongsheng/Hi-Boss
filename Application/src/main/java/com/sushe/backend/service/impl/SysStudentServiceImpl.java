package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.student.StudentQueryDTO;
import com.sushe.backend.dto.student.StudentSaveDTO;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.entity.SysStudent;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.mapper.SysStudentMapper;
import com.sushe.backend.service.SysStudentService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.StudentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 学生Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysStudentServiceImpl extends ServiceImpl<SysStudentMapper, SysStudent> implements SysStudentService {

    private final SysCampusMapper campusMapper;
    private final SysDepartmentMapper departmentMapper;
    private final SysMajorMapper majorMapper;
    private final SysClassMapper classMapper;

    @Override
    public PageResult<StudentVO> pageList(StudentQueryDTO queryDTO) {
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getStudentNo()), SysStudent::getStudentNo, queryDTO.getStudentNo())
               .like(StrUtil.isNotBlank(queryDTO.getStudentName()), SysStudent::getStudentName, queryDTO.getStudentName())
               .like(StrUtil.isNotBlank(queryDTO.getPhone()), SysStudent::getPhone, queryDTO.getPhone())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysStudent::getCampusCode, queryDTO.getCampusCode())
               .eq(StrUtil.isNotBlank(queryDTO.getDeptCode()), SysStudent::getDeptCode, queryDTO.getDeptCode())
               .eq(StrUtil.isNotBlank(queryDTO.getMajorCode()), SysStudent::getMajorCode, queryDTO.getMajorCode())
               .eq(queryDTO.getClassId() != null, SysStudent::getClassId, queryDTO.getClassId())
               .eq(queryDTO.getBedId() != null, SysStudent::getBedId, queryDTO.getBedId())
               .eq(queryDTO.getAcademicStatus() != null, SysStudent::getAcademicStatus, queryDTO.getAcademicStatus())
               .eq(queryDTO.getStatus() != null, SysStudent::getStatus, queryDTO.getStatus())
               .orderByDesc(SysStudent::getCreateTime);

        Page<SysStudent> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<StudentVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public StudentVO getDetailById(Long id) {
        SysStudent student = getById(id);
        if (student == null) {
            throw new BusinessException("学生不存在");
        }
        return convertToVO(student);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveStudent(StudentSaveDTO saveDTO) {
        // 检查学号是否重复
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysStudent::getStudentNo, saveDTO.getStudentNo());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysStudent::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("学号已存在");
        }

        SysStudent student = new SysStudent();
        BeanUtil.copyProperties(saveDTO, student);

        if (saveDTO.getId() == null) {
            // 新增时默认状态为启用
            if (student.getStatus() == null) {
                student.setStatus(1);
            }
            return save(student);
        } else {
            return updateById(student);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteStudent(Long id) {
        if (id == null) {
            throw new BusinessException("学生ID不能为空");
        }
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("学生ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 实体转VO
     */
    private StudentVO convertToVO(SysStudent student) {
        StudentVO vo = new StudentVO();
        BeanUtil.copyProperties(student, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", student.getStatus(), "未知"));
        vo.setGenderText(DictUtils.getLabel("sys_gender", student.getGender(), "未知"));
        vo.setAcademicStatusText(DictUtils.getLabel("academic_status", student.getAcademicStatus(), "未知"));

        // 查询校区名称
        if (StrUtil.isNotBlank(student.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, student.getCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        // 查询院系名称
        if (StrUtil.isNotBlank(student.getDeptCode())) {
            LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysDepartment::getDeptCode, student.getDeptCode());
            SysDepartment department = departmentMapper.selectOne(wrapper);
            if (department != null) {
                vo.setDeptName(department.getDeptName());
            }
        }

        // 查询专业名称
        if (StrUtil.isNotBlank(student.getMajorCode())) {
            LambdaQueryWrapper<SysMajor> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysMajor::getMajorCode, student.getMajorCode());
            SysMajor major = majorMapper.selectOne(wrapper);
            if (major != null) {
                vo.setMajorName(major.getMajorName());
            }
        }

        // 查询班级名称
        if (student.getClassId() != null) {
            SysClass classEntity = classMapper.selectById(student.getClassId());
            if (classEntity != null) {
                vo.setClassName(classEntity.getClassName());
            }
        }

        return vo;
    }
}

