package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.department.DepartmentQueryDTO;
import com.sushe.backend.dto.department.DepartmentSaveDTO;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.service.SysDepartmentService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.DepartmentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 院系Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysDepartmentServiceImpl extends ServiceImpl<SysDepartmentMapper, SysDepartment> implements SysDepartmentService {

    private final SysCampusMapper campusMapper;
    private final SysMajorMapper majorMapper;
    private final SysClassMapper classMapper;

    @Override
    public PageResult<DepartmentVO> pageList(DepartmentQueryDTO queryDTO) {
        LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getDeptCode()), SysDepartment::getDeptCode, queryDTO.getDeptCode())
               .like(StrUtil.isNotBlank(queryDTO.getDeptName()), SysDepartment::getDeptName, queryDTO.getDeptName())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysDepartment::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getStatus() != null, SysDepartment::getStatus, queryDTO.getStatus())
               .orderByAsc(SysDepartment::getId);

        Page<SysDepartment> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<DepartmentVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public List<DepartmentVO> treeList(DepartmentQueryDTO queryDTO) {
        LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getDeptCode()), SysDepartment::getDeptCode, queryDTO.getDeptCode())
               .like(StrUtil.isNotBlank(queryDTO.getDeptName()), SysDepartment::getDeptName, queryDTO.getDeptName())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysDepartment::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getStatus() != null, SysDepartment::getStatus, queryDTO.getStatus())
               .orderByAsc(SysDepartment::getId);

        List<SysDepartment> allDepartments = list(wrapper);
        List<DepartmentVO> allDeptVOs = allDepartments.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return buildDepartmentTree(allDeptVOs, null);
    }

    @Override
    public DepartmentVO getDetailById(Long id) {
        SysDepartment department = getById(id);
        if (department == null) {
            throw new BusinessException("院系不存在");
        }
        return convertToVO(department);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveDepartment(DepartmentSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysDepartment::getDeptCode, saveDTO.getDeptCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysDepartment::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("院系编码已存在");
        }

        // 检查校区是否存在
        LambdaQueryWrapper<SysCampus> campusWrapper = new LambdaQueryWrapper<>();
        campusWrapper.eq(SysCampus::getCampusCode, saveDTO.getCampusCode());
        if (campusMapper.selectCount(campusWrapper) == 0) {
            throw new BusinessException("所属校区不存在");
        }

        // 检查父院系是否存在
        if (StrUtil.isNotBlank(saveDTO.getParentCode())) {
            LambdaQueryWrapper<SysDepartment> parentWrapper = new LambdaQueryWrapper<>();
            parentWrapper.eq(SysDepartment::getDeptCode, saveDTO.getParentCode());
            if (saveDTO.getId() != null) {
                parentWrapper.ne(SysDepartment::getId, saveDTO.getId());
            }
            if (count(parentWrapper) == 0) {
                throw new BusinessException("上级院系不存在");
            }
        }

        SysDepartment department = new SysDepartment();
        BeanUtil.copyProperties(saveDTO, department);

        if (saveDTO.getId() == null) {
            department.setStatus(department.getStatus() != null ? department.getStatus() : 1);
            return save(department);
        } else {
            return updateById(department);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteDepartment(Long id) {
        if (id == null) {
            throw new BusinessException("院系ID不能为空");
        }

        SysDepartment department = getById(id);
        if (department == null) {
            throw new BusinessException("院系不存在");
        }

        // 检查是否有子院系
        LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysDepartment::getParentCode, department.getDeptCode());
        if (count(wrapper) > 0) {
            throw new BusinessException("存在子院系，不允许删除");
        }

        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("院系ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 构建院系树形结构
     */
    private List<DepartmentVO> buildDepartmentTree(List<DepartmentVO> allDepartments, String parentCode) {
        List<DepartmentVO> tree = new ArrayList<>();
        for (DepartmentVO dept : allDepartments) {
            String currentParentCode = dept.getParentCode();
            if ((parentCode == null && currentParentCode == null) ||
                (parentCode != null && parentCode.equals(currentParentCode))) {
                List<DepartmentVO> children = buildDepartmentTree(allDepartments, dept.getDeptCode());
                dept.setChildren(children);
                tree.add(dept);
            }
        }
        return tree;
    }

    /**
     * 更新院系状态
     * 如果状态改为关闭，则级联关闭该院系下的所有专业、班级
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysDepartment department = getById(id);
        if (department == null) {
            throw new BusinessException("院系不存在");
        }
        department.setStatus(status);
        boolean result = updateById(department);

        // 如果状态改为关闭（0），则级联关闭下级数据
        if (status == 0) {
            // 获取该院系及其所有子院系的编码列表
            List<String> deptCodes = getAllDepartmentCodes(department.getDeptCode());

            // 更新所有属于这些院系的专业状态（批量更新）
            LambdaQueryWrapper<SysMajor> majorWrapper = new LambdaQueryWrapper<>();
            majorWrapper.in(SysMajor::getDeptCode, deptCodes);
            SysMajor majorUpdate = new SysMajor();
            majorUpdate.setStatus(0);
            majorMapper.update(majorUpdate, majorWrapper);
            
            // 重新查询更新后的专业列表，用于后续级联更新
            List<SysMajor> majors = majorMapper.selectList(majorWrapper);

            // 获取这些专业的所有编码
            List<String> majorCodes = majors.stream()
                    .map(SysMajor::getMajorCode)
                    .collect(Collectors.toList());

            if (!majorCodes.isEmpty()) {
                // 更新所有属于这些专业的班级状态（批量更新）
                LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
                classWrapper.in(SysClass::getMajorCode, majorCodes);
                SysClass classUpdate = new SysClass();
                classUpdate.setStatus(0);
                classMapper.update(classUpdate, classWrapper);
            }
        }

        return result;
    }

    /**
     * 递归获取院系及其所有子院系的编码列表
     */
    private List<String> getAllDepartmentCodes(String deptCode) {
        List<String> codes = new ArrayList<>();
        codes.add(deptCode);

        LambdaQueryWrapper<SysDepartment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysDepartment::getParentCode, deptCode);
        List<SysDepartment> children = list(wrapper);

        for (SysDepartment child : children) {
            codes.addAll(getAllDepartmentCodes(child.getDeptCode()));
        }

        return codes;
    }

    /**
     * 实体转VO
     */
    private DepartmentVO convertToVO(SysDepartment department) {
        DepartmentVO vo = new DepartmentVO();
        BeanUtil.copyProperties(department, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", department.getStatus(), "未知"));

        // 查询校区名称
        if (StrUtil.isNotBlank(department.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysCampus::getCampusCode, department.getCampusCode());
            SysCampus campus = campusMapper.selectOne(wrapper);
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        return vo;
    }
}

