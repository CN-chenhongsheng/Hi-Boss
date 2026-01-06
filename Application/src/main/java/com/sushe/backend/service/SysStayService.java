package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.stay.StayQueryDTO;
import com.sushe.backend.dto.stay.StaySaveDTO;
import com.sushe.backend.entity.SysStay;
import com.sushe.backend.vo.StayVO;

/**
 * 留宿管理Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
public interface SysStayService extends IService<SysStay> {

    /**
     * 分页查询留宿管理列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<StayVO> pageList(StayQueryDTO queryDTO);

    /**
     * 根据ID获取留宿管理详情
     * 
     * @param id 留宿记录ID
     * @return 留宿管理信息
     */
    StayVO getDetailById(Long id);

    /**
     * 保存留宿管理（新增或编辑）
     * 
     * @param saveDTO 留宿管理保存DTO
     * @return 是否成功
     */
    boolean saveStay(StaySaveDTO saveDTO);

    /**
     * 删除留宿管理
     * 
     * @param id 留宿记录ID
     * @return 是否成功
     */
    boolean deleteStay(Long id);

    /**
     * 批量删除留宿管理
     * 
     * @param ids 留宿记录ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);
}

