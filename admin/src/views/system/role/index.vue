<template>
  <ArtTableFullScreen>
    <div class="role-page" id="table-full-screen">
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
            <ElButton @click="handleOperation('add')" v-ripple>新增角色</ElButton>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          :data="tableData"
          :loading="loading"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 角色表单对话框 -->
        <RoleForm
          v-model="dialogVisible"
          v-model:type="dialogType"
          v-model:form="form"
          @refresh="handleRefresh"
        />

        <!-- 权限设置对话框 -->
        <RolePermission
          v-model="permissionDialogVisible"
          :menuData="menuList"
          @refresh="handleRefresh"
        />
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { useMenuStore } from '@/store/modules/menu'
import { useRoleData } from './composables/useRoleData'
import { useRoleSearch } from './composables/useRoleSearch'
import { useRoleColumns } from './composables/useRoleColumns'
import RoleForm from './components/RoleForm.vue'
import RolePermission from './components/RolePermission.vue'

const { menuList } = storeToRefs(useMenuStore())

// 使用角色数据管理composable
const {
  loading,
  dialogVisible,
  permissionDialogVisible,
  dialogType,
  form,
  tableData,
  getTableData,
  handleOperation
} = useRoleData()

// 使用角色搜索composable
const { formFilters, formItems, handleSearch, handleReset } = useRoleSearch(getTableData)

// 使用角色表格列配置composable
const { columnChecks, columns } = useRoleColumns(handleOperation)

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
.role-page {
  .svg-icon {
    width: 1.8em;
    height: 1.8em;
    overflow: hidden;
    vertical-align: -8px;
    fill: currentcolor;
  }
}
</style>
