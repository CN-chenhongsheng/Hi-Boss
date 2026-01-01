package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.role.RoleQueryDTO;
import com.sushe.backend.dto.role.RoleSaveDTO;
import com.sushe.backend.service.SysRoleService;
import com.sushe.backend.vo.RolePermissionVO;
import com.sushe.backend.vo.RoleVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 系统角色控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/role")
@RequiredArgsConstructor
@Tag(name = "系统角色管理", description = "角色增删改查、权限分配等")
public class SysRoleController {

    private final SysRoleService roleService;

    @GetMapping("/list")
    @Operation(summary = "查询角色列表（分页）", description = "支持按角色编码、角色名称、状态查询")
    public R<PageResult<RoleVO>> list(RoleQueryDTO queryDTO) {
        log.info("查询角色列表，参数：{}", queryDTO);
        PageResult<RoleVO> result = roleService.pageList(queryDTO);
        return R.ok(result);
    }

    @GetMapping("/all")
    @Operation(summary = "查询所有角色（不分页）", description = "用于下拉选择等场景")
    public R<List<RoleVO>> listAll() {
        log.info("查询所有角色");
        List<RoleVO> list = roleService.listAll();
        return R.ok(list);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询角色详情")
    @Parameter(name = "id", description = "角色ID", required = true)
    public R<RoleVO> getDetail(@PathVariable Long id) {
        log.info("查询角色详情，ID：{}", id);
        RoleVO roleVO = roleService.getDetailById(id);
        return R.ok(roleVO);
    }

    @PostMapping
    @Operation(summary = "新增角色")
    public R<Void> add(@Valid @RequestBody RoleSaveDTO saveDTO) {
        log.info("新增角色，参数：{}", saveDTO);
        saveDTO.setId(null); // 确保ID为空
        boolean success = roleService.saveRole(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑角色")
    @Parameter(name = "id", description = "角色ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody RoleSaveDTO saveDTO) {
        log.info("编辑角色，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = roleService.saveRole(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除角色")
    @Parameter(name = "id", description = "角色ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除角色，ID：{}", id);
        boolean success = roleService.deleteRole(id);
        return R.status(success);
    }

    @DeleteMapping("/batch")
    @Operation(summary = "批量删除角色")
    public R<Void> batchDelete(@RequestBody Long[] ids) {
        log.info("批量删除角色，IDs：{}", (Object) ids);
        boolean success = roleService.batchDelete(ids);
        return R.status(success);
    }

    @PutMapping("/{id}/permissions")
    @Operation(summary = "分配角色菜单权限")
    @Parameter(name = "id", description = "角色ID", required = true)
    public R<Void> assignPermissions(@PathVariable Long id, @RequestBody Long[] menuIds) {
        log.info("分配角色菜单权限，角色ID：{}，菜单IDs：{}", id, (Object) menuIds);
        boolean success = roleService.assignMenus(id, menuIds);
        return R.ok("权限分配成功", null);
    }

    @GetMapping("/{id}/permissions")
    @Operation(summary = "获取角色的菜单权限列表（包含菜单状态）")
    @Parameter(name = "id", description = "角色ID", required = true)
    public R<List<RolePermissionVO>> getPermissions(@PathVariable Long id) {
        log.info("获取角色菜单权限，角色ID：{}", id);
        List<RolePermissionVO> permissions = roleService.getRolePermissions(id);
        return R.ok(permissions);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改角色状态")
    @Parameter(name = "id", description = "角色ID", required = true)
    @Parameter(name = "status", description = "状态：1正常 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改角色状态，ID：{}，状态：{}", id, status);
        boolean success = roleService.updateStatus(id, status);
        return R.ok(status == 1 ? "角色已启用" : "角色已停用", null);
    }
}

