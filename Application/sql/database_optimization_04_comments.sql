-- ============================================================
-- 数据库优化脚本 - 添加字段注释和枚举说明
-- 执行时间：2026-01-30
-- 作者：Claude Code
-- 版本：v1.0
-- 说明：完善字段注释，添加枚举值说明，提升可维护性
-- ============================================================

USE project_management;

-- ============================================================
-- 注意事项
-- ============================================================
-- 1. 此脚本不影响数据，只修改字段注释
-- 2. 清晰的注释有助于团队协作和代码理解
-- 3. 枚举值说明应与后端代码中的枚举类保持一致
-- ============================================================

-- ============================================================
-- 1. 学生管理 - 完善状态字段注释
-- ============================================================

-- sys_student: 学生状态
ALTER TABLE sys_student
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：0-停用 1-正常 2-休学 3-退学 4-毕业';

-- sys_student: 学籍状态
ALTER TABLE sys_student
MODIFY COLUMN academic_status int
COMMENT '学籍状态：1-在读 2-休学 3-退学 4-毕业';

-- sys_student: 性别
ALTER TABLE sys_student
MODIFY COLUMN gender varchar(10)
COMMENT '性别：male-男 female-女';

-- ============================================================
-- 2. 申请管理 - 入住类型说明
-- ============================================================

-- sys_check_in: 入住类型
ALTER TABLE sys_check_in
MODIFY COLUMN check_in_type int NOT NULL
COMMENT '入住类型：1-新生入住 2-老生返校 3-调宿入住 4-其他';

-- sys_check_in: 申请状态
ALTER TABLE sys_check_in
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

-- sys_transfer: 调宿原因（库中为 varchar 存文本）
ALTER TABLE sys_transfer
MODIFY COLUMN transfer_reason varchar(500) NULL
COMMENT '调宿原因（文本说明）';

-- sys_transfer: 申请状态
ALTER TABLE sys_transfer
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

-- sys_check_out: 退宿原因（库中为 varchar 存文本）
ALTER TABLE sys_check_out
MODIFY COLUMN check_out_reason varchar(500) NOT NULL
COMMENT '退宿原因（文本说明）';

-- sys_check_out: 申请状态
ALTER TABLE sys_check_out
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

-- sys_stay: 留宿原因（库中为 varchar 存文本）
ALTER TABLE sys_stay
MODIFY COLUMN stay_reason varchar(500) NOT NULL
COMMENT '留宿原因（文本说明）';

-- sys_stay: 申请状态
ALTER TABLE sys_stay
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待审核 2-已通过 3-已拒绝 4-已完成';

-- ============================================================
-- 3. 报修管理 - 维修类型和紧急程度说明
-- ============================================================

-- sys_repair: 维修类型
ALTER TABLE sys_repair
MODIFY COLUMN repair_type int NOT NULL
COMMENT '维修类型：1-水电 2-门窗 3-家具 4-网络 5-其他';

-- sys_repair: 紧急程度
ALTER TABLE sys_repair
MODIFY COLUMN urgent_level int NOT NULL DEFAULT 1
COMMENT '紧急程度：1-一般 2-紧急 3-非常紧急';

-- sys_repair: 报修状态
ALTER TABLE sys_repair
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-待接单 2-已接单 3-维修中 4-已完成 5-已取消';

-- ============================================================
-- 4. 通知管理 - 通知类型说明
-- ============================================================

-- sys_notice: 通知类型
ALTER TABLE sys_notice
MODIFY COLUMN notice_type int NOT NULL
COMMENT '通知类型：1-系统通知 2-宿舍公告 3-安全提醒 4-停水停电 99-其他';

-- sys_notice: 通知状态
ALTER TABLE sys_notice
MODIFY COLUMN status tinyint DEFAULT 0
COMMENT '状态：0-草稿 1-已发布';

-- sys_notice: 是否置顶
ALTER TABLE sys_notice
MODIFY COLUMN is_top tinyint DEFAULT 0
COMMENT '是否置顶：0-否 1-是';

-- （sys_notice 无 notice_level 列，已跳过）

-- ============================================================
-- 5. 宿舍管理 - 房间和床位状态说明
-- ============================================================

-- sys_room: 房间类型
ALTER TABLE sys_room
MODIFY COLUMN room_type varchar(20)
COMMENT '房间类型：standard-标准间 suite-套间 apartment-公寓';

-- sys_room: 房间状态
ALTER TABLE sys_room
MODIFY COLUMN room_status tinyint NOT NULL DEFAULT 1
COMMENT '房间状态：1-正常 2-维修中 3-停用';

-- sys_bed: 床位状态
ALTER TABLE sys_bed
MODIFY COLUMN bed_status tinyint NOT NULL DEFAULT 1
COMMENT '床位状态：1-空闲 2-已分配 3-维修中 4-停用';

-- sys_floor: 性别类型
ALTER TABLE sys_floor
MODIFY COLUMN gender_type tinyint NOT NULL DEFAULT 3
COMMENT '性别限制：1-男生 2-女生 3-不限';

-- ============================================================
-- 6. 操作日志 - 业务类型说明
-- ============================================================

-- sys_oper_log: 业务类型
ALTER TABLE sys_oper_log
MODIFY COLUMN business_type int DEFAULT 0
COMMENT '业务类型：1-新增 2-修改 3-删除 4-查询 5-导出 6-导入 7-其他';

-- sys_oper_log: 操作类别
ALTER TABLE sys_oper_log
MODIFY COLUMN operator_type int DEFAULT 0
COMMENT '操作类别：1-后台用户 2-小程序用户';

-- sys_oper_log: 设备类型
ALTER TABLE sys_oper_log
MODIFY COLUMN device_type int
COMMENT '设备类型：1-PC 2-手机 3-平板';

-- sys_oper_log: 操作状态
ALTER TABLE sys_oper_log
MODIFY COLUMN status int DEFAULT 0
COMMENT '操作状态：0-正常 1-异常';

-- ============================================================
-- 7. 审批流程 - 状态说明
-- ============================================================

-- sys_approval_instance: 审批状态
ALTER TABLE sys_approval_instance
MODIFY COLUMN status tinyint NOT NULL DEFAULT 1
COMMENT '状态：1-审批中 2-已通过 3-已拒绝 4-已撤销';

-- sys_approval_record: 审批结果（库中列名为 action）
ALTER TABLE sys_approval_record
MODIFY COLUMN action tinyint NOT NULL
COMMENT '审批结果：1-通过 2-拒绝 3-转交';

-- （sys_approval_flow 无 flow_type 列，已跳过）

-- sys_approval_node: 节点类型
ALTER TABLE sys_approval_node
MODIFY COLUMN node_type int NOT NULL
COMMENT '节点类型：1-审批节点 2-抄送节点 3-条件节点';

-- ============================================================
-- 8. 系统管理 - 菜单类型说明
-- ============================================================

-- sys_menu: 菜单类型（库中为 char(1)）
ALTER TABLE sys_menu
MODIFY COLUMN menu_type char(1)
COMMENT '菜单类型：M-目录 C-菜单 B-按钮';

-- sys_menu: 菜单状态
ALTER TABLE sys_menu
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-显示';

-- sys_menu: 是否可见
ALTER TABLE sys_menu
MODIFY COLUMN visible tinyint DEFAULT 1
COMMENT '是否可见：0-隐藏 1-显示';

-- sys_menu: 是否缓存
ALTER TABLE sys_menu
MODIFY COLUMN keep_alive tinyint DEFAULT 1
COMMENT '是否缓存：0-否 1-是';

-- ============================================================
-- 9. 用户管理 - 用户状态说明
-- ============================================================

-- sys_user: 用户状态
ALTER TABLE sys_user
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

-- sys_user: 性别（库中列名为 gender，类型 int）
ALTER TABLE sys_user
MODIFY COLUMN gender int
COMMENT '性别：1-男 2-女 0-未知';

-- sys_role: 角色状态
ALTER TABLE sys_role
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

-- ============================================================
-- 10. 字典管理 - 字典状态说明
-- ============================================================

-- sys_dict_type: 字典状态
ALTER TABLE sys_dict_type
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

-- sys_dict_data: 字典数据状态
ALTER TABLE sys_dict_data
MODIFY COLUMN status tinyint DEFAULT 1
COMMENT '状态：0-停用 1-正常';

-- ============================================================
-- 11. 学期学年 - 状态说明
-- ============================================================

-- （sys_semester 无 status 列，已跳过）

-- sys_academic_year: 学年状态
ALTER TABLE sys_academic_year
MODIFY COLUMN status tinyint
COMMENT '状态：0-未开始 1-进行中 2-已结束';

-- ============================================================
-- 验证：查看关键字段的注释
-- ============================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'project_management'
    AND COLUMN_NAME IN (
        'status', 'repair_type', 'notice_type', 'urgent_level',
        'check_in_type', 'transfer_reason', 'check_out_reason', 'stay_reason',
        'room_type', 'room_status', 'bed_status', 'gender_type',
        'business_type', 'operator_type', 'menu_type', 'node_type', 'action', 'gender'
    )
ORDER BY TABLE_NAME, COLUMN_NAME;

-- ============================================================
-- 执行完成提示
-- ============================================================
SELECT '✅ 字段注释优化完成！' AS status,
       '所有枚举字段都有详细说明' AS result,
       '请确保后端枚举类与注释一致' AS reminder;
