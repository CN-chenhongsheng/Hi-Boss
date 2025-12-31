package com.sushe.backend.controller;

import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.user.ChangePasswordDTO;
import com.sushe.backend.dto.user.UserProfileDTO;
import com.sushe.backend.service.SysUserService;
import com.sushe.backend.vo.UserVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 用户个人中心控制器
 *
 * @author 陈鸿昇
 * @since 2025-12-31
 */
@Slf4j
@Tag(name = "个人中心", description = "用户个人信息管理")
@RestController
@RequestMapping("/v1/user/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final SysUserService userService;

    /**
     * 获取当前用户个人信息
     */
    @Operation(summary = "获取个人信息")
    @GetMapping
    public R<UserVO> getProfile() {
        UserVO userVO = userService.getCurrentUserProfile();
        return R.ok(userVO);
    }

    /**
     * 更新当前用户个人信息
     */
    @Operation(summary = "更新个人信息")
    @PutMapping
    public R<Void> updateProfile(@Valid @RequestBody UserProfileDTO profileDTO) {
        boolean success = userService.updateCurrentUserProfile(profileDTO);
        return success ? R.ok() : R.fail("更新失败");
    }

    /**
     * 修改当前用户密码
     */
    @Operation(summary = "修改密码")
    @PutMapping("/password")
    public R<Void> changePassword(@Valid @RequestBody ChangePasswordDTO changePasswordDTO) {
        boolean success = userService.changeCurrentUserPassword(changePasswordDTO);
        return success ? R.ok() : R.fail("修改密码失败");
    }
}

