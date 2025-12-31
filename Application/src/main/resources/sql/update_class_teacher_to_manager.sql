-- ========================================
-- 修改班级表字段注释：班主任/辅导员 -> 负责人
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- 说明: 将 sys_class 表的 teacher 字段注释从"班主任/辅导员"改为"负责人"
-- ========================================

ALTER TABLE `sys_class` 
MODIFY COLUMN `teacher` VARCHAR(50) DEFAULT NULL COMMENT '负责人';

