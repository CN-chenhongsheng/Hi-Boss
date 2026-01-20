package com.project.backend.accommodation.controller;

import com.project.backend.accommodation.dto.checkin.CheckInQueryDTO;
import com.project.backend.accommodation.dto.checkin.CheckInSaveDTO;
import com.project.backend.accommodation.service.CheckInService;
import com.project.backend.accommodation.vo.CheckInVO;
import com.project.core.result.PageResult;
import com.project.core.result.R;
import com.project.backend.controller.base.BaseCrudController;
import com.project.backend.controller.base.BatchDeleteController;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 入住管理Controller
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@RestController
@RequestMapping("/v1/system/check-in")
@RequiredArgsConstructor
public class CheckInController extends BaseCrudController<CheckInVO, CheckInQueryDTO, CheckInSaveDTO> 
        implements BatchDeleteController {

    private final CheckInService checkInService;

    @Override
    public String getEntityName() {
        return "入住管理";
    }

    @Override
    protected PageResult<CheckInVO> callPageList(CheckInQueryDTO queryDTO) {
        return checkInService.pageList(queryDTO);
    }

    @Override
    protected CheckInVO callGetDetailById(Long id) {
        return checkInService.getDetailById(id);
    }

    @Override
    protected boolean callSave(CheckInSaveDTO saveDTO) {
        return checkInService.saveCheckIn(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return checkInService.deleteCheckIn(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return checkInService.batchDelete(ids);
    }

    /**
     * 撤回入住申请
     */
    @Operation(summary = "撤回入住申请")
    @PostMapping("/{id}/cancel")
    public R<Void> cancel(@PathVariable Long id) {
        boolean success = checkInService.cancelCheckIn(id);
        return success ? R.ok() : R.fail("撤回失败");
    }
}
