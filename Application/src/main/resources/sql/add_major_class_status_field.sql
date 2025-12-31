-- ========================================
-- 为专业表和班级表添加状态字段
-- 版本: 1.0.0
-- 日期: 2025-01-01
-- 说明: 为 sys_major 和 sys_class 表添加 status 字段
-- ========================================

-- 1. 为专业表添加状态字段
ALTER TABLE `sys_major`
ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用' AFTER `goal`;

-- 2. 为班级表添加状态字段
ALTER TABLE `sys_class`
ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用' AFTER `current_count`;

-- 3. 为状态字段添加索引（可选，用于查询优化）
ALTER TABLE `sys_major` ADD INDEX `idx_status` (`status`);
ALTER TABLE `sys_class` ADD INDEX `idx_status` (`status`);

