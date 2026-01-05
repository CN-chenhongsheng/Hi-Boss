package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.classes.ClassQueryDTO;
import com.sushe.backend.dto.classes.ClassSaveDTO;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.mapper.SysUserMapper;
import com.sushe.backend.service.SysClassService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.ClassVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 班级Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysClassServiceImpl extends ServiceImpl<SysClassMapper, SysClass> implements SysClassService {

    private final SysMajorMapper majorMapper;
    private final SysUserMapper userMapper;

    @Override
    public PageResult<ClassVO> pageList(ClassQueryDTO queryDTO) {
        LambdaQueryWrapper<SysClass> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getClassCode()), SysClass::getClassCode, queryDTO.getClassCode())
               .like(StrUtil.isNotBlank(queryDTO.getClassName()), SysClass::getClassName, queryDTO.getClassName())
               .eq(StrUtil.isNotBlank(queryDTO.getMajorCode()), SysClass::getMajorCode, queryDTO.getMajorCode())
               .eq(StrUtil.isNotBlank(queryDTO.getGrade()), SysClass::getGrade, queryDTO.getGrade())
               .eq(queryDTO.getEnrollmentYear() != null, SysClass::getEnrollmentYear, queryDTO.getEnrollmentYear())
               .eq(queryDTO.getStatus() != null, SysClass::getStatus, queryDTO.getStatus())
               .orderByDesc(SysClass::getEnrollmentYear)
               .orderByAsc(SysClass::getId);

        Page<SysClass> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<ClassVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public ClassVO getDetailById(Long id) {
        SysClass classEntity = getById(id);
        if (classEntity == null) {
            throw new BusinessException("班级不存在");
        }
        return convertToVO(classEntity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveClass(ClassSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysClass> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysClass::getClassCode, saveDTO.getClassCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysClass::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("班级编码已存在");
        }

        // 检查专业是否存在
        LambdaQueryWrapper<SysMajor> majorWrapper = new LambdaQueryWrapper<>();
        majorWrapper.eq(SysMajor::getMajorCode, saveDTO.getMajorCode());
        if (majorMapper.selectCount(majorWrapper) == 0) {
            throw new BusinessException("所属专业不存在");
        }

        SysClass classEntity = new SysClass();
        BeanUtil.copyProperties(saveDTO, classEntity);

        // 根据 teacherId 查询用户信息，填充 teacherName
        if (saveDTO.getTeacherId() != null) {
            SysUser user = userMapper.selectById(saveDTO.getTeacherId());
            if (user == null) {
                throw new BusinessException("负责人不存在");
            }
            // 优先使用 nickname，如果没有则使用 username
            classEntity.setTeacherName(StrUtil.isNotBlank(user.getNickname()) ? user.getNickname() : user.getUsername());
        } else {
            // 如果没有 teacherId，清空 teacherName
            classEntity.setTeacherName(null);
        }

        if (saveDTO.getId() == null) {
            classEntity.setCurrentCount(classEntity.getCurrentCount() != null ? classEntity.getCurrentCount() : 0);
            // 新增时默认状态为启用
            if (classEntity.getStatus() == null) {
                classEntity.setStatus(1);
            }
            return save(classEntity);
        } else {
            return updateById(classEntity);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteClass(Long id) {
        if (id == null) {
            throw new BusinessException("班级ID不能为空");
        }
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("班级ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysClass classEntity = getById(id);
        if (classEntity == null) {
            throw new BusinessException("班级不存在");
        }

        // 如果要启用班级，需要检查所属专业是否启用
        if (status == 1 && StrUtil.isNotBlank(classEntity.getMajorCode())) {
            LambdaQueryWrapper<SysMajor> majorWrapper = new LambdaQueryWrapper<>();
            majorWrapper.eq(SysMajor::getMajorCode, classEntity.getMajorCode());
            SysMajor major = majorMapper.selectOne(majorWrapper);
            if (major != null && major.getStatus() != null && major.getStatus() == 0) {
                throw new BusinessException("该专业处于停用状态，不允许启用班级");
            }
        }

        classEntity.setStatus(status);
        return updateById(classEntity);
    }

    /**
     * 实体转VO
     */
    private ClassVO convertToVO(SysClass classEntity) {
        ClassVO vo = new ClassVO();
        BeanUtil.copyProperties(classEntity, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", classEntity.getStatus(), "未知"));

        // 查询专业名称
        if (StrUtil.isNotBlank(classEntity.getMajorCode())) {
            LambdaQueryWrapper<SysMajor> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysMajor::getMajorCode, classEntity.getMajorCode());
            SysMajor major = majorMapper.selectOne(wrapper);
            if (major != null) {
                vo.setMajorName(major.getMajorName());
            }
        }

        // teacherName 和 teacherId 已经通过 BeanUtil.copyProperties 复制，无需额外处理

        return vo;
    }
}

