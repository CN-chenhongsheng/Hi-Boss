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
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysClass;
import com.sushe.backend.entity.SysDepartment;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysMajor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysClassMapper;
import com.sushe.backend.mapper.SysDepartmentMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysMajorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.service.SysCampusService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.CampusVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    private final SysFloorMapper floorMapper;
    private final SysRoomMapper roomMapper;
    private final SysBedMapper bedMapper;

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

        // ========== 级联删除楼层、房间、床位 ==========
        // 查询所有属于该校区的楼层
        LambdaQueryWrapper<SysFloor> floorWrapper = new LambdaQueryWrapper<>();
        floorWrapper.eq(SysFloor::getCampusCode, campus.getCampusCode());
        List<SysFloor> floors = floorMapper.selectList(floorWrapper);

        // 获取所有楼层ID
        List<Long> floorIds = floors.stream()
                .map(SysFloor::getId)
                .collect(Collectors.toList());

        if (!floorIds.isEmpty()) {
            // 查询所有属于这些楼层的房间
            LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
            roomWrapper.in(SysRoom::getFloorId, floorIds);
            List<SysRoom> rooms = roomMapper.selectList(roomWrapper);

            // 获取所有房间ID
            List<Long> roomIds = rooms.stream()
                    .map(SysRoom::getId)
                    .collect(Collectors.toList());

            if (!roomIds.isEmpty()) {
                // 查询所有属于这些房间的床位
                LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
                bedWrapper.in(SysBed::getRoomId, roomIds);
                List<SysBed> beds = bedMapper.selectList(bedWrapper);

                // 处理床位的学生关联关系：清空学生关联字段，但不删除学生
                for (SysBed bed : beds) {
                    if (bed.getStudentId() != null) {
                        bed.setStudentId(null);
                        bed.setStudentName(null);
                        bed.setCheckInDate(null);
                        bed.setCheckOutDate(null);
                        bed.setBedStatus(1); // 设为空闲状态
                        bedMapper.updateById(bed);
                    }
                }

                // 删除所有床位
                bedMapper.delete(bedWrapper);
            }

            // 删除所有房间
            roomMapper.delete(roomWrapper);
        }

        // 删除所有楼层
        floorMapper.delete(floorWrapper);

        // ========== 级联删除院系、专业、班级 ==========
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
        // 批量删除时，对每个ID调用单个删除方法，确保级联删除逻辑被执行
        for (Long id : ids) {
            deleteCampus(id);
        }
        return true;
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
        if (status == 0 && StrUtil.isNotBlank(campus.getCampusCode())) {
            try {
            // ========== 级联关闭楼层、房间、床位 ==========
            // 更新所有属于该校区的楼层状态（批量更新）
            LambdaQueryWrapper<SysFloor> floorWrapper = new LambdaQueryWrapper<>();
            floorWrapper.eq(SysFloor::getCampusCode, campus.getCampusCode());
            SysFloor floorUpdate = new SysFloor();
            floorUpdate.setStatus(0);
            floorMapper.update(floorUpdate, floorWrapper);

            // 重新查询所有属于该校区的楼层ID（使用新的查询条件）
            LambdaQueryWrapper<SysFloor> floorQueryWrapper = new LambdaQueryWrapper<>();
            floorQueryWrapper.eq(SysFloor::getCampusCode, campus.getCampusCode());
            List<SysFloor> floors = floorMapper.selectList(floorQueryWrapper);
            List<Long> floorIds = floors.stream()
                    .map(SysFloor::getId)
                    .collect(Collectors.toList());

            if (!floorIds.isEmpty()) {
                // 更新所有属于这些楼层的房间状态（批量更新）
                LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
                roomWrapper.in(SysRoom::getFloorId, floorIds);
                SysRoom roomUpdate = new SysRoom();
                roomUpdate.setStatus(0);
                roomMapper.update(roomUpdate, roomWrapper);

                // 重新查询所有属于这些楼层的房间ID（使用新的查询条件）
                LambdaQueryWrapper<SysRoom> roomQueryWrapper = new LambdaQueryWrapper<>();
                roomQueryWrapper.in(SysRoom::getFloorId, floorIds);
                List<SysRoom> rooms = roomMapper.selectList(roomQueryWrapper);
                List<Long> roomIds = rooms.stream()
                        .map(SysRoom::getId)
                        .collect(Collectors.toList());

                if (!roomIds.isEmpty()) {
                    // 更新所有属于这些房间的床位状态（批量更新）
                    LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
                    bedWrapper.in(SysBed::getRoomId, roomIds);
                    SysBed bedUpdate = new SysBed();
                    bedUpdate.setStatus(0);
                    bedMapper.update(bedUpdate, bedWrapper);
                }
            }

            // ========== 级联关闭院系、专业、班级 ==========
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
            } catch (Exception e) {
                log.error("级联更新校区下级数据状态失败，校区ID：{}，校区编码：{}", id, campus.getCampusCode(), e);
                // 不抛出异常，只记录日志，确保状态更新能成功
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

