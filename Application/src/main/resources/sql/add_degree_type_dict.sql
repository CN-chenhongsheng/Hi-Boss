-- ====================================
-- 添加学位类型字典
-- 创建日期：2025-01-01
-- ====================================

-- 插入字典类型
INSERT INTO `sys_dict_type` (`dict_name`, `dict_code`, `status`, `remark`)
VALUES ('学位类型', 'degree_type', 1, '学位类型：专科、本科、研究生')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `remark` = VALUES(`remark`);

-- 插入字典数据
INSERT INTO `sys_dict_data` (`dict_code`, `label`, `value`, `css_class`, `sort`, `is_default`, `status`, `remark`) VALUES
('degree_type', '专科', 'associate', '', 1, 0, 1, '专科'),
('degree_type', '本科', 'bachelor', '', 2, 1, 1, '本科'),
('degree_type', '研究生', 'graduate', '', 3, 0, 1, '研究生（包括硕士和博士）')
ON DUPLICATE KEY UPDATE
  `label` = VALUES(`label`),
  `css_class` = VALUES(`css_class`),
  `sort` = VALUES(`sort`),
  `remark` = VALUES(`remark`);

