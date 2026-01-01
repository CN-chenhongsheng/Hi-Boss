-- ====================================
-- 添加设备类型字典
-- 创建日期：2025-01-01
-- ====================================

-- 插入字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`)
VALUES ('设备类型', 'sys_device_type', 1, '设备类型：1桌面设备 2移动设备 3爬虫/Bot')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `remark` = VALUES(`remark`);

-- 插入字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `list_class`, `sort`, `is_default`, `status`, `remark`) VALUES
('sys_device_type', '桌面设备', '1', '', 'primary', 1, 1, 1, '桌面设备（PC、笔记本等）'),
('sys_device_type', '移动设备', '2', '', 'success', 2, 0, 1, '移动设备（手机、平板等）'),
('sys_device_type', '爬虫/Bot', '3', '', 'info', 3, 0, 1, '爬虫/Bot（搜索引擎、API调用等）')
ON DUPLICATE KEY UPDATE
  `label` = VALUES(`label`),
  `css_class` = VALUES(`css_class`),
  `list_class` = VALUES(`list_class`),
  `sort` = VALUES(`sort`),
  `remark` = VALUES(`remark`);

