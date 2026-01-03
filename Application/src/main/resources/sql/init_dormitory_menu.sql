-- ========================================
-- 宿舍管理模块菜单和权限配置
-- 版本: 1.0.0
-- 日期: 2026-01-03
-- 说明: 为楼层、房间、床位管理创建按钮权限并分配给超级管理员
-- 数据库: MySQL 8.0
-- ========================================

SET NAMES utf8mb4;

-- 使用临时变量避免子查询问题
SET @floor_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '楼层管理' AND parent_id = (SELECT id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1) LIMIT 1);
SET @room_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '房间管理' AND parent_id = (SELECT id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1) LIMIT 1);
SET @bed_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '床位管理' AND parent_id = (SELECT id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1) LIMIT 1);

-- ========================================
-- 1. 楼层管理按钮权限
-- ========================================
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '新增楼层', 'F', NULL, NULL, 'system:floor:add', NULL, 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '编辑楼层', 'F', NULL, NULL, 'system:floor:edit', NULL, 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '删除楼层', 'F', NULL, NULL, 'system:floor:delete', NULL, 3, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:delete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '批量删除', 'F', NULL, NULL, 'system:floor:batchDelete', NULL, 4, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:batchDelete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '状态切换', 'F', NULL, NULL, 'system:floor:status', NULL, 5, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:status');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @floor_menu_id, '导出', 'F', NULL, NULL, 'system:floor:export', NULL, 6, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:floor:export');

-- ========================================
-- 2. 房间管理按钮权限
-- ========================================
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '新增房间', 'F', NULL, NULL, 'system:room:add', NULL, 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '编辑房间', 'F', NULL, NULL, 'system:room:edit', NULL, 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '删除房间', 'F', NULL, NULL, 'system:room:delete', NULL, 3, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:delete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '批量删除', 'F', NULL, NULL, 'system:room:batchDelete', NULL, 4, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:batchDelete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '状态切换', 'F', NULL, NULL, 'system:room:status', NULL, 5, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:status');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @room_menu_id, '导出', 'F', NULL, NULL, 'system:room:export', NULL, 6, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:room:export');

-- ========================================
-- 3. 床位管理按钮权限
-- ========================================
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '新增床位', 'F', NULL, NULL, 'system:bed:add', NULL, 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '编辑床位', 'F', NULL, NULL, 'system:bed:edit', NULL, 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '删除床位', 'F', NULL, NULL, 'system:bed:delete', NULL, 3, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:delete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '批量删除', 'F', NULL, NULL, 'system:bed:batchDelete', NULL, 4, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:batchDelete');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '状态切换', 'F', NULL, NULL, 'system:bed:status', NULL, 5, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:status');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @bed_menu_id, '导出', 'F', NULL, NULL, 'system:bed:export', NULL, 6, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:bed:export');

-- ========================================
-- 4. 给超级管理员分配所有权限（role_id=1）
-- ========================================
INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, id, NOW()
FROM sys_menu
WHERE (permission LIKE 'system:floor:%' OR permission LIKE 'system:room:%' OR permission LIKE 'system:bed:%')
AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = sys_menu.id);

-- 完成
SELECT '宿舍管理菜单和权限配置完成！' AS message;

