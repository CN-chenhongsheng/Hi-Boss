/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : project_management

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 30/01/2026 16:43:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_academic_year
-- ----------------------------
DROP TABLE IF EXISTS `sys_academic_year`;
CREATE TABLE `sys_academic_year`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `year_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学年编码',
  `year_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学年名称',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_year_code`(`year_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学年表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_academic_year
-- ----------------------------

-- ----------------------------
-- Table structure for sys_approval_flow
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_flow`;
CREATE TABLE `sys_approval_flow`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `flow_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程名称',
  `flow_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程编码(唯一)',
  `business_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务类型(check_in/transfer/check_out/stay)',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程描述',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0停用 1启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_flow_code`(`flow_code` ASC) USING BTREE,
  INDEX `idx_business_type`(`business_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程定义表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_flow
-- ----------------------------
INSERT INTO `sys_approval_flow` VALUES (1, '入住流程', '#001', 'check_in', '这是一个入住管理的配置流程。', 1, NULL, '2026-01-17 22:16:19', 1, '2026-01-25 15:09:07', 1);
INSERT INTO `sys_approval_flow` VALUES (2, '调宿流程', '#002', 'transfer', '这是一条调宿申请流程', 1, NULL, '2026-01-25 15:06:46', 1, '2026-01-25 15:08:55', 1);
INSERT INTO `sys_approval_flow` VALUES (3, '退宿流程', '#003', 'check_out', '这是一条退宿申请流程。', 1, NULL, '2026-01-25 15:32:53', 1, '2026-01-25 15:32:53', 1);
INSERT INTO `sys_approval_flow` VALUES (4, '留宿流程', '#004', 'stay', '这是一条留宿申请流程。', 1, NULL, '2026-01-25 23:01:26', 1, '2026-01-25 23:01:26', 1);

-- ----------------------------
-- Table structure for sys_approval_flow_binding
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_flow_binding`;
CREATE TABLE `sys_approval_flow_binding`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `business_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务类型(check_in/transfer/check_out/stay)',
  `flow_id` bigint NOT NULL COMMENT '绑定的流程ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0停用 1启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_business_type`(`business_type` ASC) USING BTREE,
  INDEX `idx_flow_id`(`flow_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程绑定表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_flow_binding
-- ----------------------------
INSERT INTO `sys_approval_flow_binding` VALUES (6, 'check_in', 1, 1, NULL, '2026-01-19 12:14:08', 1, '2026-01-19 12:14:08', 1);
INSERT INTO `sys_approval_flow_binding` VALUES (7, 'transfer', 2, 1, NULL, '2026-01-25 15:06:55', 1, '2026-01-25 15:06:55', 1);
INSERT INTO `sys_approval_flow_binding` VALUES (8, 'check_out', 3, 1, NULL, '2026-01-25 15:32:58', 1, '2026-01-25 22:09:28', 1);
INSERT INTO `sys_approval_flow_binding` VALUES (9, 'stay', 4, 1, NULL, '2026-01-25 23:01:34', 1, '2026-01-25 23:01:34', 1);

-- ----------------------------
-- Table structure for sys_approval_instance
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_instance`;
CREATE TABLE `sys_approval_instance`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `flow_id` bigint NOT NULL COMMENT '流程ID',
  `flow_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程名称(冗余)',
  `business_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务类型',
  `business_id` bigint NOT NULL COMMENT '业务数据ID',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID',
  `applicant_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申请人姓名(冗余)',
  `current_node_id` bigint NULL DEFAULT NULL COMMENT '当前节点ID',
  `current_node_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '当前节点名称(冗余)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1进行中 2已通过 3已拒绝 4已撤回',
  `start_time` datetime NULL DEFAULT NULL COMMENT '流程开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '流程结束时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_flow_id`(`flow_id` ASC) USING BTREE,
  INDEX `idx_business`(`business_type` ASC, `business_id` ASC) USING BTREE,
  INDEX `idx_applicant_id`(`applicant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_current_node`(`current_node_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批实例表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_instance
-- ----------------------------
INSERT INTO `sys_approval_instance` VALUES (1, 1, '入住管理', 'check_in', 1, 14, '张三', 1, '已完成', 2, '2026-01-17 22:42:51', '2026-01-17 23:24:37', NULL, '2026-01-17 22:42:51', 14, '2026-01-17 22:42:51', 14);
INSERT INTO `sys_approval_instance` VALUES (2, 1, '入住管理', 'check_in', 2, 14, '张三', 2, '二次管理员', 1, '2026-01-17 23:28:26', NULL, NULL, '2026-01-17 23:28:26', 14, '2026-01-17 23:28:26', 14);
INSERT INTO `sys_approval_instance` VALUES (3, 1, '入住流程', 'check_in', 3, 14, '张三', 1, '管理员', 1, '2026-01-25 15:03:25', NULL, NULL, '2026-01-25 15:03:25', 14, '2026-01-25 15:03:25', 14);
INSERT INTO `sys_approval_instance` VALUES (4, 3, '退宿流程', 'check_out', 1, 14, '张三', 5, '宿舍阿姨', 1, '2026-01-25 16:55:07', NULL, NULL, '2026-01-25 16:55:07', 14, '2026-01-25 16:55:07', 14);
INSERT INTO `sys_approval_instance` VALUES (5, 1, '入住流程', 'check_in', 4, 14, '张三', 1, '宿舍阿姨', 1, '2026-01-25 20:44:40', NULL, NULL, '2026-01-25 20:44:40', 14, '2026-01-25 20:44:40', 14);
INSERT INTO `sys_approval_instance` VALUES (6, 4, '留宿流程', 'stay', 1, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:02:42', NULL, NULL, '2026-01-25 23:02:42', 14, '2026-01-25 23:02:42', 14);
INSERT INTO `sys_approval_instance` VALUES (7, 4, '留宿流程', 'stay', 2, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:15:12', NULL, NULL, '2026-01-25 23:15:12', 14, '2026-01-25 23:15:12', 14);
INSERT INTO `sys_approval_instance` VALUES (8, 4, '留宿流程', 'stay', 3, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:20:22', NULL, NULL, '2026-01-25 23:20:22', 14, '2026-01-25 23:20:22', 14);
INSERT INTO `sys_approval_instance` VALUES (9, 4, '留宿流程', 'stay', 4, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:22:56', NULL, NULL, '2026-01-25 23:22:56', 14, '2026-01-25 23:22:56', 14);
INSERT INTO `sys_approval_instance` VALUES (10, 4, '留宿流程', 'stay', 5, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:37:33', NULL, NULL, '2026-01-25 23:37:33', 14, '2026-01-25 23:37:33', 14);
INSERT INTO `sys_approval_instance` VALUES (11, 4, '留宿流程', 'stay', 6, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:40:45', NULL, NULL, '2026-01-25 23:40:45', 14, '2026-01-25 23:40:45', 14);
INSERT INTO `sys_approval_instance` VALUES (12, 4, '留宿流程', 'stay', 7, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:42:57', NULL, NULL, '2026-01-25 23:42:57', 14, '2026-01-25 23:42:57', 14);
INSERT INTO `sys_approval_instance` VALUES (13, 4, '留宿流程', 'stay', 8, 14, '张三', 7, '宿管阿姨', 1, '2026-01-25 23:45:46', NULL, NULL, '2026-01-25 23:45:46', 14, '2026-01-25 23:45:46', 14);
INSERT INTO `sys_approval_instance` VALUES (14, 4, '留宿流程', 'stay', 9, 14, '张三', 7, '宿管阿姨', 1, '2026-01-26 00:23:13', NULL, NULL, '2026-01-26 00:23:13', 14, '2026-01-26 00:23:13', 14);
INSERT INTO `sys_approval_instance` VALUES (15, 4, '留宿流程', 'stay', 10, 14, '张三', 7, '宿管阿姨', 1, '2026-01-26 00:32:04', NULL, NULL, '2026-01-26 00:32:04', 14, '2026-01-26 00:32:04', 14);

-- ----------------------------
-- Table structure for sys_approval_node
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_node`;
CREATE TABLE `sys_approval_node`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `flow_id` bigint NOT NULL COMMENT '流程ID',
  `node_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '节点名称',
  `node_order` int NOT NULL DEFAULT 1 COMMENT '节点顺序',
  `node_type` tinyint NOT NULL DEFAULT 1 COMMENT '节点类型：1串行 2会签(所有人通过) 3或签(任一人通过)',
  `reject_action` tinyint NOT NULL DEFAULT 1 COMMENT '拒绝处理：1直接结束 2退回申请人 3退回上一节点',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_flow_id`(`flow_id` ASC) USING BTREE,
  INDEX `idx_node_order`(`flow_id` ASC, `node_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程节点表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_node
-- ----------------------------
INSERT INTO `sys_approval_node` VALUES (1, 1, '宿舍阿姨', 1, 1, 1, NULL, '2026-01-25 15:09:07', 1, '2026-01-25 15:09:07', 1);
INSERT INTO `sys_approval_node` VALUES (2, 1, '管理员', 2, 1, 1, NULL, '2026-01-25 15:09:07', 1, '2026-01-25 15:09:07', 1);
INSERT INTO `sys_approval_node` VALUES (3, 2, '宿舍阿姨', 1, 1, 1, NULL, '2026-01-25 15:08:55', 1, '2026-01-25 15:08:55', 1);
INSERT INTO `sys_approval_node` VALUES (4, 2, '管理员', 2, 1, 3, NULL, '2026-01-25 15:08:55', 1, '2026-01-25 15:08:55', 1);
INSERT INTO `sys_approval_node` VALUES (5, 3, '宿舍阿姨', 1, 1, 1, NULL, '2026-01-25 15:32:53', 1, '2026-01-25 15:32:53', 1);
INSERT INTO `sys_approval_node` VALUES (6, 3, '管理员', 2, 1, 2, NULL, '2026-01-25 15:32:53', 1, '2026-01-25 15:32:53', 1);
INSERT INTO `sys_approval_node` VALUES (7, 4, '宿管阿姨', 1, 1, 1, NULL, '2026-01-25 23:01:26', 1, '2026-01-25 23:01:26', 1);
INSERT INTO `sys_approval_node` VALUES (8, 4, '管理员', 2, 1, 3, NULL, '2026-01-25 23:01:26', 1, '2026-01-25 23:01:26', 1);

-- ----------------------------
-- Table structure for sys_approval_node_assignee
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_node_assignee`;
CREATE TABLE `sys_approval_node_assignee`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `node_id` bigint NOT NULL COMMENT '节点ID',
  `assignee_type` tinyint NOT NULL COMMENT '指派类型：1角色 2用户',
  `assignee_id` bigint NOT NULL COMMENT '角色ID或用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_node_id`(`node_id` ASC) USING BTREE,
  INDEX `idx_assignee`(`assignee_type` ASC, `assignee_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批节点审批人表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_node_assignee
-- ----------------------------
INSERT INTO `sys_approval_node_assignee` VALUES (13, 3, 2, 2, '2026-01-25 15:08:55', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (14, 4, 2, 1, '2026-01-25 15:08:55', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (15, 1, 2, 2, '2026-01-25 15:09:07', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (16, 2, 2, 1, '2026-01-25 15:09:07', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (17, 5, 2, 2, '2026-01-25 15:32:53', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (18, 6, 2, 1, '2026-01-25 15:32:53', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (19, 7, 2, 2, '2026-01-25 23:01:26', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (20, 8, 2, 1, '2026-01-25 23:01:26', 1);

-- ----------------------------
-- Table structure for sys_approval_record
-- ----------------------------
DROP TABLE IF EXISTS `sys_approval_record`;
CREATE TABLE `sys_approval_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `instance_id` bigint NOT NULL COMMENT '审批实例ID',
  `node_id` bigint NOT NULL COMMENT '节点ID',
  `node_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '节点名称(冗余)',
  `approver_id` bigint NOT NULL COMMENT '审批人ID',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人姓名(冗余)',
  `action` tinyint NOT NULL COMMENT '操作：1通过 2拒绝',
  `opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批意见',
  `approve_time` datetime NOT NULL COMMENT '审批时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_instance_id`(`instance_id` ASC) USING BTREE,
  INDEX `idx_node_id`(`node_id` ASC) USING BTREE,
  INDEX `idx_approver_id`(`approver_id` ASC) USING BTREE,
  INDEX `idx_approve_time`(`approve_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_approval_record
-- ----------------------------
INSERT INTO `sys_approval_record` VALUES (2, 2, 1, '管理员', 1, '超级管理员', 1, '同意，没问题。', '2026-01-22 11:23:06', '2026-01-22 11:23:06');

-- ----------------------------
-- Table structure for sys_bed
-- ----------------------------
DROP TABLE IF EXISTS `sys_bed`;
CREATE TABLE `sys_bed`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '床位编码（如：101-1、101-2）',
  `bed_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '床位号（如：1、2、3、4）',
  `room_id` bigint NOT NULL COMMENT '所属房间ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属房间编码（冗余字段）',
  `floor_id` bigint NULL DEFAULT NULL COMMENT '所属楼层ID（冗余字段）',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属楼层编码（冗余字段）',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属校区编码（冗余字段）',
  `bed_position` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '床位位置（字典bed_position）：上铺、下铺、左、右等',
  `bed_status` tinyint NOT NULL DEFAULT 1 COMMENT '床位状态：1空闲 2已占用 3维修中 4已预订',
  `student_id` bigint NULL DEFAULT NULL COMMENT '当前入住学生ID（关联学生表，可为空）',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '当前入住学生姓名（冗余字段）',
  `check_in_date` date NULL DEFAULT NULL COMMENT '入住日期',
  `check_out_date` date NULL DEFAULT NULL COMMENT '退宿日期',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_bed_code`(`bed_code` ASC) USING BTREE,
  INDEX `idx_room_id`(`room_id` ASC) USING BTREE,
  INDEX `idx_room_code`(`room_code` ASC) USING BTREE,
  INDEX `idx_floor_id`(`floor_id` ASC) USING BTREE,
  INDEX `idx_campus_code`(`campus_code` ASC) USING BTREE,
  INDEX `idx_bed_code`(`bed_code` ASC) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '床位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_bed
-- ----------------------------
INSERT INTO `sys_bed` VALUES (13, '1', '1', 51, '101', 1, 'A001', 'CAMPUS001', NULL, 1, NULL, NULL, '2026-01-01', '2026-06-01', 1, 1, NULL, '2026-01-06 16:07:49', 1, '2026-01-21 16:57:10', 1);
INSERT INTO `sys_bed` VALUES (14, '2', '2', 51, '101', 1, 'A001', 'CAMPUS001', NULL, 1, NULL, NULL, '2026-01-01', '2026-06-01', 2, 1, NULL, '2026-01-06 16:07:49', 1, '2026-01-06 16:47:07', 1);
INSERT INTO `sys_bed` VALUES (15, '3', '3', 51, '101', 1, 'A001', 'CAMPUS001', NULL, 1, NULL, NULL, '2026-01-01', '2026-06-01', 3, 1, NULL, '2026-01-06 16:07:49', 1, '2026-01-06 16:47:07', 1);
INSERT INTO `sys_bed` VALUES (16, '4', '4', 51, '101', 1, 'A001', 'CAMPUS001', NULL, 1, NULL, NULL, '2026-01-01', '2026-06-01', 4, 1, NULL, '2026-01-06 16:07:49', 1, '2026-01-06 16:47:07', 1);

-- ----------------------------
-- Table structure for sys_campus
-- ----------------------------
DROP TABLE IF EXISTS `sys_campus`;
CREATE TABLE `sys_campus`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '校区编码',
  `campus_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '校区名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '校区地址',
  `manager` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_campus_code`(`campus_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '校区表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_campus
-- ----------------------------
INSERT INTO `sys_campus` VALUES (1, 'CAMPUS001', '主校区', '北京市海淀区中关村大街1号', '张三', 1, 1, '2025-12-31 12:51:08', NULL, '2026-01-21 16:52:40', 1);

-- ----------------------------
-- Table structure for sys_check_in
-- ----------------------------
DROP TABLE IF EXISTS `sys_check_in`;
CREATE TABLE `sys_check_in`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名（冗余）',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学号（冗余）',
  `check_in_type` int NOT NULL COMMENT '入住类型：1长期住宿 2临时住宿',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '校区编码',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层编码',
  `room_id` bigint NULL DEFAULT NULL COMMENT '房间ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间编码',
  `bed_id` bigint NULL DEFAULT NULL COMMENT '床位ID',
  `bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '床位编码',
  `apply_date` date NULL DEFAULT NULL COMMENT '申请日期',
  `check_in_date` date NULL DEFAULT NULL COMMENT '入住日期',
  `expected_check_out_date` date NULL DEFAULT NULL COMMENT '预计退宿日期（临时住宿）',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已入住',
  `approval_instance_id` bigint NULL DEFAULT NULL COMMENT '审批实例ID',
  `approver_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `approve_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `apply_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请原因/备注',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_check_in_date`(`check_in_date` ASC) USING BTREE,
  INDEX `idx_bed_id`(`bed_id` ASC) USING BTREE,
  INDEX `idx_approval_instance`(`approval_instance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '入住管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_check_in
-- ----------------------------
INSERT INTO `sys_check_in` VALUES (2, 14, '张三', '2021001', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-17', NULL, 1, 2, NULL, NULL, NULL, NULL, '1111', NULL, '2026-01-17 23:28:26', 14, '2026-01-17 23:28:26', 14);
INSERT INTO `sys_check_in` VALUES (3, 14, '张三', '2021001', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', NULL, 1, 3, NULL, NULL, NULL, NULL, '测试', NULL, '2026-01-25 15:03:25', 14, '2026-01-25 15:03:25', 14);
INSERT INTO `sys_check_in` VALUES (4, 14, '张三', '2021001', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', NULL, 1, 5, NULL, NULL, NULL, NULL, '这是一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的文字。', NULL, '2026-01-25 20:44:40', 14, '2026-01-25 20:44:40', 14);

-- ----------------------------
-- Table structure for sys_check_out
-- ----------------------------
DROP TABLE IF EXISTS `sys_check_out`;
CREATE TABLE `sys_check_out`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名（冗余）',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学号（冗余）',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '校区编码',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层编码',
  `room_id` bigint NULL DEFAULT NULL COMMENT '房间ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间编码',
  `bed_id` bigint NULL DEFAULT NULL COMMENT '床位ID',
  `bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '床位编码',
  `apply_date` date NULL DEFAULT NULL COMMENT '申请日期',
  `check_out_date` date NULL DEFAULT NULL COMMENT '退宿日期',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
  `approval_instance_id` bigint NULL DEFAULT NULL COMMENT '审批实例ID',
  `approver_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `approve_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `check_out_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退宿理由（必填）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_check_out_date`(`check_out_date` ASC) USING BTREE,
  INDEX `idx_bed_id`(`bed_id` ASC) USING BTREE,
  INDEX `idx_approval_instance`(`approval_instance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_check_out
-- ----------------------------
INSERT INTO `sys_check_out` VALUES (1, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', 1, 4, NULL, NULL, NULL, NULL, '测试', NULL, '2026-01-25 16:55:07', 14, '2026-01-25 16:55:07', 14);

-- ----------------------------
-- Table structure for sys_class
-- ----------------------------
DROP TABLE IF EXISTS `sys_class`;
CREATE TABLE `sys_class`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `class_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班级编码',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班级名称',
  `major_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属专业编码',
  `grade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '年级',
  `teacher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人姓名（冗余字段）',
  `teacher_id` bigint NULL DEFAULT NULL COMMENT '负责人ID（关联sys_user）',
  `enrollment_year` int NOT NULL COMMENT '入学年份',
  `current_count` int NOT NULL DEFAULT 0 COMMENT '当前人数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_class_code`(`class_code` ASC) USING BTREE,
  INDEX `idx_major_code`(`major_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_teacher_id`(`teacher_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '班级表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_class
-- ----------------------------
INSERT INTO `sys_class` VALUES (1, 'CS-SE202301', '2023级软件工程1班', 'CS-SE001', '2025', '测试用户', 2, 2025, 30, 1, '2025-12-31 12:51:17', NULL, '2026-01-06 16:00:34', 1);
INSERT INTO `sys_class` VALUES (2, 'CS-SE202302', '2023级AI算法1班', 'CS-SE001', '2025', '测试用户', 2, 2025, 15, 1, '2026-01-02 22:51:09', 1, '2026-01-06 16:00:34', 1);

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dept_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '院系编码',
  `dept_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '院系名称',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属校区编码',
  `leader` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '院系领导',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_code`(`dept_code` ASC) USING BTREE,
  INDEX `idx_campus_code`(`campus_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '院系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_department
-- ----------------------------
INSERT INTO `sys_department` VALUES (1, 'CS001', '计算机科学与技术学院', 'CAMPUS001', '李四', '010-12345678', 1, 1, '2025-12-31 12:51:11', NULL, '2026-01-21 16:54:33', 1);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典编码',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典标签',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典值',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'CSS类名',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认：1是 0否',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1正常 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dict_code`(`dict_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_sort`(`sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 319 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 'sys_user_sex', '男', '1', '', 'primary', 1, 0, 1, '男性', '2025-12-31 14:42:00', NULL, '2026-01-01 13:56:47', NULL);
INSERT INTO `sys_dict_data` VALUES (2, 'sys_user_sex', '女', '2', NULL, 'success', 2, 0, 1, '女性', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_data` VALUES (3, 'sys_user_status', '正常', '1', NULL, 'success', 1, 1, 1, '正常状态', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_data` VALUES (4, 'sys_user_status', '停用', '0', NULL, 'danger', 2, 0, 1, '停用状态', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_data` VALUES (5, 'sys_switch', '开启', '1', NULL, 'success', 1, 0, 1, '开启状态', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_data` VALUES (6, 'sys_switch', '关闭', '0', NULL, 'info', 2, 0, 1, '关闭状态', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_data` VALUES (10, 'table_button_config', '新增', 'add', 'bg-theme/12 text-theme', NULL, 1, 0, 1, 'ri:add-fill', '2026-01-01 07:00:56', NULL, '2026-01-01 07:00:56', NULL);
INSERT INTO `sys_dict_data` VALUES (11, 'table_button_config', '编辑', 'edit', 'bg-secondary/12 text-secondary', '', 2, 0, 1, 'ri:pencil-line', '2026-01-01 07:00:56', NULL, '2026-01-01 15:12:49', NULL);
INSERT INTO `sys_dict_data` VALUES (12, 'table_button_config', '删除', 'delete', 'bg-error/12 text-error', NULL, 3, 0, 1, 'ri:delete-bin-5-line', '2026-01-01 07:00:56', NULL, '2026-01-01 07:00:56', NULL);
INSERT INTO `sys_dict_data` VALUES (13, 'table_button_config', '查看', 'view', 'bg-info/12 text-info', NULL, 4, 0, 1, 'ri:eye-line', '2026-01-01 07:00:56', NULL, '2026-01-01 07:00:56', NULL);
INSERT INTO `sys_dict_data` VALUES (14, 'table_button_config', '更多', 'more', '', NULL, 5, 0, 1, 'ri:more-2-fill', '2026-01-01 07:00:56', NULL, '2026-01-01 07:00:56', NULL);
INSERT INTO `sys_dict_data` VALUES (20, 'table_button_config', '分配', 'share', 'bg-info/12 text-info', '', 6, 0, 1, 'ri:share-line', '2026-01-01 15:10:14', NULL, '2026-01-01 15:11:15', NULL);
INSERT INTO `sys_dict_data` VALUES (21, 'table_button_config', '重置', 'reset', 'bg-secondary/12 text-secondary', '', 7, 0, 1, 'ri:shield-keyhole-line', '2026-01-01 15:12:38', NULL, '2026-01-01 15:12:52', NULL);
INSERT INTO `sys_dict_data` VALUES (22, 'degree_type', '专科', 'associate', '', NULL, 1, 0, 1, '专科', '2026-01-01 17:31:03', NULL, '2026-01-01 17:31:03', NULL);
INSERT INTO `sys_dict_data` VALUES (23, 'degree_type', '本科', 'bachelor', '', NULL, 2, 1, 1, '本科', '2026-01-01 17:31:03', NULL, '2026-01-01 17:31:03', NULL);
INSERT INTO `sys_dict_data` VALUES (24, 'degree_type', '研究生', 'graduate', '', NULL, 3, 0, 1, '研究生（包括硕士和博士）', '2026-01-01 17:31:03', NULL, '2026-01-01 17:31:03', NULL);
INSERT INTO `sys_dict_data` VALUES (25, 'sys_oper_business_type', '其它', '0', '', 'info', 1, 0, 1, '其它操作', '2026-01-01 20:40:03', NULL, '2026-01-01 20:40:03', NULL);
INSERT INTO `sys_dict_data` VALUES (26, 'sys_oper_business_type', '新增', '1', '', 'success', 2, 0, 1, '新增操作', '2026-01-01 20:40:03', NULL, '2026-01-01 20:40:03', NULL);
INSERT INTO `sys_dict_data` VALUES (27, 'sys_oper_business_type', '修改', '2', '', 'warning', 3, 0, 1, '修改操作', '2026-01-01 20:40:03', NULL, '2026-01-01 20:40:03', NULL);
INSERT INTO `sys_dict_data` VALUES (28, 'sys_oper_business_type', '删除', '3', '', 'danger', 4, 0, 1, '删除操作', '2026-01-01 20:40:03', NULL, '2026-01-01 20:40:03', NULL);
INSERT INTO `sys_dict_data` VALUES (29, 'sys_device_type', '桌面设备', '1', '', 'primary', 1, 1, 1, '桌面设备（PC、笔记本等）', '2026-01-01 20:40:14', NULL, '2026-01-01 20:40:14', NULL);
INSERT INTO `sys_dict_data` VALUES (30, 'sys_device_type', '移动设备', '2', '', 'success', 2, 0, 1, '移动设备（手机、平板等）', '2026-01-01 20:40:14', NULL, '2026-01-01 20:40:14', NULL);
INSERT INTO `sys_dict_data` VALUES (31, 'sys_device_type', '爬虫/Bot', '3', '', 'info', 3, 0, 1, '爬虫/Bot（搜索引擎、API调用等）', '2026-01-01 20:40:14', NULL, '2026-01-01 20:40:14', NULL);
INSERT INTO `sys_dict_data` VALUES (32, 'sys_user_online_status', '在线', '1', NULL, 'success', 1, 0, 1, NULL, '2026-01-02 07:38:42', NULL, '2026-01-02 07:38:42', NULL);
INSERT INTO `sys_dict_data` VALUES (33, 'sys_user_online_status', '离线', '0', NULL, 'info', 2, 0, 1, NULL, '2026-01-02 07:38:42', NULL, '2026-01-02 07:38:42', NULL);
INSERT INTO `sys_dict_data` VALUES (34, 'dormitory_room_type', '标准间', 'standard', NULL, 'primary', 1, 1, 1, '标准4人间', '2026-01-03 22:12:11', NULL, '2026-01-03 22:12:11', NULL);
INSERT INTO `sys_dict_data` VALUES (35, 'dormitory_room_type', '套间', 'suite', NULL, 'success', 2, 0, 1, '套间', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (36, 'dormitory_room_type', '单人间', 'single', NULL, 'info', 3, 0, 1, '单人间', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (37, 'dormitory_room_type', '双人间', 'double', NULL, 'warning', 4, 0, 1, '双人间', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (38, 'dormitory_bed_position', '上铺', 'upper', NULL, 'primary', 1, 1, 1, '上铺', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (39, 'dormitory_bed_position', '下铺', 'lower', NULL, 'success', 2, 0, 1, '下铺', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (40, 'dormitory_bed_position', '左侧', 'left', NULL, 'info', 3, 0, 1, '左侧床位', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (41, 'dormitory_bed_position', '右侧', 'right', NULL, 'warning', 4, 0, 1, '右侧床位', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_data` VALUES (42, 'dormitory_room_status', '空闲', '1', NULL, 'success', 1, 1, 1, '房间空闲', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (43, 'dormitory_room_status', '已满', '2', NULL, 'danger', 2, 0, 1, '房间已满', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (44, 'dormitory_room_status', '维修中', '3', NULL, 'warning', 3, 0, 1, '房间维修中', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (45, 'dormitory_room_status', '已预订', '4', NULL, 'info', 4, 0, 1, '房间已预订', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (46, 'dormitory_bed_status', '空闲', '1', NULL, 'success', 1, 1, 1, '床位空闲', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (47, 'dormitory_bed_status', '已占用', '2', NULL, 'danger', 2, 0, 1, '床位已占用', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (48, 'dormitory_bed_status', '维修中', '3', NULL, 'warning', 3, 0, 1, '床位维修中', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (49, 'dormitory_bed_status', '已预订', '4', NULL, 'info', 4, 0, 1, '床位已预订', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_data` VALUES (50, 'dormitory_room_facility', '空调', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-05 02:33:58', NULL, '2026-01-05 02:33:58', NULL);
INSERT INTO `sys_dict_data` VALUES (51, 'dormitory_room_facility', '独立卫生间', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-05 02:33:58', NULL, '2026-01-05 02:33:58', NULL);
INSERT INTO `sys_dict_data` VALUES (52, 'dormitory_room_facility', '阳台', '3', NULL, NULL, 3, 0, 1, NULL, '2026-01-05 02:33:58', NULL, '2026-01-05 02:33:58', NULL);
INSERT INTO `sys_dict_data` VALUES (53, 'dormitory_gender_type', '男生宿舍', '1', NULL, 'primary', 1, 0, 1, '男生宿舍', '2026-01-05 17:50:30', NULL, '2026-01-05 17:50:30', NULL);
INSERT INTO `sys_dict_data` VALUES (54, 'dormitory_gender_type', '女生宿舍', '2', NULL, 'success', 2, 0, 1, '女生宿舍', '2026-01-05 17:50:31', NULL, '2026-01-05 17:50:31', NULL);
INSERT INTO `sys_dict_data` VALUES (55, 'dormitory_gender_type', '混合宿舍', '3', NULL, 'info', 3, 1, 1, '混合宿舍', '2026-01-05 17:50:31', NULL, '2026-01-05 17:50:31', NULL);
INSERT INTO `sys_dict_data` VALUES (56, 'academic_status', '在读', '1', '', 'success', 1, 1, 1, '在读状态', '2026-01-06 09:51:20', NULL, '2026-01-06 09:51:20', NULL);
INSERT INTO `sys_dict_data` VALUES (57, 'academic_status', '休学', '2', '', 'warning', 2, 0, 1, '休学状态', '2026-01-06 09:51:21', NULL, '2026-01-06 09:51:21', NULL);
INSERT INTO `sys_dict_data` VALUES (58, 'academic_status', '毕业', '3', '', 'info', 3, 0, 1, '毕业状态', '2026-01-06 09:51:22', NULL, '2026-01-06 09:51:22', NULL);
INSERT INTO `sys_dict_data` VALUES (59, 'academic_status', '退学', '4', '', 'danger', 4, 0, 1, '退学状态', '2026-01-06 09:51:23', NULL, '2026-01-06 09:51:23', NULL);
INSERT INTO `sys_dict_data` VALUES (60, 'check_in_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', '2026-01-06 09:51:24', NULL, '2026-01-06 09:51:24', NULL);
INSERT INTO `sys_dict_data` VALUES (61, 'check_in_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', '2026-01-06 09:51:25', NULL, '2026-01-06 09:51:25', NULL);
INSERT INTO `sys_dict_data` VALUES (62, 'check_in_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', '2026-01-06 09:51:31', NULL, '2026-01-06 09:51:31', NULL);
INSERT INTO `sys_dict_data` VALUES (63, 'check_in_status', '已入住', '4', '', 'success', 4, 1, 1, '已入住状态', '2026-01-06 09:51:32', NULL, '2026-01-06 09:51:32', NULL);
INSERT INTO `sys_dict_data` VALUES (64, 'transfer_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', '2026-01-06 09:51:33', NULL, '2026-01-06 09:51:33', NULL);
INSERT INTO `sys_dict_data` VALUES (65, 'transfer_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', '2026-01-06 09:51:34', NULL, '2026-01-06 09:51:34', NULL);
INSERT INTO `sys_dict_data` VALUES (66, 'transfer_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', '2026-01-06 09:51:36', NULL, '2026-01-06 09:51:36', NULL);
INSERT INTO `sys_dict_data` VALUES (67, 'transfer_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', '2026-01-06 09:51:37', NULL, '2026-01-06 09:51:37', NULL);
INSERT INTO `sys_dict_data` VALUES (68, 'check_out_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', '2026-01-06 09:51:38', NULL, '2026-01-06 09:51:38', NULL);
INSERT INTO `sys_dict_data` VALUES (69, 'check_out_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', '2026-01-06 09:51:39', NULL, '2026-01-06 09:51:39', NULL);
INSERT INTO `sys_dict_data` VALUES (70, 'check_out_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', '2026-01-06 09:51:40', NULL, '2026-01-06 09:51:40', NULL);
INSERT INTO `sys_dict_data` VALUES (71, 'check_out_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', '2026-01-06 09:51:41', NULL, '2026-01-06 09:51:41', NULL);
INSERT INTO `sys_dict_data` VALUES (72, 'stay_status', '待审核', '1', '', 'warning', 1, 0, 1, '待审核状态', '2026-01-06 09:51:42', NULL, '2026-01-06 09:51:42', NULL);
INSERT INTO `sys_dict_data` VALUES (73, 'stay_status', '已通过', '2', '', 'success', 2, 0, 1, '已通过状态', '2026-01-06 09:51:43', NULL, '2026-01-06 09:51:43', NULL);
INSERT INTO `sys_dict_data` VALUES (74, 'stay_status', '已拒绝', '3', '', 'danger', 3, 0, 1, '已拒绝状态', '2026-01-06 09:51:44', NULL, '2026-01-06 09:51:44', NULL);
INSERT INTO `sys_dict_data` VALUES (75, 'stay_status', '已完成', '4', '', 'success', 4, 1, 1, '已完成状态', '2026-01-06 09:51:45', NULL, '2026-01-06 09:51:45', NULL);
INSERT INTO `sys_dict_data` VALUES (76, 'student_smoking_status', '不吸烟', '0', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:17', NULL, '2026-01-10 19:50:17', NULL);
INSERT INTO `sys_dict_data` VALUES (77, 'student_smoking_status', '吸烟', '1', '', 'warning', 2, 0, 1, '', '2026-01-10 19:50:17', NULL, '2026-01-10 19:50:17', NULL);
INSERT INTO `sys_dict_data` VALUES (78, 'student_smoking_tolerance', '不接受', '0', '', 'info', 1, 1, 1, '', '2026-01-10 19:50:17', NULL, '2026-01-10 19:50:17', NULL);
INSERT INTO `sys_dict_data` VALUES (79, 'student_smoking_tolerance', '接受', '1', '', 'success', 2, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (80, 'student_sleep_schedule', '早睡早起(22:00-6:00)', '0', '', '', 1, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (81, 'student_sleep_schedule', '正常(23:00-7:00)', '1', '', '', 2, 1, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (82, 'student_sleep_schedule', '晚睡晚起(24:00-8:00)', '2', '', '', 3, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (83, 'student_sleep_schedule', '夜猫子(01:00-9:00)', '3', '', '', 4, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (84, 'student_sleep_quality', '浅睡易醒', '0', '', 'warning', 1, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (85, 'student_sleep_quality', '正常', '1', '', 'success', 2, 1, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (86, 'student_sleep_quality', '深睡', '2', '', 'success', 3, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (87, 'student_snores', '不打呼噜', '0', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (88, 'student_snores', '打呼噜', '1', '', 'warning', 2, 0, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (89, 'student_sensitive_to_light', '不敏感', '0', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_data` VALUES (90, 'student_sensitive_to_light', '敏感', '1', '', 'warning', 2, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (91, 'student_sensitive_to_sound', '不敏感', '0', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (92, 'student_sensitive_to_sound', '敏感', '1', '', 'warning', 2, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (93, 'student_cleanliness_level', '非常整洁', '1', '', 'success', 1, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (94, 'student_cleanliness_level', '整洁', '2', '', 'success', 2, 1, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (95, 'student_cleanliness_level', '一般', '3', '', 'info', 3, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (96, 'student_cleanliness_level', '随意', '4', '', 'warning', 4, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (97, 'student_cleanliness_level', '不整洁', '5', '', 'danger', 5, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (98, 'student_bedtime_cleanup', '不整理', '0', '', 'info', 1, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (99, 'student_bedtime_cleanup', '偶尔整理', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (100, 'student_bedtime_cleanup', '经常整理', '2', '', 'success', 3, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (101, 'student_bedtime_cleanup', '总是整理', '3', '', 'success', 4, 0, 1, '', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_data` VALUES (102, 'student_social_preference', '喜欢安静', '1', '', 'info', 1, 1, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (103, 'student_social_preference', '中等', '2', '', 'success', 2, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (104, 'student_social_preference', '喜欢热闹', '3', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (105, 'student_allow_visitors', '不允许', '0', '', 'info', 1, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (106, 'student_allow_visitors', '偶尔可以', '1', '', 'warning', 2, 1, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (107, 'student_allow_visitors', '可以', '2', '', 'success', 3, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (108, 'student_phone_call_time', '喜欢在宿舍打电话', '0', '', 'warning', 1, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (109, 'student_phone_call_time', '偶尔在宿舍', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (110, 'student_phone_call_time', '不在宿舍打电话', '2', '', 'success', 3, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (111, 'student_study_in_room', '不在', '0', '', 'info', 1, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (112, 'student_study_in_room', '偶尔', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (113, 'student_study_in_room', '经常', '2', '', 'success', 3, 0, 1, '', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_data` VALUES (114, 'student_study_in_room', '总是', '3', '', 'success', 4, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (115, 'student_study_environment', '需要安静', '1', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (116, 'student_study_environment', '需要轻音乐', '2', '', 'info', 2, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (117, 'student_study_environment', '可以接受声音', '3', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (118, 'student_computer_usage_time', '不用', '0', '', 'info', 1, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (119, 'student_computer_usage_time', '很少(1-2h/天)', '1', '', 'success', 2, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (120, 'student_computer_usage_time', '正常(3-5h/天)', '2', '', 'success', 3, 1, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (121, 'student_computer_usage_time', '很多(6h+/天)', '3', '', 'warning', 4, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (122, 'student_gaming_preference', '不玩游戏', '0', '', 'success', 1, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (123, 'student_gaming_preference', '偶尔玩', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (124, 'student_gaming_preference', '经常玩', '2', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (125, 'student_music_preference', '不听', '0', '', 'info', 1, 0, 1, '', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_data` VALUES (126, 'student_music_preference', '偶尔听', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (127, 'student_music_preference', '经常听', '2', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (128, 'student_music_volume', '喜欢小声', '1', '', 'success', 1, 1, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (129, 'student_music_volume', '中等', '2', '', 'info', 2, 0, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (130, 'student_music_volume', '喜欢大声', '3', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (131, 'student_eat_in_room', '不吃', '0', '', 'success', 1, 0, 1, '', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_data` VALUES (132, 'student_eat_in_room', '偶尔', '1', '', 'info', 2, 1, 1, '', '2026-01-10 19:50:24', NULL, '2026-01-10 19:50:24', NULL);
INSERT INTO `sys_dict_data` VALUES (133, 'student_eat_in_room', '经常', '2', '', 'warning', 3, 0, 1, '', '2026-01-10 19:50:24', NULL, '2026-01-10 19:50:24', NULL);
INSERT INTO `sys_dict_data` VALUES (134, 'student_nation', '汉族', '汉族', '', 'info', 1, 1, 1, '', '2026-01-10 21:57:38', NULL, '2026-01-10 21:57:38', NULL);
INSERT INTO `sys_dict_data` VALUES (135, 'student_nation', '蒙古族', '蒙古族', '', 'info', 2, 0, 1, '', '2026-01-10 21:57:38', NULL, '2026-01-10 21:57:38', NULL);
INSERT INTO `sys_dict_data` VALUES (136, 'student_nation', '回族', '回族', '', 'info', 3, 0, 1, '', '2026-01-10 21:57:38', NULL, '2026-01-10 21:57:38', NULL);
INSERT INTO `sys_dict_data` VALUES (137, 'student_nation', '藏族', '藏族', '', 'info', 4, 0, 1, '', '2026-01-10 21:57:38', NULL, '2026-01-10 21:57:38', NULL);
INSERT INTO `sys_dict_data` VALUES (138, 'student_nation', '维吾尔族', '维吾尔族', '', 'info', 5, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (139, 'student_nation', '苗族', '苗族', '', 'info', 6, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (140, 'student_nation', '彝族', '彝族', '', 'info', 7, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (141, 'student_nation', '壮族', '壮族', '', 'info', 8, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (142, 'student_nation', '布依族', '布依族', '', 'info', 9, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (143, 'student_nation', '朝鲜族', '朝鲜族', '', 'info', 10, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (144, 'student_nation', '满族', '满族', '', 'info', 11, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (145, 'student_nation', '侗族', '侗族', '', 'info', 12, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (146, 'student_nation', '瑶族', '瑶族', '', 'info', 13, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (147, 'student_nation', '白族', '白族', '', 'info', 14, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (148, 'student_nation', '土家族', '土家族', '', 'info', 15, 0, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (149, 'student_political_status', '群众', '群众', '', 'info', 1, 1, 1, '', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_data` VALUES (150, 'student_political_status', '共青团员', '共青团员', '', 'success', 2, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (151, 'student_political_status', '中共党员', '中共党员', '', 'warning', 3, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (152, 'student_political_status', '中共预备党员', '中共预备党员', '', 'warning', 4, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (153, 'student_political_status', '民革党员', '民革党员', '', 'info', 5, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (154, 'student_political_status', '民盟盟员', '民盟盟员', '', 'info', 6, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (155, 'student_political_status', '民建会员', '民建会员', '', 'info', 7, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (156, 'student_political_status', '民进会员', '民进会员', '', 'info', 8, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (157, 'student_political_status', '农工党党员', '农工党党员', '', 'info', 9, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (158, 'student_political_status', '致公党党员', '致公党党员', '', 'info', 10, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (159, 'student_political_status', '九三学社社员', '九三学社社员', '', 'info', 11, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (160, 'student_political_status', '台盟盟员', '台盟盟员', '', 'info', 12, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (161, 'student_political_status', '无党派人士', '无党派人士', '', 'info', 13, 0, 1, '', '2026-01-10 21:57:40', NULL, '2026-01-10 21:57:40', NULL);
INSERT INTO `sys_dict_data` VALUES (162, 'student_nation', '哈尼族', '哈尼族', '', 'info', 16, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (163, 'student_nation', '哈萨克族', '哈萨克族', '', 'info', 17, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (164, 'student_nation', '傣族', '傣族', '', 'info', 18, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (165, 'student_nation', '黎族', '黎族', '', 'info', 19, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (166, 'student_nation', '傈僳族', '傈僳族', '', 'info', 20, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (167, 'student_nation', '佤族', '佤族', '', 'info', 21, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (168, 'student_nation', '畲族', '畲族', '', 'info', 22, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (169, 'student_nation', '高山族', '高山族', '', 'info', 23, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (170, 'student_nation', '拉祜族', '拉祜族', '', 'info', 24, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (171, 'student_nation', '水族', '水族', '', 'info', 25, 0, 1, '', '2026-01-10 22:06:41', NULL, '2026-01-10 22:06:41', NULL);
INSERT INTO `sys_dict_data` VALUES (172, 'student_nation', '东乡族', '东乡族', '', 'info', 26, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (173, 'student_nation', '纳西族', '纳西族', '', 'info', 27, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (174, 'student_nation', '景颇族', '景颇族', '', 'info', 28, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (175, 'student_nation', '柯尔克孜族', '柯尔克孜族', '', 'info', 29, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (176, 'student_nation', '土族', '土族', '', 'info', 30, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (177, 'student_nation', '达斡尔族', '达斡尔族', '', 'info', 31, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (178, 'student_nation', '仫佬族', '仫佬族', '', 'info', 32, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (179, 'student_nation', '羌族', '羌族', '', 'info', 33, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (180, 'student_nation', '布朗族', '布朗族', '', 'info', 34, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (181, 'student_nation', '撒拉族', '撒拉族', '', 'info', 35, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (182, 'student_nation', '毛南族', '毛南族', '', 'info', 36, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (183, 'student_nation', '仡佬族', '仡佬族', '', 'info', 37, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (184, 'student_nation', '锡伯族', '锡伯族', '', 'info', 38, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (185, 'student_nation', '阿昌族', '阿昌族', '', 'info', 39, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (186, 'student_nation', '普米族', '普米族', '', 'info', 40, 0, 1, '', '2026-01-10 22:06:42', NULL, '2026-01-10 22:06:42', NULL);
INSERT INTO `sys_dict_data` VALUES (187, 'student_nation', '塔吉克族', '塔吉克族', '', 'info', 41, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (188, 'student_nation', '怒族', '怒族', '', 'info', 42, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (189, 'student_nation', '乌孜别克族', '乌孜别克族', '', 'info', 43, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (190, 'student_nation', '俄罗斯族', '俄罗斯族', '', 'info', 44, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (191, 'student_nation', '鄂温克族', '鄂温克族', '', 'info', 45, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (192, 'student_nation', '德昂族', '德昂族', '', 'info', 46, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (193, 'student_nation', '保安族', '保安族', '', 'info', 47, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (194, 'student_nation', '裕固族', '裕固族', '', 'info', 48, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (195, 'student_nation', '京族', '京族', '', 'info', 49, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (196, 'student_nation', '塔塔尔族', '塔塔尔族', '', 'info', 50, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (197, 'student_nation', '独龙族', '独龙族', '', 'info', 51, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (198, 'student_nation', '鄂伦春族', '鄂伦春族', '', 'info', 52, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (199, 'student_nation', '赫哲族', '赫哲族', '', 'info', 53, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (200, 'student_nation', '门巴族', '门巴族', '', 'info', 54, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (201, 'student_nation', '珞巴族', '珞巴族', '', 'info', 55, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (202, 'student_nation', '基诺族', '基诺族', '', 'info', 56, 0, 1, '', '2026-01-10 22:06:43', NULL, '2026-01-10 22:06:43', NULL);
INSERT INTO `sys_dict_data` VALUES (203, 'check_in_status', '已撤回', '5', NULL, NULL, 5, 0, 1, NULL, '2026-01-16 12:19:02', NULL, '2026-01-16 12:19:02', NULL);
INSERT INTO `sys_dict_data` VALUES (204, 'check_out_status', '已撤回', '5', NULL, NULL, 5, 0, 1, NULL, '2026-01-16 12:19:02', NULL, '2026-01-16 12:19:02', NULL);
INSERT INTO `sys_dict_data` VALUES (205, 'transfer_status', '已撤回', '5', NULL, NULL, 5, 0, 1, NULL, '2026-01-16 12:19:02', NULL, '2026-01-16 12:19:02', NULL);
INSERT INTO `sys_dict_data` VALUES (206, 'stay_status', '已撤回', '5', NULL, NULL, 5, 0, 1, NULL, '2026-01-16 12:19:02', NULL, '2026-01-16 12:19:02', NULL);
INSERT INTO `sys_dict_data` VALUES (207, 'business_type', '入住申请', 'check_in', '', '', 1, 0, 1, '', '2026-01-17 21:40:54', NULL, '2026-01-21 16:51:23', 1);
INSERT INTO `sys_dict_data` VALUES (208, 'business_type', '调宿申请', 'transfer', NULL, NULL, 2, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (209, 'business_type', '退宿申请', 'check_out', NULL, NULL, 3, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (210, 'business_type', '留宿申请', 'stay', NULL, NULL, 4, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (211, 'table_button_config', '绑定', 'link', 'bg-info/12 text-info', '', 8, 0, 1, 'ri:link', '2026-01-21 19:25:35', 1, '2026-01-21 20:10:31', 1);
INSERT INTO `sys_dict_data` VALUES (212, 'check_in_type', '长期住宿', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:05', NULL, '2026-01-28 19:39:05', NULL);
INSERT INTO `sys_dict_data` VALUES (213, 'check_in_type', '临时住宿', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:05', NULL, '2026-01-28 19:39:05', NULL);
INSERT INTO `sys_dict_data` VALUES (214, 'approval_business_type', '入住申请', 'check_in', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:07', NULL, '2026-01-28 19:39:07', NULL);
INSERT INTO `sys_dict_data` VALUES (215, 'approval_business_type', '调宿申请', 'transfer', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:07', NULL, '2026-01-28 19:39:07', NULL);
INSERT INTO `sys_dict_data` VALUES (216, 'approval_business_type', '退宿申请', 'check_out', NULL, NULL, 3, 0, 1, NULL, '2026-01-28 19:39:07', NULL, '2026-01-28 19:39:07', NULL);
INSERT INTO `sys_dict_data` VALUES (217, 'approval_business_type', '留宿申请', 'stay', NULL, NULL, 4, 0, 1, NULL, '2026-01-28 19:39:07', NULL, '2026-01-28 19:39:07', NULL);
INSERT INTO `sys_dict_data` VALUES (218, 'approval_action', '通过', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:09', NULL, '2026-01-28 19:39:09', NULL);
INSERT INTO `sys_dict_data` VALUES (219, 'approval_action', '拒绝', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:09', NULL, '2026-01-28 19:39:09', NULL);
INSERT INTO `sys_dict_data` VALUES (220, 'approval_node_type', '串行', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:10', NULL, '2026-01-28 19:39:10', NULL);
INSERT INTO `sys_dict_data` VALUES (221, 'approval_node_type', '会签', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:10', NULL, '2026-01-28 19:39:10', NULL);
INSERT INTO `sys_dict_data` VALUES (222, 'approval_node_type', '或签', '3', NULL, NULL, 3, 0, 1, NULL, '2026-01-28 19:39:10', NULL, '2026-01-28 19:39:10', NULL);
INSERT INTO `sys_dict_data` VALUES (223, 'approval_reject_action', '直接结束', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:11', NULL, '2026-01-28 19:39:11', NULL);
INSERT INTO `sys_dict_data` VALUES (224, 'approval_reject_action', '退回申请人', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:11', NULL, '2026-01-28 19:39:11', NULL);
INSERT INTO `sys_dict_data` VALUES (225, 'approval_reject_action', '退回上一节点', '3', NULL, NULL, 3, 0, 1, NULL, '2026-01-28 19:39:11', NULL, '2026-01-28 19:39:11', NULL);
INSERT INTO `sys_dict_data` VALUES (226, 'approval_instance_status', '进行中', '1', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:13', NULL, '2026-01-28 19:39:13', NULL);
INSERT INTO `sys_dict_data` VALUES (227, 'approval_instance_status', '已通过', '2', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:13', NULL, '2026-01-28 19:39:13', NULL);
INSERT INTO `sys_dict_data` VALUES (228, 'approval_instance_status', '已拒绝', '3', NULL, NULL, 3, 0, 1, NULL, '2026-01-28 19:39:13', NULL, '2026-01-28 19:39:13', NULL);
INSERT INTO `sys_dict_data` VALUES (229, 'approval_instance_status', '已撤回', '4', NULL, NULL, 4, 0, 1, NULL, '2026-01-28 19:39:13', NULL, '2026-01-28 19:39:13', NULL);
INSERT INTO `sys_dict_data` VALUES (230, 'parent_agree_status', '同意', 'agree', NULL, NULL, 1, 0, 1, NULL, '2026-01-28 19:39:14', NULL, '2026-01-28 19:39:14', NULL);
INSERT INTO `sys_dict_data` VALUES (231, 'parent_agree_status', '不同意', 'disagree', NULL, NULL, 2, 0, 1, NULL, '2026-01-28 19:39:14', NULL, '2026-01-28 19:39:14', NULL);
INSERT INTO `sys_dict_data` VALUES (232, 'parent_agree_status', '未填写', '', NULL, NULL, 3, 0, 1, NULL, '2026-01-28 19:39:14', NULL, '2026-01-28 19:39:14', NULL);
INSERT INTO `sys_dict_data` VALUES (258, 'notice_type', '系统通知', '1', NULL, NULL, 1, 0, 1, '系统通知类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (259, 'notice_type', '宿舍公告', '2', NULL, NULL, 2, 0, 1, '宿舍公告类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (260, 'notice_type', '安全提醒', '3', NULL, NULL, 3, 0, 1, '安全提醒类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (261, 'notice_type', '停水停电', '4', NULL, NULL, 4, 0, 1, '停水停电类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (262, 'notice_type', '其他', '99', NULL, NULL, 99, 0, 1, '其他类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (263, 'notice_status', '草稿', '0', NULL, NULL, 0, 0, 1, '草稿状态', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (264, 'notice_status', '已发布', '1', NULL, NULL, 1, 0, 1, '已发布状态', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_data` VALUES (301, 'repair_type', '水电', '1', NULL, NULL, 1, 0, 1, '水管、电路等问题', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (302, 'repair_type', '门窗', '2', NULL, NULL, 2, 0, 1, '门锁、窗户等问题', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (303, 'repair_type', '家具', '3', NULL, NULL, 3, 0, 1, '床、桌椅等问题', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (304, 'repair_type', '网络', '4', NULL, NULL, 4, 0, 1, '网络连接问题', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (305, 'repair_type', '其他', '5', NULL, NULL, 5, 0, 1, '其他类型问题', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (306, 'repair_status', '待接单', '1', NULL, NULL, 1, 0, 1, '报修已提交，等待维修人员接单', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (307, 'repair_status', '已接单', '2', NULL, NULL, 2, 0, 1, '维修人员已接单', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (308, 'repair_status', '维修中', '3', NULL, NULL, 3, 0, 1, '维修人员正在维修', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (309, 'repair_status', '已完成', '4', NULL, NULL, 4, 0, 1, '维修已完成', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (310, 'repair_status', '已取消', '5', NULL, NULL, 5, 0, 1, '报修已取消', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (311, 'repair_urgent_level', '一般', '1', NULL, NULL, 1, 0, 1, '一般问题，可等待处理', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (312, 'repair_urgent_level', '紧急', '2', NULL, NULL, 2, 0, 1, '紧急问题，需要尽快处理', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (313, 'repair_urgent_level', '非常紧急', '3', NULL, NULL, 3, 0, 1, '非常紧急，需要立即处理', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (314, 'repair_rating', '1星', '1', NULL, NULL, 1, 0, 1, '非常不满意', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (315, 'repair_rating', '2星', '2', NULL, NULL, 2, 0, 1, '不满意', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (316, 'repair_rating', '3星', '3', NULL, NULL, 3, 0, 1, '一般', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (317, 'repair_rating', '4星', '4', NULL, NULL, 4, 0, 1, '满意', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_data` VALUES (318, 'repair_rating', '5星', '5', NULL, NULL, 5, 0, 1, '非常满意', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名称',
  `dict_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典编码',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1正常 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dict_code`(`dict_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', 1, '用户性别字典', '2025-12-31 14:42:00', NULL, '2025-12-31 20:37:55', NULL);
INSERT INTO `sys_dict_type` VALUES (2, '用户状态', 'sys_user_status', 1, '用户状态字典', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_switch', 1, '系统开关字典', '2025-12-31 14:42:00', NULL, '2025-12-31 14:42:00', NULL);
INSERT INTO `sys_dict_type` VALUES (5, '表格按钮配置', 'table_button_config', 1, '表格操作按钮配置，包含图标、文字、样式等信息', '2026-01-01 07:00:53', NULL, '2026-01-01 07:00:53', NULL);
INSERT INTO `sys_dict_type` VALUES (7, '学位类型', 'degree_type', 1, '学位类型：专科、本科、研究生', '2026-01-01 17:31:02', NULL, '2026-01-01 17:31:02', NULL);
INSERT INTO `sys_dict_type` VALUES (8, '操作日志业务类型', 'sys_oper_business_type', 1, '操作日志业务类型：0其它 1新增 2修改 3删除', '2026-01-01 20:40:02', NULL, '2026-01-01 20:40:02', NULL);
INSERT INTO `sys_dict_type` VALUES (9, '设备类型', 'sys_device_type', 1, '设备类型：1桌面设备 2移动设备 3爬虫/Bot', '2026-01-01 20:40:14', NULL, '2026-01-01 20:40:14', NULL);
INSERT INTO `sys_dict_type` VALUES (10, '用户在线状态', 'sys_user_online_status', 1, '用户在线状态字典', '2026-01-02 07:38:41', NULL, '2026-01-02 07:38:41', NULL);
INSERT INTO `sys_dict_type` VALUES (11, '房间类型', 'dormitory_room_type', 1, '宿舍房间类型：标准间、套间、单人间等', '2026-01-03 22:12:11', NULL, '2026-01-03 22:12:11', NULL);
INSERT INTO `sys_dict_type` VALUES (12, '床位位置', 'dormitory_bed_position', 1, '床位位置：上铺、下铺、左、右等', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_type` VALUES (13, '房间状态', 'dormitory_room_status', 1, '房间状态：空闲、已满、维修中、已预订', '2026-01-03 22:12:12', NULL, '2026-01-03 22:12:12', NULL);
INSERT INTO `sys_dict_type` VALUES (14, '床位状态', 'dormitory_bed_status', 1, '床位状态：空闲、已占用、维修中、已预订', '2026-01-03 22:12:13', NULL, '2026-01-03 22:12:13', NULL);
INSERT INTO `sys_dict_type` VALUES (15, '房间设施', 'dormitory_room_facility', 1, '房间设施：空调、独立卫生间、阳台等', '2026-01-05 02:33:46', NULL, '2026-01-05 20:14:34', 1);
INSERT INTO `sys_dict_type` VALUES (16, '楼层适用性别', 'dormitory_gender_type', 1, '楼层适用性别：男生宿舍、女生宿舍、混合宿舍', '2026-01-05 17:50:30', NULL, '2026-01-05 17:50:30', NULL);
INSERT INTO `sys_dict_type` VALUES (17, '学籍状态', 'academic_status', 1, '学籍状态：1在读 2休学 3毕业 4退学', '2026-01-06 09:51:14', NULL, '2026-01-06 09:51:14', NULL);
INSERT INTO `sys_dict_type` VALUES (18, '入住状态', 'check_in_status', 1, '入住状态：1待审核 2已通过 3已拒绝 4已入住', '2026-01-06 09:51:15', NULL, '2026-01-06 09:51:15', NULL);
INSERT INTO `sys_dict_type` VALUES (19, '调宿状态', 'transfer_status', 1, '调宿状态：1待审核 2已通过 3已拒绝 4已完成', '2026-01-06 09:51:16', NULL, '2026-01-06 09:51:16', NULL);
INSERT INTO `sys_dict_type` VALUES (20, '退宿状态', 'check_out_status', 1, '退宿状态：1待审核 2已通过 3已拒绝 4已完成', '2026-01-06 09:51:18', NULL, '2026-01-06 09:51:18', NULL);
INSERT INTO `sys_dict_type` VALUES (21, '留宿状态', 'stay_status', 1, '留宿状态：1待审核 2已通过 3已拒绝 4已完成', '2026-01-06 09:51:19', NULL, '2026-01-06 09:51:19', NULL);
INSERT INTO `sys_dict_type` VALUES (22, '吸烟状态', 'student_smoking_status', 1, '学生是否吸烟：0不吸烟 1吸烟', '2026-01-10 19:50:17', NULL, '2026-01-10 19:50:17', NULL);
INSERT INTO `sys_dict_type` VALUES (23, '是否接受室友吸烟', 'student_smoking_tolerance', 1, '是否接受室友吸烟：0不接受 1接受', '2026-01-10 19:50:17', NULL, '2026-01-10 19:50:17', NULL);
INSERT INTO `sys_dict_type` VALUES (24, '作息时间', 'student_sleep_schedule', 1, '作息时间：0早睡早起 1正常 2晚睡晚起 3夜猫子', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_type` VALUES (25, '睡眠质量', 'student_sleep_quality', 1, '睡眠质量：0浅睡易醒 1正常 2深睡', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_type` VALUES (26, '是否打呼噜', 'student_snores', 1, '是否打呼噜：0不打 1打', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_type` VALUES (27, '是否对光线敏感', 'student_sensitive_to_light', 1, '是否对光线敏感：0不敏感 1敏感', '2026-01-10 19:50:18', NULL, '2026-01-10 19:50:18', NULL);
INSERT INTO `sys_dict_type` VALUES (28, '是否对声音敏感', 'student_sensitive_to_sound', 1, '是否对声音敏感：0不敏感 1敏感', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_type` VALUES (29, '整洁程度', 'student_cleanliness_level', 1, '整洁程度：1非常整洁 2整洁 3一般 4随意 5不整洁', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_type` VALUES (30, '睡前是否整理', 'student_bedtime_cleanup', 1, '睡前是否整理：0不整理 1偶尔整理 2经常整理 3总是整理', '2026-01-10 19:50:19', NULL, '2026-01-10 19:50:19', NULL);
INSERT INTO `sys_dict_type` VALUES (31, '社交偏好', 'student_social_preference', 1, '社交偏好：1喜欢安静 2中等 3喜欢热闹', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_type` VALUES (32, '是否允许室友带访客', 'student_allow_visitors', 1, '是否允许室友带访客：0不允许 1偶尔可以 2可以', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_type` VALUES (33, '电话时间偏好', 'student_phone_call_time', 1, '电话时间偏好：0喜欢在宿舍打电话 1偶尔在宿舍 2不在宿舍打电话', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_type` VALUES (34, '是否在宿舍学习', 'student_study_in_room', 1, '是否在宿舍学习：0不在 1偶尔 2经常 3总是', '2026-01-10 19:50:20', NULL, '2026-01-10 19:50:20', NULL);
INSERT INTO `sys_dict_type` VALUES (35, '学习环境偏好', 'student_study_environment', 1, '学习环境偏好：1需要安静 2需要轻音乐 3可以接受声音', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_type` VALUES (36, '电脑使用时间', 'student_computer_usage_time', 1, '电脑使用时间：0不用 1很少 2正常 3很多', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_type` VALUES (37, '游戏偏好', 'student_gaming_preference', 1, '游戏偏好：0不玩游戏 1偶尔玩 2经常玩', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_type` VALUES (38, '听音乐偏好', 'student_music_preference', 1, '听音乐偏好：0不听 1偶尔听 2经常听', '2026-01-10 19:50:21', NULL, '2026-01-10 19:50:21', NULL);
INSERT INTO `sys_dict_type` VALUES (39, '音乐音量偏好', 'student_music_volume', 1, '音乐音量偏好：1喜欢小声 2中等 3喜欢大声', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_type` VALUES (40, '是否在宿舍吃东西', 'student_eat_in_room', 1, '是否在宿舍吃东西：0不吃 1偶尔 2经常', '2026-01-10 19:50:22', NULL, '2026-01-10 19:50:22', NULL);
INSERT INTO `sys_dict_type` VALUES (41, '民族', 'student_nation', 1, '学生民族：包含中国56个民族', '2026-01-10 21:57:37', NULL, '2026-01-10 21:57:37', NULL);
INSERT INTO `sys_dict_type` VALUES (42, '政治面貌', 'student_political_status', 1, '学生政治面貌：群众、共青团员、中共党员等', '2026-01-10 21:57:39', NULL, '2026-01-10 21:57:39', NULL);
INSERT INTO `sys_dict_type` VALUES (43, '审批业务类型', 'business_type', 1, '审批流程关联的业务类型', '2026-01-17 21:40:54', NULL, '2026-01-21 16:51:20', 1);
INSERT INTO `sys_dict_type` VALUES (44, '入住类型', 'check_in_type', 1, '入住申请的类型（长期/临时）', '2026-01-28 19:39:04', NULL, '2026-01-28 19:39:04', NULL);
INSERT INTO `sys_dict_type` VALUES (45, '审批业务类型', 'approval_business_type', 1, '审批流程关联的业务类型', '2026-01-28 19:39:06', NULL, '2026-01-28 19:39:06', NULL);
INSERT INTO `sys_dict_type` VALUES (46, '审批动作', 'approval_action', 1, '审批操作的动作类型（通过/拒绝）', '2026-01-28 19:39:08', NULL, '2026-01-28 19:39:08', NULL);
INSERT INTO `sys_dict_type` VALUES (47, '流程节点类型', 'approval_node_type', 1, '审批流程节点的类型（串行/会签/或签）', '2026-01-28 19:39:09', NULL, '2026-01-28 19:39:09', NULL);
INSERT INTO `sys_dict_type` VALUES (48, '拒绝处理方式', 'approval_reject_action', 1, '审批拒绝后的处理方式', '2026-01-28 19:39:11', NULL, '2026-01-28 19:39:11', NULL);
INSERT INTO `sys_dict_type` VALUES (49, '审批实例状态', 'approval_instance_status', 1, '审批流程实例的状态', '2026-01-28 19:39:12', NULL, '2026-01-28 19:39:12', NULL);
INSERT INTO `sys_dict_type` VALUES (50, '家长同意状态', 'parent_agree_status', 1, '留宿申请中家长是否同意', '2026-01-28 19:39:13', NULL, '2026-01-28 19:39:13', NULL);
INSERT INTO `sys_dict_type` VALUES (57, '通知类型', 'notice_type', 1, '通知公告的类型', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_type` VALUES (58, '通知状态', 'notice_status', 1, '通知公告的状态', '2026-01-29 16:46:29', NULL, '2026-01-29 16:46:29', NULL);
INSERT INTO `sys_dict_type` VALUES (68, '维修类型', 'repair_type', 1, '报修的维修类型', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_type` VALUES (69, '报修状态', 'repair_status', 1, '报修单的状态：1-待接单 2-已接单 3-维修中 4-已完成 5-已取消', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_type` VALUES (70, '紧急程度', 'repair_urgent_level', 1, '报修的紧急程度：1-一般 2-紧急 3-非常紧急', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);
INSERT INTO `sys_dict_type` VALUES (71, '维修评分', 'repair_rating', 1, '报修完成后的评分：1-5星', '2026-01-29 19:33:18', NULL, '2026-01-29 19:33:18', NULL);

-- ----------------------------
-- Table structure for sys_floor
-- ----------------------------
DROP TABLE IF EXISTS `sys_floor`;
CREATE TABLE `sys_floor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '楼层编码（如：F1、F2）',
  `floor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层名称（如：1楼、2楼）',
  `floor_number` int NOT NULL COMMENT '楼层数（数字，如：1、2、3）',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属校区编码（关联sys_campus）',
  `gender_type` tinyint NOT NULL DEFAULT 3 COMMENT '适用性别：1男 2女 3混合',
  `total_rooms` int NOT NULL DEFAULT 0 COMMENT '该楼层房间数（统计字段）',
  `total_beds` int NOT NULL DEFAULT 0 COMMENT '该楼层床位数（统计字段）',
  `current_occupancy` int NOT NULL DEFAULT 0 COMMENT '当前入住人数（统计字段）',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_floor_code`(`floor_code` ASC) USING BTREE,
  INDEX `idx_campus_code`(`campus_code` ASC) USING BTREE,
  INDEX `idx_floor_code`(`floor_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '楼层表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_floor
-- ----------------------------
INSERT INTO `sys_floor` VALUES (1, 'A001', '科学园A座', 5, 'CAMPUS001', 1, 25, 100, 0, 1, 1, NULL, '2026-01-04 15:29:15', 1, '2026-01-06 15:32:01', 1);

-- ----------------------------
-- Table structure for sys_major
-- ----------------------------
DROP TABLE IF EXISTS `sys_major`;
CREATE TABLE `sys_major`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `major_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专业编码',
  `major_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专业名称',
  `dept_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属院系编码',
  `director` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专业负责人',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学位类型（字典degree_type）',
  `duration` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学制',
  `goal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '培养目标',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_major_code`(`major_code` ASC) USING BTREE,
  INDEX `idx_dept_code`(`dept_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专业表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_major
-- ----------------------------
INSERT INTO `sys_major` VALUES (1, 'CS-SE001', '软件工程', 'CS001', '王五', 'bachelor', '4年制', '培养具有扎实的软件工程理论基础和实践能力的高级专门人才', 1, '2025-12-31 12:51:14', NULL, '2026-01-06 15:32:01', 1);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单类型：M目录 C菜单 F按钮',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由路径',
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `visible` tinyint(1) NULL DEFAULT 1 COMMENT '是否可见：1显示 0隐藏',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1正常 0停用',
  `keep_alive` tinyint(1) NULL DEFAULT 1 COMMENT '页面缓存：1开启 0关闭',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '工作台', 'M', '/dashboard', '/index/index', '', 'ri:pie-chart-line', 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-21 16:51:11', 1);
INSERT INTO `sys_menu` VALUES (2, 1, '控制台', 'C', 'console', '/dashboard/console', 'dashboard:console:view', '', 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-21 16:52:13', 1);
INSERT INTO `sys_menu` VALUES (3, 0, '系统管理', 'M', '/system', '/index/index', '', 'ri:user-3-line', 9, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-29 18:40:43', 1);
INSERT INTO `sys_menu` VALUES (4, 3, '用户管理', 'C', 'user', '/system/user', 'system:user:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (5, 3, '角色管理', 'C', 'role', '/system/role', 'system:role:view', NULL, 2, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (6, 3, '菜单管理', 'C', 'menu', '/system/menu', 'system:menu:view', NULL, 3, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (7, 3, '个人中心', 'C', 'user-center', '/system/user-center', 'system:user-center:view', '', 5, 0, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-31 14:44:02', NULL);
INSERT INTO `sys_menu` VALUES (8, 0, '异常页面', 'M', '/exception', '/index/index', '', 'ri:error-warning-line', 11, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-29 19:02:33', 1);
INSERT INTO `sys_menu` VALUES (9, 8, '403', 'C', '403', '/exception/403', 'exception:403:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (10, 8, '404', 'C', '404', '/exception/404', 'exception:404:view', NULL, 2, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (11, 8, '500', 'C', '500', '/exception/500', 'exception:500:view', NULL, 3, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (12, 0, '结果页面', 'M', '/result', '/index/index', '', 'ri:checkbox-circle-line', 12, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-29 19:02:36', 1);
INSERT INTO `sys_menu` VALUES (13, 12, '成功页', 'C', 'success', '/result/success', 'result:success:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (14, 12, '失败页', 'C', 'fail', '/result/fail', 'result:fail:view', NULL, 2, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (15, 3, '字典管理', 'C', 'dict', '/system/dict', 'system:dict:view', NULL, 4, 1, 1, 1, '2025-12-31 14:42:15', NULL, '2025-12-31 14:42:15', NULL);
INSERT INTO `sys_menu` VALUES (16, 4, '新增用户', 'F', NULL, NULL, 'system:user:add', NULL, 1, 1, 1, 1, '2025-12-31 09:11:03', NULL, '2025-12-31 09:11:03', NULL);
INSERT INTO `sys_menu` VALUES (17, 4, '编辑用户', 'F', NULL, NULL, 'system:user:edit', NULL, 2, 1, 1, 1, '2025-12-31 09:11:03', NULL, '2025-12-31 09:11:03', NULL);
INSERT INTO `sys_menu` VALUES (18, 4, '删除用户', 'F', NULL, NULL, 'system:user:delete', NULL, 3, 1, 1, 1, '2025-12-31 09:11:03', NULL, '2025-12-31 09:11:03', NULL);
INSERT INTO `sys_menu` VALUES (19, 4, '重置密码', 'F', NULL, NULL, 'system:user:reset-pwd', NULL, 4, 1, 1, 1, '2025-12-31 09:11:03', NULL, '2025-12-31 09:11:03', NULL);
INSERT INTO `sys_menu` VALUES (37, 5, '新增角色', 'F', NULL, NULL, 'system:role:add', NULL, 1, 1, 1, 1, '2025-12-31 17:11:56', NULL, '2025-12-31 17:11:56', NULL);
INSERT INTO `sys_menu` VALUES (38, 5, '编辑角色', 'F', NULL, NULL, 'system:role:edit', NULL, 2, 1, 1, 1, '2025-12-31 17:11:56', NULL, '2025-12-31 17:11:56', NULL);
INSERT INTO `sys_menu` VALUES (39, 5, '删除角色', 'F', NULL, NULL, 'system:role:delete', NULL, 3, 1, 1, 1, '2025-12-31 17:11:56', NULL, '2025-12-31 17:11:56', NULL);
INSERT INTO `sys_menu` VALUES (40, 5, '分配权限', 'F', NULL, NULL, 'system:role:assign', NULL, 4, 1, 1, 1, '2025-12-31 17:11:56', NULL, '2025-12-31 17:11:56', NULL);
INSERT INTO `sys_menu` VALUES (41, 6, '新增菜单', 'F', NULL, NULL, 'system:menu:add', NULL, 1, 1, 1, 1, '2025-12-31 17:12:03', NULL, '2025-12-31 17:12:03', NULL);
INSERT INTO `sys_menu` VALUES (42, 6, '编辑菜单', 'F', NULL, NULL, 'system:menu:edit', NULL, 2, 1, 1, 1, '2025-12-31 17:12:03', NULL, '2025-12-31 17:12:03', NULL);
INSERT INTO `sys_menu` VALUES (43, 6, '删除菜单', 'F', NULL, NULL, 'system:menu:delete', NULL, 3, 1, 1, 1, '2025-12-31 17:12:03', NULL, '2025-12-31 17:12:03', NULL);
INSERT INTO `sys_menu` VALUES (44, 15, '新增字典类型', 'F', NULL, NULL, 'system:dict:type:add', NULL, 1, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (45, 15, '编辑字典类型', 'F', NULL, NULL, 'system:dict:type:edit', NULL, 2, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (46, 15, '删除字典类型', 'F', NULL, NULL, 'system:dict:type:delete', NULL, 3, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (47, 15, '新增字典数据', 'F', NULL, NULL, 'system:dict:data:add', NULL, 4, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (48, 15, '编辑字典数据', 'F', NULL, NULL, 'system:dict:data:edit', NULL, 5, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (49, 15, '删除字典数据', 'F', NULL, NULL, 'system:dict:data:delete', NULL, 6, 1, 1, 1, '2025-12-31 17:12:12', NULL, '2025-12-31 17:12:12', NULL);
INSERT INTO `sys_menu` VALUES (50, 0, '学校管理', 'M', '/school', '/index/index', '', 'ri:school-line', 7, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-29 18:40:43', 1);
INSERT INTO `sys_menu` VALUES (55, 67, '新增校区', 'F', NULL, NULL, 'system:campus:add', NULL, 1, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-01 16:08:18', NULL);
INSERT INTO `sys_menu` VALUES (56, 67, '编辑校区', 'F', NULL, NULL, 'system:campus:edit', NULL, 2, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-01 16:08:20', NULL);
INSERT INTO `sys_menu` VALUES (57, 67, '删除校区', 'F', NULL, NULL, 'system:campus:delete', NULL, 3, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-01 16:08:29', NULL);
INSERT INTO `sys_menu` VALUES (58, 68, '新增院系', 'F', NULL, NULL, 'system:department:add', NULL, 1, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-01 16:08:35', NULL);
INSERT INTO `sys_menu` VALUES (59, 68, '编辑院系', 'F', NULL, NULL, 'system:department:edit', NULL, 2, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:37', NULL);
INSERT INTO `sys_menu` VALUES (60, 68, '删除院系', 'F', NULL, NULL, 'system:department:delete', NULL, 3, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:40', NULL);
INSERT INTO `sys_menu` VALUES (61, 69, '新增专业', 'F', NULL, NULL, 'system:major:add', NULL, 1, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:45', NULL);
INSERT INTO `sys_menu` VALUES (62, 69, '编辑专业', 'F', NULL, NULL, 'system:major:edit', NULL, 2, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:47', NULL);
INSERT INTO `sys_menu` VALUES (63, 69, '删除专业', 'F', NULL, NULL, 'system:major:delete', NULL, 3, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:49', NULL);
INSERT INTO `sys_menu` VALUES (64, 70, '新增班级', 'F', NULL, NULL, 'system:class:add', NULL, 1, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:56', NULL);
INSERT INTO `sys_menu` VALUES (65, 70, '编辑班级', 'F', NULL, NULL, 'system:class:edit', NULL, 2, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:08:57', NULL);
INSERT INTO `sys_menu` VALUES (66, 70, '删除班级', 'F', NULL, NULL, 'system:class:delete', NULL, 3, 1, 1, 1, '2025-12-31 20:01:28', NULL, '2026-01-01 16:09:07', NULL);
INSERT INTO `sys_menu` VALUES (67, 50, '校区管理', 'C', 'campus', '/school/campus', NULL, '', 1, 1, 1, 1, '2025-12-31 20:25:36', NULL, '2025-12-31 20:29:28', NULL);
INSERT INTO `sys_menu` VALUES (68, 88, '院系管理', 'C', 'department', '/organization/department', NULL, '', 1, 1, 1, 1, '2025-12-31 20:25:36', NULL, '2026-01-03 12:46:08', NULL);
INSERT INTO `sys_menu` VALUES (69, 88, '专业管理', 'C', 'major', '/organization/major', NULL, '', 2, 1, 1, 1, '2025-12-31 20:25:36', NULL, '2026-01-03 12:46:19', NULL);
INSERT INTO `sys_menu` VALUES (70, 88, '班级管理', 'C', 'class', '/organization/class', NULL, '', 3, 1, 1, 1, '2025-12-31 20:25:36', NULL, '2026-01-03 12:46:22', NULL);
INSERT INTO `sys_menu` VALUES (83, 3, '操作日志', 'C', 'oper-log', '/system/oper-log', 'system:operlog:view', '', 6, 1, 1, 1, '2026-01-01 19:53:03', NULL, '2026-01-01 19:54:30', 1);
INSERT INTO `sys_menu` VALUES (84, 83, '查看详情', 'F', NULL, NULL, 'system:operlog:detail', NULL, 1, 1, 1, 1, '2026-01-01 19:53:03', NULL, '2026-01-01 19:53:03', NULL);
INSERT INTO `sys_menu` VALUES (85, 83, '删除日志', 'F', NULL, NULL, 'system:operlog:delete', NULL, 2, 1, 1, 1, '2026-01-01 19:53:03', NULL, '2026-01-01 19:53:03', NULL);
INSERT INTO `sys_menu` VALUES (86, 83, '清空日志', 'F', NULL, NULL, 'system:operlog:clean', NULL, 3, 1, 1, 1, '2026-01-01 19:53:03', NULL, '2026-01-01 19:53:03', NULL);
INSERT INTO `sys_menu` VALUES (87, 4, '分配管理', 'F', '', '', 'system:user:assign-scope', '', 5, 1, 1, 1, '2026-01-02 17:57:21', 1, '2026-01-02 17:57:21', 1);
INSERT INTO `sys_menu` VALUES (88, 0, '组织管理', 'M', '/organization', '/index/index', NULL, 'ri:organization-chart', 8, 1, 1, 1, '2026-01-03 12:45:25', NULL, '2026-01-29 18:40:43', NULL);
INSERT INTO `sys_menu` VALUES (89, 50, '学年管理', 'C', 'academic-year', '/school/academic-year', NULL, '', 2, 1, 1, 1, '2026-01-03 12:45:29', NULL, '2026-01-03 20:56:04', NULL);
INSERT INTO `sys_menu` VALUES (90, 0, '宿舍管理', 'M', '/dormitory', '/index/index', '', 'ri:building-line', 3, 1, 1, 1, '2026-01-03 12:45:30', NULL, '2026-01-06 18:12:29', 1);
INSERT INTO `sys_menu` VALUES (94, 89, '新增学年', 'F', NULL, NULL, 'system:academic-year:add', NULL, 1, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:51:45', NULL);
INSERT INTO `sys_menu` VALUES (95, 89, '编辑学年', 'F', NULL, NULL, 'system:academic-year:edit', NULL, 2, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:51:45', NULL);
INSERT INTO `sys_menu` VALUES (96, 89, '删除学年', 'F', NULL, NULL, 'system:academic-year:delete', NULL, 3, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:51:45', NULL);
INSERT INTO `sys_menu` VALUES (97, 90, '楼层管理', 'C', 'floor', '/dormitory/floor', NULL, '', 1, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:55:44', NULL);
INSERT INTO `sys_menu` VALUES (98, 90, '房间管理', 'C', 'room', '/dormitory/room', NULL, '', 2, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:55:41', NULL);
INSERT INTO `sys_menu` VALUES (99, 90, '床位管理', 'C', 'bed', '/dormitory/bed', NULL, '', 3, 1, 1, 1, '2026-01-03 20:51:45', NULL, '2026-01-03 20:55:30', NULL);
INSERT INTO `sys_menu` VALUES (100, 97, '新增楼层', 'F', NULL, NULL, 'system:floor:add', NULL, 1, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (101, 97, '编辑楼层', 'F', NULL, NULL, 'system:floor:edit', NULL, 2, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (102, 97, '删除楼层', 'F', NULL, NULL, 'system:floor:delete', NULL, 3, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (103, 97, '批量删除', 'F', NULL, NULL, 'system:floor:batchDelete', NULL, 4, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (104, 97, '状态切换', 'F', NULL, NULL, 'system:floor:status', NULL, 5, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (105, 97, '导出', 'F', NULL, NULL, 'system:floor:export', NULL, 6, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (106, 98, '新增房间', 'F', NULL, NULL, 'system:room:add', NULL, 1, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (107, 98, '编辑房间', 'F', NULL, NULL, 'system:room:edit', NULL, 2, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (108, 98, '删除房间', 'F', NULL, NULL, 'system:room:delete', NULL, 3, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (109, 98, '批量删除', 'F', NULL, NULL, 'system:room:batchDelete', NULL, 4, 1, 1, 1, '2026-01-03 22:12:25', NULL, '2026-01-03 22:12:25', NULL);
INSERT INTO `sys_menu` VALUES (110, 98, '状态切换', 'F', NULL, NULL, 'system:room:status', NULL, 5, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (111, 98, '导出', 'F', NULL, NULL, 'system:room:export', NULL, 6, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (112, 99, '新增床位', 'F', NULL, NULL, 'system:bed:add', NULL, 1, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (113, 99, '编辑床位', 'F', NULL, NULL, 'system:bed:edit', NULL, 2, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (114, 99, '删除床位', 'F', NULL, NULL, 'system:bed:delete', NULL, 3, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (115, 99, '批量删除', 'F', NULL, NULL, 'system:bed:batchDelete', NULL, 4, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (116, 99, '状态切换', 'F', NULL, NULL, 'system:bed:status', NULL, 5, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (117, 99, '导出', 'F', NULL, NULL, 'system:bed:export', NULL, 6, 1, 1, 1, '2026-01-03 22:12:26', NULL, '2026-01-03 22:12:26', NULL);
INSERT INTO `sys_menu` VALUES (118, 97, '批量增加房间', 'F', NULL, NULL, 'system:floor:batchAdd', NULL, 7, 1, 1, 1, '2026-01-06 04:01:38', NULL, '2026-01-06 04:01:38', NULL);
INSERT INTO `sys_menu` VALUES (119, 98, '批量增加床位', 'F', NULL, NULL, 'system:room:batchAdd', NULL, 7, 1, 1, 1, '2026-01-06 04:01:39', NULL, '2026-01-06 04:01:39', NULL);
INSERT INTO `sys_menu` VALUES (124, 4, '分配权限', 'F', '', '', 'system:user:assign-permission', '', 6, 1, 1, 1, '2026-01-06 14:29:02', 1, '2026-01-06 14:29:08', 1);
INSERT INTO `sys_menu` VALUES (125, 0, '住宿管理', 'M', '/accommodation', '/index/index', '', 'ri:community-line', 2, 1, 1, 1, '2026-01-06 17:55:18', NULL, '2026-01-06 18:18:50', 1);
INSERT INTO `sys_menu` VALUES (126, 125, '人员管理', 'C', 'student', '/accommodation/student', '', '', 1, 1, 1, 1, '2026-01-06 17:55:18', NULL, '2026-01-06 18:25:40', 1);
INSERT INTO `sys_menu` VALUES (127, 126, '新增学生', 'F', '', '', 'system:student:add', '', 1, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (128, 126, '编辑学生', 'F', '', '', 'system:student:edit', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (129, 126, '删除学生', 'F', '', '', 'system:student:delete', '', 3, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (130, 125, '入住管理', 'C', 'check-in', '/accommodation/check-in', '', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 18:25:46', 1);
INSERT INTO `sys_menu` VALUES (131, 130, '新增入住', 'F', '', '', 'system:checkIn:add', '', 1, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (132, 130, '删除入住', 'F', '', '', 'system:checkIn:delete', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (133, 125, '调宿管理', 'C', 'transfer', '/accommodation/transfer', '', '', 3, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 18:25:53', 1);
INSERT INTO `sys_menu` VALUES (134, 133, '新增调宿', 'F', '', '', 'system:transfer:add', '', 1, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (135, 133, '删除调宿', 'F', '', '', 'system:transfer:delete', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (136, 125, '退宿管理', 'C', 'check-out', '/accommodation/check-out', '', '', 4, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 18:26:01', 1);
INSERT INTO `sys_menu` VALUES (137, 136, '新增退宿', 'F', '', '', 'system:checkOut:add', '', 1, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (138, 136, '删除退宿', 'F', '', '', 'system:checkOut:delete', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (139, 125, '留宿管理', 'C', 'stay', '/accommodation/stay', '', '', 5, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 18:26:11', 1);
INSERT INTO `sys_menu` VALUES (140, 139, '新增留宿', 'F', '', '', 'system:stay:add', '', 1, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (141, 139, '删除留宿', 'F', '', '', 'system:stay:delete', '', 2, 1, 1, 1, '2026-01-06 17:55:19', NULL, '2026-01-06 17:55:19', NULL);
INSERT INTO `sys_menu` VALUES (142, 0, '审批管理', 'M', '/approval', '/index/index', '', 'ri:flow-chart', 6, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-25 22:24:46', 1);
INSERT INTO `sys_menu` VALUES (143, 142, '流程配置', 'C', 'flow-config', '/approval/flow-config', NULL, '', 1, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:12', NULL);
INSERT INTO `sys_menu` VALUES (144, 142, '待办审批', 'C', 'pending', '/approval/pending', NULL, '', 2, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:15', NULL);
INSERT INTO `sys_menu` VALUES (145, 142, '审批记录', 'C', 'history', '/approval/history', NULL, '', 3, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:18', NULL);
INSERT INTO `sys_menu` VALUES (146, 0, '通知管理', 'M', '/notice', '/index/index', '', 'ri:notification-3-line', 5, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:40:43', NULL);
INSERT INTO `sys_menu` VALUES (147, 146, '通知列表', 'C', 'list', '/notice/list', 'notice:list:view', '', 1, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (148, 147, '新增通知', 'F', NULL, NULL, 'notice:add', NULL, 1, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (149, 147, '编辑通知', 'F', NULL, NULL, 'notice:edit', NULL, 2, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (150, 147, '删除通知', 'F', NULL, NULL, 'notice:delete', NULL, 3, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (151, 147, '发布/下架', 'F', NULL, NULL, 'notice:publish', NULL, 4, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (152, 0, '报修管理', 'M', '/repair', '/index/index', '', 'ri:tools-line', 4, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:40:43', NULL);
INSERT INTO `sys_menu` VALUES (153, 152, '报修工单', 'C', 'list', '/repair/list', 'repair:list:view', '', 1, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (154, 153, '接单', 'F', NULL, NULL, 'repair:accept', NULL, 1, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (155, 153, '完成维修', 'F', NULL, NULL, 'repair:complete', NULL, 2, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);
INSERT INTO `sys_menu` VALUES (156, 153, '删除工单', 'F', NULL, NULL, 'repair:delete', NULL, 3, 1, 1, 1, '2026-01-29 18:38:02', 1, '2026-01-29 18:38:02', NULL);

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `notice_type` int NOT NULL COMMENT '通知类型：1系统通知 2宿舍公告 3安全提醒 4停水停电 99其他',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `attachments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附件（JSON数组）',
  `publisher_id` bigint NULL DEFAULT NULL COMMENT '发布人ID',
  `publisher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发布人姓名',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `is_top` tinyint(1) NULL DEFAULT 0 COMMENT '是否置顶：0否 1是',
  `target_floors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '目标楼层（JSON数组，为空表示全部）',
  `read_count` int NULL DEFAULT 0 COMMENT '阅读次数',
  `status` int NULL DEFAULT 0 COMMENT '状态：0草稿 1已发布',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_notice_type`(`notice_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE,
  INDEX `idx_is_top`(`is_top` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '欢迎使用宿舍管理系统', '欢迎使用宿舍管理系统小程序！如有问题，请联系管理员。', 1, NULL, NULL, NULL, '系统管理员', '2026-01-29 16:46:29', 1, NULL, 0, 1, NULL, '2026-01-29 16:46:29', '2026-01-29 16:46:29', NULL, NULL);
INSERT INTO `sys_notice` VALUES (2, '春节放假通知', '根据学校安排，春节期间宿舍开放时间调整如下：除夕至初六全天开放，初七恢复正常。请同学们合理安排时间。', 2, NULL, NULL, NULL, '宿管科', '2026-01-29 16:46:29', 1, NULL, 0, 1, NULL, '2026-01-29 16:46:29', '2026-01-29 16:46:29', NULL, NULL);
INSERT INTO `sys_notice` VALUES (3, '注意用电安全', '冬季是火灾高发期，请同学们注意用电安全，不使用违规电器，离开宿舍及时关闭电源。', 3, NULL, NULL, NULL, '保卫处', '2026-01-29 16:46:29', 0, NULL, 0, 1, NULL, '2026-01-29 16:46:29', '2026-01-29 16:46:29', NULL, NULL);

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `notice_id` bigint NOT NULL COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（学生ID）',
  `read_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '阅读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_notice_user`(`notice_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_notice_id`(`notice_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知阅读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作模块',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `device_type` int NULL DEFAULT NULL COMMENT '设备类型（字典sys_device_type：1桌面设备 2移动设备 3爬虫/Bot）',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT NULL COMMENT '消耗时间（毫秒）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_oper_time`(`oper_time` ASC) USING BTREE,
  INDEX `idx_business_type`(`business_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 307 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (238, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1', '192.168.0.107', '', '1 {\"id\":1,\"roleCode\":\"SUPER_ADMIN\",\"roleName\":\"超级管理员\",\"sort\":1,\"status\":1,\"remark\":\"系统最高权限\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985232897}', 0, '', '2026-01-21 16:47:13', 263);
INSERT INTO `sys_oper_log` VALUES (239, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1', '192.168.0.107', '', '1 {\"id\":1,\"roleCode\":\"SUPER_ADMIN\",\"roleName\":\"超级管理员\",\"sort\":1,\"status\":1,\"remark\":\"系统最高权限\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985261763}', 0, '', '2026-01-21 16:47:42', 4);
INSERT INTO `sys_oper_log` VALUES (240, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/6', '192.168.0.107', '', '6 {\"id\":6,\"roleCode\":\"TEST_ROLE\",\"roleName\":\"测试角色\",\"sort\":100,\"status\":1,\"remark\":\"这是一个测试角色\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985278027}', 0, '', '2026-01-21 16:47:58', 5);
INSERT INTO `sys_oper_log` VALUES (241, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/2', '192.168.0.107', '', '2 {\"id\":2,\"roleCode\":\"DORMITORY_MANAGER\",\"roleName\":\"宿管员\",\"sort\":2,\"status\":1,\"remark\":\"管理宿舍楼和房间信息\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985347826}', 0, '', '2026-01-21 16:49:08', 4);
INSERT INTO `sys_oper_log` VALUES (242, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/3', '192.168.0.107', '', '3 {\"id\":3,\"roleCode\":\"COUNSELOR\",\"roleName\":\"辅导员\",\"sort\":3,\"status\":1,\"remark\":\"审核本学院学生申请\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985407620}', 0, '', '2026-01-21 16:50:08', 6);
INSERT INTO `sys_oper_log` VALUES (243, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/4', '192.168.0.107', '', '4 {\"id\":4,\"roleCode\":\"COLLEGE_ADMIN\",\"roleName\":\"院系管理员\",\"sort\":4,\"status\":1,\"remark\":\"管理本学院住宿信息\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985410471}', 0, '', '2026-01-21 16:50:10', 6);
INSERT INTO `sys_oper_log` VALUES (244, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/5', '192.168.0.107', '', '5 {\"id\":5,\"roleCode\":\"SCHOOL_AUDITOR\",\"roleName\":\"学校审核员\",\"sort\":5,\"status\":1,\"remark\":\"最终审核权限\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985438263}', 0, '', '2026-01-21 16:50:38', 17);
INSERT INTO `sys_oper_log` VALUES (245, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/6', '192.168.0.107', '', '6 {\"id\":6,\"roleCode\":\"TEST_ROLE\",\"roleName\":\"测试角色\",\"sort\":100,\"status\":1,\"remark\":\"这是一个测试角色\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985440386}', 0, '', '2026-01-21 16:50:40', 17);
INSERT INTO `sys_oper_log` VALUES (246, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1', '192.168.0.107', '', '1 {\"id\":1,\"roleCode\":\"SUPER_ADMIN\",\"roleName\":\"超级管理员\",\"sort\":1,\"status\":1,\"remark\":\"系统最高权限\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985442290}', 0, '', '2026-01-21 16:50:42', 4);
INSERT INTO `sys_oper_log` VALUES (247, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/2', '192.168.0.107', '', '2 {\"id\":2,\"roleCode\":\"DORMITORY_MANAGER\",\"roleName\":\"宿管员\",\"sort\":2,\"status\":1,\"remark\":\"管理宿舍楼和房间信息\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985443994}', 0, '', '2026-01-21 16:50:44', 0);
INSERT INTO `sys_oper_log` VALUES (248, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/3', '192.168.0.107', '', '3 {\"id\":3,\"roleCode\":\"COUNSELOR\",\"roleName\":\"辅导员\",\"sort\":3,\"status\":1,\"remark\":\"审核本学院学生申请\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985446188}', 0, '', '2026-01-21 16:50:46', 4);
INSERT INTO `sys_oper_log` VALUES (249, '编辑角色', 2, 'com.project.backend.system.controller.RoleController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/4', '192.168.0.107', '', '4 {\"id\":4,\"roleCode\":\"COLLEGE_ADMIN\",\"roleName\":\"院系管理员\",\"sort\":4,\"status\":1,\"remark\":\"管理本学院住宿信息\",\"menuIds\":null}', '{\"code\":200,\"message\":\"角色编辑成功\",\"data\":null,\"timestamp\":1768985448231}', 0, '', '2026-01-21 16:50:48', 0);
INSERT INTO `sys_oper_log` VALUES (250, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/1', '192.168.0.107', '', '1 {\"id\":1,\"parentId\":0,\"menuName\":\"工作台\",\"menuType\":\"M\",\"path\":\"/dashboard\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:pie-chart-line\",\"sort\":1,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1768985471260}', 0, '', '2026-01-21 16:51:11', 21);
INSERT INTO `sys_oper_log` VALUES (251, '字典类型管理-编辑字典类型(ID:43)', 2, 'com.project.backend.system.controller.DictTypeController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/dict/type/43', '192.168.0.107', '', '43 {\"id\":43,\"dictName\":\"审批业务类型\",\"dictCode\":\"business_type\",\"status\":1,\"remark\":\"审批流程关联的业务类型\"}', '{\"code\":200,\"message\":\"字典类型编辑成功\",\"data\":null,\"timestamp\":1768985480384}', 0, '', '2026-01-21 16:51:20', 15);
INSERT INTO `sys_oper_log` VALUES (252, '编辑字典数据', 2, 'com.project.backend.system.controller.DictDataController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/dict/data/207', '192.168.0.107', '', '207 {\"id\":207,\"dictCode\":\"business_type\",\"label\":\"入住申请\",\"value\":\"check_in\",\"cssClass\":\"\",\"listClass\":\"\",\"sort\":1,\"isDefault\":0,\"status\":1,\"remark\":\"\"}', '{\"code\":200,\"message\":\"字典数据编辑成功\",\"data\":null,\"timestamp\":1768985483135}', 0, '', '2026-01-21 16:51:23', 91);
INSERT INTO `sys_oper_log` VALUES (253, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/2', '192.168.0.107', '', '2 {\"id\":2,\"parentId\":1,\"menuName\":\"控制台\",\"menuType\":\"C\",\"path\":\"console\",\"component\":\"/dashboard/console\",\"permission\":\"dashboard:console:view\",\"icon\":\"\",\"sort\":1,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1768985533021}', 0, '', '2026-01-21 16:52:13', 4);
INSERT INTO `sys_oper_log` VALUES (254, '校区管理-编辑校区(主校区)', 2, 'com.project.backend.organization.controller.CampusController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/campus/1', '192.168.0.107', '', '1 {\"id\":1,\"campusCode\":\"CAMPUS001\",\"campusName\":\"主校区\",\"address\":\"北京市海淀区中关村大街1号\",\"manager\":\"张三\",\"sort\":1,\"status\":1}', '{\"code\":200,\"message\":\"校区编辑成功\",\"data\":null,\"timestamp\":1768985559899}', 0, '', '2026-01-21 16:52:40', 13);
INSERT INTO `sys_oper_log` VALUES (255, '院系管理-编辑院系(计算机科学与技术学院)', 2, 'com.project.backend.organization.controller.DepartmentController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/department/1', '192.168.0.107', '', '1 {\"id\":1,\"deptCode\":\"CS001\",\"deptName\":\"计算机科学与技术学院\",\"campusCode\":\"CAMPUS001\",\"leader\":\"李四\",\"phone\":\"010-12345678\",\"sort\":1,\"status\":1}', '{\"code\":200,\"message\":\"院系编辑成功\",\"data\":null,\"timestamp\":1768985566550}', 0, '', '2026-01-21 16:52:47', 15);
INSERT INTO `sys_oper_log` VALUES (256, '院系管理-编辑院系(计算机科学与技术学院)', 2, 'com.project.backend.organization.controller.DepartmentController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/department/1', '192.168.0.107', '', '1 {\"id\":1,\"deptCode\":\"CS001\",\"deptName\":\"计算机科学与技术学院\",\"campusCode\":\"CAMPUS001\",\"leader\":\"李四\",\"phone\":\"010-12345678\",\"sort\":1,\"status\":1}', '{\"code\":200,\"message\":\"院系编辑成功\",\"data\":null,\"timestamp\":1768985673361}', 0, '', '2026-01-21 16:54:33', 5);
INSERT INTO `sys_oper_log` VALUES (257, '房间管理-编辑房间(ID:53)', 2, 'com.project.backend.room.controller.RoomController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/room/53', '192.168.0.107', '', '53 {\"id\":53,\"roomCode\":\"103\",\"roomNumber\":\"103\",\"floorId\":1,\"floorNumber\":1,\"roomType\":\"standard\",\"bedCount\":4,\"maxOccupancy\":4,\"area\":25.5,\"hasAirConditioner\":1,\"hasBathroom\":1,\"hasBalcony\":1,\"roomStatus\":1,\"sort\":3,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"房间编辑成功\",\"data\":null,\"timestamp\":1768985823290}', 0, '', '2026-01-21 16:57:03', 101);
INSERT INTO `sys_oper_log` VALUES (258, '床位管理-编辑床位(ID:13)', 2, 'com.project.backend.room.controller.BedController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/13', '192.168.0.107', '', '13 BedSaveDTO(id=13, bedCode=1, bedNumber=1, roomId=51, bedPosition=null, bedStatus=1, studentId=null, studentName=null, checkInDate=2026-01-01, checkOutDate=2026-06-01, sort=1, status=1, remark=null)', '{\"code\":200,\"message\":\"床位编辑成功\",\"data\":null,\"timestamp\":1768985830290}', 0, '', '2026-01-21 16:57:10', 46);
INSERT INTO `sys_oper_log` VALUES (259, '新增字典数据', 1, 'com.project.backend.system.controller.DictDataController.add()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/dict/data', '192.168.0.107', '', '{\"id\":null,\"dictCode\":\"table_button_config\",\"label\":\"绑定\",\"value\":\"link\",\"cssClass\":\"ri:link\",\"listClass\":\"\",\"sort\":8,\"isDefault\":0,\"status\":1,\"remark\":\"\"}', '{\"code\":200,\"message\":\"字典数据新增成功\",\"data\":null,\"timestamp\":1768994735318}', 0, '', '2026-01-21 19:25:35', 37);
INSERT INTO `sys_oper_log` VALUES (260, '分配用户权限', 0, 'com.project.backend.system.controller.UserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/2/permissions', '192.168.0.107', '', '2 [1,2,127,128,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14,125,126]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768995025450}', 0, '', '2026-01-21 19:30:25', 78);
INSERT INTO `sys_oper_log` VALUES (261, '编辑用户', 2, 'com.project.backend.system.controller.UserController.update()', 'PUT', 1, 'testuser', 1, '/api/v1/system/user/1', '192.168.0.100', '', '1 {\"id\":1,\"username\":\"superAdmin\",\"password\":null,\"nickname\":\"超级管理员\",\"avatar\":null,\"email\":\"superAdmin@example.com\",\"phone\":\"17876648229\",\"manageScope\":\"{\\\"campusIds\\\":[1],\\\"departmentIds\\\":[1],\\\"majorIds\\\":[1],\\\"classIds\\\":[2,1]}\",\"status\":1,\"gender\":1,\"address\":null,\"introduction\":null,\"cpUserId\":null,\"openid\":null,\"roleIds\":[1]}', '{\"code\":200,\"message\":\"用户编辑成功\",\"data\":null,\"timestamp\":1768996132349}', 0, '', '2026-01-21 19:48:52', 46);
INSERT INTO `sys_oper_log` VALUES (262, '编辑字典数据', 2, 'com.project.backend.system.controller.DictDataController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/dict/data/211', '192.168.0.107', '', '211 {\"id\":211,\"dictCode\":\"table_button_config\",\"label\":\"绑定\",\"value\":\"link\",\"cssClass\":\"ri:link\",\"listClass\":\"\",\"sort\":8,\"isDefault\":0,\"status\":1,\"remark\":\"ri:link\"}', '{\"code\":200,\"message\":\"字典数据编辑成功\",\"data\":null,\"timestamp\":1768997414690}', 0, '', '2026-01-21 20:10:15', 12);
INSERT INTO `sys_oper_log` VALUES (263, '编辑字典数据', 2, 'com.project.backend.system.controller.DictDataController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/dict/data/211', '192.168.0.107', '', '211 {\"id\":211,\"dictCode\":\"table_button_config\",\"label\":\"绑定\",\"value\":\"link\",\"cssClass\":\"bg-info/12 text-info\",\"listClass\":\"\",\"sort\":8,\"isDefault\":0,\"status\":1,\"remark\":\"ri:link\"}', '{\"code\":200,\"message\":\"字典数据编辑成功\",\"data\":null,\"timestamp\":1768997431481}', 0, '', '2026-01-21 20:10:31', 6);
INSERT INTO `sys_oper_log` VALUES (264, '分配用户权限', 0, 'com.project.backend.system.controller.UserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/2/permissions', '192.168.0.107', '', '2 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768997547600}', 0, '', '2026-01-21 20:12:28', 72);
INSERT INTO `sys_oper_log` VALUES (265, '执行审批', 0, 'com.project.backend.approval.controller.ApprovalController.doApprove()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/approve', '192.168.0.107', '', '{\"instanceId\":2,\"action\":1,\"opinion\":\"同意，没问题。\"}', '{\"code\":200,\"message\":\"审批成功\",\"data\":null,\"timestamp\":1769052185769}', 0, '', '2026-01-22 11:23:06', 63);
INSERT INTO `sys_oper_log` VALUES (266, '入住管理-新增入住', 1, 'com.project.backend.accommodation.controller.CheckInController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/check-in', '192.168.0.107', '', 'CheckInSaveDTO(id=null, studentId=14, checkInType=1, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, checkInDate=2026-01-25, expectedCheckOutDate=null, status=null, approverId=null, approverName=null, approveOpinion=null, applyReason=测试, remark=null)', '{\"code\":200,\"message\":\"入住管理新增成功\",\"data\":null,\"timestamp\":1769324605049}', 0, '', '2026-01-25 15:03:25', 170);
INSERT INTO `sys_oper_log` VALUES (267, '调宿管理-新增调宿', 1, 'com.project.backend.accommodation.controller.TransferController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/transfer', '192.168.0.107', '', 'TransferSaveDTO(id=null, studentId=14, originalCampusCode=null, originalFloorCode=null, originalRoomId=null, originalRoomCode=null, originalBedId=null, originalBedCode=null, targetCampusCode=null, targetFloorCode=null, targetRoomId=null, targetRoomCode=null, targetBedId=null, targetBedCode=null, applyDate=null, transferDate=2026-01-25, status=null, approverId=null, approverName=null, approveOpinion=null, transferReason=测试调宿, remark=null)', '{\"code\":200,\"message\":\"调宿管理新增成功\",\"data\":null,\"timestamp\":1769324649978}', 0, '', '2026-01-25 15:04:10', 21);
INSERT INTO `sys_oper_log` VALUES (268, '新增审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.addFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/flow', '192.168.0.100', '', '{\"id\":null,\"flowName\":\"调宿流程\",\"flowCode\":\"#002\",\"businessType\":\"transfer\",\"description\":\"这是一条调宿申请流程\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":null,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":null,\"nodeName\":\"二次管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":3,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程新增成功\",\"data\":null,\"timestamp\":1769324805851}', 0, '', '2026-01-25 15:06:46', 13);
INSERT INTO `sys_oper_log` VALUES (269, '绑定审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.100', '', '{\"id\":null,\"businessType\":\"transfer\",\"flowId\":2,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1769324814704}', 0, '', '2026-01-25 15:06:55', 8);
INSERT INTO `sys_oper_log` VALUES (270, '编辑审批流程', 2, 'com.project.backend.approval.controller.ApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.100', '', '1 {\"id\":1,\"flowName\":\"入住流程\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":2,\"nodeName\":\"二次管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1769324847829}', 0, '', '2026-01-25 15:07:28', 18);
INSERT INTO `sys_oper_log` VALUES (271, '编辑审批流程', 2, 'com.project.backend.approval.controller.ApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/2', '192.168.0.100', '', '2 {\"id\":2,\"flowName\":\"调宿流程\",\"flowCode\":\"#002\",\"businessType\":\"transfer\",\"description\":\"这是一条调宿申请流程\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":3,\"nodeName\":\"宿舍阿姨\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":4,\"nodeName\":\"管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":3,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1769324934968}', 0, '', '2026-01-25 15:08:55', 12);
INSERT INTO `sys_oper_log` VALUES (272, '编辑审批流程', 2, 'com.project.backend.approval.controller.ApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.100', '', '1 {\"id\":1,\"flowName\":\"入住流程\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"宿舍阿姨\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":2,\"nodeName\":\"管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1769324947216}', 0, '', '2026-01-25 15:09:07', 15);
INSERT INTO `sys_oper_log` VALUES (273, '新增审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.addFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/flow', '192.168.0.100', '', '{\"id\":null,\"flowName\":\"退宿流程\",\"flowCode\":\"#003\",\"businessType\":\"check_out\",\"description\":\"这是一条退宿申请流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":null,\"nodeName\":\"宿舍阿姨\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":null,\"nodeName\":\"管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":2,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程新增成功\",\"data\":null,\"timestamp\":1769326372718}', 0, '', '2026-01-25 15:32:53', 10);
INSERT INTO `sys_oper_log` VALUES (274, '绑定审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.100', '', '{\"id\":null,\"businessType\":\"check_out\",\"flowId\":3,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1769326378099}', 0, '', '2026-01-25 15:32:58', 8);
INSERT INTO `sys_oper_log` VALUES (275, '退宿管理-新增退宿', 1, 'com.project.backend.accommodation.controller.CheckOutController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/check-out', '192.168.0.107', '', 'CheckOutSaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, checkOutDate=2026-01-25, status=null, approverId=null, approverName=null, approveOpinion=null, checkOutReason=测试, remark=null)', '{\"code\":200,\"message\":\"退宿管理新增成功\",\"data\":null,\"timestamp\":1769331306782}', 0, '', '2026-01-25 16:55:07', 162);
INSERT INTO `sys_oper_log` VALUES (276, '入住管理-新增入住', 1, 'com.project.backend.accommodation.controller.CheckInController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/check-in', '192.168.0.107', '', 'CheckInSaveDTO(id=null, studentId=14, checkInType=1, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, checkInDate=2026-01-25, expectedCheckOutDate=null, status=null, approverId=null, approverName=null, approveOpinion=null, applyReason=这是一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的文字。, remark=null)', '{\"code\":200,\"message\":\"入住管理新增成功\",\"data\":null,\"timestamp\":1769345080436}', 0, '', '2026-01-25 20:44:40', 48);
INSERT INTO `sys_oper_log` VALUES (277, '绑定审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_out\",\"flowId\":3,\"status\":0,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1769350167115}', 0, '', '2026-01-25 22:09:27', 17);
INSERT INTO `sys_oper_log` VALUES (278, '绑定审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_out\",\"flowId\":3,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1769350168298}', 0, '', '2026-01-25 22:09:28', 5);
INSERT INTO `sys_oper_log` VALUES (279, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/142', '192.168.0.107', '', '142 {\"id\":142,\"parentId\":0,\"menuName\":\"审批管理\",\"menuType\":\"M\",\"path\":\"/approval\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:flow-chart\",\"sort\":5,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351038135}', 0, '', '2026-01-25 22:23:58', 11);
INSERT INTO `sys_oper_log` VALUES (280, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/3', '192.168.0.107', '', '3 {\"id\":3,\"parentId\":0,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"path\":\"/system\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:user-3-line\",\"sort\":7,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351048057}', 0, '', '2026-01-25 22:24:08', 5);
INSERT INTO `sys_oper_log` VALUES (281, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/8', '192.168.0.107', '', '8 {\"id\":8,\"parentId\":0,\"menuName\":\"异常页面\",\"menuType\":\"M\",\"path\":\"/exception\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:error-warning-line\",\"sort\":7,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351070501}', 0, '', '2026-01-25 22:24:31', 5);
INSERT INTO `sys_oper_log` VALUES (282, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/8', '192.168.0.107', '', '8 {\"id\":8,\"parentId\":0,\"menuName\":\"异常页面\",\"menuType\":\"M\",\"path\":\"/exception\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:error-warning-line\",\"sort\":8,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351075370}', 0, '', '2026-01-25 22:24:35', 3);
INSERT INTO `sys_oper_log` VALUES (283, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/12', '192.168.0.107', '', '12 {\"id\":12,\"parentId\":0,\"menuName\":\"结果页面\",\"menuType\":\"M\",\"path\":\"/result\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:checkbox-circle-line\",\"sort\":9,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351079076}', 0, '', '2026-01-25 22:24:39', 5);
INSERT INTO `sys_oper_log` VALUES (284, '编辑菜单', 2, 'com.project.backend.system.controller.MenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/142', '192.168.0.107', '', '142 {\"id\":142,\"parentId\":0,\"menuName\":\"审批管理\",\"menuType\":\"M\",\"path\":\"/approval\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:flow-chart\",\"sort\":6,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1769351086465}', 0, '', '2026-01-25 22:24:46', 5);
INSERT INTO `sys_oper_log` VALUES (285, '新增审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.addFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/flow', '192.168.0.107', '', '{\"id\":null,\"flowName\":\"留宿流程\",\"flowCode\":\"#004\",\"businessType\":\"stay\",\"description\":\"这是一条留宿申请流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":null,\"nodeName\":\"宿管阿姨\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":2,\"assigneeName\":\"测试用户\"}]},{\"id\":null,\"nodeName\":\"管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":3,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程新增成功\",\"data\":null,\"timestamp\":1769353286406}', 0, '', '2026-01-25 23:01:26', 39);
INSERT INTO `sys_oper_log` VALUES (286, '绑定审批流程', 1, 'com.project.backend.approval.controller.ApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"stay\",\"flowId\":4,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1769353294467}', 0, '', '2026-01-25 23:01:34', 8);
INSERT INTO `sys_oper_log` VALUES (287, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=不想回家。, remark=null)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769353362055}', 0, '', '2026-01-25 23:02:42', 21);
INSERT INTO `sys_oper_log` VALUES (288, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=不想回家, remark=null)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769354112381}', 0, '', '2026-01-25 23:15:12', 34);
INSERT INTO `sys_oper_log` VALUES (289, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=null, parentPhone=null, parentAgree=null, signature=null, images=null)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769354421784}', 0, '', '2026-01-25 23:20:22', 100);
INSERT INTO `sys_oper_log` VALUES (290, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=陈11, parentPhone=17812345678, parentAgree=agree, signature=http://tmp/e9RviiqXDT569f4ad1f82ba514d72a3c9d4b548afa7c.png, images=)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769354575782}', 0, '', '2026-01-25 23:22:56', 17);
INSERT INTO `sys_oper_log` VALUES (291, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=俺不想回家。。。, remark=null, parentName=陈大师, parentPhone=17812345678, parentAgree=agree, signature=http://tmp/c5fr9-J6uU4De6636d969e72f4a66c1cfb83101290c0.png, images=)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769355453282}', 0, '', '2026-01-25 23:37:33', 42);
INSERT INTO `sys_oper_log` VALUES (292, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=测试, parentPhone=17812345678, parentAgree=agree, signature=http://tmp/WF6xlP63L5COd1f44f118b62deb77190780584afe442.png, images=)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769355644630}', 0, '', '2026-01-25 23:40:45', 11);
INSERT INTO `sys_oper_log` VALUES (293, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=陈大师, parentPhone=17876648229, parentAgree=agree, signature=http://tmp/-TD5I_65599ffce88f91332761076cdb8f9e1a099fa4.png, images=)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769355776708}', 0, '', '2026-01-25 23:42:57', 21);
INSERT INTO `sys_oper_log` VALUES (294, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-25, stayEndDate=2026-01-25, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=测试, parentPhone=17812345678, parentAgree=agree, signature=http://tmp/h66SqJt5K1A9dcd21c3261b0ecd2512a3a917469eedf.png, images=)', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769355946296}', 0, '', '2026-01-25 23:45:46', 163);
INSERT INTO `sys_oper_log` VALUES (295, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-26, stayEndDate=2026-01-27, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=测试, remark=null, parentName=测试, parentPhone=17812345678, parentAgree=agree, signature=[http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/cc5a1567-48ec-4825-8a4f-0a825dfdf7c1.png], images=[])', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769358192700}', 0, '', '2026-01-26 00:23:13', 146);
INSERT INTO `sys_oper_log` VALUES (296, '留宿管理-新增留宿', 1, 'com.project.backend.accommodation.controller.StayController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/stay', '192.168.0.107', '', 'StaySaveDTO(id=null, studentId=14, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, stayStartDate=2026-01-26, stayEndDate=2026-01-26, status=null, approverId=null, approverName=null, approveOpinion=null, stayReason=111, remark=null, parentName=1, parentPhone=17812345678, parentAgree=agree, signature=[http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/9d128bdb-78b9-4784-9dff-544f3b5e8750.png], images=[http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/dbe3caa6-2361-45b5-8d47-7e02c7b0860c.png])', '{\"code\":200,\"message\":\"留宿管理新增成功\",\"data\":null,\"timestamp\":1769358724468}', 0, '', '2026-01-26 00:32:04', 13);
INSERT INTO `sys_oper_log` VALUES (297, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'testuser', 1, '/api/v1/system/student', '192.168.0.100', '', '{\"id\":14,\"studentNo\":\"2021001\",\"studentName\":\"张三\",\"gender\":1,\"idCard\":\"320102199901123456\",\"phone\":\"13800138001\",\"email\":\"zhangsan@example.com\",\"birthDate\":null,\"nation\":\"汉族\",\"politicalStatus\":\"\",\"enrollmentYear\":2021,\"schoolingLength\":4,\"currentGrade\":null,\"academicStatus\":1,\"homeAddress\":\"\",\"emergencyContact\":\"\",\"emergencyPhone\":\"\",\"parentName\":\"\",\"parentPhone\":\"\",\"campusCode\":null,\"deptCode\":null,\"majorCode\":null,\"classId\":null,\"classCode\":null,\"floorId\":null,\"floorCode\":null,\"roomId\":null,\"roomCode\":null,\"bedId\":null,\"bedCode\":null,\"status\":null,\"remark\":\"\",\"smokingStatus\":null,\"smokingTolerance\":null,\"sleepSchedule\":null,\"sleepQuality\":null,\"snores\":null,\"sensitiveToLight\":null,\"sensitiveToSound\":null,\"cleanlinessLevel\":null,\"bedtimeCleanup\":null,\"socialPreference\":null,\"allowVisitors\":null,\"phoneCallTime\":null,\"studyInRoom\":null,\"studyEnvironment\":null,\"computerUsageTime\":null,\"gamingPreference\":null,\"musicPreference\":null,\"musicVolume\":null,\"eatInRoom\":null}', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769422801281}', 0, '', '2026-01-26 18:20:01', 137);
INSERT INTO `sys_oper_log` VALUES (298, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'testuser', 1, '/api/v1/system/student', '192.168.0.100', '', '{\"id\":14,\"studentNo\":\"2021001\",\"studentName\":\"张三\",\"gender\":1,\"idCard\":\"320102199901123456\",\"phone\":\"13800138001\",\"email\":\"zhangsan@example.com\",\"birthDate\":null,\"nation\":\"汉族\",\"politicalStatus\":\"群众\",\"enrollmentYear\":2021,\"schoolingLength\":4,\"currentGrade\":null,\"academicStatus\":1,\"homeAddress\":\"\",\"emergencyContact\":\"\",\"emergencyPhone\":\"\",\"parentName\":\"\",\"parentPhone\":\"\",\"campusCode\":null,\"deptCode\":null,\"majorCode\":null,\"classId\":null,\"classCode\":null,\"floorId\":null,\"floorCode\":null,\"roomId\":null,\"roomCode\":null,\"bedId\":null,\"bedCode\":null,\"status\":null,\"remark\":\"\",\"smokingStatus\":null,\"smokingTolerance\":null,\"sleepSchedule\":null,\"sleepQuality\":null,\"snores\":null,\"sensitiveToLight\":null,\"sensitiveToSound\":null,\"cleanlinessLevel\":null,\"bedtimeCleanup\":null,\"socialPreference\":null,\"allowVisitors\":null,\"phoneCallTime\":null,\"studyInRoom\":null,\"studyEnvironment\":null,\"computerUsageTime\":null,\"gamingPreference\":null,\"musicPreference\":null,\"musicVolume\":null,\"eatInRoom\":null}', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769422813525}', 0, '', '2026-01-26 18:20:14', 8);
INSERT INTO `sys_oper_log` VALUES (299, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'testuser', 1, '/api/v1/system/student', '192.168.0.100', '', 'StudentSaveDTO(id=14, studentNo=2021001, studentName=张三, gender=1, idCard=320102199901123456, phone=13800138001, email=zhangsan@example.com, birthDate=1999-01-12, nation=汉族, politicalStatus=群众, enrollmentYear=2021, schoolingLength=4, currentGrade=null, academicStatus=1, homeAddress=, emergencyContact=, emergencyPhone=, parentName=, parentPhone=, campusCode=null, deptCode=null, majorCode=null, classId=null, classCode=null, floorId=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, status=null, remark=, smokingStatus=null, smokingTolerance=null, sleepSchedule=null, sleepQuality=null, snores=null, sensitiveToLight=null, sensitiveToSound=null, cleanlinessLevel=null, bedtimeCleanup=null, socialPreference=null, allowVisitors=null, phoneCallTime=null, studyInRoom=null, studyEnvironment=null, computerUsageTime=null, gamingPreference=null, musicPreference=null, musicVolume=null, eatInRoom=null)', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769422877898}', 0, '', '2026-01-26 18:21:18', 7);
INSERT INTO `sys_oper_log` VALUES (300, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'testuser', 1, '/api/v1/system/student', '192.168.0.100', '', 'StudentSaveDTO(id=14, studentNo=2021001, studentName=张三, gender=1, idCard=320102199901123456, phone=13800138001, email=zhangsan@example.com, birthDate=1999-01-12, nation=汉族, politicalStatus=群众, enrollmentYear=2021, schoolingLength=4, currentGrade=null, academicStatus=1, homeAddress=, emergencyContact=, emergencyPhone=, parentName=, parentPhone=, campusCode=null, deptCode=null, majorCode=null, classId=null, classCode=null, floorId=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, status=null, remark=, smokingStatus=null, smokingTolerance=null, sleepSchedule=null, sleepQuality=null, snores=null, sensitiveToLight=null, sensitiveToSound=null, cleanlinessLevel=null, bedtimeCleanup=null, socialPreference=null, allowVisitors=null, phoneCallTime=null, studyInRoom=null, studyEnvironment=null, computerUsageTime=null, gamingPreference=null, musicPreference=null, musicVolume=null, eatInRoom=null)', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769422896382}', 0, '', '2026-01-26 18:21:36', 10);
INSERT INTO `sys_oper_log` VALUES (301, '修改状态', 2, 'com.project.backend.organization.controller.ClassController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2/status/0', '192.168.0.111', '', '2 0', '{\"code\":200,\"message\":\"班级已停用\",\"data\":null,\"timestamp\":1769424034622}', 0, '', '2026-01-26 18:40:35', 6);
INSERT INTO `sys_oper_log` VALUES (302, '修改状态', 2, 'com.project.backend.organization.controller.ClassController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2/status/1', '192.168.0.111', '', '2 1', '{\"code\":200,\"message\":\"班级已启用\",\"data\":null,\"timestamp\":1769424034915}', 0, '', '2026-01-26 18:40:35', 6);
INSERT INTO `sys_oper_log` VALUES (303, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/student', '192.168.0.107', '', 'StudentSaveDTO(id=14, studentNo=2021001, studentName=张三, gender=1, idCard=320102199901123456, phone=13800138001, email=zhangsan@example.com, birthDate=1999-01-12, nation=汉族, politicalStatus=共青团员, enrollmentYear=2021, schoolingLength=4, currentGrade=null, academicStatus=1, homeAddress=, emergencyContact=, emergencyPhone=, parentName=, parentPhone=, campusCode=null, deptCode=null, majorCode=null, classId=null, classCode=null, floorId=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, status=null, remark=, smokingStatus=null, smokingTolerance=null, sleepSchedule=null, sleepQuality=null, snores=null, sensitiveToLight=null, sensitiveToSound=null, cleanlinessLevel=null, bedtimeCleanup=null, socialPreference=null, allowVisitors=null, phoneCallTime=null, studyInRoom=null, studyEnvironment=null, computerUsageTime=null, gamingPreference=null, musicPreference=null, musicVolume=null, eatInRoom=null)', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769427268344}', 0, '', '2026-01-26 19:34:28', 8);
INSERT INTO `sys_oper_log` VALUES (304, '学生管理-编辑学生(ID:14)', 2, 'com.project.backend.accommodation.controller.StudentController.updateFromBody()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/student', '192.168.0.107', '', 'StudentSaveDTO(id=14, studentNo=2021001, studentName=张三, gender=1, idCard=320102199901123456, phone=13800138001, email=zhangsan@example.com, birthDate=1999-01-12, nation=汉族, politicalStatus=群众, enrollmentYear=2021, schoolingLength=4, currentGrade=null, academicStatus=1, homeAddress=, emergencyContact=, emergencyPhone=, parentName=, parentPhone=, campusCode=null, deptCode=null, majorCode=null, classId=null, classCode=null, floorId=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, status=null, remark=, smokingStatus=null, smokingTolerance=null, sleepSchedule=null, sleepQuality=null, snores=null, sensitiveToLight=null, sensitiveToSound=null, cleanlinessLevel=null, bedtimeCleanup=null, socialPreference=null, allowVisitors=null, phoneCallTime=null, studyInRoom=null, studyEnvironment=null, computerUsageTime=null, gamingPreference=null, musicPreference=null, musicVolume=null, eatInRoom=null)', '{\"code\":200,\"message\":\"学生编辑成功\",\"data\":null,\"timestamp\":1769427301782}', 0, '', '2026-01-26 19:35:02', 3);
INSERT INTO `sys_oper_log` VALUES (305, '分配角色权限', 0, 'com.project.backend.system.controller.RoleController.assignPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1/permissions', '0:0:0:0:0:0:0:1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,142,143,144,145,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14,146,147,148,149,150,151,152,153,154,155,156]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1769683120187}', 0, '', '2026-01-29 18:38:40', 117);
INSERT INTO `sys_oper_log` VALUES (306, '分配用户权限', 0, 'com.project.backend.system.controller.UserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '0:0:0:0:0:0:0:1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,142,143,144,145,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14,146,147,148,149,150,151,152,153,154,155,156]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1769683128889}', 0, '', '2026-01-29 18:38:49', 84);

-- ----------------------------
-- Table structure for sys_repair
-- ----------------------------
DROP TABLE IF EXISTS `sys_repair`;
CREATE TABLE `sys_repair`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` bigint NOT NULL COMMENT '学生ID（关联 sys_student）',
  `room_id` bigint NULL DEFAULT NULL COMMENT '房间ID（关联 sys_room）',
  `bed_id` bigint NULL DEFAULT NULL COMMENT '床位ID（关联 sys_bed）',
  `repair_type` int NOT NULL COMMENT '维修类型：1-水电 2-门窗 3-家具 4-网络 5-其他',
  `fault_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '故障描述',
  `fault_images` json NULL COMMENT '故障图片（JSON数组）',
  `urgent_level` int NOT NULL DEFAULT 1 COMMENT '紧急程度：1-一般 2-紧急 3-非常紧急',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1-待接单 2-已接单 3-维修中 4-已完成 5-已取消',
  `repair_person_id` bigint NULL DEFAULT NULL COMMENT '维修人员ID',
  `repair_person_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '维修人员姓名',
  `appointment_time` datetime NULL DEFAULT NULL COMMENT '预约时间',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `repair_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '维修结果描述',
  `repair_images` json NULL COMMENT '维修后图片（JSON数组）',
  `rating` int NULL DEFAULT NULL COMMENT '评分：1-5星',
  `rating_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评价内容',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_room_id`(`room_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_repair_type`(`repair_type` ASC) USING BTREE,
  INDEX `idx_repair_person_id`(`repair_person_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '报修管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_repair
-- ----------------------------
INSERT INTO `sys_repair` VALUES (1, 14, 51, 13, 1, '水龙头漏水，需要维修', '[\"image1.jpg\"]', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-29 19:38:36', '2026-01-29 19:38:36', NULL, NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1正常 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'SUPER_ADMIN', '超级管理员', 1, 1, '系统最高权限', '2025-12-30 17:19:06', NULL, '2026-01-21 16:50:42', 1);
INSERT INTO `sys_role` VALUES (2, 'DORMITORY_MANAGER', '宿管员', 2, 1, '管理宿舍楼和房间信息', '2025-12-30 17:19:06', NULL, '2026-01-21 16:50:44', 1);
INSERT INTO `sys_role` VALUES (3, 'COUNSELOR', '辅导员', 3, 1, '审核本学院学生申请', '2025-12-30 17:19:06', NULL, '2026-01-21 16:50:46', 1);
INSERT INTO `sys_role` VALUES (4, 'COLLEGE_ADMIN', '院系管理员', 4, 1, '管理本学院住宿信息', '2025-12-30 17:19:06', NULL, '2026-01-21 16:50:48', 1);
INSERT INTO `sys_role` VALUES (5, 'SCHOOL_AUDITOR', '学校审核员', 5, 1, '最终审核权限', '2025-12-30 17:19:06', NULL, '2026-01-21 16:50:38', 1);
INSERT INTO `sys_role` VALUES (6, 'TEST_ROLE', '测试角色', 100, 1, '这是一个测试角色', '2025-12-31 11:41:23', NULL, '2026-01-21 16:50:40', 1);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE,
  INDEX `idx_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1954, 6, 1, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1955, 6, 2, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1956, 6, 125, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1957, 6, 126, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1958, 6, 127, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1959, 6, 128, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1960, 6, 129, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1961, 6, 130, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1962, 6, 131, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1963, 6, 132, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1964, 6, 133, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1965, 6, 134, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1966, 6, 135, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1967, 6, 136, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1968, 6, 137, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1969, 6, 138, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1970, 6, 139, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1971, 6, 140, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1972, 6, 141, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1973, 6, 90, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1974, 6, 97, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1975, 6, 100, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1976, 6, 101, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1977, 6, 102, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1978, 6, 103, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1979, 6, 104, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1980, 6, 105, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1981, 6, 118, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1982, 6, 98, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1983, 6, 106, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1984, 6, 107, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1985, 6, 108, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1986, 6, 109, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1987, 6, 110, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1988, 6, 111, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1989, 6, 119, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1990, 6, 99, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1991, 6, 112, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1992, 6, 113, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1993, 6, 114, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1994, 6, 115, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1995, 6, 116, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1996, 6, 117, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1997, 6, 142, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1998, 6, 143, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (1999, 6, 144, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2000, 6, 145, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2001, 6, 88, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2002, 6, 68, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2003, 6, 58, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2004, 6, 59, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2005, 6, 60, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2006, 6, 69, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2007, 6, 61, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2008, 6, 62, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2009, 6, 63, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2010, 6, 70, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2011, 6, 64, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2012, 6, 65, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2013, 6, 66, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2014, 6, 50, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2015, 6, 67, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2016, 6, 55, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2017, 6, 56, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2018, 6, 57, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2019, 6, 89, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2020, 6, 94, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2021, 6, 95, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2022, 6, 96, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2023, 6, 3, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2024, 6, 4, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2025, 6, 16, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2026, 6, 17, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2027, 6, 18, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2028, 6, 19, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2029, 6, 87, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2030, 6, 124, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2031, 6, 5, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2032, 6, 37, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2033, 6, 38, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2034, 6, 39, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2035, 6, 40, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2036, 6, 6, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2037, 6, 41, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2038, 6, 42, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2039, 6, 43, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2040, 6, 15, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2041, 6, 44, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2042, 6, 45, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2043, 6, 46, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2044, 6, 47, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2045, 6, 48, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2046, 6, 49, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2047, 6, 7, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2048, 6, 83, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2049, 6, 84, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2050, 6, 85, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2051, 6, 86, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2052, 6, 8, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2053, 6, 9, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2054, 6, 10, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2055, 6, 11, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2056, 6, 12, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2057, 6, 13, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2058, 6, 14, '2026-01-17 22:54:57');
INSERT INTO `sys_role_menu` VALUES (2066, 1, 1, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2067, 1, 2, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2068, 1, 125, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2069, 1, 126, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2070, 1, 127, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2071, 1, 128, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2072, 1, 129, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2073, 1, 130, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2074, 1, 131, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2075, 1, 132, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2076, 1, 133, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2077, 1, 134, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2078, 1, 135, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2079, 1, 136, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2080, 1, 137, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2081, 1, 138, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2082, 1, 139, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2083, 1, 140, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2084, 1, 141, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2085, 1, 90, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2086, 1, 97, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2087, 1, 100, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2088, 1, 101, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2089, 1, 102, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2090, 1, 103, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2091, 1, 104, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2092, 1, 105, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2093, 1, 118, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2094, 1, 98, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2095, 1, 106, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2096, 1, 107, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2097, 1, 108, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2098, 1, 109, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2099, 1, 110, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2100, 1, 111, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2101, 1, 119, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2102, 1, 99, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2103, 1, 112, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2104, 1, 113, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2105, 1, 114, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2106, 1, 115, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2107, 1, 116, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2108, 1, 117, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2109, 1, 88, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2110, 1, 68, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2111, 1, 58, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2112, 1, 59, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2113, 1, 60, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2114, 1, 69, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2115, 1, 61, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2116, 1, 62, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2117, 1, 63, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2118, 1, 70, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2119, 1, 64, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2120, 1, 65, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2121, 1, 66, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2122, 1, 50, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2123, 1, 67, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2124, 1, 55, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2125, 1, 56, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2126, 1, 57, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2127, 1, 89, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2128, 1, 94, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2129, 1, 95, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2130, 1, 96, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2131, 1, 142, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2132, 1, 143, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2133, 1, 144, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2134, 1, 145, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2135, 1, 3, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2136, 1, 4, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2137, 1, 16, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2138, 1, 17, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2139, 1, 18, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2140, 1, 19, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2141, 1, 87, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2142, 1, 124, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2143, 1, 5, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2144, 1, 37, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2145, 1, 38, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2146, 1, 39, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2147, 1, 40, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2148, 1, 6, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2149, 1, 41, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2150, 1, 42, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2151, 1, 43, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2152, 1, 15, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2153, 1, 44, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2154, 1, 45, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2155, 1, 46, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2156, 1, 47, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2157, 1, 48, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2158, 1, 49, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2159, 1, 7, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2160, 1, 83, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2161, 1, 84, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2162, 1, 85, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2163, 1, 86, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2164, 1, 8, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2165, 1, 9, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2166, 1, 10, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2167, 1, 11, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2168, 1, 12, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2169, 1, 13, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2170, 1, 14, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2171, 1, 146, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2172, 1, 147, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2173, 1, 148, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2174, 1, 149, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2175, 1, 150, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2176, 1, 151, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2177, 1, 152, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2178, 1, 153, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2179, 1, 154, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2180, 1, 155, '2026-01-29 18:38:40');
INSERT INTO `sys_role_menu` VALUES (2181, 1, 156, '2026-01-29 18:38:40');

-- ----------------------------
-- Table structure for sys_room
-- ----------------------------
DROP TABLE IF EXISTS `sys_room`;
CREATE TABLE `sys_room`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '房间编码（如：101、102）',
  `room_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '房间号（如：101、102）',
  `floor_id` bigint NOT NULL COMMENT '所属楼层ID',
  `floor_number` int NULL DEFAULT NULL COMMENT '所属楼层数（冗余字段）',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属楼层编码（冗余字段）',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属校区编码（冗余字段）',
  `room_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间类型（字典room_type）：标准间、套间、单人间等',
  `bed_count` int NOT NULL DEFAULT 4 COMMENT '床位数（标准配置）',
  `current_occupancy` int NOT NULL DEFAULT 0 COMMENT '当前入住人数',
  `max_occupancy` int NULL DEFAULT NULL COMMENT '最大入住人数',
  `area` decimal(10, 2) NULL DEFAULT NULL COMMENT '房间面积（平方米）',
  `has_air_conditioner` tinyint NOT NULL DEFAULT 0 COMMENT '是否有空调：1是 0否',
  `has_bathroom` tinyint NOT NULL DEFAULT 0 COMMENT '是否有独立卫生间：1是 0否',
  `has_balcony` tinyint NOT NULL DEFAULT 0 COMMENT '是否有阳台：1是 0否',
  `room_status` tinyint NOT NULL DEFAULT 1 COMMENT '房间状态：1空闲 2已满 3维修中 4已预订',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_code`(`room_code` ASC) USING BTREE,
  INDEX `idx_floor_id`(`floor_id` ASC) USING BTREE,
  INDEX `idx_floor_code`(`floor_code` ASC) USING BTREE,
  INDEX `idx_campus_code`(`campus_code` ASC) USING BTREE,
  INDEX `idx_room_code`(`room_code` ASC) USING BTREE,
  INDEX `idx_floor_id_number`(`floor_id` ASC, `floor_number` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房间表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_room
-- ----------------------------
INSERT INTO `sys_room` VALUES (51, '101', '101', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 1, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (52, '102', '102', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 2, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (53, '103', '103', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 3, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-21 16:57:03', 1);
INSERT INTO `sys_room` VALUES (54, '104', '104', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 4, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (55, '105', '105', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 5, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (56, '201', '201', 1, 2, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 6, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (57, '202', '202', 1, 2, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 7, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (58, '203', '203', 1, 2, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 8, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (59, '204', '204', 1, 2, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 9, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (60, '205', '205', 1, 2, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 10, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (61, '301', '301', 1, 3, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 11, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (62, '302', '302', 1, 3, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 12, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (63, '303', '303', 1, 3, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 13, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (64, '304', '304', 1, 3, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 14, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (65, '305', '305', 1, 3, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 15, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (66, '401', '401', 1, 4, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 16, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (67, '402', '402', 1, 4, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 17, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (68, '403', '403', 1, 4, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 18, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (69, '404', '404', 1, 4, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 19, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (70, '405', '405', 1, 4, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 20, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (71, '501', '501', 1, 5, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 21, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (72, '502', '502', 1, 5, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 22, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (73, '503', '503', 1, 5, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 23, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (74, '504', '504', 1, 5, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 24, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
INSERT INTO `sys_room` VALUES (75, '505', '505', 1, 5, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 25, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);

-- ----------------------------
-- Table structure for sys_semester
-- ----------------------------
DROP TABLE IF EXISTS `sys_semester`;
CREATE TABLE `sys_semester`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `academic_year_id` bigint NOT NULL COMMENT '所属学年ID',
  `semester_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学期编码',
  `semester_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学期名称',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `semester_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学期类型（如：第一学期、第二学期）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_semester_code`(`semester_code` ASC) USING BTREE,
  INDEX `idx_academic_year_id`(`academic_year_id` ASC) USING BTREE,
  CONSTRAINT `fk_semester_academic_year` FOREIGN KEY (`academic_year_id`) REFERENCES `sys_academic_year` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学期表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_semester
-- ----------------------------

-- ----------------------------
-- Table structure for sys_stay
-- ----------------------------
DROP TABLE IF EXISTS `sys_stay`;
CREATE TABLE `sys_stay`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名（冗余）',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学号（冗余）',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '校区编码',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层编码',
  `room_id` bigint NULL DEFAULT NULL COMMENT '房间ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间编码',
  `bed_id` bigint NULL DEFAULT NULL COMMENT '床位ID',
  `bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '床位编码',
  `apply_date` date NULL DEFAULT NULL COMMENT '申请日期',
  `stay_start_date` date NULL DEFAULT NULL COMMENT '留宿开始日期',
  `stay_end_date` date NULL DEFAULT NULL COMMENT '留宿结束日期',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
  `approval_instance_id` bigint NULL DEFAULT NULL COMMENT '审批实例ID',
  `approver_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `approve_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `stay_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留宿理由（必填）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `parent_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家长姓名',
  `parent_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家长电话',
  `parent_agree` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家长是否同意：agree-同意 disagree-不同意',
  `signature` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '本人签名图片URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附件图片列表（JSON字符串数组）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_stay_start_date`(`stay_start_date` ASC) USING BTREE,
  INDEX `idx_stay_end_date`(`stay_end_date` ASC) USING BTREE,
  INDEX `idx_bed_id`(`bed_id` ASC) USING BTREE,
  INDEX `idx_approval_instance`(`approval_instance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '留宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_stay
-- ----------------------------
INSERT INTO `sys_stay` VALUES (1, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 6, NULL, NULL, NULL, NULL, '不想回家。', NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25 23:02:42', 14, '2026-01-25 23:02:42', 14);
INSERT INTO `sys_stay` VALUES (2, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 7, NULL, NULL, NULL, NULL, '不想回家', NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25 23:15:12', 14, '2026-01-25 23:15:12', 14);
INSERT INTO `sys_stay` VALUES (3, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 8, NULL, NULL, NULL, NULL, '测试', NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25 23:20:22', 14, '2026-01-25 23:20:22', 14);
INSERT INTO `sys_stay` VALUES (4, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 9, NULL, NULL, NULL, NULL, '测试', NULL, '陈11', '17812345678', 'agree', 'http://tmp/e9RviiqXDT569f4ad1f82ba514d72a3c9d4b548afa7c.png', '', '2026-01-25 23:22:56', 14, '2026-01-25 23:22:56', 14);
INSERT INTO `sys_stay` VALUES (5, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 10, NULL, NULL, NULL, NULL, '俺不想回家。。。', NULL, '陈大师', '17812345678', 'agree', 'http://tmp/c5fr9-J6uU4De6636d969e72f4a66c1cfb83101290c0.png', '', '2026-01-25 23:37:33', 14, '2026-01-25 23:37:33', 14);
INSERT INTO `sys_stay` VALUES (6, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 11, NULL, NULL, NULL, NULL, '测试', NULL, '测试', '17812345678', 'agree', 'http://tmp/WF6xlP63L5COd1f44f118b62deb77190780584afe442.png', '', '2026-01-25 23:40:45', 14, '2026-01-25 23:40:45', 14);
INSERT INTO `sys_stay` VALUES (7, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-26', 1, 12, NULL, NULL, NULL, NULL, '测试', NULL, '陈大师', '17876648229', 'agree', 'http://tmp/-TD5I_65599ffce88f91332761076cdb8f9e1a099fa4.png', '', '2026-01-25 23:42:57', 14, '2026-01-25 23:42:57', 14);
INSERT INTO `sys_stay` VALUES (8, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', '2026-01-25', 1, 13, NULL, NULL, NULL, NULL, '测试', NULL, '测试', '17812345678', 'agree', 'http://tmp/h66SqJt5K1A9dcd21c3261b0ecd2512a3a917469eedf.png', '', '2026-01-25 23:45:46', 14, '2026-01-25 23:45:46', 14);
INSERT INTO `sys_stay` VALUES (9, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-26', '2026-01-27', 1, 14, NULL, NULL, NULL, NULL, '测试', NULL, '测试', '17812345678', 'agree', '[\"http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/cc5a1567-48ec-4825-8a4f-0a825dfdf7c1.png\"]', NULL, '2026-01-26 00:23:13', 14, '2026-01-26 00:23:13', 14);
INSERT INTO `sys_stay` VALUES (10, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-26', '2026-01-26', 1, 15, NULL, NULL, NULL, NULL, '111', NULL, '1', '17812345678', 'agree', '[\"http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/9d128bdb-78b9-4784-9dff-544f3b5e8750.png\"]', '[\"http://192.168.0.107:8080/api/v1/common/files/uploads/20260126/dbe3caa6-2361-45b5-8d47-7e02c7b0860c.png\"]', '2026-01-26 00:32:04', 14, '2026-01-26 00:32:04', 14);

-- ----------------------------
-- Table structure for sys_student
-- ----------------------------
DROP TABLE IF EXISTS `sys_student`;
CREATE TABLE `sys_student`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `gender` int NULL DEFAULT NULL COMMENT '性别（字典sys_user_sex）：0未知 1男 2女',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `nation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '民族',
  `political_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政治面貌',
  `enrollment_year` int NULL DEFAULT NULL COMMENT '入学年份',
  `schooling_length` int NULL DEFAULT NULL COMMENT '学制（年）',
  `current_grade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '当前年级',
  `academic_status` int NULL DEFAULT NULL COMMENT '学籍状态（字典academic_status）：1在读 2休学 3毕业 4退学',
  `home_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家庭地址',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系人电话',
  `parent_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家长姓名',
  `parent_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家长电话',
  `campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '校区编码',
  `dept_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '院系编码',
  `major_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专业编码',
  `class_id` bigint NULL DEFAULT NULL COMMENT '班级ID',
  `class_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级编码',
  `floor_id` bigint NULL DEFAULT NULL COMMENT '楼层ID',
  `floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层编码',
  `room_id` bigint NULL DEFAULT NULL COMMENT '房间ID',
  `room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '房间编码',
  `bed_id` bigint NULL DEFAULT NULL COMMENT '床位ID',
  `bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '床位编码',
  `smoking_status` tinyint NULL DEFAULT 0 COMMENT '吸烟状态：0不吸烟 1吸烟',
  `smoking_tolerance` tinyint NULL DEFAULT 0 COMMENT '是否接受室友吸烟：0不接受 1接受',
  `sleep_schedule` tinyint NULL DEFAULT 1 COMMENT '作息时间：0早睡早起(22:00-6:00) 1正常(23:00-7:00) 2晚睡晚起(24:00-8:00) 3夜猫子(01:00-9:00)',
  `sleep_quality` tinyint NULL DEFAULT 1 COMMENT '睡眠质量：0浅睡易醒 1正常 2深睡',
  `snores` tinyint NULL DEFAULT 0 COMMENT '是否打呼噜：0不打 1打',
  `sensitive_to_light` tinyint NULL DEFAULT 0 COMMENT '是否对光线敏感：0不敏感 1敏感',
  `sensitive_to_sound` tinyint NULL DEFAULT 0 COMMENT '是否对声音敏感：0不敏感 1敏感',
  `cleanliness_level` tinyint NULL DEFAULT 2 COMMENT '整洁程度：1非常整洁 2整洁 3一般 4随意 5不整洁',
  `bedtime_cleanup` tinyint NULL DEFAULT 1 COMMENT '睡前是否整理：0不整理 1偶尔整理 2经常整理 3总是整理',
  `social_preference` tinyint NULL DEFAULT 1 COMMENT '社交偏好：1喜欢安静 2中等 3喜欢热闹',
  `allow_visitors` tinyint NULL DEFAULT 1 COMMENT '是否允许室友带访客：0不允许 1偶尔可以 2可以',
  `phone_call_time` tinyint NULL DEFAULT 1 COMMENT '电话时间偏好：0喜欢在宿舍打电话 1偶尔在宿舍 2不在宿舍打电话',
  `study_in_room` tinyint NULL DEFAULT 1 COMMENT '是否在宿舍学习：0不在 1偶尔 2经常 3总是',
  `study_environment` tinyint NULL DEFAULT 1 COMMENT '学习环境偏好：1需要安静 2需要轻音乐 3可以接受声音',
  `computer_usage_time` tinyint NULL DEFAULT 2 COMMENT '电脑使用时间：0不用 1很少(1-2h/天) 2正常(3-5h/天) 3很多(6h+/天)',
  `gaming_preference` tinyint NULL DEFAULT 1 COMMENT '游戏偏好：0不玩游戏 1偶尔玩 2经常玩',
  `music_preference` tinyint NULL DEFAULT 1 COMMENT '听音乐偏好：0不听 1偶尔听 2经常听',
  `music_volume` tinyint NULL DEFAULT 1 COMMENT '音乐音量偏好：1喜欢小声 2中等 3喜欢大声',
  `eat_in_room` tinyint NULL DEFAULT 1 COMMENT '是否在宿舍吃东西：0不吃 1偶尔 2经常',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码（加密）',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信openid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_student_name`(`student_name` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_id_card`(`id_card` ASC) USING BTREE,
  INDEX `idx_campus_code`(`campus_code` ASC) USING BTREE,
  INDEX `idx_dept_code`(`dept_code` ASC) USING BTREE,
  INDEX `idx_major_code`(`major_code` ASC) USING BTREE,
  INDEX `idx_class_id`(`class_id` ASC) USING BTREE,
  INDEX `idx_bed_id`(`bed_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_student
-- ----------------------------
INSERT INTO `sys_student` VALUES (1, '2025001001', '张三', 1, NULL, '13800138000', 'zhangsan@example.com', NULL, NULL, NULL, 2025, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:06', NULL, '2026-01-26 17:14:20', NULL, NULL, NULL);
INSERT INTO `sys_student` VALUES (4, '2025001002', '李四', 2, NULL, '13900139000', 'lisi@example.com', NULL, NULL, NULL, 2025, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:31', NULL, '2026-01-26 17:14:24', NULL, NULL, NULL);
INSERT INTO `sys_student` VALUES (6, '2025001003', '王五', 1, NULL, '13700137000', 'wangwu@example.com', NULL, NULL, NULL, 2025, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:54', NULL, '2026-01-26 17:14:28', 1, NULL, NULL);
INSERT INTO `sys_student` VALUES (14, '2021001', '张三', 1, '320102199901123456', '13800138001', 'zhangsan@example.com', '1999-01-12', '汉族', '群众', 2021, 4, '大三', 1, '', '', '', '', '', 'CAMPUS001', 'CS001', 'CS-SE001', 1, 'CS-SE202301', 1, 'A001', 51, '101', 13, '1', 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, '', '2026-01-15 18:23:05', NULL, '2026-01-26 19:35:02', 1, '$2a$10$kutnHxYZ9sAN0aluqHKBXuJctNg.HTztmKUwqcIsRlmqSYySqSinS', NULL);
INSERT INTO `sys_student` VALUES (15, '2021002', '李四', 2, '320102199902234654', '13800138002', 'lisi@example.com', NULL, NULL, NULL, 2021, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-15 18:23:05', NULL, '2026-01-15 18:23:05', NULL, '$2a$10$0QdMZpT9OAscydeo8reBAuWfvdrdkLUJ/BojEvR1AN.j6obO8/JDC', NULL);
INSERT INTO `sys_student` VALUES (16, '2021003', '王五', 1, '320102199903111111', '13800138003', 'wangwu@example.com', NULL, NULL, NULL, 2021, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-15 18:23:05', NULL, '2026-01-15 18:23:05', NULL, '$2a$10$eWQqpPDInOx7FbfUFyhr8O/s0zUtA6ILn9vcmPpT6/NeWx3RIajJG', 'test_openid_wangwu');

-- ----------------------------
-- Table structure for sys_transfer
-- ----------------------------
DROP TABLE IF EXISTS `sys_transfer`;
CREATE TABLE `sys_transfer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名（冗余）',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学号（冗余）',
  `original_campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原校区编码',
  `original_floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原楼层编码',
  `original_room_id` bigint NULL DEFAULT NULL COMMENT '原房间ID',
  `original_room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原房间编码',
  `original_bed_id` bigint NULL DEFAULT NULL COMMENT '原床位ID',
  `original_bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原床位编码',
  `target_campus_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标校区编码',
  `target_floor_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标楼层编码',
  `target_room_id` bigint NULL DEFAULT NULL COMMENT '目标房间ID',
  `target_room_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标房间编码',
  `target_bed_id` bigint NULL DEFAULT NULL COMMENT '目标床位ID',
  `target_bed_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标床位编码',
  `apply_date` date NULL DEFAULT NULL COMMENT '申请日期',
  `transfer_date` date NULL DEFAULT NULL COMMENT '调宿日期',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
  `approval_instance_id` bigint NULL DEFAULT NULL COMMENT '审批实例ID',
  `approver_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `approve_opinion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见',
  `transfer_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '调宿原因',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_transfer_date`(`transfer_date` ASC) USING BTREE,
  INDEX `idx_original_bed_id`(`original_bed_id` ASC) USING BTREE,
  INDEX `idx_target_bed_id`(`target_bed_id` ASC) USING BTREE,
  INDEX `idx_approval_instance`(`approval_instance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_transfer
-- ----------------------------
INSERT INTO `sys_transfer` VALUES (1, 14, '张三', '2021001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-25', 2, NULL, NULL, NULL, NULL, NULL, '测试调宿', NULL, '2026-01-25 15:04:10', 14, '2026-01-25 15:04:10', 14);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（加密）',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `manage_scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理范围',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1正常 0停用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint NULL DEFAULT NULL COMMENT '更新人ID',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `gender` int NULL DEFAULT NULL COMMENT '性别(字典sys_gender): 0未知 1男 2女',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个人介绍',
  `cp_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '企业微信ID',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信openid',
  `del_flag` int NULL DEFAULT 0 COMMENT '删除标志: 0正常 1删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_college`(`manage_scope` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'superAdmin', '$2a$10$LGpvVk9hFrfIIVRnWHoRVe.FkSVbqJ0CtyrY/WPLUva9e6xU7b/Ta', '超级管理员', NULL, 'superAdmin@example.com', '17876648229', '{\"campusIds\":[1],\"departmentIds\":[1],\"majorIds\":[1],\"classIds\":[2,1]}', 1, '2025-12-30 17:19:05', NULL, '2026-01-21 19:48:52', 2, '2026-01-30 16:19:07', 1, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (2, 'testuser', '$2a$10$LGpvVk9hFrfIIVRnWHoRVe.FkSVbqJ0CtyrY/WPLUva9e6xU7b/Ta', '测试用户', NULL, 'test@example.com', '13800138000', '', 1, '2025-12-31 11:41:22', NULL, '2026-01-03 16:43:14', 1, '2026-01-26 19:14:33', NULL, NULL, NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for sys_user_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_menu`;
CREATE TABLE `sys_user_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_menu`(`user_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1099 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_menu
-- ----------------------------
INSERT INTO `sys_user_menu` VALUES (878, 2, 1, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (879, 2, 2, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (880, 2, 125, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (881, 2, 126, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (882, 2, 127, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (883, 2, 128, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (884, 2, 129, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (885, 2, 130, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (886, 2, 131, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (887, 2, 132, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (888, 2, 133, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (889, 2, 134, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (890, 2, 135, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (891, 2, 136, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (892, 2, 137, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (893, 2, 138, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (894, 2, 139, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (895, 2, 140, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (896, 2, 141, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (897, 2, 90, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (898, 2, 97, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (899, 2, 100, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (900, 2, 101, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (901, 2, 102, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (902, 2, 103, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (903, 2, 104, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (904, 2, 105, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (905, 2, 118, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (906, 2, 98, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (907, 2, 106, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (908, 2, 107, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (909, 2, 108, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (910, 2, 109, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (911, 2, 110, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (912, 2, 111, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (913, 2, 119, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (914, 2, 99, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (915, 2, 112, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (916, 2, 113, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (917, 2, 114, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (918, 2, 115, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (919, 2, 116, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (920, 2, 117, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (921, 2, 142, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (922, 2, 143, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (923, 2, 144, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (924, 2, 145, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (925, 2, 88, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (926, 2, 68, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (927, 2, 58, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (928, 2, 59, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (929, 2, 60, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (930, 2, 69, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (931, 2, 61, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (932, 2, 62, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (933, 2, 63, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (934, 2, 70, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (935, 2, 64, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (936, 2, 65, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (937, 2, 66, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (938, 2, 50, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (939, 2, 67, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (940, 2, 55, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (941, 2, 56, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (942, 2, 57, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (943, 2, 89, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (944, 2, 94, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (945, 2, 95, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (946, 2, 96, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (947, 2, 3, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (948, 2, 4, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (949, 2, 16, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (950, 2, 17, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (951, 2, 18, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (952, 2, 19, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (953, 2, 87, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (954, 2, 124, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (955, 2, 5, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (956, 2, 37, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (957, 2, 38, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (958, 2, 39, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (959, 2, 40, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (960, 2, 6, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (961, 2, 41, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (962, 2, 42, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (963, 2, 43, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (964, 2, 15, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (965, 2, 44, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (966, 2, 45, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (967, 2, 46, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (968, 2, 47, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (969, 2, 48, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (970, 2, 49, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (971, 2, 7, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (972, 2, 83, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (973, 2, 84, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (974, 2, 85, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (975, 2, 86, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (976, 2, 8, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (977, 2, 9, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (978, 2, 10, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (979, 2, 11, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (980, 2, 12, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (981, 2, 13, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (982, 2, 14, '2026-01-21 20:12:27');
INSERT INTO `sys_user_menu` VALUES (983, 1, 1, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (984, 1, 2, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (985, 1, 125, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (986, 1, 126, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (987, 1, 127, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (988, 1, 128, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (989, 1, 129, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (990, 1, 130, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (991, 1, 131, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (992, 1, 132, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (993, 1, 133, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (994, 1, 134, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (995, 1, 135, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (996, 1, 136, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (997, 1, 137, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (998, 1, 138, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (999, 1, 139, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1000, 1, 140, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1001, 1, 141, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1002, 1, 90, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1003, 1, 97, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1004, 1, 100, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1005, 1, 101, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1006, 1, 102, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1007, 1, 103, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1008, 1, 104, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1009, 1, 105, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1010, 1, 118, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1011, 1, 98, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1012, 1, 106, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1013, 1, 107, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1014, 1, 108, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1015, 1, 109, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1016, 1, 110, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1017, 1, 111, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1018, 1, 119, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1019, 1, 99, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1020, 1, 112, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1021, 1, 113, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1022, 1, 114, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1023, 1, 115, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1024, 1, 116, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1025, 1, 117, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1026, 1, 88, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1027, 1, 68, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1028, 1, 58, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1029, 1, 59, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1030, 1, 60, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1031, 1, 69, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1032, 1, 61, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1033, 1, 62, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1034, 1, 63, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1035, 1, 70, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1036, 1, 64, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1037, 1, 65, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1038, 1, 66, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1039, 1, 50, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1040, 1, 67, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1041, 1, 55, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1042, 1, 56, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1043, 1, 57, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1044, 1, 89, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1045, 1, 94, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1046, 1, 95, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1047, 1, 96, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1048, 1, 142, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1049, 1, 143, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1050, 1, 144, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1051, 1, 145, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1052, 1, 3, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1053, 1, 4, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1054, 1, 16, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1055, 1, 17, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1056, 1, 18, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1057, 1, 19, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1058, 1, 87, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1059, 1, 124, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1060, 1, 5, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1061, 1, 37, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1062, 1, 38, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1063, 1, 39, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1064, 1, 40, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1065, 1, 6, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1066, 1, 41, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1067, 1, 42, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1068, 1, 43, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1069, 1, 15, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1070, 1, 44, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1071, 1, 45, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1072, 1, 46, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1073, 1, 47, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1074, 1, 48, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1075, 1, 49, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1076, 1, 7, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1077, 1, 83, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1078, 1, 84, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1079, 1, 85, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1080, 1, 86, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1081, 1, 8, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1082, 1, 9, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1083, 1, 10, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1084, 1, 11, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1085, 1, 12, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1086, 1, 13, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1087, 1, 14, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1088, 1, 146, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1089, 1, 147, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1090, 1, 148, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1091, 1, 149, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1092, 1, 150, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1093, 1, 151, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1094, 1, 152, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1095, 1, 153, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1096, 1, 154, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1097, 1, 155, '2026-01-29 18:38:48');
INSERT INTO `sys_user_menu` VALUES (1098, 1, 156, '2026-01-29 18:38:48');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (76, 2, 3, '2026-01-03 16:43:14');
INSERT INTO `sys_user_role` VALUES (77, 2, 6, '2026-01-03 16:43:14');
INSERT INTO `sys_user_role` VALUES (80, 1, 1, '2026-01-21 19:48:52');

SET FOREIGN_KEY_CHECKS = 1;
