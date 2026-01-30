-- ============================================================
-- 数据库优化脚本 - 统一 status 字段类型为 tinyint
-- 执行时间：2026-01-30
-- 作者：Claude Code
-- 版本：v1.0
-- 说明：将所有 status 相关字段统一为 tinyint 类型，节省存储空间
-- ============================================================

USE project_management;

-- ============================================================
-- 注意事项
-- ============================================================
-- 1. 执行前请先备份数据库
-- 2. tinyint 范围：-128 ~ 127，足够存储状态枚举
-- 3. 相比 int，每个字段节省 3 字节存储空间
-- 4. 不影响现有数据，只改变数据类型
-- ============================================================

-- ============================================================
-- 1. 申请管理表 - 将 int 类型的 status 改为 tinyint
-- ============================================================
ALTER TABLE sys_check_in
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

ALTER TABLE sys_transfer
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

ALTER TABLE sys_check_out
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

ALTER TABLE sys_stay
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

-- ============================================================
-- 2. 报修和通知 - 统一为 tinyint
-- ============================================================
ALTER TABLE sys_repair
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待接单 2-已接单 3-维修中 4-已完成 5-已取消';

ALTER TABLE sys_notice
MODIFY COLUMN status tinyint DEFAULT 0
COMMENT '状态：0-草稿 1-已发布';

-- ============================================================
-- 3. 审批流程 - 统一为 tinyint
-- ============================================================
ALTER TABLE sys_approval_instance
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-审批中 2-已通过 3-已拒绝 4-已撤销';

-- ============================================================
-- 4. 系统管理表 - 统一 tinyint(1) 为 tinyint
-- ============================================================
ALTER TABLE sys_user
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

ALTER TABLE sys_role
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

ALTER TABLE sys_menu
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-显示';

ALTER TABLE sys_menu
MODIFY COLUMN visible tinyint DEFAULT 1
COMMENT '是否可见：0-隐藏 1-显示';

ALTER TABLE sys_menu
MODIFY COLUMN keep_alive tinyint DEFAULT 1
COMMENT '是否缓存：0-否 1-是';

-- ============================================================
-- 5. 通知相关布尔字段 - 统一为 tinyint
-- ============================================================
ALTER TABLE sys_notice
MODIFY COLUMN is_top tinyint DEFAULT 0
COMMENT '是否置顶：0-否 1-是';

-- ============================================================
-- 6. 学生管理 - 确保 status 为 tinyint
-- ============================================================
-- sys_student 已经是 tinyint，但确保注释完整
ALTER TABLE sys_student
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：0-停用 1-正常 2-休学 3-退学 4-毕业';

-- ============================================================
-- 7. 宿舍管理 - 确保状态字段为 tinyint
-- ============================================================
ALTER TABLE sys_room
MODIFY COLUMN room_status tinyint NOT NULL DEFAULT 1
COMMENT '房间状态：1-正常 2-维修中 3-停用';

ALTER TABLE sys_bed
MODIFY COLUMN bed_status tinyint NOT NULL DEFAULT 1
COMMENT '床位状态：1-空闲 2-已分配 3-维修中 4-停用';

ALTER TABLE sys_floor
MODIFY COLUMN gender_type tinyint NOT NULL DEFAULT 3
COMMENT '性别限制：1-男生 2-女生 3-不限';

-- ============================================================
-- 验证：检查所有 status 字段类型
-- ============================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND (COLUMN_NAME LIKE '%status%'
         OR COLUMN_NAME IN ('is_top', 'visible', 'keep_alive', 'gender_type'))
ORDER BY TABLE_NAME, COLUMN_NAME;

-- 期望结果：所有状态字段都应该是 tinyint 类型

-- ============================================================
-- 执行完成提示
-- ============================================================
SELECT '✅ Status 字段类型统一完成！' AS status,
       '所有状态字段已统一为 tinyint' AS result,
       '每个字段节省 3 字节存储空间' AS benefit;
