-- ============================================================
-- 初始化学生密码脚本
-- 功能：为所有尚未设置密码的学生设置初始密码（身份证后6位）
-- 说明：密码使用 BCrypt 加密，strength=10
-- ============================================================

-- 注意：此脚本需要在 Java 应用中执行，因为需要使用 BCrypt 加密
-- 以下是参考 SQL，实际需要通过后端批量更新

-- 示例：手动设置单个学生密码（需要先通过 BCrypt 加密）
-- UPDATE sys_student 
-- SET password = '$2a$10$...' -- 这里是 BCrypt 加密后的密码
-- WHERE student_no = '2021001';

-- 推荐方式：创建一个后端接口或定时任务来批量初始化密码
-- 逻辑：
-- 1. 查询所有 password 为 NULL 或空的学生
-- 2. 对于每个学生：
--    - 如果有身份证号，使用身份证后6位作为初始密码
--    - 如果没有身份证号，使用学号作为初始密码
--    - 使用 BCryptPasswordEncoder 加密密码
--    - 更新到数据库

-- 查询需要初始化密码的学生
SELECT id, student_no, student_name, id_card
FROM sys_student
WHERE password IS NULL OR password = ''
ORDER BY student_no;
