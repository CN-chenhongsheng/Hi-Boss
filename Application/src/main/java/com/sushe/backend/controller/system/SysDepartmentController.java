package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.controller.base.TreeController;
import com.sushe.backend.dto.department.DepartmentQueryDTO;
import com.sushe.backend.dto.department.DepartmentSaveDTO;
import com.sushe.backend.service.SysDepartmentService;
import com.sushe.backend.vo.DepartmentVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
public class SysDepartmentController extends BaseCrudController<DepartmentVO, DepartmentQueryDTO, DepartmentSaveDTO>
        implements TreeController<DepartmentVO, DepartmentQueryDTO>, 
                   BatchDeleteController, 
                   StatusUpdateController {

    private final SysDepartmentService departmentService;

    @Override
    public String getEntityName() {
        return "院系";
    }

    @Override
    protected PageResult<DepartmentVO> callPageList(DepartmentQueryDTO queryDTO) {
        return departmentService.pageList(queryDTO);
    }

    @Override
    protected DepartmentVO callGetDetailById(Long id) {
        return departmentService.getDetailById(id);
    }

    @Override
    protected boolean callSave(DepartmentSaveDTO saveDTO) {
        return departmentService.saveDepartment(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return departmentService.deleteDepartment(id);
    }

    @Override
    public List<DepartmentVO> callTreeList(DepartmentQueryDTO queryDTO) {
        return departmentService.treeList(queryDTO);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return departmentService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return departmentService.updateStatus(id, status);
    }
}
