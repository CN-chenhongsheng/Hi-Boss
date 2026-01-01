<!-- 用户管理页面 -->
<template>
  <div class="user-page art-full-height">
    <!-- 搜索栏 -->
    <UserSearch v-model="searchForm" @search="handleSearch" @reset="resetSearchParams"></UserSearch>

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader v-model:columns="columnChecks" :loading="loading" @refresh="refreshData">
        <template #left>
          <ElSpace wrap>
            <ElButton @click="showDialog('add')" v-ripple v-permission="'system:user:add'">
              新增用户
            </ElButton>
            <ElButton
              :disabled="selectedRows.length === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:user:delete'"
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

      <!-- 用户弹窗 -->
      <UserDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :user-data="currentUserData"
        @submit="handleDialogSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { ACCOUNT_TABLE_DATA } from '@/mock/temp/formData'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetUserList,
    fetchDeleteUser,
    fetchUpdateUserStatus,
    fetchResetUserPassword
  } from '@/api/system-manage'
  import UserSearch from './modules/user-search.vue'
  import UserDialog from './modules/user-dialog.vue'
  import { ElTag, ElMessageBox, ElImage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'
  import { DialogType } from '@/types'

  defineOptions({ name: 'User' })

  type UserListItem = Api.SystemManage.UserListItem

  // 弹窗相关
  const dialogType = ref<DialogType>('add')
  const dialogVisible = ref(false)
  const currentUserData = ref<Partial<UserListItem>>({})

  // 选中行
  const selectedRows = ref<UserListItem[]>([])

  // 搜索表单
  const searchForm = ref<Api.SystemManage.UserSearchParams>({
    pageNum: 1,
    pageSize: 20,
    username: undefined,
    nickname: undefined,
    phone: undefined,
    college: undefined,
    status: undefined
  })

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
    refreshData
  } = useTable<typeof fetchGetUserList>({
    // 核心配置
    core: {
      apiFn: fetchGetUserList,
      apiParams: {
        pageNum: 1,
        pageSize: 20,
        ...searchForm.value
      },
      // 自定义分页字段映射
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        { type: 'selection' }, // 勾选列
        {
          prop: 'userInfo',
          label: '用户信息',
          formatter: (row) => {
            return h('div', { class: 'user flex-c' }, [
              h(ElImage, {
                class: 'size-9.5 rounded-md',
                src: row.avatar || '/default-avatar.png',
                previewSrcList: [row.avatar || '/default-avatar.png'],
                previewTeleported: true
              }),
              h('div', { class: 'ml-2' }, [
                h('p', { class: 'nickname text-sm text-gray-500' }, `${row.nickname}#${row.id}`),
                h('p', { class: 'email text-xs text-gray-400' }, row.email || '未设置邮箱')
              ])
            ])
          }
        },
        {
          prop: 'phone',
          label: '手机号',
          width: 125
        },
        {
          prop: 'college',
          label: '所属学院',
          width: 150
        },
        {
          prop: 'roleNames',
          label: '角色',
          width: 200,
          formatter: (row) => {
            // roleNames can be either string array or comma-separated string
            const roleList = Array.isArray(row.roleNames)
              ? row.roleNames
              : row.roleNames
                ? (row.roleNames as unknown as string).split(',')
                : []
            if (roleList.length === 0) {
              return h('span', { class: 'text-gray-400' }, '暂无角色')
            }
            return h(
              'div',
              { class: 'flex gap-1 flex-wrap' },
              roleList.map((roleName: string) =>
                h(ElTag, { size: 'small', type: 'primary' }, () => roleName)
              )
            )
          }
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row) => {
            const isSuperAdmin = row.username === 'superAdmin'
            return h(ArtSwitch, {
              modelValue: row.status === 1,
              inlinePrompt: true,
              disabled: isSuperAdmin, // 超级管理员禁用开关
              onChange: async (value: boolean | string | number) => {
                const newStatus = typeof value === 'boolean' ? (value ? 1 : 0) : Number(value)
                await handleStatusChange(row, newStatus)
              }
            })
          }
        },
        {
          prop: 'lastLoginTime',
          label: '最后登录',
          width: 180,
          formatter: (row) => row.lastLoginTime || '未登录'
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
          width: 200,
          fixed: 'right',
          formatter: (row) => {
            const buttons = []
            if (hasPermission('system:user:edit')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'edit',
                  onClick: () => showDialog('edit', row)
                })
              )
            }
            if (hasPermission('system:user:reset-pwd')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'edit',
                  icon: 'ri-shield-keyhole-line',
                  tooltip: '重置密码',
                  onClick: () => handleResetPassword(row)
                })
              )
            }
            if (hasPermission('system:user:delete')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'delete',
                  onClick: () => deleteUser(row)
                })
              )
            }
            return h('div', buttons)
          }
        }
      ]
    },
    // 数据处理
    transform: {
      // 数据转换器 - 替换头像
      dataTransformer: (records: UserListItem[]) => {
        if (!Array.isArray(records)) {
          console.warn('数据转换器: 期望数组类型，实际收到:', typeof records)
          return []
        }

        // 使用本地头像替换接口返回的头像（如果接口没有返回头像）
        return records.map((item, index: number) => {
          return {
            ...item,
            avatar: item.avatar || ACCOUNT_TABLE_DATA[index % ACCOUNT_TABLE_DATA.length].avatar
          }
        })
      }
    }
  })

  /**
   * 搜索处理
   */
  const handleSearch = (params: Record<string, any>) => {
    Object.assign(searchParams, params, { pageNum: 1 })
    getData()
  }

  /**
   * 显示用户弹窗
   */
  const showDialog = (type: DialogType, row?: UserListItem): void => {
    console.log('打开弹窗:', { type, row })
    dialogType.value = type
    currentUserData.value = row ? { ...row } : {}
    nextTick(() => {
      dialogVisible.value = true
    })
  }

  /**
   * 删除用户
   */
  const deleteUser = async (row: UserListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除用户 "${row.username}" 吗？此操作不可恢复！`,
        '删除用户',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      await fetchDeleteUser(row.id)
      await refreshData()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除用户失败:', error)
      }
    }
  }

  /**
   * 批量删除
   */
  const handleBatchDelete = async (): Promise<void> => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请先选择要删除的用户')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要删除选中的 ${selectedRows.value.length} 个用户吗？此操作不可恢复！`,
        '批量删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      // 逐个删除（如果后端支持批量删除接口，可以改为批量调用）
      for (const user of selectedRows.value) {
        await fetchDeleteUser(user.id)
      }

      ElMessage.success('批量删除成功')
      selectedRows.value = []
      await refreshData()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除失败:', error)
      }
    }
  }

  /**
   * 更改用户状态
   */
  const handleStatusChange = async (row: UserListItem, status: number): Promise<void> => {
    // 超级管理员不允许关闭
    if (row.username === 'superAdmin' && status === 0) {
      ElMessage.warning('超级管理员不允许停用')
      return
    }

    const originalStatus = row.status
    try {
      row.status = status
      await fetchUpdateUserStatus(row.id, status)
    } catch (error) {
      console.error('更改状态失败:', error)
      // 恢复原状态
      row.status = originalStatus
    }
  }

  /**
   * 重置密码
   */
  const handleResetPassword = async (row: UserListItem): Promise<void> => {
    try {
      const { value: newPassword } = await ElMessageBox.prompt(
        '请输入新密码（至少6位）',
        `重置用户 "${row.nickname}" 的密码`,
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputPattern: /.{6,}/,
          inputErrorMessage: '密码长度不能少于6位',
          inputType: 'password'
        }
      )

      if (newPassword) {
        await fetchResetUserPassword(row.id, { newPassword: newPassword as string })
      }
    } catch (error) {
      if (error !== 'cancel') {
        console.error('重置密码失败:', error)
      }
    }
  }

  /**
   * 处理弹窗提交事件
   */
  const handleDialogSubmit = async () => {
    await refreshData()
  }

  /**
   * 处理表格行选择变化
   */
  const handleSelectionChange = (selection: UserListItem[]): void => {
    selectedRows.value = selection
    console.log('选中行数据:', selectedRows.value)
  }
</script>

<style scoped lang="scss">
  .user-page {
    :deep(.user) {
      .user-name {
        font-size: 14px;
        color: var(--el-text-color-primary);
        margin-bottom: 4px;
      }

      .nickname {
        font-size: 13px;
        color: var(--el-text-color-regular);
        margin-bottom: 2px;
      }

      .email {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }
  }
</style>
