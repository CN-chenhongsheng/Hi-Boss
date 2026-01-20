package com.project.app.controller;

import com.project.core.result.R;
import com.project.backend.accommodation.dto.student.StudentLifestyleDTO;
import com.project.app.service.StudentService;
import com.project.backend.accommodation.vo.student.DormInfoVO;
import com.project.backend.accommodation.vo.student.RoommateVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 学生端控制器
 *
 * @author 陈鸿昇
 * @since 2026-01-16
 */
@Slf4j
@Tag(name = "学生端", description = "学生端相关接口")
@RestController("appStudentController")
@RequestMapping("/v1/app/student")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    /**
     * 获取当前学生的宿舍信息
     */
    @Operation(summary = "获取宿舍信息")
    @GetMapping("/dorm-info")
    public R<DormInfoVO> getDormInfo() {
        DormInfoVO dormInfo = studentService.getCurrentStudentDormInfo();
        return R.ok(dormInfo);
    }

    /**
     * 获取当前学生的室友列表
     */
    @Operation(summary = "获取室友列表")
    @GetMapping("/roommates")
    public R<List<RoommateVO>> getRoommates() {
        List<RoommateVO> roommates = studentService.getCurrentStudentRoommates();
        return R.ok(roommates);
    }

    /**
     * 获取当前学生的生活习惯信息
     */
    @Operation(summary = "获取生活习惯信息")
    @GetMapping("/habits")
    public R<StudentLifestyleDTO> getHabits() {
        StudentLifestyleDTO habits = studentService.getCurrentStudentHabits();
        return R.ok(habits);
    }

    /**
     * 更新当前学生的生活习惯信息
     */
    @Operation(summary = "更新生活习惯信息")
    @PutMapping("/habits")
    public R<Void> updateHabits(@RequestBody StudentLifestyleDTO dto) {
        studentService.updateCurrentStudentHabits(dto);
        return R.ok();
    }
}
