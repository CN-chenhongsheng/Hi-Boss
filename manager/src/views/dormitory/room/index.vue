<!-- 房间管理页面 -->
<template>
  <div class="room-page art-full-height">
    <!-- 搜索栏 -->
    <RoomSearch
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:room:add'"
              >新增房间</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:room:delete'"
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
        :onRowContextmenu="handleRowContextmenu as any"
        :onContextMenuSelect="handleContextMenuSelect"
        row-key="id"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />

      <!-- 房间弹窗 -->
      <RoomDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        @submit="handleSubmit"
      />

      <!-- 下钻弹框（床位） -->
      <DrillDownDialog
        v-model:visible="drillDownVisible"
        :drill-type="drillDownType"
        :parent-name="drillDownParentName"
        :filter-params="drillDownFilterParams"
        :key="`${drillDownType}-${drillDownVisible}`"
      />

      <!-- 批量增加床位弹框 -->
      <BatchBedDialog
        v-model:visible="batchBedDialogVisible"
        :room-data="batchBedRoomData"
        @submit="handleBatchBedSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import RoomDialog from './modules/room-dialog.vue'
  import RoomSearch from './modules/room-search.vue'
  import BatchBedDialog from './modules/batch-bed-dialog.vue'
  import {
    fetchGetRoomPage,
    fetchDeleteRoom,
    fetchBatchDeleteRoom,
    fetchUpdateRoomStatus
  } from '@/api/dormitory-manage'
  import { useReferenceStore } from '@/store/modules/reference'
  import DrillDownDialog from '@/components/school/DrillDownDialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  // 使用参考数据 store（用于缓存失效）
  const referenceStore = useReferenceStore()

  defineOptions({ name: 'Room' })

  type RoomListItem = Api.SystemManage.RoomListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<RoomListItem | null>(null)

  // 下钻���框相关
  const drillDownVisible = ref(false)
  const drillDownType = ref<'bed'>('bed')
  const drillDownParentName = ref('')
  const drillDownFilterParams = ref<Record<string, any>>({})

  // 批量增加床位弹框相关
  const batchBedDialogVisible = ref(false)
  const batchBedRoomData = ref<RoomListItem | null>(null)

  // 批量选择
  const selectedRows = ref<RoomListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索相关
  const formFilters = ref({
    roomCode: '',
    roomNumber: '',
    floorCode: '',
    campusCode: '',
    roomType: '',
    roomStatus: undefined,
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
  } = useTable<typeof fetchGetRoomPage>({
    core: {
      apiFn: fetchGetRoomPage,
      apiParams: computed(() => {
        return {
          roomCode: formFilters.value.roomCode || undefined,
          roomNumber: formFilters.value.roomNumber || undefined,
          floorCode: formFilters.value.floorCode || undefined,
          campusCode: formFilters.value.campusCode || undefined,
          roomType: formFilters.value.roomType || undefined,
          roomStatus: formFilters.value.roomStatus,
          status: formFilters.value.status,
          pageNum: formFilters.value.pageNum
        } as Partial<Api.SystemManage.RoomSearchParams>
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
          prop: 'roomCode',
          label: '房间编码',
          width: 120
        },
        {
          prop: 'roomNumber',
          label: '房间号',
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
          prop: 'floorNumber',
          label: '楼层数',
          width: 100,
          formatter: (row: RoomListItem) => {
            return row.floorNumber ? `${row.floorNumber}层` : '-'
          }
        },
        {
          prop: 'roomTypeText',
          label: '房间类型',
          width: 100
        },
        {
          prop: 'bedCount',
          label: '床位数',
          width: 100
        },
        {
          prop: 'currentOccupancy',
          label: '入住人数',
          width: 100
        },
        {
          prop: 'roomStatusText',
          label: '房间状态',
          width: 100
        },
        {
          prop: 'facilities',
          label: '设施',
          minWidth: 160,
          formatter: (row: RoomListItem) => {
            const facilities = []
            if (row.hasAirConditioner === 1) facilities.push('空调')
            if (row.hasBathroom === 1) facilities.push('卫生间')
            if (row.hasBalcony === 1) facilities.push('阳台')
            return facilities.length > 0 ? facilities.join(' / ') : '-'
          }
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: RoomListItem) => {
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
          width: 180,
          fixed: 'right' as const,
          formatter: (row: RoomListItem) => [
            { type: 'view', label: '查看床位', onClick: () => handleViewBeds(row) },
            {
              type: 'edit',
              label: '编辑',
              onClick: () => handleEdit(row),
              auth: 'system:room:edit'
            },
            {
              type: 'add',
              label: '批量增加',
              onClick: () => handleBatchAddBeds(row),
              auth: 'system:room:batchAdd'
            },
            {
              type: 'delete',
              label: '删除',
              onClick: () => handleDelete(row),
              auth: 'system:room:delete',
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
      roomCode: '',
      roomNumber: '',
      floorCode: '',
      campusCode: '',
      roomType: '',
      roomStatus: undefined,
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
   * 新增房间
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑房间
   */
  const handleEdit = (row: RoomListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除房间
   */
  const handleDelete = async (row: RoomListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除房间"${row.roomNumber || row.roomCode}"吗？<br/>提示：删除房间后，该房间下的所有床位也会被删除。`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消',
          dangerouslyUseHTMLString: true
        }
      )
      await fetchDeleteRoom(row.id)
      // 刷新房间列表缓存
      await referenceStore.refreshRoomList()
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除房间失败:', error)
      }
    }
  }

  /**
   * 处理表格行选择变化
   */
  const handleSelectionChange = (selection: RoomListItem[]): void => {
    selectedRows.value = selection
  }

  /**
   * 批量删除房间
   */
  const handleBatchDelete = async (): Promise<void> => {
    if (selectedCount.value === 0) {
      ElMessage.warning('请至少选择一条数据')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要批量删除选中的 ${selectedCount.value} 条房间数据吗？<br/>提示：删除房间后，这些房间下的所有床位也会被删除。`,
        '批量删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消',
          dangerouslyUseHTMLString: true
        }
      )
      await fetchBatchDeleteRoom(selectedIds.value as number[])
      // 刷新房间列表缓存
      await referenceStore.refreshRoomList()
      selectedRows.value = []
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除房间失败:', error)
      }
    }
  }

  /**
   * 状态切换
   */
  const handleStatusChange = async (row: RoomListItem, enabled: boolean): Promise<void> => {
    // 如果是关闭操作（从启用变为停用），需要提示用户级联影响
    if (!enabled && row.status === 1) {
      try {
        let message = `确定要停用房间"${row.roomNumber || row.roomCode}"吗？<br/>提示：停用房间后，该房间下的所有床位也会被停用。`
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
      row.status = enabled ? 1 : 0
      await fetchUpdateRoomStatus(row.id, enabled ? 1 : 0)
    } catch (error) {
      console.error('更新房间状态失败:', error)
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }

  /**
   * 弹窗提交
   */
  const handleSubmit = async (): Promise<void> => {
    dialogVisible.value = false
    // 刷新房间列表缓存
    await referenceStore.refreshRoomList()
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 查看床位
   */
  const handleViewBeds = (row: RoomListItem): void => {
    drillDownType.value = 'bed'
    drillDownParentName.value = row.roomNumber || row.roomCode
    drillDownFilterParams.value = { roomCode: row.roomCode, pageNum: 1 }
    drillDownVisible.value = true
  }

  /**
   * 批量增加床位
   */
  const handleBatchAddBeds = (row: RoomListItem): void => {
    batchBedRoomData.value = { ...row }
    batchBedDialogVisible.value = true
  }

  /**
   * 批量增加床位提交回调
   */
  const handleBatchBedSubmit = async (): Promise<void> => {
    batchBedDialogVisible.value = false
    // 刷新房间数据
    await refreshData()
  }
</script>
