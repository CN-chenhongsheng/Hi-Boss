-- ========================================
-- 学生表生活习惯字段添加SQL
-- 创建日期：2026-01-07
-- 数据库：MySQL 8.0
-- 说明：为学生表添加生活习惯相关字段，用于床位分配算法
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 为学生表添加生活习惯字段
ALTER TABLE `sys_student`
  -- 吸烟相关（必填，核心匹配条件）
  ADD COLUMN `smoking_status` TINYINT DEFAULT 0 COMMENT '吸烟状态：0不吸烟 1吸烟' AFTER `bed_code`,
  ADD COLUMN `smoking_tolerance` TINYINT DEFAULT 0 COMMENT '是否接受室友吸烟：0不接受 1接受' AFTER `smoking_status`,
  
  -- 作息习惯
  ADD COLUMN `sleep_schedule` TINYINT DEFAULT 1 COMMENT '作息时间：0早睡早起(22:00-6:00) 1正常(23:00-7:00) 2晚睡晚起(24:00-8:00) 3夜猫子(01:00-9:00)' AFTER `smoking_tolerance`,
  ADD COLUMN `sleep_quality` TINYINT DEFAULT 1 COMMENT '睡眠质量：0浅睡易醒 1正常 2深睡' AFTER `sleep_schedule`,
  ADD COLUMN `snores` TINYINT DEFAULT 0 COMMENT '是否打呼噜：0不打 1打' AFTER `sleep_quality`,
  ADD COLUMN `sensitive_to_light` TINYINT DEFAULT 0 COMMENT '是否对光线敏感：0不敏感 1敏感' AFTER `snores`,
  ADD COLUMN `sensitive_to_sound` TINYINT DEFAULT 0 COMMENT '是否对声音敏感：0不敏感 1敏感' AFTER `sensitive_to_light`,
  
  -- 卫生习惯
  ADD COLUMN `cleanliness_level` TINYINT DEFAULT 2 COMMENT '整洁程度：1非常整洁 2整洁 3一般 4随意 5不整洁' AFTER `sensitive_to_sound`,
  ADD COLUMN `bedtime_cleanup` TINYINT DEFAULT 1 COMMENT '睡前是否整理：0不整理 1偶尔整理 2经常整理 3总是整理' AFTER `cleanliness_level`,
  
  -- 社交偏好
  ADD COLUMN `social_preference` TINYINT DEFAULT 1 COMMENT '社交偏好：1喜欢安静 2中等 3喜欢热闹' AFTER `bedtime_cleanup`,
  ADD COLUMN `allow_visitors` TINYINT DEFAULT 1 COMMENT '是否允许室友带访客：0不允许 1偶尔可以 2可以' AFTER `social_preference`,
  ADD COLUMN `phone_call_time` TINYINT DEFAULT 1 COMMENT '电话时间偏好：0喜欢在宿舍打电话 1偶尔在宿舍 2不在宿舍打电话' AFTER `allow_visitors`,
  
  -- 学习习惯
  ADD COLUMN `study_in_room` TINYINT DEFAULT 1 COMMENT '是否在宿舍学习：0不在 1偶尔 2经常 3总是' AFTER `phone_call_time`,
  ADD COLUMN `study_environment` TINYINT DEFAULT 1 COMMENT '学习环境偏好：1需要安静 2需要轻音乐 3可以接受声音' AFTER `study_in_room`,
  ADD COLUMN `computer_usage_time` TINYINT DEFAULT 2 COMMENT '电脑使用时间：0不用 1很少(1-2h/天) 2正常(3-5h/天) 3很多(6h+/天)' AFTER `study_environment`,
  
  -- 娱乐习惯
  ADD COLUMN `gaming_preference` TINYINT DEFAULT 1 COMMENT '游戏偏好：0不玩游戏 1偶尔玩 2经常玩' AFTER `computer_usage_time`,
  ADD COLUMN `music_preference` TINYINT DEFAULT 1 COMMENT '听音乐偏好：0不听 1偶尔听 2经常听' AFTER `gaming_preference`,
  ADD COLUMN `music_volume` TINYINT DEFAULT 1 COMMENT '音乐音量偏好：1喜欢小声 2中等 3喜欢大声' AFTER `music_preference`,
  
  -- 饮食习惯（可选）
  ADD COLUMN `eat_in_room` TINYINT DEFAULT 1 COMMENT '是否在宿舍吃东西：0不吃 1偶尔 2经常' AFTER `music_volume`,
  
  -- 其他
  ADD COLUMN `special_needs` VARCHAR(500) DEFAULT NULL COMMENT '特殊需求（如过敏、健康问题等）' AFTER `eat_in_room`,
  ADD COLUMN `roommate_preference` VARCHAR(200) DEFAULT NULL COMMENT '室友偏好（如希望室友不抽烟、安静等）' AFTER `special_needs`;

SET FOREIGN_KEY_CHECKS = 1;

