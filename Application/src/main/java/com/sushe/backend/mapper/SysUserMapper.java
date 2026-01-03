package com.sushe.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.sushe.backend.dto.user.UserWithRoleCodeDTO;
import com.sushe.backend.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 系统用户Mapper
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {

    /**
     * 根据角色代码列表查询用户列表
     * 
     * @param roleCodes 角色代码列表
     * @return 用户列表（包含角色代码）
     */
    @Select("<script>" +
            "SELECT DISTINCT u.id, u.username, u.nickname, u.phone, u.email, " +
            "REPLACE(REPLACE(TRIM(r.role_code), CHAR(13), ''), CHAR(10), '') as roleCode " +
            "FROM sys_user u " +
            "INNER JOIN sys_user_role ur ON u.id = ur.user_id " +
            "INNER JOIN sys_role r ON ur.role_id = r.id " +
            "WHERE REPLACE(REPLACE(TRIM(r.role_code), CHAR(13), ''), CHAR(10), '') IN " +
            "<foreach collection='roleCodes' item='roleCode' open='(' separator=',' close=')'>" +
            "#{roleCode}" +
            "</foreach> " +
            "AND u.status = 1 AND r.status = 1 " +
            "ORDER BY REPLACE(REPLACE(TRIM(r.role_code), CHAR(13), ''), CHAR(10), ''), u.id" +
            "</script>")
    List<UserWithRoleCodeDTO> selectUsersByRoleCodes(@Param("roleCodes") List<String> roleCodes);
}

