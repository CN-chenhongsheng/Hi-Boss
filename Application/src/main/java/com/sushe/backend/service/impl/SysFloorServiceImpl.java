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
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
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

import java.util.Arrays;
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

        // 编辑时，检查是否有房间关联
        if (saveDTO.getId() != null) {
            if (checkFloorHasRooms(saveDTO.getId())) {
                throw new BusinessException("该楼层下存在房间，无法编辑");
            }
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

        // 检查是否存在房间
        LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(SysRoom::getFloorId, id);
        long roomCount = roomMapper.selectCount(roomWrapper);
        if (roomCount > 0) {
            throw new BusinessException("该楼层下存在房间，无法删除");
        }

        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("楼层ID不能为空");
        }

        // 检查是否有房间关联
        for (Long id : ids) {
            if (checkFloorHasRooms(id)) {
                SysFloor floor = getById(id);
                String floorName = floor != null ? floor.getFloorName() : String.valueOf(id);
                throw new BusinessException("楼层\"" + floorName + "\"下存在房间，无法删除");
            }
        }

        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysFloor floor = getById(id);
        if (floor == null) {
            throw new BusinessException("楼层不存在");
        }

        floor.setStatus(status);
        boolean result = updateById(floor);

        // 如果状态改为停用（0），则级联更新该楼层下所有房间的状态为停用
        if (status == 0) {
            LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
            roomWrapper.eq(SysRoom::getFloorId, id);
            SysRoom roomUpdate = new SysRoom();
            roomUpdate.setStatus(0);
            roomMapper.update(roomUpdate, roomWrapper);
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

