package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.classes.ClassQueryDTO;
import com.sushe.backend.dto.classes.ClassSaveDTO;
import com.sushe.backend.service.SysClassService;
import com.sushe.backend.vo.ClassVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 班级管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/class")
@RequiredArgsConstructor
@Tag(name = "班级管理", description = "班级增删改查等")
public class SysClassController {

    private final SysClassService classService;

    @GetMapping("/page")
    @Operation(summary = "分页查询班级列表")
    public R<PageResult<ClassVO>> page(ClassQueryDTO queryDTO) {
        log.info("分页查询班级列表，参数：{}", queryDTO);
        PageResult<ClassVO> result = classService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询班级详情")
    @Parameter(name = "id", description = "班级ID", required = true)
    public R<ClassVO> getDetail(@PathVariable Long id) {
        log.info("查询班级详情，ID：{}", id);
        ClassVO result = classService.getDetailById(id);
        return R.ok(result);
    }

    @PostMapping
    @Operation(summary = "新增班级")
    public R<Void> add(@Valid @RequestBody ClassSaveDTO saveDTO) {
        log.info("新增班级，参数：{}", saveDTO);
        boolean success = classService.saveClass(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑班级")
    @Parameter(name = "id", description = "班级ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody ClassSaveDTO saveDTO) {
        log.info("编辑班级，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = classService.saveClass(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除班级")
    @Parameter(name = "id", description = "班级ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除班级，ID：{}", id);
        boolean success = classService.deleteClass(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除班级")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除班级，IDs：{}", (Object) ids);
        boolean success = classService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改班级状态")
    @Parameter(name = "id", description = "班级ID", required = true)
    @Parameter(name = "status", description = "状态：1启用 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改班级状态，ID：{}，状态：{}", id, status);
        boolean success = classService.updateStatus(id, status);
        return R.ok(status == 1 ? "班级已启用" : "班级已停用", null);
    }
}

