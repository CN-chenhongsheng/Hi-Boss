<!-- 班级管理页面 -->
<template>
  <div class="class-page art-full-height">
    <!-- 搜索栏 -->
    <ArtSearchBar
      v-model="formFilters"
      :items="formItems"
      :showExpand="false"
      @reset="handleReset"
      @search="handleSearch"
    />

    <ElCard class="art-table-card" shadow="never">
      <!-- 表格头部 -->
      <ArtTableHeader :loading="loading" v-model:columns="columnChecks" @refresh="handleRefresh">
        <template #left>
          <ElSpace wrap>
            <ElButton @click="handleAdd" v-ripple v-permission="'system:class:add'"
              >新增班级</ElButton
            >
            <ElButton
              :disabled="selectedRows.length === 0"
              @click="handleBatchDelete"
              v-ripple
              v-permission="'system:class:delete'"
            >
              批量删除
            </ElButton>
          </ElSpace>
        </template>
      </ArtTableHeader>

      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
        :pagination="pagination"
        @selection-change="handleSelectionChange"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />

      <!-- 班级弹窗 -->
      <ClassDialog
        v-model:visible="dialogVisible"
        :type="dialogType"
        :edit-data="currentClassData"
        @submit="handleDialogSubmit"
      />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetClassPage,
    fetchDeleteClass,
    fetchBatchDeleteClass,
    fetchUpdateClassStatus
  } from '@/api/school-manage'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import ClassDialog from './modules/class-dialog.vue'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import { DialogType } from '@/types'
  import { hasPermission } from '@/directives/core/permission'
  import { h } from 'vue'

  defineOptions({ name: 'Class' })

  type ClassListItem = Api.SystemManage.ClassListItem & { _statusLoading?: boolean }

  // 弹窗相关
  const dialogType = ref<DialogType>('add')
  const dialogVisible = ref(false)
  const currentClassData = ref<Partial<ClassListItem>>({})
  const selectedRows = ref<ClassListItem[]>([])

  // 搜索栏表单数据（使用 reactive 以确保双向绑定正常工作）
  const formFilters = reactive<Api.SystemManage.ClassSearchParams>({
    pageNum: 1,
    pageSize: 20,
    classCode: undefined,
    className: undefined,
    majorCode: undefined,
    grade: undefined,
    enrollmentYear: undefined,
    status: undefined
  })

  const {
    columns,
    columnChecks,
    data,
    loading,
    pagination,
    getData,
    resetSearchParams,
    handleSizeChange,
    handleCurrentChange,
    refreshData,
    refreshCreate,
    refreshUpdate,
    refreshRemove
  } = useTable<typeof fetchGetClassPage>({
    core: {
      apiFn: fetchGetClassPage,
      apiParams: computed(() => {
        // 从 formFilters 同步到 searchParams，用于 API 调用
        // 分页信息由 useTable 内部管理，这里只传递搜索条件
        return {
          classCode: formFilters.classCode || undefined,
          className: formFilters.className || undefined,
          majorCode: formFilters.majorCode || undefined,
          grade: formFilters.grade || undefined,
          enrollmentYear: formFilters.enrollmentYear,
          status: formFilters.status
        } as Partial<Api.SystemManage.ClassSearchParams>
      }),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        {
          type: 'selection',
          width: 55
        },
        {
          prop: 'classCode',
          label: '班级编码',
          minWidth: 120
        },
        {
          prop: 'className',
          label: '班级名称',
          minWidth: 150
        },
        {
          prop: 'majorName',
          label: '所属专业',
          minWidth: 150
        },
        {
          prop: 'grade',
          label: '年级',
          width: 100
        },
        {
          prop: 'enrollmentYear',
          label: '入学年份',
          width: 100
        },
        {
          prop: 'teacher',
          label: '负责人',
          minWidth: 120
        },
        {
          prop: 'currentCount',
          label: '当前人数',
          width: 100
        },
        {
          prop: 'status',
          label: '状态',
          width: 100,
          formatter: (row: ClassListItem) => {
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
          prop: 'createTime',
          label: '创建时间',
          width: 180
        },
        {
          prop: 'action',
          label: '操作',
          width: 150,
          fixed: 'right' as const,
          formatter: (row: ClassListItem) => {
            const buttons = []
            if (hasPermission('system:class:edit')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'edit',
                  onClick: () => handleEdit(row)
                })
              )
            }
            if (hasPermission('system:class:delete')) {
              buttons.push(
                h(ArtButtonTable, {
                  type: 'delete',
                  onClick: () => handleDelete(row)
                })
              )
            }
            return h('div', { class: 'flex gap-1' }, buttons)
          }
        }
      ]
    } as any
  })

  /**
   * 搜索
   */
  const handleSearch = async (): Promise<void> => {
    // getData 方法会自动重置到第一页（对应内部的 getDataByPage）
    await getData()
  }

  /**
   * 重置搜索
   */
  const handleReset = async (): Promise<void> => {
    // 重置 formFilters
    Object.assign(formFilters, {
      classCode: undefined,
      className: undefined,
      majorCode: undefined,
      grade: undefined,
      enrollmentYear: undefined,
      status: undefined
    })
    // 使用 useTable 的 resetSearchParams 统一重置
    await resetSearchParams()
  }

  /**
   * 刷新数据
   */
  const handleRefresh = (): void => {
    refreshData()
  }

  /**
   * 新增班级
   */
  const handleAdd = (): void => {
    dialogType.value = 'add'
    currentClassData.value = {}
    dialogVisible.value = true
  }

  /**
   * 编辑班级
   */
  const handleEdit = (row: ClassListItem): void => {
    dialogType.value = 'edit'
    currentClassData.value = { ...row }
    dialogVisible.value = true
  }

  /**
   * 删除班级
   */
  const handleDelete = async (row: ClassListItem): Promise<void> => {
    try {
      await ElMessageBox.confirm(
        `确定要删除班级"${row.className}"吗？此操作不可恢复！`,
        '删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      await fetchDeleteClass(row.id)
      ElMessage.success('删除成功')
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除班级失败:', error)
      }
    }
  }

  /**
   * 批量删除
   */
  const handleBatchDelete = async (): Promise<void> => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请选择要删除的班级')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要删除选中的 ${selectedRows.value.length} 个班级吗？此操作不可恢复！`,
        '批量删除确认',
        {
          type: 'warning',
          confirmButtonText: '确定删除',
          cancelButtonText: '取消'
        }
      )
      const ids = selectedRows.value.map((item) => item.id)
      await fetchBatchDeleteClass(ids)
      ElMessage.success('批量删除成功')
      selectedRows.value = []
      await refreshRemove()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('批量删除失败:', error)
      }
    }
  }

  /**
   * 选择变化
   */
  const handleSelectionChange = (selection: ClassListItem[]): void => {
    selectedRows.value = selection
  }

  /**
   * 弹窗提交
   */
  const handleDialogSubmit = async (): Promise<void> => {
    dialogVisible.value = false
    // 根据 dialogType 判断是新增还是编辑
    if (dialogType.value === 'add') {
      await refreshCreate()
    } else {
      await refreshUpdate()
    }
  }

  /**
   * 更新班级状态
   */
  const handleStatusChange = async (row: ClassListItem, value: boolean): Promise<void> => {
    const originalStatus = row.status
    try {
      row._statusLoading = true
      row.status = value ? 1 : 0
      await fetchUpdateClassStatus(row.id, value ? 1 : 0)
    } catch (error) {
      console.error('更新班级状态失败:', error)
      ElMessage.error('更新班级状态失败')
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }

  // 表单项配置（用于搜索栏）
  const formItems = computed(() => [
    {
      label: '班级编码',
      key: 'classCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入班级编码' }
    },
    {
      label: '班级名称',
      key: 'className',
      type: 'input',
      props: { clearable: true, placeholder: '请输入班级名称' }
    },
    {
      label: '所属专业',
      key: 'majorCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入专业编码' }
    },
    {
      label: '年级',
      key: 'grade',
      type: 'input',
      props: { clearable: true, placeholder: '请输入年级' }
    },
    {
      label: '入学年份',
      key: 'enrollmentYear',
      type: 'input',
      props: { clearable: true, placeholder: '请输入入学年份' }
    },
    {
      label: '状态',
      key: 'status',
      type: 'select',
      props: {
        clearable: true,
        placeholder: '请选择状态',
        options: [
          { label: '正常', value: 1 },
          { label: '停用', value: 0 }
        ]
      }
    }
  ])
</script>
