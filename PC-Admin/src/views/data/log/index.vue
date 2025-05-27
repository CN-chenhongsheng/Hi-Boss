<template>
  <ArtTableFullScreen>
    <div class="log-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="() => handleSearch(getTableData)"
      />

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <transition :name="settingStore.pageTransition">
              <ElButton
                v-show="showDeleteButton"
                @click="handleBatchDelete"
                :disabled="!selectedRows.length"
                v-ripple
              >
                批量删除 ({{ selectedRows.length }})
              </ElButton>
            </transition>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="tableData"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
          @selection-change="handleSelectionChange"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>
      </ElCard>
    </div>

    <!-- 引入日志详情抽屉组件 -->
    <LogDetailDrawer v-model="drawerVisible" :data="currentLog" />
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import LogDetailDrawer from './components/LogDetailDrawer.vue'
import { useSettingStore } from '@/store/modules/setting'

// 使用设置Store获取过渡效果配置
const settingStore = useSettingStore()

// 导入composables
import { useLogData } from './composables/useLogData'
import { useLogColumns } from './composables/useLogColumns'
import { useLogSearch } from './composables/useLogSearch'

// 使用日志数据composable
const {
  loading,
  tableData,
  selectedRows,
  drawerVisible,
  currentLog,
  getTableData,
  handleSelectionChange,
  handleRefresh,
  handleViewDetail,
  handleDeleteLog,
  handleBatchDelete
} = useLogData()

// 计算属性：是否显示批量删除按钮
const showDeleteButton = computed(() => selectedRows.value.length > 0)

// 统一操作方法
const handleOperation = (type: string, row?: any) => {
  switch (type) {
    case 'detail':
      handleViewDetail(row)
      break
    case 'delete':
      handleDeleteLog(row)
      break
    default:
      break
  }
}

// 使用日志表格列配置
const { columnChecks, columns } = useLogColumns(handleOperation)

// 使用日志搜索配置
const { formFilters, formItems, handleReset, handleSearch } = useLogSearch()

// 引用表格
const tableRef = ref()
</script>

<style lang="scss" scoped>
// 可以添加特定于日志页面的样式
// .log-page {}
</style>
