-- ========================================
-- 更新菜单结构：使用存储过程
-- 版本: 1.0.0
-- 日期: 2026-01-03
-- ========================================

DELIMITER //

DROP PROCEDURE IF EXISTS UpdateMenuStructure //

CREATE PROCEDURE UpdateMenuStructure()
BEGIN
    DECLARE v_org_menu_id BIGINT;
    DECLARE v_dorm_menu_id BIGINT;
    DECLARE v_year_menu_id BIGINT;
    
    -- 获取菜单ID
    SELECT id INTO v_org_menu_id FROM sys_menu WHERE menu_name = '组织管理' AND parent_id = 0 LIMIT 1;
    SELECT id INTO v_dorm_menu_id FROM sys_menu WHERE menu_name = '宿舍管理' AND parent_id = 0 LIMIT 1;
    SELECT id INTO v_year_menu_id FROM sys_menu WHERE menu_name = '学年管理' AND parent_id = 50 LIMIT 1;
    
    -- 删除重复菜单
    DELETE FROM sys_menu WHERE id IN (91, 92, 93);
    
    -- 更新组织管理排序
    UPDATE sys_menu SET sort = 3 WHERE id = v_org_menu_id;
    
    -- 更新院系、专业、班级管理的父菜单和组件路径
    UPDATE sys_menu SET parent_id = v_org_menu_id, component = '/organization/department', path = 'department' WHERE id = 68;
    UPDATE sys_menu SET parent_id = v_org_menu_id, component = '/organization/major', path = 'major' WHERE id = 69;
    UPDATE sys_menu SET parent_id = v_org_menu_id, component = '/organization/class', path = 'class' WHERE id = 70;
    
    -- 更新排序
    UPDATE sys_menu SET sort = 1 WHERE id = 67; -- 校区管理
    UPDATE sys_menu SET sort = 2 WHERE id = v_year_menu_id; -- 学年管理
    UPDATE sys_menu SET sort = 1 WHERE id = 68; -- 院系管理
    UPDATE sys_menu SET sort = 2 WHERE id = 69; -- 专业管理
    UPDATE sys_menu SET sort = 3 WHERE id = 70; -- 班级管理
    
    -- 创建学年管理按钮权限
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_year_menu_id, '新增学年', 'F', NULL, NULL, 'system:academic-year:add', NULL, 1, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:add');
    
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_year_menu_id, '编辑学年', 'F', NULL, NULL, 'system:academic-year:edit', NULL, 2, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:edit');
    
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_year_menu_id, '删除学年', 'F', NULL, NULL, 'system:academic-year:delete', NULL, 3, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE permission = 'system:academic-year:delete');
    
    -- 创建宿舍管理子菜单
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_dorm_menu_id, '楼层管理', 'C', 'floor', '/dormitory/floor', NULL, 'ri:building-2-line', 1, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '楼层管理' AND parent_id = v_dorm_menu_id);
    
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_dorm_menu_id, '房间管理', 'C', 'room', '/dormitory/room', NULL, 'ri:door-open-line', 2, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '房间管理' AND parent_id = v_dorm_menu_id);
    
    INSERT INTO sys_menu (parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status, keep_alive, create_time)
    SELECT v_dorm_menu_id, '床位管理', 'C', 'bed', '/dormitory/bed', NULL, 'ri:bed-line', 3, 1, 1, 1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_name = '床位管理' AND parent_id = v_dorm_menu_id);
    
    -- 给超级管理员分配权限
    INSERT INTO sys_role_menu (role_id, menu_id, create_time)
    SELECT 1, id, NOW()
    FROM sys_menu
    WHERE ((menu_name = '组织管理' AND parent_id = 0) OR parent_id = v_org_menu_id)
       OR ((menu_name = '学年管理' AND parent_id = 50) OR parent_id = v_year_menu_id)
       OR ((menu_name = '宿舍管理' AND parent_id = 0) OR parent_id = v_dorm_menu_id)
    AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = sys_menu.id);
    
    SELECT '菜单结构更新完成！' AS message;
END //

DELIMITER ;

-- 执行存储过程
CALL UpdateMenuStructure();

-- 删除存储过程
DROP PROCEDURE IF EXISTS UpdateMenuStructure;

