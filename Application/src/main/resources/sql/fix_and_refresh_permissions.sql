-- ========================================
-- 修复学校管理菜单配置并刷新超级管理员权限
-- 版本: 1.0.2
-- 日期: 2025-12-31
-- 说明: 修复菜单路径格式，并重新分配超级管理员所有菜单权限
-- 使用方法: 在MySQL客户端或数据库管理工具中执行此脚本
-- ========================================

-- 步骤1: 修复学校管理子菜单的component路径（确保以/开头）
UPDATE sys_menu 
SET component = '/system/school/campus/index',
    update_time = NOW()
WHERE id = 51 AND menu_name = '校区管理';

UPDATE sys_menu 
SET component = '/system/school/department/index',
    update_time = NOW()
WHERE id = 52 AND menu_name = '院系管理';

UPDATE sys_menu 
SET component = '/system/school/major/index',
    update_time = NOW()
WHERE id = 53 AND menu_name = '专业管理';

UPDATE sys_menu 
SET component = '/system/school/class/index',
    update_time = NOW()
WHERE id = 54 AND menu_name = '班级管理';

-- 步骤2: 确保学校管理菜单的path正确
UPDATE sys_menu 
SET path = '/system/school',
    update_time = NOW()
WHERE id = 50 AND menu_name = '学校管理';

-- 步骤3: 删除超级管理员角色的所有现有菜单权限
DELETE FROM sys_role_menu WHERE role_id = 1;

-- 步骤4: 为超级管理员角色重新插入所有菜单权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, id
FROM sys_menu
WHERE id IS NOT NULL
ORDER BY id;

-- 步骤5: 验证结果
SELECT 
    '修复完成' as status,
    (SELECT COUNT(*) FROM sys_menu) as total_menus,
    (SELECT COUNT(*) FROM sys_role_menu WHERE role_id = 1) as super_admin_menu_count,
    CASE 
        WHEN (SELECT COUNT(*) FROM sys_menu) = (SELECT COUNT(*) FROM sys_role_menu WHERE role_id = 1) 
        THEN '权限分配完整 ✓' 
        ELSE '权限分配不完整 ✗' 
    END as permission_status;

-- 步骤6: 查看学校管理相关菜单配置（验证修复结果）
SELECT 
    id,
    parent_id,
    menu_name,
    menu_type,
    path,
    component,
    icon,
    sort,
    visible,
    status
FROM sys_menu
WHERE id = 50 OR parent_id = 50
ORDER BY parent_id, sort;

