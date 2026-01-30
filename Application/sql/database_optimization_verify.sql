-- ============================================================
-- 数据库优化验证脚本
-- 执行时间：2026-01-30
-- 作者：Claude Code
-- 版本：v1.0
-- 说明：验证数据库优化是否成功执行
-- ============================================================

USE project_management;

-- ============================================================
-- 1. 验证逻辑删除字段（deleted）
-- ============================================================

SELECT '========== 1. 逻辑删除字段验证 ==========' AS verification_section;

-- 统计有 deleted 字段的表数量
SELECT
    COUNT(DISTINCT TABLE_NAME) AS table_count,
    '应该有 31 张表（除了 sys_oper_log）' AS expected
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'deleted';

-- 列出所有有 deleted 字段的表
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    IS_NULLABLE,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'deleted'
ORDER BY TABLE_NAME;

-- 检查是否有表缺少 deleted 字段（排除 sys_oper_log）
SELECT
    TABLE_NAME,
    '❌ 缺少 deleted 字段' AS issue
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_TYPE = 'BASE TABLE'
    AND TABLE_NAME != 'sys_oper_log'
    AND TABLE_NAME NOT IN (
        SELECT DISTINCT TABLE_NAME
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'project_management'
            AND COLUMN_NAME = 'deleted'
    )
ORDER BY TABLE_NAME;

-- ============================================================
-- 2. 验证 status 字段类型统一
-- ============================================================

SELECT '========== 2. Status 字段类型验证 ==========' AS verification_section;

-- 统计 status 字段类型分布
SELECT
    COLUMN_TYPE,
    COUNT(*) AS table_count,
    GROUP_CONCAT(TABLE_NAME ORDER BY TABLE_NAME) AS tables
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'status'
GROUP BY COLUMN_TYPE
ORDER BY table_count DESC;

-- 列出所有 status 字段（应该都是 tinyint）
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    DATA_TYPE,
    COLUMN_COMMENT,
    CASE
        WHEN DATA_TYPE = 'tinyint' THEN '✅'
        ELSE '❌ 需要改为 tinyint'
    END AS status_check
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME = 'status'
ORDER BY TABLE_NAME;

-- 检查其他布尔/状态字段
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    DATA_TYPE,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME IN ('is_top', 'visible', 'keep_alive', 'gender_type')
ORDER BY TABLE_NAME, COLUMN_NAME;

-- ============================================================
-- 3. 验证索引优化
-- ============================================================

SELECT '========== 3. 索引优化验证 ==========' AS verification_section;

-- 统计新增索引数量（idx_ 和 uk_ 开头）
SELECT
    COUNT(*) AS index_count,
    '应该有 50+ 个索引' AS expected
FROM (
    SELECT DISTINCT TABLE_NAME, INDEX_NAME
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = 'project_management'
        AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')
) AS idx;

-- 按表统计索引数量
SELECT
    TABLE_NAME,
    COUNT(DISTINCT INDEX_NAME) AS index_count,
    GROUP_CONCAT(DISTINCT INDEX_NAME ORDER BY INDEX_NAME) AS indexes
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')
GROUP BY TABLE_NAME
ORDER BY index_count DESC, TABLE_NAME;

-- 列出所有新增的组合索引
SELECT
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS INDEX_COLUMNS,
    INDEX_TYPE,
    CASE NON_UNIQUE
        WHEN 0 THEN '唯一索引'
        WHEN 1 THEN '普通索引'
    END AS INDEX_UNIQUENESS
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')
GROUP BY TABLE_NAME, INDEX_NAME, INDEX_TYPE, NON_UNIQUE
ORDER BY TABLE_NAME, INDEX_NAME;

-- 检查关键业务表的索引
SELECT
    '关键业务表索引检查' AS check_category,
    TABLE_NAME,
    CASE
        WHEN TABLE_NAME = 'sys_check_in' AND INDEX_NAME LIKE '%student_status%' THEN '✅ 有学生+状态索引'
        WHEN TABLE_NAME = 'sys_repair' AND INDEX_NAME LIKE '%student_status%' THEN '✅ 有学生+状态索引'
        WHEN TABLE_NAME = 'sys_repair' AND INDEX_NAME LIKE '%repairer_status%' THEN '✅ 有维修人员+状态索引'
        WHEN TABLE_NAME = 'sys_notice' AND INDEX_NAME LIKE '%type_status_top%' THEN '✅ 有类型+状态+置顶索引'
        WHEN TABLE_NAME = 'sys_bed' AND INDEX_NAME LIKE '%room_status%' THEN '✅ 有房间+床位状态索引'
        ELSE CONCAT('索引: ', INDEX_NAME)
    END AS index_check
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'project_management'
    AND TABLE_NAME IN ('sys_check_in', 'sys_repair', 'sys_notice', 'sys_bed')
    AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')
ORDER BY TABLE_NAME, INDEX_NAME;

-- ============================================================
-- 4. 验证字段注释完整性
-- ============================================================

SELECT '========== 4. 字段注释完整性验证 ==========' AS verification_section;

-- 检查关键枚举字段的注释
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    COLUMN_COMMENT,
    CASE
        WHEN COLUMN_COMMENT IS NULL OR COLUMN_COMMENT = '' THEN '❌ 缺少注释'
        WHEN COLUMN_COMMENT LIKE '%：%' THEN '✅ 有枚举说明'
        ELSE '⚠️ 注释可能不完整'
    END AS comment_check
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME IN (
        'status', 'repair_type', 'notice_type', 'urgent_level',
        'check_in_type', 'transfer_reason', 'check_out_reason', 'stay_reason',
        'room_type', 'room_status', 'bed_status', 'gender_type',
        'business_type', 'operator_type', 'menu_type', 'node_type',
        'action', 'gender'
    )
ORDER BY TABLE_NAME, COLUMN_NAME;

-- 统计缺少注释的字段
SELECT
    COUNT(*) AS fields_without_comment,
    '缺少注释的字段数' AS description
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND (COLUMN_COMMENT IS NULL OR COLUMN_COMMENT = '');

-- ============================================================
-- 5. 数据完整性检查
-- ============================================================

SELECT '========== 5. 数据完整性检查 ==========' AS verification_section;

-- 检查 deleted 字段的数据分布
SELECT
    'sys_student' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN deleted = 0 THEN 1 ELSE 0 END) AS active_records,
    SUM(CASE WHEN deleted = 1 THEN 1 ELSE 0 END) AS deleted_records
FROM sys_student
UNION ALL
SELECT
    'sys_check_in' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN deleted = 0 THEN 1 ELSE 0 END) AS active_records,
    SUM(CASE WHEN deleted = 1 THEN 1 ELSE 0 END) AS deleted_records
FROM sys_check_in
UNION ALL
SELECT
    'sys_repair' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN deleted = 0 THEN 1 ELSE 0 END) AS active_records,
    SUM(CASE WHEN deleted = 1 THEN 1 ELSE 0 END) AS deleted_records
FROM sys_repair
UNION ALL
SELECT
    'sys_notice' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN deleted = 0 THEN 1 ELSE 0 END) AS active_records,
    SUM(CASE WHEN deleted = 1 THEN 1 ELSE 0 END) AS deleted_records
FROM sys_notice;

-- ============================================================
-- 6. 性能测试（EXPLAIN 分析）
-- ============================================================

SELECT '========== 6. 查询性能测试 ==========' AS verification_section;

-- 测试1：学生申请查询（应该使用 idx_student_status）
EXPLAIN SELECT * FROM sys_check_in
WHERE student_id = 1 AND status = 1 AND deleted = 0
ORDER BY create_time DESC;

-- 测试2：维修人员待办查询（应该使用 idx_repairer_status）
EXPLAIN SELECT * FROM sys_repair
WHERE repair_person_id = 10 AND status IN (1, 2, 3) AND deleted = 0
ORDER BY urgent_level DESC, create_time ASC;

-- 测试3：通知列表查询（应该使用 idx_type_status_top）
EXPLAIN SELECT * FROM sys_notice
WHERE notice_type = 1 AND status = 1 AND deleted = 0
ORDER BY is_top DESC, publish_time DESC
LIMIT 10;

-- 测试4：房间可用床位查询（应该使用 idx_room_status）
EXPLAIN SELECT * FROM sys_bed
WHERE room_id = 100 AND bed_status = 1 AND deleted = 0;

-- 测试5：审批实例业务查询（应该使用 uk_business 唯一索引）
EXPLAIN SELECT * FROM sys_approval_instance
WHERE business_type = 'CHECK_IN' AND business_id = 123 AND deleted = 0;

-- ============================================================
-- 7. 表结构变更汇总
-- ============================================================

SELECT '========== 7. 表结构变更汇总 ==========' AS verification_section;

-- 统计每个表的字段数和索引数
SELECT
    t.TABLE_NAME,
    COUNT(DISTINCT c.COLUMN_NAME) AS column_count,
    COUNT(DISTINCT s.INDEX_NAME) AS index_count,
    SUM(CASE WHEN c.COLUMN_NAME = 'deleted' THEN 1 ELSE 0 END) AS has_deleted_field,
    t.TABLE_ROWS AS approximate_rows,
    ROUND(t.DATA_LENGTH / 1024 / 1024, 2) AS data_size_mb,
    ROUND(t.INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb
FROM information_schema.TABLES t
LEFT JOIN information_schema.COLUMNS c
    ON t.TABLE_SCHEMA = c.TABLE_SCHEMA
    AND t.TABLE_NAME = c.TABLE_NAME
LEFT JOIN information_schema.STATISTICS s
    ON t.TABLE_SCHEMA = s.TABLE_SCHEMA
    AND t.TABLE_NAME = s.TABLE_NAME
WHERE t.TABLE_SCHEMA = 'project_management'
    AND t.TABLE_TYPE = 'BASE TABLE'
GROUP BY t.TABLE_NAME, t.TABLE_ROWS, t.DATA_LENGTH, t.INDEX_LENGTH
ORDER BY t.TABLE_NAME;

-- ============================================================
-- 8. 最终验证结果
-- ============================================================

SELECT '========== 8. 最终验证结果 ==========' AS verification_section;

-- 综合验证结果
SELECT
    '逻辑删除字段' AS optimization_item,
    (SELECT COUNT(DISTINCT TABLE_NAME)
     FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = 'project_management'
     AND COLUMN_NAME = 'deleted') AS actual_value,
    31 AS expected_value,
    CASE
        WHEN (SELECT COUNT(DISTINCT TABLE_NAME)
              FROM information_schema.COLUMNS
              WHERE TABLE_SCHEMA = 'project_management'
              AND COLUMN_NAME = 'deleted') >= 31
        THEN '✅ 通过'
        ELSE '❌ 未通过'
    END AS verification_result
UNION ALL
SELECT
    'Status 字段统一' AS optimization_item,
    (SELECT COUNT(*)
     FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = 'project_management'
     AND COLUMN_NAME = 'status'
     AND DATA_TYPE = 'tinyint') AS actual_value,
    (SELECT COUNT(*)
     FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = 'project_management'
     AND COLUMN_NAME = 'status') AS expected_value,
    CASE
        WHEN (SELECT COUNT(*)
              FROM information_schema.COLUMNS
              WHERE TABLE_SCHEMA = 'project_management'
              AND COLUMN_NAME = 'status'
              AND DATA_TYPE != 'tinyint') = 0
        THEN '✅ 通过'
        ELSE '❌ 未通过'
    END AS verification_result
UNION ALL
SELECT
    '索引优化' AS optimization_item,
    (SELECT COUNT(DISTINCT INDEX_NAME)
     FROM information_schema.STATISTICS
     WHERE TABLE_SCHEMA = 'project_management'
     AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')) AS actual_value,
    50 AS expected_value,
    CASE
        WHEN (SELECT COUNT(DISTINCT INDEX_NAME)
              FROM information_schema.STATISTICS
              WHERE TABLE_SCHEMA = 'project_management'
              AND (INDEX_NAME LIKE 'idx_%' OR INDEX_NAME LIKE 'uk_%')) >= 50
        THEN '✅ 通过'
        ELSE '⚠️ 部分通过'
    END AS verification_result;

-- ============================================================
-- 验证完成提示
-- ============================================================
SELECT
    '✅ 验证脚本执行完成！' AS status,
    '请查看上述验证结果' AS next_step,
    '如有问题，请检查对应的优化脚本' AS reminder;
