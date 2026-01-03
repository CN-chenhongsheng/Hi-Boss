package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.bed.BedQueryDTO;
import com.sushe.backend.dto.bed.BedSaveDTO;
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.service.SysBedService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.BedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 床位Service实现
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysBedServiceImpl extends ServiceImpl<SysBedMapper, SysBed> implements SysBedService {

    private final SysRoomMapper roomMapper;
    private final SysFloorMapper floorMapper;

    @Override
    public PageResult<BedVO> pageList(BedQueryDTO queryDTO) {
        LambdaQueryWrapper<SysBed> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getBedCode()), SysBed::getBedCode, queryDTO.getBedCode())
               .like(StrUtil.isNotBlank(queryDTO.getBedNumber()), SysBed::getBedNumber, queryDTO.getBedNumber())
               .eq(queryDTO.getRoomId() != null, SysBed::getRoomId, queryDTO.getRoomId())
               .eq(StrUtil.isNotBlank(queryDTO.getRoomCode()), SysBed::getRoomCode, queryDTO.getRoomCode())
               .eq(queryDTO.getFloorId() != null, SysBed::getFloorId, queryDTO.getFloorId())
               .eq(StrUtil.isNotBlank(queryDTO.getFloorCode()), SysBed::getFloorCode, queryDTO.getFloorCode())
               .eq(StrUtil.isNotBlank(queryDTO.getCampusCode()), SysBed::getCampusCode, queryDTO.getCampusCode())
               .eq(StrUtil.isNotBlank(queryDTO.getBedPosition()), SysBed::getBedPosition, queryDTO.getBedPosition())
               .eq(queryDTO.getBedStatus() != null, SysBed::getBedStatus, queryDTO.getBedStatus())
               .eq(queryDTO.getStatus() != null, SysBed::getStatus, queryDTO.getStatus())
               .orderByAsc(SysBed::getSort)
               .orderByAsc(SysBed::getId);

        Page<SysBed> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<BedVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public BedVO getDetailById(Long id) {
        SysBed bed = getById(id);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }
        return convertToVO(bed);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveBed(BedSaveDTO saveDTO) {
        // 检查编码是否重复
        LambdaQueryWrapper<SysBed> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysBed::getBedCode, saveDTO.getBedCode());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysBed::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("床位编码已存在");
        }

        // 查询房间信息，填充冗余字段
        SysRoom room = roomMapper.selectById(saveDTO.getRoomId());
        if (room == null) {
            throw new BusinessException("所属房间不存在");
        }

        SysBed bed = new SysBed();
        BeanUtil.copyProperties(saveDTO, bed);

        // 自动填充冗余字段
        bed.setRoomCode(room.getRoomCode());
        bed.setFloorId(room.getFloorId());
        bed.setFloorCode(room.getFloorCode());
        bed.setCampusCode(room.getCampusCode());

        if (saveDTO.getId() == null) {
            bed.setStatus(bed.getStatus() != null ? bed.getStatus() : 1);
            bed.setSort(bed.getSort() != null ? bed.getSort() : 0);
            bed.setBedStatus(bed.getBedStatus() != null ? bed.getBedStatus() : 1);

            boolean result = save(bed);

            // 更新房间和楼层统计字段
            if (result) {
                updateRoomStatistics(bed.getRoomId());
                if (bed.getFloorId() != null) {
                    updateFloorStatistics(bed.getFloorId());
                }
            }

            return result;
        } else {
            // 编辑时，如果房间ID发生变化，需要更新统计字段
            SysBed oldBed = getById(bed.getId());
            boolean result = updateById(bed);
            if (result && oldBed != null) {
                // 如果房间ID变化，更新旧房间和新房间的统计字段
                if (!oldBed.getRoomId().equals(bed.getRoomId())) {
                    updateRoomStatistics(oldBed.getRoomId());
                    updateRoomStatistics(bed.getRoomId());
                    // 如果楼层ID也变化，更新楼层统计字段
                    if (oldBed.getFloorId() != null && bed.getFloorId() != null && 
                        !oldBed.getFloorId().equals(bed.getFloorId())) {
                        updateFloorStatistics(oldBed.getFloorId());
                        updateFloorStatistics(bed.getFloorId());
                    } else if (bed.getFloorId() != null) {
                        updateFloorStatistics(bed.getFloorId());
                    }
                } else {
                    // 房间ID未变化，只更新当前房间和楼层统计字段
                    updateRoomStatistics(bed.getRoomId());
                    if (bed.getFloorId() != null) {
                        updateFloorStatistics(bed.getFloorId());
                    }
                }
            }
            return result;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteBed(Long id) {
        if (id == null) {
            throw new BusinessException("床位ID不能为空");
        }

        SysBed bed = getById(id);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }

        boolean result = removeById(id);

        // 更新房间和楼层统计字段
        if (result) {
            if (bed.getRoomId() != null) {
                updateRoomStatistics(bed.getRoomId());
            }
            if (bed.getFloorId() != null) {
                updateFloorStatistics(bed.getFloorId());
            }
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("床位ID不能为空");
        }
        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysBed bed = getById(id);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }

        bed.setStatus(status);
        boolean result = updateById(bed);

        // 如果床位状态变更，更新统计字段
        if (result) {
            if (bed.getRoomId() != null) {
                updateRoomStatistics(bed.getRoomId());
            }
            if (bed.getFloorId() != null) {
                updateFloorStatistics(bed.getFloorId());
            }
        }

        return result;
    }

    /**
     * 实体转VO
     */
    private BedVO convertToVO(SysBed bed) {
        BedVO vo = new BedVO();
        BeanUtil.copyProperties(bed, vo);
        vo.setStatusText(DictUtils.getLabel("sys_common_status", bed.getStatus(), "未知"));
        vo.setBedPositionText(DictUtils.getLabel("dormitory_bed_position", bed.getBedPosition(), "未知"));
        vo.setBedStatusText(DictUtils.getLabel("dormitory_bed_status", bed.getBedStatus(), "未知"));

        // 查询房间信息填充房间号
        if (bed.getRoomId() != null) {
            SysRoom room = roomMapper.selectById(bed.getRoomId());
            if (room != null) {
                vo.setRoomNumber(room.getRoomNumber());
            }
        }

        return vo;
    }

    /**
     * 更新房间统计字段
     */
    private void updateRoomStatistics(Long roomId) {
        if (roomId == null) {
            return;
        }

        // 统计该房间已占用的床位数
        LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(SysBed::getRoomId, roomId)
                  .eq(SysBed::getBedStatus, 2); // 2-已占用
        long currentOccupancy = count(bedWrapper);

        // 更新房间统计字段
        SysRoom room = roomMapper.selectById(roomId);
        if (room != null) {
            room.setCurrentOccupancy((int) currentOccupancy);
            roomMapper.updateById(room);
        }
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
        long totalRooms = roomMapper.selectCount(roomWrapper);

        // 统计该楼层所有房间的床位数
        List<SysRoom> rooms = roomMapper.selectList(roomWrapper);
        int totalBeds = rooms.stream()
                .mapToInt(room -> room.getBedCount() != null ? room.getBedCount() : 0)
                .sum();

        // 统计该楼层所有床位的入住人数
        LambdaQueryWrapper<SysBed> bedWrapper = new LambdaQueryWrapper<>();
        bedWrapper.eq(SysBed::getFloorId, floorId)
                   .eq(SysBed::getBedStatus, 2); // 2-已占用
        long currentOccupancy = count(bedWrapper);

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

