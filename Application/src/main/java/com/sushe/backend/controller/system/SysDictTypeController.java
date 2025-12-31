package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.dict.DictTypeQueryDTO;
import com.sushe.backend.dto.dict.DictTypeSaveDTO;
import com.sushe.backend.service.SysDictTypeService;
import com.sushe.backend.vo.DictTypeVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 字典类型控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/dict/type")
@RequiredArgsConstructor
@Tag(name = "字典类型管理", description = "字典类型的增删改查")
public class SysDictTypeController {

    private final SysDictTypeService dictTypeService;

    @GetMapping("/page")
    @Operation(summary = "分页查询字典类型列表")
    public R<PageResult<DictTypeVO>> pageList(
            @Parameter(description = "字典名称") @RequestParam(required = false) String dictName,
            @Parameter(description = "字典编码") @RequestParam(required = false) String dictCode,
            @Parameter(description = "状态：1正常 0停用") @RequestParam(required = false) Integer status,
            @Parameter(description = "当前页码") @RequestParam(required = false, defaultValue = "1") Long pageNum,
            @Parameter(description = "每页条数") @RequestParam(required = false, defaultValue = "10") Long pageSize
    ) {
        log.info("分页查询字典类型列表，dictName：{}，dictCode：{}，status：{}", dictName, dictCode, status);

        DictTypeQueryDTO queryDTO = new DictTypeQueryDTO();
        queryDTO.setDictName(dictName);
        queryDTO.setDictCode(dictCode);
        queryDTO.setStatus(status);
        queryDTO.setPageNum(pageNum);
        queryDTO.setPageSize(pageSize);

        PageResult<DictTypeVO> result = dictTypeService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询字典类型详情")
    @Parameter(name = "id", description = "字典类型ID", required = true)
    public R<DictTypeVO> getDetail(@PathVariable Long id) {
        log.info("查询字典类型详情，ID：{}", id);
        DictTypeVO dictTypeVO = dictTypeService.getDetailById(id);
        return R.ok(dictTypeVO);
    }

    @PostMapping
    @Operation(summary = "新增字典类型")
    public R<Void> add(@Valid @RequestBody DictTypeSaveDTO saveDTO) {
        log.info("新增字典类型，参数：{}", saveDTO);
        saveDTO.setId(null); // 确保ID为空
        boolean success = dictTypeService.saveDictType(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑字典类型")
    @Parameter(name = "id", description = "字典类型ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody DictTypeSaveDTO saveDTO) {
        log.info("编辑字典类型，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = dictTypeService.saveDictType(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除字典类型")
    @Parameter(name = "id", description = "字典类型ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除字典类型，ID：{}", id);
        boolean success = dictTypeService.deleteDictType(id);
        return R.status(success);
    }
}

