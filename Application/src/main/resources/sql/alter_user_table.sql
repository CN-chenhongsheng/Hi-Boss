-- ========================================
-- 用户表字段扩展迁移脚本
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- 说明: 为 sys_user 表添加扩展字段
-- 数据库: MySQL
-- ========================================

-- 添加新字段（MySQL语法）
-- 如果字段已存在会报错，可以忽略或单独执行每条语句

ALTER TABLE sys_user ADD COLUMN gender INT DEFAULT NULL COMMENT '性别(字典sys_gender): 0未知 1男 2女';
ALTER TABLE sys_user ADD COLUMN address VARCHAR(255) DEFAULT NULL COMMENT '地址';
ALTER TABLE sys_user ADD COLUMN introduction VARCHAR(500) DEFAULT NULL COMMENT '个人介绍';
ALTER TABLE sys_user ADD COLUMN cp_user_id VARCHAR(64) DEFAULT NULL COMMENT '企业微信ID';
ALTER TABLE sys_user ADD COLUMN openid VARCHAR(64) DEFAULT NULL COMMENT '微信openid';
ALTER TABLE sys_user ADD COLUMN del_flag INT DEFAULT 0 COMMENT '删除标志: 0正常 1删除';

-- 为企业微信ID添加索引（可选，根据业务需求）
-- CREATE INDEX idx_sys_user_cp_user_id ON sys_user(cp_user_id);

-- 为微信openid添加索引（可选，根据业务需求）
-- CREATE INDEX idx_sys_user_openid ON sys_user(openid);

-- ========================================
-- 添加性别字典类型
-- ========================================
INSERT INTO sys_dict_type (dict_name, dict_code, status, remark, create_time, update_time)
SELECT '性别', 'sys_gender', 1, '用户性别字典', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_code = 'sys_gender');

-- ========================================
-- 添加性别字典数据
-- ========================================
INSERT INTO sys_dict_data (dict_code, label, value, css_class, list_class, sort, is_default, status, remark, create_time, update_time)
SELECT 'sys_gender', '未知', '0', '', 'info', 0, 0, 1, '未知性别', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_code = 'sys_gender' AND value = '0');

INSERT INTO sys_dict_data (dict_code, label, value, css_class, list_class, sort, is_default, status, remark, create_time, update_time)
SELECT 'sys_gender', '男', '1', '', 'primary', 1, 0, 1, '男性', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_code = 'sys_gender' AND value = '1');

INSERT INTO sys_dict_data (dict_code, label, value, css_class, list_class, sort, is_default, status, remark, create_time, update_time)
SELECT 'sys_gender', '女', '2', '', 'success', 2, 0, 1, '女性', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_code = 'sys_gender' AND value = '2');
