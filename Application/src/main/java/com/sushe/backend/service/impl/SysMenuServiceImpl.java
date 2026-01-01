package com.sushe.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.common.context.UserContext;
import com.sushe.backend.common.exception.BusinessException;
import com.sushe.backend.dto.menu.MenuQueryDTO;
import com.sushe.backend.dto.menu.MenuSaveDTO;
import com.sushe.backend.entity.SysMenu;
import com.sushe.backend.entity.SysRoleMenu;
import com.sushe.backend.mapper.SysMenuMapper;
import com.sushe.backend.mapper.SysRoleMenuMapper;
import com.sushe.backend.service.SysMenuService;
import com.sushe.backend.util.DictUtils;
import com.sushe.backend.vo.MenuVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 系统菜单Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper, SysMenu> implements SysMenuService {

    private final SysRoleMenuMapper roleMenuMapper;

    /**
     * 查询菜单树形列表
     */
    @Override
    public List<MenuVO> treeList(MenuQueryDTO queryDTO) {
        // 查询所有菜单
        LambdaQueryWrapper<SysMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(queryDTO.getMenuName()), SysMenu::getMenuName, queryDTO.getMenuName())
               .eq(queryDTO.getMenuType() != null, SysMenu::getMenuType, queryDTO.getMenuType())
               .eq(queryDTO.getStatus() != null, SysMenu::getStatus, queryDTO.getStatus())
               .orderByAsc(SysMenu::getSort)
               .orderByAsc(SysMenu::getId);

        List<SysMenu> allMenus = list(wrapper);

        // 转换为VO并构建树形结构
        List<MenuVO> allMenuVOs = allMenus.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return buildMenuTree(allMenuVOs, 0L);
    }

    /**
     * 根据ID获取菜单详情
     */
    @Override
    public MenuVO getDetailById(Long id) {
        SysMenu menu = getById(id);
        if (menu == null) {
            throw new BusinessException("菜单不存在");
        }
        return convertToVO(menu);
    }

    /**
     * 保存菜单（新增或编辑）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveMenu(MenuSaveDTO saveDTO) {
        SysMenu menu = new SysMenu();
        BeanUtil.copyProperties(saveDTO, menu);

        if (saveDTO.getId() == null) {
            // 新增
            menu.setStatus(1); // 默认启用
            menu.setVisible(1); // 默认显示
            return save(menu);
        } else {
            // 编辑
            // 不能将父菜单设置为自己或自己的子菜单
            if (menu.getId().equals(menu.getParentId())) {
                throw new BusinessException("不能将父菜单设置为自己");
            }
            return updateById(menu);
        }
    }

    /**
     * 删除菜单
     * 级联删除所有子菜单及相关的角色菜单关系
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteMenu(Long id) {
        if (id == null) {
            throw new BusinessException("菜单ID不能为空");
        }

        // 级联删除所有子菜单
        cascadeDeleteChildren(id);

        // 删除与该菜单关联的角色菜单关系
        LambdaQueryWrapper<SysRoleMenu> roleMenuWrapper = new LambdaQueryWrapper<>();
        roleMenuWrapper.eq(SysRoleMenu::getMenuId, id);
        roleMenuMapper.delete(roleMenuWrapper);
        log.info("删除菜单关联的角色菜单关系，菜单ID：{}", id);

        // 删除菜单
        return removeById(id);
    }

    /**
     * 递归级联删除所有子菜单
     */
    private void cascadeDeleteChildren(Long parentId) {
        LambdaQueryWrapper<SysMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysMenu::getParentId, parentId);
        List<SysMenu> children = list(wrapper);

        if (children != null && !children.isEmpty()) {
            for (SysMenu child : children) {
                // 先删除子菜单的角色菜单关系
                LambdaQueryWrapper<SysRoleMenu> roleMenuWrapper = new LambdaQueryWrapper<>();
                roleMenuWrapper.eq(SysRoleMenu::getMenuId, child.getId());
                roleMenuMapper.delete(roleMenuWrapper);
                log.info("删除子菜单关联的角色菜单关系，菜单ID：{}", child.getId());

                // 递归删除子菜单的子菜单
                cascadeDeleteChildren(child.getId());

                // 删除子菜单
                removeById(child.getId());
                log.info("删除子菜单，菜单ID：{}，菜单名称：{}", child.getId(), child.getMenuName());
            }
        }
    }

    /**
     * 获取菜单树形选择器
     */
    @Override
    public List<MenuVO> getMenuTreeSelect() {
        // 查询所有正常状态的菜单
        LambdaQueryWrapper<SysMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysMenu::getStatus, 1)
               .in(SysMenu::getMenuType, "M", "C") // 只查询目录和菜单，不包括按钮
               .orderByAsc(SysMenu::getSort)
               .orderByAsc(SysMenu::getId);

        List<SysMenu> allMenus = list(wrapper);
        List<MenuVO> allMenuVOs = allMenus.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        // 添加顶级节点
        MenuVO topMenu = new MenuVO();
        topMenu.setId(0L);
        topMenu.setParentId(-1L);
        topMenu.setMenuName("顶级菜单");

        List<MenuVO> tree = buildMenuTree(allMenuVOs, 0L);

        List<MenuVO> result = new ArrayList<>();
        result.add(topMenu);
        result.addAll(tree);

        return result;
    }

    /**
     * 获取当前登录用户的菜单树
     */
    @Override
    public List<MenuVO> getUserMenuTree() {
        // 从 UserContext 获取当前登录用户ID
        Long userId = UserContext.getUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        // 查询用户有权限的菜单列表
        List<SysMenu> userMenus = baseMapper.selectMenusByUserId(userId);

        // 转换为VO并构建树形结构
        List<MenuVO> menuVOs = userMenus.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return buildMenuTree(menuVOs, 0L);
    }

    /**
     * 构建菜单树
     */
    private List<MenuVO> buildMenuTree(List<MenuVO> allMenus, Long parentId) {
        List<MenuVO> tree = new ArrayList<>();

        for (MenuVO menu : allMenus) {
            if (parentId.equals(menu.getParentId())) {
                // 递归查找子菜单
                List<MenuVO> children = buildMenuTree(allMenus, menu.getId());
                menu.setChildren(children);
                tree.add(menu);
            }
        }

        return tree;
    }

    /**
     * 实体转VO
     */
    private MenuVO convertToVO(SysMenu menu) {
        MenuVO vo = new MenuVO();
        BeanUtil.copyProperties(menu, vo);

        // 菜单类型文本（保持硬编码，因为这是系统固定的枚举值，不需要字典）
        String menuType = menu.getMenuType();
        if (menuType != null) {
            switch (menuType) {
                case "M" -> vo.setMenuTypeText("目录");
                case "C" -> vo.setMenuTypeText("菜单");
                case "F" -> vo.setMenuTypeText("按钮");
                default -> vo.setMenuTypeText("未知");
            }
        }

        // 可见文本（保持硬编码，因为这是系统固定的显示/隐藏状态）
        vo.setVisibleText(menu.getVisible() == 1 ? "显示" : "隐藏");

        // 状态文本（使用字典）
        vo.setStatusText(DictUtils.getLabel("sys_user_status", menu.getStatus(), "未知"));

        return vo;
    }

    /**
     * 更新菜单状态
     * 如果状态改为关闭，则级联关闭该菜单下的所有子菜单
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateStatus(Long id, Integer status) {
        SysMenu menu = getById(id);
        if (menu == null) {
            throw new BusinessException("菜单不存在");
        }

        // 如果要启用菜单，需要检查父菜单是否启用
        if (status == 1 && menu.getParentId() != null && menu.getParentId() != 0) {
            SysMenu parentMenu = getById(menu.getParentId());
            if (parentMenu != null && parentMenu.getStatus() != null && parentMenu.getStatus() == 0) {
                throw new BusinessException("上级菜单处于停用状态，不允许启用菜单");
            }
        }

        menu.setStatus(status);
        boolean result = updateById(menu);

        // 如果状态改为关闭（0），则级联关闭所有子菜单
        if (status == 0 && result) {
            cascadeUpdateChildrenStatus(id, 0);
        }

        return result;
    }

    /**
     * 递归级联更新所有子菜单的状态
     */
    private void cascadeUpdateChildrenStatus(Long parentId, Integer status) {
        LambdaQueryWrapper<SysMenu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysMenu::getParentId, parentId);
        List<SysMenu> children = list(wrapper);

        if (children != null && !children.isEmpty()) {
            for (SysMenu child : children) {
                child.setStatus(status);
                updateById(child);
                // 递归处理子菜单的子菜单
                cascadeUpdateChildrenStatus(child.getId(), status);
            }
        }
    }
}

