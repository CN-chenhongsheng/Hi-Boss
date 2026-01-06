-- ========================================
-- 学年管理模块数据库表
-- 版本: 1.0.0
-- 日期: 2025-01-01
-- 说明: 创建学年和学期管理表
-- 数据库: MySQL
-- ========================================

-- 1. 学年表
CREATE TABLE IF NOT EXISTS `sys_academic_year` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `year_code` VARCHAR(50) NOT NULL COMMENT '学年编码',
    `year_name` VARCHAR(100) NOT NULL COMMENT '学年名称',
    `start_date` DATE NOT NULL COMMENT '开始日期',
    `end_date` DATE NOT NULL COMMENT '结束日期',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用 0停用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_year_code` (`year_code`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学年表';

-- 2. 学期表
CREATE TABLE IF NOT EXISTS `sys_semester` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `academic_year_id` BIGINT NOT NULL COMMENT '所属学年ID',
    `semester_code` VARCHAR(50) NOT NULL COMMENT '学期编码',
    `semester_name` VARCHAR(100) NOT NULL COMMENT '学期名称',
    `start_date` DATE NOT NULL COMMENT '开始日期',
    `end_date` DATE NOT NULL COMMENT '结束日期',
    `semester_type` VARCHAR(20) DEFAULT NULL COMMENT '学期类型（如：第一学期、第二学期）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新人ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_semester_code` (`semester_code`),
    KEY `idx_academic_year_id` (`academic_year_id`),
    CONSTRAINT `fk_semester_academic_year` FOREIGN KEY (`academic_year_id`) REFERENCES `sys_academic_year` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学期表';

