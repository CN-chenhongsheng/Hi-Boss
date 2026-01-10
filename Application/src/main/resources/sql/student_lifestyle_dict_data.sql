-- ========================================
-- 学生生活习惯字典数据
-- 创建日期：2026-01-07
-- 说明：为学生生活习惯字段创建字典类型和字典数据
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 吸烟状态字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '吸烟状态', 'student_smoking_status', 1, '学生是否吸烟：0不吸烟 1吸烟', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_smoking_status');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_smoking_status', '不吸烟', '0', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_smoking_status' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_smoking_status', '吸烟', '1', '', 'warning', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_smoking_status' AND `value` = '1');

-- 是否接受室友吸烟字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否接受室友吸烟', 'student_smoking_tolerance', 1, '是否接受室友吸烟：0不接受 1接受', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_smoking_tolerance');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_smoking_tolerance', '不接受', '0', '', 'info', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_smoking_tolerance' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_smoking_tolerance', '接受', '1', '', 'success', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_smoking_tolerance' AND `value` = '1');

-- 作息时间字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '作息时间', 'student_sleep_schedule', 1, '作息时间：0早睡早起 1正常 2晚睡晚起 3夜猫子', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_sleep_schedule');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_schedule', '早睡早起(22:00-6:00)', '0', '', '', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_schedule' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_schedule', '正常(23:00-7:00)', '1', '', '', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_schedule' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_schedule', '晚睡晚起(24:00-8:00)', '2', '', '', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_schedule' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_schedule', '夜猫子(01:00-9:00)', '3', '', '', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_schedule' AND `value` = '3');

-- 睡眠质量字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '睡眠质量', 'student_sleep_quality', 1, '睡眠质量：0浅睡易醒 1正常 2深睡', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_sleep_quality');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_quality', '浅睡易醒', '0', '', 'warning', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_quality' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_quality', '正常', '1', '', 'success', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_quality' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sleep_quality', '深睡', '2', '', 'success', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sleep_quality' AND `value` = '2');

-- 是否打呼噜字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否打呼噜', 'student_snores', 1, '是否打呼噜：0不打 1打', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_snores');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_snores', '不打呼噜', '0', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_snores' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_snores', '打呼噜', '1', '', 'warning', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_snores' AND `value` = '1');

-- 是否对光线敏感字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否对光线敏感', 'student_sensitive_to_light', 1, '是否对光线敏感：0不敏感 1敏感', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_sensitive_to_light');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sensitive_to_light', '不敏感', '0', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sensitive_to_light' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sensitive_to_light', '敏感', '1', '', 'warning', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sensitive_to_light' AND `value` = '1');

-- 是否对声音敏感字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否对声音敏感', 'student_sensitive_to_sound', 1, '是否对声音敏感：0不敏感 1敏感', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_sensitive_to_sound');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sensitive_to_sound', '不敏感', '0', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sensitive_to_sound' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_sensitive_to_sound', '敏感', '1', '', 'warning', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_sensitive_to_sound' AND `value` = '1');

-- 整洁程度字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '整洁程度', 'student_cleanliness_level', 1, '整洁程度：1非常整洁 2整洁 3一般 4随意 5不整洁', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_cleanliness_level');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_cleanliness_level', '非常整洁', '1', '', 'success', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_cleanliness_level' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_cleanliness_level', '整洁', '2', '', 'success', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_cleanliness_level' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_cleanliness_level', '一般', '3', '', 'info', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_cleanliness_level' AND `value` = '3');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_cleanliness_level', '随意', '4', '', 'warning', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_cleanliness_level' AND `value` = '4');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_cleanliness_level', '不整洁', '5', '', 'danger', 5, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_cleanliness_level' AND `value` = '5');

-- 睡前是否整理字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '睡前是否整理', 'student_bedtime_cleanup', 1, '睡前是否整理：0不整理 1偶尔整理 2经常整理 3总是整理', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_bedtime_cleanup');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_bedtime_cleanup', '不整理', '0', '', 'info', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_bedtime_cleanup' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_bedtime_cleanup', '偶尔整理', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_bedtime_cleanup' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_bedtime_cleanup', '经常整理', '2', '', 'success', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_bedtime_cleanup' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_bedtime_cleanup', '总是整理', '3', '', 'success', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_bedtime_cleanup' AND `value` = '3');

-- 社交偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '社交偏好', 'student_social_preference', 1, '社交偏好：1喜欢安静 2中等 3喜欢热闹', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_social_preference');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_social_preference', '喜欢安静', '1', '', 'info', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_social_preference' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_social_preference', '中等', '2', '', 'success', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_social_preference' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_social_preference', '喜欢热闹', '3', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_social_preference' AND `value` = '3');

-- 是否允许室友带访客字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否允许室友带访客', 'student_allow_visitors', 1, '是否允许室友带访客：0不允许 1偶尔可以 2可以', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_allow_visitors');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_allow_visitors', '不允许', '0', '', 'info', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_allow_visitors' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_allow_visitors', '偶尔可以', '1', '', 'warning', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_allow_visitors' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_allow_visitors', '可以', '2', '', 'success', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_allow_visitors' AND `value` = '2');

-- 电话时间偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '电话时间偏好', 'student_phone_call_time', 1, '电话时间偏好：0喜欢在宿舍打电话 1偶尔在宿舍 2不在宿舍打电话', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_phone_call_time');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_phone_call_time', '喜欢在宿舍打电话', '0', '', 'warning', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_phone_call_time' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_phone_call_time', '偶尔在宿舍', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_phone_call_time' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_phone_call_time', '不在宿舍打电话', '2', '', 'success', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_phone_call_time' AND `value` = '2');

-- 是否在宿舍学习字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否在宿舍学习', 'student_study_in_room', 1, '是否在宿舍学习：0不在 1偶尔 2经常 3总是', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_study_in_room');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_in_room', '不在', '0', '', 'info', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_in_room' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_in_room', '偶尔', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_in_room' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_in_room', '经常', '2', '', 'success', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_in_room' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_in_room', '总是', '3', '', 'success', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_in_room' AND `value` = '3');

-- 学习环境偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '学习环境偏好', 'student_study_environment', 1, '学习环境偏好：1需要安静 2需要轻音乐 3可以接受声音', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_study_environment');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_environment', '需要安静', '1', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_environment' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_environment', '需要轻音乐', '2', '', 'info', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_environment' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_study_environment', '可以接受声音', '3', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_study_environment' AND `value` = '3');

-- 电脑使用时间字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '电脑使用时间', 'student_computer_usage_time', 1, '电脑使用时间：0不用 1很少 2正常 3很多', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_computer_usage_time');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_computer_usage_time', '不用', '0', '', 'info', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_computer_usage_time' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_computer_usage_time', '很少(1-2h/天)', '1', '', 'success', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_computer_usage_time' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_computer_usage_time', '正常(3-5h/天)', '2', '', 'success', 3, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_computer_usage_time' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_computer_usage_time', '很多(6h+/天)', '3', '', 'warning', 4, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_computer_usage_time' AND `value` = '3');

-- 游戏偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '游戏偏好', 'student_gaming_preference', 1, '游戏偏好：0不玩游戏 1偶尔玩 2经常玩', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_gaming_preference');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_gaming_preference', '不玩游戏', '0', '', 'success', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_gaming_preference' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_gaming_preference', '偶尔玩', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_gaming_preference' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_gaming_preference', '经常玩', '2', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_gaming_preference' AND `value` = '2');

-- 听音乐偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '听音乐偏好', 'student_music_preference', 1, '听音乐偏好：0不听 1偶尔听 2经常听', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_music_preference');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_preference', '不听', '0', '', 'info', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_preference' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_preference', '偶尔听', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_preference' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_preference', '经常听', '2', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_preference' AND `value` = '2');

-- 音乐音量偏好字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '音乐音量偏好', 'student_music_volume', 1, '音乐音量偏好：1喜欢小声 2中等 3喜欢大声', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_music_volume');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_volume', '喜欢小声', '1', '', 'success', 1, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_volume' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_volume', '中等', '2', '', 'info', 2, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_volume' AND `value` = '2');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_music_volume', '喜欢大声', '3', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_music_volume' AND `value` = '3');

-- 是否在宿舍吃东西字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`, `update_time`)
SELECT '是否在宿舍吃东西', 'student_eat_in_room', 1, '是否在宿舍吃东西：0不吃 1偶尔 2经常', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_type` WHERE `dict_code` = 'student_eat_in_room');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_eat_in_room', '不吃', '0', '', 'success', 1, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_eat_in_room' AND `value` = '0');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_eat_in_room', '偶尔', '1', '', 'info', 2, 1, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_eat_in_room' AND `value` = '1');

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`, `create_time`, `update_time`)
SELECT 'student_eat_in_room', '经常', '2', '', 'warning', 3, 0, 1, '', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_dict_data` WHERE `dict_code` = 'student_eat_in_room' AND `value` = '2');

SET FOREIGN_KEY_CHECKS = 1;
