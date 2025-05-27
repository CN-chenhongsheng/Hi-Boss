<template>
  <ArtTableFullScreen>
    <div class="dictionary-page" id="table-full-screen">
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
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
          row-key="dictType"
          @selection-change="handleSelectionChange"
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

// 使用字典数据composable
const {
  loading,
  tableData,
  selectedRows,
  dialogVisible,
  dialogType,
  formData,
  getTableData,
  handleSelectionChange,
  handleRefresh,
  handleEditDictionary,
  handleDeleteDictionary,
  handleBatchDelete
} = useDictionaryData()

// 计算属性：是否显示恢复按钮
const showRecoverButton = computed(() => selectedRows.value.length > 0)

// 权限弹窗相关变量
const permissionDialogVisible = ref(false)
const currentType = ref('')
const currentDict = reactive({
  dictName: '',
  dictType: '',
  status: 1,
  remark: ''
})

// 当前选中字典的明细数据
const dataDetails = ref<any[]>([])

// 统一的操作方法
const handleOperation = (type: string, row?: any) => {
  // 预先定义可能用到的变量
  let mockDetails = []

  switch (type) {
    case 'detail':
      // 查看权限（展示字典值）
      permissionDialogVisible.value = true
      currentType.value = row.dictType
      currentDict.dictName = row.dictName
      currentDict.dictType = row.dictType
      currentDict.status = row.status
      currentDict.remark = row.remark

      // 加载对应的字典明细数据 - 模拟数据
      // 实际项目中应从API获取字典明细数据
      mockDetails = [
        {
          id: 1,
          dictType: row.dictType,
          code: '0',
          name: '选项一',
          status: 1,
          createTime: '2023-07-15 14:35:00',
          remark: '备注信息1'
        },
        {
          id: 2,
          dictType: row.dictType,
          code: '1',
          name: '选项二',
          status: 1,
          createTime: '2023-07-15 14:36:00',
          remark: '备注信息2'
        },
        {
          id: 3,
          dictType: row.dictType,
          code: '2',
          name: '选项三',
          status: 0,
          createTime: '2023-07-15 14:37:00',
          remark: '备注信息3'
        }
      ]

      // 赋值给明细数据
      dataDetails.value = mockDetails
      break
    case 'add':
    case 'edit':
      handleEditDictionary(type, row)
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

// 刷新字典明细数据
const handleDetailRefresh = () => {
  if (currentType.value) {
    // 这里应该重新加载当前字典类型的明细数据
    console.log('刷新字典明细数据:', currentType.value)
  }
}

const tableRef = ref()

onMounted(() => {
  getTableData()
})
</script>

<style lang="scss" scoped>
// 可以添加特定于字典页面的样式
// .dictionary-page {}
</style>
