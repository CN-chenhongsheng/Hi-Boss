package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.dto.classes.ClassQueryDTO;
import com.sushe.backend.dto.classes.ClassSaveDTO;
import com.sushe.backend.service.SysClassService;
import com.sushe.backend.vo.ClassVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 班级管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/class")
@RequiredArgsConstructor
@Tag(name = "班级管理", description = "班级增删改查等")
public class SysClassController extends BaseCrudController<ClassVO, ClassQueryDTO, ClassSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysClassService classService;

    @Override
    public String getEntityName() {
        return "班级";
    }

    @Override
    protected PageResult<ClassVO> callPageList(ClassQueryDTO queryDTO) {
        return classService.pageList(queryDTO);
    }

    @Override
    protected ClassVO callGetDetailById(Long id) {
        return classService.getDetailById(id);
    }

    @Override
    protected boolean callSave(ClassSaveDTO saveDTO) {
        return classService.saveClass(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return classService.deleteClass(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return classService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return classService.updateStatus(id, status);
    }
}
