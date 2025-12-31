-- ========================================
-- 学校管理模块数据库表
-- 版本: 1.0.0
-- 日期: 2025-12-31
-- 说明: 创建校区、院系、专业、班级管理表
-- 数据库: MySQL
-- ========================================

-- 1. 校区表
CREATE TABLE IF NOT EXISTS `sys_campus` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `campus_code` VARCHAR(50) NOT NULL COMMENT '校区编码',
    `campus_name` VARCHAR(100) NOT NULL COMMENT '校区名称',
    `parent_code` VARCHAR(50) DEFAULT NULL COMMENT '上级校区编码',
    `address` VARCHAR(255) NOT NULL COMMENT '校区地址',
    `manager` VARCHAR(50) DEFAULT NULL COMMENT '负责人',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `sort` INT NOT NULL DEFAULT 0 COMMENT '排序序号',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_campus_code` (`campus_code`),
    KEY `idx_parent_code` (`parent_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='校区表';

-- 2. 院系表
CREATE TABLE IF NOT EXISTS `sys_department` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `dept_code` VARCHAR(50) NOT NULL COMMENT '院系编码',
    `dept_name` VARCHAR(100) NOT NULL COMMENT '院系名称',
    `campus_code` VARCHAR(50) NOT NULL COMMENT '所属校区编码',
    `parent_code` VARCHAR(50) DEFAULT NULL COMMENT '上级院系编码',
    `leader` VARCHAR(50) DEFAULT NULL COMMENT '院系领导',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_dept_code` (`dept_code`),
    KEY `idx_campus_code` (`campus_code`),
    KEY `idx_parent_code` (`parent_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='院系表';

-- 3. 专业表
CREATE TABLE IF NOT EXISTS `sys_major` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `major_code` VARCHAR(50) NOT NULL COMMENT '专业编码',
    `major_name` VARCHAR(100) NOT NULL COMMENT '专业名称',
    `dept_code` VARCHAR(50) NOT NULL COMMENT '所属院系编码',
    `director` VARCHAR(50) DEFAULT NULL COMMENT '专业负责人',
    `duration` VARCHAR(20) NOT NULL COMMENT '学制',
    `goal` TEXT DEFAULT NULL COMMENT '培养目标',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_major_code` (`major_code`),
    KEY `idx_dept_code` (`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专业表';

-- 4. 班级表
CREATE TABLE IF NOT EXISTS `sys_class` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `class_code` VARCHAR(50) NOT NULL COMMENT '班级编码',
    `class_name` VARCHAR(100) NOT NULL COMMENT '班级名称',
    `major_code` VARCHAR(50) NOT NULL COMMENT '所属专业编码',
    `grade` VARCHAR(20) NOT NULL COMMENT '年级',
    `teacher` VARCHAR(50) DEFAULT NULL COMMENT '负责人',
    `enrollment_year` INT NOT NULL COMMENT '入学年份',
    `current_count` INT NOT NULL DEFAULT 0 COMMENT '当前人数',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_class_code` (`class_code`),
    KEY `idx_major_code` (`major_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='班级表';

