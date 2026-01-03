-- ========================================
-- 更新菜单结构：重组学校管理模块
-- 版本: 1.0.0
-- 日期: 2026-01-03
-- 说明: 重组学校管理结构，创建组织管理和宿舍管理模块
-- 数据库: MySQL
-- ========================================

SET NAMES utf8mb4;

-- 1. 删除重复的菜单记录（如果存在）
DELETE FROM sys_menu WHERE id IN (91, 92, 93);

-- 2. 更新组织管理菜单的排序（确保在正确位置）
UPDATE sys_menu SET sort = 3 WHERE id = 88 AND menu_name = '组织管理';

-- 3. 更新院系、专业、班级管理的父菜单和组件路径
UPDATE sys_menu 
SET parent_id = 88, 
    component = '/organization/department',
    path = 'department'
WHERE id = 68 AND menu_name = '院系管理';

UPDATE sys_menu 
SET parent_id = 88, 
    component = '/organization/major',
    path = 'major'
WHERE id = 69 AND menu_name = '专业管理';

UPDATE sys_menu 
SET parent_id = 88, 
    component = '/organization/class',
    path = 'class'
WHERE id = 70 AND menu_name = '班级管理';

-- 4. 更新组织管理下菜单的排序
UPDATE sys_menu SET sort = 1 WHERE id = 68; -- 院系管理
UPDATE sys_menu SET sort = 2 WHERE id = 69; -- 专业管理
UPDATE sys_menu SET sort = 3 WHERE id = 70; -- 班级管理

-- 5. 确保学年管理菜单存在（如果不存在则创建）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT 50, '学年管理', 'C', 'academic-year', '/school/academic-year', NULL, 'ri:calendar-line', 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '学年管理' AND parent_id = 50);

-- 6. 确保宿舍管理菜单存在（如果不存在则创建）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT 0, '宿舍管理', 'M', '/dormitory', '/index/index', NULL, 'ri:home-line', 4, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0);

-- 7. 创建学年管理的按钮权限
-- 使用临时变量避免子查询问题
SET @academic_year_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '学年管理' AND parent_id = 50 LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @academic_year_menu_id, '新增学年', 'F', NULL, NULL, 'system:academic-year:add', NULL, 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @academic_year_menu_id, '编辑学年', 'F', NULL, NULL, 'system:academic-year:edit', NULL, 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @academic_year_menu_id, '删除学年', 'F', NULL, NULL, 'system:academic-year:delete', NULL, 3, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:delete');

-- 8. 创建宿舍管理下的子菜单（楼层、房间、床位）
-- 使用临时变量避免子查询问题
SET @dormitory_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @dormitory_menu_id, '楼层管理', 'C', 'floor', '/dormitory/floor', NULL, 'ri:building-2-line', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '楼层管理' AND parent_id = @dormitory_menu_id);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @dormitory_menu_id, '房间管理', 'C', 'room', '/dormitory/room', NULL, 'ri:door-open-line', 2, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '房间管理' AND parent_id = @dormitory_menu_id);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
SELECT @dormitory_menu_id, '床位管理', 'C', 'bed', '/dormitory/bed', NULL, 'ri:bed-line', 3, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '床位管理' AND parent_id = @dormitory_menu_id);

-- 9. 更新学校管理下菜单的排序
UPDATE sys_menu SET sort = 1 WHERE id = 67 AND menu_name = '校区管理'; -- 校区管理
-- 学年管理排序更新（使用临时变量避免子查询问题）
SET @academic_year_id = (SELECT id FROM sys_menu WHERE menu_name = '学年管理' AND parent_id = 50 LIMIT 1);
UPDATE sys_menu SET sort = 2 WHERE id = @academic_year_id AND menu_name = '学年管理';

-- 10. 给超级管理员分配所有新菜单的权限（超级管理员角色ID为1）
-- 使用临时变量避免子查询问题
SET @org_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '组织管理' AND parent_id = 0 LIMIT 1);
SET @dorm_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1);
SET @year_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '学年管理' AND parent_id = 50 LIMIT 1);

-- 组织管理及其子菜单
INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, id, NOW()
FROM sys_menu
WHERE (id = @org_menu_id OR parent_id = @org_menu_id)
AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = sys_menu.id);

-- 学年管理及其按钮
INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, id, NOW()
FROM sys_menu
WHERE (id = @year_menu_id OR parent_id = @year_menu_id)
AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = sys_menu.id);

-- 宿舍管理及其子菜单
INSERT INTO sys_role_menu (role_id, menu_id, create_time)
SELECT 1, id, NOW()
FROM sys_menu
WHERE (id = @dorm_menu_id OR parent_id = @dorm_menu_id)
AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = sys_menu.id);

-- 完成
SELECT '菜单结构更新完成！' AS message;
