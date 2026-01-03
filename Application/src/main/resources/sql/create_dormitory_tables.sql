-- ========================================
-- 宿舍管理模块数据库表
-- 版本: 1.0.0
-- 日期: 2026-01-03
-- 说明: 创建楼层、房间、床位管理表
-- 数据库: MySQL 8.0
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- 1. 楼层表（sys_floor）
-- ========================================
CREATE TABLE IF NOT EXISTS `sys_floor` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `floor_code` VARCHAR(50) NOT NULL COMMENT '楼层编码（如：F1、F2）',
    `floor_name` VARCHAR(100) DEFAULT NULL COMMENT '楼层名称（如：1楼、2楼）',
    `floor_number` INT NOT NULL COMMENT '楼层号（数字，如：1、2、3）',
    `campus_code` VARCHAR(50) NOT NULL COMMENT '所属校区编码（关联sys_campus）',
    `gender_type` TINYINT NOT NULL DEFAULT 3 COMMENT '适用性别：1男 2女 3混合',
    `total_rooms` INT NOT NULL DEFAULT 0 COMMENT '该楼层房间数（统计字段）',
    `total_beds` INT NOT NULL DEFAULT 0 COMMENT '该楼层床位数（统计字段）',
    `current_occupancy` INT NOT NULL DEFAULT 0 COMMENT '当前入住人数（统计字段）',
    `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_floor_code` (`floor_code`),
    KEY `idx_campus_code` (`campus_code`),
    KEY `idx_floor_code` (`floor_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='楼层表';

-- ========================================
-- 2. 房间表（sys_room）
-- ========================================
CREATE TABLE IF NOT EXISTS `sys_room` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `room_code` VARCHAR(50) NOT NULL COMMENT '房间编码（如：101、102）',
    `room_number` VARCHAR(50) NOT NULL COMMENT '房间号（如：101、102）',
    `floor_id` BIGINT NOT NULL COMMENT '所属楼层ID',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '所属楼层编码（冗余字段）',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '所属校区编码（冗余字段）',
    `room_type` VARCHAR(20) DEFAULT NULL COMMENT '房间类型（字典room_type）：标准间、套间、单人间等',
    `bed_count` INT NOT NULL DEFAULT 4 COMMENT '床位数（标准配置）',
    `current_occupancy` INT NOT NULL DEFAULT 0 COMMENT '当前入住人数',
    `max_occupancy` INT DEFAULT NULL COMMENT '最大入住人数',
    `area` DECIMAL(10,2) DEFAULT NULL COMMENT '房间面积（平方米）',
    `has_air_conditioner` TINYINT NOT NULL DEFAULT 0 COMMENT '是否有空调：1是 0否',
    `has_bathroom` TINYINT NOT NULL DEFAULT 0 COMMENT '是否有独立卫生间：1是 0否',
    `has_balcony` TINYINT NOT NULL DEFAULT 0 COMMENT '是否有阳台：1是 0否',
    `room_status` TINYINT NOT NULL DEFAULT 1 COMMENT '房间状态：1空闲 2已满 3维修中 4已预订',
    `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_room_code` (`room_code`),
    KEY `idx_floor_id` (`floor_id`),
    KEY `idx_floor_code` (`floor_code`),
    KEY `idx_campus_code` (`campus_code`),
    KEY `idx_room_code` (`room_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房间表';

-- ========================================
-- 3. 床位表（sys_bed）
-- ========================================
CREATE TABLE IF NOT EXISTS `sys_bed` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `bed_code` VARCHAR(50) NOT NULL COMMENT '床位编码（如：101-1、101-2）',
    `bed_number` VARCHAR(20) NOT NULL COMMENT '床位号（如：1、2、3、4）',
    `room_id` BIGINT NOT NULL COMMENT '所属房间ID',
    `room_code` VARCHAR(50) DEFAULT NULL COMMENT '所属房间编码（冗余字段）',
    `floor_id` BIGINT DEFAULT NULL COMMENT '所属楼层ID（冗余字段）',
    `floor_code` VARCHAR(50) DEFAULT NULL COMMENT '所属楼层编码（冗余字段）',
    `campus_code` VARCHAR(50) DEFAULT NULL COMMENT '所属校区编码（冗余字段）',
    `bed_position` VARCHAR(20) DEFAULT NULL COMMENT '床位位置（字典bed_position）：上铺、下铺、左、右等',
    `bed_status` TINYINT NOT NULL DEFAULT 1 COMMENT '床位状态：1空闲 2已占用 3维修中 4已预订',
    `student_id` BIGINT DEFAULT NULL COMMENT '当前入住学生ID（关联学生表，可为空）',
    `student_name` VARCHAR(50) DEFAULT NULL COMMENT '当前入住学生姓名（冗余字段）',
    `check_in_date` DATE DEFAULT NULL COMMENT '入住日期',
    `check_out_date` DATE DEFAULT NULL COMMENT '退宿日期',
    `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_bed_code` (`bed_code`),
    KEY `idx_room_id` (`room_id`),
    KEY `idx_room_code` (`room_code`),
    KEY `idx_floor_id` (`floor_id`),
    KEY `idx_campus_code` (`campus_code`),
    KEY `idx_bed_code` (`bed_code`),
    KEY `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='床位表';

SET FOREIGN_KEY_CHECKS = 1;

