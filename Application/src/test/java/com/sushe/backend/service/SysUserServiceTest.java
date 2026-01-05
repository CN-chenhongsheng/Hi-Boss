package com.sushe.backend.service;

import com.sushe.backend.dto.UserDTO;
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
    private UserDTO userDTO;

    @BeforeEach
    void setUp() {
        // 初始化测试数据
        testUser = new SysUser();
        testUser.setId(1L);
        testUser.setUsername("testuser");
        testUser.setPassword("$2a$10$encodedPassword");
        testUser.setRealName("测试用户");
        testUser.setPhone("13800138000");
        testUser.setEmail("test@example.com");
        testUser.setStatus(1);
        testUser.setCreateTime(LocalDateTime.now());
        testUser.setUpdateTime(LocalDateTime.now());
        testUser.setDeleted(0);

        userDTO = new UserDTO();
        userDTO.setUsername("testuser");
        userDTO.setPassword("password123");
        userDTO.setRealName("测试用户");
        userDTO.setPhone("13800138000");
        userDTO.setEmail("test@example.com");
    }

    @Test
    @DisplayName("创建用户-成功")
    void testCreateUser_Success() {
        // Given
        when(userMapper.selectByUsername(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("$2a$10$encodedPassword");
        when(userMapper.insert(any(SysUser.class))).thenReturn(1);

        // When
        Long userId = userService.createUser(userDTO);

        // Then
        assertThat(userId).isNotNull();
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
        assertThatThrownBy(() -> userService.createUser(userDTO))
            .isInstanceOf(RuntimeException.class)
            .hasMessageContaining("用户名已存在");

        verify(userMapper, times(1)).selectByUsername("testuser");
        verify(userMapper, never()).insert(any(SysUser.class));
    }

    @Test
    @DisplayName("根据ID获取用户-成功")
    void testGetUserById_Success() {
        // Given
        when(userMapper.selectById(1L)).thenReturn(testUser);

        // When
        UserVO userVO = userService.getUserById(1L);

        // Then
        assertThat(userVO).isNotNull();
        assertThat(userVO.getUsername()).isEqualTo("testuser");
        assertThat(userVO.getRealName()).isEqualTo("测试用户");
        verify(userMapper, times(1)).selectById(1L);
    }

    @Test
    @DisplayName("根据ID获取用户-用户不存在")
    void testGetUserById_NotFound() {
        // Given
        when(userMapper.selectById(999L)).thenReturn(null);

        // When
        UserVO userVO = userService.getUserById(999L);

        // Then
        assertThat(userVO).isNull();
        verify(userMapper, times(1)).selectById(999L);
    }

    @Test
    @DisplayName("更新用户-成功")
    void testUpdateUser_Success() {
        // Given
        UserDTO updateUserDTO = new UserDTO();
        updateUserDTO.setId(1L);
        updateUserDTO.setRealName("更新后的用户");
        updateUserDTO.setPhone("13900139000");

        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(userMapper.updateById(any(SysUser.class))).thenReturn(1);

        // When
        boolean result = userService.updateUser(updateUserDTO);

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
        verify(userMapper, times(1)).selectById(1L);
        verify(userMapper, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("获取所有用户-成功")
    void testGetAllUsers_Success() {
        // Given
        SysUser user2 = new SysUser();
        user2.setId(2L);
        user2.setUsername("user2");
        user2.setRealName("用户2");

        when(userMapper.selectList(any())).thenReturn(Arrays.asList(testUser, user2));

        // When
        List<UserVO> users = userService.getAllUsers();

        // Then
        assertThat(users).hasSize(2);
        assertThat(users.get(0).getUsername()).isEqualTo("testuser");
        assertThat(users.get(1).getUsername()).isEqualTo("user2");
        verify(userMapper, times(1)).selectList(any());
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
        boolean result = userService.changePassword(1L, oldPassword, newPassword);

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
        assertThatThrownBy(() -> userService.changePassword(1L, oldPassword, newPassword))
            .isInstanceOf(RuntimeException.class)
            .hasMessageContaining("旧密码错误");

        verify(userMapper, times(1)).selectById(1L);
        verify(passwordEncoder, times(1)).matches(oldPassword, testUser.getPassword());
        verify(passwordEncoder, never()).encode(anyString());
        verify(userMapper, never()).updateById(any(SysUser.class));
    }
}
