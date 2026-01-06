<!-- 留宿管理页面 -->
<template>
  <div class="stay-page art-full-height">
    <!-- 搜索栏 -->
    <StaySearch
      v-show="showSearchBar"
      v-model="searchForm"
      @search="handleSearch"
      @reset="resetSearchParams"
    ></StaySearch>

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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:stay:add'"
              >新增留宿</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:stay:delete'"
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
        :pagination="pagination"
        :stripe="false"
        row-key="id"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { computed } from 'vue'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetStayPage,
    fetchDeleteStay,
    fetchBatchDeleteStay
  } from '@/api/accommodation-manage'
  import { ElMessageBox } from 'element-plus'
  import StaySearch from './modules/stay-search.vue'

  defineOptions({ name: 'AccommodationStay' })

  type StayListItem = Api.AccommodationManage.StayListItem

  // 状态管理
  const showSearchBar = ref(false)
  const selectedRows = ref<StayListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索表单
  const searchForm = ref<Api.AccommodationManage.StaySearchParams>({
    pageNum: 1,
    pageSize: 20,
    studentNo: undefined,
    studentName: undefined,
    studentId: undefined,
    campusCode: undefined,
    bedId: undefined,
    status: undefined,
    applyDateStart: undefined,
    applyDateEnd: undefined,
    stayStartDateStart: undefined,
    stayStartDateEnd: undefined
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
    refreshRemove
  } = useTable<typeof fetchGetStayPage>({
    core: {
      apiFn: fetchGetStayPage,
      apiParams: computed(() => ({
        pageNum: searchForm.value.pageNum || 1,
        pageSize: searchForm.value.pageSize || 20,
        ...searchForm.value
      })),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        { type: 'selection', width: 50 },
        { type: 'index', label: '序号', width: 60 },
        { prop: 'studentNo', label: '学号', width: 120 },
        { prop: 'studentName', label: '学生姓名', width: 100 },
        { prop: 'campusName', label: '校区', width: 120 },
        { prop: 'roomCode', label: '房间编码', width: 120 },
        { prop: 'bedCode', label: '床位编码', width: 120 },
        { prop: 'applyDate', label: '申请日期', width: 120 },
        { prop: 'stayStartDate', label: '留宿开始日期', width: 140 },
        { prop: 'stayEndDate', label: '留宿结束日期', width: 140 },
        { prop: 'stayReason', label: '留宿理由', width: 200 },
        { prop: 'statusText', label: '状态', width: 100 },
        {
          prop: 'action',
          label: '操作',
          width: 150,
          fixed: 'right',
          actions: [
            { type: 'view', onClick: () => handleView() },
            {
              type: 'delete',
              onClick: (row: StayListItem) => handleDelete(row),
              auth: 'system:stay:delete'
            }
          ]
        }
      ]
    }
  })

  /**
   * 搜索处理
   */
  const handleSearch = (params: Record<string, any>) => {
    Object.assign(searchParams, params, { pageNum: 1 })
    getData()
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
  const handleView = () => {
    // TODO: 打开查看对话框
  }

  // 删除
  const handleDelete = async (row: StayListItem) => {
    try {
      await ElMessageBox.confirm(`确定要删除留宿记录吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      await fetchDeleteStay(row.id)
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
        `确定要批量删除选中的 ${selectedCount.value} 条留宿记录吗？`,
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )
      await fetchBatchDeleteStay(selectedIds.value)
      selectedRows.value = []
      await refreshRemove()
    } catch {
      // 用户取消或删除失败
    }
  }

  // 选择变化
  const handleSelectionChange = (rows: StayListItem[]) => {
    selectedRows.value = rows
  }
</script>
