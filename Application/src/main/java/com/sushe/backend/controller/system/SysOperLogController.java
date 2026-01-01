package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.dto.operlog.OperLogQueryDTO;
import com.sushe.backend.service.SysOperLogService;
import com.sushe.backend.vo.OperLogVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 操作日志控制器
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/oper-log")
@RequiredArgsConstructor
@Tag(name = "操作日志管理", description = "操作日志的查询、删除等")
public class SysOperLogController implements BatchDeleteController {

    private final SysOperLogService operLogService;

    @GetMapping("/page")
    @Operation(summary = "分页查询操作日志列表")
    public R<PageResult<OperLogVO>> page(OperLogQueryDTO queryDTO) {
        log.info("分页查询操作日志，参数：{}", queryDTO);
        PageResult<OperLogVO> result = operLogService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询操作日志详情")
    @Parameter(name = "id", description = "日志ID", required = true)
    public R<OperLogVO> getDetail(@PathVariable Long id) {
        log.info("查询操作日志详情，ID：{}", id);
        OperLogVO operLogVO = operLogService.getDetailById(id);
        return R.ok(operLogVO);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除操作日志")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除操作日志，IDs：{}", (Object) ids);
        boolean success = operLogService.batchDelete(ids);
        return R.status(success);
    }

    @DeleteMapping("/clean")
    @Operation(summary = "清空操作日志")
    public R<Void> clean() {
        log.info("清空操作日志");
        boolean success = operLogService.clean();
        return R.status(success);
    }

    @Override
    public String getEntityName() {
        return "操作日志";
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return operLogService.batchDelete(ids);
    }
}

