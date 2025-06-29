<template>
  <ArtDialog v-model="dialogVisible" title="字典数据列表" width="70%">
    <!-- 搜索栏 -->
    <ArtSearchBar
      v-model:filter="formFilters"
      :items="formItems"
      @reset="handleReset"
      @search="handleSearchWrapper"
    />

    <ElCard shadow="never" class="art-table-card">
      <!-- 表格头部 -->
      <ArtTableHeader v-model:columns="columnChecks" :fullScreen="false" @refresh="handleRefresh">
        <template #left>
          <ElButton @click="handleOperation('add')" v-ripple>新增数据</ElButton>
          <transition :name="settingStore.pageTransition">
            <ElButton
              v-show="showRecoverButton"
              @click="handleBatchDelete"
              :disabled="!selectedRows.length"
              v-ripple
            >
              批量删除 ({{ selectedRows.length }})
            </ElButton>
          </transition>
        </template>
      </ArtTableHeader>

      <!-- 字典明细表格 -->
      <ArtTable
        :loading="loading"
        :data="tableData"
        :currentPage="pagination.pageNum"
        :pageSize="pagination.pageSize"
        :total="pagination.total"
        row-key="dictCode"
        paginationAlign="right-margin-left"
        style="width: 100%"
        @selection-change="handleSelectionChange"
        @current-change="handleCurrentChange"
        @size-change="handleSizeChange"
      >
        <template #default>
          <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
        </template>
      </ArtTable>
    </ElCard>
  </ArtDialog>

  <!-- 字典明细对话框 -->
  <DictDetail
    v-model="dialogDetailsVisible"
    v-model:type="dialogType"
    v-model:data="detailFormData"
    @refresh="handleRefresh"
  />
</template>

<script setup lang="ts">
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import DictDetail from './DictDetail.vue'
import { useSettingStore } from '@/store/modules/setting'
import ArtSearchBar from '@/components/core/forms/art-search-bar/index.vue'

// 使用设置 Store 获取过渡效果配置
const settingStore = useSettingStore()

// 导入composables
import { useDictDataOperations, DictionaryDetailItem } from '../composables/useDictDataOperations'
import { useDictDataColumns } from '../composables/useDictionaryColumns'
import { useDictDataSearch } from '../composables/useDictDataSearch'

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const currentDictType = defineModel<string>('dictType', { required: true })

// 导出DICTIONARY_DETAIL_DATA引用，便于外部调用
const tableData = defineModel<DictionaryDetailItem[]>('details', { required: true })

// 添加本地loading状态
const loading = ref(false)

// 分页参数
const pagination = reactive({
  pageNum: 1,
  pageSize: 20,
  total: 0
})

const emit = defineEmits(['refresh'])

// 使用字典数据搜索配置
const { formFilters, formItems, handleReset, handleSearch } = useDictDataSearch()

// 查询参数
const queryParams = reactive({
  dictLabel: '',
  status: '',
  dictType: currentDictType.value
})

// 刷新字典明细
const handleRefresh = () => {
  emit('refresh', queryParams)
}

// 重写搜索处理函数
const handleSearchWrapper = () => {
  handleSearch((params) => {
    // 合并搜索参数和当前字典类型
    Object.assign(queryParams, params, { dictType: currentDictType.value })
    // 重置页码
    pagination.pageNum = 1
    // 刷新数据
    handleRefresh()
  })
}

// 使用字典数据操作composable - 注意这里我们直接传递了currentDictType响应式对象，并传入emit函数
const {
  selectedRows,
  dialogType,
  dialogDetailsVisible,
  detailFormData,
  handleSelectionChange,
  handleAddDictData,
  handleEditDictData,
  handleDeleteDictData,
  handleBatchDelete
} = useDictDataOperations(currentDictType, emit)

// 监听currentDictType的变化，记录变化情况
watch(currentDictType, (newValue) => {
  // 确保detailFormData中的dictType始终与currentDictType保持一致
  if (detailFormData.value) {
    detailFormData.value.dictType = newValue
  }
  // 更新查询参数中的dictType
  queryParams.dictType = newValue
})

// 计算属性：是否显示批量删除按钮
const showRecoverButton = computed(() => selectedRows.value.length > 0)

// 显示对话框
const handleOperation = (type: string, row?: any) => {
  // 确保每次操作前detailFormData中的dictType都是最新的
  if (detailFormData.value) {
    detailFormData.value.dictType = currentDictType.value
  }

  switch (type) {
    case 'add':
      handleAddDictData()
      break
    case 'edit':
      handleEditDictData(row)
      break
    case 'delete':
      handleDeleteDictData(row)
      break
    default:
      break
  }
}

// 使用字典数据列配置
const { columnChecks, columns } = useDictDataColumns(handleOperation)

// 处理页码变化
const handleCurrentChange = (page: number) => {
  pagination.pageNum = page
  handleRefresh()
}

// 处理每页条数变化
const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.pageNum = 1
  handleRefresh()
}
</script>

<style scoped>
.operation-btns {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
</style>
