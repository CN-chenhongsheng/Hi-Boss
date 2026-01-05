<!-- 学年管理页面 -->
<template>
  <div class="academic-year-page art-full-height">
    <!-- 搜索栏 -->
    <AcademicYearSearch
      v-show="showSearchBar"
      v-model="formFilters"
      @reset="handleReset"
      @search="handleSearch"
    />

    <ElCard
      class="art-table-card"
      shadow="never"
      :style="{ 'margin-top': showSearchBar ? '12px' : '0' }"
    >
      <!-- 表格头部 -->
      <ArtTableHeader
        :showZebra="false"
        :loading="loading"
        v-model:columns="columnChecks"
        v-model:showSearchBar="showSearchBar"
        @refresh="handleRefresh"
      >
        <template #left>
          <ElSpace wrap>
            <ElButton @click="handleAdd" v-ripple v-permission="'system:academic-year:add'"
              >新增学年</ElButton
            >
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable :loading="loading" :columns="columns" :data="data" :stripe="false" />

      <!-- 学年弹窗 -->
      <AcademicYearDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        @submit="handleSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import AcademicYearDialog from './modules/academic-year-dialog.vue'
  import AcademicYearSearch from './modules/academic-year-search.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  defineOptions({ name: 'AcademicYear' })

  // 临时使用空函数，等后端API准备好后替���
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const fetchGetAcademicYearPage = async (params: any) => {
    return {
      list: [],
      total: 0
    }
  }

  type AcademicYearListItem = {
    id: number
    yearCode: string
    yearName: string
    startDate: string
    endDate: string
    status: number
    createTime?: string
    _statusLoading?: boolean
  }

  // 状态管理
  const showSearchBar = ref(false)
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<AcademicYearListItem | null>(null)

  // 搜索相关
  const initialSearchState = {
    yearCode: '',
    yearName: '',
    status: undefined
  }

  const formFilters = reactive({ ...initialSearchState })

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
  } = useTable<typeof fetchGetAcademicYearPage>({
    core: {
      apiFn: fetchGetAcademicYearPage,
      apiParams: computed(() => {
        return {
          yearCode: formFilters.yearCode || undefined,
          yearName: formFilters.yearName || undefined,
          status: formFilters.status
        }
      }),
      columnsFactory: () => [
        {
          prop: 'yearCode',
          label: '学年编码',
          minWidth: 120
        },
        {
          prop: 'yearName',
          label: '学年名称',
          minWidth: 150
        },
        {
          prop: 'startDate',
          label: '开始日期',
          width: 120
        },
        {
          prop: 'endDate',
          label: '结束日期',
          width: 120
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: AcademicYearListItem) => {
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
          width: 180,
          fixed: 'right' as const,
          formatter: (row: AcademicYearListItem) => [
            { type: 'edit', onClick: () => handleEdit(row), auth: 'system:academic-year:edit' },
            {
              type: 'delete',
              onClick: () => handleDelete(row),
              auth: 'system:academic-year:delete',
              danger: true
            }
          ]
        }
      ],
      immediate: true
    }
  })

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
   * 新增学年
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑学年
   */
  const handleEdit = (row: AcademicYearListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除学年
   */
  const handleDelete = async (row: AcademicYearListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除学年"${row.yearName}"吗？此操作不可恢复！`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      // TODO: 调用删除API
      // await fetchDeleteAcademicYear(row.id)
      ElMessage.success('删除成功')
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除学年失败:', error)
      }
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = async (): Promise<void> => {
    dialogVisible.value = false
    // 根据 dialogType 判断是新增还是编辑
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 更新学年状态
   */
  const handleStatusChange = async (row: AcademicYearListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      // TODO: 调用更新状态API
      // await fetchUpdateAcademicYearStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新学年状态失败:', error)
      ElMessage.error('更新学年状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
