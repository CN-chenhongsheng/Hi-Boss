-- ====================================
-- 为专业表添加类型字段
-- 创建日期：2025-01-01
-- ====================================

-- 添加类型字段（关联学位类型字典）
ALTER TABLE `sys_major` 
ADD COLUMN `type` VARCHAR(50) DEFAULT NULL COMMENT '学位类型（字典degree_type）' AFTER `director`;

