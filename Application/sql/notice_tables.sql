-- ----------------------------
-- 通知公告表
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` VARCHAR(200) NOT NULL COMMENT '标题',
  `content` TEXT NOT NULL COMMENT '内容',
  `notice_type` INT(11) NOT NULL COMMENT '通知类型：1系统通知 2宿舍公告 3安全提醒 4停水停电 99其他',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图片',
  `attachments` TEXT DEFAULT NULL COMMENT '附件（JSON数组）',
  `publisher_id` BIGINT(20) DEFAULT NULL COMMENT '发布人ID',
  `publisher_name` VARCHAR(50) DEFAULT NULL COMMENT '发布人姓名',
  `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
  `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶：0否 1是',
  `target_floors` TEXT DEFAULT NULL COMMENT '目标楼层（JSON数组，为空表示全部）',
  `read_count` INT(11) DEFAULT 0 COMMENT '阅读次数',
  `status` INT(11) DEFAULT 0 COMMENT '状态：0草稿 1已发布',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` BIGINT(20) DEFAULT NULL COMMENT '创建人ID',
  `update_by` BIGINT(20) DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`),
  KEY `idx_notice_type` (`notice_type`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_is_top` (`is_top`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';

-- ----------------------------
-- 通知阅读记录表
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `notice_id` BIGINT(20) NOT NULL COMMENT '通知ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID（学生ID）',
  `read_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '阅读时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` BIGINT(20) DEFAULT NULL COMMENT '创建人ID',
  `update_by` BIGINT(20) DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_notice_user` (`notice_id`, `user_id`),
  KEY `idx_notice_id` (`notice_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知阅读记录表';

-- ----------------------------
-- 通知相关字典：先删后插，避免重复执行报错
-- ----------------------------
DELETE FROM `sys_dict_data` WHERE `dict_code` IN ('notice_type', 'notice_status');
DELETE FROM `sys_dict_type` WHERE `dict_code` IN ('notice_type', 'notice_status');

-- 通知类型字典类型（先插入类型，再插入数据）
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`) VALUES
('通知类型', 'notice_type', 1, '通知公告的类型'),
('通知状态', 'notice_status', 1, '通知公告的状态');

-- ----------------------------
-- 通知类型字典数据
-- ----------------------------
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `remark`, `status`) VALUES
('notice_type', '系统通知', '1', 1, '系统通知类型', 1),
('notice_type', '宿舍公告', '2', 2, '宿舍公告类型', 1),
('notice_type', '安全提醒', '3', 3, '安全提醒类型', 1),
('notice_type', '停水停电', '4', 4, '停水停电类型', 1),
('notice_type', '其他', '99', 99, '其他类型', 1);

-- ----------------------------
-- 通知状态字典数据
-- ----------------------------
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `remark`, `status`) VALUES
('notice_status', '草稿', '0', 0, '草稿状态', 1),
('notice_status', '已发布', '1', 1, '已发布状态', 1);

-- ----------------------------
-- 示例数据（可选）：先删后插，避免重复执行报错
-- ----------------------------
DELETE FROM `sys_notice` WHERE `title` IN ('欢迎使用宿舍管理系统', '春节放假通知', '注意用电安全');

INSERT INTO `sys_notice` (`title`, `content`, `notice_type`, `publisher_name`, `publish_time`, `is_top`, `read_count`, `status`) VALUES
('欢迎使用宿舍管理系统', '欢迎使用宿舍管理系统小程序！如有问题，请联系管理员。', 1, '系统管理员', NOW(), 1, 0, 1),
('春节放假通知', '根据学校安排，春节期间宿舍开放时间调整如下：除夕至初六全天开放，初七恢复正常。请同学们合理安排时间。', 2, '宿管科', NOW(), 1, 0, 1),
('注意用电安全', '冬季是火灾高发期，请同学们注意用电安全，不使用违规电器，离开宿舍及时关闭电源。', 3, '保卫处', NOW(), 0, 0, 1);
