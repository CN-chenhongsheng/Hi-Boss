<template>
  <ArtTableFullScreen>
    <div class="recycle-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      />

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton @click="handleOperation('clearAll')" v-ripple>彻底删除</ElButton>
            <transition :name="settingStore.pageTransition">
              <ElButton
                v-show="showRecoverButton"
                @click="handleOperation('recoverSelected')"
                v-ripple
              >
                恢复数据 ({{ selectedRows.length }})
              </ElButton>
            </transition>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="tableData"
          :currentPage="currentPage"
          :pageSize="pageSize"
          :total="total"
          @selection-change="handleSelectionChange"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>
      </ElCard>
    </div>

    <!-- 数据详情抽屉 -->
    <RecycleDetail v-model="drawerVisible" :data="currentRecord" />
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRecycleData } from './composables/useRecycleData'
import { useRecycleColumns } from './composables/useRecycleColumns'
import { useRecycleSearch } from './composables/useRecycleSearch'
import RecycleDetail from './components/RecycleDetail.vue'
import { RecycleItem } from './components/RecycleDetail.vue'
import { useSettingStore } from '@/store/modules/setting'

// 使用设置 Store 获取过渡效果配置
const settingStore = useSettingStore()

// 记录当前选中的数据
const currentRecord = ref<RecycleItem | null>(null)
const drawerVisible = ref(false)

// 使用数据处理Composable
const {
  loading,
  tableData,
  currentPage,
  pageSize,
  total,
  selectedRows,
  getTableData,
  handleSelectionChange,
  handleRefresh,
  recoverItem,
  recoverSelectedItems,
  deleteItem,
  clearRecycle
} = useRecycleData()

// 计算属性：是否显示恢复按钮
const showRecoverButton = computed(() => selectedRows.value.length > 0)

// 使用搜索Composable
const { formFilters, formItems, handleSearch, handleReset } = useRecycleSearch(() => {
  getTableData()
})

// 处理数据详情查看
const handleViewDetail = (row: RecycleItem) => {
  currentRecord.value = row
  drawerVisible.value = true
}

// 使用表格列配置Composable
const { columnChecks, columns } = useRecycleColumns(
  handleViewDetail, // 查看详情
  recoverItem, // 恢复数据
  deleteItem // 删除数据
)

// 统一操作方法
const handleOperation = (type: string) => {
  switch (type) {
    case 'recoverSelected':
      recoverSelectedItems()
      break
    case 'clearAll':
      clearRecycle()
      break
  }
}

// 初始加载
onMounted(() => {
  getTableData()
})
</script>

<style lang="scss" scoped>
.recycle-page {
  // 页面特定样式可以保留在这里
}

/* 确保按钮过渡效果样式与系统一致 */
.el-button {
  transition: all 0.3s;
}
</style>
