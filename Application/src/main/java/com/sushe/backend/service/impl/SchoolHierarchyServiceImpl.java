package com.sushe.backend.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.service.SchoolHierarchyService;
import com.sushe.backend.vo.SchoolHierarchyNodeVO;
import com.sushe.backend.vo.SchoolHierarchyVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 学校层级服务实现
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SchoolHierarchyServiceImpl implements SchoolHierarchyService {

    private final SysCampusMapper campusMapper;
    private final SysDepartmentMapper departmentMapper;
    private final SysMajorMapper majorMapper;
    private final SysClassMapper classMapper;

    @Override
    public SchoolHierarchyVO getFullHierarchy() {
        // 1. 查询所有校区（只查询启用的）
        LambdaQueryWrapper<SysCampus> campusWrapper = new LambdaQueryWrapper<>();
        campusWrapper.eq(SysCampus::getStatus, 1);
        campusWrapper.orderByAsc(SysCampus::getSort);
        campusWrapper.orderByAsc(SysCampus::getId);
        List<SysCampus> allCampuses = campusMapper.selectList(campusWrapper);

        // 2. 查询所有院系（只查询启用的）
        LambdaQueryWrapper<SysDepartment> deptWrapper = new LambdaQueryWrapper<>();
        deptWrapper.eq(SysDepartment::getStatus, 1);
        deptWrapper.orderByAsc(SysDepartment::getSort);
        deptWrapper.orderByAsc(SysDepartment::getId);
        List<SysDepartment> allDepartments = departmentMapper.selectList(deptWrapper);

        // 3. 查询所有专业（只查询启用的）
        LambdaQueryWrapper<SysMajor> majorWrapper = new LambdaQueryWrapper<>();
        majorWrapper.eq(SysMajor::getStatus, 1);
        majorWrapper.orderByAsc(SysMajor::getId);
        List<SysMajor> allMajors = majorMapper.selectList(majorWrapper);

        // 4. 查询所有班级（只查询启用的）
        LambdaQueryWrapper<SysClass> classWrapper = new LambdaQueryWrapper<>();
        classWrapper.eq(SysClass::getStatus, 1);
        classWrapper.orderByAsc(SysClass::getId);
        List<SysClass> allClasses = classMapper.selectList(classWrapper);

        // 5. 按编码分组，方便查找（处理 null 值）
        Map<String, List<SysDepartment>> deptMapByCampus = allDepartments.stream()
                .filter(dept -> dept.getCampusCode() != null && !dept.getCampusCode().isEmpty())
                .collect(Collectors.groupingBy(SysDepartment::getCampusCode));

        Map<String, List<SysMajor>> majorMapByDept = allMajors.stream()
                .filter(major -> major.getDeptCode() != null && !major.getDeptCode().isEmpty())
                .collect(Collectors.groupingBy(SysMajor::getDeptCode));

        Map<String, List<SysClass>> classMapByMajor = allClasses.stream()
                .filter(cls -> cls.getMajorCode() != null && !cls.getMajorCode().isEmpty())
                .collect(Collectors.groupingBy(SysClass::getMajorCode));

        // 6. 构建校区树（只包含根校区，即parentCode为null的）
        List<SchoolHierarchyNodeVO> campusNodes = allCampuses.stream()
                .filter(campus -> campus.getParentCode() == null || campus.getParentCode().isEmpty())
                .map(campus -> buildCampusNode(campus, deptMapByCampus, majorMapByDept, classMapByMajor))
                .collect(Collectors.toList());

        SchoolHierarchyVO result = new SchoolHierarchyVO();
        result.setCampuses(campusNodes);
        return result;
    }

    /**
     * 构建校区节点
     */
    private SchoolHierarchyNodeVO buildCampusNode(
            SysCampus campus,
            Map<String, List<SysDepartment>> deptMapByCampus,
            Map<String, List<SysMajor>> majorMapByDept,
            Map<String, List<SysClass>> classMapByMajor) {
        SchoolHierarchyNodeVO node = new SchoolHierarchyNodeVO();
        node.setId(campus.getId());
        node.setCode(campus.getCampusCode());
        node.setName(campus.getCampusName());
        node.setType("campus");
        node.setParentCode(campus.getParentCode());
        node.setStatus(campus.getStatus());

        // 构建院系节点
        String campusCode = campus.getCampusCode();
        List<SysDepartment> departments = (campusCode != null && !campusCode.isEmpty())
                ? deptMapByCampus.getOrDefault(campusCode, new ArrayList<>())
                : new ArrayList<>();
        List<SchoolHierarchyNodeVO> deptNodes = departments.stream()
                .map(dept -> buildDepartmentNode(dept, majorMapByDept, classMapByMajor))
                .collect(Collectors.toList());

        if (!deptNodes.isEmpty()) {
            node.setChildren(deptNodes);
        }

        return node;
    }

    /**
     * 构建院系节点
     */
    private SchoolHierarchyNodeVO buildDepartmentNode(
            SysDepartment department,
            Map<String, List<SysMajor>> majorMapByDept,
            Map<String, List<SysClass>> classMapByMajor) {
        SchoolHierarchyNodeVO node = new SchoolHierarchyNodeVO();
        node.setId(department.getId());
        node.setCode(department.getDeptCode());
        node.setName(department.getDeptName());
        node.setType("department");
        node.setParentCode(department.getCampusCode());
        node.setStatus(department.getStatus());

        // 构建专业节点
        String deptCode = department.getDeptCode();
        List<SysMajor> majors = (deptCode != null && !deptCode.isEmpty())
                ? majorMapByDept.getOrDefault(deptCode, new ArrayList<>())
                : new ArrayList<>();
        List<SchoolHierarchyNodeVO> majorNodes = majors.stream()
                .map(major -> buildMajorNode(major, classMapByMajor))
                .collect(Collectors.toList());

        if (!majorNodes.isEmpty()) {
            node.setChildren(majorNodes);
        }

        return node;
    }

    /**
     * 构建专业节点
     */
    private SchoolHierarchyNodeVO buildMajorNode(
            SysMajor major,
            Map<String, List<SysClass>> classMapByMajor) {
        SchoolHierarchyNodeVO node = new SchoolHierarchyNodeVO();
        node.setId(major.getId());
        node.setCode(major.getMajorCode());
        node.setName(major.getMajorName());
        node.setType("major");
        node.setParentCode(major.getDeptCode());
        node.setStatus(major.getStatus());

        // 构建班级节点
        String majorCode = major.getMajorCode();
        List<SysClass> classes = (majorCode != null && !majorCode.isEmpty())
                ? classMapByMajor.getOrDefault(majorCode, new ArrayList<>())
                : new ArrayList<>();
        List<SchoolHierarchyNodeVO> classNodes = classes.stream()
                .map(this::buildClassNode)
                .collect(Collectors.toList());

        if (!classNodes.isEmpty()) {
            node.setChildren(classNodes);
        }

        return node;
    }

    /**
     * 构建班级节点
     */
    private SchoolHierarchyNodeVO buildClassNode(SysClass classEntity) {
        SchoolHierarchyNodeVO node = new SchoolHierarchyNodeVO();
        node.setId(classEntity.getId());
        node.setCode(classEntity.getClassCode());
        node.setName(classEntity.getClassName());
        node.setType("class");
        node.setParentCode(classEntity.getMajorCode());
        node.setStatus(classEntity.getStatus());
        // 班级是叶子节点，没有children
        return node;
    }
}

