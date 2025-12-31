-- 添加字典管理菜单
-- 在系统管理下添加字典管理菜单项

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `sort`, `visible`, `status`, `create_time`, `update_time`)
VALUES (15, 3, '字典管理', 'C', 'dict', '/system/dict', 'system:dict:view', NULL, 4, 1, 1, NOW(), NOW());

-- 为超级管理员角色分配字典管理菜单权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
VALUES (1, 15)
ON DUPLICATE KEY UPDATE role_id = role_id;

