package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.major.MajorQueryDTO;
import com.sushe.backend.dto.major.MajorSaveDTO;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.service.SysMajorService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.MajorVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 专业Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysMajorServiceImpl extends ServiceImpl<SysMajorMapper, SysMajor> implements SysMajorService {

    private final SysDepartmentMapper departmentMapper;
    private final SysClassMapper classMapper;

    @Override
    public PageResult<MajorVO> pageList(MajorQueryDTO queryDTO) {
        LambdaQueryWrapper<SysMajor> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getMajorCode()), SysMajor::getMajorCode, queryDTO.getMajorCode())
               .like(StrUtil.isNotBlank(queryDTO.getMajorName()), SysMajor::getMajorName, queryDTO.getMajorName())
               .eq(StrUtil.isNotBlank(queryDTO.getDeptCode()), SysMajor::getDeptCode, queryDTO.getDeptCode())
               .eq(queryDTO.getStatus() != null, SysMajor::getStatus, queryDTO.getStatus())
               .orderByAsc(SysMajor::getId);

        Page<SysMajor> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<MajorVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public MajorVO getDetailById(Long id) {
        SysMajor major = getById(id);
        if (major == null) {
            throw new BusinessException("专业不存在");
        }
        return convertToVO(major);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveMajor(MajorSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysMajor> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysMajor::getMajorCode, saveDTO.getMajorCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysMajor::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("专业编码已存在");
        }

        // 检查院系是否存在
        LambdaQueryWrapper<SysDepartment> deptWrapper = new LambdaQueryWrapper<>();
        deptWrapper.eq(SysDepartment::getDeptCode, saveDTO.getDeptCode());
        if (departmentMapper.selectCount(deptWrapper) == 0) {
            throw new BusinessException("所属院系不存在");
        }

        SysMajor major = new SysMajor();
        BeanUtil.copyProperties(saveDTO, major);

        if (saveDTO.getId() == null) {
            // 新增时默认状态为启用
            if (major.getStatus() == null) {
                major.setStatus(1);
            }
            return save(major);
        } else {
            return updateById(major);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteMajor(Long id) {
        if (id == null) {
            throw new BusinessException("专业ID不能为空");
        }

        SysMajor major = getById(id);
        if (major == null) {
            throw new BusinessException("专业不存在");
        }

        // 删除所有属于该专业的班级
        LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
        classWrapper.eq(SysClass::getMajorCode, major.getMajorCode());
        classMapper.delete(classWrapper);

        // 删除专业
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("专业ID不能为空");
        }

        // 查询所有要删除的专业
        List<SysMajor> majors = listByIds(Arrays.asList(ids));
        List<String> majorCodes = majors.stream()
                .map(SysMajor::getMajorCode)
                .collect(Collectors.toList());

        if (!majorCodes.isEmpty()) {
            // 删除所有属于这些专业的班级
            LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
            classWrapper.in(SysClass::getMajorCode, majorCodes);
            classMapper.delete(classWrapper);
        }

        // 删除专业
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 更新专业状态
     * 如果状态改为关闭，则级联关闭该专业下的所有班级
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysMajor major = getById(id);
        if (major == null) {
            throw new BusinessException("专业不存在");
        }

        // 如果要启用专业，需要检查所属院系是否启用
        if (status == 1 && StrUtil.isNotBlank(major.getDeptCode())) {
            LambdaQueryWrapper<SysDepartment> deptWrapper = new LambdaQueryWrapper<>();
            deptWrapper.eq(SysDepartment::getDeptCode, major.getDeptCode());
            SysDepartment department = departmentMapper.selectOne(deptWrapper);
            if (department != null && department.getStatus() != null && department.getStatus() == 0) {
                throw new BusinessException("该院系处于停用状态，不允许启用专业");
            }
        }

        major.setStatus(status);
        boolean result = updateById(major);

        // 如果状态改为关闭（0），则级联关闭下级数据
        if (status == 0) {
            // 更新所有属于该专业的班级状态（批量更新）
            LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
            classWrapper.eq(SysClass::getMajorCode, major.getMajorCode());
            SysClass classUpdate = new SysClass();
            classUpdate.setStatus(0);
            classMapper.update(classUpdate, classWrapper);
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private MajorVO convertToVO(SysMajor major) {
        MajorVO vo = new MajorVO();
        BeanUtil.copyProperties(major, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", major.getStatus(), "未知"));

        // 学位类型文本（从字典获取）
        if (StrUtil.isNotBlank(major.getType())) {
            vo.setTypeText(DictUtils.getLabel("degree_type", major.getType(), "未知"));
        }

        // 查询院系名称
        if (StrUtil.isNotBlank(major.getDeptCode())) {
            LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysDepartment::getDeptCode, major.getDeptCode());
            SysDepartment department = departmentMapper.selectOne(wrapper);
            if (department != null) {
                vo.setDeptName(department.getDeptName());
            }
        }

        return vo;
    }
}

