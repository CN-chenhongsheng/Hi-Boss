package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.floor.FloorQueryDTO;
import com.sushe.backend.dto.floor.FloorSaveDTO;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.vo.FloorVO;

/**
 * 楼层Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
public interface SysFloorService extends IService<SysFloor> {

    /**
     * 分页查询楼层列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<FloorVO> pageList(FloorQueryDTO queryDTO);

    /**
     * 根据ID获取楼层详情
     * 
     * @param id 楼层ID
     * @return 楼层信息
     */
    FloorVO getDetailById(Long id);

    /**
     * 保存楼层（新增或编辑）
     * 
     * @param saveDTO 楼层保存DTO
     * @return 是否成功
     */
    boolean saveFloor(FloorSaveDTO saveDTO);

    /**
     * 删除楼层
     * 
     * @param id 楼层ID
     * @return 是否成功
     */
    boolean deleteFloor(Long id);

    /**
     * 批量删除楼层
     * 
     * @param ids 楼层ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 更新楼层状态
     * 
     * @param id 楼层ID
     * @param status 状态：1正常 0停用
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);
}

