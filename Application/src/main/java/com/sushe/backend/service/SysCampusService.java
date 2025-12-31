package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.campus.CampusQueryDTO;
import com.sushe.backend.dto.campus.CampusSaveDTO;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.vo.CampusVO;

import java.util.List;

/**
 * 校区Service
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
public interface SysCampusService extends IService<SysCampus> {

    /**
     * 分页查询校区列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<CampusVO> pageList(CampusQueryDTO queryDTO);

    /**
     * 查询校区树形列表
     * 
     * @param queryDTO 查询条件
     * @return 校区树形列表
     */
    List<CampusVO> treeList(CampusQueryDTO queryDTO);

    /**
     * 根据ID获取校区详情
     * 
     * @param id 校区ID
     * @return 校区信息
     */
    CampusVO getDetailById(Long id);

    /**
     * 保存校区（新增或编辑）
     * 
     * @param saveDTO 校区保存DTO
     * @return 是否成功
     */
    boolean saveCampus(CampusSaveDTO saveDTO);

    /**
     * 删除校区
     * 
     * @param id 校区ID
     * @return 是否成功
     */
    boolean deleteCampus(Long id);

    /**
     * 批量删除校区
     * 
     * @param ids 校区ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 更新校区状态
     * 
     * @param id 校区ID
     * @param status 状态：1正常 0停用
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);
}

