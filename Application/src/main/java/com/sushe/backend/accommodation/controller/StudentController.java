package com.sushe.backend.accommodation.controller;

import com.sushe.backend.accommodation.dto.student.StudentQueryDTO;
import com.sushe.backend.accommodation.dto.student.StudentSaveDTO;
import com.sushe.backend.accommodation.service.StudentService;
import com.sushe.backend.accommodation.vo.StudentVO;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 学生管理Controller
 * 
 * @author 陈鸿昇
 * @since 2026-01-06
 */
@RestController
@RequestMapping("/v1/system/student")
@RequiredArgsConstructor
public class StudentController extends BaseCrudController<StudentVO, StudentQueryDTO, StudentSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final StudentService studentService;

    @Override
    public String getEntityName() {
        return "学生";
    }

    @Override
    protected PageResult<StudentVO> callPageList(StudentQueryDTO queryDTO) {
        return studentService.pageList(queryDTO);
    }

    @Override
    protected StudentVO callGetDetailById(Long id) {
        return studentService.getDetailById(id);
    }

    @Override
    protected boolean callSave(StudentSaveDTO saveDTO) {
        return studentService.saveStudent(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return studentService.deleteStudent(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return studentService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return studentService.updateStatus(id, status);
    }
}
