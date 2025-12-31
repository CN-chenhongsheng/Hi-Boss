-- ========================================
-- 为超级管理员分配学校管理模块按钮权限
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- ========================================

-- 为超级管理员（role_id = 1）分配所有学校管理按钮权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, id
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
AND id NOT IN (SELECT menu_id FROM sys_role_menu WHERE role_id = 1);

-- 验证分配结果
SELECT 
    m.menu_name,
    m.permission,
    rm.role_id
FROM sys_menu m
INNER JOIN sys_role_menu rm ON m.id = rm.menu_id
WHERE rm.role_id = 1
AND m.permission IN (
    'system:campus:add',
    'system:campus:edit',
    'system:campus:delete',
    'system:department:add',
    'system:department:edit',
    'system:department:delete',
    'system:major:add',
    'system:major:edit',
    'system:major:edit',
    'system:class:add',
    'system:class:edit',
    'system:class:delete'
)
ORDER BY m.permission;

