-- ============================================================
-- 关联表审计字段补充
-- ============================================================
-- 功能：为4个关联表添加缺失的审计字段，支持软删除功能
-- 涉及表：sys_user_role, sys_user_menu, sys_role_menu, sys_approval_node_assignee
-- 执行时机：在实体类改造之前
-- 作者：Claude Code
-- 日期：2026-01-30
-- ============================================================

USE project_management;

-- ============================================================
-- 1. sys_user_role 表 - 添加审计字段
-- ============================================================
ALTER TABLE sys_user_role
ADD COLUMN update_time datetime DEFAULT NULL COMMENT '更新时间' AFTER create_time,
ADD COLUMN create_by bigint DEFAULT NULL COMMENT '创建人ID' AFTER update_time,
ADD COLUMN update_by bigint DEFAULT NULL COMMENT '更新人ID' AFTER create_by;

-- ============================================================
-- 2. sys_user_menu 表 - 添加审计字段
-- ============================================================
ALTER TABLE sys_user_menu
ADD COLUMN update_time datetime DEFAULT NULL COMMENT '更新时间' AFTER create_time,
ADD COLUMN create_by bigint DEFAULT NULL COMMENT '创建人ID' AFTER update_time,
ADD COLUMN update_by bigint DEFAULT NULL COMMENT '更新人ID' AFTER create_by;

-- ============================================================
-- 3. sys_role_menu 表 - 添加审计字段
-- ============================================================
ALTER TABLE sys_role_menu
ADD COLUMN update_time datetime DEFAULT NULL COMMENT '更新时间' AFTER create_time,
ADD COLUMN create_by bigint DEFAULT NULL COMMENT '创建人ID' AFTER update_time,
ADD COLUMN update_by bigint DEFAULT NULL COMMENT '更新人ID' AFTER create_by;

-- ============================================================
-- 4. sys_approval_node_assignee 表 - 添加审计字段
-- ============================================================
ALTER TABLE sys_approval_node_assignee
ADD COLUMN update_time datetime DEFAULT NULL COMMENT '更新时间' AFTER create_time,
ADD COLUMN update_by bigint DEFAULT NULL COMMENT '更新人ID' AFTER create_by;

-- ============================================================
-- 5. 性能优化索引
-- ============================================================
-- sys_user_role 表索引
ALTER TABLE sys_user_role ADD INDEX idx_deleted (deleted);
ALTER TABLE sys_user_role ADD INDEX idx_user_deleted (user_id, deleted);
ALTER TABLE sys_user_role ADD INDEX idx_role_deleted (role_id, deleted);

-- sys_user_menu 表索引
ALTER TABLE sys_user_menu ADD INDEX idx_deleted (deleted);
ALTER TABLE sys_user_menu ADD INDEX idx_user_deleted (user_id, deleted);
ALTER TABLE sys_user_menu ADD INDEX idx_menu_deleted (menu_id, deleted);

-- sys_role_menu 表索引
ALTER TABLE sys_role_menu ADD INDEX idx_deleted (deleted);
ALTER TABLE sys_role_menu ADD INDEX idx_role_deleted (role_id, deleted);
ALTER TABLE sys_role_menu ADD INDEX idx_menu_deleted (menu_id, deleted);

-- sys_approval_node_assignee 表索引
ALTER TABLE sys_approval_node_assignee ADD INDEX idx_deleted (deleted);
ALTER TABLE sys_approval_node_assignee ADD INDEX idx_node_deleted (node_id, deleted);

-- ============================================================
-- 6. 验证脚本 - 检查字段是否添加成功
-- ============================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_NAME IN ('sys_user_role', 'sys_user_menu', 'sys_role_menu', 'sys_approval_node_assignee')
    AND COLUMN_NAME IN ('update_time', 'create_by', 'update_by', 'deleted')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- ============================================================
-- 7. 索引验证
-- ============================================================
SELECT
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNS
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_NAME IN ('sys_user_role', 'sys_user_menu', 'sys_role_menu', 'sys_approval_node_assignee')
    AND INDEX_NAME LIKE 'idx_%'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;
