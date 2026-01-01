package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.user.RoleUserQueryDTO;
import com.sushe.backend.dto.user.UserQueryDTO;
import com.sushe.backend.dto.user.UserResetPasswordDTO;
import com.sushe.backend.dto.user.UserSaveDTO;
import com.sushe.backend.service.SysUserService;
import com.sushe.backend.vo.UserSimpleVO;
import com.sushe.backend.vo.UserVO;

import java.util.List;
import java.util.Map;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 系统用户控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/user")
@RequiredArgsConstructor
@Tag(name = "系统用户管理", description = "用户增删改查、重置密码、状态管理等")
public class SysUserController {

    private final SysUserService userService;

    @GetMapping("/list")
    @Operation(summary = "查询用户列表（分页）", description = "支持按用户名、昵称、手机号、学院、状态查询")
    public R<PageResult<UserVO>> list(UserQueryDTO queryDTO) {
        log.info("查询用户列表，参数：{}", queryDTO);
        PageResult<UserVO> result = userService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询用户详情")
    @Parameter(name = "id", description = "用户ID", required = true)
    public R<UserVO> getDetail(@PathVariable Long id) {
        log.info("查询用户详情，ID：{}", id);
        UserVO userVO = userService.getDetailById(id);
        return R.ok(userVO);
    }

    @PostMapping
    @Operation(summary = "新增用户")
    public R<Void> add(@Valid @RequestBody UserSaveDTO saveDTO) {
        log.info("新增用户，参数：{}", saveDTO);
        saveDTO.setId(null); // 确保ID为空
        boolean success = userService.saveUser(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑用户")
    @Parameter(name = "id", description = "用户ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody UserSaveDTO saveDTO) {
        log.info("编辑用户，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = userService.saveUser(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除用户")
    @Parameter(name = "id", description = "用户ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除用户，ID：{}", id);
        boolean success = userService.deleteUser(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除用户")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除用户，IDs：{}", (Object) ids);
        boolean success = userService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/reset-password")
    @Operation(summary = "重置用户密码")
    @Parameter(name = "id", description = "用户ID", required = true)
    public R<Void> resetPassword(@PathVariable Long id, @Valid @RequestBody UserResetPasswordDTO resetDTO) {
        log.info("重置用户密码，ID：{}", id);
        resetDTO.setUserId(id);
        boolean success = userService.resetPassword(resetDTO);
        return R.ok("密码重置成功", null);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改用户状态")
    @Parameter(name = "id", description = "用户ID", required = true)
    @Parameter(name = "status", description = "状态：1正常 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改用户状态，ID：{}，状态：{}", id, status);
        boolean success = userService.updateStatus(id, status);
        return R.ok(status == 1 ? "用户已启用" : "用户已停用", null);
    }

    @PostMapping("/by-roles")
    @Operation(summary = "根据角色代码列表查询用户列表", description = "支持多个角色代码，返回Map格式，key为角色代码，value为用户列表")
    public R<Map<String, List<UserSimpleVO>>> getUsersByRoleCodes(@Valid @RequestBody RoleUserQueryDTO queryDTO) {
        log.info("根据角色代码查询用户列表，角色代码：{}", queryDTO.getRoleCodes());
        Map<String, List<UserSimpleVO>> result = userService.getUsersByRoleCodes(queryDTO);
        return R.ok(result);
    }
}

