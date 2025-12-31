<!-- 校区管理页面 -->
<template>
  <div class="campus-page art-full-height">
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:campus:add'"
              >新增校区</ElButton
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

      <!-- 校区弹窗 -->
      <CampusDialog
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
  import CampusDialog from './modules/campus-dialog.vue'
  import {
    fetchGetCampusTree,
    fetchDeleteCampus,
    fetchUpdateCampusStatus
  } from '@/api/school-manage'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'
  import { h } from 'vue'

  defineOptions({ name: 'Campus' })

  type CampusListItem = Api.SystemManage.CampusListItem & { _statusLoading?: boolean }

  // 状态管理
  const loading = ref(false)
  const isExpanded = ref(false)
  const tableRef = ref()

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<CampusListItem | null>(null)

  // 表格数据
  const tableData = ref<CampusListItem[]>([])

  // 搜索相关
  const initialSearchState = {
    campusCode: '',
    campusName: '',
    status: undefined
  }

  const formFilters = reactive({ ...initialSearchState })

  const formItems = computed(() => [
    {
      label: '校区编码',
      key: 'campusCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入校区编码' }
    },
    {
      label: '校区名称',
      key: 'campusName',
      type: 'input',
      props: { clearable: true, placeholder: '请输入校区名称' }
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
  const { columns, columnChecks } = useTableColumns<CampusListItem>(() => [
    {
      type: 'selection',
      width: 55
    },
    {
      prop: 'campusCode',
      label: '校区编码',
      minWidth: 120
    },
    {
      prop: 'campusName',
      label: '校区名称',
      minWidth: 150
    },
    {
      prop: 'address',
      label: '校区地址',
      minWidth: 200
    },
    {
      prop: 'manager',
      label: '负责人',
      minWidth: 100
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: CampusListItem) => {
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
      prop: 'sort',
      label: '排序',
      width: 80
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
      formatter: (row: CampusListItem) => {
        const buttons = []
        if (hasPermission('system:campus:edit')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => handleEdit(row)
            })
          )
        }
        if (hasPermission('system:campus:delete')) {
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
    getCampusList()
  })

  /**
   * 获取校区列表数据
   */
  const getCampusList = async (): Promise<void> => {
    loading.value = true

    try {
      const params: Api.SystemManage.CampusSearchParams = {}
      if (formFilters.campusCode) {
        params.campusCode = formFilters.campusCode
      }
      if (formFilters.campusName) {
        params.campusName = formFilters.campusName
      }
      if (formFilters.status !== undefined) {
        params.status = formFilters.status
      }

      const list = await fetchGetCampusTree(params)
      tableData.value = list
    } catch (error) {
      console.error('获取校区列表失败:', error)
      ElMessage.error('获取校区列表失败')
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
  const toggleAllExpansion = (data: CampusListItem[], expand: boolean): void => {
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
    getCampusList()
  }

  /**
   * 重置搜索
   */
  const handleReset = (): void => {
    Object.assign(formFilters, initialSearchState)
    getCampusList()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    getCampusList()
  }

  /**
   * 新增校区
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑校区
   */
  const handleEdit = (row: CampusListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除校区
   */
  const handleDelete = async (row: CampusListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(`确定要删除校区"${row.campusName}"吗？`, '提示', {
        type: 'warning'
      })
      await fetchDeleteCampus(row.id)
      ElMessage.success('删除成功')
      getCampusList()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除校区失败:', error)
      }
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = (): void => {
    dialogVisible.value = false
    getCampusList()
  }

  /**
   * 更新校区状态
   */
  const handleStatusChange = async (row: CampusListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateCampusStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新校区状态失败:', error)
      ElMessage.error('更新校区状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
