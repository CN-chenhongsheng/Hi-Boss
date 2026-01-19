/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : sushe_management

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 19/01/2026 20:42:02
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学年表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_flow
-- ----------------------------
INSERT INTO `sys_approval_flow` VALUES (1, '入住流程', '#001', 'check_in', '这是一个入住管理的配置流程。', 1, NULL, '2026-01-17 22:16:19', 1, '2026-01-19 11:56:38', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程绑定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_flow_binding
-- ----------------------------
INSERT INTO `sys_approval_flow_binding` VALUES (6, 'check_in', 1, 1, NULL, '2026-01-19 12:14:08', 1, '2026-01-19 12:14:08', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批实例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_instance
-- ----------------------------
INSERT INTO `sys_approval_instance` VALUES (1, 1, '入住管理', 'check_in', 1, 14, '张三', 1, '已完成', 2, '2026-01-17 22:42:51', '2026-01-17 23:24:37', NULL, '2026-01-17 22:42:51', 14, '2026-01-17 22:42:51', 14);
INSERT INTO `sys_approval_instance` VALUES (2, 1, '入住管理', 'check_in', 2, 14, '张三', 1, '管理员', 1, '2026-01-17 23:28:26', NULL, NULL, '2026-01-17 23:28:26', 14, '2026-01-17 23:28:26', 14);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批流程节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_node
-- ----------------------------
INSERT INTO `sys_approval_node` VALUES (1, 1, '管理员', 1, 1, 1, NULL, '2026-01-19 11:56:38', 1, '2026-01-19 11:56:38', 1);
INSERT INTO `sys_approval_node` VALUES (2, 1, '二次管理员', 2, 1, 1, NULL, '2026-01-19 11:56:38', 1, '2026-01-19 11:56:38', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批节点审批人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_node_assignee
-- ----------------------------
INSERT INTO `sys_approval_node_assignee` VALUES (7, 1, 2, 1, '2026-01-19 11:56:38', 1);
INSERT INTO `sys_approval_node_assignee` VALUES (8, 2, 2, 1, '2026-01-19 11:56:38', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_approval_record
-- ----------------------------

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
INSERT INTO `sys_bed` VALUES (13, '1', '1', 51, '101', 1, 'A001', 'CAMPUS001', NULL, 1, NULL, NULL, '2026-01-01', '2026-06-01', 1, 1, NULL, '2026-01-06 16:07:49', 1, '2026-01-06 16:47:07', 1);
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
INSERT INTO `sys_campus` VALUES (1, 'CAMPUS001', '主校区', '北京市海淀区中关村大街1号', '张三', 1, 1, '2025-12-31 12:51:08', NULL, '2026-01-01 20:42:06', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '入住管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_check_in
-- ----------------------------
INSERT INTO `sys_check_in` VALUES (2, 14, '张三', '2021001', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-01-17', NULL, 1, 2, NULL, NULL, NULL, NULL, '1111', NULL, '2026-01-17 23:28:26', 14, '2026-01-17 23:28:26', 14);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_check_out
-- ----------------------------

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
INSERT INTO `sys_department` VALUES (1, 'CS001', '计算机科学与技术学院', 'CAMPUS001', '李四', '010-12345678', 1, 1, '2025-12-31 12:51:11', NULL, '2026-01-06 15:32:01', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_dict_data` VALUES (207, 'business_type', '入住申请', 'check_in', NULL, NULL, 1, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (208, 'business_type', '调宿申请', 'transfer', NULL, NULL, 2, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (209, 'business_type', '退宿申请', 'check_out', NULL, NULL, 3, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);
INSERT INTO `sys_dict_data` VALUES (210, 'business_type', '留宿申请', 'stay', NULL, NULL, 4, 0, 1, NULL, '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_dict_type` VALUES (43, '审批业务类型', 'business_type', 1, '审批流程关联的业务类型', '2026-01-17 21:40:54', NULL, '2026-01-17 21:40:54', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '工作台', 'M', '/dashboard', '/index/index', NULL, 'ri:pie-chart-line', 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (2, 1, '控制台', 'C', 'console', '/dashboard/console', 'dashboard:console:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (3, 0, '系统管理', 'M', '/system', '/index/index', '', 'ri:user-3-line', 6, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-06 18:12:29', 1);
INSERT INTO `sys_menu` VALUES (4, 3, '用户管理', 'C', 'user', '/system/user', 'system:user:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (5, 3, '角色管理', 'C', 'role', '/system/role', 'system:role:view', NULL, 2, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (6, 3, '菜单管理', 'C', 'menu', '/system/menu', 'system:menu:view', NULL, 3, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (7, 3, '个人中心', 'C', 'user-center', '/system/user-center', 'system:user-center:view', '', 5, 0, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-31 14:44:02', NULL);
INSERT INTO `sys_menu` VALUES (8, 0, '异常页面', 'M', '/exception', '/index/index', '', 'ri:error-warning-line', 7, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-06 18:12:29', 1);
INSERT INTO `sys_menu` VALUES (9, 8, '403', 'C', '403', '/exception/403', 'exception:403:view', NULL, 1, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (10, 8, '404', 'C', '404', '/exception/404', 'exception:404:view', NULL, 2, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (11, 8, '500', 'C', '500', '/exception/500', 'exception:500:view', NULL, 3, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2025-12-30 11:16:38', NULL);
INSERT INTO `sys_menu` VALUES (12, 0, '结果页面', 'M', '/result', '/index/index', '', 'ri:checkbox-circle-line', 8, 1, 1, 1, '2025-12-30 11:16:38', NULL, '2026-01-06 18:12:29', 1);
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
INSERT INTO `sys_menu` VALUES (50, 0, '学校管理', 'M', '/school', '/index/index', '', 'ri:school-line', 5, 1, 1, 1, '2025-12-31 20:01:27', NULL, '2026-01-06 18:12:29', 1);
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
INSERT INTO `sys_menu` VALUES (88, 0, '组织管理', 'M', '/organization', '/index/index', NULL, 'ri:organization-chart', 4, 1, 1, 1, '2026-01-03 12:45:25', NULL, '2026-01-06 18:12:29', NULL);
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
INSERT INTO `sys_menu` VALUES (142, 0, '审批管理', 'M', '/approval', '/index/index', '', 'ri:flow-chart', 3, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:32:18', 1);
INSERT INTO `sys_menu` VALUES (143, 142, '流程配置', 'C', 'flow-config', '/approval/flow-config', NULL, '', 1, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:12', NULL);
INSERT INTO `sys_menu` VALUES (144, 142, '待办审批', 'C', 'pending', '/approval/pending', NULL, '', 2, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:15', NULL);
INSERT INTO `sys_menu` VALUES (145, 142, '审批记录', 'C', 'history', '/approval/history', NULL, '', 3, 1, 1, 1, '2026-01-17 16:30:53', NULL, '2026-01-17 16:35:18', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 238 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '编辑', 2, 'com.sushe.backend.controller.system.SysCampusController.update()', 'PUT', 1, 'superAdmin', NULL, '/api/v1/system/campus/1', '1.1.1.1', '', '1 {\"id\":1,\"campusCode\":\"CAMPUS001\",\"campusName\":\"主校区\",\"parentCode\":null,\"address\":\"北京市海淀区中关村大街1号\",\"manager\":\"张三\",\"status\":1,\"sort\":1}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767268992082}', 0, '', '2026-01-01 20:03:12', 439);
INSERT INTO `sys_oper_log` VALUES (2, '编辑', 2, 'com.sushe.backend.controller.system.SysCampusController.update()', 'PUT', 1, 'superAdmin', NULL, '/api/v1/system/campus/1', '1.1.1.1', '', '1 {\"id\":1,\"campusCode\":\"CAMPUS001\",\"campusName\":\"主校区\",\"parentCode\":null,\"address\":\"北京市海淀区中关村大街1号\",\"manager\":\"张三\",\"status\":1,\"sort\":1}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767269413036}', 0, '', '2026-01-01 20:10:13', 744);
INSERT INTO `sys_oper_log` VALUES (3, '校区管理-编辑校区(主校区)', 2, 'com.sushe.backend.controller.system.SysCampusController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/campus/1', '1.1.1.1', '', '1 {\"id\":1,\"campusCode\":\"CAMPUS001\",\"campusName\":\"主校区\",\"parentCode\":null,\"address\":\"北京市海淀区中关村大街1号\",\"manager\":\"张三\",\"status\":1,\"sort\":1}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767271326022}', 0, '', '2026-01-01 20:42:06', 174);
INSERT INTO `sys_oper_log` VALUES (4, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '', 0, '', '2026-01-02 18:05:55', 2);
INSERT INTO `sys_oper_log` VALUES (5, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '', 0, '', '2026-01-02 18:05:57', 0);
INSERT INTO `sys_oper_log` VALUES (6, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '', 0, '', '2026-01-02 18:10:26', 2);
INSERT INTO `sys_oper_log` VALUES (7, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348889238}', 0, '', '2026-01-02 18:14:49', 199);
INSERT INTO `sys_oper_log` VALUES (8, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348954077}', 0, '', '2026-01-02 18:15:54', 79);
INSERT INTO `sys_oper_log` VALUES (9, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348959578}', 0, '', '2026-01-02 18:16:00', 21);
INSERT INTO `sys_oper_log` VALUES (10, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348965247}', 0, '', '2026-01-02 18:16:05', 15);
INSERT INTO `sys_oper_log` VALUES (11, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348972317}', 0, '', '2026-01-02 18:16:12', 70);
INSERT INTO `sys_oper_log` VALUES (12, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767348994882}', 0, '', '2026-01-02 18:16:35', 20);
INSERT INTO `sys_oper_log` VALUES (13, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349061309}', 0, '', '2026-01-02 18:17:41', 27);
INSERT INTO `sys_oper_log` VALUES (14, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349088351}', 0, '', '2026-01-02 18:18:08', 44);
INSERT INTO `sys_oper_log` VALUES (15, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349132504}', 0, '', '2026-01-02 18:18:53', 23);
INSERT INTO `sys_oper_log` VALUES (16, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349307433}', 0, '', '2026-01-02 18:21:47', 78);
INSERT INTO `sys_oper_log` VALUES (17, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349494340}', 0, '', '2026-01-02 18:24:54', 44);
INSERT INTO `sys_oper_log` VALUES (18, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349644233}', 0, '', '2026-01-02 18:27:24', 55);
INSERT INTO `sys_oper_log` VALUES (19, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349655399}', 0, '', '2026-01-02 18:27:35', 20);
INSERT INTO `sys_oper_log` VALUES (20, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349691360}', 0, '', '2026-01-02 18:28:11', 47);
INSERT INTO `sys_oper_log` VALUES (21, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349698546}', 0, '', '2026-01-02 18:28:19', 19);
INSERT INTO `sys_oper_log` VALUES (22, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349701659}', 0, '', '2026-01-02 18:28:22', 17);
INSERT INTO `sys_oper_log` VALUES (23, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349714200}', 0, '', '2026-01-02 18:28:34', 20);
INSERT INTO `sys_oper_log` VALUES (24, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767349718795}', 0, '', '2026-01-02 18:28:39', 17);
INSERT INTO `sys_oper_log` VALUES (25, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350053489}', 0, '', '2026-01-02 18:34:13', 70);
INSERT INTO `sys_oper_log` VALUES (26, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350057557}', 0, '', '2026-01-02 18:34:18', 16);
INSERT INTO `sys_oper_log` VALUES (27, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350061954}', 0, '', '2026-01-02 18:34:22', 25);
INSERT INTO `sys_oper_log` VALUES (28, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350069024}', 0, '', '2026-01-02 18:34:29', 29);
INSERT INTO `sys_oper_log` VALUES (29, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350073683}', 0, '', '2026-01-02 18:34:34', 68);
INSERT INTO `sys_oper_log` VALUES (30, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350078593}', 0, '', '2026-01-02 18:34:39', 22);
INSERT INTO `sys_oper_log` VALUES (31, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350256546}', 0, '', '2026-01-02 18:37:37', 31);
INSERT INTO `sys_oper_log` VALUES (32, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350261573}', 0, '', '2026-01-02 18:37:42', 12);
INSERT INTO `sys_oper_log` VALUES (33, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350272007}', 0, '', '2026-01-02 18:37:52', 42);
INSERT INTO `sys_oper_log` VALUES (34, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350275225}', 0, '', '2026-01-02 18:37:55', 33);
INSERT INTO `sys_oper_log` VALUES (35, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350279692}', 0, '', '2026-01-02 18:38:00', 16);
INSERT INTO `sys_oper_log` VALUES (36, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350285241}', 0, '', '2026-01-02 18:38:05', 16);
INSERT INTO `sys_oper_log` VALUES (37, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350289808}', 0, '', '2026-01-02 18:38:10', 13);
INSERT INTO `sys_oper_log` VALUES (38, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350292388}', 0, '', '2026-01-02 18:38:12', 20);
INSERT INTO `sys_oper_log` VALUES (39, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350294872}', 0, '', '2026-01-02 18:38:15', 26);
INSERT INTO `sys_oper_log` VALUES (40, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350301823}', 0, '', '2026-01-02 18:38:22', 23);
INSERT INTO `sys_oper_log` VALUES (41, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350305848}', 0, '', '2026-01-02 18:38:26', 19);
INSERT INTO `sys_oper_log` VALUES (42, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350472979}', 0, '', '2026-01-02 18:41:13', 345);
INSERT INTO `sys_oper_log` VALUES (43, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350479780}', 0, '', '2026-01-02 18:41:20', 19);
INSERT INTO `sys_oper_log` VALUES (44, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767350511227}', 0, '', '2026-01-02 18:41:51', 15);
INSERT INTO `sys_oper_log` VALUES (45, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767351117329}', 0, '', '2026-01-02 18:51:57', 33);
INSERT INTO `sys_oper_log` VALUES (46, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363187449}', 0, '', '2026-01-02 22:13:07', 2149);
INSERT INTO `sys_oper_log` VALUES (47, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363193414}', 0, '', '2026-01-02 22:13:13', 314);
INSERT INTO `sys_oper_log` VALUES (48, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363200204}', 0, '', '2026-01-02 22:13:20', 202);
INSERT INTO `sys_oper_log` VALUES (49, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363523216}', 0, '', '2026-01-02 22:18:43', 122);
INSERT INTO `sys_oper_log` VALUES (50, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363668070}', 0, '', '2026-01-02 22:21:08', 124);
INSERT INTO `sys_oper_log` VALUES (51, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363682427}', 0, '', '2026-01-02 22:21:22', 203);
INSERT INTO `sys_oper_log` VALUES (52, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363703580}', 0, '', '2026-01-02 22:21:44', 144);
INSERT INTO `sys_oper_log` VALUES (53, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363733052}', 0, '', '2026-01-02 22:22:13', 133);
INSERT INTO `sys_oper_log` VALUES (54, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363735837}', 0, '', '2026-01-02 22:22:16', 108);
INSERT INTO `sys_oper_log` VALUES (55, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363737652}', 0, '', '2026-01-02 22:22:18', 129);
INSERT INTO `sys_oper_log` VALUES (56, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363740082}', 0, '', '2026-01-02 22:22:20', 113);
INSERT INTO `sys_oper_log` VALUES (57, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767363742649}', 0, '', '2026-01-02 22:22:23', 173);
INSERT INTO `sys_oper_log` VALUES (58, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364121763}', 0, '', '2026-01-02 22:28:42', 296);
INSERT INTO `sys_oper_log` VALUES (59, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364132768}', 0, '', '2026-01-02 22:28:53', 156);
INSERT INTO `sys_oper_log` VALUES (60, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364173887}', 0, '', '2026-01-02 22:29:34', 310);
INSERT INTO `sys_oper_log` VALUES (61, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364194311}', 0, '', '2026-01-02 22:29:54', 174);
INSERT INTO `sys_oper_log` VALUES (62, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364423170}', 0, '', '2026-01-02 22:33:43', 400);
INSERT INTO `sys_oper_log` VALUES (63, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364429126}', 0, '', '2026-01-02 22:33:49', 528);
INSERT INTO `sys_oper_log` VALUES (64, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364458864}', 0, '', '2026-01-02 22:34:19', 133);
INSERT INTO `sys_oper_log` VALUES (65, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364522247}', 0, '', '2026-01-02 22:35:22', 115);
INSERT INTO `sys_oper_log` VALUES (66, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364712484}', 0, '', '2026-01-02 22:38:32', 215);
INSERT INTO `sys_oper_log` VALUES (67, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364825483}', 0, '', '2026-01-02 22:40:25', 166);
INSERT INTO `sys_oper_log` VALUES (68, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364879985}', 0, '', '2026-01-02 22:41:20', 83);
INSERT INTO `sys_oper_log` VALUES (69, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364903398}', 0, '', '2026-01-02 22:41:43', 135);
INSERT INTO `sys_oper_log` VALUES (70, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364907492}', 0, '', '2026-01-02 22:41:47', 152);
INSERT INTO `sys_oper_log` VALUES (71, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767364977066}', 0, '', '2026-01-02 22:42:57', 86);
INSERT INTO `sys_oper_log` VALUES (72, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365133162}', 0, '', '2026-01-02 22:45:33', 245);
INSERT INTO `sys_oper_log` VALUES (73, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365227202}', 0, '', '2026-01-02 22:47:07', 222);
INSERT INTO `sys_oper_log` VALUES (74, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365233226}', 0, '', '2026-01-02 22:47:13', 276);
INSERT INTO `sys_oper_log` VALUES (75, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365255918}', 0, '', '2026-01-02 22:47:36', 85);
INSERT INTO `sys_oper_log` VALUES (76, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365281578}', 0, '', '2026-01-02 22:48:02', 96);
INSERT INTO `sys_oper_log` VALUES (77, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365285611}', 0, '', '2026-01-02 22:48:06', 97);
INSERT INTO `sys_oper_log` VALUES (78, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365341543}', 0, '', '2026-01-02 22:49:02', 113);
INSERT INTO `sys_oper_log` VALUES (79, '班级管理-新增班级(2023级AI算法1班)', 1, 'com.sushe.backend.controller.system.SysClassController.add()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/class', '0:0:0:0:0:0:0:1', '', '{\"id\":null,\"classCode\":\"CS-SE202302\",\"className\":\"2023级AI算法1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacher\":null,\"enrollmentYear\":2026,\"currentCount\":15,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767365469182}', 0, '', '2026-01-02 22:51:09', 509);
INSERT INTO `sys_oper_log` VALUES (80, '班级管理-编辑班级(2023级AI算法1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2', '0:0:0:0:0:0:0:1', '', '2 {\"id\":2,\"classCode\":\"CS-SE202302\",\"className\":\"2023级AI算法1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacher\":null,\"enrollmentYear\":2025,\"currentCount\":15,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767365480870}', 0, '', '2026-01-02 22:51:21', 145);
INSERT INTO `sys_oper_log` VALUES (81, '班级管理-编辑班级(2023级软件工程1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1', '0:0:0:0:0:0:0:1', '', '1 {\"id\":1,\"classCode\":\"CS-SE202301\",\"className\":\"2023级软件工程1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacher\":\"赵六\",\"enrollmentYear\":2025,\"currentCount\":30,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767365489010}', 0, '', '2026-01-02 22:51:29', 1041);
INSERT INTO `sys_oper_log` VALUES (82, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365498699}', 0, '', '2026-01-02 22:51:39', 151);
INSERT INTO `sys_oper_log` VALUES (83, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365523099}', 0, '', '2026-01-02 22:52:03', 138);
INSERT INTO `sys_oper_log` VALUES (84, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365529001}', 0, '', '2026-01-02 22:52:09', 184);
INSERT INTO `sys_oper_log` VALUES (85, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365631969}', 0, '', '2026-01-02 22:53:52', 244);
INSERT INTO `sys_oper_log` VALUES (86, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365635125}', 0, '', '2026-01-02 22:53:55', 306);
INSERT INTO `sys_oper_log` VALUES (87, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365637532}', 0, '', '2026-01-02 22:53:58', 417);
INSERT INTO `sys_oper_log` VALUES (88, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365712702}', 0, '', '2026-01-02 22:55:13', 143);
INSERT INTO `sys_oper_log` VALUES (89, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365937194}', 0, '', '2026-01-02 22:58:57', 142);
INSERT INTO `sys_oper_log` VALUES (90, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767365989349}', 0, '', '2026-01-02 22:59:49', 134);
INSERT INTO `sys_oper_log` VALUES (91, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366326562}', 0, '', '2026-01-02 23:05:27', 160);
INSERT INTO `sys_oper_log` VALUES (92, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366403716}', 0, '', '2026-01-02 23:06:44', 91);
INSERT INTO `sys_oper_log` VALUES (93, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366410248}', 0, '', '2026-01-02 23:06:50', 103);
INSERT INTO `sys_oper_log` VALUES (94, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366513294}', 0, '', '2026-01-02 23:08:33', 130);
INSERT INTO `sys_oper_log` VALUES (95, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366950565}', 0, '', '2026-01-02 23:15:51', 155);
INSERT INTO `sys_oper_log` VALUES (96, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366969846}', 0, '', '2026-01-02 23:16:10', 145);
INSERT INTO `sys_oper_log` VALUES (97, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366976626}', 0, '', '2026-01-02 23:16:17', 303);
INSERT INTO `sys_oper_log` VALUES (98, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366980431}', 0, '', '2026-01-02 23:16:20', 150);
INSERT INTO `sys_oper_log` VALUES (99, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366983149}', 0, '', '2026-01-02 23:16:23', 135);
INSERT INTO `sys_oper_log` VALUES (100, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366985388}', 0, '', '2026-01-02 23:16:25', 125);
INSERT INTO `sys_oper_log` VALUES (101, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366990042}', 0, '', '2026-01-02 23:16:30', 103);
INSERT INTO `sys_oper_log` VALUES (102, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366992801}', 0, '', '2026-01-02 23:16:33', 137);
INSERT INTO `sys_oper_log` VALUES (103, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767366996118}', 0, '', '2026-01-02 23:16:36', 101);
INSERT INTO `sys_oper_log` VALUES (104, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367001476}', 0, '', '2026-01-02 23:16:41', 110);
INSERT INTO `sys_oper_log` VALUES (105, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367050960}', 0, '', '2026-01-02 23:17:31', 444);
INSERT INTO `sys_oper_log` VALUES (106, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367072028}', 0, '', '2026-01-02 23:17:52', 152);
INSERT INTO `sys_oper_log` VALUES (107, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367074533}', 0, '', '2026-01-02 23:17:55', 103);
INSERT INTO `sys_oper_log` VALUES (108, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367099099}', 0, '', '2026-01-02 23:18:19', 249);
INSERT INTO `sys_oper_log` VALUES (109, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367099810}', 0, '', '2026-01-02 23:18:20', 145);
INSERT INTO `sys_oper_log` VALUES (110, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367102125}', 0, '', '2026-01-02 23:18:22', 87);
INSERT INTO `sys_oper_log` VALUES (111, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367104925}', 0, '', '2026-01-02 23:18:25', 126);
INSERT INTO `sys_oper_log` VALUES (112, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367107377}', 0, '', '2026-01-02 23:18:27', 160);
INSERT INTO `sys_oper_log` VALUES (113, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367130266}', 0, '', '2026-01-02 23:18:50', 366);
INSERT INTO `sys_oper_log` VALUES (114, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367131614}', 0, '', '2026-01-02 23:18:52', 153);
INSERT INTO `sys_oper_log` VALUES (115, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367139732}', 0, '', '2026-01-02 23:19:00', 414);
INSERT INTO `sys_oper_log` VALUES (116, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367229902}', 0, '', '2026-01-02 23:20:30', 117);
INSERT INTO `sys_oper_log` VALUES (117, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367235963}', 0, '', '2026-01-02 23:20:36', 167);
INSERT INTO `sys_oper_log` VALUES (118, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367250147}', 0, '', '2026-01-02 23:20:50', 103);
INSERT INTO `sys_oper_log` VALUES (119, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367694518}', 0, '', '2026-01-02 23:28:15', 231);
INSERT INTO `sys_oper_log` VALUES (120, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767367712330}', 0, '', '2026-01-02 23:28:32', 133);
INSERT INTO `sys_oper_log` VALUES (121, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767421853415}', 0, '', '2026-01-03 14:30:53', 137);
INSERT INTO `sys_oper_log` VALUES (122, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767423475439}', 0, '', '2026-01-03 14:57:56', 14297);
INSERT INTO `sys_oper_log` VALUES (123, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767423490113}', 0, '', '2026-01-03 14:58:10', 284);
INSERT INTO `sys_oper_log` VALUES (124, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767423610872}', 0, '', '2026-01-03 15:00:11', 241);
INSERT INTO `sys_oper_log` VALUES (125, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767423761050}', 0, '', '2026-01-03 15:02:41', 253);
INSERT INTO `sys_oper_log` VALUES (126, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767424060630}', 0, '', '2026-01-03 15:07:41', 359);
INSERT INTO `sys_oper_log` VALUES (127, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767424413164}', 0, '', '2026-01-03 15:13:33', 215);
INSERT INTO `sys_oper_log` VALUES (128, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767424418697}', 0, '', '2026-01-03 15:13:39', 139);
INSERT INTO `sys_oper_log` VALUES (129, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767424756200}', 0, '', '2026-01-03 15:19:16', 370);
INSERT INTO `sys_oper_log` VALUES (130, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425147596}', 0, '', '2026-01-03 15:25:48', 249);
INSERT INTO `sys_oper_log` VALUES (131, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425151015}', 0, '', '2026-01-03 15:25:51', 139);
INSERT INTO `sys_oper_log` VALUES (132, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425443774}', 0, '', '2026-01-03 15:30:44', 202);
INSERT INTO `sys_oper_log` VALUES (133, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425461040}', 0, '', '2026-01-03 15:31:01', 209);
INSERT INTO `sys_oper_log` VALUES (134, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425544708}', 0, '', '2026-01-03 15:32:25', 163);
INSERT INTO `sys_oper_log` VALUES (135, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425698493}', 0, '', '2026-01-03 15:34:58', 262);
INSERT INTO `sys_oper_log` VALUES (136, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767425810063}', 0, '', '2026-01-03 15:36:50', 520);
INSERT INTO `sys_oper_log` VALUES (137, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426454647}', 0, '', '2026-01-03 15:47:35', 174);
INSERT INTO `sys_oper_log` VALUES (138, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426835639}', 0, '', '2026-01-03 15:53:56', 318);
INSERT INTO `sys_oper_log` VALUES (139, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426875219}', 0, '', '2026-01-03 15:54:35', 57);
INSERT INTO `sys_oper_log` VALUES (140, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426950535}', 0, '', '2026-01-03 15:55:51', 156);
INSERT INTO `sys_oper_log` VALUES (141, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426955045}', 0, '', '2026-01-03 15:55:55', 874);
INSERT INTO `sys_oper_log` VALUES (142, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426957896}', 0, '', '2026-01-03 15:55:58', 146);
INSERT INTO `sys_oper_log` VALUES (143, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426960106}', 0, '', '2026-01-03 15:56:00', 185);
INSERT INTO `sys_oper_log` VALUES (144, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426963280}', 0, '', '2026-01-03 15:56:03', 134);
INSERT INTO `sys_oper_log` VALUES (145, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767426968493}', 0, '', '2026-01-03 15:56:08', 101);
INSERT INTO `sys_oper_log` VALUES (146, '班级管理-编辑班级(2023级软件工程1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1', '0:0:0:0:0:0:0:1', '', '1 {\"id\":1,\"classCode\":\"CS-SE202301\",\"className\":\"2023级软件工程1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacher\":null,\"enrollmentYear\":2025,\"currentCount\":30,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767427507986}', 0, '', '2026-01-03 16:05:08', 1126);
INSERT INTO `sys_oper_log` VALUES (147, '班级管理-编辑班级(2023级软件工程1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1', '0:0:0:0:0:0:0:1', '', '1 {\"id\":1,\"classCode\":\"CS-SE202301\",\"className\":\"2023级软件工程1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacher\":null,\"enrollmentYear\":2025,\"currentCount\":30,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767427514347}', 0, '', '2026-01-03 16:05:14', 453);
INSERT INTO `sys_oper_log` VALUES (148, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767428105047}', 0, '', '2026-01-03 16:15:05', 213);
INSERT INTO `sys_oper_log` VALUES (149, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767428119818}', 0, '', '2026-01-03 16:15:20', 107);
INSERT INTO `sys_oper_log` VALUES (150, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '0:0:0:0:0:0:0:1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767431711929}', 0, '', '2026-01-03 17:15:12', 333);
INSERT INTO `sys_oper_log` VALUES (151, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767451216482}', 0, '', '2026-01-03 22:40:17', 295);
INSERT INTO `sys_oper_log` VALUES (152, '楼层管理-新增楼层', 1, 'com.sushe.backend.controller.system.SysFloorController.add()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/floor', '1.1.1.1', '', '{\"id\":null,\"floorCode\":\"A001\",\"floorName\":\"科学园A座\",\"floorNumber\":5,\"campusCode\":\"CAMPUS001\",\"genderType\":1,\"sort\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767511755249}', 0, '', '2026-01-04 15:29:15', 539);
INSERT INTO `sys_oper_log` VALUES (153, '楼层管理-编辑楼层(ID:1)', 2, 'com.sushe.backend.controller.system.SysFloorController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/floor/1', '1.1.1.1', '', '1 {\"id\":1,\"floorCode\":\"A001\",\"floorName\":\"科学园A座\",\"floorNumber\":5,\"campusCode\":\"CAMPUS001\",\"genderType\":1,\"sort\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767596351037}', 0, '', '2026-01-05 14:59:11', 788);
INSERT INTO `sys_oper_log` VALUES (154, '班级管理-编辑班级(2023级软件工程1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1', '1.1.1.1', '', '1 {\"id\":1,\"classCode\":\"CS-SE202301\",\"className\":\"2023级软件工程1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacherId\":2,\"enrollmentYear\":2025,\"currentCount\":30,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767606272014}', 0, '', '2026-01-05 17:44:32', 410);
INSERT INTO `sys_oper_log` VALUES (155, '班级管理-编辑班级(2023级AI算法1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2', '1.1.1.1', '', '2 {\"id\":2,\"classCode\":\"CS-SE202302\",\"className\":\"2023级AI算法1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacherId\":2,\"enrollmentYear\":2025,\"currentCount\":15,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767606275351}', 0, '', '2026-01-05 17:44:35', 80);
INSERT INTO `sys_oper_log` VALUES (156, '班级管理-编辑班级(2023级软件工程1班)', 2, 'com.sushe.backend.controller.system.SysClassController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1', '1.1.1.1', '', '1 {\"id\":1,\"classCode\":\"CS-SE202301\",\"className\":\"2023级软件工程1班\",\"majorCode\":\"CS-SE001\",\"grade\":\"2025\",\"teacherId\":null,\"enrollmentYear\":2025,\"currentCount\":30,\"status\":null}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767606279489}', 0, '', '2026-01-05 17:44:39', 72);
INSERT INTO `sys_oper_log` VALUES (157, '字典类型管理-编辑字典类型(ID:15)', 2, 'com.sushe.backend.controller.system.SysDictTypeController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/dict/type/15', '1.1.1.1', '', '15 {\"id\":15,\"dictName\":\"房间设施\",\"dictCode\":\"dormitory_room_facility\",\"status\":1,\"remark\":\"房间设施：空调、独立卫生间、阳台等\"}', '{\"code\":200,\"message\":\"操作成功\",\"data\":null,\"timestamp\":1767615274564}', 0, '', '2026-01-05 20:14:35', 116);
INSERT INTO `sys_oper_log` VALUES (158, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767665813618}', 0, '', '2026-01-06 10:16:54', 105);
INSERT INTO `sys_oper_log` VALUES (159, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767665815938}', 0, '', '2026-01-06 10:16:56', 18);
INSERT INTO `sys_oper_log` VALUES (160, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767665832785}', 0, '', '2026-01-06 10:17:13', 17);
INSERT INTO `sys_oper_log` VALUES (161, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767665839485}', 0, '', '2026-01-06 10:17:19', 14);
INSERT INTO `sys_oper_log` VALUES (162, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767670945498}', 0, '', '2026-01-06 11:42:26', 25);
INSERT INTO `sys_oper_log` VALUES (163, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767670957735}', 0, '', '2026-01-06 11:42:38', 71);
INSERT INTO `sys_oper_log` VALUES (164, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671028567}', 0, '', '2026-01-06 11:43:49', 101);
INSERT INTO `sys_oper_log` VALUES (165, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671034791}', 0, '', '2026-01-06 11:43:55', 12);
INSERT INTO `sys_oper_log` VALUES (166, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671127151}', 0, '', '2026-01-06 11:45:27', 6);
INSERT INTO `sys_oper_log` VALUES (167, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671163234}', 0, '', '2026-01-06 11:46:03', 16);
INSERT INTO `sys_oper_log` VALUES (168, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671187714}', 0, '', '2026-01-06 11:46:28', 7);
INSERT INTO `sys_oper_log` VALUES (169, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671208346}', 0, '', '2026-01-06 11:46:48', 7);
INSERT INTO `sys_oper_log` VALUES (170, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671256194}', 0, '', '2026-01-06 11:47:36', 11);
INSERT INTO `sys_oper_log` VALUES (171, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767671422800}', 0, '', '2026-01-06 11:50:23', 13);
INSERT INTO `sys_oper_log` VALUES (172, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767672247359}', 0, '', '2026-01-06 12:04:07', 12);
INSERT INTO `sys_oper_log` VALUES (173, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767673329509}', 0, '', '2026-01-06 12:22:10', 20);
INSERT INTO `sys_oper_log` VALUES (174, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767680148243}', 0, '', '2026-01-06 14:15:48', 33);
INSERT INTO `sys_oper_log` VALUES (175, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767680971473}', 0, '', '2026-01-06 14:29:31', 30);
INSERT INTO `sys_oper_log` VALUES (176, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767681556772}', 0, '', '2026-01-06 14:39:17', 92);
INSERT INTO `sys_oper_log` VALUES (177, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767683254669}', 0, '', '2026-01-06 15:07:35', 24);
INSERT INTO `sys_oper_log` VALUES (178, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767683381178}', 0, '', '2026-01-06 15:09:41', 8);
INSERT INTO `sys_oper_log` VALUES (179, '修改状态', 2, 'com.sushe.backend.controller.system.SysClassController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2/status/1', '1.1.1.1', '', '2 1', '', 1, '该专业处于停用状态，不允许启用班级', '2026-01-06 16:46:53', 26);
INSERT INTO `sys_oper_log` VALUES (180, '修改状态', 2, 'com.sushe.backend.controller.system.SysMajorController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/major/1/status/1', '1.1.1.1', '', '1 1', '{\"code\":200,\"message\":\"专业已启用\",\"data\":null,\"timestamp\":1767689216626}', 0, '', '2026-01-06 16:46:57', 82);
INSERT INTO `sys_oper_log` VALUES (181, '修改状态', 2, 'com.sushe.backend.controller.system.SysClassController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/1/status/1', '1.1.1.1', '', '1 1', '{\"code\":200,\"message\":\"班级已启用\",\"data\":null,\"timestamp\":1767689219469}', 0, '', '2026-01-06 16:46:59', 454);
INSERT INTO `sys_oper_log` VALUES (182, '修改状态', 2, 'com.sushe.backend.controller.system.SysClassController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/class/2/status/1', '1.1.1.1', '', '2 1', '{\"code\":200,\"message\":\"班级已启用\",\"data\":null,\"timestamp\":1767689219605}', 0, '', '2026-01-06 16:47:00', 136);
INSERT INTO `sys_oper_log` VALUES (183, '修改状态', 2, 'com.sushe.backend.controller.system.SysRoomController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/room/51/status/0', '1.1.1.1', '', '51 0', '{\"code\":200,\"message\":\"房间已停用\",\"data\":null,\"timestamp\":1767689227467}', 0, '', '2026-01-06 16:47:07', 109);
INSERT INTO `sys_oper_log` VALUES (184, '修改状态', 2, 'com.sushe.backend.controller.system.SysBedController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/13/status/1', '1.1.1.1', '', '13 1', '', 1, '该房间处于停用状态，不允许启用床位', '2026-01-06 16:47:13', 5);
INSERT INTO `sys_oper_log` VALUES (185, '修改状态', 2, 'com.sushe.backend.controller.system.SysRoomController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/room/51/status/1', '1.1.1.1', '', '51 1', '{\"code\":200,\"message\":\"房间已启用\",\"data\":null,\"timestamp\":1767689236540}', 0, '', '2026-01-06 16:47:17', 71);
INSERT INTO `sys_oper_log` VALUES (186, '修改状态', 2, 'com.sushe.backend.controller.system.SysBedController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/13/status/1', '1.1.1.1', '', '13 1', '{\"code\":200,\"message\":\"床位已启用\",\"data\":null,\"timestamp\":1767689239884}', 0, '', '2026-01-06 16:47:20', 94);
INSERT INTO `sys_oper_log` VALUES (187, '修改状态', 2, 'com.sushe.backend.controller.system.SysBedController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/14/status/1', '1.1.1.1', '', '14 1', '{\"code\":200,\"message\":\"床位已启用\",\"data\":null,\"timestamp\":1767689241328}', 0, '', '2026-01-06 16:47:21', 105);
INSERT INTO `sys_oper_log` VALUES (188, '修改状态', 2, 'com.sushe.backend.controller.system.SysBedController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/15/status/1', '1.1.1.1', '', '15 1', '{\"code\":200,\"message\":\"床位已启用\",\"data\":null,\"timestamp\":1767689242907}', 0, '', '2026-01-06 16:47:23', 91);
INSERT INTO `sys_oper_log` VALUES (189, '修改状态', 2, 'com.sushe.backend.controller.system.SysBedController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/bed/16/status/1', '1.1.1.1', '', '16 1', '{\"code\":200,\"message\":\"床位已启用\",\"data\":null,\"timestamp\":1767689244577}', 0, '', '2026-01-06 16:47:25', 105);
INSERT INTO `sys_oper_log` VALUES (190, '学校层级管理', 0, 'com.sushe.backend.controller.system.SysSchoolHierarchyController.getFullHierarchy()', 'GET', 1, 'superAdmin', 1, '/api/v1/system/school/hierarchy', '1.1.1.1', '', '', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"campuses\":[{\"id\":1,\"code\":\"CAMPUS001\",\"name\":\"主校区\",\"type\":\"campus\",\"parentCode\":null,\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS001\",\"name\":\"计算机科学与技术学院\",\"type\":\"department\",\"parentCode\":\"CAMPUS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE001\",\"name\":\"软件工程\",\"type\":\"major\",\"parentCode\":\"CS001\",\"status\":1,\"children\":[{\"id\":1,\"code\":\"CS-SE202301\",\"name\":\"2023级软件工程1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null},{\"id\":2,\"code\":\"CS-SE202302\",\"name\":\"2023级AI算法1班\",\"type\":\"class\",\"parentCode\":\"CS-SE001\",\"status\":1,\"children\":null}]}]}]}]},\"timestamp\":1767689881014}', 0, '', '2026-01-06 16:58:01', 31);
INSERT INTO `sys_oper_log` VALUES (191, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '1.1.1.1', '', '1 [1,2,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1767694025810}', 0, '', '2026-01-06 18:07:06', 362);
INSERT INTO `sys_oper_log` VALUES (192, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '1.1.1.1', '', '1 [1,2,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1767694202236}', 0, '', '2026-01-06 18:10:02', 174);
INSERT INTO `sys_oper_log` VALUES (193, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '1.1.1.1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1767694401979}', 0, '', '2026-01-06 18:13:22', 194);
INSERT INTO `sys_oper_log` VALUES (194, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/125', '1.1.1.1', '', '125 {\"id\":125,\"parentId\":0,\"menuName\":\"住宿管理\",\"menuType\":\"M\",\"path\":\"accommodation\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"accommodation\",\"sort\":2,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694463175}', 0, '', '2026-01-06 18:14:23', 186);
INSERT INTO `sys_oper_log` VALUES (195, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/125', '1.1.1.1', '', '125 {\"id\":125,\"parentId\":0,\"menuName\":\"住宿管理\",\"menuType\":\"M\",\"path\":\"/accommodation\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"accommodation\",\"sort\":2,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694474386}', 0, '', '2026-01-06 18:14:34', 105);
INSERT INTO `sys_oper_log` VALUES (196, '分配角色权限', 0, 'com.sushe.backend.controller.system.SysRoleController.assignPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1/permissions', '1.1.1.1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1767694499407}', 0, '', '2026-01-06 18:14:59', 239);
INSERT INTO `sys_oper_log` VALUES (197, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '1.1.1.1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1767694506284}', 0, '', '2026-01-06 18:15:06', 630);
INSERT INTO `sys_oper_log` VALUES (198, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/125', '1.1.1.1', '', '125 {\"id\":125,\"parentId\":0,\"menuName\":\"住宿管理\",\"menuType\":\"M\",\"path\":\"/accommodation\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:community-line\",\"sort\":2,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694729933}', 0, '', '2026-01-06 18:18:50', 98);
INSERT INTO `sys_oper_log` VALUES (199, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/126', '1.1.1.1', '', '126 {\"id\":126,\"parentId\":125,\"menuName\":\"人员管理\",\"menuType\":\"C\",\"path\":\"student\",\"component\":\"accommodation/student/index\",\"permission\":\"\",\"icon\":\"\",\"sort\":1,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694819538}', 0, '', '2026-01-06 18:20:20', 140);
INSERT INTO `sys_oper_log` VALUES (200, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/130', '1.1.1.1', '', '130 {\"id\":130,\"parentId\":125,\"menuName\":\"入住管理\",\"menuType\":\"C\",\"path\":\"check-in\",\"component\":\"accommodation/check-in/index\",\"permission\":\"\",\"icon\":\"\",\"sort\":2,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694824684}', 0, '', '2026-01-06 18:20:25', 105);
INSERT INTO `sys_oper_log` VALUES (201, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/133', '1.1.1.1', '', '133 {\"id\":133,\"parentId\":125,\"menuName\":\"调宿管理\",\"menuType\":\"C\",\"path\":\"transfer\",\"component\":\"accommodation/transfer/index\",\"permission\":\"\",\"icon\":\"\",\"sort\":3,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694829390}', 0, '', '2026-01-06 18:20:29', 61);
INSERT INTO `sys_oper_log` VALUES (202, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/136', '1.1.1.1', '', '136 {\"id\":136,\"parentId\":125,\"menuName\":\"退宿管理\",\"menuType\":\"C\",\"path\":\"check-out\",\"component\":\"accommodation/check-out/index\",\"permission\":\"\",\"icon\":\"\",\"sort\":4,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694833249}', 0, '', '2026-01-06 18:20:33', 80);
INSERT INTO `sys_oper_log` VALUES (203, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/139', '1.1.1.1', '', '139 {\"id\":139,\"parentId\":125,\"menuName\":\"留宿管理\",\"menuType\":\"C\",\"path\":\"stay\",\"component\":\"accommodation/stay/index\",\"permission\":\"\",\"icon\":\"\",\"sort\":5,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1767694837245}', 0, '', '2026-01-06 18:20:37', 63);
INSERT INTO `sys_oper_log` VALUES (204, '修改状态', 2, 'com.sushe.backend.controller.accommodation.SysStudentController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/student/6/status/0', '192.168.0.100', '', '6 0', '{\"code\":200,\"message\":\"学生已停用\",\"data\":null,\"timestamp\":1768054132961}', 0, '', '2026-01-10 22:08:53', 234);
INSERT INTO `sys_oper_log` VALUES (205, '修改状态', 2, 'com.sushe.backend.controller.accommodation.SysStudentController.updateStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/student/6/status/1', '192.168.0.100', '', '6 1', '{\"code\":200,\"message\":\"学生已启用\",\"data\":null,\"timestamp\":1768054133955}', 0, '', '2026-01-10 22:08:54', 125);
INSERT INTO `sys_oper_log` VALUES (206, '编辑菜单', 2, 'com.sushe.backend.controller.system.SysMenuController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/menu/142', '1.1.1.1', '', '142 {\"id\":142,\"parentId\":0,\"menuName\":\"审批管理\",\"menuType\":\"M\",\"path\":\"/approval\",\"component\":\"/index/index\",\"permission\":\"\",\"icon\":\"ri:flow-chart\",\"sort\":3,\"visible\":1,\"status\":1,\"keepAlive\":1}', '{\"code\":200,\"message\":\"菜单编辑成功\",\"data\":null,\"timestamp\":1768638737821}', 0, '', '2026-01-17 16:32:18', 19);
INSERT INTO `sys_oper_log` VALUES (207, '分配角色权限', 0, 'com.sushe.backend.controller.system.SysRoleController.assignPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/1/permissions', '1.1.1.1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768638808594}', 0, '', '2026-01-17 16:33:29', 93);
INSERT INTO `sys_oper_log` VALUES (208, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1/permissions', '1.1.1.1', '', '1 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768638822670}', 0, '', '2026-01-17 16:33:43', 79);
INSERT INTO `sys_oper_log` VALUES (209, '编辑用户', 2, 'com.sushe.backend.controller.system.SysUserController.update()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/1', '192.168.0.107', '', '1 {\"id\":1,\"username\":\"superAdmin\",\"password\":null,\"nickname\":\"超级管理员\",\"avatar\":null,\"email\":\"superAdmin@example.com\",\"phone\":\"17876648229\",\"manageScope\":\"{\\\"campusIds\\\":[1],\\\"departmentIds\\\":[1],\\\"majorIds\\\":[1],\\\"classIds\\\":[2,1]}\",\"status\":1,\"gender\":1,\"address\":null,\"introduction\":null,\"cpUserId\":null,\"openid\":null,\"roleIds\":[1]}', '{\"code\":200,\"message\":\"用户编辑成功\",\"data\":null,\"timestamp\":1768650119470}', 0, '', '2026-01-17 19:41:59', 78);
INSERT INTO `sys_oper_log` VALUES (210, '新增审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.addFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/flow', '192.168.0.107', '', '{\"id\":null,\"flowName\":\"入住管理\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":null,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程新增成功\",\"data\":null,\"timestamp\":1768659379377}', 0, '', '2026-01-17 22:16:19', 86);
INSERT INTO `sys_oper_log` VALUES (211, '编辑审批流程', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.107', '', '1 {\"id\":1,\"flowName\":\"入住管理\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1768660347126}', 0, '', '2026-01-17 22:32:27', 28);
INSERT INTO `sys_oper_log` VALUES (212, '修改审批流程状态', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlowStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1/status/0', '192.168.0.107', '', '1 0', '{\"code\":200,\"message\":\"流程已停用\",\"data\":null,\"timestamp\":1768660552730}', 0, '', '2026-01-17 22:35:53', 9);
INSERT INTO `sys_oper_log` VALUES (213, '修改审批流程状态', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlowStatus()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1/status/1', '192.168.0.107', '', '1 1', '{\"code\":200,\"message\":\"流程已启用\",\"data\":null,\"timestamp\":1768660554007}', 0, '', '2026-01-17 22:35:54', 9);
INSERT INTO `sys_oper_log` VALUES (214, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768660840306}', 0, '', '2026-01-17 22:40:40', 7);
INSERT INTO `sys_oper_log` VALUES (215, '入住管理-新增入住', 1, 'com.sushe.backend.controller.accommodation.SysCheckInController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/check-in', '192.168.0.107', '', 'CheckInSaveDTO(id=null, studentId=14, checkInType=1, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, checkInDate=2026-01-17, expectedCheckOutDate=null, status=null, approverId=null, approverName=null, approveOpinion=null, applyReason=123123, remark=null)', '{\"code\":200,\"message\":\"入住管理新增成功\",\"data\":null,\"timestamp\":1768660970896}', 0, '', '2026-01-17 22:42:51', 32);
INSERT INTO `sys_oper_log` VALUES (216, '分配角色权限', 0, 'com.sushe.backend.controller.system.SysRoleController.assignPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/role/6/permissions', '192.168.0.107', '', '6 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768661697339}', 0, '', '2026-01-17 22:54:57', 67);
INSERT INTO `sys_oper_log` VALUES (217, '分配用户权限', 0, 'com.sushe.backend.controller.system.SysUserController.assignUserPermissions()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/user/2/permissions', '192.168.0.107', '', '2 [1,2,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,90,97,100,101,102,103,104,105,118,98,106,107,108,109,110,111,119,99,112,113,114,115,116,117,142,143,144,145,88,68,58,59,60,69,61,62,63,70,64,65,66,50,67,55,56,57,89,94,95,96,3,4,16,17,18,19,87,124,5,37,38,39,40,6,41,42,43,15,44,45,46,47,48,49,7,83,84,85,86,8,9,10,11,12,13,14]', '{\"code\":200,\"message\":\"权限分配成功\",\"data\":null,\"timestamp\":1768661705102}', 0, '', '2026-01-17 22:55:05', 68);
INSERT INTO `sys_oper_log` VALUES (218, '执行审批', 0, 'com.sushe.backend.controller.system.SysApprovalController.doApprove()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/approve', '192.168.0.107', '', '{\"instanceId\":1,\"action\":1,\"opinion\":\"允许\"}', '{\"code\":200,\"message\":\"审批成功\",\"data\":null,\"timestamp\":1768663477200}', 0, '', '2026-01-17 23:24:37', 52);
INSERT INTO `sys_oper_log` VALUES (219, '入住管理-删除入住(ID:1)', 3, 'com.sushe.backend.controller.accommodation.SysCheckInController.delete()', 'DELETE', 1, 'superAdmin', 1, '/api/v1/system/check-in/1', '192.168.0.107', '', '1', '{\"code\":200,\"message\":\"入住管理删除成功\",\"data\":null,\"timestamp\":1768663687950}', 0, '', '2026-01-17 23:28:08', 7);
INSERT INTO `sys_oper_log` VALUES (220, '入住管理-新增入住', 1, 'com.sushe.backend.controller.accommodation.SysCheckInController.add()', 'POST', 1, '2021001', 2, '/api/v1/system/check-in', '192.168.0.107', '', 'CheckInSaveDTO(id=null, studentId=14, checkInType=1, campusCode=null, floorCode=null, roomId=null, roomCode=null, bedId=null, bedCode=null, applyDate=null, checkInDate=2026-01-17, expectedCheckOutDate=null, status=null, approverId=null, approverName=null, approveOpinion=null, applyReason=1111, remark=null)', '{\"code\":200,\"message\":\"入住管理新增成功\",\"data\":null,\"timestamp\":1768663705881}', 0, '', '2026-01-17 23:28:26', 16);
INSERT INTO `sys_oper_log` VALUES (221, '编辑审批流程', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.107', '', '1 {\"id\":1,\"flowName\":\"入住管理\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]},{\"id\":null,\"nodeName\":\"二次管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1768664982290}', 0, '', '2026-01-17 23:49:42', 10);
INSERT INTO `sys_oper_log` VALUES (222, '编辑审批流程', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.107', '', '1 {\"id\":1,\"flowName\":\"入住管理\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]},{\"id\":2,\"nodeName\":\"二次管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1768794984173}', 0, '', '2026-01-19 11:56:24', 45);
INSERT INTO `sys_oper_log` VALUES (223, '编辑审批流程', 2, 'com.sushe.backend.controller.system.SysApprovalController.updateFlow()', 'PUT', 1, 'superAdmin', 1, '/api/v1/system/approval/flow/1', '192.168.0.107', '', '1 {\"id\":1,\"flowName\":\"入住流程\",\"flowCode\":\"#001\",\"businessType\":\"check_in\",\"description\":\"这是一个入住管理的配置流程。\",\"status\":1,\"remark\":null,\"nodes\":[{\"id\":1,\"nodeName\":\"管理员\",\"nodeOrder\":1,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]},{\"id\":2,\"nodeName\":\"二次管理员\",\"nodeOrder\":2,\"nodeType\":1,\"rejectAction\":1,\"remark\":null,\"assignees\":[{\"assigneeType\":2,\"assigneeId\":1,\"assigneeName\":\"超级管理员\"}]}]}', '{\"code\":200,\"message\":\"流程编辑成功\",\"data\":null,\"timestamp\":1768794997604}', 0, '', '2026-01-19 11:56:38', 15);
INSERT INTO `sys_oper_log` VALUES (224, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":0,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795607211}', 0, '', '2026-01-19 12:06:47', 7);
INSERT INTO `sys_oper_log` VALUES (225, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\r\n### The error may exist in com/sushe/backend/mapper/SysApprovalFlowBindingMapper.java (best guess)\r\n### The error may involve com.sushe.backend.mapper.SysApprovalFlowBindingMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO sys_approval_flow_binding  ( business_type, flow_id, status,  create_time, update_time, create_by, update_by )  VALUES (  ?, ?, ?,  ?, ?, ?, ?  )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\n; Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'', '2026-01-19 12:06:49', 222);
INSERT INTO `sys_oper_log` VALUES (226, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\r\n### The error may exist in com/sushe/backend/mapper/SysApprovalFlowBindingMapper.java (best guess)\r\n### The error may involve com.sushe.backend.mapper.SysApprovalFlowBindingMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO sys_approval_flow_binding  ( business_type, flow_id, status,  create_time, update_time, create_by, update_by )  VALUES (  ?, ?, ?,  ?, ?, ?, ?  )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\n; Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'', '2026-01-19 12:06:51', 4);
INSERT INTO `sys_oper_log` VALUES (227, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\r\n### The error may exist in com/sushe/backend/mapper/SysApprovalFlowBindingMapper.java (best guess)\r\n### The error may involve com.sushe.backend.mapper.SysApprovalFlowBindingMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO sys_approval_flow_binding  ( business_type, flow_id, status,  create_time, update_time, create_by, update_by )  VALUES (  ?, ?, ?,  ?, ?, ?, ?  )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\n; Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'', '2026-01-19 12:07:21', 13);
INSERT INTO `sys_oper_log` VALUES (228, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\r\n### The error may exist in com/sushe/backend/mapper/SysApprovalFlowBindingMapper.java (best guess)\r\n### The error may involve com.sushe.backend.mapper.SysApprovalFlowBindingMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO sys_approval_flow_binding  ( business_type, flow_id, status,  create_time, update_time, create_by, update_by )  VALUES (  ?, ?, ?,  ?, ?, ?, ?  )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'\n; Duplicate entry \'check_in\' for key \'sys_approval_flow_binding.uk_business_type\'', '2026-01-19 12:09:36', 5);
INSERT INTO `sys_oper_log` VALUES (229, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795812707}', 0, '', '2026-01-19 12:10:13', 31);
INSERT INTO `sys_oper_log` VALUES (230, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":0,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795814558}', 0, '', '2026-01-19 12:10:15', 6);
INSERT INTO `sys_oper_log` VALUES (231, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795818020}', 0, '', '2026-01-19 12:10:18', 6);
INSERT INTO `sys_oper_log` VALUES (232, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":0,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795862550}', 0, '', '2026-01-19 12:11:03', 9);
INSERT INTO `sys_oper_log` VALUES (233, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795871895}', 0, '', '2026-01-19 12:11:12', 8);
INSERT INTO `sys_oper_log` VALUES (234, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":0,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795973956}', 0, '', '2026-01-19 12:12:54', 4);
INSERT INTO `sys_oper_log` VALUES (235, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768795974894}', 0, '', '2026-01-19 12:12:55', 6);
INSERT INTO `sys_oper_log` VALUES (236, '解绑审批流程', 3, 'com.sushe.backend.controller.system.SysApprovalController.unbindFlow()', 'DELETE', 1, 'superAdmin', 1, '/api/v1/system/approval/binding/check_in', '192.168.0.107', '', '\"check_in\"', '{\"code\":200,\"message\":\"解绑成功\",\"data\":null,\"timestamp\":1768796027399}', 0, '', '2026-01-19 12:13:47', 10);
INSERT INTO `sys_oper_log` VALUES (237, '绑定审批流程', 1, 'com.sushe.backend.controller.system.SysApprovalController.bindFlow()', 'POST', 1, 'superAdmin', 1, '/api/v1/system/approval/binding', '192.168.0.107', '', '{\"id\":null,\"businessType\":\"check_in\",\"flowId\":1,\"status\":1,\"remark\":null}', '{\"code\":200,\"message\":\"绑定成功\",\"data\":null,\"timestamp\":1768796047583}', 0, '', '2026-01-19 12:14:08', 5);

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
INSERT INTO `sys_role` VALUES (1, 'SUPER_ADMIN', '超级管理员', 1, 1, '系统最高权限', '2025-12-30 17:19:06', NULL, '2026-01-01 13:56:10', NULL);
INSERT INTO `sys_role` VALUES (2, '\r\nDORMITORY_MANAGER', '宿管员', 2, 1, '管理宿舍楼和房间信息', '2025-12-30 17:19:06', NULL, '2025-12-31 09:47:34', NULL);
INSERT INTO `sys_role` VALUES (3, '\r\nCOUNSELOR', '辅导员', 3, 1, '审核本学院学生申请', '2025-12-30 17:19:06', NULL, '2025-12-31 09:48:01', NULL);
INSERT INTO `sys_role` VALUES (4, '\r\nCOLLEGE_ADMIN', '院系管理员', 4, 1, '管理本学院住宿信息', '2025-12-30 17:19:06', NULL, '2025-12-31 09:48:16', NULL);
INSERT INTO `sys_role` VALUES (5, '\r\nSCHOOL_AUDITOR', '学校审核员', 5, 1, '最终审核权限', '2025-12-30 17:19:06', NULL, '2025-12-31 09:48:36', NULL);
INSERT INTO `sys_role` VALUES (6, 'TEST_ROLE', '测试角色', 100, 1, '这是一个测试角色', '2025-12-31 11:41:23', NULL, '2025-12-31 15:41:00', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2059 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1849, 1, 1, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1850, 1, 2, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1851, 1, 125, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1852, 1, 126, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1853, 1, 127, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1854, 1, 128, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1855, 1, 129, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1856, 1, 130, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1857, 1, 131, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1858, 1, 132, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1859, 1, 133, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1860, 1, 134, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1861, 1, 135, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1862, 1, 136, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1863, 1, 137, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1864, 1, 138, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1865, 1, 139, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1866, 1, 140, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1867, 1, 141, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1868, 1, 90, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1869, 1, 97, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1870, 1, 100, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1871, 1, 101, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1872, 1, 102, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1873, 1, 103, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1874, 1, 104, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1875, 1, 105, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1876, 1, 118, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1877, 1, 98, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1878, 1, 106, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1879, 1, 107, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1880, 1, 108, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1881, 1, 109, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1882, 1, 110, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1883, 1, 111, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1884, 1, 119, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1885, 1, 99, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1886, 1, 112, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1887, 1, 113, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1888, 1, 114, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1889, 1, 115, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1890, 1, 116, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1891, 1, 117, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1892, 1, 142, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1893, 1, 143, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1894, 1, 144, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1895, 1, 145, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1896, 1, 88, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1897, 1, 68, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1898, 1, 58, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1899, 1, 59, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1900, 1, 60, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1901, 1, 69, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1902, 1, 61, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1903, 1, 62, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1904, 1, 63, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1905, 1, 70, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1906, 1, 64, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1907, 1, 65, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1908, 1, 66, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1909, 1, 50, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1910, 1, 67, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1911, 1, 55, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1912, 1, 56, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1913, 1, 57, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1914, 1, 89, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1915, 1, 94, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1916, 1, 95, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1917, 1, 96, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1918, 1, 3, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1919, 1, 4, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1920, 1, 16, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1921, 1, 17, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1922, 1, 18, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1923, 1, 19, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1924, 1, 87, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1925, 1, 124, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1926, 1, 5, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1927, 1, 37, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1928, 1, 38, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1929, 1, 39, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1930, 1, 40, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1931, 1, 6, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1932, 1, 41, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1933, 1, 42, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1934, 1, 43, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1935, 1, 15, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1936, 1, 44, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1937, 1, 45, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1938, 1, 46, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1939, 1, 47, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1940, 1, 48, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1941, 1, 49, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1942, 1, 7, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1943, 1, 83, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1944, 1, 84, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1945, 1, 85, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1946, 1, 86, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1947, 1, 8, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1948, 1, 9, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1949, 1, 10, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1950, 1, 11, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1951, 1, 12, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1952, 1, 13, '2026-01-17 16:33:28');
INSERT INTO `sys_role_menu` VALUES (1953, 1, 14, '2026-01-17 16:33:28');
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
INSERT INTO `sys_room` VALUES (53, '103', '103', 1, 1, 'A001', 'CAMPUS001', 'standard', 4, 0, 4, 25.50, 1, 1, 1, 1, 3, 1, NULL, '2026-01-06 16:07:25', 1, '2026-01-06 16:08:48', 1);
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学期表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '留宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_stay
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_student
-- ----------------------------
INSERT INTO `sys_student` VALUES (1, '2025001001', '张三', 1, NULL, '13800138000', 'zhangsan@example.com', NULL, NULL, NULL, 2025, 4, '2025级', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:06', NULL, '2026-01-10 12:02:06', NULL, NULL, NULL);
INSERT INTO `sys_student` VALUES (4, '2025001002', '李四', 2, NULL, '13900139000', 'lisi@example.com', NULL, NULL, NULL, 2025, 4, '2025级', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:31', NULL, '2026-01-10 12:02:31', NULL, NULL, NULL);
INSERT INTO `sys_student` VALUES (6, '2025001003', '王五', 1, NULL, '13700137000', 'wangwu@example.com', NULL, NULL, NULL, 2025, 4, '2025级', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, NULL, '2026-01-10 12:02:54', NULL, '2026-01-15 12:00:30', 1, NULL, NULL);
INSERT INTO `sys_student` VALUES (14, '2021001', '张三', 1, '320102199901123456', '13800138001', 'zhangsan@example.com', NULL, NULL, NULL, 2021, 4, '大三', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, NULL, '2026-01-15 18:23:05', NULL, '2026-01-15 18:23:05', 14, '$2a$10$kutnHxYZ9sAN0aluqHKBXuJctNg.HTztmKUwqcIsRlmqSYySqSinS', NULL);
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调宿管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_transfer
-- ----------------------------

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
INSERT INTO `sys_user` VALUES (1, 'superAdmin', '$2a$10$LGpvVk9hFrfIIVRnWHoRVe.FkSVbqJ0CtyrY/WPLUva9e6xU7b/Ta', '超级管理员', NULL, 'superAdmin@example.com', '17876648229', '{\"campusIds\":[1],\"departmentIds\":[1],\"majorIds\":[1],\"classIds\":[2,1]}', 1, '2025-12-30 17:19:05', NULL, '2026-01-17 19:41:59', 1, '2026-01-19 20:19:50', 1, NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (2, 'testuser', '$2a$10$LGpvVk9hFrfIIVRnWHoRVe.FkSVbqJ0CtyrY/WPLUva9e6xU7b/Ta', '测试用户', NULL, 'test@example.com', '13800138000', '', 1, '2025-12-31 11:41:22', NULL, '2026-01-03 16:43:14', 1, '2026-01-17 22:56:19', NULL, NULL, NULL, NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 774 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_menu
-- ----------------------------
INSERT INTO `sys_user_menu` VALUES (564, 1, 1, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (565, 1, 2, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (566, 1, 125, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (567, 1, 126, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (568, 1, 127, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (569, 1, 128, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (570, 1, 129, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (571, 1, 130, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (572, 1, 131, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (573, 1, 132, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (574, 1, 133, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (575, 1, 134, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (576, 1, 135, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (577, 1, 136, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (578, 1, 137, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (579, 1, 138, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (580, 1, 139, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (581, 1, 140, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (582, 1, 141, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (583, 1, 90, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (584, 1, 97, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (585, 1, 100, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (586, 1, 101, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (587, 1, 102, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (588, 1, 103, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (589, 1, 104, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (590, 1, 105, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (591, 1, 118, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (592, 1, 98, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (593, 1, 106, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (594, 1, 107, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (595, 1, 108, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (596, 1, 109, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (597, 1, 110, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (598, 1, 111, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (599, 1, 119, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (600, 1, 99, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (601, 1, 112, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (602, 1, 113, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (603, 1, 114, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (604, 1, 115, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (605, 1, 116, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (606, 1, 117, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (607, 1, 142, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (608, 1, 143, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (609, 1, 144, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (610, 1, 145, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (611, 1, 88, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (612, 1, 68, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (613, 1, 58, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (614, 1, 59, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (615, 1, 60, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (616, 1, 69, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (617, 1, 61, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (618, 1, 62, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (619, 1, 63, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (620, 1, 70, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (621, 1, 64, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (622, 1, 65, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (623, 1, 66, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (624, 1, 50, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (625, 1, 67, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (626, 1, 55, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (627, 1, 56, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (628, 1, 57, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (629, 1, 89, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (630, 1, 94, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (631, 1, 95, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (632, 1, 96, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (633, 1, 3, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (634, 1, 4, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (635, 1, 16, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (636, 1, 17, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (637, 1, 18, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (638, 1, 19, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (639, 1, 87, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (640, 1, 124, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (641, 1, 5, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (642, 1, 37, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (643, 1, 38, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (644, 1, 39, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (645, 1, 40, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (646, 1, 6, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (647, 1, 41, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (648, 1, 42, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (649, 1, 43, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (650, 1, 15, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (651, 1, 44, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (652, 1, 45, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (653, 1, 46, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (654, 1, 47, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (655, 1, 48, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (656, 1, 49, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (657, 1, 7, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (658, 1, 83, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (659, 1, 84, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (660, 1, 85, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (661, 1, 86, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (662, 1, 8, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (663, 1, 9, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (664, 1, 10, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (665, 1, 11, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (666, 1, 12, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (667, 1, 13, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (668, 1, 14, '2026-01-17 16:33:42');
INSERT INTO `sys_user_menu` VALUES (669, 2, 1, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (670, 2, 2, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (671, 2, 125, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (672, 2, 126, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (673, 2, 127, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (674, 2, 128, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (675, 2, 129, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (676, 2, 130, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (677, 2, 131, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (678, 2, 132, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (679, 2, 133, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (680, 2, 134, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (681, 2, 135, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (682, 2, 136, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (683, 2, 137, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (684, 2, 138, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (685, 2, 139, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (686, 2, 140, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (687, 2, 141, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (688, 2, 90, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (689, 2, 97, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (690, 2, 100, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (691, 2, 101, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (692, 2, 102, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (693, 2, 103, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (694, 2, 104, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (695, 2, 105, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (696, 2, 118, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (697, 2, 98, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (698, 2, 106, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (699, 2, 107, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (700, 2, 108, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (701, 2, 109, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (702, 2, 110, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (703, 2, 111, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (704, 2, 119, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (705, 2, 99, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (706, 2, 112, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (707, 2, 113, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (708, 2, 114, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (709, 2, 115, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (710, 2, 116, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (711, 2, 117, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (712, 2, 142, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (713, 2, 143, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (714, 2, 144, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (715, 2, 145, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (716, 2, 88, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (717, 2, 68, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (718, 2, 58, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (719, 2, 59, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (720, 2, 60, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (721, 2, 69, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (722, 2, 61, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (723, 2, 62, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (724, 2, 63, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (725, 2, 70, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (726, 2, 64, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (727, 2, 65, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (728, 2, 66, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (729, 2, 50, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (730, 2, 67, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (731, 2, 55, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (732, 2, 56, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (733, 2, 57, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (734, 2, 89, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (735, 2, 94, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (736, 2, 95, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (737, 2, 96, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (738, 2, 3, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (739, 2, 4, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (740, 2, 16, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (741, 2, 17, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (742, 2, 18, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (743, 2, 19, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (744, 2, 87, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (745, 2, 124, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (746, 2, 5, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (747, 2, 37, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (748, 2, 38, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (749, 2, 39, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (750, 2, 40, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (751, 2, 6, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (752, 2, 41, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (753, 2, 42, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (754, 2, 43, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (755, 2, 15, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (756, 2, 44, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (757, 2, 45, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (758, 2, 46, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (759, 2, 47, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (760, 2, 48, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (761, 2, 49, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (762, 2, 7, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (763, 2, 83, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (764, 2, 84, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (765, 2, 85, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (766, 2, 86, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (767, 2, 8, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (768, 2, 9, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (769, 2, 10, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (770, 2, 11, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (771, 2, 12, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (772, 2, 13, '2026-01-17 22:55:05');
INSERT INTO `sys_user_menu` VALUES (773, 2, 14, '2026-01-17 22:55:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (76, 2, 3, '2026-01-03 16:43:14');
INSERT INTO `sys_user_role` VALUES (77, 2, 6, '2026-01-03 16:43:14');
INSERT INTO `sys_user_role` VALUES (79, 1, 1, '2026-01-17 19:41:59');

SET FOREIGN_KEY_CHECKS = 1;
