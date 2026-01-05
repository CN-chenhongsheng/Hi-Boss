package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.bed.BedBatchCreateDTO;
import com.sushe.backend.dto.bed.BedQueryDTO;
import com.sushe.backend.dto.bed.BedSaveDTO;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sushe.backend.service.SysBedService;
import com.sushe.backend.vo.BedVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 床位管理控制器
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/bed")
@RequiredArgsConstructor
@Tag(name = "床位管理", description = "床位增删改查等")
public class SysBedController extends BaseCrudController<BedVO, BedQueryDTO, BedSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysBedService bedService;

    @Override
    public String getEntityName() {
        return "床位";
    }

    @Override
    protected PageResult<BedVO> callPageList(BedQueryDTO queryDTO) {
        return bedService.pageList(queryDTO);
    }

    @Override
    protected BedVO callGetDetailById(Long id) {
        return bedService.getDetailById(id);
    }

    @Override
    protected boolean callSave(BedSaveDTO saveDTO) {
        return bedService.saveBed(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return bedService.deleteBed(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return bedService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return bedService.updateStatus(id, status);
    }

    @PostMapping("/batch-create")
    @Operation(summary = "批量创建床位")
    public R<Integer> batchCreate(@RequestBody @Valid BedBatchCreateDTO dto) {
        return R.ok(bedService.batchCreateBeds(dto));
    }
}

