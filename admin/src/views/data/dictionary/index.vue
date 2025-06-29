<template>
  <ArtTableFullScreen>
    <div class="dictionary-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearchWrapper"
      />

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton @click="handleOperation('add')" v-ripple>新增字典</ElButton>
            <transition :name="settingStore.pageTransition">
              <ElButton
                v-show="showRecoverButton"
                @click="handleBatchDelete"
                :disabled="!selectedRows.length"
                v-ripple
              >
                批量删除({{ selectedRows.length }})
              </ElButton>
            </transition>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="tableData"
          :currentPage="pagination.pageNum"
          :pageSize="pagination.pageSize"
          :total="pagination.total"
          :marginTop="10"
          row-key="dictId"
          @selection-change="handleSelectionChange"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>
      </ElCard>
    </div>

    <!-- 添加/编辑字典弹窗 -->
    <DictForm
      v-model="dialogVisible"
      v-model:type="dialogType"
      v-model:data="formData"
      @refresh="handleRefresh"
    />

    <!-- 字典数据列表弹窗 -->
    <DictDataList
      v-model="permissionDialogVisible"
      v-model:dictType="currentType"
      v-model:details="dataDetails"
      @refresh="handleDetailRefresh"
    />
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import DictForm from './components/DictForm.vue'
import DictDataList from './components/DictDataList.vue'
import { useSettingStore } from '@/store/modules/setting'

// 使用设置 Store 获取过渡效果配置
const settingStore = useSettingStore()

// 导入composables
import { useDictionaryData } from './composables/useDictionaryData'
import { useDictionaryColumns } from './composables/useDictionaryColumns'
import { useDictionarySearch } from './composables/useDictionarySearch'
import { useDictDataList } from './composables/useDictDataList'

// 使用字典数据composable
const {
  loading,
  tableData,
  selectedRows,
  dialogVisible,
  dialogType,
  formData,
  pagination,
  permissionDialogVisible,
  currentType,
  dataDetails,
  getTableData,
  handleCurrentChange,
  handleSizeChange,
  handleSelectionChange,
  handleRefresh,
  handleAddDictionary,
  handleEditDictionary,
  handleDetailDictionary,
  handleDeleteDictionary,
  handleBatchDelete,
  setQueryParams
} = useDictionaryData()

// 使用字典数据列表composable
const { dictDataList, getDictData } = useDictDataList()

// 计算属性：是否显示恢复按钮
const showRecoverButton = computed(() => selectedRows.value.length > 0)

// 统一的操作方法
const handleOperation = async (type: string, row?: any) => {
  switch (type) {
    case 'detail':
      // 先设置当前字典类型，再打开对话框
      currentType.value = row.dictType

      // 获取字典数据
      await getDictData(row.dictType)
      dataDetails.value = dictDataList.value

      // 最后打开对话框
      handleDetailDictionary(row)
      break
    case 'add':
      handleAddDictionary()
      break
    case 'edit':
      handleEditDictionary(row)
      break
    case 'delete':
      handleDeleteDictionary(row)
      break
    default:
      break
  }
}

// 使用字典表格列配置
const { columnChecks, columns } = useDictionaryColumns(handleOperation)

// 使用字典搜索配置
const { formFilters, formItems, handleReset, handleSearch } = useDictionarySearch()

// 重写搜索处理函数
const handleSearchWrapper = () => {
  handleSearch(setQueryParams)
}

// 刷新字典明细数据
const handleDetailRefresh = async (searchParams?: any) => {
  if (currentType.value) {
    // 重新加载当前字典类型的明细数据，并传入搜索参数
    await getDictData(currentType.value, searchParams)
    dataDetails.value = dictDataList.value
  }
}

onMounted(() => {
  getTableData()
})
</script>

<style lang="scss" scoped>
// 可以添加特定于字典页面的样式
// .dictionary-page {}
</style>
