-- ========================================
-- 宿舍管理模块字典数据初始化
-- 版本: 1.0.0
-- 日期: 2026-01-03
-- 说明: 初始化房间类型、床位位置、房间状态、床位状态字典
-- 数据库: MySQL 8.0
-- ========================================

SET NAMES utf8mb4;

-- ========================================
-- 1. 房间类型字典（dormitory_room_type）
-- ========================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '房间类型', 'dormitory_room_type', 1, '宿舍房间类型：标准间、套间、单人间等', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'dormitory_room_type');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_type', '标准间', 'standard', NULL, 'primary', 1, 1, 1, '标准4人间', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_type' AND `value` = 'standard');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_type', '套间', 'suite', NULL, 'success', 2, 0, 1, '套间', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_type' AND `value` = 'suite');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_type', '单人间', 'single', NULL, 'info', 3, 0, 1, '单人间', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_type' AND `value` = 'single');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_type', '双人间', 'double', NULL, 'warning', 4, 0, 1, '双人间', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_type' AND `value` = 'double');

-- ========================================
-- 2. 床位位置字典（dormitory_bed_position）
-- ========================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '床位位置', 'dormitory_bed_position', 1, '床位位置：上铺、下铺、左、右等', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'dormitory_bed_position');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_position', '上铺', 'upper', NULL, 'primary', 1, 1, 1, '上铺', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_position' AND `value` = 'upper');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_position', '下铺', 'lower', NULL, 'success', 2, 0, 1, '下铺', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_position' AND `value` = 'lower');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_position', '左侧', 'left', NULL, 'info', 3, 0, 1, '左侧床位', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_position' AND `value` = 'left');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_position', '右侧', 'right', NULL, 'warning', 4, 0, 1, '右侧床位', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_position' AND `value` = 'right');

-- ========================================
-- 3. 房间状态字典（dormitory_room_status）
-- ========================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '房间状态', 'dormitory_room_status', 1, '房间状态：空闲、已满、维修中、已预订', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'dormitory_room_status');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_status', '空闲', '1', NULL, 'success', 1, 1, 1, '房间空闲', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_status', '已满', '2', NULL, 'danger', 2, 0, 1, '房间已满', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_status', '维修中', '3', NULL, 'warning', 3, 0, 1, '房间维修中', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_room_status', '已预订', '4', NULL, 'info', 4, 0, 1, '房间已预订', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_room_status' AND `value` = '4');

-- ========================================
-- 4. 床位状态字典（dormitory_bed_status）
-- ========================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '床位状态', 'dormitory_bed_status', 1, '床位状态：空闲、已占用、维修中、已预订', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'dormitory_bed_status');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_status', '空闲', '1', NULL, 'success', 1, 1, 1, '床位空闲', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_status', '已占用', '2', NULL, 'danger', 2, 0, 1, '床位已占用', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_status', '维修中', '3', NULL, 'warning', 3, 0, 1, '床位维修中', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_bed_status', '已预订', '4', NULL, 'info', 4, 0, 1, '床位已预订', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_bed_status' AND `value` = '4');

-- 完成
SELECT '宿舍管理字典数据初始化完成！' AS message;

