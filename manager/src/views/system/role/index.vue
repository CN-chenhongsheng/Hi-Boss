<!-- 角色管理页面 -->
<template>
  <div class="art-full-height">
    <RoleSearch
      v-show="showSearchBar"
      v-model="searchForm"
      @search="handleSearch"
      @reset="resetSearchParams"
    ></RoleSearch>

    <ElCard
      class="art-table-card"
      shadow="never"
      :style="{ 'margin-top': showSearchBar ? '12px' : '0' }"
    >
      <ArtTableHeader
        v-model:columns="columnChecks"
        v-model:showSearchBar="showSearchBar"
        :loading="loading"
        @refresh="refreshData"
      >
        <template #left>
          <ElSpace wrap>
            <ElButton @click="showDialog('add')" v-ripple v-permission="'system:role:add'">
              新增角色
            </ElButton>
            <ElButton
              :disabled="selectedRows.length === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:role:delete'"
            >
              批量删除
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <!-- 表格 -->
      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
        :pagination="pagination"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      >
      </ArtTable>
    </ElCard>

    <!-- 角色编辑弹窗 -->
    <RoleEditDialog
      v-model="dialogVisible"
      :dialog-type="dialogType"
      :role-data="currentRoleData"
      @success="handleEditDialogSuccess"
    />

    <!-- 菜单权限弹窗 -->
    <RolePermissionDialog
      v-model="permissionDialog"
      :role-data="currentRoleData"
      @success="refreshUpdate"
    />
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import { fetchGetRoleList, fetchDeleteRole, fetchUpdateRoleStatus } from '@/api/system-manage'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import RoleSearch from './modules/role-search.vue'
  import RoleEditDialog from './modules/role-edit-dialog.vue'
  import RolePermissionDialog from './modules/role-permission-dialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'

  defineOptions({ name: 'Role' })

  type RoleListItem = Api.SystemManage.RoleListItem & { _statusLoading?: boolean }

  // 搜索表单
  const searchForm = ref<Api.SystemManage.RoleSearchParams>({
    pageNum: 1,
    pageSize: 20,
    roleName: undefined,
    roleCode: undefined,
    status: undefined
  })

  const showSearchBar = ref(false)
  const dialogVisible = ref(false)
  const permissionDialog = ref(false)
  const currentRoleData = ref<RoleListItem | undefined>(undefined)
  const selectedRows = ref<RoleListItem[]>([])

  const {
    columns,
    columnChecks,
    data,
    loading,
    pagination,
    getData,
    searchParams,
    resetSearchParams,
    handleSizeChange,
    handleCurrentChange,
    refreshData,
    refreshCreate,
    refreshUpdate,
    refreshRemove
  } = useTable({
    // 核心配置
    core: {
      apiFn: fetchGetRoleList,
      apiParams: {
        pageNum: 1,
        pageSize: 20
      },
      // 自定义分页字段映射
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        { type: 'selection' },
        {
          prop: 'roleName',
          label: '角色名称',
          minWidth: 150,
          formatter: (row: RoleListItem) => {
            return h('div', { class: 'flex items-center gap-2' }, [
              h('span', { class: 'font-medium' }, `${row.roleName as string}#${row.id}`)
            ])
          }
        },
        {
          prop: 'roleCode',
          label: '角色编码',
          minWidth: 150,
          formatter: (row: RoleListItem) => {
            return row.roleCode
          }
        },
        {
          prop: 'sort',
          label: '排序',
          width: 80,
          sortable: true
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: RoleListItem) => {
            const isSuperAdmin = row.roleCode === 'SUPER_ADMIN'
            return h(ArtSwitch, {
              modelValue: row.status === 1,
              loading: row._statusLoading || false,
              inlinePrompt: true,
              disabled: isSuperAdmin, // 超级管理员禁用开关
              onChange: (value: string | number | boolean) => {
                handleStatusChange(row, value === true || value === 1)
              }
            })
          }
        },
        {
          prop: 'remark',
          label: '备注',
          minWidth: 200,
          showOverflowTooltip: true
        },
        {
          prop: 'createTime',
          label: '创建时间',
          width: 180,
          sortable: true
        },
        {
          prop: 'operation',
          label: '操作',
          width: 180,
          fixed: 'right',
          formatter: (row: RoleListItem) => {
            const buttons = []
            if (hasPermission('system:role:assign')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'share',
                  onClick: () => showPermissionDialog(row)
                })
              )
            }
            if (hasPermission('system:role:edit')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'edit',
                  onClick: () => showDialog('edit', row)
                })
              )
            }
            // 超级管理员角色不允许删除
            if (hasPermission('system:role:delete') && row.roleCode !== 'SUPER_ADMIN') {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'delete',
                  onClick: () => deleteRole(row)
                })
              )
            }
            return h('div', buttons)
          }
        }
      ]
    }
  })

  const dialogType = ref<'add' | 'edit'>('add')

  const showDialog = (type: 'add' | 'edit', row?: RoleListItem) => {
    dialogVisible.value = true
    dialogType.value = type
    currentRoleData.value = row
  }

  /**
   * 搜索处理
   */
  const handleSearch = (params: Record<string, any>) => {
    console.log('搜索参数:', params)
    Object.assign(searchParams, params, { pageNum: 1 })
    getData()
  }

  /**
   * 显示权限分配弹窗
   */
  const showPermissionDialog = (row?: RoleListItem) => {
    permissionDialog.value = true
    currentRoleData.value = row
  }

  /**
   * 处理编辑弹窗成功事件
   */
  const handleEditDialogSuccess = async () => {
    // 根据 dialogType 判断是新增还是编辑
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 删除角色
   */
  const deleteRole = async (row: RoleListItem) => {
    // 防止删除超级管理员角色
    if (row.roleCode === 'SUPER_ADMIN') {
      ElMessage.warning('超级管理员角色不允许删除')
      return
    }

    try {
      await ElMessageBox.confirm(`确定删除角色"${row.roleName}"吗？此操作不可恢复！`, '删除确认', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })

      await fetchDeleteRole(row.id)
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除角色失败:', error)
      }
    }
  }

  /**
   * 批量删除
   */
  const handleBatchDelete = async () => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请先选择要删除的角色')
      return
    }

    // 检查是否包含超级管理员
    const hasSuperAdmin = selectedRows.value.some((row) => row.roleCode === 'SUPER_ADMIN')
    if (hasSuperAdmin) {
      ElMessage.warning('选中的角色中包含超级管理员，无法删除')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要删除选中的 ${selectedRows.value.length} 个角色吗？此操作不可恢复！`,
        '批量删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      // 逐个删除
      for (const role of selectedRows.value) {
        await fetchDeleteRole(role.id)
      }

      ElMessage.success('批量删除成功')
      selectedRows.value = []
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除失败:', error)
      }
    }
  }

  /**
   * 处理表格行选择变化
   */
  const handleSelectionChange = (selection: RoleListItem[]) => {
    selectedRows.value = selection
    console.log('选中行数据:', selectedRows.value)
  }

  /**
   * 更新角色状态
   */
  const handleStatusChange = async (row: RoleListItem, value: boolean): Promise<void> => {
    // 超级管理员不允许关闭
    if (row.roleCode === 'SUPER_ADMIN' && !value) {
      ElMessage.warning('超级管理员角色不允许停用')
      return
    }

    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateRoleStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新角色状态失败:', error)
      ElMessage.error('更新角色状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
