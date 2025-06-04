import { DICTIONARY_DATA, DictionaryItem } from '@/mock/temp/dictionaryData'

export function useDictionaryData() {
  // 响应式状态
  const loading = ref(false)
  const tableData = ref<DictionaryItem[]>([])
  const selectedRows = ref<DictionaryItem[]>([])

  // 对话框状态
  const dialogVisible = ref(false)
  const dialogType = ref('add')

  // 表单数据
  const formData = ref<{
    dictName: string
    dictType: string
    status: number
    remark: string
  }>({
    dictName: '',
    dictType: '',
    status: 1,
    remark: ''
  })

  // 获取表格数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
      // 使用从模拟数据文件中导入的数据并转换status字段类型
      tableData.value = DICTIONARY_DATA.map((item) => ({
        ...item,
        status: item.status // 确保status是数字类型
      }))
      loading.value = false
    }, 500)
  }

  // 处理选择变更
  const handleSelectionChange = (selection: DictionaryItem[]) => {
    selectedRows.value = selection
  }

  // 处理刷新
  const handleRefresh = () => {
    getTableData()
  }

  // 新增/编辑字典
  const handleEditDictionary = (type: string, row?: DictionaryItem) => {
    dialogType.value = type
    dialogVisible.value = true

    if (type === 'edit' && row) {
      formData.value.dictName = row.dictName
      formData.value.dictType = row.dictType
      formData.value.status = row.status
      formData.value.remark = row.remark
    } else {
      formData.value.dictName = ''
      formData.value.dictType = ''
      formData.value.status = 1
      formData.value.remark = ''
    }
  }

  // 删除单个字典
  const handleDeleteDictionary = (row?: DictionaryItem) => {
    console.log(row)
    ElMessageBox.confirm('确定要删除该字典吗？', '删除字典', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(() => {
        ElMessage.success('删除成功')
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 批量删除字典
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
        ElMessage.success(`已删除 ${selectedRows.value.length} 条数据`)
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  return {
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
  }
}
