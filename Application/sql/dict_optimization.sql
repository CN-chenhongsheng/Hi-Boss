-- ===================================================
-- 后端硬编码优化 - 数据字典补充 SQL
-- 执行日期: 2026-01-28
-- 说明: 添加缺失的字典类型和字典数据，消除代码硬编码
-- 作者: Claude Code 优化助手
-- ===================================================

-- 1. 入住类型字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('入住类型', 'check_in_type', 1, '入住申请的类型（长期/临时）', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('check_in_type', '长期住宿', '1', 1, 1, NOW()),
('check_in_type', '临时住宿', '2', 2, 1, NOW());

-- 2. 审批业务类型字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('审批业务类型', 'approval_business_type', 1, '审批流程关联的业务类型', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('approval_business_type', '入住申请', 'check_in', 1, 1, NOW()),
('approval_business_type', '调宿申请', 'transfer', 2, 1, NOW()),
('approval_business_type', '退宿申请', 'check_out', 3, 1, NOW()),
('approval_business_type', '留宿申请', 'stay', 4, 1, NOW());

-- 3. 审批动作字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('审批动作', 'approval_action', 1, '审批操作的动作类型（通过/拒绝）', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('approval_action', '通过', '1', 1, 1, NOW()),
('approval_action', '拒绝', '2', 2, 1, NOW());

-- 4. 流程节点类型字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('流程节点类型', 'approval_node_type', 1, '审批流程节点的类型（串行/会签/或签）', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('approval_node_type', '串行', '1', 1, 1, NOW()),
('approval_node_type', '会签', '2', 2, 1, NOW()),
('approval_node_type', '或签', '3', 3, 1, 1, NOW());

-- 5. 拒绝处理方式字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('拒绝处理方式', 'approval_reject_action', 1, '审批拒绝后的处理方式', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('approval_reject_action', '直接结束', '1', 1, 1, NOW()),
('approval_reject_action', '退回申请人', '2', 2, 1, NOW()),
('approval_reject_action', '退回上一节点', '3', 3, 1, NOW());

-- 6. 审批实例状态字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('审批实例状态', 'approval_instance_status', 1, '审批流程实例的状态', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('approval_instance_status', '进行中', '1', 1, 1, NOW()),
('approval_instance_status', '已通过', '2', 2, 1, NOW()),
('approval_instance_status', '已拒绝', '3', 3, 1, NOW()),
('approval_instance_status', '已撤回', '4', 4, 1, NOW());

-- 7. 家长同意状态字典
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`, `create_time`)
VALUES ('家长同意状态', 'parent_agree_status', 1, '留宿申请中家长是否同意', NOW());

INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `sort`, `status`, `create_time`) VALUES
('parent_agree_status', '同意', 'agree', 1, 1, NOW()),
('parent_agree_status', '不同意', 'disagree', 2, 1, NOW()),
('parent_agree_status', '未填写', '', 3, 1, NOW());

-- ===================================================
-- 验证查询
-- ===================================================

-- 查询新增的字典类型
SELECT * FROM sys_dict_type
WHERE dict_code IN (
    'check_in_type',
    'approval_business_type',
    'approval_action',
    'approval_node_type',
    'approval_reject_action',
    'approval_instance_status',
    'parent_agree_status'
)
ORDER BY create_time DESC;

-- 查询新增的字典数据
SELECT dict_code, label, value, sort, status
FROM sys_dict_data
WHERE dict_code IN (
    'check_in_type',
    'approval_business_type',
    'approval_action',
    'approval_node_type',
    'approval_reject_action',
    'approval_instance_status',
    'parent_agree_status'
)
ORDER BY dict_code, sort;

-- 统计新增数据量
SELECT
    '字典类型' AS category,
    COUNT(*) AS count
FROM sys_dict_type
WHERE dict_code IN ('check_in_type', 'approval_business_type', 'approval_action', 'approval_node_type', 'approval_reject_action', 'approval_instance_status', 'parent_agree_status')
UNION ALL
SELECT
    '字典数据' AS category,
    COUNT(*) AS count
FROM sys_dict_data
WHERE dict_code IN ('check_in_type', 'approval_business_type', 'approval_action', 'approval_node_type', 'approval_reject_action', 'approval_instance_status', 'parent_agree_status');

-- ===================================================
-- 执行完成后，请重启后端应用以刷新字典缓存
-- 或调用字典刷新接口:
-- POST /api/system/dict/refreshCache
-- ===================================================
