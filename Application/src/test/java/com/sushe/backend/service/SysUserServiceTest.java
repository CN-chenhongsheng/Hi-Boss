package com.sushe.backend.service;

import com.sushe.backend.dto.user.UserSaveDTO;
import com.sushe.backend.entity.SysUser;
import com.sushe.backend.mapper.SysUserMapper;
import com.sushe.backend.service.impl.SysUserServiceImpl;
import com.sushe.backend.vo.UserVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * 用户服务测试类
 *
 * 测试要点：
 * 1. 使用Mockito模拟依���
 * 2. 测试正常场景和异常场景
 * 3. 验证方法调用次数
 * 4. 使用AssertJ进行断言
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("用户服务测试")
public class SysUserServiceTest {

    @Mock
    private SysUserMapper userMapper;

    @Mock
    private BCryptPasswordEncoder passwordEncoder;

    @InjectMocks
    private SysUserServiceImpl userService;

    private SysUser testUser;
    private UserSaveDTO userSaveDTO;

    @BeforeEach
    void setUp() {
        // 初始化测试数据
        testUser = new SysUser();
        testUser.setId(1L);
        testUser.setUsername("testuser");
        testUser.setPassword("$2a$10$encodedPassword");
        testUser.setNickname("测试用户");
        testUser.setPhone("13800138000");
        testUser.setEmail("test@example.com");
        testUser.setStatus(1);
        testUser.setCreateTime(LocalDateTime.now());
        testUser.setUpdateTime(LocalDateTime.now());
        testUser.setDelFlag(0);

        userSaveDTO = new UserSaveDTO();
        userSaveDTO.setUsername("testuser");
        userSaveDTO.setPassword("password123");
        userSaveDTO.setNickname("测试用户");
        userSaveDTO.setPhone("13800138000");
        userSaveDTO.setEmail("test@example.com");
        userSaveDTO.setStatus(1);
    }

    @Test
    @DisplayName("创建用户-成功")
    void testCreateUser_Success() {
        // Given
        when(userMapper.selectByUsername(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("$2a$10$encodedPassword");
        when(userMapper.insert(any(SysUser.class))).thenReturn(1);

        // When
        boolean result = userService.saveUser(userSaveDTO);

        // Then
        assertThat(result).isTrue();
        verify(userMapper, times(1)).selectByUsername("testuser");
        verify(passwordEncoder, times(1)).encode("password123");
        verify(userMapper, times(1)).insert(any(SysUser.class));
    }

    @Test
    @DisplayName("创建用户-用户名已存在")
    void testCreateUser_UsernameExists() {
        // Given
        when(userMapper.selectByUsername(anyString())).thenReturn(testUser);

        // When & Then
        assertThatThrownBy(() -> userService.saveUser(userSaveDTO))
            .isInstanceOf(RuntimeException.class)
            .hasMessageContaining("用户名已存在");

        verify(userMapper, times(1)).selectByUsername("testuser");
        verify(userMapper, never()).insert(any(SysUser.class));
    }

    @Test
    @DisplayName("根据ID获取用户-成功")
    void testGetDetailById_Success() {
        // Given
        when(userMapper.selectById(1L)).thenReturn(testUser);

        // When
        UserVO userVO = userService.getDetailById(1L);

        // Then
        assertThat(userVO).isNotNull();
        assertThat(userVO.getUsername()).isEqualTo("testuser");
        assertThat(userVO.getNickname()).isEqualTo("测试用户");
        verify(userMapper, times(1)).selectById(1L);
    }

    @Test
    @DisplayName("根据ID获取用户-用户不存在")
    void testGetDetailById_NotFound() {
        // Given
        when(userMapper.selectById(999L)).thenReturn(null);

        // When
        UserVO userVO = userService.getDetailById(999L);

        // Then
        assertThat(userVO).isNull();
        verify(userMapper, times(1)).selectById(999L);
    }

    @Test
    @DisplayName("更新用户-成功")
    void testUpdateUser_Success() {
        // Given
        UserSaveDTO updateUserDTO = new UserSaveDTO();
        updateUserDTO.setId(1L);
        updateUserDTO.setNickname("更新后的用户");
        updateUserDTO.setPhone("13900139000");

        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(userMapper.updateById(any(SysUser.class))).thenReturn(1);

        // When
        boolean result = userService.saveUser(updateUserDTO);

        // Then
        assertThat(result).isTrue();
        verify(userMapper, times(1)).selectById(1L);
        verify(userMapper, times(1)).updateById(any(SysUser.class));
    }

    @Test
    @DisplayName("删除用户-成功")
    void testDeleteUser_Success() {
        // Given
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(userMapper.deleteById(1L)).thenReturn(1);

        // When
        boolean result = userService.deleteUser(1L);

        // Then
        assertThat(result).isTrue();
        verify(userMapper, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("分页查询用户-成功")
    void testPageList_Success() {
        // Given
        SysUser user2 = new SysUser();
        user2.setId(2L);
        user2.setUsername("user2");
        user2.setNickname("用户2");

        when(userMapper.selectList(any())).thenReturn(Arrays.asList(testUser, user2));

        // When
        // UserQueryDTO需要根据实际情况创建
        // List<UserVO> users = userService.pageList(queryDTO);

        // 这里暂时注释掉，因为没有UserQueryDTO的具体实现
        // TODO: 实现分页查询测试
    }

    @Test
    @DisplayName("修改密码-成功")
    void testChangePassword_Success() {
        // Given
        String oldPassword = "password123";
        String newPassword = "newPassword456";
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(passwordEncoder.matches(oldPassword, testUser.getPassword())).thenReturn(true);
        when(passwordEncoder.encode(newPassword)).thenReturn("$2a$10$newEncodedPassword");
        when(userMapper.updateById(any(SysUser.class))).thenReturn(1);

        // When
        boolean result = userService.changeCurrentUserPassword(
            new com.sushe.backend.dto.user.ChangePasswordDTO(1L, oldPassword, newPassword));

        // Then
        assertThat(result).isTrue();
        verify(userMapper, times(1)).selectById(1L);
        verify(passwordEncoder, times(1)).matches(oldPassword, testUser.getPassword());
        verify(passwordEncoder, times(1)).encode(newPassword);
        verify(userMapper, times(1)).updateById(any(SysUser.class));
    }

    @Test
    @DisplayName("修改密码-旧密码错误")
    void testChangePassword_OldPasswordIncorrect() {
        // Given
        String oldPassword = "wrongPassword";
        String newPassword = "newPassword456";
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(passwordEncoder.matches(oldPassword, testUser.getPassword())).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> userService.changeCurrentUserPassword(
            new com.sushe.backend.dto.user.ChangePasswordDTO(1L, oldPassword, newPassword)))
            .isInstanceOf(RuntimeException.class)
            .hasMessageContaining("旧密码错误");

        verify(userMapper, times(1)).selectById(1L);
        verify(passwordEncoder, times(1)).matches(oldPassword, testUser.getPassword());
        verify(passwordEncoder, never()).encode(anyString());
        verify(userMapper, never()).updateById(any(SysUser.class));
    }
}
