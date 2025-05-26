<template>
  <ArtDialog v-model="dialogVisible" title="字典数据列表" width="70%" :open="handleOpen">
    <ElCard shadow="never" class="art-table-card">
      <!-- 表格头部 -->
      <ArtTableHeader
        v-model:columns="detailColumnChecks"
        :fullScreen="false"
        @refresh="handleDetailRefresh"
      >
        <template #left>
          <ElButton @click="addDictDetail" v-ripple>新增数据</ElButton>
        </template>
      </ArtTableHeader>

      <!-- 字典明细表格 -->
      <ArtTable
        :data="dictDetails"
        :currentPage="1"
        :pageSize="20"
        :total="500"
        style="width: 100%"
      >
        <template #default>
          <ElTableColumn
            v-for="detailCol in detailColumns"
            :key="detailCol.prop || detailCol.type"
            v-bind="detailCol"
          />
        </template>
      </ArtTable>
    </ElCard>
  </ArtDialog>

  <!-- 字典明细对话框 -->
  <DictDetail
    v-model="detailDialogVisible"
    v-model:type="detailDialogType"
    v-model:data="detailFormData"
    @refresh="handleDetailRefresh"
  />
</template>

<script setup lang="ts">
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import DictDetail from './DictDetail.vue'
import { ref, reactive, h } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// 字典明细数据接口
interface DictionaryDetailItem {
  id: number
  dictType: string
  code: string
  name: string
  status: number
  createTime: string
  remark: string
}

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const currentDictType = defineModel<string>('dictType', { required: true })

// 导出DICTIONARY_DETAIL_DATA引用，便于外部调用
const dictDetails = defineModel<DictionaryDetailItem[]>('details', { required: true })

// 字典明细对话框相关变量
const detailDialogType = ref('add')
const detailDialogVisible = ref(false)

// 字典明细表单数据
const detailFormData = reactive<{
  id?: number
  dictType: string
  code: string
  name: string
  status: number
  remark: string
}>({
  dictType: '',
  code: '',
  name: '',
  status: 1,
  remark: ''
})

// 添加字典明细
const addDictDetail = () => {
  detailDialogType.value = 'add'
  detailDialogVisible.value = true

  // 初始化表单数据
  detailFormData.dictType = currentDictType.value
  detailFormData.code = ''
  detailFormData.name = ''
  detailFormData.status = 1
  detailFormData.remark = ''
}

// 编辑字典明细
const editDictDetail = (row: DictionaryDetailItem) => {
  detailDialogType.value = 'edit'
  detailDialogVisible.value = true

  // 填充表单数据
  detailFormData.id = row.id
  detailFormData.dictType = row.dictType
  detailFormData.code = row.code
  detailFormData.name = row.name
  detailFormData.status = row.status
  detailFormData.remark = row.remark
}

// 删除字典明细
const deleteDictDetail = (row: DictionaryDetailItem) => {
  ElMessageBox.confirm('确定要删除该字典数据吗？', '删除字典数据', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'error'
  }).then(() => {
    // 模拟删除操作，实际项目中应该调用API
    const index = dictDetails.value.findIndex((item) => item.id === row.id)
    if (index !== -1) {
      dictDetails.value.splice(index, 1)
      ElMessage.success('删除成功')
    }
  })
}

// 动态子列配置
const { columnChecks: detailColumnChecks, columns: detailColumns } = useCheckedColumns(() => [
  { type: 'selection', width: 55 },
  { type: 'index', label: '序号', width: 80 },
  { prop: 'code', label: '字典编码', width: 150 },
  { prop: 'name', label: '字典名称', width: 150 },
  {
    prop: 'status',
    label: '状态',
    width: 100,
    formatter: (row: any) => {
      return h(ArtStatusSwitch, {
        modelValue: row.status
      })
    }
  },
  { prop: 'createTime', label: '创建时间', sortable: true, width: 180 },
  { prop: 'remark', label: '备注' },
  {
    prop: 'operation',
    label: '操作',
    width: 150,
    formatter: (row: any) => {
      return h('div', { class: 'operation-btns' }, [
        h(ArtButtonTable, {
          type: 'edit',
          onClick: () => editDictDetail(row)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          onClick: () => deleteDictDetail(row)
        })
      ])
    }
  }
])

// 刷新字典明细
const handleDetailRefresh = () => {
  emit('refresh')
}

const handleOpen = () => {
  console.log('字典数据列表对话框打开')
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
