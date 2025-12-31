-- ====================================
-- 宿舍管理系统 - 字典管理模块建表SQL
-- 创建日期：2025-12-30
-- 数据库：MySQL 8.0
-- ====================================

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ====================================
-- 1. 字典类型表
-- ====================================
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_name` varchar(100) NOT NULL COMMENT '字典名称',
  `dict_code` varchar(100) NOT NULL COMMENT '字典编码',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1正常 0停用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dict_code` (`dict_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典类型表';

-- ====================================
-- 2. 字典数据表
-- ====================================
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_code` varchar(100) NOT NULL COMMENT '字典编码',
  `label` varchar(100) NOT NULL COMMENT '字典标签',
  `value` varchar(100) NOT NULL COMMENT '字典值',
  `css_class` varchar(100) DEFAULT NULL COMMENT 'CSS类名',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认：1是 0否',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1正常 0停用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_dict_code` (`dict_code`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典数据表';

-- 插入示例数据
INSERT INTO `sys_dict_type` (`id`, `dict_name`, `dict_code`, `status`, `remark`) VALUES
(1, '用户性别', 'sys_user_sex', 1, '用户性别字典'),
(2, '用户状态', 'sys_user_status', 1, '用户状态字典'),
(3, '系统开关', 'sys_switch', 1, '系统开关字典');

INSERT INTO `sys_dict_data` (`id`, `dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`) VALUES
(1, 'sys_user_sex', '男', '1', NULL, 'primary', 1, 0, 1, '男性'),
(2, 'sys_user_sex', '女', '2', NULL, 'success', 2, 0, 1, '女性'),
(3, 'sys_user_status', '正常', '1', NULL, 'success', 1, 1, 1, '正常状态'),
(4, 'sys_user_status', '停用', '0', NULL, 'danger', 2, 0, 1, '停用状态'),
(5, 'sys_switch', '开启', '1', NULL, 'success', 1, 0, 1, '开启状态'),
(6, 'sys_switch', '关闭', '0', NULL, 'info', 2, 0, 1, '关闭状态');

SET FOREIGN_KEY_CHECKS = 1;

-- ====================================
-- SQL执行完成
-- ====================================

