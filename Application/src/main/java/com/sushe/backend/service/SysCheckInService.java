package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.checkin.CheckInQueryDTO;
import com.sushe.backend.dto.checkin.CheckInSaveDTO;
import com.sushe.backend.entity.SysCheckIn;
import com.sushe.backend.vo.CheckInVO;

/**
 * 入住管理Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
public interface SysCheckInService extends IService<SysCheckIn> {

    /**
     * 分页查询入住管理列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<CheckInVO> pageList(CheckInQueryDTO queryDTO);

    /**
     * 根据ID获取入住管理详情
     * 
     * @param id 入住记录ID
     * @return 入住管理信息
     */
    CheckInVO getDetailById(Long id);

    /**
     * 保存入住管理（新增或编辑）
     * 
     * @param saveDTO 入住管理保存DTO
     * @return 是否成功
     */
    boolean saveCheckIn(CheckInSaveDTO saveDTO);

    /**
     * 删除入住管理
     * 
     * @param id 入住记录ID
     * @return 是否成功
     */
    boolean deleteCheckIn(Long id);

    /**
     * 批量删除入住管理
     * 
     * @param ids 入住记录ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);
}

