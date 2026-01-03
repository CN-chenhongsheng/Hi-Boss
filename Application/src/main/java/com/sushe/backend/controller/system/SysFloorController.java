package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.dto.floor.FloorQueryDTO;
import com.sushe.backend.dto.floor.FloorSaveDTO;
import com.sushe.backend.service.SysFloorService;
import com.sushe.backend.vo.FloorVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 楼层管理控制器
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/floor")
@RequiredArgsConstructor
@Tag(name = "楼层管理", description = "楼层增删改查等")
public class SysFloorController extends BaseCrudController<FloorVO, FloorQueryDTO, FloorSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysFloorService floorService;

    @Override
    public String getEntityName() {
        return "楼层";
    }

    @Override
    protected PageResult<FloorVO> callPageList(FloorQueryDTO queryDTO) {
        return floorService.pageList(queryDTO);
    }

    @Override
    protected FloorVO callGetDetailById(Long id) {
        return floorService.getDetailById(id);
    }

    @Override
    protected boolean callSave(FloorSaveDTO saveDTO) {
        return floorService.saveFloor(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return floorService.deleteFloor(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return floorService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return floorService.updateStatus(id, status);
    }
}

