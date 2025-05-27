<template>
  <ArtDialog v-model="dialogVisible" title="字典数据列表" width="70%" :open="handleOpen">
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
        :data="dictDetails"
        :currentPage="1"
        :pageSize="20"
        :total="500"
        style="width: 100%"
        @selection-change="handleSelectionChange"
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

// 使用设置 Store 获取过渡效果配置
const settingStore = useSettingStore()

// 导入composables
import { useDictDataOperations, DictionaryDetailItem } from '../composables/useDictDataOperations'
import { useDictDataColumns } from '../composables/useDictionaryColumns'

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const currentDictType = defineModel<string>('dictType', { required: true })

// 导出DICTIONARY_DETAIL_DATA引用，便于外部调用
const dictDetails = defineModel<DictionaryDetailItem[]>('details', { required: true })

// 使用字典数据操作composable
const {
  selectedRows,
  dialogType,
  dialogDetailsVisible,
  detailFormData,
  handleSelectionChange,
  handleEditDictData,
  handleDeleteDictData,
  handleBatchDelete
} = useDictDataOperations(currentDictType.value)

// 计算属性：是否显示批量删除按钮
const showRecoverButton = computed(() => selectedRows.value.length > 0)

// 显示对话框
const handleOperation = (type: string, row?: any) => {
  switch (type) {
    case 'add':
    case 'edit':
      handleEditDictData(type, row)
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

// 刷新字典明细
const handleRefresh = () => {
  emit('refresh')
}

const handleOpen = () => {
  console.log('字典数据列表对话框打开')
  console.log(dictDetails.value)
}

const emit = defineEmits(['refresh'])
</script>

<style scoped>
.operation-btns {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
</style>
