package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.dict.DictDataQueryDTO;
import com.sushe.backend.dto.dict.DictDataSaveDTO;
import com.sushe.backend.entity.SysDictData;
import com.sushe.backend.mapper.SysDictDataMapper;
import com.sushe.backend.service.SysDictDataService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.DictDataVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 字典数据Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@Service
public class SysDictDataServiceImpl extends ServiceImpl<SysDictDataMapper, SysDictData> implements SysDictDataService {

    /**
     * 分页查询字典数据列表
     */
    @Override
    public PageResult<DictDataVO> pageList(DictDataQueryDTO queryDTO) {
        // 构建查询条件
        LambdaQueryWrapper<SysDictData> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StrUtil.isNotBlank(queryDTO.getDictCode()), SysDictData::getDictCode, queryDTO.getDictCode())
               .like(StrUtil.isNotBlank(queryDTO.getLabel()), SysDictData::getLabel, queryDTO.getLabel())
               .eq(queryDTO.getStatus() != null, SysDictData::getStatus, queryDTO.getStatus())
               .orderByAsc(SysDictData::getSort)
               .orderByAsc(SysDictData::getId);

        // 分页查询
        Page<SysDictData> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        // 转换为VO
        List<DictDataVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    /**
     * 根据字典编码获取字典数据列表
     */
    @Override
    public List<DictDataVO> listByDictCode(String dictCode) {
        LambdaQueryWrapper<SysDictData> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysDictData::getDictCode, dictCode)
               .eq(SysDictData::getStatus, 1)
               .orderByAsc(SysDictData::getSort)
               .orderByAsc(SysDictData::getId);

        List<SysDictData> list = list(wrapper);
        return list.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    /**
     * 根据ID获取字典数据详情
     */
    @Override
    public DictDataVO getDetailById(Long id) {
        SysDictData dictData = getById(id);
        if (dictData == null) {
            throw new BusinessException("字典数据不存在");
        }
        return convertToVO(dictData);
    }

    /**
     * 保存字典数据（新增或编辑）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveDictData(DictDataSaveDTO saveDTO) {
        // 检查同一字典编码下，字典值是否重复
        LambdaQueryWrapper<SysDictData> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysDictData::getDictCode, saveDTO.getDictCode())
               .eq(SysDictData::getValue, saveDTO.getValue());
        if (saveDTO.getId() != null) {
            wrapper.ne(SysDictData::getId, saveDTO.getId());
        }
        if (count(wrapper) > 0) {
            throw new BusinessException("该字典编码下字典值已存在");
        }

        SysDictData dictData = new SysDictData();
        BeanUtil.copyProperties(saveDTO, dictData);

        boolean success;
        if (saveDTO.getId() == null) {
            // 新增
            dictData.setStatus(1); // 默认启用
            dictData.setIsDefault(0); // 默认不是默认值
            success = save(dictData);
        } else {
            // 编辑
            success = updateById(dictData);
        }

        // 刷新字典缓存
        if (success) {
            DictUtils.refreshCache(saveDTO.getDictCode());
        }

        return success;
    }

    /**
     * 删除字典数据
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteDictData(Long id) {
        if (id == null) {
            throw new BusinessException("字典数据ID不能为空");
        }

        // 获取字典编码，用于刷新缓存
        SysDictData dictData = getById(id);
        String dictCode = dictData != null ? dictData.getDictCode() : null;

        boolean success = removeById(id);

        // 刷新字典缓存
        if (success && dictCode != null) {
            DictUtils.refreshCache(dictCode);
        }

        return success;
    }

    /**
     * 实体转VO
     */
    private DictDataVO convertToVO(SysDictData dictData) {
        DictDataVO vo = new DictDataVO();
        BeanUtil.copyProperties(dictData, vo);

        // 状态文本（使用字典）
        vo.setStatusText(DictUtils.getLabel("sys_user_status", dictData.getStatus(), "未知"));

        return vo;
    }
}

