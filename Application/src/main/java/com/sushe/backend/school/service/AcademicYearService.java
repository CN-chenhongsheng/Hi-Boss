package com.sushe.backend.school.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.school.dto.AcademicYearQueryDTO;
import com.sushe.backend.school.dto.AcademicYearSaveDTO;
import com.sushe.backend.school.entity.AcademicYear;
import com.sushe.backend.school.vo.AcademicYearVO;

/**
 * 学年Service
 * 
 * @author 陈鸿昇
 * @since 2026-01-01
 */
public interface AcademicYearService extends IService<AcademicYear> {

    /**
     * 分页查询学年列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<AcademicYearVO> pageList(AcademicYearQueryDTO queryDTO);

    /**
     * 根据ID获取学年详情
     * 
     * @param id 学年ID
     * @return 学年信息（包含学期列表）
     */
    AcademicYearVO getDetailById(Long id);

    /**
     * 保存学年（新增或编辑）
     * 
     * @param saveDTO 学年保存DTO
     * @return 是否成功
     */
    boolean saveAcademicYear(AcademicYearSaveDTO saveDTO);

    /**
     * 删除学年
     * 
     * @param id 学年ID
     * @return 是否成功
     */
    boolean deleteAcademicYear(Long id);

    /**
     * 批量删除学年
     * 
     * @param ids 学年ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 更新学年状态
     * 
     * @param id 学年ID
     * @param status 状态：1启用 0停用
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);
}
