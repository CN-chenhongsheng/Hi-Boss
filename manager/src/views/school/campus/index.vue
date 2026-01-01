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
        :data="data"
        :stripe="false"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="false"
      />

      <!-- 校区弹窗 -->
      <CampusDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        :parent-data="parentData"
        @submit="handleSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { useTable } from '@/hooks/core/useTable'
  import CampusDialog from './modules/campus-dialog.vue'
  import {
    fetchGetCampusTree,
    fetchDeleteCampus,
    fetchUpdateCampusStatus
  } from '@/api/school-manage'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { hasPermission } from '@/directives/core/permission'
  import { h, nextTick } from 'vue'

  defineOptions({ name: 'Campus' })

  type CampusListItem = Api.SystemManage.CampusListItem & { _statusLoading?: boolean }

  // 状态管理
  const isExpanded = ref(false)
  const tableRef = ref()

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit' | 'addChild'>('add')
  const editData = ref<CampusListItem | null>(null)
  const parentData = ref<CampusListItem | null>(null)

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

  // 使用 useTable 管理表格数据
  const {
    columns,
    columnChecks,
    data,
    loading,
    getData,
    resetSearchParams,
    refreshData,
    refreshCreate,
    refreshUpdate,
    refreshRemove
  } = useTable<typeof fetchGetCampusTree>({
    core: {
      apiFn: fetchGetCampusTree,
      apiParams: computed(() => {
        return {
          campusCode: formFilters.campusCode || undefined,
          campusName: formFilters.campusName || undefined,
          status: formFilters.status
        } as Partial<Api.SystemManage.CampusSearchParams>
      }),
      columnsFactory: () => [
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
          width: 80,
          sortable: true
        },
        {
          prop: 'createTime',
          label: '创建时间',
          width: 180
        },
        {
          prop: 'action',
          label: '操作',
          width: 180,
          fixed: 'right' as const,
          formatter: (row: CampusListItem) => {
            const buttons = []
            if (hasPermission('system:campus:add')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'add',
                  onClick: () => handleAddChild(row)
                })
              )
            }
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
      ],
      immediate: true
    }
  })

  /**
   * 切换展开/收起
   */
  const toggleExpand = (): void => {
    isExpanded.value = !isExpanded.value
    toggleAllExpansion(data.value, isExpanded.value)
  }

  /**
   * 递归展开/收起所有节点
   */
  const toggleAllExpansion = (treeData: CampusListItem[], expand: boolean): void => {
    nextTick(() => {
      treeData.forEach((item) => {
        if (tableRef.value?.elTableRef) {
          tableRef.value.elTableRef.toggleRowExpansion(item, expand)
        }
        if (item.children && item.children.length > 0) {
          toggleAllExpansion(item.children, expand)
        }
      })
    })
  }

  /**
   * 搜索
   */
  const handleSearch = async (): Promise<void> => {
    await getData()
  }

  /**
   * 重置搜索
   */
  const handleReset = async (): Promise<void> => {
    Object.assign(formFilters, initialSearchState)
    await resetSearchParams()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    refreshData()
  }

  /**
   * 新增校区
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    parentData.value = null
    dialogVisible.value = true
  }

  /**
   * 新增子校区
   */
  const handleAddChild = (row: CampusListItem): void => {
    dialogType.value = 'addChild'
    editData.value = null
    parentData.value = row
    dialogVisible.value = true
  }

  /**
   * 编辑校区
   */
  const handleEdit = (row: CampusListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    parentData.value = null
    dialogVisible.value = true
  }

  /**
   * 删除校区
   */
  const handleDelete = async (row: CampusListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除校区"${row.campusName}"吗？<br/>提示：删除校区后，该校区下的所有院系、专业和班级也会被删除。`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消',
          dangerouslyUseHTMLString: true
        }
      )
      await fetchDeleteCampus(row.id)
      ElMessage.success('删除成功')
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除校区失败:', error)
      }
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = async (): Promise<void> => {
    dialogVisible.value = false
    // 根据 dialogType 判断是新增还是编辑
    if (dialogType.value === 'add' || dialogType.value === 'addChild') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 更新校区状态
   */
  const handleStatusChange = async (row: CampusListItem, value: boolean): Promise<void> => {
    // 检查是否有子节点
    const hasChildren = row.children && row.children.length > 0

    // 如果是关闭操作（从启用变为停用），需要提示用户级联影响
    if (!value && row.status === 1) {
      try {
        let message = `确定要停用校区"${row.campusName}"吗？<br/>提示：停用校区后，该校区下的所有院系、专业和班级也会被停用。`
        await ElMessageBox.confirm(message, '确认停用', {
          type: 'warning',
          confirmButtonText: '确认停用',
          cancelButtonText: '取消',
          dangerouslyUseHTMLString: true
        })
      } catch {
        // 用户取消操作，不执行任何更改
        return
      }
    }

    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateCampusStatus(row.id, value ? 1 : 0)
      // 如果有子节点，需要刷新表格以同步子校区状态
      // 如果是叶子节点，只更新当前行状态即可，不需要刷新表格
      if (hasChildren) {
        await refreshData()
      }
    } catch (error) {
      console.error('更新校区状态失败:', error)
      ElMessage.error('更新校区状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
