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
        :data="data"
        :columns="columns"
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
    </ElCard>

    <!-- 学生详情抽屉（查看） -->
    <StudentDrawer
      v-if="dialogType === 'view'"
      v-model:visible="dialogVisible"
      :dialog-type="dialogType"
      :student-id="editData?.id"
      :student-data="editData"
      @saved="handleRefresh"
    />

    <!-- 学生新增/编辑弹窗 -->
    <StudentDialog
      v-if="dialogType === 'edit' || dialogType === 'add'"
      v-model:visible="dialogVisible"
      :dialog-type="dialogType"
      :student-id="editData?.id"
      :student-data="editData"
      @saved="handleRefresh"
    />
  </div>
</template>

<script setup lang="ts">
  import { computed, h, ref } from 'vue'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetStudentPage,
    fetchDeleteStudent,
    fetchBatchDeleteStudent,
    fetchUpdateStudentStatus
  } from '@/api/accommodation-manage'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import StudentSearch from './modules/student-search.vue'
  import StudentDrawer from './modules/student-drawer.vue'
  import StudentDialog from './modules/student-dialog.vue'

  defineOptions({ name: 'AccommodationStudent' })

  type StudentListItem = Api.AccommodationManage.StudentListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)
  const dialogVisible = ref(false)
  const dialogType = ref<'view' | 'edit' | 'add'>('view')
  const editData = ref<StudentListItem | null>(null)

  // 批量选择
  const selectedRows = ref<StudentListItem[]>([])
  const selectedIds = computed(() => selectedRows.value.map((item) => item.id))
  const selectedCount = computed(() => selectedRows.value.length)

  // 搜索表单
  const searchForm = ref<Api.AccommodationManage.StudentSearchParams>({
    pageNum: 1,
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
    refreshRemove,
    contextMenuItems,
    contextMenuWidth,
    handleRowContextmenu,
    handleContextMenuSelect
  } = useTable<typeof fetchGetStudentPage>({
    core: {
      apiFn: fetchGetStudentPage,
      apiParams: computed(() => ({
        pageNum: searchForm.value.pageNum,
        studentNo: searchForm.value.studentNo || undefined,
        studentName: searchForm.value.studentName || undefined,
        phone: searchForm.value.phone || undefined,
        campusCode: searchForm.value.campusCode || undefined,
        deptCode: searchForm.value.deptCode || undefined,
        majorCode: searchForm.value.majorCode || undefined,
        classId: searchForm.value.classId || undefined,
        bedId: searchForm.value.bedId || undefined,
        academicStatus: searchForm.value.academicStatus,
        status: searchForm.value.status
      })),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        { type: 'selection', width: 50 },
        { prop: 'studentNo', label: '学号', width: 120 },
        { prop: 'studentName', label: '姓名', minWidth: 100 },
        { prop: 'genderText', label: '性别', width: 60 },
        { prop: 'phone', label: '手机号', width: 125 },
        { prop: 'nation', label: '民族', minWidth: 80 },
        { prop: 'politicalStatus', label: '政治面貌', minWidth: 100 },
        { prop: 'campusName', label: '校区', minWidth: 100 },
        { prop: 'deptName', label: '院系', minWidth: 120 },
        { prop: 'majorName', label: '专业', minWidth: 120 },
        { prop: 'className', label: '班级', minWidth: 100 },
        { prop: 'floorName', label: '楼栋', minWidth: 100 },
        { prop: 'roomName', label: '房间', minWidth: 100 },
        { prop: 'bedName', label: '床位', minWidth: 100 },
        { prop: 'academicStatusText', label: '学籍状态', width: 100 },
        { prop: 'enrollmentYear', label: '入学年份', width: 100 },
        { prop: 'currentGrade', label: '当前年级', width: 100 },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: StudentListItem) => {
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
          prop: 'action',
          label: '操作',
          width: 180,
          fixed: 'right',
          formatter: (row: StudentListItem) => [
            { type: 'view', label: '查看', onClick: () => handleView(row) },
            {
              type: 'edit',
              label: '编辑',
              onClick: () => handleEdit(row),
              auth: 'system:student:edit'
            },
            {
              type: 'delete',
              label: '删除',
              onClick: () => handleDelete(row),
              auth: 'system:student:delete',
              danger: true
            }
          ]
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

  // 刷新数据
  const handleRefresh = () => {
    refreshData()
  }

  // 查看
  const handleView = async (row: StudentListItem) => {
    dialogType.value = 'view'
    editData.value = row
    dialogVisible.value = true
    // 如果需要获取完整详情，可以调用API
    // try {
    //   const res = await fetchGetStudentDetail(row.id)
    //   if (res.data) {
    //     editData.value = res.data
    //   }
    // } catch {
    //   // 获取失败，使用列表数据
    //   editData.value = row
    // }
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

  /**
   * 更新学生状态
   */
  const handleStatusChange = async (row: StudentListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateStudentStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新学生状态失败:', error)
      row.status = originalStatus
      ElMessage.error('更新学生状态失败')
    } finally {
      row._statusLoading = false
    }
  }
</script>
