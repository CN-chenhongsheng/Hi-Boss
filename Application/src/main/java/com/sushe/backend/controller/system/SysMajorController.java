package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.major.MajorQueryDTO;
import com.sushe.backend.dto.major.MajorSaveDTO;
import com.sushe.backend.service.SysMajorService;
import com.sushe.backend.vo.MajorVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 专业管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/major")
@RequiredArgsConstructor
@Tag(name = "专业管理", description = "专业增删改查等")
public class SysMajorController {

    private final SysMajorService majorService;

    @GetMapping("/page")
    @Operation(summary = "分页查询专业列表")
    public R<PageResult<MajorVO>> page(MajorQueryDTO queryDTO) {
        log.info("分页查询专业列表，参数：{}", queryDTO);
        PageResult<MajorVO> result = majorService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询专业详情")
    @Parameter(name = "id", description = "专业ID", required = true)
    public R<MajorVO> getDetail(@PathVariable Long id) {
        log.info("查询专业详情，ID：{}", id);
        MajorVO result = majorService.getDetailById(id);
        return R.ok(result);
    }

    @PostMapping
    @Operation(summary = "新增专业")
    public R<Void> add(@Valid @RequestBody MajorSaveDTO saveDTO) {
        log.info("新增专业，参数：{}", saveDTO);
        boolean success = majorService.saveMajor(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑专业")
    @Parameter(name = "id", description = "专业ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody MajorSaveDTO saveDTO) {
        log.info("编辑专业，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = majorService.saveMajor(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除专业")
    @Parameter(name = "id", description = "专业ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除专业，ID：{}", id);
        boolean success = majorService.deleteMajor(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除专业")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除专业，IDs：{}", (Object) ids);
        boolean success = majorService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改专业状态")
    @Parameter(name = "id", description = "专业ID", required = true)
    @Parameter(name = "status", description = "状态：1启用 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改专业状态，ID：{}，状态：{}", id, status);
        boolean success = majorService.updateStatus(id, status);
        return R.ok(status == 1 ? "专业已启用" : "专业已停用", null);
    }
}

