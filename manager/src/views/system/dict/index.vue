<!-- 字典管理页面 -->
<template>
  <div class="dict-page art-full-height">
    <div class="dict-container">
      <!-- 左侧：字典类型列表 -->
      <div class="dict-type-panel">
        <ElCard shadow="never" class="panel-card">
          <template #header>
            <div class="panel-header">
              <span class="panel-title">
                <ArtSvgIcon icon="ri:bookmark-line" class="text-primary text-lg" />
                字典类型
              </span>
              <ElButton
                type="primary"
                size="small"
                @click="showTypeDialog('add')"
                v-ripple
                v-permission="'system:dict:type:add'"
              >
                <template #icon><ArtSvgIcon :icon="'ri-add-line'" /></template>
                新增类型
              </ElButton>
            </div>
          </template>

          <!-- 类型搜索 -->
          <div class="search-bar">
            <ElInput
              v-model="typeSearchForm.dictName"
              placeholder="搜索字典名称"
              clearable
              @clear="handleTypeSearch"
              @keyup.enter="handleTypeSearch"
            >
              <template #prefix>
                <i class="i-carbon-search" />
              </template>
            </ElInput>
          </div>

          <!-- 类型表格 -->
          <ArtTable
            :loading="typeLoading"
            :data="typeData"
            :columns="typeColumns"
            :pagination="typePagination"
            @row-click="handleTypeRowClick"
            @pagination:size-change="handleTypeSizeChange"
            @pagination:current-change="handleTypeCurrentChange"
          />
        </ElCard>
      </div>

      <!-- 右侧：字典数据列表 -->
      <div class="dict-data-panel">
        <ElCard shadow="never" class="panel-card">
          <template #header>
            <div class="panel-header">
              <span class="panel-title">
                <ArtSvgIcon icon="ri:list-check" class="text-primary text-lg" />
                字典数据
              </span>
              <ElButton
                type="primary"
                size="small"
                :disabled="!selectedTypeId"
                @click="showDataDialog('add')"
                v-ripple
                v-permission="'system:dict:data:add'"
              >
                <template #icon><ArtSvgIcon :icon="'ri-add-line'" /></template>
                新增数据
              </ElButton>
            </div>
          </template>

          <div v-if="!selectedTypeId" class="empty-tip">
            <ElEmpty description="请先选择左侧字典类型" />
          </div>

          <template v-else>
            <!-- 数据搜索 -->
            <div class="search-bar">
              <ElInput
                v-model="dataSearchForm.label"
                placeholder="搜索字典标签"
                clearable
                @clear="handleDataSearch"
                @keyup.enter="handleDataSearch"
              >
                <template #prefix>
                  <i class="i-carbon-search" />
                </template>
              </ElInput>
            </div>

            <!-- 数据表格 -->
            <ArtTable
              :loading="dataLoading"
              :data="dataData"
              :columns="dataColumns"
              :pagination="dataPagination"
              @pagination:size-change="onDataSizeChange"
              @pagination:current-change="onDataCurrentChange"
            />
          </template>
        </ElCard>
      </div>
    </div>

    <!-- 字典类型弹窗 -->
    <DictTypeDialog
      v-model="typeDialogVisible"
      :dialog-type="typeDialogType"
      :type-data="currentTypeData"
      @success="handleTypeRefresh"
    />

    <!-- 字典数据弹窗 -->
    <DictDataDialog
      v-model="dataDialogVisible"
      :dialog-type="dataDialogType"
      :data-data="currentDataData"
      :dict-code="selectedDictCode"
      @success="handleDataRefresh"
    />
  </div>
</template>

<script setup lang="ts">
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetDictTypePage,
    fetchGetDictTypeDetail,
    fetchUpdateDictType,
    fetchDeleteDictType,
    fetchGetDictDataPage,
    fetchGetDictDataDetail,
    fetchUpdateDictData,
    fetchDeleteDictData
  } from '@/api/system-manage'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import DictTypeDialog from './modules/dict-type-dialog.vue'
  import DictDataDialog from './modules/dict-data-dialog.vue'
  import { ElTag, ElMessageBox, ElMessage } from 'element-plus'
  import { h } from 'vue'
  import { hasPermission } from '@/directives/core/permission'
  import ArtSwitch from '@/components/core/forms/art-switch/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'

  defineOptions({ name: 'Dict' })

  type DictTypeListItem = Api.SystemManage.DictTypeListItem & { _statusLoading?: boolean }
  type DictDataListItem = Api.SystemManage.DictDataListItem & { _statusLoading?: boolean }

  // 字典类型相关
  const selectedTypeId = ref<number | null>(null)
  const selectedDictCode = ref<string>('')
  const typeSearchForm = ref<Api.SystemManage.DictTypeSearchParams>({
    pageNum: 1,
    pageSize: 10,
    dictName: undefined,
    dictCode: undefined,
    status: undefined
  })

  const {
    data: typeData,
    loading: typeLoading,
    pagination: typePagination,
    getData: getTypeData,
    handleSizeChange: handleTypeSizeChange,
    handleCurrentChange: handleTypeCurrentChange
  } = useTable<typeof fetchGetDictTypePage>({
    core: {
      apiFn: fetchGetDictTypePage,
      apiParams: typeSearchForm,
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      }
    } as any
  })

  // 字典数据相关
  const dataSearchForm = ref({
    label: undefined as string | undefined
  })

  const {
    data: dataData,
    loading: dataLoading,
    pagination: dataPagination,
    getData: getDataData
  } = useTable<typeof fetchGetDictDataPage>({
    core: {
      apiFn: fetchGetDictDataPage,
      apiParams: {
        dictCode: '',
        pageNum: 1,
        pageSize: 10
      },
      immediate: false, // 不自动加载，需要先选择字典类型
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      }
    } as any
  })

  // 弹窗相关
  const typeDialogVisible = ref(false)
  const typeDialogType = ref<'add' | 'edit'>('add')
  const currentTypeData = ref<DictTypeListItem | undefined>(undefined)

  const dataDialogVisible = ref(false)
  const dataDialogType = ref<'add' | 'edit'>('add')
  const currentDataData = ref<DictDataListItem | undefined>(undefined)

  // 类型表格列
  const typeColumns = computed(() => [
    {
      prop: 'dictName',
      label: '字典名称',
      minWidth: 120
    },
    {
      prop: 'dictCode',
      label: '字典编码',
      minWidth: 150,
      formatter: (row: DictTypeListItem) => {
        return h('code', { class: 'dict-code' }, row.dictCode)
      }
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: DictTypeListItem) => {
        return h(ArtSwitch, {
          modelValue: row.status === 1,
          loading: row._statusLoading || false,
          inlinePrompt: true,
          onChange: (value: string | number | boolean) => {
            handleTypeStatusChange(row, value === true || value === 1)
          }
        })
      }
    },
    {
      prop: 'remark',
      label: '备注',
      minWidth: 150,
      showOverflowTooltip: true
    },
    {
      prop: 'action',
      label: '操作',
      width: 120,
      fixed: 'right' as const,
      formatter: (row: DictTypeListItem) => {
        const buttons = []
        if (hasPermission('system:dict:type:edit')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => showTypeDialog('edit', row)
            })
          )
        }
        if (hasPermission('system:dict:type:delete')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => deleteType(row)
            })
          )
        }
        return h('div', { class: 'flex gap-1' }, buttons)
      }
    }
  ])

  // 数据表格列
  const dataColumns = computed(() => [
    {
      prop: 'label',
      label: '字典标签',
      minWidth: 120
    },
    {
      prop: 'value',
      label: '字典值',
      minWidth: 120,
      formatter: (row: DictDataListItem) => {
        return h('code', { class: 'dict-value' }, row.value)
      }
    },
    {
      prop: 'listClass',
      label: '样式',
      width: 100,
      formatter: (row: DictDataListItem) => {
        if (!row.listClass) return '-'
        const tagType = (row.listClass || 'info') as
          | 'primary'
          | 'success'
          | 'info'
          | 'warning'
          | 'danger'
        return h(ElTag, { type: tagType, size: 'small' }, () => row.listClass || '-')
      }
    },
    {
      prop: 'sort',
      label: '排序',
      width: 80
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: DictDataListItem) => {
        return h(ArtSwitch, {
          modelValue: row.status === 1,
          loading: row._statusLoading || false,
          inlinePrompt: true,
          onChange: (value: string | number | boolean) => {
            handleDataStatusChange(row, value === true || value === 1)
          }
        })
      }
    },
    {
      prop: 'remark',
      label: '备注',
      minWidth: 150,
      showOverflowTooltip: true
    },
    {
      prop: 'action',
      label: '操作',
      width: 120,
      fixed: 'right' as const,
      formatter: (row: DictDataListItem) => {
        const buttons = []
        if (hasPermission('system:dict:data:edit')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => showDataDialog('edit', row)
            })
          )
        }
        if (hasPermission('system:dict:data:delete')) {
          buttons.push(
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => deleteData(row)
            })
          )
        }
        return h('div', { class: 'flex gap-1' }, buttons)
      }
    }
  ])

  // 类型相关方法
  const handleTypeSearch = () => {
    typeSearchForm.value.pageNum = 1
    getTypeData()
  }

  const handleTypeRowClick = (row: DictTypeListItem) => {
    selectedTypeId.value = row.id
    selectedDictCode.value = row.dictCode
    // 直接传递参数调用 getDataData
    getDataData({
      dictCode: row.dictCode,
      pageNum: 1,
      pageSize: 10
    })
  }

  const showTypeDialog = (type: 'add' | 'edit', data?: DictTypeListItem) => {
    typeDialogType.value = type
    currentTypeData.value = data
    typeDialogVisible.value = true
  }

  const deleteType = async (row: DictTypeListItem) => {
    try {
      await ElMessageBox.confirm(
        `确定删除字典类型"${row.dictName}"吗？此操作不可恢复！`,
        '删除确认',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      await fetchDeleteDictType(row.id)
      handleTypeRefresh()
      // 如果删除的是当前选中的类型，清空右侧数据
      if (selectedTypeId.value === row.id) {
        selectedTypeId.value = null
        selectedDictCode.value = ''
        dataData.value = []
      }
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除字典类型失败:', error)
      }
    }
  }

  const handleTypeRefresh = () => {
    getTypeData()
  }

  // 更新字典类型状态
  const handleTypeStatusChange = async (row: DictTypeListItem, value: boolean) => {
    // 保存原始状态
    const originalStatus = row.status
    try {
      // 设置loading状态
      row._statusLoading = true

      // 先更新UI状态（乐观更新）
      row.status = value ? 1 : 0

      // 获取详情
      const detail = await fetchGetDictTypeDetail(row.id)

      // 更新状态
      await fetchUpdateDictType(row.id, {
        ...detail,
        status: value ? 1 : 0
      })
    } catch (error) {
      console.error('更新字典类型状态失败:', error)
      // 恢复原状态
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }

  // 数据相关方法
  const handleDataSearch = () => {
    if (!selectedDictCode.value) return
    getDataData({
      dictCode: selectedDictCode.value,
      label: dataSearchForm.value.label,
      pageNum: 1,
      pageSize: 10
    })
  }

  const showDataDialog = (type: 'add' | 'edit', data?: DictDataListItem) => {
    dataDialogType.value = type
    currentDataData.value = data
    dataDialogVisible.value = true
  }

  const deleteData = async (row: DictDataListItem) => {
    try {
      await ElMessageBox.confirm(`确定删除字典数据"${row.label}"吗？此操作不可恢复！`, '删除确认', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })

      await fetchDeleteDictData(row.id)
      handleDataRefresh()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除字典数据失败:', error)
      }
    }
  }

  const handleDataRefresh = () => {
    if (!selectedDictCode.value) return
    getDataData({
      dictCode: selectedDictCode.value,
      label: dataSearchForm.value.label,
      pageNum: dataPagination.current || 1,
      pageSize: dataPagination.size || 10
    })
  }

  // 更新字典数据状态
  const handleDataStatusChange = async (row: DictDataListItem, value: boolean) => {
    // 保存原始状态
    const originalStatus = row.status
    try {
      // 设置loading状态
      row._statusLoading = true

      // 先更新UI状态（乐观更新）
      row.status = value ? 1 : 0

      // 获取详情
      const detail = await fetchGetDictDataDetail(row.id)

      // 更新状态
      await fetchUpdateDictData(row.id, {
        ...detail,
        status: value ? 1 : 0
      })
    } catch (error) {
      console.error('更新字典数据状态失败:', error)
      // 恢复原状态
      row.status = originalStatus
    } finally {
      row._statusLoading = false
    }
  }

  // 自定义分页事件处理器
  const onDataSizeChange = (size: number) => {
    if (!selectedDictCode.value) return
    getDataData({
      dictCode: selectedDictCode.value,
      label: dataSearchForm.value.label,
      pageNum: 1,
      pageSize: size
    })
  }

  const onDataCurrentChange = (page: number) => {
    if (!selectedDictCode.value) return
    getDataData({
      dictCode: selectedDictCode.value,
      label: dataSearchForm.value.label,
      pageNum: page,
      pageSize: dataPagination.size || 10
    })
  }

  // 初始化
  onMounted(() => {
    getTypeData()
  })
</script>

<style scoped lang="scss">
  .dict-container {
    display: flex;
    gap: 16px;
    height: 100%;
  }

  .dict-type-panel,
  .dict-data-panel {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
  }

  .panel-card {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    border-radius: calc(var(--custom-radius) / 2 + 2px) !important;

    :deep(.el-card__body) {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }
  }

  .panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .panel-title {
    font-weight: 500;
    font-size: 14px;
  }

  .search-bar {
    margin-bottom: 12px;
  }

  .empty-tip {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .dict-code,
  .dict-value {
    padding: 2px 6px;
    background-color: var(--el-fill-color-light);
    border-radius: 3px;
    font-family: 'Courier New', monospace;
    font-size: 12px;
  }
</style>
