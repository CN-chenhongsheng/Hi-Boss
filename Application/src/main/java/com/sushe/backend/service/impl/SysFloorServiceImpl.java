package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.floor.FloorQueryDTO;
import com.sushe.backend.dto.floor.FloorSaveDTO;
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.service.SysFloorService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.FloorVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 楼层Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysFloorServiceImpl extends ServiceImpl<SysFloorMapper, SysFloor> implements SysFloorService {

    private final SysRoomMapper roomMapper;
    private final SysBedMapper bedMapper;
    private final SysCampusMapper campusMapper;

    @Override
    public PageResult<FloorVO> pageList(FloorQueryDTO queryDTO) {
        LambdaQueryWrapper<SysFloor> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getFloorCode()), SysFloor::getFloorCode, queryDTO.getFloorCode())
               .like(StrUtil.isNotBlank(queryDTO.getFloorName()), SysFloor::getFloorName, queryDTO.getFloorName())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysFloor::getCampusCode, queryDTO.getCampusCode())
               .eq(queryDTO.getGenderType() != null, SysFloor::getGenderType, queryDTO.getGenderType())
               .eq(queryDTO.getStatus() != null, SysFloor::getStatus, queryDTO.getStatus())
               .orderByAsc(SysFloor::getSort)
               .orderByAsc(SysFloor::getId);

        Page<SysFloor> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<FloorVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public FloorVO getDetailById(Long id) {
        SysFloor floor = getById(id);
        if (floor == null) {
            throw new BusinessException("楼层不存在");
        }
        return convertToVO(floor);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveFloor(FloorSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysFloor> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysFloor::getFloorCode, saveDTO.getFloorCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysFloor::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("楼层编码已存在");
        }


        SysFloor floor = new SysFloor();
        BeanUtil.copyProperties(saveDTO, floor);

        if (saveDTO.getId() == null) {
            floor.setStatus(floor.getStatus() != null ? floor.getStatus() : 1);
            floor.setSort(floor.getSort() != null ? floor.getSort() : 0);
            floor.setTotalRooms(0);
            floor.setTotalBeds(0);
            floor.setCurrentOccupancy(0);
            return save(floor);
        } else {
            return updateById(floor);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteFloor(Long id) {
        if (id == null) {
            throw new BusinessException("楼层ID不能为空");
        }

        SysFloor floor = getById(id);
        if (floor == null) {
            throw new BusinessException("楼层不存在");
        }

        // ========== 级联删除房间、床位 ==========
        // 查询所有属于该楼层的房间
        LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(SysRoom::getFloorId, id);
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

        // 删除当前楼层
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("楼层ID不能为空");
        }

        // 批量删除时，对每个ID调用单个删除方法，确保级联删除逻辑被执行
        for (Long id : ids) {
            deleteFloor(id);
        }
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysFloor floor = getById(id);
        if (floor == null) {
            throw new BusinessException("楼层不存在");
        }

        // 如果要启用楼层，需要检查所属校区是否启用
        if (status == 1 && StrUtil.isNotBlank(floor.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> campusWrapper = new LambdaQueryWrapper<>();
            campusWrapper.eq(SysCampus::getCampusCode, floor.getCampusCode());
            SysCampus campus = campusMapper.selectOne(campusWrapper);
            if (campus != null && campus.getStatus() != null && campus.getStatus() == 0) {
                throw new BusinessException("该校区处于停用状态，不允许启用楼层");
            }
        }

        floor.setStatus(status);
        boolean result = updateById(floor);

        // 如果状态改为停用（0），则级联停用该楼层下的所有房间和床位
        if (status == 0) {
            // 查询所有属于该楼层的房间ID
            LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
            roomWrapper.eq(SysRoom::getFloorId, id);
            List<SysRoom> rooms = roomMapper.selectList(roomWrapper);
            List<Long> roomIds = rooms.stream()
                    .map(SysRoom::getId)
                    .collect(Collectors.toList());

            // 级联停用所有房间
            if (!roomIds.isEmpty()) {
                SysRoom roomUpdate = new SysRoom();
                roomUpdate.setStatus(0);
                roomMapper.update(roomUpdate, roomWrapper);

                // 级联停用所有床位
                LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
                bedWrapper.in(SysBed::getRoomId, roomIds);
                SysBed bedUpdate = new SysBed();
                bedUpdate.setStatus(0);
                bedMapper.update(bedUpdate, bedWrapper);
            }
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private FloorVO convertToVO(SysFloor floor) {
        FloorVO vo = new FloorVO();
        BeanUtil.copyProperties(floor, vo);
        vo.setStatusText(DictUtils.getLabel("sys_common_status", floor.getStatus(), "未知"));

        // 查询校区名称
        if (floor.getCampusCode() != null) {
            com.sushe.backend.entity.SysCampus campus = campusMapper.selectByCampusCode(floor.getCampusCode());
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        // 性别类型文本映射（使用字典）
        vo.setGenderTypeText(DictUtils.getLabel("dormitory_gender_type", floor.getGenderType(), "未知"));

        return vo;
    }

    /**
     * 检查楼层是否被房间关联
     * 
     * @param floorId 楼层ID
     * @return true-有房间关联，false-无房间关联
     */
    public boolean checkFloorHasRooms(Long floorId) {
        if (floorId == null) {
            return false;
        }
        LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(SysRoom::getFloorId, floorId);
        long roomCount = roomMapper.selectCount(roomWrapper);
        return roomCount > 0;
    }
}

