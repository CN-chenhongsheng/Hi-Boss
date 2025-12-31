-- ========================================
-- 添加学校管理模块按钮权限并分配给超级管理员
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- 说明: 为校区、院系、专业、班级管理添加按钮权限菜单，并分配给超级管理员
-- ========================================

-- 获取菜单ID
SET @campus_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '校区管理' AND menu_type = 'C' LIMIT 1);
SET @dept_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '院系管理' AND menu_type = 'C' LIMIT 1);
SET @major_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '专业管理' AND menu_type = 'C' LIMIT 1);
SET @class_menu_id = (SELECT id FROM sys_menu WHERE menu_name = '班级管理' AND menu_type = 'C' LIMIT 1);
SET @super_admin_role_id = 1;

-- ========================================
-- 校区管理按钮权限
-- ========================================

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

-- ========================================
-- 院系管理按钮权限
-- ========================================

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

-- ========================================
-- 专业管理按钮权限
-- ========================================

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

-- ========================================
-- 班级管理按钮权限
-- ========================================

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

-- ========================================
-- 为超级管理员分配所有新创建的按钮权限
-- ========================================

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @super_admin_role_id, id
FROM sys_menu
WHERE permission IN (
    'system:campus:add',
    'system:campus:edit',
    'system:campus:delete',
    'system:department:add',
    'system:department:edit',
    'system:department:delete',
    'system:major:add',
    'system:major:edit',
    'system:major:delete',
    'system:class:add',
    'system:class:edit',
    'system:class:delete'
)
AND id NOT IN (SELECT menu_id FROM sys_role_menu WHERE role_id = @super_admin_role_id);

-- ========================================
-- 验证结果
-- ========================================

SELECT 
    '按钮权限创建完成' as status,
    (SELECT COUNT(*) FROM sys_menu WHERE permission LIKE 'system:campus:%' OR permission LIKE 'system:department:%' OR permission LIKE 'system:major:%' OR permission LIKE 'system:class:%') as button_permission_count,
    (SELECT COUNT(*) FROM sys_role_menu rm 
     INNER JOIN sys_menu m ON rm.menu_id = m.id 
     WHERE rm.role_id = @super_admin_role_id 
     AND (m.permission LIKE 'system:campus:%' OR m.permission LIKE 'system:department:%' OR m.permission LIKE 'system:major:%' OR m.permission LIKE 'system:class:%')) as super_admin_permission_count;

