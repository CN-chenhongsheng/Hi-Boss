package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.dto.major.MajorQueryDTO;
import com.sushe.backend.dto.major.MajorSaveDTO;
import com.sushe.backend.service.SysMajorService;
import com.sushe.backend.vo.MajorVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
public class SysMajorController extends BaseCrudController<MajorVO, MajorQueryDTO, MajorSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysMajorService majorService;

    @Override
    public String getEntityName() {
        return "专业";
    }

    @Override
    protected PageResult<MajorVO> callPageList(MajorQueryDTO queryDTO) {
        return majorService.pageList(queryDTO);
    }

    @Override
    protected MajorVO callGetDetailById(Long id) {
        return majorService.getDetailById(id);
    }

    @Override
    protected boolean callSave(MajorSaveDTO saveDTO) {
        return majorService.saveMajor(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return majorService.deleteMajor(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return majorService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return majorService.updateStatus(id, status);
    }
}
