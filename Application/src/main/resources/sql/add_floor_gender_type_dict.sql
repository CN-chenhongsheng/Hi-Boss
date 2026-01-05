-- ========================================
-- 添加楼层适用性别字典
-- 版本: 1.0.0
-- 日期: 2025-01-01
-- 说明: 初始化楼层适用性别字典：男生宿舍、女生宿舍、混合宿舍
-- ========================================

SET NAMES utf8mb4;

-- ========================================
-- 楼层适用性别字典（dormitory_gender_type）
-- ========================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '楼层适用性别', 'dormitory_gender_type', 1, '楼层适用性别：男生宿舍、女生宿舍、混合宿舍', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'dormitory_gender_type');

-- 男生宿舍
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_gender_type', '男生宿舍', '1', NULL, 'primary', 1, 0, 1, '男生宿舍', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_gender_type' AND `value` = '1');

-- 女生宿舍
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_gender_type', '女生宿舍', '2', NULL, 'success', 2, 0, 1, '女生宿舍', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_gender_type' AND `value` = '2');

-- 混合宿舍
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'dormitory_gender_type', '混合宿舍', '3', NULL, 'info', 3, 1, 1, '混合宿舍', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'dormitory_gender_type' AND `value` = '3');

-- 完成
SELECT '楼层适用性别字典数据初始化完成！' AS message;

