-- ========================================
-- 移除校区和院系表的 parent_code 字段
-- 版本: 1.0.0
-- 日期: 2025-01-XX
-- 说明: 移除校区和院系管理中的上级字段支持
-- 数据库: MySQL
-- ========================================

SET NAMES utf8mb4;

-- ========================================
-- 注意：执行前请确保已备份数据库
-- 此脚本会安全地检查索引和字段是否存在后再删除
-- ========================================

-- 1. 删除校区表的 parent_code 索引（如果存在）
SET @dbname = DATABASE();
SET @tablename = 'sys_campus';
SET @indexname = 'idx_parent_code';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_schema = @dbname
    AND table_name = @tablename
    AND index_name = @indexname
  ) > 0,
  CONCAT('ALTER TABLE `', @tablename, '` DROP INDEX `', @indexname, '`'),
  'SELECT 1'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

-- 2. 删除校区表的 parent_code 字段（如果存在）
SET @columnname = 'parent_code';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_schema = @dbname
    AND table_name = @tablename
    AND column_name = @columnname
  ) > 0,
  CONCAT('ALTER TABLE `', @tablename, '` DROP COLUMN `', @columnname, '`'),
  'SELECT 1'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

-- 3. 删除院系表的 parent_code 索引（如果存在）
SET @tablename = 'sys_department';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_schema = @dbname
    AND table_name = @tablename
    AND index_name = @indexname
  ) > 0,
  CONCAT('ALTER TABLE `', @tablename, '` DROP INDEX `', @indexname, '`'),
  'SELECT 1'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

-- 4. 删除院系表的 parent_code 字段（如果存在）
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_schema = @dbname
    AND table_name = @tablename
    AND column_name = @columnname
  ) > 0,
  CONCAT('ALTER TABLE `', @tablename, '` DROP COLUMN `', @columnname, '`'),
  'SELECT 1'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

