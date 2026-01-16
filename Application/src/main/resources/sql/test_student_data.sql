-- ============================================================
-- 测试学生数据脚本
-- 功能：创建测试学生账号用于登录功能测试
-- ============================================================

-- 测试学生1：张三
-- 学号：2021001
-- 初始密码：123456（身份证后6位）
-- BCrypt 加密后的密码（strength=10）
INSERT INTO sys_student (
    student_no, 
    student_name, 
    gender, 
    id_card, 
    phone, 
    email,
    enrollment_year,
    schooling_length,
    current_grade,
    academic_status,
    status,
    password,
    create_time,
    update_time
) VALUES (
    '2021001',
    '张三',
    1,
    '320102199901123456',
    '13800138001',
    'zhangsan@example.com',
    2021,
    4,
    '大三',
    1,
    1,
    '$2a$10$kutnHxYZ9sAN0aluqHKBXuJctNg.HTztmKUwqcIsRlmqSYySqSinS', -- 密码: 123456
    NOW(),
    NOW()
);

-- 测试学生2：李四
-- 学号：2021002
-- 初始密码：654321（身份证后6位）
INSERT INTO sys_student (
    student_no, 
    student_name, 
    gender, 
    id_card, 
    phone, 
    email,
    enrollment_year,
    schooling_length,
    current_grade,
    academic_status,
    status,
    password,
    create_time,
    update_time
) VALUES (
    '2021002',
    '李四',
    2,
    '320102199902234654',
    '13800138002',
    'lisi@example.com',
    2021,
    4,
    '大三',
    1,
    1,
    '$2a$10$0QdMZpT9OAscydeo8reBAuWfvdrdkLUJ/BojEvR1AN.j6obO8/JDC', -- 密码: 654321（需要重新生成）
    NOW(),
    NOW()
);

-- 测试学生3：王五（用于测试微信登录）
-- 学号：2021003
-- 初始密码：111111
-- 绑定 openid：test_openid_wangwu
INSERT INTO sys_student (
    student_no, 
    student_name, 
    gender, 
    id_card, 
    phone, 
    email,
    enrollment_year,
    schooling_length,
    current_grade,
    academic_status,
    status,
    password,
    openid,
    create_time,
    update_time
) VALUES (
    '2021003',
    '王五',
    1,
    '320102199903111111',
    '13800138003',
    'wangwu@example.com',
    2021,
    4,
    '大三',
    1,
    1,
    '$2a$10$eWQqpPDInOx7FbfUFyhr8O/s0zUtA6ILn9vcmPpT6/NeWx3RIajJG', -- 密码: 111111
    'test_openid_wangwu',
    NOW(),
    NOW()
);

-- ============================================================
-- 注意事项
-- ============================================================
-- 1. 以上密码都是使用 BCrypt 加密的，可以使用以下 Java 代码生成：
--    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
--    String encoded = encoder.encode("明文密码");
--
-- 2. 测试账号信息：
--    学号：2021001，密码：123456
--    学号：2021002，密码：654321（密码hash需重新生成）
--    学号：2021003，密码：111111，openid: test_openid_wangwu
--
-- 3. 微信登录测试：
--    使用 openid: test_openid_wangwu 进行测试
--
-- 4. 生产环境请删除这些测试数据
-- ============================================================
