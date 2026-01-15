-- ========================================
-- 住宿管理模块建表SQL
-- 创建日期：2026-01-06
-- 数据库：MySQL 8.0
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- 1. 学生表（sys_student）
-- ========================================
DROP TABLE IF EXISTS `sys_student`;
CREATE TABLE `sys_student` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `student_no` VARCHAR(50) NOT NULL COMMENT '学号',
    `student_name` VARCHAR(50) NOT NULL COMMENT '姓名',
    `gender` INT DEFAULT NULL COMMENT '性别（字典sys_user_sex）：0未知 1男 2女',
    `id_card` VARCHAR(18) DEFAULT NULL COMMENT '身份证号',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `birth_date` DATE DEFAULT NULL COMMENT '出生日期',
    `nation` VARCHAR(50) DEFAULT NULL COMMENT '民族',
    `political_status` VARCHAR(50) DEFAULT NULL COMMENT '政治面貌',
    `enrollment_year` INT DEFAULT NULL COMMENT '入学年份',
    `schooling_length` INT DEFAULT NULL COMMENT '学制（年）',
    `current_grade` VARCHAR(20) DEFAULT NULL COMMENT '当前年级',
    `academic_status` INT DEFAULT NULL COMMENT '学籍状态（字典academic_status）：1在读 2休学 3毕业 4退学',
    `home_address` VARCHAR(255) DEFAULT NULL COMMENT '家庭地址',
    `emergency_contact` VARCHAR(50) DEFAULT NULL COMMENT '紧急联系人',
    `emergency_phone` VARCHAR(20) DEFAULT NULL COMMENT '紧急联系人电话',
    `parent_name` VARCHAR(50) DEFAULT NULL COMMENT '家长姓名',
    `parent_phone` VARCHAR(20) DEFAULT NULL COMMENT '家长电话',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '校区编码',
    `dept_code` VARCHAR(50) DEFAULT NULL COMMENT '院系编码',
    `major_code` VARCHAR(50) DEFAULT NULL COMMENT '专业编码',
    `class_id` BIGINT DEFAULT NULL COMMENT '班级ID',
    `class_code` VARCHAR(50) DEFAULT NULL COMMENT '班级编码',
    `floor_id` BIGINT DEFAULT NULL COMMENT '楼层ID',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '楼层编码',
    `room_id` BIGINT DEFAULT NULL COMMENT '房间ID',
    `room_code` VARCHAR(50) DEFAULT NULL COMMENT '房间编码',
    `bed_id` BIGINT DEFAULT NULL COMMENT '床位ID',
    `bed_code` VARCHAR(50) DEFAULT NULL COMMENT '床位编码',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_student_no` (`student_no`),
    KEY `idx_student_name` (`student_name`),
    KEY `idx_phone` (`phone`),
    KEY `idx_id_card` (`id_card`),
    KEY `idx_campus_code` (`campus_code`),
    KEY `idx_dept_code` (`dept_code`),
    KEY `idx_major_code` (`major_code`),
    KEY `idx_class_id` (`class_id`),
    KEY `idx_bed_id` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生表';

-- ========================================
-- 2. 入住管理表（sys_check_in）
-- ========================================
DROP TABLE IF EXISTS `sys_check_in`;
CREATE TABLE `sys_check_in` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名（冗余）',
    `student_no` VARCHAR(50) DEFAULT NULL COMMENT '学号（冗余）',
    `check_in_type` INT NOT NULL COMMENT '入住类型：1长期住宿 2临时住宿',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '校区编码',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '楼层编码',
    `room_id` BIGINT DEFAULT NULL COMMENT '房间ID',
    `room_code` VARCHAR(50) DEFAULT NULL COMMENT '房间编码',
    `bed_id` BIGINT DEFAULT NULL COMMENT '床位ID',
    `bed_code` VARCHAR(50) DEFAULT NULL COMMENT '床位编码',
    `apply_date` DATE DEFAULT NULL COMMENT '申请日期',
    `check_in_date` DATE DEFAULT NULL COMMENT '入住日期',
    `expected_check_out_date` DATE DEFAULT NULL COMMENT '预计退宿日期（临时住宿）',
    `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已入住',
    `approver_id` BIGINT DEFAULT NULL COMMENT '审核人ID',
    `approver_name` VARCHAR(50) DEFAULT NULL COMMENT '审核人姓名',
    `approve_time` DATETIME DEFAULT NULL COMMENT '审核时间',
    `approve_opinion` VARCHAR(500) DEFAULT NULL COMMENT '审核意见',
    `apply_reason` VARCHAR(500) DEFAULT NULL COMMENT '申请原因/备注',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_student_id` (`student_id`),
    KEY `idx_student_no` (`student_no`),
    KEY `idx_status` (`status`),
    KEY `idx_check_in_date` (`check_in_date`),
    KEY `idx_bed_id` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入住管理表';

-- ========================================
-- 3. 调宿管理表（sys_transfer）
-- ========================================
DROP TABLE IF EXISTS `sys_transfer`;
CREATE TABLE `sys_transfer` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名（冗余）',
    `student_no` VARCHAR(50) DEFAULT NULL COMMENT '学号（冗余）',
    `original_campus_code` VARCHAR(50) DEFAULT NULL COMMENT '原校区编码',
    `original_floor_code` VARCHAR(50) DEFAULT NULL COMMENT '原楼层编码',
    `original_room_id` BIGINT DEFAULT NULL COMMENT '原房间ID',
    `original_room_code` VARCHAR(50) DEFAULT NULL COMMENT '原房间编码',
    `original_bed_id` BIGINT DEFAULT NULL COMMENT '原床位ID',
    `original_bed_code` VARCHAR(50) DEFAULT NULL COMMENT '原床位编码',
    `target_campus_code` VARCHAR(50) DEFAULT NULL COMMENT '目标校区编码',
    `target_floor_code` VARCHAR(50) DEFAULT NULL COMMENT '目标楼层编码',
    `target_room_id` BIGINT DEFAULT NULL COMMENT '目标房间ID',
    `target_room_code` VARCHAR(50) DEFAULT NULL COMMENT '目标房间编码',
    `target_bed_id` BIGINT DEFAULT NULL COMMENT '目标床位ID',
    `target_bed_code` VARCHAR(50) DEFAULT NULL COMMENT '目标床位编码',
    `apply_date` DATE DEFAULT NULL COMMENT '申请日期',
    `transfer_date` DATE DEFAULT NULL COMMENT '调宿日期',
    `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
    `approver_id` BIGINT DEFAULT NULL COMMENT '审核人ID',
    `approver_name` VARCHAR(50) DEFAULT NULL COMMENT '审核人姓名',
    `approve_time` DATETIME DEFAULT NULL COMMENT '审核时间',
    `approve_opinion` VARCHAR(500) DEFAULT NULL COMMENT '审核意见',
    `transfer_reason` VARCHAR(500) DEFAULT NULL COMMENT '调宿原因',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_student_id` (`student_id`),
    KEY `idx_student_no` (`student_no`),
    KEY `idx_status` (`status`),
    KEY `idx_transfer_date` (`transfer_date`),
    KEY `idx_original_bed_id` (`original_bed_id`),
    KEY `idx_target_bed_id` (`target_bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调宿管理表';

-- ========================================
-- 4. 退宿管理表（sys_check_out）
-- ========================================
DROP TABLE IF EXISTS `sys_check_out`;
CREATE TABLE `sys_check_out` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名（冗余）',
    `student_no` VARCHAR(50) DEFAULT NULL COMMENT '学号（冗余）',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '校区编码',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '楼层编码',
    `room_id` BIGINT DEFAULT NULL COMMENT '房间ID',
    `room_code` VARCHAR(50) DEFAULT NULL COMMENT '房间编码',
    `bed_id` BIGINT DEFAULT NULL COMMENT '床位ID',
    `bed_code` VARCHAR(50) DEFAULT NULL COMMENT '床位编码',
    `apply_date` DATE DEFAULT NULL COMMENT '申请日期',
    `check_out_date` DATE DEFAULT NULL COMMENT '退宿日期',
    `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
    `approver_id` BIGINT DEFAULT NULL COMMENT '审核人ID',
    `approver_name` VARCHAR(50) DEFAULT NULL COMMENT '审核人姓名',
    `approve_time` DATETIME DEFAULT NULL COMMENT '审核时间',
    `approve_opinion` VARCHAR(500) DEFAULT NULL COMMENT '审核意见',
    `check_out_reason` VARCHAR(500) NOT NULL COMMENT '退宿理由（必填）',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_student_id` (`student_id`),
    KEY `idx_student_no` (`student_no`),
    KEY `idx_status` (`status`),
    KEY `idx_check_out_date` (`check_out_date`),
    KEY `idx_bed_id` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='退宿管理表';

-- ========================================
-- 5. 留宿管理表（sys_stay）
-- ========================================
DROP TABLE IF EXISTS `sys_stay`;
CREATE TABLE `sys_stay` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `student_id` BIGINT NOT NULL COMMENT '学生ID',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '学生姓名（冗余）',
    `student_no` VARCHAR(50) DEFAULT NULL COMMENT '学号（冗余）',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '校区编码',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '楼层编码',
    `room_id` BIGINT DEFAULT NULL COMMENT '房间ID',
    `room_code` VARCHAR(50) DEFAULT NULL COMMENT '房间编码',
    `bed_id` BIGINT DEFAULT NULL COMMENT '床位ID',
    `bed_code` VARCHAR(50) DEFAULT NULL COMMENT '床位编码',
    `apply_date` DATE DEFAULT NULL COMMENT '申请日期',
    `stay_start_date` DATE DEFAULT NULL COMMENT '留宿开始日期',
    `stay_end_date` DATE DEFAULT NULL COMMENT '留宿结束日期',
    `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1待审核 2已通过 3已拒绝 4已完成',
    `approver_id` BIGINT DEFAULT NULL COMMENT '审核人ID',
    `approver_name` VARCHAR(50) DEFAULT NULL COMMENT '审核人姓名',
    `approve_time` DATETIME DEFAULT NULL COMMENT '审核时间',
    `approve_opinion` VARCHAR(500) DEFAULT NULL COMMENT '审核意见',
    `stay_reason` VARCHAR(500) NOT NULL COMMENT '留宿理由（必填）',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    KEY `idx_student_id` (`student_id`),
    KEY `idx_student_no` (`student_no`),
    KEY `idx_status` (`status`),
    KEY `idx_stay_start_date` (`stay_start_date`),
    KEY `idx_stay_end_date` (`stay_end_date`),
    KEY `idx_bed_id` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='留宿管理表';

SET FOREIGN_KEY_CHECKS = 1;

