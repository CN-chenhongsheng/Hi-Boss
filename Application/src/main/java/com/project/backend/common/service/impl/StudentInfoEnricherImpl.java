package com.project.backend.common.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.project.backend.accommodation.entity.Student;
import com.project.backend.common.service.StudentInfoEnricher;
import com.project.backend.organization.entity.Campus;
import com.project.backend.organization.entity.Class;
import com.project.backend.organization.entity.Department;
import com.project.backend.organization.entity.Major;
import com.project.backend.organization.mapper.CampusMapper;
import com.project.backend.organization.mapper.ClassMapper;
import com.project.backend.organization.mapper.DepartmentMapper;
import com.project.backend.organization.mapper.MajorMapper;
import com.project.backend.room.entity.Bed;
import com.project.backend.room.entity.Floor;
import com.project.backend.room.entity.Room;
import com.project.backend.room.mapper.BedMapper;
import com.project.backend.room.mapper.FloorMapper;
import com.project.backend.room.mapper.RoomMapper;
import com.project.backend.util.DictUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * 学生信息填充器实现
 * 用于将学生详细信息填充到 VO 对象中，减少重复代码
 *
 * @author 陈鸿昇
 * @since 2026-01-26
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class StudentInfoEnricherImpl implements StudentInfoEnricher {

    private final CampusMapper campusMapper;
    private final DepartmentMapper departmentMapper;
    private final MajorMapper majorMapper;
    private final ClassMapper classMapper;
    private final FloorMapper floorMapper;
    private final RoomMapper roomMapper;
    private final BedMapper bedMapper;

    @Override
    public void enrichStudentInfo(Student student, Object vo) {
        enrichStudentInfo(student, vo, "campusName");
    }

    @Override
    public void enrichStudentInfo(Student student, Object vo, String campusNameFieldName) {
        if (student == null || vo == null) {
            return;
        }

        try {
            // 填充学生基本信息
            setFieldValue(vo, "gender", student.getGender());
            setFieldValue(vo, "genderText", DictUtils.getLabel("sys_user_sex", student.getGender(), "未知"));
            setFieldValue(vo, "phone", student.getPhone());
            setFieldValue(vo, "nation", student.getNation());
            setFieldValue(vo, "politicalStatus", student.getPoliticalStatus());
            setFieldValue(vo, "enrollmentYear", student.getEnrollmentYear());
            setFieldValue(vo, "currentGrade", student.getCurrentGrade());
            setFieldValue(vo, "academicStatusText", DictUtils.getLabel("academic_status", student.getAcademicStatus(), "未知"));

            // 姓名、学号、编码、学籍状态及 ID 类（与 StudentServiceImpl 对齐）
            setFieldValue(vo, "studentName", student.getStudentName());
            setFieldValue(vo, "studentNo", student.getStudentNo());
            setFieldValue(vo, "campusCode", student.getCampusCode());
            setFieldValue(vo, "floorCode", student.getFloorCode());
            setFieldValue(vo, "academicStatus", student.getAcademicStatus());
            setFieldValue(vo, "deptCode", student.getDeptCode());
            setFieldValue(vo, "majorCode", student.getMajorCode());
            setFieldValue(vo, "classId", student.getClassId());
            setFieldValue(vo, "classCode", student.getClassCode());
            setFieldValue(vo, "floorId", student.getFloorId());
            setFieldValue(vo, "roomId", student.getRoomId());
            setFieldValue(vo, "bedId", student.getBedId());

            // 身份/联系与家庭/紧急联系人（与 StudentVO 基本信息对齐）
            setFieldValue(vo, "idCard", student.getIdCard());
            setFieldValue(vo, "email", student.getEmail());
            setFieldValue(vo, "birthDate", student.getBirthDate());
            setFieldValue(vo, "schoolingLength", student.getSchoolingLength());
            setFieldValue(vo, "homeAddress", student.getHomeAddress());
            setFieldValue(vo, "emergencyContact", student.getEmergencyContact());
            setFieldValue(vo, "emergencyPhone", student.getEmergencyPhone());
            setFieldValue(vo, "parentName", student.getParentName());
            setFieldValue(vo, "parentPhone", student.getParentPhone());

            // 如果校区名称为空，从学生的校区编码查询并填充
            String currentCampusName = getFieldValue(vo, campusNameFieldName);
            if (StrUtil.isBlank(currentCampusName) && StrUtil.isNotBlank(student.getCampusCode())) {
                LambdaQueryWrapper<Campus> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Campus::getCampusCode, student.getCampusCode());
                Campus campus = campusMapper.selectOne(wrapper);
                if (campus != null) {
                    setFieldValue(vo, campusNameFieldName, campus.getCampusName());
                }
            }

            // 查询并填充院系名称
            if (StrUtil.isNotBlank(student.getDeptCode())) {
                LambdaQueryWrapper<Department> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Department::getDeptCode, student.getDeptCode());
                Department department = departmentMapper.selectOne(wrapper);
                if (department != null) {
                    setFieldValue(vo, "deptName", department.getDeptName());
                }
            }

            // 查询并填充专业名称
            if (StrUtil.isNotBlank(student.getMajorCode())) {
                LambdaQueryWrapper<Major> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Major::getMajorCode, student.getMajorCode());
                Major major = majorMapper.selectOne(wrapper);
                if (major != null) {
                    setFieldValue(vo, "majorName", major.getMajorName());
                }
            }

            // 查询并填充班级名称
            if (student.getClassId() != null) {
                Class classEntity = classMapper.selectById(student.getClassId());
                if (classEntity != null) {
                    setFieldValue(vo, "className", classEntity.getClassName());
                }
            }

            // 查询并填充楼层名称
            if (student.getFloorId() != null) {
                Floor floor = floorMapper.selectById(student.getFloorId());
                if (floor != null) {
                    setFieldValue(vo, "floorName", floor.getFloorName());
                }
            } else if (StrUtil.isNotBlank(student.getFloorCode())) {
                LambdaQueryWrapper<Floor> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Floor::getFloorCode, student.getFloorCode());
                Floor floor = floorMapper.selectOne(wrapper);
                if (floor != null) {
                    setFieldValue(vo, "floorName", floor.getFloorName());
                }
            }

            // 查询并填充房间名称
            if (student.getRoomId() != null) {
                Room room = roomMapper.selectById(student.getRoomId());
                if (room != null) {
                    setFieldValue(vo, "roomName", room.getRoomNumber());
                }
            } else if (StrUtil.isNotBlank(student.getRoomCode())) {
                LambdaQueryWrapper<Room> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Room::getRoomCode, student.getRoomCode());
                Room room = roomMapper.selectOne(wrapper);
                if (room != null) {
                    setFieldValue(vo, "roomName", room.getRoomNumber());
                }
            }

            // 查询并填充床位名称
            if (student.getBedId() != null) {
                Bed bed = bedMapper.selectById(student.getBedId());
                if (bed != null) {
                    setFieldValue(vo, "bedName", bed.getBedNumber());
                }
            } else if (StrUtil.isNotBlank(student.getBedCode())) {
                LambdaQueryWrapper<Bed> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(Bed::getBedCode, student.getBedCode());
                Bed bed = bedMapper.selectOne(wrapper);
                if (bed != null) {
                    setFieldValue(vo, "bedName", bed.getBedNumber());
                }
            }
        } catch (Exception e) {
            log.error("填充学生信息失败: studentId={}, voClass={}", student.getId(), vo.getClass().getName(), e);
        }
    }

    /**
     * 使用反射设置字段值
     */
    private void setFieldValue(Object obj, String fieldName, Object value) {
        if (obj == null || StrUtil.isBlank(fieldName)) {
            return;
        }
        try {
            BeanUtil.setFieldValue(obj, fieldName, value);
        } catch (Exception e) {
            log.debug("设置字段失败: fieldName={}, value={}, error={}", fieldName, value, e.getMessage());
        }
    }

    /**
     * 使用反射获取字段值
     */
    private String getFieldValue(Object obj, String fieldName) {
        if (obj == null || StrUtil.isBlank(fieldName)) {
            return null;
        }
        try {
            Object value = BeanUtil.getFieldValue(obj, fieldName);
            return value != null ? value.toString() : null;
        } catch (Exception e) {
            log.debug("获取字段失败: fieldName={}, error={}", fieldName, e.getMessage());
            return null;
        }
    }
}
