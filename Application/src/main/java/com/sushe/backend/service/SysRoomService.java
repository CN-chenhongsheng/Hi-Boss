package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.room.RoomQueryDTO;
import com.sushe.backend.dto.room.RoomSaveDTO;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.vo.RoomVO;

/**
 * 房间Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
public interface SysRoomService extends IService<SysRoom> {

    /**
     * 分页查询房间列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<RoomVO> pageList(RoomQueryDTO queryDTO);

    /**
     * 根据ID获取房间详情
     * 
     * @param id 房间ID
     * @return 房间信息
     */
    RoomVO getDetailById(Long id);

    /**
     * 保存房间（新增或编辑）
     * 
     * @param saveDTO 房间保存DTO
     * @return 是否成功
     */
    boolean saveRoom(RoomSaveDTO saveDTO);

    /**
     * 删除房间
     * 
     * @param id 房间ID
     * @return 是否成功
     */
    boolean deleteRoom(Long id);

    /**
     * 批量删除房间
     * 
     * @param ids 房间ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 更新房间状态
     * 
     * @param id 房间ID
     * @param status 状态：1正常 0停用
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);
}

