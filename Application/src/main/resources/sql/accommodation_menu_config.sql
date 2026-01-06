-- ========================================
-- 住宿管理模块菜单配置SQL
-- 创建日期：2026-01-06
-- 数据库：MySQL 8.0
-- ========================================

SET NAMES utf8mb4;

-- ========================================
-- 1. 一级菜单：住宿管理
-- ========================================
-- 调整菜单排序：住宿管理放在工作台(1)和宿舍管理(2)之间，所以住宿管理为2，宿舍管理及之后的菜单都往后移
UPDATE `sys_menu` SET `sort` = 3 WHERE `menu_name` = '宿舍管理' AND `parent_id` = 0;
UPDATE `sys_menu` SET `sort` = 4 WHERE `menu_name` = '组织管理' AND `parent_id` = 0;
UPDATE `sys_menu` SET `sort` = 5 WHERE `menu_name` = '学校管理' AND `parent_id` = 0;
UPDATE `sys_menu` SET `sort` = 6 WHERE `menu_name` = '系统管理' AND `parent_id` = 0;
UPDATE `sys_menu` SET `sort` = 7 WHERE `menu_name` = '异常页面' AND `parent_id` = 0;
UPDATE `sys_menu` SET `sort` = 8 WHERE `menu_name` = '结果页面' AND `parent_id` = 0;

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '住宿管理', 0, 2, 'accommodation', NULL, 'M', 1, 1, NULL, 'accommodation', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '住宿管理' AND `parent_id` = 0);

-- 更新已存在的住宿管理菜单的排序和路径
UPDATE `sys_menu` SET `sort` = 2, `path` = 'accommodation', `update_time` = NOW() WHERE `menu_name` = '住宿管理' AND `parent_id` = 0;

-- 获取一级菜单ID
SET @accommodation_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '住宿管理' AND `parent_id` = 0 LIMIT 1);

-- ========================================
-- 2. 二级菜单：人员管理
-- ========================================
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '人员管理', @accommodation_menu_id, 1, 'student', 'accommodation/student/index', 'C', 1, 1, NULL, 'user', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '人员管理' AND `parent_id` = @accommodation_menu_id);

SET @student_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '人员管理' AND `parent_id` = @accommodation_menu_id LIMIT 1);

-- 人员管理按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '新增学生', @student_menu_id, 1, '', '', 'F', 1, 1, 'system:student:add', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:student:add');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '编辑学生', @student_menu_id, 2, '', '', 'F', 1, 1, 'system:student:edit', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:student:edit');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '删除学生', @student_menu_id, 3, '', '', 'F', 1, 1, 'system:student:delete', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:student:delete');

-- ========================================
-- 3. 二级菜单：入住管理
-- ========================================
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '入住管理', @accommodation_menu_id, 2, 'check-in', 'accommodation/check-in/index', 'C', 1, 1, NULL, 'check-in', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '入住管理' AND `parent_id` = @accommodation_menu_id);

SET @check_in_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '入住管理' AND `parent_id` = @accommodation_menu_id LIMIT 1);

-- 入住管理按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '新增入住', @check_in_menu_id, 1, '', '', 'F', 1, 1, 'system:checkIn:add', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:checkIn:add');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '删除入住', @check_in_menu_id, 2, '', '', 'F', 1, 1, 'system:checkIn:delete', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:checkIn:delete');

-- ========================================
-- 4. 二级菜单：调宿管理
-- ========================================
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '调宿管理', @accommodation_menu_id, 3, 'transfer', 'accommodation/transfer/index', 'C', 1, 1, NULL, 'transfer', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '调宿管理' AND `parent_id` = @accommodation_menu_id);

SET @transfer_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '调宿管理' AND `parent_id` = @accommodation_menu_id LIMIT 1);

-- 调宿管理按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '新增调宿', @transfer_menu_id, 1, '', '', 'F', 1, 1, 'system:transfer:add', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:transfer:add');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '删除调宿', @transfer_menu_id, 2, '', '', 'F', 1, 1, 'system:transfer:delete', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:transfer:delete');

-- ========================================
-- 5. 二级菜单：退宿管理
-- ========================================
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '退宿管理', @accommodation_menu_id, 4, 'check-out', 'accommodation/check-out/index', 'C', 1, 1, NULL, 'check-out', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '退宿管理' AND `parent_id` = @accommodation_menu_id);

SET @check_out_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '退宿管理' AND `parent_id` = @accommodation_menu_id LIMIT 1);

-- 退宿管理按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '新增退宿', @check_out_menu_id, 1, '', '', 'F', 1, 1, 'system:checkOut:add', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:checkOut:add');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '删除退宿', @check_out_menu_id, 2, '', '', 'F', 1, 1, 'system:checkOut:delete', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:checkOut:delete');

-- ========================================
-- 6. 二级菜单：留宿管理
-- ========================================
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '留宿管理', @accommodation_menu_id, 5, 'stay', 'accommodation/stay/index', 'C', 1, 1, NULL, 'stay', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `menu_name` = '留宿管理' AND `parent_id` = @accommodation_menu_id);

SET @stay_menu_id = (SELECT `id` FROM `sys_menu` WHERE `menu_name` = '留宿管理' AND `parent_id` = @accommodation_menu_id LIMIT 1);

-- 留宿管理按钮权限
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '新增留宿', @stay_menu_id, 1, '', '', 'F', 1, 1, 'system:stay:add', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:stay:add');

INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `sort`, `path`, `component`, `menu_type`, `visible`, `status`, `permission`, `icon`, `keep_alive`, `create_time`, `update_time`)
SELECT '删除留宿', @stay_menu_id, 2, '', '', 'F', 1, 1, 'system:stay:delete', '', 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `permission` = 'system:stay:delete');

-- ========================================
-- 7. 为超级管理员角色分配所有权限
-- ========================================
-- 获取超级管理员角色ID
SET @super_admin_role_id = (SELECT `id` FROM `sys_role` WHERE `role_code` = 'SUPER_ADMIN' LIMIT 1);

-- 为超级管理员分配住宿管理菜单权限（只有当角色存在时才执行）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @super_admin_role_id, `id` FROM `sys_menu` WHERE `menu_name` = '住宿管理' AND `parent_id` = 0 AND @super_admin_role_id IS NOT NULL
ON DUPLICATE KEY UPDATE `role_id` = `role_id`;

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @super_admin_role_id, `id` FROM `sys_menu` WHERE `parent_id` = @accommodation_menu_id AND @super_admin_role_id IS NOT NULL
ON DUPLICATE KEY UPDATE `role_id` = `role_id`;

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT @super_admin_role_id, `id` FROM `sys_menu` WHERE `parent_id` IN (@student_menu_id, @check_in_menu_id, @transfer_menu_id, @check_out_menu_id, @stay_menu_id) AND @super_admin_role_id IS NOT NULL
ON DUPLICATE KEY UPDATE `role_id` = `role_id`;

