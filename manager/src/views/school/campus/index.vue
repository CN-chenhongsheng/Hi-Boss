<!-- 校区管理页面 -->
<template>
  <div class="campus-page art-full-height">
    <!-- 搜索栏 -->
    <CampusSearch
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
            <ElButton @click="handleAdd" v-ripple v-permission="'system:campus:add'"
              >新增校区</ElButton
            >
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable :loading="loading" :columns="columns" :data="data" :stripe="false" />

      <!-- 校区弹窗 -->
      <CampusDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="editData"
        @submit="handleSubmit"
      />

      <!-- 下钻弹框（院系） -->
      <DrillDownDialog
        v-model:visible="drillDownVisible"
        :drill-type="drillDownType"
        :parent-name="drillDownParentName"
        :filter-params="drillDownFilterParams"
        :key="`${drillDownType}-${drillDownVisible}`"
        @drill-down="handleDrillDown"
      />

      <!-- 嵌套下钻弹框（专业） -->
      <DrillDownDialog
        v-model:visible="nestedDrillDownVisible"
        :drill-type="nestedDrillDownType"
        :parent-name="nestedDrillDownParentName"
        :filter-params="nestedDrillDownFilterParams"
        :key="`${nestedDrillDownType}-${nestedDrillDownVisible}`"
        @drill-down="handleNestedDrillDown"
      />

      <!-- 第三层下钻弹框（班级） -->
      <DrillDownDialog
        v-model:visible="thirdLevelDrillDownVisible"
        :drill-type="thirdLevelDrillDownType"
        :parent-name="thirdLevelDrillDownParentName"
        :filter-params="thirdLevelDrillDownFilterParams"
        :key="`${thirdLevelDrillDownType}-${thirdLevelDrillDownVisible}`"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import CampusDialog from './modules/campus-dialog.vue'
  import CampusSearch from './modules/campus-search.vue'
  import {
    fetchGetCampusTree,
    fetchDeleteCampus,
    fetchUpdateCampusStatus
  } from '@/api/school-manage'
  import DrillDownDialog from '@/components/school/DrillDownDialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import { h } from 'vue'

  defineOptions({ name: 'Campus' })

  type CampusListItem = Api.SystemManage.CampusListItem & { _statusLoading?: boolean }

  // 状态管理
  const showSearchBar = ref(false)

  // 弹窗相关
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const editData = ref<CampusListItem | null>(null)

  // 下钻弹框相关
  const drillDownVisible = ref(false)
  const drillDownType = ref<'department' | 'major' | 'class'>('department')
  const drillDownParentName = ref('')
  const drillDownFilterParams = ref<Record<string, any>>({})
  const nestedDrillDownVisible = ref(false)
  const nestedDrillDownType = ref<'department' | 'major' | 'class'>('major')
  const nestedDrillDownParentName = ref('')
  const nestedDrillDownFilterParams = ref<Record<string, any>>({})
  const thirdLevelDrillDownVisible = ref(false)
  const thirdLevelDrillDownType = ref<'department' | 'major' | 'class'>('class')
  const thirdLevelDrillDownParentName = ref('')
  const thirdLevelDrillDownFilterParams = ref<Record<string, any>>({})

  // 搜索相关
  const initialSearchState = {
    campusCode: '',
    campusName: '',
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
  } = useTable<typeof fetchGetCampusTree>({
    core: {
      apiFn: fetchGetCampusTree,
      apiParams: computed(() => {
        return {
          campusCode: formFilters.campusCode || undefined,
          campusName: formFilters.campusName || undefined,
          status: formFilters.status
        } as Partial<Api.SystemManage.CampusSearchParams>
      }),
      columnsFactory: () => [
        {
          prop: 'campusCode',
          label: '校区编码',
          minWidth: 120
        },
        {
          prop: 'campusName',
          label: '校区名称',
          minWidth: 150
        },
        {
          prop: 'address',
          label: '校区地址',
          minWidth: 200
        },
        {
          prop: 'manager',
          label: '负责人',
          minWidth: 100
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: CampusListItem) => {
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
          formatter: (row: CampusListItem) => [
            { type: 'view', onClick: () => handleViewDepartments(row) },
            { type: 'edit', onClick: () => handleEdit(row), auth: 'system:campus:edit' },
            {
              type: 'delete',
              onClick: () => handleDelete(row),
              auth: 'system:campus:delete',
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
   * 新增校区
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    editData.value = null
    dialogVisible.value = true
  }

  /**
   * 编辑校区
   */
  const handleEdit = (row: CampusListItem): void => {
    dialogType.value = 'edit'
    editData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除校区
   */
  const handleDelete = async (row: CampusListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除校区"${row.campusName}"吗？<br/>提示：删除校区后，该校区下的所有院系、专业和班级也会被删除。`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消',
          dangerouslyUseHTMLString: true
        }
      )
      await fetchDeleteCampus(row.id)
      ElMessage.success('删除成功')
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除校区失败:', error)
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
   * 查看院系
   */
  const handleViewDepartments = (row: CampusListItem): void => {
    drillDownType.value = 'department'
    drillDownParentName.value = row.campusName
    drillDownFilterParams.value = { campusCode: row.campusCode }
    drillDownVisible.value = true
  }

  /**
   * 处理下钻事件
   */
  const handleDrillDown = (type: 'department' | 'major' | 'class', row: any): void => {
    if (type === 'major') {
      // 从院系下钻到专业
      nestedDrillDownType.value = 'major'
      nestedDrillDownParentName.value = row.deptName
      nestedDrillDownFilterParams.value = { deptCode: row.deptCode }
      nestedDrillDownVisible.value = true
    } else if (type === 'class') {
      // 从专业下钻到班级
      thirdLevelDrillDownType.value = 'class'
      thirdLevelDrillDownParentName.value = row.majorName
      thirdLevelDrillDownFilterParams.value = { majorCode: row.majorCode }
      thirdLevelDrillDownVisible.value = true
    }
  }

  /**
   * 处理嵌套下钻事件（从专业下钻到班级）
   */
  const handleNestedDrillDown = (type: 'department' | 'major' | 'class', row: any): void => {
    if (type === 'class') {
      // 从专业下钻到班级
      thirdLevelDrillDownType.value = 'class'
      thirdLevelDrillDownParentName.value = row.majorName
      thirdLevelDrillDownFilterParams.value = { majorCode: row.majorCode }
      thirdLevelDrillDownVisible.value = true
    }
  }

  /**
   * 更新校区状态
   */
  const handleStatusChange = async (row: CampusListItem, value: boolean): Promise<void> => {
    // 如果是关闭操作（从启用变为停用），需要提示用户级联影响
    if (!value && row.status === 1) {
      try {
        let message = `确定要停用校区"${row.campusName}"吗？<br/>提示：停用校区后，该校区下的所有院系、专业和班级也会被停用。`
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
      row.status = value ? 1 : 0
      await fetchUpdateCampusStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新校区状态失败:', error)
      ElMessage.error('更新校区状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }
</script>
