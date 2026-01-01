-- ====================================
-- 添加表格按钮配置字典
-- 创建日期：2025-01-01
-- ====================================

-- 插入字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`) 
VALUES ('表格按钮配置', 'table_button_config', 1, '表格操作按钮配置，包含图标、文字、样式等信息')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `remark` = VALUES(`remark`);

-- 插入字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `sort`, `is_default`, `status`, `remark`) VALUES
('table_button_config', '新增', 'add', 'bg-theme/12 text-theme', 1, 0, 1, 'ri:add-fill'),
('table_button_config', '编辑', 'edit', 'bg-secondary/12 text-secondary', 2, 0, 1, 'ri:pencil-line'),
('table_button_config', '删除', 'delete', 'bg-error/12 text-error', 3, 0, 1, 'ri:delete-bin-5-line'),
('table_button_config', '查看', 'view', 'bg-info/12 text-info', 4, 0, 1, 'ri:eye-line'),
('table_button_config', '更多', 'more', '', 5, 0, 1, 'ri:more-2-fill')
ON DUPLICATE KEY UPDATE 
  `label` = VALUES(`label`),
  `css_class` = VALUES(`css_class`),
  `sort` = VALUES(`sort`),
  `remark` = VALUES(`remark`);

