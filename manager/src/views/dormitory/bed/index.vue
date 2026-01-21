<!-- 床位管理页面 -->
<template>
  <div class="bed-page art-full-height">
    <!-- 搜索栏 -->
    <BedSearch
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:bed:add'"
              >新增床位</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:bed:delete'"
            >
              批量删除{{ selectedCount > 0 ? `(${selectedCount})` : '' }}
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        :loading="loading"
        :columns="columns"
        :data="data"
        :stripe="false"
        :pagination="pagination"
        :contextMenuItems="contextMenuItems"
        :contextMenuWidth="contextMenuWidth"
        :onRowContextmenu="handleRowContextmenu"
        :onContextMenuSelect="handleContextMenuSelect"
        row-key="id"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />

      <!-- 床位弹窗 -->
      <BedDialog
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
  import BedDialog from './modules/bed-dialog.vue'
  import BedSearch from './modules/bed-search.vue'
  import {
    fetchGetBedPage,
    fetchDeleteBed,
    fetchBatchDeleteBed,
    fetchUpdateBedStatus
  } from '@/api/dormitory-manage'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  defineOptions({ name: 'Bed' })

  type BedListItem = Api.SystemManage.BedListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<BedListItem | null>(null)

  // 批量选择
  const selectedRows = ref<BedListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索相关
  const formFilters = ref({
    bedCode: '',
    bedNumber: '',
    roomCode: '',
    floorCode: '',
    campusCode: '',
    bedPosition: '',
    bedStatus: undefined,
    status: undefined,
    pageNum: 1
  })

  // 使用 useTable 管理表格数据
  const {
    columns,
    columnChecks,
    data,
    loading,
    pagination,
    getData,
    resetSearchParams,
    refreshData,
    refreshCreate,
    refreshUpdate,
    refreshRemove,
    handleSizeChange,
    handleCurrentChange,
    contextMenuItems,
    contextMenuWidth,
    handleRowContextmenu,
    handleContextMenuSelect
  } = useTable<typeof fetchGetBedPage>({
    core: {
      apiFn: fetchGetBedPage,
      apiParams: computed(() => {
        return {
          bedCode: formFilters.value.bedCode || undefined,
          bedNumber: formFilters.value.bedNumber || undefined,
          roomCode: formFilters.value.roomCode || undefined,
          floorCode: formFilters.value.floorCode || undefined,
          campusCode: formFilters.value.campusCode || undefined,
          bedPosition: formFilters.value.bedPosition || undefined,
          bedStatus: formFilters.value.bedStatus,
          status: formFilters.value.status,
          pageNum: formFilters.value.pageNum
        } as Partial<Api.SystemManage.BedSearchParams>
      }),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        {
          type: 'selection',
          width: 50,
          reserveSelection: true
        },
        {
          prop: 'bedCode',
          label: '床位编码',
          minWidth: 120
        },
        {
          prop: 'bedNumber',
          label: '床位号',
          width: 100
        },
        {
          prop: 'roomNumber',
          label: '所属房间',
          minWidth: 120
        },
        {
          prop: 'floorName',
          label: '所属楼层',
          minWidth: 120
        },
        {
          prop: 'campusName',
          label: '所属校区',
          minWidth: 120
        },
        {
          prop: 'bedPositionText',
          label: '床位位置',
          width: 100
        },
        {
          prop: 'bedStatusText',
          label: '床位状态',
          width: 100
        },
        {
          prop: 'studentName',
          label: '入住学生',
          minWidth: 120
        },
        {
          prop: 'checkInDate',
          label: '入住日期',
          width: 120
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: BedListItem) => {
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
          width: 85,
          sortable: true
        },
        {
          prop: 'createTime',
          label: '创建时间',
          width: 180,
          sortable: true
        },
        {
          prop: 'action',
          label: '操作',
          width: 150,
          fixed: 'right' as const,
          formatter: (row: BedListItem) => [
            {
              type: 'edit',
              label: '编辑',
              onClick: () => handleEdit(row),
              auth: 'system:bed:edit'
            },
            {
              type: 'delete',
              label: '删除',
              onClick: () => handleDelete(row),
              auth: 'system:bed:delete',
              danger: true
            }
          ]
        }
      ],
      immediate: true
    },
    adaptive: {
      enabled: true
    },
    contextMenu: {
      enabled: true
    }
  })

  /**
   * 搜索
   */
  const handleSearch = async (): Promise<void> => {
    formFilters.value.pageNum = 1
    await getData()
  }

  /**
   * 重置搜索
   */
  const handleReset = async (): Promise<void> => {
    formFilters.value = {
      bedCode: '',
      bedNumber: '',
      roomCode: '',
      floorCode: '',
      campusCode: '',
      bedPosition: '',
      bedStatus: undefined,
      status: undefined,
      pageNum: 1
    }
    await resetSearchParams()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    refreshData()
  }

  /**
   * 新增床位
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑床位
   */
  const handleEdit = (row: BedListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除床位
   */
  const handleDelete = async (row: BedListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除床位"${row.bedNumber || row.bedCode}"吗？`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchDeleteBed(row.id)
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除床位失败:', error)
      }
    }
  }

  /**
   * 处理表格行选择变化
   */
  const handleSelectionChange = (selection: BedListItem[]): void => {
    selectedRows.value = selection
  }

  /**
   * 批量删除床位
   */
  const handleBatchDelete = async (): Promise<void> => {
    if (selectedCount.value === 0) {
      ElMessage.warning('请至少选择一条数据')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要批量删除选中的 ${selectedCount.value} 条床位数据吗？`,
        '批量删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchBatchDeleteBed(selectedIds.value as number[])
      selectedRows.value = []
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除床位失败:', error)
      }
    }
  }

  /**
   * 状态切换
   */
  const handleStatusChange = async (row: BedListItem, enabled: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      const status = enabled ? 1 : 0
      await ElMessageBox.confirm(
        `确定要${enabled ? '启用' : '停用'}床位"${row.bedNumber || row.bedCode}"吗？`,
        '状态确认',
        {
          type: 'warning',
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }
      )
      row.status = status
      await fetchUpdateBedStatus(row.id, status)
    } catch (error) {
      if (error !== 'cancel') {
        console.error('状态切换失败:', error)
        row.status = originalStatus
      } else {
        row.status = originalStatus
      }
    } finally {
      row._statusLoading = false
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = async (): Promise<void> => {
    dialogVisible.value = false
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }
</script>
