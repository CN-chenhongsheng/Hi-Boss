-- ====================================
-- 修改操作日志表：将dept_name字段改为device_type
-- 创建日期：2025-01-01
-- 说明：将部门名称字段改为设备类型字段（INT类型，存储字典值）
-- ====================================

SET NAMES utf8mb4;

-- 修改字段：将dept_name改为device_type，类型改为INT
ALTER TABLE `sys_oper_log` 
CHANGE COLUMN `dept_name` `device_type` INT DEFAULT NULL COMMENT '设备类型（字典sys_device_type：1桌面设备 2移动设备 3爬虫/Bot）';

