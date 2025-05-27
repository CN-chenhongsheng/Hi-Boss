<template>
  <ArtTableFullScreen>
    <div class="account-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton @click="handleOperation('add')" v-ripple>新增用户</ElButton>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          :loading="loading"
          :data="tableData"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 使用用户表单组件 -->
        <UserForm
          v-model="dialogVisible"
          v-model:type="dialogType"
          v-model:data="formData"
          @refresh="handleRefresh"
        />
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { useUserData } from './composables/useUserData'
import { useUserSearch } from './composables/useUserSearch'
import { useUserColumns } from './composables/useUserColumns'
import UserForm from './components/UserForm.vue'

// 使用用户数据管理composable
const {
  loading,
  dialogType,
  dialogVisible,
  tableData,
  formData,
  getTableData,
  handleOperation
} = useUserData()

// 使用用户搜索composable
const { formFilters, formItems, handleSearch, handleReset } = useUserSearch(getTableData)

// 使用用户表格列配置composable
const { columnChecks, columns } = useUserColumns(handleOperation)

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
.account-page {
  :deep(.user) {
    .avatar {
      width: 40px;
      height: 40px;
      border-radius: 6px;
    }

    > div {
      margin-left: 10px;

      .user-name {
        font-weight: 500;
        color: var(--art-text-gray-800);
      }
    }
  }
}
</style>
