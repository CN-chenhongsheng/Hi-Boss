package com.sushe.backend.service;

import com.sushe.backend.vo.student.DormInfoVO;
import com.sushe.backend.vo.student.RoommateVO;

import java.util.List;

/**
 * 学生端Service
 *
 * @author 陈鸿昇
 * @since 2026-01-16
 */
public interface StudentService {

    /**
     * 获取当前学生的宿舍信息
     *
     * @return 宿舍信息
     */
    DormInfoVO getCurrentStudentDormInfo();

    /**
     * 获取当前学生的室友列表
     *
     * @return 室友列表
     */
    List<RoommateVO> getCurrentStudentRoommates();
}
