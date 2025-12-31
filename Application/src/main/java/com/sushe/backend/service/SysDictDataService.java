package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.dict.DictDataQueryDTO;
import com.sushe.backend.dto.dict.DictDataSaveDTO;
import com.sushe.backend.entity.SysDictData;
import com.sushe.backend.vo.DictDataVO;

import java.util.List;

/**
 * 字典数据Service
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
public interface SysDictDataService extends IService<SysDictData> {

    /**
     * 分页查询字典数据列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<DictDataVO> pageList(DictDataQueryDTO queryDTO);

    /**
     * 根据字典编码获取字典数据列表
     * 
     * @param dictCode 字典编码
     * @return 字典数据列表
     */
    List<DictDataVO> listByDictCode(String dictCode);

    /**
     * 根据ID获取字典数据详情
     * 
     * @param id 字典数据ID
     * @return 字典数据信息
     */
    DictDataVO getDetailById(Long id);

    /**
     * 保存字典数据（新增或编辑）
     * 
     * @param saveDTO 字典数据保存DTO
     * @return 是否成功
     */
    boolean saveDictData(DictDataSaveDTO saveDTO);

    /**
     * 删除字典数据
     * 
     * @param id 字典数据ID
     * @return 是否成功
     */
    boolean deleteDictData(Long id);
}

