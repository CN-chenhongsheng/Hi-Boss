<!-- 院系管理页面 -->
<template>
  <div class="department-page art-full-height">
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:department:add'"
              >新增院系</ElButton
            >
            <ElButton @click="toggleExpand" v-ripple>
              {{ isExpanded ? '收起全部' : '展开全部' }}
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        ref="tableRef"
        row-key="id"
        :loading="loading"
        :columns="columns"
        :data="tableData"
        :stripe="false"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="false"
      />

      <!-- 院系弹窗 -->
      <DepartmentDialog
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
  import DepartmentDialog from './modules/department-dialog.vue'
  import {
    fetchGetDepartmentTree,
    fetchDeleteDepartment,
    fetchUpdateDepartmentStatus
  } from '@/api/school-manage'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'
  import { h } from 'vue'

  defineOptions({ name: 'Department' })

  type DepartmentListItem = Api.SystemManage.DepartmentListItem & { _statusLoading?: boolean }

  // 状态管理
  const loading = ref(false)
  const isExpanded = ref(false)
  const tableRef = ref()

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<DepartmentListItem | null>(null)

  // 表格数据
  const tableData = ref<DepartmentListItem[]>([])

  // 搜索相关
  const initialSearchState = {
    deptCode: '',
    deptName: '',
    campusCode: '',
    status: undefined
  }

  const formFilters = reactive({ ...initialSearchState })

  const formItems = computed(() => [
    {
      label: '院系编码',
      key: 'deptCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入院系编码' }
    },
    {
      label: '院系名称',
      key: 'deptName',
      type: 'input',
      props: { clearable: true, placeholder: '请输入院系名称' }
    },
    {
      label: '所属校区',
      key: 'campusCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入校区编码' }
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

  // 表格列配置
  const { columns, columnChecks } = useTableColumns<DepartmentListItem>(() => [
    {
      prop: 'deptCode',
      label: '院系编码',
      minWidth: 120
    },
    {
      prop: 'deptName',
      label: '院系名称',
      minWidth: 150
    },
    {
      prop: 'campusName',
      label: '所属校区',
      minWidth: 120
    },
    {
      prop: 'leader',
      label: '院系领导',
      minWidth: 100
    },
    {
      prop: 'phone',
      label: '联系电话',
      minWidth: 120
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: DepartmentListItem) => {
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
      prop: 'action',
      label: '操作',
      width: 150,
      fixed: 'right' as const,
      formatter: (row: DepartmentListItem) => {
        const buttons = []
        if (hasPermission('system:department:edit')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => handleEdit(row)
            })
          )
        }
        if (hasPermission('system:department:delete')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => handleDelete(row)
            })
          )
        }
        return h('div', { class: 'flex gap-1' }, buttons)
      }
    }
  ])

  onMounted(() => {
    getDepartmentList()
  })

  /**
   * 获取院系列表数据
   */
  const getDepartmentList = async (): Promise<void> => {
    loading.value = true

    try {
      const params: Api.SystemManage.DepartmentSearchParams = {}
      if (formFilters.deptCode) {
        params.deptCode = formFilters.deptCode
      }
      if (formFilters.deptName) {
        params.deptName = formFilters.deptName
      }
      if (formFilters.campusCode) {
        params.campusCode = formFilters.campusCode
      }
      if (formFilters.status !== undefined) {
        params.status = formFilters.status
      }

      const list = await fetchGetDepartmentTree(params)
      tableData.value = list
    } catch (error) {
      console.error('获取院系列表失败:', error)
      ElMessage.error('获取院系列表失败')
    } finally {
      loading.value = false
    }
  }

  /**
   * 切换展开/收起
   */
  const toggleExpand = (): void => {
    isExpanded.value = !isExpanded.value
    toggleAllExpansion(tableData.value, isExpanded.value)
  }

  /**
   * 递归展开/收起所有节点
   */
  const toggleAllExpansion = (data: DepartmentListItem[], expand: boolean): void => {
    data.forEach((item) => {
      if (tableRef.value) {
        tableRef.value.toggleRowExpansion(item, expand)
      }
      if (item.children && item.children.length > 0) {
        toggleAllExpansion(item.children, expand)
      }
    })
  }

  /**
   * 搜索
   */
  const handleSearch = (): void => {
    getDepartmentList()
  }

  /**
   * 重置搜索
   */
  const handleReset = (): void => {
    Object.assign(formFilters, initialSearchState)
    getDepartmentList()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    getDepartmentList()
  }

  /**
   * 新增院系
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑院系
   */
  const handleEdit = (row: DepartmentListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除院系
   */
  const handleDelete = async (row: DepartmentListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(`确定要删除院系"${row.deptName}"吗？`, '提示', {
        type: 'warning'
      })
      await fetchDeleteDepartment(row.id)
      ElMessage.success('删除成功')
      getDepartmentList()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除院系失败:', error)
      }
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = (): void => {
    dialogVisible.value = false
    getDepartmentList()
  }

  /**
   * 更新院系状态
   */
  const handleStatusChange = async (row: DepartmentListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateDepartmentStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新院系状态失败:', error)
      ElMessage.error('更新院系状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
