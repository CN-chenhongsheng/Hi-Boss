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
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        :loading="loading"
        :columns="columns"
        :data="data"
        :stripe="false"
        :pagination="pagination"
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
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import RoomDialog from './modules/room-dialog.vue'
  import RoomSearch from './modules/room-search.vue'
  import { fetchGetRoomPage, fetchDeleteRoom, fetchUpdateRoomStatus } from '@/api/dormitory-manage'
  import DrillDownDialog from '@/components/school/DrillDownDialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  defineOptions({ name: 'Room' })

  type RoomListItem = Api.SystemManage.RoomListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<RoomListItem | null>(null)

  // 下钻弹框相关
  const drillDownVisible = ref(false)
  const drillDownType = ref<'bed'>('bed')
  const drillDownParentName = ref('')
  const drillDownFilterParams = ref<Record<string, any>>({})

  // 搜索相关
  const initialSearchState = {
    roomCode: '',
    roomNumber: '',
    floorCode: '',
    campusCode: '',
    roomType: '',
    roomStatus: undefined,
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
  } = useTable<typeof fetchGetRoomPage>({
    core: {
      apiFn: fetchGetRoomPage,
      apiParams: computed(() => {
        return {
          roomCode: formFilters.roomCode || undefined,
          roomNumber: formFilters.roomNumber || undefined,
          floorCode: formFilters.floorCode || undefined,
          campusCode: formFilters.campusCode || undefined,
          roomType: formFilters.roomType || undefined,
          roomStatus: formFilters.roomStatus,
          status: formFilters.status,
          pageNum: formFilters.pageNum,
          pageSize: formFilters.pageSize
        } as Partial<Api.SystemManage.RoomSearchParams>
      }),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        {
          prop: 'roomCode',
          label: '房间编码',
          minWidth: 120
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
          minWidth: 150,
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
          width: 180
        },
        {
          prop: 'action',
          label: '操作',
          width: 200,
          fixed: 'right' as const,
          formatter: (row: RoomListItem) => [
            { type: 'view', onClick: () => handleViewBeds(row), label: '查看床位' },
            { type: 'edit', onClick: () => handleEdit(row), auth: 'system:room:edit' },
            {
              type: 'delete',
              onClick: () => handleDelete(row),
              auth: 'system:room:delete',
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
        `确定要删除房间"${row.roomNumber || row.roomCode}"吗？`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchDeleteRoom(row.id)
      ElMessage.success('删除成功')
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除房间失败:', error)
      }
    }
  }

  /**
   * 状态切换
   */
  const handleStatusChange = async (row: RoomListItem, enabled: boolean): Promise<void> => {
    try {
      row._statusLoading = true
      const status = enabled ? 1 : 0
      await ElMessageBox.confirm(
        `确定要${enabled ? '启用' : '停用'}房间"${row.roomNumber || row.roomCode}"吗？`,
        '状态确认',
        {
          type: 'warning',
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }
      )
      await fetchUpdateRoomStatus(row.id, status)
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
    drillDownFilterParams.value = { roomCode: row.roomCode, pageNum: 1, pageSize: 20 }
    drillDownVisible.value = true
  }
</script>
