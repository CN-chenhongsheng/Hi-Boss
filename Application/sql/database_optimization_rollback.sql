-- ============================================================
-- 数据库优化回滚脚本
-- 执行时间：2026-01-30
-- 作者：Claude Code
-- 版本：v1.0
-- 说明：如果优化出现问题，可以使用此脚本回滚更改
-- ============================================================

USE project_management;

-- ============================================================
-- ⚠️ 警告：此脚本会删除所有优化内容
-- ============================================================
-- 1. 执行前请确认需要回滚
-- 2. 建议先使用数据库备份恢复
-- 3. 此脚本仅在无法使用备份时使用
-- 4. 回滚后数据不会丢失，但优化效果会消失
-- ============================================================

-- ============================================================
-- 确认回滚操作（需要手动执行）
-- ============================================================
-- 取消下面的注释以确认回滚：
-- SET @confirm_rollback = 'YES';

-- 检查确认标志
SELECT
    CASE
        WHEN @confirm_rollback = 'YES' THEN '⚠️ 开始回滚操作...'
        ELSE '❌ 未确认回滚，请设置 @confirm_rollback = ''YES'''
    END AS rollback_status;

-- 如果未确认，停止执行
-- SELECT IF(@confirm_rollback != 'YES',
--          (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NOT_EXISTS'),
--          1);

-- ============================================================
-- 1. 回滚逻辑删除字段
-- ============================================================

SELECT '========== 开始回滚逻辑删除字段 ==========' AS rollback_section;

-- 1. 将 sys_user 的 deleted 改回 del_flag
ALTER TABLE sys_user
CHANGE COLUMN deleted del_flag int NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- 2. 删除其他表的 deleted 字段
ALTER TABLE sys_student DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_check_in DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_transfer DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_check_out DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_stay DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_repair DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_notice DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_notice_read DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_campus DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_floor DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_room DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_bed DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_department DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_major DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_class DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_role DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_menu DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_role_menu DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_user_role DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_user_menu DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_flow DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_flow_binding DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_instance DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_node DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_node_assignee DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_approval_record DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_dict_type DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_dict_data DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_semester DROP COLUMN IF EXISTS deleted;
ALTER TABLE sys_academic_year DROP COLUMN IF EXISTS deleted;

SELECT '✅ 逻辑删除字段回滚完成' AS rollback_status;

-- ============================================================
-- 2. 回滚 status 字段类型（可选）
-- ============================================================

SELECT '========== 开始回滚 Status 字段类型 ==========' AS rollback_section;

-- 如果需要恢复为原来的 int 类型，取消下面的注释
/*
ALTER TABLE sys_check_in MODIFY COLUMN status int NOT NULL DEFAULT 1;
ALTER TABLE sys_transfer MODIFY COLUMN status int NOT NULL DEFAULT 1;
ALTER TABLE sys_check_out MODIFY COLUMN status int NOT NULL DEFAULT 1;
ALTER TABLE sys_stay MODIFY COLUMN status int NOT NULL DEFAULT 1;
ALTER TABLE sys_repair MODIFY COLUMN status int NOT NULL DEFAULT 1;
ALTER TABLE sys_notice MODIFY COLUMN status int DEFAULT 0;
ALTER TABLE sys_approval_instance MODIFY COLUMN status int NOT NULL DEFAULT 1;
*/

SELECT '⚠️ Status 字段类型回滚已跳过（取消注释以执行）' AS rollback_status;

-- ============================================================
-- 3. 回滚索引优化
-- ============================================================

SELECT '========== 开始删除优化索引 ==========' AS rollback_section;

-- 学生管理表索引
ALTER TABLE sys_student DROP INDEX IF EXISTS idx_status_year;
ALTER TABLE sys_student DROP INDEX IF EXISTS idx_class;
ALTER TABLE sys_student DROP INDEX IF EXISTS idx_major;

-- 申请管理表索引
ALTER TABLE sys_check_in DROP INDEX IF EXISTS idx_student_status;
ALTER TABLE sys_check_in DROP INDEX IF EXISTS idx_apply_date;
ALTER TABLE sys_check_in DROP INDEX IF EXISTS idx_bed;

ALTER TABLE sys_transfer DROP INDEX IF EXISTS idx_student_status;
ALTER TABLE sys_transfer DROP INDEX IF EXISTS idx_apply_date;
ALTER TABLE sys_transfer DROP INDEX IF EXISTS idx_from_bed;
ALTER TABLE sys_transfer DROP INDEX IF EXISTS idx_to_bed;

ALTER TABLE sys_check_out DROP INDEX IF EXISTS idx_student_status;
ALTER TABLE sys_check_out DROP INDEX IF EXISTS idx_apply_date;
ALTER TABLE sys_check_out DROP INDEX IF EXISTS idx_bed;

ALTER TABLE sys_stay DROP INDEX IF EXISTS idx_student_status;
ALTER TABLE sys_stay DROP INDEX IF EXISTS idx_stay_dates;
ALTER TABLE sys_stay DROP INDEX IF EXISTS idx_bed;

-- 报修管理索引
ALTER TABLE sys_repair DROP INDEX IF EXISTS idx_student_status;
ALTER TABLE sys_repair DROP INDEX IF EXISTS idx_repairer_status;
ALTER TABLE sys_repair DROP INDEX IF EXISTS idx_room;
ALTER TABLE sys_repair DROP INDEX IF EXISTS idx_type_urgent;
ALTER TABLE sys_repair DROP INDEX IF EXISTS idx_repair_time;

-- 通知管理索引
ALTER TABLE sys_notice DROP INDEX IF EXISTS idx_type_status_top;
ALTER TABLE sys_notice DROP INDEX IF EXISTS idx_publish_time;
ALTER TABLE sys_notice_read DROP INDEX IF EXISTS idx_user_notice;
ALTER TABLE sys_notice_read DROP INDEX IF EXISTS idx_notice;

-- 宿舍管理索引
ALTER TABLE sys_room DROP INDEX IF EXISTS idx_floor_status;
ALTER TABLE sys_room DROP INDEX IF EXISTS idx_campus_floor;
ALTER TABLE sys_room DROP INDEX IF EXISTS idx_room_type;

ALTER TABLE sys_bed DROP INDEX IF EXISTS idx_room_status;
ALTER TABLE sys_bed DROP INDEX IF EXISTS idx_student;

ALTER TABLE sys_floor DROP INDEX IF EXISTS idx_campus;
ALTER TABLE sys_floor DROP INDEX IF EXISTS idx_gender;

-- 审批流程索引
ALTER TABLE sys_approval_instance DROP INDEX IF EXISTS uk_business;
ALTER TABLE sys_approval_instance DROP INDEX IF EXISTS idx_applicant_status;
ALTER TABLE sys_approval_instance DROP INDEX IF EXISTS idx_flow;

ALTER TABLE sys_approval_record DROP INDEX IF EXISTS idx_instance;
ALTER TABLE sys_approval_record DROP INDEX IF EXISTS idx_approver_status;

ALTER TABLE sys_approval_flow_binding DROP INDEX IF EXISTS idx_business_type;

ALTER TABLE sys_approval_node DROP INDEX IF EXISTS idx_flow;

ALTER TABLE sys_approval_node_assignee DROP INDEX IF EXISTS idx_node;
ALTER TABLE sys_approval_node_assignee DROP INDEX IF EXISTS idx_assignee;

-- 操作日志索引
ALTER TABLE sys_oper_log DROP INDEX IF EXISTS idx_business_time;
ALTER TABLE sys_oper_log DROP INDEX IF EXISTS idx_oper_name;
ALTER TABLE sys_oper_log DROP INDEX IF EXISTS idx_status_time;
ALTER TABLE sys_oper_log DROP INDEX IF EXISTS idx_title;

-- 字典管理索引
ALTER TABLE sys_dict_data DROP INDEX IF EXISTS idx_type_sort;
ALTER TABLE sys_dict_data DROP INDEX IF EXISTS idx_dict_value;

-- 组织架构索引
ALTER TABLE sys_major DROP INDEX IF EXISTS idx_department;
ALTER TABLE sys_class DROP INDEX IF EXISTS idx_major;
ALTER TABLE sys_class DROP INDEX IF EXISTS idx_grade;

-- 权限管理索引
ALTER TABLE sys_user_role DROP INDEX IF EXISTS idx_user;
ALTER TABLE sys_user_role DROP INDEX IF EXISTS idx_role;

ALTER TABLE sys_role_menu DROP INDEX IF EXISTS idx_role;
ALTER TABLE sys_role_menu DROP INDEX IF EXISTS idx_menu;

ALTER TABLE sys_user_menu DROP INDEX IF EXISTS idx_user;
ALTER TABLE sys_user_menu DROP INDEX IF EXISTS idx_menu;

SELECT '✅ 索引回滚完成' AS rollback_status;

-- ============================================================
-- 4. 验证回滚结果
-- ============================================================

SELECT '========== 验证回滚结果 ==========' AS rollback_section;

-- 检查 deleted 字段是否已删除
SELECT
    COUNT(DISTINCT TABLE_NAME) AS tables_with_deleted_field,
    '应该为 0 或 1（sys_user 的 del_flag）' AS expected
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'deleted';

-- 检查 del_flag 是否恢复
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    '✅ del_flag 已恢复' AS status
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_NAME = 'sys_user'
    AND COLUMN_NAME = 'del_flag';

-- 检查优化索引是否已删除
SELECT
    COUNT(DISTINCT INDEX_NAME) AS remaining_optimization_indexes,
    '应该接近 0' AS expected
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%');

-- ============================================================
-- 回滚完成提示
-- ============================================================
SELECT
    '✅ 回滚操作完成！' AS status,
    '数据库已恢复到优化前状态' AS result,
    '如需重新优化，请执行优化脚本' AS next_step,
    '建议分析回滚原因，避免再次出现问题' AS reminder;

-- ============================================================
-- 备注：字段注释回滚
-- ============================================================
-- 注意：字段注释的回滚不包含在此脚本中
-- 原因：字段注释不影响功能，且难以精确恢复原始注释
-- 如需恢复，请使用数据库备份
