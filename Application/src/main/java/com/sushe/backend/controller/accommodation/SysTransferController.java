package com.sushe.backend.controller.accommodation;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.dto.transfer.TransferQueryDTO;
import com.sushe.backend.dto.transfer.TransferSaveDTO;
import com.sushe.backend.service.SysTransferService;
import com.sushe.backend.vo.TransferVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 调宿管理Controller
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@RestController
@RequestMapping("/v1/system/transfer")
@RequiredArgsConstructor
public class SysTransferController extends BaseCrudController<TransferVO, TransferQueryDTO, TransferSaveDTO> 
        implements BatchDeleteController {

    private final SysTransferService transferService;

    @Override
    public String getEntityName() {
        return "调宿管理";
    }

    @Override
    protected PageResult<TransferVO> callPageList(TransferQueryDTO queryDTO) {
        return transferService.pageList(queryDTO);
    }

    @Override
    protected TransferVO callGetDetailById(Long id) {
        return transferService.getDetailById(id);
    }

    @Override
    protected boolean callSave(TransferSaveDTO saveDTO) {
        return transferService.saveTransfer(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return transferService.deleteTransfer(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return transferService.batchDelete(ids);
    }
}

