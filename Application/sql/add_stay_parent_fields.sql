-- 为留宿表添加家长信息与附件/签名字段
-- @author 陈鸿昇
-- @since 2026-01-25

ALTER TABLE sys_stay
ADD COLUMN parent_name VARCHAR(50) COMMENT '家长姓名' AFTER remark,
ADD COLUMN parent_phone VARCHAR(20) COMMENT '家长电话' AFTER parent_name,
ADD COLUMN parent_agree VARCHAR(20) COMMENT '家长是否同意：agree-同意 disagree-不同意' AFTER parent_phone,
ADD COLUMN signature VARCHAR(500) COMMENT '本人签名图片URL' AFTER parent_agree,
ADD COLUMN images TEXT COMMENT '附件图片列表（JSON字符串数组）' AFTER signature;
