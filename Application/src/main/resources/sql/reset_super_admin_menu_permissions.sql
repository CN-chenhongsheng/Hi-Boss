-- ========================================
-- 重置超级管理员菜单权限
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- 说明: 为超级管理员角色赋予所有菜单权限
-- 数据库: MySQL
-- ========================================

-- 设置超级管理员角色ID
SET @super_admin_role_id = 1;

-- 步骤1: 删除超级管理员角色的所有现有菜单权限
DELETE FROM sys_role_menu WHERE role_id = @super_admin_role_id;

-- 步骤2: 为超级管理员角色插入所有菜单权限
-- 获取所有菜单ID并插入到角色菜单关联表
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @super_admin_role_id, id
FROM sys_menu
WHERE id IS NOT NULL
ORDER BY id;

-- 验证：查看超级管理员拥有的菜单权限数量
SELECT 
    COUNT(*) as menu_count,
    '超级管理员拥有的菜单权限数量' as description
FROM sys_role_menu 
WHERE role_id = @super_admin_role_id;

-- 查看超级管理员拥有的所有菜单
SELECT 
    rm.role_id,
    r.role_name,
    rm.menu_id,
    m.menu_name,
    m.menu_type,
    m.parent_id
FROM sys_role_menu rm
INNER JOIN sys_role r ON rm.role_id = r.id
INNER JOIN sys_menu m ON rm.menu_id = m.id
WHERE rm.role_id = @super_admin_role_id
ORDER BY m.id;

