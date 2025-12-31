package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.menu.MenuQueryDTO;
import com.sushe.backend.dto.menu.MenuSaveDTO;
import com.sushe.backend.service.SysMenuService;
import com.sushe.backend.vo.MenuVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 系统菜单控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/menu")
@RequiredArgsConstructor
@Tag(name = "系统菜单管理", description = "菜单树形列表、增删改查等")
public class SysMenuController {

    private final SysMenuService menuService;

    @GetMapping("/tree")
    @Operation(summary = "查询菜单树形列表", description = "返回树形结构的菜单列表")
    public R<List<MenuVO>> treeList(
            @Parameter(description = "菜单名称") @RequestParam(required = false) String menuName,
            @Parameter(description = "菜单类型：M目录 C菜单 F按钮") @RequestParam(required = false) String menuType,
            @Parameter(description = "状态：1正常 0停用") @RequestParam(required = false) Integer status
    ) {
        log.info("查询菜单树形列表，menuName：{}，menuType：{}，status：{}", menuName, menuType, status);

        // 构建查询DTO
        MenuQueryDTO queryDTO = new MenuQueryDTO();
        queryDTO.setMenuName(menuName);
        queryDTO.setMenuType(menuType);
        queryDTO.setStatus(status);

        List<MenuVO> tree = menuService.treeList(queryDTO);
        return R.ok(tree);
    }

    @GetMapping("/tree-select")
    @Operation(summary = "获取菜单树形选择器", description = "用于上级菜单选择，包含顶级菜单")
    public R<List<MenuVO>> getTreeSelect() {
        log.info("获取菜单树形选择器");
        List<MenuVO> tree = menuService.getMenuTreeSelect();
        return R.ok(tree);
    }

    @GetMapping("/user-tree")
    @Operation(summary = "获取当前用户菜单树", description = "根据当前登录用户的角色权限返回有权限查看的菜单树")
    public R<List<MenuVO>> getUserMenuTree() {
        log.info("获取当前用户菜单树");
        List<MenuVO> tree = menuService.getUserMenuTree();
        return R.ok(tree);
    }

    @GetMapping("/{id}")
    @Operation(summary = "根据ID查询菜单详情")
    @Parameter(name = "id", description = "菜单ID", required = true)
    public R<MenuVO> getDetail(@PathVariable Long id) {
        log.info("查询菜单详情，ID：{}", id);
        MenuVO menuVO = menuService.getDetailById(id);
        return R.ok(menuVO);
    }

    @PostMapping
    @Operation(summary = "新增菜单")
    public R<Void> add(@Valid @RequestBody MenuSaveDTO saveDTO) {
        log.info("新增菜单，参数：{}", saveDTO);
        saveDTO.setId(null); // 确保ID为空
        boolean success = menuService.saveMenu(saveDTO);
        return R.status(success);
    }

    @PutMapping("/{id}")
    @Operation(summary = "编辑菜单")
    @Parameter(name = "id", description = "菜单ID", required = true)
    public R<Void> update(@PathVariable Long id, @Valid @RequestBody MenuSaveDTO saveDTO) {
        log.info("编辑菜单，ID：{}，参数：{}", id, saveDTO);
        saveDTO.setId(id);
        boolean success = menuService.saveMenu(saveDTO);
        return R.status(success);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除菜单")
    @Parameter(name = "id", description = "菜单ID", required = true)
    public R<Void> delete(@PathVariable Long id) {
        log.info("删除菜单，ID：{}", id);
        boolean success = menuService.deleteMenu(id);
        return R.status(success);
    }

    @PutMapping("/{id}/status/{status}")
    @Operation(summary = "修改菜单状态")
    @Parameter(name = "id", description = "菜单ID", required = true)
    @Parameter(name = "status", description = "状态：1正常 0停用", required = true)
    public R<Void> updateStatus(@PathVariable Long id, @PathVariable Integer status) {
        log.info("修改菜单状态，ID：{}，状态：{}", id, status);
        boolean success = menuService.updateStatus(id, status);
        return R.ok(status == 1 ? "菜单已启用" : "菜单已停用", null);
    }
}

