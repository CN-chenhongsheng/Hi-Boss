-- ========================================
-- 学生基本信息字典数据SQL
-- 创建日期：2026-01-07
-- 数据库：MySQL 8.0
-- 说明：为学生基本信息字段创建字典类型和字典数据
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- 1. 民族字典（student_nation）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '民族', 'student_nation', 1, '学生民族：包含中国56个民族', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_nation');

-- 添加民族字典数据（常见民族）
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '汉族', '汉族', '', 'info', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '汉族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '蒙古族', '蒙古族', '', 'info', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '蒙古族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '回族', '回族', '', 'info', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '回族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '藏族', '藏族', '', 'info', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '藏族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '维吾尔族', '维吾尔族', '', 'info', 5, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '维吾尔族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '苗族', '苗族', '', 'info', 6, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '苗族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '彝族', '彝族', '', 'info', 7, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '彝族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '壮族', '壮族', '', 'info', 8, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '壮族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '布依族', '布依族', '', 'info', 9, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '布依族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '朝鲜族', '朝鲜族', '', 'info', 10, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '朝鲜族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '满族', '满族', '', 'info', 11, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '满族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '侗族', '侗族', '', 'info', 12, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '侗族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '瑶族', '瑶族', '', 'info', 13, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '瑶族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '白族', '白族', '', 'info', 14, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '白族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '土家族', '土家族', '', 'info', 15, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '土家族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '哈尼族', '哈尼族', '', 'info', 16, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '哈尼族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '哈萨克族', '哈萨克族', '', 'info', 17, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '哈萨克族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '傣族', '傣族', '', 'info', 18, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '傣族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '黎族', '黎族', '', 'info', 19, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '黎族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '傈僳族', '傈僳族', '', 'info', 20, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '傈僳族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '佤族', '佤族', '', 'info', 21, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '佤族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '畲族', '畲族', '', 'info', 22, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '畲族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '高山族', '高山族', '', 'info', 23, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '高山族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '拉祜族', '拉祜族', '', 'info', 24, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '拉祜族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '水族', '水族', '', 'info', 25, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '水族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '东乡族', '东乡族', '', 'info', 26, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '东乡族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '纳西族', '纳西族', '', 'info', 27, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '纳西族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '景颇族', '景颇族', '', 'info', 28, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '景颇族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '柯尔克孜族', '柯尔克孜族', '', 'info', 29, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '柯尔克孜族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '土族', '土族', '', 'info', 30, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '土族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '达斡尔族', '达斡尔族', '', 'info', 31, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '达斡尔族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '仫佬族', '仫佬族', '', 'info', 32, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '仫佬族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '羌族', '羌族', '', 'info', 33, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '羌族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '布朗族', '布朗族', '', 'info', 34, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '布朗族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '撒拉族', '撒拉族', '', 'info', 35, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '撒拉族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '毛南族', '毛南族', '', 'info', 36, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '毛南族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '仡佬族', '仡佬族', '', 'info', 37, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '仡佬族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '锡伯族', '锡伯族', '', 'info', 38, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '锡伯族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '阿昌族', '阿昌族', '', 'info', 39, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '阿昌族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '普米族', '普米族', '', 'info', 40, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '普米族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '塔吉克族', '塔吉克族', '', 'info', 41, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '塔吉克族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '怒族', '怒族', '', 'info', 42, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '怒族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '乌孜别克族', '乌孜别克族', '', 'info', 43, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '乌孜别克族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '俄罗斯族', '俄罗斯族', '', 'info', 44, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '俄罗斯族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '鄂温克族', '鄂温克族', '', 'info', 45, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '鄂温克族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '德昂族', '德昂族', '', 'info', 46, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '德昂族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '保安族', '保安族', '', 'info', 47, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '保安族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '裕固族', '裕固族', '', 'info', 48, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '裕固族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '京族', '京族', '', 'info', 49, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '京族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '塔塔尔族', '塔塔尔族', '', 'info', 50, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '塔塔尔族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '独龙族', '独龙族', '', 'info', 51, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '独龙族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '鄂伦春族', '鄂伦春族', '', 'info', 52, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '鄂伦春族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '赫哲族', '赫哲族', '', 'info', 53, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '赫哲族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '门巴族', '门巴族', '', 'info', 54, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '门巴族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '珞巴族', '珞巴族', '', 'info', 55, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '珞巴族');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_nation', '基诺族', '基诺族', '', 'info', 56, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_nation' AND `value` = '基诺族');

-- ========================================
-- 2. 政治面貌字典（student_political_status）
-- ========================================
-- 添加字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '政治面貌', 'student_political_status', 1, '学生政治面貌：群众、共青团员、中共党员等', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_political_status');

-- 添加政治面貌字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '群众', '群众', '', 'info', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '群众');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '共青团员', '共青团员', '', 'success', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '共青团员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '中共党员', '中共党员', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '中共党员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '中共预备党员', '中共预备党员', '', 'warning', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '中共预备党员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '民革党员', '民革党员', '', 'info', 5, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '民革党员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '民盟盟员', '民盟盟员', '', 'info', 6, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '民盟盟员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '民建会员', '民建会员', '', 'info', 7, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '民建会员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '民进会员', '民进会员', '', 'info', 8, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '民进会员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '农工党党员', '农工党党员', '', 'info', 9, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '农工党党员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '致公党党员', '致公党党员', '', 'info', 10, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '致公党党员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '九三学社社员', '九三学社社员', '', 'info', 11, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '九三学社社员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '台盟盟员', '台盟盟员', '', 'info', 12, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '台盟盟员');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_political_status', '无党派人士', '无党派人士', '', 'info', 13, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_political_status' AND `value` = '无党派人士');

SET FOREIGN_KEY_CHECKS = 1;

