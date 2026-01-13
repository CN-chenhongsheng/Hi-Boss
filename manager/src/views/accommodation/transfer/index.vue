<!-- 调宿管理页面 -->
<template>
  <div class="transfer-page art-full-height">
    <!-- 搜索栏 -->
    <TransferSearch
      v-show="showSearchBar"
      v-model="searchForm"
      @search="handleSearch"
      @reset="resetSearchParams"
    ></TransferSearch>

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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:transfer:add'"
              >新增调宿</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:transfer:delete'"
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
    fetchGetTransferPage,
    fetchDeleteTransfer,
    fetchBatchDeleteTransfer
  } from '@/api/accommodation-manage'
  import { ElMessageBox } from 'element-plus'
  import TransferSearch from './modules/transfer-search.vue'

  defineOptions({ name: 'AccommodationTransfer' })

  type TransferListItem = Api.AccommodationManage.TransferListItem

  // 状态管理
  const showSearchBar = ref(false)
  const selectedRows = ref<TransferListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索表单
  const searchForm = ref<Api.AccommodationManage.TransferSearchParams>({
    pageNum: 1,
    pageSize: 20,
    studentNo: undefined,
    studentName: undefined,
    studentId: undefined,
    originalCampusCode: undefined,
    targetCampusCode: undefined,
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
    refreshRemove
  } = useTable<typeof fetchGetTransferPage>({
    core: {
      apiFn: fetchGetTransferPage,
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
        { prop: 'studentNo', label: '学号', width: 120 },
        { prop: 'studentName', label: '学生姓名', width: 100 },
        { prop: 'genderText', label: '性别', width: 80 },
        { prop: 'phone', label: '手机号', width: 120 },
        { prop: 'originalCampusName', label: '原校区', width: 120 },
        { prop: 'originalRoomCode', label: '原房间', width: 120 },
        { prop: 'originalBedCode', label: '原床位', width: 120 },
        { prop: 'targetCampusName', label: '目标校区', width: 120 },
        { prop: 'targetRoomCode', label: '目标房间', width: 120 },
        { prop: 'targetBedCode', label: '目标床位', width: 120 },
        { prop: 'applyDate', label: '申请日期', width: 180 },
        { prop: 'transferDate', label: '调宿日期', width: 180 },
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
              onClick: (row: TransferListItem) => handleDelete(row),
              auth: 'system:transfer:delete'
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
  const handleDelete = async (row: TransferListItem) => {
    try {
      await ElMessageBox.confirm(`确定要删除调宿记录吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      await fetchDeleteTransfer(row.id)
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
        `确定要批量删除选中的 ${selectedCount.value} 条调宿记录吗？`,
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )
      await fetchBatchDeleteTransfer(selectedIds.value)
      selectedRows.value = []
      await refreshRemove()
    } catch {
      // 用户取消或删除失败
    }
  }

  // 选择变化
  const handleSelectionChange = (rows: TransferListItem[]) => {
    selectedRows.value = rows
  }
</script>
