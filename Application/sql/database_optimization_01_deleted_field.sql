-- ============================================================
-- 数据库优化脚本 - 添加逻辑删除字段
-- 执行时间：2026-01-30
-- 作者：Claude Code
-- 版本：v1.0
-- 说明：为所有业务表添加 deleted 字段，实现逻辑删除功能
-- ============================================================

USE project_management;

-- ============================================================
-- 注意事项
-- ============================================================
-- 1. 执行前请先备份数据库
-- 2. 建议在业务低峰期执行
-- 3. 执行后需同步修改后端 Entity 类
-- 4. sys_oper_log 不需要逻辑删除字段（历史记录表）
-- ============================================================

-- ============================================================
-- 1. 修改 sys_user 表（重命名 del_flag 为 deleted）
-- ============================================================
ALTER TABLE sys_user
CHANGE COLUMN del_flag deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 2. 核心业务表 - 学生管理
-- ============================================================
ALTER TABLE sys_student
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER status;

-- ============================================================
-- 3. 核心业务表 - 申请管理
-- ============================================================
ALTER TABLE sys_check_in
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_transfer
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_check_out
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_stay
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER images;

-- ============================================================
-- 4. 核心业务表 - 报修和通知
-- ============================================================
ALTER TABLE sys_repair
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_notice
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_notice_read
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 5. 宿舍管理表
-- ============================================================
ALTER TABLE sys_campus
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_floor
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_room
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_bed
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

-- ============================================================
-- 6. 组织架构表
-- ============================================================
ALTER TABLE sys_department
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_major
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_class
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 7. 权限管理表
-- ============================================================
ALTER TABLE sys_role
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_menu
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_role_menu
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_user_role
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_user_menu
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 8. 审批流程表
-- ============================================================
ALTER TABLE sys_approval_flow
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_approval_flow_binding
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_approval_instance
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除'
AFTER remark;

ALTER TABLE sys_approval_node
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_approval_node_assignee
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_approval_record
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 9. 字典表
-- ============================================================
ALTER TABLE sys_dict_type
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_dict_data
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 10. 学期和学年表
-- ============================================================
ALTER TABLE sys_semester
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

ALTER TABLE sys_academic_year
ADD COLUMN deleted tinyint NOT NULL DEFAULT 0
COMMENT '删除标记：0-未删除 1-已删除';

-- ============================================================
-- 验证：检查所有表是否都有 deleted 字段
-- ============================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'deleted'
ORDER BY TABLE_NAME;

-- 期望结果：应该有 31 行记录（除了 sys_oper_log）

-- ============================================================
-- 执行完成提示
-- ============================================================
SELECT '✅ 逻辑删除字段添加完成！' AS status,
       '请执行上面的 SELECT 语句验证结果' AS next_step,
       '后续需要修改后端 Entity 类，添加 @TableLogic 注解' AS reminder;
