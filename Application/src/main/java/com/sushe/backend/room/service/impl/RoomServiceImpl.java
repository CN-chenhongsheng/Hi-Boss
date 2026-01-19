package com.sushe.backend.room.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.organization.entity.Campus;
import com.sushe.backend.organization.mapper.CampusMapper;
import com.sushe.backend.room.dto.room.RoomBatchCreateDTO;
import com.sushe.backend.room.dto.room.RoomQueryDTO;
import com.sushe.backend.room.dto.room.RoomSaveDTO;
import com.sushe.backend.room.entity.Bed;
import com.sushe.backend.room.entity.Floor;
import com.sushe.backend.room.entity.Room;
import com.sushe.backend.room.mapper.BedMapper;
import com.sushe.backend.room.mapper.FloorMapper;
import com.sushe.backend.room.mapper.RoomMapper;
import com.sushe.backend.room.service.RoomService;
import com.sushe.backend.room.vo.RoomVO;
import com.sushe.backend.util.DictUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
public class RoomServiceImpl extends ServiceImpl<RoomMapper, Room> implements RoomService {

    private final FloorMapper floorMapper;
    private final BedMapper bedMapper;
    private final CampusMapper campusMapper;

    @Override
    public PageResult<RoomVO> pageList(RoomQueryDTO queryDTO) {
        LambdaQueryWrapper<Room> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getRoomCode()), Room::getRoomCode, queryDTO.getRoomCode())
               .like(StrUtil.isNotBlank(queryDTO.getRoomNumber()), Room::getRoomNumber, queryDTO.getRoomNumber())
               .eq(queryDTO.getFloorId() != null, Room::getFloorId, queryDTO.getFloorId())
               .eq(StrUtil.isNotBlank(queryDTO.getFloorCode()), Room::getFloorCode, queryDTO.getFloorCode())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), Room::getCampusCode, queryDTO.getCampusCode())
               .eq(StrUtil.isNotBlank(queryDTO.getRoomType()), Room::getRoomType, queryDTO.getRoomType())
               .eq(queryDTO.getRoomStatus() != null, Room::getRoomStatus, queryDTO.getRoomStatus())
               .eq(queryDTO.getStatus() != null, Room::getStatus, queryDTO.getStatus())
               .orderByAsc(Room::getSort)
               .orderByAsc(Room::getId);

        Page<Room> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<RoomVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public RoomVO getDetailById(Long id) {
        Room room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }
        return convertToVO(room);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveRoom(RoomSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<Room> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Room::getRoomCode, saveDTO.getRoomCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(Room::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("房间编码已存在");
        }

        // 查询楼层信息，填充冗余字段
        Floor floor = floorMapper.selectById(saveDTO.getFloorId());
        if (floor == null) {
            throw new BusinessException("所属楼层不存在");
        }

        Room room = new Room();
        BeanUtil.copyProperties(saveDTO, room);

        // 自动填充冗余字段
        room.setFloorCode(floor.getFloorCode());
        room.setCampusCode(floor.getCampusCode());
        // floorNumber 从saveDTO 中获取，如果为空则从楼层信息中获取
        if (room.getFloorNumber() == null) {
            room.setFloorNumber(floor.getFloorNumber());
        }

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
            Room oldRoom = getById(room.getId());
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

        Room room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // ========== 级联删除床位 ==========
        // 查询所有属于该房间的床位
        LambdaQueryWrapper<Bed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(Bed::getRoomId, id);
        List<Bed> beds = bedMapper.selectList(bedWrapper);

        // 处理床位的学生关联关系：清空学生关联字段，但不删除学生
        for (Bed bed : beds) {
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

        // 删除当前房间
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

        // 批量删除时，对每个ID调用单个删除方法，确保级联删除逻辑被执行
        for (Long id : ids) {
            deleteRoom(id);
        }
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        Room room = getById(id);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // 如果要启用房间，需要检查所属楼层是否启用
        if (status == 1 && room.getFloorId() != null) {
            Floor floor = floorMapper.selectById(room.getFloorId());
            if (floor != null && floor.getStatus() != null && floor.getStatus() == 0) {
                throw new BusinessException("该楼层处于停用状态，不允许启用房间");
            }
        }

        room.setStatus(status);
        boolean result = updateById(room);

        // 如果状态改为停用（0），则级联更新该房间下所有床位状态为停用
        if (status == 0) {
            LambdaQueryWrapper<Bed> bedWrapper = new LambdaQueryWrapper<>();
            bedWrapper.eq(Bed::getRoomId, id);
            Bed bedUpdate = new Bed();
            bedUpdate.setStatus(0);
            bedMapper.update(bedUpdate, bedWrapper);
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private RoomVO convertToVO(Room room) {
        RoomVO vo = new RoomVO();
        BeanUtil.copyProperties(room, vo);
        vo.setStatusText(DictUtils.getLabel("sys_common_status", room.getStatus(), "未知"));
        vo.setRoomTypeText(DictUtils.getLabel("dormitory_room_type", room.getRoomType(), "未知"));
        vo.setRoomStatusText(DictUtils.getLabel("dormitory_room_status", room.getRoomStatus(), "未知"));

        // 查询楼层信息填充楼层名称
        if (room.getFloorId() != null) {
            Floor floor = floorMapper.selectById(room.getFloorId());
            if (floor != null) {
                vo.setFloorName(floor.getFloorName());
            }
        }

        // 查询校区信息填充校区名称
        if (StrUtil.isNotBlank(room.getCampusCode())) {
            Campus campus = campusMapper.selectByCampusCode(room.getCampusCode());
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        // 查询该房间下的床位数
        LambdaQueryWrapper<Bed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(Bed::getRoomId, room.getId());
        long bedCount = bedMapper.selectCount(bedWrapper);
        vo.setTotalBeds((int) bedCount);

        // floorNumber 已经从BeanUtil.copyProperties 中复制了

        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int batchCreateRooms(RoomBatchCreateDTO dto) {
        // 验证楼层是否存在
        Floor floor = floorMapper.selectById(dto.getFloorId());
        if (floor == null) {
            throw new BusinessException("所属楼层不存在");
        }

        // 验证楼层数是否超出楼层的最大层数
        int maxFloorNumber = floor.getFloorNumber() != null ? floor.getFloorNumber() : 1;
        for (Integer floorNum : dto.getFloorNumbers()) {
            if (floorNum > maxFloorNumber) {
                throw new BusinessException("楼层" + floorNum + " 超出该楼最大层数" + maxFloorNumber);
            }
        }

        // 查询该楼层每个楼层数已有房间的最大序号
        Map<Integer, Integer> maxSeqMap = new HashMap<>();
        for (Integer floorNum : dto.getFloorNumbers()) {
            // 查询该楼层数下所有房间编码，找出最大序号
            LambdaQueryWrapper<Room> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Room::getFloorId, dto.getFloorId())
                   .eq(Room::getFloorNumber, floorNum);
            List<Room> existingRooms = list(wrapper);

            int maxSeq = 0;
            for (Room existingRoom : existingRooms) {
                String roomCode = existingRoom.getRoomCode();
                if (roomCode != null && roomCode.length() >= 3) {
                    try {
                        // 尝试解析最后两位作为序号
                        int seq = Integer.parseInt(roomCode.substring(roomCode.length() - 2));
                        maxSeq = Math.max(maxSeq, seq);
                    } catch (NumberFormatException e) {
                        // 忽略解析失败的编码
                    }
                }
            }
            maxSeqMap.put(floorNum, maxSeq);
        }

        // 获取当前最大排序号
        LambdaQueryWrapper<Room> sortWrapper = new LambdaQueryWrapper<>();
        sortWrapper.eq(Room::getFloorId, dto.getFloorId())
                   .orderByDesc(Room::getSort)
                   .last("LIMIT 1");
        Room lastRoom = getOne(sortWrapper);
        int currentSort = lastRoom != null && lastRoom.getSort() != null ? lastRoom.getSort() : 0;

        // 批量生成房间
        List<Room> roomsToCreate = new ArrayList<>();
        List<Integer> sortedFloorNumbers = new ArrayList<>(dto.getFloorNumbers());
        Collections.sort(sortedFloorNumbers);

        for (Integer floorNum : sortedFloorNumbers) {
            int startSeq = maxSeqMap.get(floorNum) + 1;

            for (int i = 0; i < dto.getGenerateCount(); i++) {
                int seq = startSeq + i;
                // 生成房间编码：楼层数 * 100 + 序号，如 1层第1个房间= 101
                String roomCode = String.valueOf(floorNum * 100 + seq);
                String roomNumber = roomCode; // 房间号与编码相同

                // 检查编码是否已存在
                LambdaQueryWrapper<Room> checkWrapper = new LambdaQueryWrapper<>();
                checkWrapper.eq(Room::getRoomCode, roomCode);
                if (count(checkWrapper) > 0) {
                    throw new BusinessException("房间编码 " + roomCode + " 已存在");
                }

                Room room = new Room();
                room.setRoomCode(roomCode);
                room.setRoomNumber(roomNumber);
                room.setFloorId(dto.getFloorId());
                room.setFloorCode(floor.getFloorCode());
                room.setCampusCode(floor.getCampusCode());
                room.setFloorNumber(floorNum);
                room.setRoomType(dto.getRoomType());
                room.setRoomStatus(dto.getRoomStatus() != null ? dto.getRoomStatus() : 1);
                room.setBedCount(dto.getBedCount() != null ? dto.getBedCount() : 4);
                room.setArea(dto.getArea());
                room.setMaxOccupancy(dto.getMaxOccupancy());
                room.setStatus(dto.getStatus() != null ? dto.getStatus() : 1);
                room.setHasAirConditioner(dto.getHasAirConditioner() != null ? dto.getHasAirConditioner() : 0);
                room.setHasBathroom(dto.getHasBathroom() != null ? dto.getHasBathroom() : 0);
                room.setHasBalcony(dto.getHasBalcony() != null ? dto.getHasBalcony() : 0);
                room.setRemark(dto.getRemark());
                room.setCurrentOccupancy(0);
                room.setSort(++currentSort);

                roomsToCreate.add(room);
            }
        }

        // 批量插入
        boolean result = saveBatch(roomsToCreate);

        // 更新楼层统计字段
        if (result) {
            updateFloorStatistics(dto.getFloorId());
        }

        return roomsToCreate.size();
    }

    /**
     * 检查房间是否被床位关联
     * 
     * @param roomId 房间ID
     * @return true-有床位关联，false-无床位关联
     */
    public boolean checkRoomHasBeds(Long roomId) {
        if (roomId == null) {
            return false;
        }
        LambdaQueryWrapper<Bed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(Bed::getRoomId, roomId);
        long bedCount = bedMapper.selectCount(bedWrapper);
        return bedCount > 0;
    }

    /**
     * 更新楼层统计字段
     */
    private void updateFloorStatistics(Long floorId) {
        if (floorId == null) {
            return;
        }

        // 统计该楼层的房间数和床位数
        LambdaQueryWrapper<Room> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(Room::getFloorId, floorId);
        long totalRooms = count(roomWrapper);

        // 统计该楼层所有房间的床位数
        List<Room> rooms = list(roomWrapper);
        int totalBeds = rooms.stream()
                .mapToInt(room -> room.getBedCount() != null ? room.getBedCount() : 0)
                .sum();

        // 统计该楼层所有床位的入住人数
        LambdaQueryWrapper<Bed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(Bed::getFloorId, floorId)
                   .eq(Bed::getBedStatus, 2); // 2-已占用
        long currentOccupancy = bedMapper.selectCount(bedWrapper);

        // 更新楼层统计字段
        Floor floor = floorMapper.selectById(floorId);
        if (floor != null) {
            floor.setTotalRooms((int) totalRooms);
            floor.setTotalBeds(totalBeds);
            floor.setCurrentOccupancy((int) currentOccupancy);
            floorMapper.updateById(floor);
        }
    }
}
