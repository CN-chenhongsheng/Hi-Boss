package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.department.DepartmentQueryDTO;
import com.sushe.backend.dto.department.DepartmentSaveDTO;
import com.sushe.backend.service.SysDepartmentService;
import com.sushe.backend.vo.DepartmentVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 院系管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/department")
@RequiredArgsConstructor
@Tag(name = "院系管理", description = "院系增删改查、树形列表等")
public class SysDepartmentController {

    private final SysDepartmentService departmentService;

    @GetMapping("/page")
    @Operation(summary = "分页查询院系列表")
    public R<PageResult<DepartmentVO>> page(DepartmentQueryDTO queryDTO) {
        log.info("分页查询院系列表，参数：{}", queryDTO);
        PageResult<DepartmentVO> result = departmentService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/tree")
    @Operation(summary = "查询院系树形列表")
    public R<List<DepartmentVO>> tree(DepartmentQueryDTO queryDTO) {
        log.info("查询院系树形列表，参数：{}", queryDTO);
        List<DepartmentVO> result = departmentService.treeList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询院系详情")
    @Parameter(name = "id", description = "院系ID", required = true)
    public R<DepartmentVO> getDetail(@PathVariable Long id) {
        log.info("查询院系详情，ID：{}", id);
        DepartmentVO result = departmentService.getDetailById(id);
        return R.ok(result);
    }

    @PostMapping
    @Operation(summary = "新增院系")
    public R<Void> add(@Valid @RequestBody DepartmentSaveDTO saveDTO) {
        log.info("新增院系，参数：{}", saveDTO);
        boolean success = departmentService.saveDepartment(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑院系")
    @Parameter(name = "id", description = "院系ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody DepartmentSaveDTO saveDTO) {
        log.info("编辑院系，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = departmentService.saveDepartment(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除院系")
    @Parameter(name = "id", description = "院系ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除院系，ID：{}", id);
        boolean success = departmentService.deleteDepartment(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除院系")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除院系，IDs：{}", (Object) ids);
        boolean success = departmentService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改院系状态")
    @Parameter(name = "id", description = "院系ID", required = true)
    @Parameter(name = "status", description = "状态：1正常 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改院系状态，ID：{}，状态：{}", id, status);
        boolean success = departmentService.updateStatus(id, status);
        return R.ok(status == 1 ? "院系已启用" : "院系已停用", null);
    }
}

