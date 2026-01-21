<!-- 入住管理页面 -->
<template>
  <div class="check-in-page art-full-height">
    <!-- 搜索栏 -->
    <CheckInSearch
      v-show="showSearchBar"
      v-model="searchForm"
      @search="handleSearch"
      @reset="handleReset"
    ></CheckInSearch>

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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:checkIn:add'"
              >新增入住</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:checkIn:delete'"
            >
              批量删除{{ selectedCount > 0 ? `(${selectedCount})` : '' }}
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
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
    </ElCard>

    <!-- 申请详情抽屉 -->
    <CheckInDrawer
      :visible="drawerVisible"
      :check-in-id="currentRow?.id || null"
      :check-in-data="currentRow"
      @update:visible="drawerVisible = $event"
      @approval-success="handleRefresh"
    />
  </div>
</template>

<script setup lang="ts">
  import { computed, ref, h } from 'vue'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetCheckInPage,
    fetchDeleteCheckIn,
    fetchBatchDeleteCheckIn
  } from '@/api/accommodation-manage'
  import { ElMessageBox, ElTag } from 'element-plus'
  import CheckInSearch from './modules/check-in-search.vue'
  import CheckInDrawer from './modules/check-in-drawer.vue'

  defineOptions({ name: 'AccommodationCheckIn' })

  type CheckInListItem = Api.AccommodationManage.CheckInListItem

  // 状态管理
  const showSearchBar = ref(false)
  const selectedRows = ref<CheckInListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)
  const drawerVisible = ref(false)
  const currentRow = ref<CheckInListItem | null>(null)

  // 搜索表单
  const searchForm = ref<Api.AccommodationManage.CheckInSearchParams>({
    pageNum: 1,
    studentNo: undefined,
    studentName: undefined,
    studentId: undefined,
    checkInType: undefined,
    campusCode: undefined,
    bedId: undefined,
    status: undefined,
    applyDateStart: undefined,
    applyDateEnd: undefined
  })

  // 使用 useTable 管理表格数据
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
    refreshRemove,
    contextMenuItems,
    contextMenuWidth,
    handleRowContextmenu,
    handleContextMenuSelect
  } = useTable<typeof fetchGetCheckInPage>({
    core: {
      apiFn: fetchGetCheckInPage,
      apiParams: computed(() => ({
        pageNum: searchForm.value.pageNum,
        studentNo: searchForm.value.studentNo || undefined,
        studentName: searchForm.value.studentName || undefined,
        studentId: searchForm.value.studentId || undefined,
        checkInType: searchForm.value.checkInType,
        campusCode: searchForm.value.campusCode || undefined,
        bedId: searchForm.value.bedId || undefined,
        status: searchForm.value.status,
        applyDateStart: searchForm.value.applyDateStart || undefined,
        applyDateEnd: searchForm.value.applyDateEnd || undefined
      })),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        { type: 'selection', width: 50 },
        { prop: 'studentNo', label: '学号', width: 120 },
        { prop: 'studentName', label: '学生姓名', width: 100 },
        { prop: 'checkInTypeText', label: '入住类型', width: 100 },
        { prop: 'campusName', label: '校区', width: 120 },
        { prop: 'deptName', label: '院系', width: 120 },
        { prop: 'majorName', label: '专业', width: 120 },
        { prop: 'className', label: '班级', width: 120 },
        { prop: 'roomCode', label: '房间编码', width: 120 },
        { prop: 'bedCode', label: '床位编码', width: 120 },
        { prop: 'applyDate', label: '申请日期', width: 180, sortable: true },
        { prop: 'checkInDate', label: '入住日期', width: 180, sortable: true },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: CheckInListItem) => {
            const statusMap: Record<
              number,
              { type: 'warning' | 'success' | 'danger' | 'info'; text: string }
            > = {
              1: { type: 'warning', text: '待审核' },
              2: { type: 'success', text: '已通过' },
              3: { type: 'danger', text: '已拒绝' },
              4: { type: 'info', text: '已入住' }
            }
            const config = statusMap[row.status] || { type: 'info', text: row.statusText || '未知' }
            return h(ElTag, { type: config.type, size: 'small' }, () => config.text)
          }
        },
        {
          prop: 'action',
          label: '操作',
          width: 150,
          fixed: 'right',
          formatter: (row: CheckInListItem) => {
            return [
              { type: 'view', label: '查看', onClick: () => handleView(row) },
              {
                type: 'delete',
                label: '删除',
                onClick: () => handleDelete(row),
                danger: true,
                auth: 'system:checkIn:delete'
              }
            ]
          }
        }
      ]
    },
    adaptive: {
      enabled: true
    },
    contextMenu: {
      enabled: true
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
   * 重置搜索
   */
  const handleReset = () => {
    resetSearchParams()
  }

  // 刷新数据
  const handleRefresh = () => {
    refreshData()
  }

  // 新增
  const handleAdd = () => {
    // TODO: 打开新增对话框
  }

  // 查看
  const handleView = (row: CheckInListItem) => {
    currentRow.value = row
    drawerVisible.value = true
  }

  // 删除
  const handleDelete = async (row: CheckInListItem) => {
    try {
      await ElMessageBox.confirm(`确定要删除入住记录吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      await fetchDeleteCheckIn(row.id)
      await refreshRemove()
    } catch {
      // 用户取消或删除失败
    }
  }

  // 批量删除
  const handleBatchDelete = async () => {
    if (selectedCount.value === 0) {
      return
    }
    try {
      await ElMessageBox.confirm(
        `确定要批量删除选中的 ${selectedCount.value} 条入住记录吗？`,
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )
      await fetchBatchDeleteCheckIn(selectedIds.value)
      selectedRows.value = []
      await refreshRemove()
    } catch {
      // 用户取消或删除失败
    }
  }

  // 选择变化
  const handleSelectionChange = (rows: CheckInListItem[]) => {
    selectedRows.value = rows
  }
</script>
