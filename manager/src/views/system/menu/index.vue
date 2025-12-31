<!-- 菜单管理页面 -->
<template>
  <div class="menu-page art-full-height">
    <!-- 搜索栏 -->
    <ArtSearchBar
      v-model="formFilters"
      :items="formItems"
      :showExpand="false"
      @reset="handleReset"
      @search="handleSearch"
    />

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader
        :showZebra="false"
        :loading="loading"
        v-model:columns="columnChecks"
        @refresh="handleRefresh"
      >
        <template #left>
          <ElSpace wrap>
            <ElButton @click="handleAddMenu" v-ripple v-permission="'system:menu:add'">
              添加菜单
            </ElButton>
            <ElButton @click="toggleExpand" v-ripple>
              {{ isExpanded ? '收起全部' : '展开全部' }}
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        ref="tableRef"
        rowKey="id"
        :loading="loading"
        :columns="columns"
        :data="tableData"
        :stripe="false"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="false"
      />

      <!-- 菜单弹窗 -->
      <MenuDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        @submit="handleSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { useTableColumns } from '@/hooks/core/useTableColumns'
  import MenuDialog from './modules/menu-dialog.vue'
  import { fetchGetMenuList, fetchDeleteMenu, fetchUpdateMenuStatus } from '@/api/system-manage'
  import { ElTag, ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'

  defineOptions({ name: 'Menus' })

  type MenuListItem = Api.SystemManage.MenuListItem & { _statusLoading?: boolean }

  // 状态管理
  const loading = ref(false)
  const isExpanded = ref(false)
  const tableRef = ref()

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<MenuListItem | null>(null)

  // 搜索相关
  const initialSearchState = {
    menuName: '',
    status: undefined
  }

  const formFilters = reactive({ ...initialSearchState })

  const formItems = computed(() => [
    {
      label: '菜单名称',
      key: 'menuName',
      type: 'input',
      props: { clearable: true, placeholder: '请输入菜单名称' }
    },
    {
      label: '状态',
      key: 'status',
      type: 'select',
      props: {
        clearable: true,
        placeholder: '请选择状态',
        options: [
          { label: '正常', value: 1 },
          { label: '停用', value: 0 }
        ]
      }
    }
  ])

  onMounted(() => {
    getMenuList()
  })

  /**
   * 获取菜单列表数据
   */
  const getMenuList = async (): Promise<void> => {
    loading.value = true

    try {
      const params: Api.SystemManage.MenuSearchParams = {}
      if (formFilters.menuName) {
        params.menuName = formFilters.menuName
      }
      if (formFilters.status !== undefined) {
        params.status = formFilters.status
      }

      const list = await fetchGetMenuList(params)
      tableData.value = list
    } catch (error) {
      console.error('获取菜单失败:', error)
      ElMessage.error('获取菜单列表失败')
    } finally {
      loading.value = false
    }
  }

  /**
   * 获取菜单类型标签颜色
   */
  const getMenuTypeTag = (type: string): 'primary' | 'success' | 'info' => {
    const typeMap: Record<string, 'primary' | 'success' | 'info'> = {
      M: 'info', // 目录
      C: 'primary', // 菜单
      F: 'success' // 按钮
    }
    return typeMap[type] || 'info'
  }

  /**
   * 获取菜单类型文本
   */
  const getMenuTypeText = (type: string): string => {
    const typeMap: Record<string, string> = {
      M: '目录',
      C: '菜单',
      F: '按钮'
    }
    return typeMap[type] || '未知'
  }

  /**
   * 获取菜单图标
   */
  const getMenuIcon = (icon?: string) => {
    return icon || 'i-carbon-document'
  }

  // 表格列配置
  const { columnChecks, columns } = useTableColumns(() => [
    {
      prop: 'menuName',
      label: '菜单名称',
      minWidth: 200,
      formatter: (row: MenuListItem) => {
        return h('div', { class: 'flex items-center gap-2' }, [
          h('i', { class: `${getMenuIcon(row.icon)} text-lg` }),
          h('span', row.menuName)
        ])
      }
    },
    {
      prop: 'menuType',
      label: '类型',
      width: 80,
      formatter: (row: MenuListItem) => {
        return h(ElTag, { type: getMenuTypeTag(row.menuType), size: 'small' }, () =>
          getMenuTypeText(row.menuType)
        )
      }
    },
    {
      prop: 'path',
      label: '路由路径',
      minWidth: 150,
      formatter: (row: MenuListItem) => {
        return row.path || '-'
      }
    },
    {
      prop: 'component',
      label: '组件路径',
      minWidth: 180,
      showOverflowTooltip: true,
      formatter: (row: MenuListItem) => {
        return row.component || '-'
      }
    },
    {
      prop: 'permission',
      label: '权限标识',
      minWidth: 150,
      formatter: (row: MenuListItem) => {
        if (!row.permission) return '-'
        return `${row.permission.split(',').length} 个权限标识`
      }
    },
    {
      prop: 'sort',
      label: '排序',
      width: 80,
      sortable: true
    },
    {
      prop: 'visible',
      label: '可见',
      width: 80,
      formatter: (row: MenuListItem) => {
        return h(
          ElTag,
          {
            type: row.visible === 1 ? 'success' : 'info',
            size: 'small'
          },
          () => (row.visible === 1 ? '是' : '否')
        )
      }
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: MenuListItem) => {
        return h(ArtSwitch, {
          modelValue: row.status === 1,
          loading: row._statusLoading || false,
          inlinePrompt: true,
          onChange: (value: string | number | boolean) => {
            handleStatusChange(row, value === true || value === 1)
          }
        })
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      width: 180
    },
    {
      prop: 'operation',
      label: '操作',
      width: 180,
      fixed: 'right',
      formatter: (row: MenuListItem) => {
        const buttons = []
        // 只有目录和菜单可以添加子菜单/按钮
        if (hasPermission('system:menu:add') && (row.menuType === 'M' || row.menuType === 'C')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'add',
              tooltip: '添加',
              onClick: () => handleAddSubMenu(row)
            })
          )
        }
        if (hasPermission('system:menu:edit')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => handleEditMenu(row)
            })
          )
        }
        if (hasPermission('system:menu:delete')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => handleDeleteMenu(row)
            })
          )
        }
        return h('div', buttons)
      }
    }
  ])

  // 数据相关
  const tableData = ref<MenuListItem[]>([])

  /**
   * 重置搜索条件
   */
  const handleReset = (): void => {
    Object.assign(formFilters, { ...initialSearchState })
    getMenuList()
  }

  /**
   * 执行搜索
   */
  const handleSearch = (): void => {
    getMenuList()
  }

  /**
   * 刷新菜单列表
   */
  const handleRefresh = (): void => {
    getMenuList()
  }

  /**
   * 添加顶级菜单
   */
  const handleAddMenu = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 添加子菜单
   */
  const handleAddSubMenu = (row: MenuListItem): void => {
    dialogType.value = 'add'
    editData.value = { parentId: row.id } as MenuListItem
    dialogVisible.value = true
  }

  /**
   * 编辑菜单
   */
  const handleEditMenu = (row: MenuListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 提交表单数据
   */
  const handleSubmit = (): void => {
    getMenuList()
  }

  /**
   * 删除菜单
   */
  const handleDeleteMenu = async (row: MenuListItem): Promise<void> => {
    // 检查是否有子菜单
    if (row.children && row.children.length > 0) {
      ElMessage.warning('该菜单下有子菜单，请先删除子菜单')
      return
    }

    try {
      await ElMessageBox.confirm(`确定要删除菜单"${row.menuName}"吗？删除后无法恢复`, '删除确认', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })

      await fetchDeleteMenu(row.id)
      await getMenuList()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除菜单失败:', error)
      }
    }
  }

  /**
   * 切换展开/收起所有菜单
   */
  const toggleExpand = (): void => {
    isExpanded.value = !isExpanded.value
    nextTick(() => {
      if (tableRef.value?.elTableRef && tableData.value) {
        const processRows = (rows: MenuListItem[]) => {
          rows.forEach((row) => {
            if (row.children?.length) {
              tableRef.value.elTableRef.toggleRowExpansion(row, isExpanded.value)
              processRows(row.children)
            }
          })
        }
        processRows(tableData.value)
      }
    })
  }

  /**
   * 更新菜单状态
   */
  const handleStatusChange = async (row: MenuListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateMenuStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新菜单状态失败:', error)
      ElMessage.error('更新菜单状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>

<style scoped lang="scss">
  .menu-page {
    :deep(.el-table) {
      .el-table__row {
        .cell {
          display: flex;
          align-items: center;
        }
      }
    }
  }
</style>
