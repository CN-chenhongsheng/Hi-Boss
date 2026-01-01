-- ====================================
-- 为院系表添加排序字段
-- 创建日期：2025-01-01
-- ====================================

-- 添加排序字段
ALTER TABLE `sys_department` 
ADD COLUMN `sort` INT NOT NULL DEFAULT 0 COMMENT '排序' AFTER `phone`;

