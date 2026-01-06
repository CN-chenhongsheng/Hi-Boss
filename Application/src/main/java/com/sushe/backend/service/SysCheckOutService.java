package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.checkout.CheckOutQueryDTO;
import com.sushe.backend.dto.checkout.CheckOutSaveDTO;
import com.sushe.backend.entity.SysCheckOut;
import com.sushe.backend.vo.CheckOutVO;

/**
 * 退宿管理Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
public interface SysCheckOutService extends IService<SysCheckOut> {

    /**
     * 分页查询退宿管理列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<CheckOutVO> pageList(CheckOutQueryDTO queryDTO);

    /**
     * 根据ID获取退宿管理详情
     * 
     * @param id 退宿记录ID
     * @return 退宿管理信息
     */
    CheckOutVO getDetailById(Long id);

    /**
     * 保存退宿管理（新增或编辑）
     * 
     * @param saveDTO 退宿管理保存DTO
     * @return 是否成功
     */
    boolean saveCheckOut(CheckOutSaveDTO saveDTO);

    /**
     * 删除退宿管理
     * 
     * @param id 退宿记录ID
     * @return 是否成功
     */
    boolean deleteCheckOut(Long id);

    /**
     * 批量删除退宿管理
     * 
     * @param ids 退宿记录ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);
}

