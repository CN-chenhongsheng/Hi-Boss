-- ====================================
-- 添加审计字段（create_by、update_by）迁移脚本
-- 创建日期：2025-01-01
-- 说明：为所有业务表添加创建人和更新人字段
-- ====================================

SET NAMES utf8mb4;

-- 校区表
ALTER TABLE `sys_campus` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 院系表
ALTER TABLE `sys_department` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 专业表
ALTER TABLE `sys_major` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 班级表
ALTER TABLE `sys_class` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 字典类型表
ALTER TABLE `sys_dict_type` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 字典数据表
ALTER TABLE `sys_dict_data` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 系统用户表
ALTER TABLE `sys_user` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 系统角色表
ALTER TABLE `sys_role` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 系统菜单表
ALTER TABLE `sys_menu` 
ADD COLUMN `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID' AFTER `create_time`,
ADD COLUMN `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID' AFTER `update_time`;

-- 注意：关联表（sys_user_role、sys_role_menu）通常不需要更新人和更新人字段，因此不添加

