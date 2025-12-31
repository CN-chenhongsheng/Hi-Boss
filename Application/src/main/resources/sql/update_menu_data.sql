-- 清空现有菜单数据
DELETE FROM sys_menu;
DELETE FROM sys_role_menu;

-- 重置自增ID
ALTER TABLE sys_menu AUTO_INCREMENT = 1;

-- 插入菜单数据（参考前端路由结构）
-- 1. 工作台（Dashboard）
INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(1, 0, '工作台', 'M', '/dashboard', '/index/index', NULL, 'ri:pie-chart-line', 1, 1, 1);

INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(2, 1, '控制台', 'C', 'console', '/dashboard/console', 'dashboard:console:view', NULL, 1, 1, 1);

-- 2. 系统管理（System）
INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(3, 0, '系统管理', 'M', '/system', '/index/index', NULL, 'ri:user-3-line', 2, 1, 1);

INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(4, 3, '用户管理', 'C', 'user', '/system/user', 'system:user:view', NULL, 1, 1, 1),
(5, 3, '角色管理', 'C', 'role', '/system/role', 'system:role:view', NULL, 2, 1, 1),
(6, 3, '菜单管理', 'C', 'menu', '/system/menu', 'system:menu:view', NULL, 3, 1, 1),
(7, 3, '个人中心', 'C', 'user-center', '/system/user-center', 'system:user-center:view', NULL, 4, 0, 1);

-- 3. 异常页面（Exception）
INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(8, 0, '异常页面', 'M', '/exception', '/index/index', NULL, 'ri:error-warning-line', 3, 1, 1);

INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(9, 8, '403', 'C', '403', '/exception/403', 'exception:403:view', NULL, 1, 1, 1),
(10, 8, '404', 'C', '404', '/exception/404', 'exception:404:view', NULL, 2, 1, 1),
(11, 8, '500', 'C', '500', '/exception/500', 'exception:500:view', NULL, 3, 1, 1);

-- 4. 结果页面（Result）
INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(12, 0, '结果页面', 'M', '/result', '/index/index', NULL, 'ri:checkbox-circle-line', 4, 1, 1);

INSERT INTO sys_menu (id, parent_id, menu_name, menu_type, path, component, permission, icon, sort, visible, status) VALUES 
(13, 12, '成功页', 'C', 'success', '/result/success', 'result:success:view', NULL, 1, 1, 1),
(14, 12, '失败页', 'C', 'fail', '/result/fail', 'result:fail:view', NULL, 2, 1, 1);

-- 为超级管理员角色分配所有菜单权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, id FROM sys_menu;

-- 验证数据
SELECT 
    m1.id,
    m1.parent_id,
    m2.menu_name AS parent_name,
    m1.menu_name,
    m1.menu_type,
    m1.path,
    m1.component,
    m1.icon,
    m1.sort,
    m1.visible,
    m1.status
FROM sys_menu m1
LEFT JOIN sys_menu m2 ON m1.parent_id = m2.id
ORDER BY m1.parent_id, m1.sort;

