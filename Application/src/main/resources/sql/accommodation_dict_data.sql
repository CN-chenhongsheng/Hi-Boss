-- ========================================
-- 住宿管理模块字典数据SQL
-- 创建日期：2026-01-06
-- 数据库：MySQL 8.0
-- ========================================

SET NAMES utf8mb4;

-- ========================================
-- 1. 学籍状态字典（academic_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '学籍状态', 'academic_status', 1, '学籍状态：1在读 2休学 3毕业 4退学', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'academic_status');

-- 添加字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'academic_status', '在读', '1', '', 'success', 1, 1, 1, '在读状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'academic_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'academic_status', '休学', '2', '', 'warning', 2, 0, 1, '休学状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'academic_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'academic_status', '毕业', '3', '', 'info', 3, 0, 1, '毕业状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'academic_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'academic_status', '退学', '4', '', 'danger', 4, 0, 1, '退学状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'academic_status' AND `value` = '4');

-- ========================================
-- 2. 入住状态字典（check_in_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '入住状态', 'check_in_status', 1, '入住状态：1待审核 2已通过 3已拒绝 4已入住', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'check_in_status');

-- 添加字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_in_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_in_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_in_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_in_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_in_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_in_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_in_status', '已入住', '4', '', 'success', 4, 1, 1, '已入住状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_in_status' AND `value` = '4');

-- ========================================
-- 3. 调宿状态字典（transfer_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '调宿状态', 'transfer_status', 1, '调宿状态：1待审核 2已通过 3已拒绝 4已完成', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'transfer_status');

-- 添加字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'transfer_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'transfer_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'transfer_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'transfer_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'transfer_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'transfer_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'transfer_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'transfer_status' AND `value` = '4');

-- ========================================
-- 4. 退宿状态字典（check_out_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '退宿状态', 'check_out_status', 1, '退宿状态：1待审核 2已通过 3已拒绝 4已完成', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'check_out_status');

-- 添加字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_out_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_out_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_out_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_out_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_out_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_out_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'check_out_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'check_out_status' AND `value` = '4');

-- ========================================
-- 5. 留宿状态字典（stay_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '留宿状态', 'stay_status', 1, '留宿状态：1待审核 2已通过 3已拒绝 4已完成', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'stay_status');

-- 添加字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'stay_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'stay_status' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'stay_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'stay_status' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'stay_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'stay_status' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'stay_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'stay_status' AND `value` = '4');

