-- ====================================
-- 添加操作日志业务类型字典
-- 创建日期：2025-01-01
-- ====================================

-- 插入字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`)
VALUES ('操作日志业务类型', 'sys_oper_business_type', 1, '操作日志业务类型：0其它 1新增 2修改 3删除')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `remark` = VALUES(`remark`);

-- 插入字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`) VALUES
('sys_oper_business_type', '其它', '0', '', 'info', 1, 0, 1, '其它操作'),
('sys_oper_business_type', '新增', '1', '', 'success', 2, 0, 1, '新增操作'),
('sys_oper_business_type', '修改', '2', '', 'warning', 3, 0, 1, '修改操作'),
('sys_oper_business_type', '删除', '3', '', 'danger', 4, 0, 1, '删除操作')
ON DUPLICATE KEY UPDATE
  `label` = VALUES(`label`),
  `css_class` = VALUES(`css_class`),
  `list_class` = VALUES(`list_class`),
  `sort` = VALUES(`sort`),
  `remark` = VALUES(`remark`);

