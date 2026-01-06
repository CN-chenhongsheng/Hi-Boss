<!-- 人员管理（学生）页面 -->
<template>
  <div class="student-page art-full-height">
    <!-- 搜索栏 -->
    <StudentSearch
      v-show="showSearchBar"
      v-model="searchForm"
      @search="handleSearch"
      @reset="resetSearchParams"
    ></StudentSearch>

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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:student:add'"
              >新增学生</ElButton
            >
            <ElButton
              :disabled="selectedCount === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:student:delete'"
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
    fetchGetStudentPage,
    fetchDeleteStudent,
    fetchBatchDeleteStudent
  } from '@/api/accommodation-manage'
  import { ElMessageBox } from 'element-plus'
  import StudentSearch from './modules/student-search.vue'

  defineOptions({ name: 'AccommodationStudent' })

  type StudentListItem = Api.AccommodationManage.StudentListItem

  // 状态管理
  const showSearchBar = ref(false)
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<StudentListItem | null>(null)

  // 批量选择
  const selectedRows = ref<StudentListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索表单
  const searchForm = ref<Api.AccommodationManage.StudentSearchParams>({
    pageNum: 1,
    pageSize: 20,
    studentNo: undefined,
    studentName: undefined,
    phone: undefined,
    campusCode: undefined,
    deptCode: undefined,
    majorCode: undefined,
    classId: undefined,
    bedId: undefined,
    academicStatus: undefined,
    status: undefined
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
  } = useTable<typeof fetchGetStudentPage>({
    core: {
      apiFn: fetchGetStudentPage,
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
        { prop: 'studentName', label: '姓名', width: 100 },
        { prop: 'genderText', label: '性别', width: 80 },
        { prop: 'phone', label: '手机号', width: 120 },
        { prop: 'campusName', label: '校区', width: 120 },
        { prop: 'deptName', label: '院系', width: 120 },
        { prop: 'majorName', label: '专业', width: 120 },
        { prop: 'className', label: '班级', width: 120 },
        { prop: 'bedCode', label: '床位编码', width: 120 },
        { prop: 'academicStatusText', label: '学籍状态', width: 100 },
        { prop: 'statusText', label: '状态', width: 80 },
        {
          prop: 'action',
          label: '操作',
          width: 200,
          fixed: 'right',
          actions: [
            { type: 'view', onClick: (row: StudentListItem) => handleView(row) },
            {
              type: 'edit',
              onClick: (row: StudentListItem) => handleEdit(row),
              auth: 'system:student:edit'
            },
            {
              type: 'delete',
              onClick: (row: StudentListItem) => handleDelete(row),
              auth: 'system:student:delete'
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
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  // 查看
  const handleView = (row: StudentListItem) => {
    dialogType.value = 'edit'
    editData.value = row
    dialogVisible.value = true
  }

  // 编辑
  const handleEdit = (row: StudentListItem) => {
    dialogType.value = 'edit'
    editData.value = row
    dialogVisible.value = true
  }

  // 删除
  const handleDelete = async (row: StudentListItem) => {
    try {
      await ElMessageBox.confirm(`确定要删除学生"${row.studentName}"吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      })
      await fetchDeleteStudent(row.id)
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
        `确定要批量删除选中的 ${selectedCount.value} 条学生数据吗？`,
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: true
        }
      )
      await fetchBatchDeleteStudent(selectedIds.value)
      selectedRows.value = []
      await refreshRemove()
    } catch {
      // 用户取消或删除失败
    }
  }

  // 选择变化
  const handleSelectionChange = (rows: StudentListItem[]) => {
    selectedRows.value = rows
  }
</script>
