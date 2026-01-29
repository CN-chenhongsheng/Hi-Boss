package com.project.app.controller;

import com.project.backend.repair.dto.RepairQueryDTO;
import com.project.backend.repair.dto.RepairSaveDTO;
import com.project.backend.repair.service.RepairService;
import com.project.backend.repair.vo.RepairVO;
import com.project.core.annotation.Log;
import com.project.core.result.PageResult;
import com.project.core.result.R;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 报修Controller（小程序端）
 *
 * @author 陈鸿昇
 * @since 2026-01-29
 */
@Slf4j
@Tag(name = "报修（小程序）", description = "小程序报修相关接口")
@RestController("appRepairController")
@RequestMapping("/v1/app/repair")
@RequiredArgsConstructor
public class RepairController {

    private final RepairService repairService;

    /**
     * 提交报修
     */
    @Operation(summary = "提交报修")
    @Log(title = "提交报修", businessType = 1)
    @PostMapping("/submit")
    public R<Void> submit(@RequestBody @Valid RepairSaveDTO saveDTO) {
        boolean success = repairService.submitRepair(saveDTO);
        return success ? R.ok() : R.fail("报修提交失败");
    }

    /**
     * 我的报修列表
     */
    @Operation(summary = "我的报修列表")
    @GetMapping("/list")
    public R<PageResult<RepairVO>> list(RepairQueryDTO queryDTO) {
        PageResult<RepairVO> result = repairService.myRepairList(queryDTO);
        return R.ok(result);
    }

    /**
     * 报修详情
     */
    @Operation(summary = "报修详情")
    @GetMapping("/detail/{id}")
    public R<RepairVO> detail(@PathVariable Long id) {
        RepairVO detail = repairService.getDetailById(id);
        return R.ok(detail);
    }

    /**
     * 取消报修
     */
    @Operation(summary = "取消报修")
    @Log(title = "取消报修", businessType = 2)
    @PostMapping("/cancel/{id}")
    public R<Void> cancel(@PathVariable Long id) {
        boolean success = repairService.cancelRepair(id);
        return success ? R.ok() : R.fail("取消失败");
    }

    /**
     * 评价报修
     */
    @Operation(summary = "评价报修")
    @Log(title = "评价报修", businessType = 2)
    @PostMapping("/rate/{id}")
    public R<Void> rate(
            @PathVariable Long id,
            @RequestBody @Valid RateRepairRequest request
    ) {
        boolean success = repairService.rateRepair(id, request.getRating(), request.getRatingComment());
        return success ? R.ok() : R.fail("评价失败");
    }

    /**
     * 评价报修请求
     */
    @lombok.Data
    @io.swagger.v3.oas.annotations.media.Schema(description = "评价报修请求")
    public static class RateRepairRequest {
        @io.swagger.v3.oas.annotations.media.Schema(description = "评分：1-5星", requiredMode = io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED)
        @jakarta.validation.constraints.NotNull(message = "评分不能为空")
        @jakarta.validation.constraints.Min(value = 1, message = "评分最小为1星")
        @jakarta.validation.constraints.Max(value = 5, message = "评分最大为5星")
        private Integer rating;

        @io.swagger.v3.oas.annotations.media.Schema(description = "评价内容")
        private String ratingComment;
    }
}
