-- ============================================================
-- 修复 sys_role_menu 表重复数据问题
-- 创建日期: 2026-01-31
-- 说明: 清理重复的软删除记录，并修复唯一索引
-- ============================================================

USE project_management;

-- ============================================================
-- 步骤1：查看当前问题
-- ============================================================

-- 查看所有软删除的记录
SELECT '=== 当前软删除记录 ===' AS '步骤';
SELECT role_id, menu_id, deleted, COUNT(*) AS count
FROM sys_role_menu
WHERE deleted = 1
GROUP BY role_id, menu_id, deleted
ORDER BY role_id, menu_id;

-- 查看是否有重复的软删除记录
SELECT '=== 重复的软删除记录 ===' AS '步骤';
SELECT role_id, menu_id, deleted, COUNT(*) AS duplicate_count
FROM sys_role_menu
WHERE deleted = 1
GROUP BY role_id, menu_id, deleted
HAVING COUNT(*) > 1;

-- 查看当前唯一索引定义
SELECT '=== 当前索引定义 ===' AS '步骤';
SHOW INDEX FROM sys_role_menu WHERE Key_name = 'uk_role_menu';

-- ============================================================
-- 步骤2：备份现有数据（可选，但强烈建议）
-- ============================================================

-- 创建备份表
DROP TABLE IF EXISTS sys_role_menu_backup_20260131;
CREATE TABLE sys_role_menu_backup_20260131 AS SELECT * FROM sys_role_menu;
SELECT '=== 已创建备份表 sys_role_menu_backup_20260131 ===' AS '步骤';

-- ============================================================
-- 步骤3：清理重复的软删除记录
-- ============================================================

-- 删除重复的软删除记录（保留ID最大的一条）
DELETE t1 FROM sys_role_menu t1
INNER JOIN (
    SELECT role_id, menu_id, MAX(id) as max_id
    FROM sys_role_menu
    WHERE deleted = 1
    GROUP BY role_id, menu_id
    HAVING COUNT(*) > 1
) t2 ON t1.role_id = t2.role_id AND t1.menu_id = t2.menu_id
WHERE t1.deleted = 1 AND t1.id < t2.max_id;

SELECT '=== 已清理重复的软删除记录 ===' AS '步骤';

-- ============================================================
-- 步骤4：修复唯一索引（确保包含 deleted 字段）
-- ============================================================

-- 删除旧索引
ALTER TABLE sys_role_menu DROP INDEX IF EXISTS uk_role_menu;

-- 创建新的复合唯一索引
ALTER TABLE sys_role_menu ADD UNIQUE KEY uk_role_menu (role_id, menu_id, deleted);

SELECT '=== 已修复唯一索引 ===' AS '步骤';

-- ============================================================
-- 步骤5：验证修复结果
-- ============================================================

-- 验证是否还有重复记录
SELECT '=== 验证：检查重复记录 ===' AS '步骤';
SELECT role_id, menu_id, deleted, COUNT(*) AS count
FROM sys_role_menu
GROUP BY role_id, menu_id, deleted
HAVING COUNT(*) > 1;

-- 验证索引是否正确
SELECT '=== 验证：检查索引定义 ===' AS '步骤';
SELECT
    INDEX_NAME AS '索引名',
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS '索引字段'
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_NAME = 'sys_role_menu'
    AND INDEX_NAME = 'uk_role_menu'
GROUP BY INDEX_NAME;

-- 查看表结构
SELECT '=== 表结构 ===' AS '步骤';
DESCRIBE sys_role_menu;

-- ============================================================
-- 步骤6：测试软删除功能
-- ============================================================

-- 测试：软删除一条记录
SELECT '=== 测试：软删除功能 ===' AS '步骤';

-- 查看role_id=1的当前活跃记录
SELECT COUNT(*) AS '删除前活跃记录数' FROM sys_role_menu WHERE role_id = 1 AND deleted = 0;

-- 执行软删除（注释掉，手动测试时取消注释）
-- UPDATE sys_role_menu SET deleted = 1 WHERE role_id = 1 AND deleted = 0 LIMIT 1;

-- 查看删除后状态
-- SELECT COUNT(*) AS '删除后活跃记录数' FROM sys_role_menu WHERE role_id = 1 AND deleted = 0;
-- SELECT COUNT(*) AS '删除后软删除记录数' FROM sys_role_menu WHERE role_id = 1 AND deleted = 1;

SELECT '=== 修复完成！请重启后端服务并测试 ===' AS '步骤';

-- ============================================================
-- 回滚说明
-- ============================================================
--
-- 如果需要回滚，请执行：
-- DROP TABLE IF EXISTS sys_role_menu;
-- CREATE TABLE sys_role_menu AS SELECT * FROM sys_role_menu_backup_20260131;
-- ALTER TABLE sys_role_menu ADD PRIMARY KEY (id);
--
-- ============================================================
