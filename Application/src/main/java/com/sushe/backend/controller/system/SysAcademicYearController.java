package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.dto.academicyear.AcademicYearQueryDTO;
import com.sushe.backend.dto.academicyear.AcademicYearSaveDTO;
import com.sushe.backend.service.SysAcademicYearService;
import com.sushe.backend.vo.AcademicYearVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 学年管理控制器
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/system/academic-year")
@RequiredArgsConstructor
@Tag(name = "学年管理", description = "学年增删改查、状态更新等")
public class SysAcademicYearController extends BaseCrudController<AcademicYearVO, AcademicYearQueryDTO, AcademicYearSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysAcademicYearService academicYearService;

    @Override
    public String getEntityName() {
        return "学年";
    }

    @Override
    protected PageResult<AcademicYearVO> callPageList(AcademicYearQueryDTO queryDTO) {
        return academicYearService.pageList(queryDTO);
    }

    @Override
    protected AcademicYearVO callGetDetailById(Long id) {
        return academicYearService.getDetailById(id);
    }

    @Override
    protected boolean callSave(AcademicYearSaveDTO saveDTO) {
        return academicYearService.saveAcademicYear(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return academicYearService.deleteAcademicYear(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return academicYearService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return academicYearService.updateStatus(id, status);
    }
}

