package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.campus.CampusQueryDTO;
import com.sushe.backend.dto.campus.CampusSaveDTO;
import com.sushe.backend.service.SysCampusService;
import com.sushe.backend.vo.CampusVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 校区管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/campus")
@RequiredArgsConstructor
@Tag(name = "校区管理", description = "校区增删改查、树形列表等")
public class SysCampusController {

    private final SysCampusService campusService;

    @GetMapping("/page")
    @Operation(summary = "分页查询校区列表")
    public R<PageResult<CampusVO>> page(CampusQueryDTO queryDTO) {
        log.info("分页查询校区列表，参数：{}", queryDTO);
        PageResult<CampusVO> result = campusService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/tree")
    @Operation(summary = "查询校区树形列表")
    public R<List<CampusVO>> tree(CampusQueryDTO queryDTO) {
        log.info("查询校区树形列表，参数：{}", queryDTO);
        List<CampusVO> result = campusService.treeList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询校区详情")
    @Parameter(name = "id", description = "校区ID", required = true)
    public R<CampusVO> getDetail(@PathVariable Long id) {
        log.info("查询校区详情，ID：{}", id);
        CampusVO result = campusService.getDetailById(id);
        return R.ok(result);
    }

    @PostMapping
    @Operation(summary = "新增校区")
    public R<Void> add(@Valid @RequestBody CampusSaveDTO saveDTO) {
        log.info("新增校区，参数：{}", saveDTO);
        boolean success = campusService.saveCampus(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑校区")
    @Parameter(name = "id", description = "校区ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody CampusSaveDTO saveDTO) {
        log.info("编辑校区，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = campusService.saveCampus(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除校区")
    @Parameter(name = "id", description = "校区ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除校区，ID：{}", id);
        boolean success = campusService.deleteCampus(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除校区")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除校区，IDs：{}", (Object) ids);
        boolean success = campusService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改校区状态")
    @Parameter(name = "id", description = "校区ID", required = true)
    @Parameter(name = "status", description = "状态：1正常 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改校区状态，ID：{}，状态：{}", id, status);
        boolean success = campusService.updateStatus(id, status);
        return R.ok(status == 1 ? "校区已启用" : "校区已停用", null);
    }
}

