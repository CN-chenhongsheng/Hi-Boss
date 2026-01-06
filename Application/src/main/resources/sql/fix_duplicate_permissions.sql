-- ========================================
-- 修复重复的权限记录
-- 问题：system:floor:batchAdd 和 system:room:batchAdd 存在重复记录
-- 解决方案：删除重复记录，只保留最早的记录（id最小的）
-- ========================================

-- 1. 删除重复的"批量增加房间"权限，只保留 id=118 的记录
DELETE FROM sys_role_menu WHERE menu_id IN (120, 122);
DELETE FROM sys_menu WHERE id IN (120, 122) AND permission = 'system:floor:batchAdd';

-- 2. 删除重复的"批量增加床位"权限，只保留 id=119 的记录
DELETE FROM sys_role_menu WHERE menu_id IN (121, 123);
DELETE FROM sys_menu WHERE id IN (121, 123) AND permission = 'system:room:batchAdd';

-- 3. 确保超级管理员（role_id=1）拥有这两个权限
-- 如果不存在，则添加
INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, 118, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 118
);

INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, 119, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 119
);

-- 4. 验证结果
-- SELECT id, menu_name, permission FROM sys_menu WHERE permission IN ('system:floor:batchAdd', 'system:room:batchAdd');
-- SELECT role_id, menu_id FROM sys_role_menu WHERE role_id = 1 AND menu_id IN (118, 119);

