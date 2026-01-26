-- 检查 sys_stay 表结构
DESCRIBE sys_stay;

-- 查看最近的留宿记录（包含新字段）
SELECT 
  id, 
  student_name, 
  stay_start_date, 
  stay_end_date,
  stay_reason,
  parent_name, 
  parent_phone, 
  parent_agree,
  signature,
  images,
  create_time
FROM sys_stay
ORDER BY create_time DESC
LIMIT 5;
