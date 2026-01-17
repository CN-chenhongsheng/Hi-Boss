-- =============================================
-- 审批流程管理系统数据库表
-- 作者：系统生成
-- 日期：2026-01-17
-- =============================================

-- 1. 审批流程定义表
DROP TABLE IF EXISTS `sys_approval_flow`;
CREATE TABLE `sys_approval_flow` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `flow_name` VARCHAR(100) NOT NULL COMMENT '流程名称',
    `flow_code` VARCHAR(50) NOT NULL COMMENT '流程编码(唯一)',
    `business_type` VARCHAR(50) NOT NULL COMMENT '业务类型(check_in/transfer/check_out/stay)',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '流程描述',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0停用 1启用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_flow_code` (`flow_code`),
    KEY `idx_business_type` (`business_type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批流程定义表';

-- 2. 审批流程节点表
DROP TABLE IF EXISTS `sys_approval_node`;
CREATE TABLE `sys_approval_node` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `flow_id` BIGINT NOT NULL COMMENT '流程ID',
    `node_name` VARCHAR(100) NOT NULL COMMENT '节点名称',
    `node_order` INT NOT NULL DEFAULT 1 COMMENT '节点顺序',
    `node_type` TINYINT NOT NULL DEFAULT 1 COMMENT '节点类型：1串行 2会签(所有人通过) 3或签(任一人通过)',
    `reject_action` TINYINT NOT NULL DEFAULT 1 COMMENT '拒绝处理：1直接结束 2退回申请人 3退回上一节点',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_flow_id` (`flow_id`),
    KEY `idx_node_order` (`flow_id`, `node_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批流程节点表';

-- 3. 审批节点审批人表
DROP TABLE IF EXISTS `sys_approval_node_assignee`;
CREATE TABLE `sys_approval_node_assignee` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `node_id` BIGINT NOT NULL COMMENT '节点ID',
    `assignee_type` TINYINT NOT NULL COMMENT '指派类型：1角色 2用户',
    `assignee_id` BIGINT NOT NULL COMMENT '角色ID或用户ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    PRIMARY KEY (`id`),
    KEY `idx_node_id` (`node_id`),
    KEY `idx_assignee` (`assignee_type`, `assignee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批节点审批人表';

-- 4. 审批流程绑定表
DROP TABLE IF EXISTS `sys_approval_flow_binding`;
CREATE TABLE `sys_approval_flow_binding` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `business_type` VARCHAR(50) NOT NULL COMMENT '业务类型(check_in/transfer/check_out/stay)',
    `flow_id` BIGINT NOT NULL COMMENT '绑定的流程ID',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0停用 1启用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_business_type` (`business_type`),
    KEY `idx_flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批流程绑定表';

-- 5. 审批实例表
DROP TABLE IF EXISTS `sys_approval_instance`;
CREATE TABLE `sys_approval_instance` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `flow_id` BIGINT NOT NULL COMMENT '流程ID',
    `flow_name` VARCHAR(100) DEFAULT NULL COMMENT '流程名称(冗余)',
    `business_type` VARCHAR(50) NOT NULL COMMENT '业务类型',
    `business_id` BIGINT NOT NULL COMMENT '业务数据ID',
    `applicant_id` BIGINT NOT NULL COMMENT '申请人ID',
    `applicant_name` VARCHAR(50) DEFAULT NULL COMMENT '申请人姓名(冗余)',
    `current_node_id` BIGINT DEFAULT NULL COMMENT '当前节点ID',
    `current_node_name` VARCHAR(100) DEFAULT NULL COMMENT '当前节点名称(冗余)',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1进行中 2已通过 3已拒绝 4已撤回',
    `start_time` DATETIME DEFAULT NULL COMMENT '流程开始时间',
    `end_time` DATETIME DEFAULT NULL COMMENT '流程结束时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_flow_id` (`flow_id`),
    KEY `idx_business` (`business_type`, `business_id`),
    KEY `idx_applicant_id` (`applicant_id`),
    KEY `idx_status` (`status`),
    KEY `idx_current_node` (`current_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批实例表';

-- 6. 审批记录表
DROP TABLE IF EXISTS `sys_approval_record`;
CREATE TABLE `sys_approval_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `instance_id` BIGINT NOT NULL COMMENT '审批实例ID',
    `node_id` BIGINT NOT NULL COMMENT '节点ID',
    `node_name` VARCHAR(100) DEFAULT NULL COMMENT '节点名称(冗余)',
    `approver_id` BIGINT NOT NULL COMMENT '审批人ID',
    `approver_name` VARCHAR(50) DEFAULT NULL COMMENT '审批人姓名(冗余)',
    `action` TINYINT NOT NULL COMMENT '操作：1通过 2拒绝',
    `opinion` VARCHAR(500) DEFAULT NULL COMMENT '审批意见',
    `approve_time` DATETIME NOT NULL COMMENT '审批时间',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_instance_id` (`instance_id`),
    KEY `idx_node_id` (`node_id`),
    KEY `idx_approver_id` (`approver_id`),
    KEY `idx_approve_time` (`approve_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审批记录表';

-- =============================================
-- 清空旧的申请数据（根据用户要求）
-- =============================================
-- TRUNCATE TABLE sys_check_in;
-- TRUNCATE TABLE sys_check_out;
-- TRUNCATE TABLE sys_transfer;
-- TRUNCATE TABLE sys_stay;

-- =============================================
-- 修改现有申请表，增加审批实例关联字段
-- =============================================
ALTER TABLE `sys_check_in` ADD COLUMN `approval_instance_id` BIGINT DEFAULT NULL COMMENT '审批实例ID' AFTER `status`;
ALTER TABLE `sys_check_out` ADD COLUMN `approval_instance_id` BIGINT DEFAULT NULL COMMENT '审批实例ID' AFTER `status`;
ALTER TABLE `sys_transfer` ADD COLUMN `approval_instance_id` BIGINT DEFAULT NULL COMMENT '审批实例ID' AFTER `status`;
ALTER TABLE `sys_stay` ADD COLUMN `approval_instance_id` BIGINT DEFAULT NULL COMMENT '审批实例ID' AFTER `status`;

-- 添加索引
ALTER TABLE `sys_check_in` ADD INDEX `idx_approval_instance` (`approval_instance_id`);
ALTER TABLE `sys_check_out` ADD INDEX `idx_approval_instance` (`approval_instance_id`);
ALTER TABLE `sys_transfer` ADD INDEX `idx_approval_instance` (`approval_instance_id`);
ALTER TABLE `sys_stay` ADD INDEX `idx_approval_instance` (`approval_instance_id`);

-- =============================================
-- 初始化菜单数据
-- =============================================
-- 获取最大菜单ID，避免ID冲突
SET @max_menu_id = (SELECT IFNULL(MAX(id), 0) FROM sys_menu);

-- 审批管理一级菜单
INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `icon`, `sort`, `visible`, `status`, `create_time`)
VALUES 
(@max_menu_id + 1, 0, '审批管理', 1, '/approval', 'Layout', 'ri:flow-chart', 3, 1, 1, NOW());

-- 流程配置二级菜单
INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `icon`, `sort`, `visible`, `status`, `create_time`)
VALUES 
(@max_menu_id + 2, @max_menu_id + 1, '流程配置', 2, '/approval/flow-config', '/approval/flow-config/index', 'ri:settings-3-line', 1, 1, 1, NOW());

-- 待办审批二级菜单
INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `icon`, `sort`, `visible`, `status`, `create_time`)
VALUES 
(@max_menu_id + 3, @max_menu_id + 1, '待办审批', 2, '/approval/pending', '/approval/pending/index', 'ri:todo-line', 2, 1, 1, NOW());

-- 审批记录二级菜单
INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `icon`, `sort`, `visible`, `status`, `create_time`)
VALUES 
(@max_menu_id + 4, @max_menu_id + 1, '审批记录', 2, '/approval/history', '/approval/history/index', 'ri:history-line', 3, 1, 1, NOW());
