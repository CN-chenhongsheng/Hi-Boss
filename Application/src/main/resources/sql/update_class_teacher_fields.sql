-- ========================================
-- 修改班级表负责人字段：teacher -> teacher_name，添加 teacher_id
-- 版本: 1.0.0
-- 日期: 2025-01-01
-- 说明: 将 sys_class 表的 teacher 字段重命名为 teacher_name（冗余字段），并添加 teacher_id 字段（关联用户ID）
-- ========================================

SET NAMES utf8mb4;

-- 重命名字段
ALTER TABLE `sys_class` 
CHANGE COLUMN `teacher` `teacher_name` VARCHAR(50) DEFAULT NULL COMMENT '负责人姓名（冗余字段）';

-- 添加新字段
ALTER TABLE `sys_class` 
ADD COLUMN `teacher_id` BIGINT DEFAULT NULL COMMENT '负责人ID（关联sys_user）' AFTER `teacher_name`;

-- 添加索引
CREATE INDEX `idx_teacher_id` ON `sys_class`(`teacher_id`);

