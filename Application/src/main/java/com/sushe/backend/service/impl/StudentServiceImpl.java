package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.sushe.backend.common.context.UserContext;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.dto.student.StudentLifestyleDTO;
import com.sushe.backend.entity.SysBed;
import com.sushe.backend.entity.SysCampus;
import com.sushe.backend.entity.SysFloor;
import com.sushe.backend.entity.SysRoom;
import com.sushe.backend.entity.SysStudent;
import com.sushe.backend.mapper.SysBedMapper;
import com.sushe.backend.mapper.SysCampusMapper;
import com.sushe.backend.mapper.SysFloorMapper;
import com.sushe.backend.mapper.SysRoomMapper;
import com.sushe.backend.mapper.SysStudentMapper;
import com.sushe.backend.service.StudentService;
import com.sushe.backend.service.SysStudentService;
import com.sushe.backend.vo.student.DormInfoVO;
import com.sushe.backend.vo.student.RoommateVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 学生端Service实现
 *
 * @author 陈鸿昇
 * @since 2026-01-16
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final SysStudentMapper studentMapper;
    private final SysCampusMapper campusMapper;
    private final SysFloorMapper floorMapper;
    private final SysRoomMapper roomMapper;
    private final SysBedMapper bedMapper;
    private final SysStudentService sysStudentService;

    @Override
    public DormInfoVO getCurrentStudentDormInfo() {
        // 获取当前登录用户
        String username = UserContext.getUsername();
        if (StrUtil.isBlank(username)) {
            throw new BusinessException("用户未登录");
        }

        // 根据学号查询学生信息
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysStudent::getStudentNo, username);
        SysStudent student = studentMapper.selectOne(wrapper);

        if (student == null) {
            throw new BusinessException("学生信息不存在");
        }

        DormInfoVO dormInfo = new DormInfoVO();

        // 查询校区名称
        if (StrUtil.isNotBlank(student.getCampusCode())) {
            LambdaQueryWrapper<SysCampus> campusWrapper = new LambdaQueryWrapper<>();
            campusWrapper.eq(SysCampus::getCampusCode, student.getCampusCode());
            SysCampus campus = campusMapper.selectOne(campusWrapper);
            if (campus != null) {
                dormInfo.setCampusName(campus.getCampusName());
            }
        }

        // 查询楼栋/楼层名称
        if (StrUtil.isNotBlank(student.getFloorCode())) {
            LambdaQueryWrapper<SysFloor> floorWrapper = new LambdaQueryWrapper<>();
            floorWrapper.eq(SysFloor::getFloorCode, student.getFloorCode());
            SysFloor floor = floorMapper.selectOne(floorWrapper);
            if (floor != null) {
                dormInfo.setBuildingName(floor.getFloorName());
                dormInfo.setFloorName(floor.getFloorNumber() + "层");
            }
        }

        // 设置房间号和床位号
        dormInfo.setRoomCode(student.getRoomCode());
        dormInfo.setBedCode(student.getBedCode());

        // 查询入住日期
        if (student.getBedId() != null) {
            SysBed bed = bedMapper.selectById(student.getBedId());
            if (bed != null) {
                dormInfo.setCheckInDate(bed.getCheckInDate());
            }
        }

        return dormInfo;
    }

    @Override
    public List<RoommateVO> getCurrentStudentRoommates() {
        // 获取当前登录用户
        String username = UserContext.getUsername();
        if (StrUtil.isBlank(username)) {
            throw new BusinessException("用户未登录");
        }

        // 根据学号查询学生信息
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysStudent::getStudentNo, username);
        SysStudent currentStudent = studentMapper.selectOne(wrapper);

        if (currentStudent == null) {
            throw new BusinessException("学生信息不存在");
        }

        // 如果没有房间信息，返回空列表
        if (currentStudent.getRoomId() == null) {
            return new ArrayList<>();
        }

        // 查询同房间的其他学生
        LambdaQueryWrapper<SysStudent> roommateWrapper = new LambdaQueryWrapper<>();
        roommateWrapper.eq(SysStudent::getRoomId, currentStudent.getRoomId())
                .ne(SysStudent::getId, currentStudent.getId())
                .eq(SysStudent::getStatus, 1);

        List<SysStudent> roommates = studentMapper.selectList(roommateWrapper);

        return roommates.stream().map(student -> {
            RoommateVO vo = new RoommateVO();
            vo.setId(student.getId());
            vo.setStudentNo(student.getStudentNo());
            vo.setStudentName(student.getStudentName());
            vo.setPhone(student.getPhone());
            vo.setBedCode(student.getBedCode());
            // 头像暂时为空，学生表没有头像字段
            vo.setAvatar(null);
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public StudentLifestyleDTO getCurrentStudentHabits() {
        // 获取当前登录用户
        String username = UserContext.getUsername();
        if (StrUtil.isBlank(username)) {
            throw new BusinessException("用户未登录");
        }

        // 根据学号查询学生信息
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysStudent::getStudentNo, username);
        SysStudent student = studentMapper.selectOne(wrapper);

        if (student == null) {
            throw new BusinessException("学生信息不存在");
        }

        // 转换为DTO
        StudentLifestyleDTO dto = new StudentLifestyleDTO();
        BeanUtil.copyProperties(student, dto);
        return dto;
    }

    @Override
    public boolean updateCurrentStudentHabits(StudentLifestyleDTO dto) {
        // 获取当前登录用户
        String username = UserContext.getUsername();
        if (StrUtil.isBlank(username)) {
            throw new BusinessException("用户未登录");
        }

        // 根据学号查询学生信息
        LambdaQueryWrapper<SysStudent> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysStudent::getStudentNo, username);
        SysStudent student = studentMapper.selectOne(wrapper);

        if (student == null) {
            throw new BusinessException("学生信息不存在");
        }

        // 调用更新方法
        return sysStudentService.updateLifestyle(student.getId(), dto);
    }
}
