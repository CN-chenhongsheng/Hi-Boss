package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.campus.CampusQueryDTO;
import com.sushe.backend.dto.campus.CampusSaveDTO;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.service.SysCampusService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.CampusVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 校区Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysCampusServiceImpl extends ServiceImpl<SysCampusMapper, SysCampus> implements SysCampusService {

    private final SysDepartmentMapper departmentMapper;
    private final SysMajorMapper majorMapper;
    private final SysClassMapper classMapper;

    @Override
    public PageResult<CampusVO> pageList(CampusQueryDTO queryDTO) {
        LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysCampus::getCampusCode, queryDTO.getCampusCode())
               .like(StrUtil.isNotBlank(queryDTO.getCampusName()), SysCampus::getCampusName, queryDTO.getCampusName())
               .eq(queryDTO.getStatus() != null, SysCampus::getStatus, queryDTO.getStatus())
               .orderByAsc(SysCampus::getSort)
               .orderByAsc(SysCampus::getId);

        Page<SysCampus> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<CampusVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public List<CampusVO> treeList(CampusQueryDTO queryDTO) {
        LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysCampus::getCampusCode, queryDTO.getCampusCode())
               .like(StrUtil.isNotBlank(queryDTO.getCampusName()), SysCampus::getCampusName, queryDTO.getCampusName())
               .eq(queryDTO.getStatus() != null, SysCampus::getStatus, queryDTO.getStatus())
               .orderByAsc(SysCampus::getSort)
               .orderByAsc(SysCampus::getId);

        List<SysCampus> allCampuses = list(wrapper);
        return allCampuses.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    @Override
    public CampusVO getDetailById(Long id) {
        SysCampus campus = getById(id);
        if (campus == null) {
            throw new BusinessException("校区不存在");
        }
        return convertToVO(campus);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveCampus(CampusSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysCampus> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysCampus::getCampusCode, saveDTO.getCampusCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysCampus::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("校区编码已存在");
        }

        SysCampus campus = new SysCampus();
        BeanUtil.copyProperties(saveDTO, campus);

        if (saveDTO.getId() == null) {
            campus.setStatus(campus.getStatus() != null ? campus.getStatus() : 1);
            campus.setSort(campus.getSort() != null ? campus.getSort() : 0);
            return save(campus);
        } else {
            return updateById(campus);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteCampus(Long id) {
        if (id == null) {
            throw new BusinessException("校区ID不能为空");
        }

        SysCampus campus = getById(id);
        if (campus == null) {
            throw new BusinessException("校区不存在");
        }

        // 查询所有属于该校区的院系
        LambdaQueryWrapper<SysDepartment> deptWrapper = new LambdaQueryWrapper<>();
        deptWrapper.eq(SysDepartment::getCampusCode, campus.getCampusCode());
        List<SysDepartment> departments = departmentMapper.selectList(deptWrapper);

        // 获取这些院系的编码列表
        List<String> deptCodes = departments.stream()
                .map(SysDepartment::getDeptCode)
                .collect(Collectors.toList());

        if (!deptCodes.isEmpty()) {
            // 查询所有属于这些院系的专业
            LambdaQueryWrapper<SysMajor> majorWrapper = new LambdaQueryWrapper<>();
            majorWrapper.in(SysMajor::getDeptCode, deptCodes);
            List<SysMajor> majors = majorMapper.selectList(majorWrapper);

            // 获取这些专业的所有编码
            List<String> majorCodes = majors.stream()
                    .map(SysMajor::getMajorCode)
                    .collect(Collectors.toList());

            if (!majorCodes.isEmpty()) {
                // 删除所有属于这些专业的班级
                LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
                classWrapper.in(SysClass::getMajorCode, majorCodes);
                classMapper.delete(classWrapper);
            }

            // 删除所有专业
            majorMapper.delete(majorWrapper);

            // 删除所有院系
            departmentMapper.delete(deptWrapper);
        }

        // 删除当前校区
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("校区ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    /**
     * 更新校区状态
     * 如果状态改为关闭，则级联关闭该校区下的所有院系、专业、班级
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysCampus campus = getById(id);
        if (campus == null) {
            throw new BusinessException("校区不存在");
        }

        campus.setStatus(status);
        boolean result = updateById(campus);

        // 如果状态改为关闭（0），则级联关闭下级数据
        if (status == 0) {
            // 更新所有属于该校区的院系状态（批量更新）
            LambdaQueryWrapper<SysDepartment> deptWrapper = new LambdaQueryWrapper<>();
            deptWrapper.eq(SysDepartment::getCampusCode, campus.getCampusCode());
            SysDepartment deptUpdate = new SysDepartment();
            deptUpdate.setStatus(0);
            departmentMapper.update(deptUpdate, deptWrapper);

            // 重新查询更新后的院系列表，用于后续级联更新
            List<SysDepartment> departments = departmentMapper.selectList(deptWrapper);

            // 获取这些院系的编码列表
            List<String> deptCodes = departments.stream()
                    .map(SysDepartment::getDeptCode)
                    .collect(Collectors.toList());

            if (!deptCodes.isEmpty()) {
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
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private CampusVO convertToVO(SysCampus campus) {
        CampusVO vo = new CampusVO();
        BeanUtil.copyProperties(campus, vo);
        vo.setStatusText(DictUtils.getLabel("sys_user_status", campus.getStatus(), "未知"));
        return vo;
    }
}

