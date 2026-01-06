<!-- 楼层管理页面 -->
<template>
  <div class="floor-page art-full-height">
    <!-- 搜索栏 -->
    <FloorSearch
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:floor:add'"
              >新增楼层</ElButton
            >
            <ElButton
              :disabled="
                selectedCount === 0 || selectedRows.some((row) => (row.totalRooms || 0) > 0)
              "
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:floor:delete'"
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
        row-key="id"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />

      <!-- 楼层弹窗 -->
      <FloorDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        @submit="handleSubmit"
      />

      <!-- 下钻弹框（房间） -->
      <DrillDownDialog
        v-model:visible="drillDownVisible"
        :drill-type="drillDownType"
        :parent-name="drillDownParentName"
        :filter-params="drillDownFilterParams"
        :key="`${drillDownType}-${drillDownVisible}`"
        @drill-down="handleRoomDrillDown"
      />

      <!-- 下钻弹框（床位） -->
      <DrillDownDialog
        v-model:visible="roomNestedDrillDownVisible"
        :drill-type="roomNestedDrillDownType"
        :parent-name="roomNestedDrillDownParentName"
        :filter-params="roomNestedDrillDownFilterParams"
        :key="`${roomNestedDrillDownType}-${roomNestedDrillDownVisible}`"
      />

      <!-- 批量增加房间弹框 -->
      <BatchRoomDialog
        v-model:visible="batchRoomDialogVisible"
        :floor-data="batchRoomFloorData"
        @submit="handleBatchRoomSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import FloorDialog from './modules/floor-dialog.vue'
  import FloorSearch from './modules/floor-search.vue'
  import BatchRoomDialog from './modules/batch-room-dialog.vue'
  import {
    fetchGetFloorPage,
    fetchDeleteFloor,
    fetchBatchDeleteFloor,
    fetchUpdateFloorStatus
  } from '@/api/dormitory-manage'
  import { useReferenceStore } from '@/store/modules/reference'
  import DrillDownDialog from '@/components/school/DrillDownDialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  // 使用参考数据 store（用于缓存失效）
  const referenceStore = useReferenceStore()

  defineOptions({ name: 'Floor' })

  type FloorListItem = Api.SystemManage.FloorListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<FloorListItem | null>(null)

  // 下钻弹框相关
  const drillDownVisible = ref(false)
  const drillDownType = ref<'room'>('room')
  const drillDownParentName = ref('')
  const drillDownFilterParams = ref<Record<string, any>>({})

  // 嵌套下钻弹框相关（房间 → 床位）
  const roomNestedDrillDownVisible = ref(false)
  const roomNestedDrillDownType = ref<'bed'>('bed')
  const roomNestedDrillDownParentName = ref('')
  const roomNestedDrillDownFilterParams = ref<Record<string, any>>({})

  // 批量增加房间弹框相关
  const batchRoomDialogVisible = ref(false)
  const batchRoomFloorData = ref<FloorListItem | null>(null)

  // 批量选择
  const selectedRows = ref<FloorListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索相关
  const initialSearchState = {
    floorCode: '',
    floorName: '',
    campusCode: '',
    genderType: undefined,
    status: undefined,
    pageNum: 1,
    pageSize: 20
  }

  const formFilters = reactive({ ...initialSearchState })

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
    handleCurrentChange
  } = useTable<typeof fetchGetFloorPage>({
    core: {
      apiFn: fetchGetFloorPage,
      apiParams: computed(() => {
        return {
          floorCode: formFilters.floorCode || undefined,
          floorName: formFilters.floorName || undefined,
          campusCode: formFilters.campusCode || undefined,
          genderType: formFilters.genderType,
          status: formFilters.status,
          pageNum: formFilters.pageNum,
          pageSize: formFilters.pageSize
        } as Partial<Api.SystemManage.FloorSearchParams>
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
          prop: 'floorCode',
          label: '楼层编码',
          minWidth: 120
        },
        {
          prop: 'floorName',
          label: '楼层名称',
          minWidth: 120
        },
        {
          prop: 'floorNumber',
          label: '楼层数',
          width: 100
        },
        {
          prop: 'campusName',
          label: '所属校区',
          minWidth: 150
        },
        {
          prop: 'genderTypeText',
          label: '性别类型',
          width: 100
        },
        {
          prop: 'totalRooms',
          label: '房间数',
          width: 100
        },
        {
          prop: 'totalBeds',
          label: '床位数',
          width: 100
        },
        {
          prop: 'currentOccupancy',
          label: '入住人数',
          width: 100
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: FloorListItem) => {
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
          width: 180
        },
        {
          prop: 'action',
          label: '操作',
          width: 180,
          fixed: 'right' as const,
          formatter: (row: FloorListItem) => [
            { type: 'view', onClick: () => handleViewRooms(row), label: '查看房间' },
            {
              type: 'edit',
              onClick: () => handleEdit(row),
              auth: 'system:floor:edit',
              disabled: (row.totalRooms || 0) > 0
            },
            { type: 'add', onClick: () => handleBatchAddRooms(row), label: '批量增加' },
            {
              type: 'delete',
              onClick: () => handleDelete(row),
              auth: 'system:floor:delete',
              danger: true,
              disabled: (row.totalRooms || 0) > 0
            }
          ]
        }
      ],
      immediate: true
    },
    transform: {
      dataTransformer: (records: FloorListItem[]) => {
        // 同步返回，异步检查在后台进行
        // 注意：这里不能使用 async，因为 dataTransformer 必须是同步函数
        // 关联检查将在列表加载后通过 watch 或 computed 进行
        return records
      }
    }
  })

  /**
   * 搜索
   */
  const handleSearch = async (): Promise<void> => {
    formFilters.pageNum = 1
    await getData()
  }

  /**
   * 重置搜索
   */
  const handleReset = async (): Promise<void> => {
    Object.assign(formFilters, { ...initialSearchState, pageNum: 1, pageSize: 20 })
    await resetSearchParams()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    refreshData()
  }

  /**
   * 新增楼层
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑楼层
   */
  const handleEdit = (row: FloorListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除楼层
   */
  const handleDelete = async (row: FloorListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除楼层"${row.floorName || row.floorCode}"吗？`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchDeleteFloor(row.id)
      ElMessage.success('删除成功')
      // 刷新楼层列表缓存
      await referenceStore.refreshFloorList()
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除楼层失败:', error)
      }
    }
  }

  /**
   * 处理表格行选择变化
   */
  const handleSelectionChange = (selection: FloorListItem[]): void => {
    selectedRows.value = selection
  }

  /**
   * 批量删除楼层
   */
  const handleBatchDelete = async (): Promise<void> => {
    if (selectedCount.value === 0) {
      ElMessage.warning('请至少选择一条数据')
      return
    }

    // 检查是否有选中项包含房间
    const hasRoomsInSelection = selectedRows.value.some((row) => (row.totalRooms || 0) > 0)
    if (hasRoomsInSelection) {
      ElMessage.warning('选中的楼层中包含有房间的楼层，无法删除')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要批量删除选中的 ${selectedCount.value} 条楼层数据吗？`,
        '批量删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchBatchDeleteFloor(selectedIds.value as number[])
      ElMessage.success('批量删除成功')
      // 刷新楼层列表缓存
      await referenceStore.refreshFloorList()
      selectedRows.value = []
      await getData()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除楼层失败:', error)
      }
    }
  }

  /**
   * 状态切换
   */
  const handleStatusChange = async (row: FloorListItem, enabled: boolean): Promise<void> => {
    try {
      row._statusLoading = true
      const status = enabled ? 1 : 0
      await ElMessageBox.confirm(
        `确定要${enabled ? '启用' : '停用'}楼层"${row.floorName || row.floorCode}"吗？`,
        '状态确认',
        {
          type: 'warning',
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }
      )
      await fetchUpdateFloorStatus(row.id, status)
      ElMessage.success(`${enabled ? '启用' : '停用'}成功`)
      await refreshData()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('状态切换失败:', error)
        await refreshData()
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
    // 刷新楼层列表缓存
    await referenceStore.refreshFloorList()
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 查看房间
   */
  const handleViewRooms = (row: FloorListItem): void => {
    drillDownType.value = 'room'
    drillDownParentName.value = row.floorName || row.floorCode
    drillDownFilterParams.value = { floorCode: row.floorCode, pageNum: 1, pageSize: 20 }
    drillDownVisible.value = true
  }

  /**
   * 处理房间下钻事件（从房间下钻到床位）
   */
  const handleRoomDrillDown = (
    type: 'department' | 'major' | 'class' | 'floor' | 'room' | 'bed',
    row: any
  ): void => {
    if (type === 'bed') {
      // 从房间下钻到床位
      roomNestedDrillDownType.value = 'bed'
      roomNestedDrillDownParentName.value = row.roomNumber || row.roomCode
      roomNestedDrillDownFilterParams.value = {
        roomCode: row.roomCode,
        pageNum: 1,
        pageSize: 20
      }
      roomNestedDrillDownVisible.value = true
    }
  }

  /**
   * 批量增加房间
   */
  const handleBatchAddRooms = (row: FloorListItem): void => {
    batchRoomFloorData.value = { ...row }
    batchRoomDialogVisible.value = true
  }

  /**
   * 批量增加房间提交回调
   */
  const handleBatchRoomSubmit = async (): Promise<void> => {
    batchRoomDialogVisible.value = false
    // 刷新楼层数据（因为房间数量会更新）
    await refreshData()
  }
</script>
