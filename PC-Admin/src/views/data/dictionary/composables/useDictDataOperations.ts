import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// 字典明细数据接口
export interface DictionaryDetailItem {
  id: number
  dictType: string
  code: string
  name: string
  status: number
  createTime: string
  remark: string
}

export function useDictDataOperations(dictType: string) {
  // 响应式状态
  const selectedRows = ref<DictionaryDetailItem[]>([])
  const dictDetails = ref<DictionaryDetailItem[]>([])

  // 对话框状态
  const dialogType = ref('add')
  const dialogDetailsVisible = ref(false)

  // 表单数据
  const detailFormData = ref<{
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

  // 处理选择变更
  const handleSelectionChange = (selection: DictionaryDetailItem[]) => {
    selectedRows.value = selection
  }

  // 处理编辑字典数据
  const handleEditDictData = (type: string, row?: DictionaryDetailItem) => {
    dialogType.value = type
    dialogDetailsVisible.value = true

    if (type === 'edit' && row) {
      detailFormData.value.id = row.id
      detailFormData.value.dictType = dictType
      detailFormData.value.code = row.code
      detailFormData.value.name = row.name
      detailFormData.value.status = row.status
      detailFormData.value.remark = row.remark
    } else {
      detailFormData.value.dictType = dictType
      detailFormData.value.code = ''
      detailFormData.value.name = ''
      detailFormData.value.status = 1
      detailFormData.value.remark = ''
    }
  }

  // 删除单个字典数据
  const handleDeleteDictData = (row: DictionaryDetailItem) => {
    ElMessageBox.confirm('确定要删除该字典数据吗？', '删除字典数据', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(() => {
        // 模拟删除操作，实际项目中应该调用API
        const index = dictDetails.value.findIndex((item) => item.id === row.id)
        if (index !== -1) {
          dictDetails.value.splice(index, 1)
          ElMessage.success('删除成功')
        }
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 批量删除字典数据
  const handleBatchDelete = () => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请先选择要删除的数据')
      return
    }

    ElMessageBox.confirm(
      `确定要删除选中的 ${selectedRows.value.length} 条数据吗？`,
      '批量删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
      .then(() => {
        // 模拟批量删除
        const ids = selectedRows.value.map((item) => item.id)
        dictDetails.value = dictDetails.value.filter((item) => !ids.includes(item.id))
        ElMessage.success(`已删除 ${selectedRows.value.length} 条数据`)
        selectedRows.value = []
      })
      .catch(() => {
        // 取消操作
      })
  }

  return {
    selectedRows,
    dictDetails,
    dialogType,
    dialogDetailsVisible,
    detailFormData,
    handleSelectionChange,
    handleEditDictData,
    handleDeleteDictData,
    handleBatchDelete
  }
}
