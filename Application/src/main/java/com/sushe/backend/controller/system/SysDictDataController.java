package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.dict.DictDataQueryDTO;
import com.sushe.backend.dto.dict.DictDataSaveDTO;
import com.sushe.backend.service.SysDictDataService;
import com.sushe.backend.vo.DictDataVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 字典数据控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/dict/data")
@RequiredArgsConstructor
@Tag(name = "字典数据管理", description = "字典数据的增删改查")
public class SysDictDataController {

    private final SysDictDataService dictDataService;

    @GetMapping("/page")
    @Operation(summary = "分页查询字典数据列表")
    public R<PageResult<DictDataVO>> pageList(
            @Parameter(description = "字典编码") @RequestParam(required = false) String dictCode,
            @Parameter(description = "字典标签") @RequestParam(required = false) String label,
            @Parameter(description = "状态：1正常 0停用") @RequestParam(required = false) Integer status,
            @Parameter(description = "当前页码") @RequestParam(required = false, defaultValue = "1") Long pageNum,
            @Parameter(description = "每页条数") @RequestParam(required = false, defaultValue = "10") Long pageSize
    ) {
        log.info("分页查询字典数据列表，dictCode：{}，label：{}，status：{}", dictCode, label, status);

        DictDataQueryDTO queryDTO = new DictDataQueryDTO();
        queryDTO.setDictCode(dictCode);
        queryDTO.setLabel(label);
        queryDTO.setStatus(status);
        queryDTO.setPageNum(pageNum);
        queryDTO.setPageSize(pageSize);

        PageResult<DictDataVO> result = dictDataService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/list/{dictCode}")
    @Operation(summary = "根据字典编码获取字典数据列表")
    @Parameter(name = "dictCode", description = "字典编码", required = true)
    public R<List<DictDataVO>> listByDictCode(@PathVariable String dictCode) {
        log.info("根据字典编码获取字典数据列表，dictCode：{}", dictCode);
        List<DictDataVO> list = dictDataService.listByDictCode(dictCode);
        return R.ok(list);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询字典数据详情")
    @Parameter(name = "id", description = "字典数据ID", required = true)
    public R<DictDataVO> getDetail(@PathVariable Long id) {
        log.info("查询字典数据详情，ID：{}", id);
        DictDataVO dictDataVO = dictDataService.getDetailById(id);
        return R.ok(dictDataVO);
    }

    @PostMapping
    @Operation(summary = "新增字典数据")
    public R<Void> add(@Valid @RequestBody DictDataSaveDTO saveDTO) {
        log.info("新增字典数据，参数：{}", saveDTO);
        saveDTO.setId(null); // 确保ID为空
        boolean success = dictDataService.saveDictData(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑字典数据")
    @Parameter(name = "id", description = "字典数据ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody DictDataSaveDTO saveDTO) {
        log.info("编辑字典数据，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = dictDataService.saveDictData(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除字典数据")
    @Parameter(name = "id", description = "字典数据ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除字典数据，ID：{}", id);
        boolean success = dictDataService.deleteDictData(id);
        return R.status(success);
    }
}

