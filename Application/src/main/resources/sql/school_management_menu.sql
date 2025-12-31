-- ========================================
-- 学校管理模块菜单数据（修正版）
-- 版本: 1.0.1
-- 日期: 2025-12-31
-- 说明: 学校管理菜单应该和工作台同级（顶级菜单），位于工作台和系统管理之间
-- 数据库: MySQL
-- ========================================

-- 步骤1: 更新系统管理及之后菜单的sort值，为学校管理腾出位置
-- 将"系统管理"的sort从2改为3
UPDATE sys_menu SET sort = 3, update_time = NOW() WHERE id = 3 AND menu_name = '系统管理';

-- 将"异常页面"的sort从3改为4
UPDATE sys_menu SET sort = 4, update_time = NOW() WHERE id = 8 AND menu_name = '异常页面';

-- 将"结果页面"的sort从4改为5
UPDATE sys_menu SET sort = 5, update_time = NOW() WHERE id = 12 AND menu_name = '结果页面';

-- 步骤2: 更新已存在的"学校管理"菜单为顶级菜单（parent_id=0），sort=2
-- 如果学校管理菜单存在且parent_id不是0，则更新它
UPDATE sys_menu 
SET parent_id = 0, sort = 2, update_time = NOW()
WHERE menu_name = '学校管理' AND parent_id != 0;

-- 步骤3: 如果学校管理菜单不存在，则创建它（作为顶级菜单）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT 0, '学校管理', 'M', '/system/school', NULL, NULL, 'school', 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '学校管理' AND parent_id = 0);

-- 步骤4: 获取"学校管理"菜单ID（用于后续子菜单的parent_id）
SET @school_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '学校管理' AND parent_id = 0 LIMIT 1);

-- 步骤5: 更新已存在的子菜单的parent_id（确保它们指向正确的学校管理菜单）
UPDATE sys_menu SET parent_id = @school_menu_id, update_time = NOW() 
WHERE menu_name IN ('校区管理', '院系管理', '专业管理', '班级管理') 
  AND menu_type = 'C' 
  AND parent_id != @school_menu_id;

-- 步骤6: 插入"校区管理"菜单（如果不存在）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @school_menu_id, '校区管理', 'C', '/system/school/campus', 'system/school/campus/index', NULL, 'office-building', 1, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '校区管理' AND parent_id = @school_menu_id);

-- 步骤7: 插入"院系管理"菜单（如果不存在）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @school_menu_id, '院系管理', 'C', '/system/school/department', 'system/school/department/index', NULL, 'suitcase', 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '院系管理' AND parent_id = @school_menu_id);

-- 步骤8: 插入"专业管理"菜单（如果不存在）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @school_menu_id, '专业管理', 'C', '/system/school/major', 'system/school/major/index', NULL, 'document', 3, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '专业管理' AND parent_id = @school_menu_id);

-- 步骤9: 插入"班级管理"菜单（如果不存在）
INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @school_menu_id, '班级管理', 'C', '/system/school/class', 'system/school/class/index', NULL, 'user-filled', 4, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '班级管理' AND parent_id = @school_menu_id);

-- ========================================
-- 插入按钮权限（如果不存在）
-- ========================================

-- 校区管理按钮权限
SET @campus_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '校区管理' AND menu_type = 'C' AND parent_id = @school_menu_id LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @campus_menu_id, '新增校区', 'F', NULL, NULL, 'system:campus:add', NULL, 1, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:campus:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @campus_menu_id, '编辑校区', 'F', NULL, NULL, 'system:campus:edit', NULL, 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:campus:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @campus_menu_id, '删除校区', 'F', NULL, NULL, 'system:campus:delete', NULL, 3, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:campus:delete');

-- 院系管理按钮权限
SET @dept_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '院系管理' AND menu_type = 'C' AND parent_id = @school_menu_id LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @dept_menu_id, '新增院系', 'F', NULL, NULL, 'system:department:add', NULL, 1, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:department:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @dept_menu_id, '编辑院系', 'F', NULL, NULL, 'system:department:edit', NULL, 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:department:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @dept_menu_id, '删除院系', 'F', NULL, NULL, 'system:department:delete', NULL, 3, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:department:delete');

-- 专业管理按钮权限
SET @major_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '专业管理' AND menu_type = 'C' AND parent_id = @school_menu_id LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @major_menu_id, '新增专业', 'F', NULL, NULL, 'system:major:add', NULL, 1, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:major:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @major_menu_id, '编辑专业', 'F', NULL, NULL, 'system:major:edit', NULL, 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:major:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @major_menu_id, '删除专业', 'F', NULL, NULL, 'system:major:delete', NULL, 3, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:major:delete');

-- 班级管理按钮权限
SET @class_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '班级管理' AND menu_type = 'C' AND parent_id = @school_menu_id LIMIT 1);

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @class_menu_id, '新增班级', 'F', NULL, NULL, 'system:class:add', NULL, 1, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:class:add');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @class_menu_id, '编辑班级', 'F', NULL, NULL, 'system:class:edit', NULL, 2, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:class:edit');

INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, create_time, update_time)
SELECT @class_menu_id, '删除班级', 'F', NULL, NULL, 'system:class:delete', NULL, 3, 1, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:class:delete');
