-- ============================================================
-- 修复唯一索引以支持软删除后重复数据
-- 创建日期: 2026-01-30
-- 说明: 将所有唯一索引改为包含deleted字段的复合唯一索引
--      允许软删除后重新创建相同的业务数据
-- ============================================================

USE project_management;

-- ============================================================
-- 1. 系统管理模块
-- ============================================================

-- sys_user 表 - 用户名唯一约束
ALTER TABLE sys_user DROP INDEX uk_username;
ALTER TABLE sys_user ADD UNIQUE KEY uk_username (username, deleted);

-- sys_role 表 - 角色编码唯一约束
ALTER TABLE sys_role DROP INDEX uk_role_code;
ALTER TABLE sys_role ADD UNIQUE KEY uk_role_code (role_code, deleted);

-- sys_dict_type 表 - 字典类型编码唯一约束
ALTER TABLE sys_dict_type DROP INDEX uk_dict_code;
ALTER TABLE sys_dict_type ADD UNIQUE KEY uk_dict_code (dict_code, deleted);

-- sys_user_role 表 - 用户角色关联唯一约束
ALTER TABLE sys_user_role DROP INDEX uk_user_role;
ALTER TABLE sys_user_role ADD UNIQUE KEY uk_user_role (user_id, role_id, deleted);

-- sys_role_menu 表 - 角色菜单关联唯一约束
ALTER TABLE sys_role_menu DROP INDEX uk_role_menu;
ALTER TABLE sys_role_menu ADD UNIQUE KEY uk_role_menu (role_id, menu_id, deleted);

-- sys_user_menu 表 - 用户菜单关联唯一约束
ALTER TABLE sys_user_menu DROP INDEX uk_user_menu;
ALTER TABLE sys_user_menu ADD UNIQUE KEY uk_user_menu (user_id, menu_id, deleted);

-- ============================================================
-- 2. 审批流程模块
-- ============================================================

-- sys_approval_flow 表 - 审批流程编码唯一约束
ALTER TABLE sys_approval_flow DROP INDEX uk_flow_code;
ALTER TABLE sys_approval_flow ADD UNIQUE KEY uk_flow_code (flow_code, deleted);

-- sys_approval_flow_binding 表 - 业务类型唯一约束
ALTER TABLE sys_approval_flow_binding DROP INDEX uk_business_type;
ALTER TABLE sys_approval_flow_binding ADD UNIQUE KEY uk_business_type (business_type, deleted);

-- sys_approval_instance 表 - 业务实例唯一约束
ALTER TABLE sys_approval_instance DROP INDEX uk_business;
ALTER TABLE sys_approval_instance ADD UNIQUE KEY uk_business (business_type, business_id, deleted);

-- ============================================================
-- 3. 组织管理模块
-- ============================================================

-- sys_campus 表 - 校区编码唯一约束
ALTER TABLE sys_campus DROP INDEX uk_campus_code;
ALTER TABLE sys_campus ADD UNIQUE KEY uk_campus_code (campus_code, deleted);

-- sys_department 表 - 院系编码唯一约束
ALTER TABLE sys_department DROP INDEX uk_dept_code;
ALTER TABLE sys_department ADD UNIQUE KEY uk_dept_code (dept_code, deleted);

-- sys_class 表 - 班级编码唯一约束
ALTER TABLE sys_class DROP INDEX uk_class_code;
ALTER TABLE sys_class ADD UNIQUE KEY uk_class_code (class_code, deleted);

-- sys_major 表 - 专业编码唯一约束
ALTER TABLE sys_major DROP INDEX uk_major_code;
ALTER TABLE sys_major ADD UNIQUE KEY uk_major_code (major_code, deleted);

-- ============================================================
-- 4. 学生模块
-- ============================================================

-- sys_student 表 - 学号唯一约束
ALTER TABLE sys_student DROP INDEX uk_student_no;
ALTER TABLE sys_student ADD UNIQUE KEY uk_student_no (student_no, deleted);

-- ============================================================
-- 5. 学年学期模块
-- ============================================================

-- sys_academic_year 表 - 学年编码唯一约束
ALTER TABLE sys_academic_year DROP INDEX uk_year_code;
ALTER TABLE sys_academic_year ADD UNIQUE KEY uk_year_code (year_code, deleted);

-- sys_semester 表 - 学期编码唯一约束
ALTER TABLE sys_semester DROP INDEX uk_semester_code;
ALTER TABLE sys_semester ADD UNIQUE KEY uk_semester_code (semester_code, deleted);

-- ============================================================
-- 6. 房间管理模块
-- ============================================================

-- sys_floor 表 - 楼层编码唯一约束
ALTER TABLE sys_floor DROP INDEX uk_floor_code;
ALTER TABLE sys_floor ADD UNIQUE KEY uk_floor_code (floor_code, deleted);

-- sys_room 表 - 房间编码唯一约束
ALTER TABLE sys_room DROP INDEX uk_room_code;
ALTER TABLE sys_room ADD UNIQUE KEY uk_room_code (room_code, deleted);

-- sys_bed 表 - 床位编码唯一约束
ALTER TABLE sys_bed DROP INDEX uk_bed_code;
ALTER TABLE sys_bed ADD UNIQUE KEY uk_bed_code (bed_code, deleted);

-- ============================================================
-- 7. 通知模块
-- ============================================================

-- sys_notice_read 表 - 通知用户关联唯一约束
ALTER TABLE sys_notice_read DROP INDEX uk_notice_user;
ALTER TABLE sys_notice_read ADD UNIQUE KEY uk_notice_user (notice_id, user_id, deleted);

-- ============================================================
-- 验证索引修改
-- ============================================================

SELECT
    TABLE_NAME AS '表名',
    INDEX_NAME AS '索引名',
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS '索引字段'
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND INDEX_NAME LIKE 'uk_%'
    AND NON_UNIQUE = 0
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;

-- ============================================================
-- 执行说明
-- ============================================================
--
-- 执行方式:
-- mysql -u root -p project_management < Application/sql/fix_unique_index_with_deleted.sql
--
-- 验证方式:
-- 1. 检查所有唯一索引是否包含deleted字段
-- 2. 测试删除后重新创建相同数据是否成功
--
-- 回滚方式:
-- 如需回滚，执行对应的DROP和ADD语句，去掉deleted字段
-- 例如: ALTER TABLE sys_user DROP INDEX uk_username;
--      ALTER TABLE sys_user ADD UNIQUE KEY uk_username (username);
--
-- ============================================================
