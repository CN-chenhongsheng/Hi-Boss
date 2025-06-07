<template>
  <ArtTableFullScreen>
    <div class="menu-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader :showZebra="false" v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton v-auth="'add'" @click="handleOperation('menu')" v-ripple>添加菜单</ElButton>
            <ElButton @click="toggleExpand" v-ripple>{{ isExpanded ? '收起' : '展开' }}</ElButton>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="filteredTableData"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 菜单表单 -->
        <MenuForm
          v-model="dialogVisible"
          v-model:form="form"
          v-model:labelPosition="labelPosition"
          v-model:isEdit="isEdit"
          v-model:lockMenuType="lockMenuType"
        />
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { useMenuData } from './composables/useMenuData'
import { useMenuSearch } from './composables/useMenuSearch'
import { useMenuColumns } from './composables/useMenuColumns'
import MenuForm from './components/MenuForm.vue'

// 使用菜单数据处理composable
const {
  loading,
  tableData,
  tableRef,
  isExpanded,
  form,
  dialogVisible,
  labelPosition,
  isEdit,
  lockMenuType,
  getTableData,
  toggleExpand,
  handleOperation
} = useMenuData()

// 使用菜单搜索composable
const { formFilters, formItems, filteredTableData, handleSearch, handleReset } = useMenuSearch(
  tableData,
  getTableData
)

// 使用菜单列配置composable
const { columnChecks, columns } = useMenuColumns(handleOperation)

// 初始加载
onMounted(() => {
  getTableData()
})

// 处理刷新
const handleRefresh = () => {
  getTableData()
}
</script>

<style lang="scss" scoped>
.menu-page {
  .svg-icon {
    width: 1.8em;
    height: 1.8em;
    overflow: hidden;
    vertical-align: -8px;
    fill: currentcolor;
  }

  :deep(.small-btn) {
    height: 30px !important;
    padding: 0 10px !important;
    font-size: 12px !important;
  }
}
</style>
