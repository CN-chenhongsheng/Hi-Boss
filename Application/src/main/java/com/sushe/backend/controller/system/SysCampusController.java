package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.controller.base.TreeController;
import com.sushe.backend.dto.campus.CampusQueryDTO;
import com.sushe.backend.dto.campus.CampusSaveDTO;
import com.sushe.backend.service.SysCampusService;
import com.sushe.backend.vo.CampusVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
public class SysCampusController extends BaseCrudController<CampusVO, CampusQueryDTO, CampusSaveDTO>
        implements TreeController<CampusVO, CampusQueryDTO>,
                   BatchDeleteController,
                   StatusUpdateController {

    private final SysCampusService campusService;

    @Override
    public String getEntityName() {
        return "校区";
    }

    @Override
    protected PageResult<CampusVO> callPageList(CampusQueryDTO queryDTO) {
        return campusService.pageList(queryDTO);
    }

    @Override
    protected CampusVO callGetDetailById(Long id) {
        return campusService.getDetailById(id);
    }

    @Override
    protected boolean callSave(CampusSaveDTO saveDTO) {
        return campusService.saveCampus(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return campusService.deleteCampus(id);
    }

    @Override
    public List<CampusVO> callTreeList(CampusQueryDTO queryDTO) {
        return campusService.treeList(queryDTO);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return campusService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return campusService.updateStatus(id, status);
    }
}
