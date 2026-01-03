package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.room.RoomQueryDTO;
import com.sushe.backend.dto.room.RoomSaveDTO;
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.service.SysRoomService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.RoomVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 房间Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysRoomServiceImpl extends ServiceImpl<SysRoomMapper, SysRoom> implements SysRoomService {

    private final SysFloorMapper floorMapper;
    private final SysBedMapper bedMapper;

    @Override
    public PageResult<RoomVO> pageList(RoomQueryDTO queryDTO) {
        LambdaQueryWrapper<SysRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getRoomCode()), SysRoom::getRoomCode, queryDTO.getRoomCode())
               .like(StrUtil.isNotBlank(queryDTO.getRoomNumber()), SysRoom::getRoomNumber, queryDTO.getRoomNumber())
               .eq(queryDTO.getFloorId() != null, SysRoom::getFloorId, queryDTO.getFloorId())
               .eq(StrUtil.isNotBlank(queryDTO.getFloorCode()), SysRoom::getFloorCode, queryDTO.getFloorCode())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysRoom::getCampusCode, queryDTO.getCampusCode())
               .eq(StrUtil.isNotBlank(queryDTO.getRoomType()), SysRoom::getRoomType, queryDTO.getRoomType())
               .eq(queryDTO.getRoomStatus() != null, SysRoom::getRoomStatus, queryDTO.getRoomStatus())
               .eq(queryDTO.getStatus() != null, SysRoom::getStatus, queryDTO.getStatus())
               .orderByAsc(SysRoom::getSort)
               .orderByAsc(SysRoom::getId);

        Page<SysRoom> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<RoomVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public RoomVO getDetailById(Long id) {
        SysRoom room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }
        return convertToVO(room);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveRoom(RoomSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysRoom::getRoomCode, saveDTO.getRoomCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysRoom::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("房间编码已存在");
        }

        // 查询楼层信息，填充冗余字段
        SysFloor floor = floorMapper.selectById(saveDTO.getFloorId());
        if (floor == null) {
            throw new BusinessException("所属楼层不存在");
        }

        SysRoom room = new SysRoom();
        BeanUtil.copyProperties(saveDTO, room);
        
        // 自动填充冗余字段
        room.setFloorCode(floor.getFloorCode());
        room.setCampusCode(floor.getCampusCode());

        if (saveDTO.getId() == null) {
            room.setStatus(room.getStatus() != null ? room.getStatus() : 1);
            room.setSort(room.getSort() != null ? room.getSort() : 0);
            room.setBedCount(room.getBedCount() != null ? room.getBedCount() : 4);
            room.setCurrentOccupancy(0);
            room.setHasAirConditioner(room.getHasAirConditioner() != null ? room.getHasAirConditioner() : 0);
            room.setHasBathroom(room.getHasBathroom() != null ? room.getHasBathroom() : 0);
            room.setHasBalcony(room.getHasBalcony() != null ? room.getHasBalcony() : 0);
            room.setRoomStatus(room.getRoomStatus() != null ? room.getRoomStatus() : 1);
            
            boolean result = save(room);
            
            // 更新楼层统计字段
            updateFloorStatistics(room.getFloorId());
            
            return result;
        } else {
            // 编辑时，如果楼层ID发生变化，需要更新统计字段
            SysRoom oldRoom = getById(room.getId());
            boolean result = updateById(room);
            if (result && oldRoom != null && !oldRoom.getFloorId().equals(room.getFloorId())) {
                // 更新旧楼层的统计字段
                updateFloorStatistics(oldRoom.getFloorId());
                // 更新新楼层的统计字段
                updateFloorStatistics(room.getFloorId());
            } else if (result) {
                // 楼层ID未变化，只更新当前楼层统计字段
                updateFloorStatistics(room.getFloorId());
            }
            return result;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteRoom(Long id) {
        if (id == null) {
            throw new BusinessException("房间ID不能为空");
        }

        SysRoom room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // 检查是否存在床位
        LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(SysBed::getRoomId, id);
        long bedCount = bedMapper.selectCount(bedWrapper);
        if (bedCount > 0) {
            throw new BusinessException("该房间下存在床位，无法删除");
        }

        boolean result = removeById(id);
        
        // 更新楼层统计字段
        if (result && room.getFloorId() != null) {
            updateFloorStatistics(room.getFloorId());
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("房间ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysRoom room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        room.setStatus(status);
        boolean result = updateById(room);

        // 如果状态改为停用（0），则级联更新该房间下所有床位状态为停用
        if (status == 0) {
            LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
            bedWrapper.eq(SysBed::getRoomId, id);
            SysBed bedUpdate = new SysBed();
            bedUpdate.setStatus(0);
            bedMapper.update(bedUpdate, bedWrapper);
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private RoomVO convertToVO(SysRoom room) {
        RoomVO vo = new RoomVO();
        BeanUtil.copyProperties(room, vo);
        vo.setStatusText(DictUtils.getLabel("sys_common_status", room.getStatus(), "未知"));
        vo.setRoomTypeText(DictUtils.getLabel("dormitory_room_type", room.getRoomType(), "未知"));
        vo.setRoomStatusText(DictUtils.getLabel("dormitory_room_status", room.getRoomStatus(), "未知"));
        
        // 查询楼层信息填充楼层名称
        if (room.getFloorId() != null) {
            SysFloor floor = floorMapper.selectById(room.getFloorId());
            if (floor != null) {
                vo.setFloorName(floor.getFloorName());
            }
        }
        
        return vo;
    }

    /**
     * 更新楼层统计字段
     */
    private void updateFloorStatistics(Long floorId) {
        if (floorId == null) {
            return;
        }
        
        // 统计该楼层的房间数和床位数
        LambdaQueryWrapper<SysRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(SysRoom::getFloorId, floorId);
        long totalRooms = count(roomWrapper);
        
        // 统计该楼层所有房间的床位数
        List<SysRoom> rooms = list(roomWrapper);
        int totalBeds = rooms.stream()
                .mapToInt(room -> room.getBedCount() != null ? room.getBedCount() : 0)
                .sum();
        
        // 统计该楼层所有床位的入住人数
        LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(SysBed::getFloorId, floorId)
                   .eq(SysBed::getBedStatus, 2); // 2-已占用
        long currentOccupancy = bedMapper.selectCount(bedWrapper);
        
        // 更新楼层统计字段
        SysFloor floor = floorMapper.selectById(floorId);
        if (floor != null) {
            floor.setTotalRooms((int) totalRooms);
            floor.setTotalBeds(totalBeds);
            floor.setCurrentOccupancy((int) currentOccupancy);
            floorMapper.updateById(floor);
        }
    }
}

