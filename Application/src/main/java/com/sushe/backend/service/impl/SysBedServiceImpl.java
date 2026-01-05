package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.bed.BedBatchCreateDTO;
import com.sushe.backend.dto.bed.BedQueryDTO;
import com.sushe.backend.dto.bed.BedSaveDTO;
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.service.SysBedService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.BedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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
    private final SysCampusMapper campusMapper;

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

        // 查询房间信息填充房间号，并确保楼层信息正确
        SysRoom room = null;
        if (bed.getRoomId() != null) {
            room = roomMapper.selectById(bed.getRoomId());
            if (room != null) {
                // 填充房间号
                vo.setRoomNumber(room.getRoomNumber());
                // 如果床位的floorId为空或不一致，从房间获取并更新
                if (bed.getFloorId() == null || !bed.getFloorId().equals(room.getFloorId())) {
                    if (room.getFloorId() != null) {
                        bed.setFloorId(room.getFloorId());
                        vo.setFloorId(room.getFloorId());
                    }
                }
                // 如果床位的floorCode为空或不一致，从房间获取并更新
                if (StrUtil.isBlank(bed.getFloorCode()) || !bed.getFloorCode().equals(room.getFloorCode())) {
                    if (StrUtil.isNotBlank(room.getFloorCode())) {
                        bed.setFloorCode(room.getFloorCode());
                        vo.setFloorCode(room.getFloorCode());
                    }
                }
            }
        }

        // 查询楼层信息填充楼层名称
        Long floorIdToQuery = bed.getFloorId();
        if (floorIdToQuery == null && room != null && room.getFloorId() != null) {
            floorIdToQuery = room.getFloorId();
        }
        if (floorIdToQuery != null) {
            SysFloor floor = floorMapper.selectById(floorIdToQuery);
            if (floor != null) {
                vo.setFloorName(floor.getFloorName());
                // 确保楼层编码正确
                if (StrUtil.isBlank(vo.getFloorCode()) || !vo.getFloorCode().equals(floor.getFloorCode())) {
                    vo.setFloorCode(floor.getFloorCode());
                }
            }
        }

        // 查询校区信息填充校区名称
        if (StrUtil.isNotBlank(bed.getCampusCode())) {
            SysCampus campus = campusMapper.selectByCampusCode(bed.getCampusCode());
            if (campus != null) {
                vo.setCampusName(campus.getCampusName());
            }
        }

        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int batchCreateBeds(BedBatchCreateDTO dto) {
        // 验证房间是否存在
        SysRoom room = roomMapper.selectById(dto.getRoomId());
        if (room == null) {
            throw new BusinessException("所属房间不存在");
        }
        
        // 确保房间的关联字段不为空
        if (room.getFloorId() == null) {
            throw new BusinessException("房间的楼层信息不完整，无法创建床位");
        }
        if (StrUtil.isBlank(room.getRoomCode())) {
            throw new BusinessException("房间编码不能为空");
        }

        // 查询该房间已有床位的最大序号
        LambdaQueryWrapper<SysBed> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysBed::getRoomId, dto.getRoomId());
        List<SysBed> existingBeds = list(wrapper);
        
        int maxSeq = 0;
        for (SysBed existingBed : existingBeds) {
            String bedCode = existingBed.getBedCode();
            if (bedCode != null) {
                try {
                    int seq = Integer.parseInt(bedCode);
                    maxSeq = Math.max(maxSeq, seq);
                } catch (NumberFormatException e) {
                    // 忽略解析失败的编码
                }
            }
        }

        // 获取当前最大排序值
        LambdaQueryWrapper<SysBed> sortWrapper = new LambdaQueryWrapper<>();
        sortWrapper.eq(SysBed::getRoomId, dto.getRoomId())
                   .orderByDesc(SysBed::getSort)
                   .last("LIMIT 1");
        SysBed lastBed = getOne(sortWrapper);
        int currentSort = lastBed != null && lastBed.getSort() != null ? lastBed.getSort() : 0;

        // 批量生成床位
        List<SysBed> bedsToCreate = new ArrayList<>();
        for (int i = 0; i < dto.getGenerateCount(); i++) {
            int seq = maxSeq + i + 1;
            String bedCode = String.valueOf(seq);
            String bedNumber = bedCode;

            // 检查编码是否已存在（在同一房间内）
            LambdaQueryWrapper<SysBed> checkWrapper = new LambdaQueryWrapper<>();
            checkWrapper.eq(SysBed::getRoomId, dto.getRoomId())
                       .eq(SysBed::getBedCode, bedCode);
            if (count(checkWrapper) > 0) {
                throw new BusinessException("床位编码 " + bedCode + " 已存在");
            }

            SysBed bed = new SysBed();
            bed.setBedCode(bedCode);
            bed.setBedNumber(bedNumber);
            bed.setRoomId(dto.getRoomId());
            bed.setRoomCode(room.getRoomCode());
            bed.setFloorId(room.getFloorId());
            bed.setFloorCode(room.getFloorCode());
            bed.setCampusCode(room.getCampusCode());
            bed.setBedPosition(dto.getBedPosition());
            bed.setBedStatus(dto.getBedStatus() != null ? dto.getBedStatus() : 1);
            bed.setCheckInDate(dto.getCheckInDate());
            bed.setCheckOutDate(dto.getCheckOutDate());
            bed.setStatus(dto.getStatus() != null ? dto.getStatus() : 1);
            bed.setRemark(dto.getRemark());
            bed.setSort(++currentSort);

            bedsToCreate.add(bed);
        }

        // 批量插入
        boolean result = saveBatch(bedsToCreate);

        // 更新房间和楼层统计字段
        if (result) {
            updateRoomStatistics(dto.getRoomId());
            if (room.getFloorId() != null) {
                updateFloorStatistics(room.getFloorId());
            }
        }

        return bedsToCreate.size();
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

