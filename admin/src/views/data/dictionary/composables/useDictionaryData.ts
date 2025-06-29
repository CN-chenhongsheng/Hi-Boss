import { getDictTypeList, deleteDictType } from '@/api/dictionary'
import { DictTypeItem } from '@/api/dictionary/model'
import { ApiStatus } from '@/utils/http/status'

export function useDictionaryData() {
  // 响应式状态
  const loading = ref(false)
  const tableData = ref<DictTypeItem[]>([])
  const selectedRows = ref<DictTypeItem[]>([])

  // 分页参数
  const pagination = reactive({
    pageNum: 1,
    pageSize: 20,
    total: 0
  })

  // 查询参数
  const queryParams = reactive({
    dictName: '',
    dictType: '',
    status: ''
  })

  // 对话框状态
  const dialogVisible = ref(false)
  const dialogType = ref('add')

  // 表单数据
  const formData = ref<{
    dictId?: number
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

  // 获取表格数据
  const getTableData = async () => {
    loading.value = true
    try {
      const params = {
        ...queryParams,
        pageNum: pagination.pageNum,
        pageSize: pagination.pageSize
      }
      const res = await getDictTypeList(params)
      if (res.code !== ApiStatus.success) {
        ElMessage.error(res.msg || '获取字典数据失败')
        return
      }
      tableData.value = res.rows.map((item) => ({
        ...item,
        status: Number(item.status) // 确保status格式正确
      }))
      pagination.total = res.total
    } catch (error) {
      console.error('获取字典数据出错:', error)
      ElMessage.error('获取字典数据出错')
    } finally {
      loading.value = false
    }
  }

  // 处理页码变化
  const handleCurrentChange = (page: number) => {
    pagination.pageNum = page
    getTableData()
  }

  // 处理每页条数变化
  const handleSizeChange = (size: number) => {
    pagination.pageSize = size
    pagination.pageNum = 1
    getTableData()
  }

  // 处理选择变更
  const handleSelectionChange = (selection: DictTypeItem[]) => {
    selectedRows.value = [...selection]
  }

  // 处理刷新
  const handleRefresh = () => {
    pagination.pageNum = 1
    getTableData()
  }

  // 新增字典
  const handleAddDictionary = () => {
    dialogType.value = 'add'
    dialogVisible.value = true

    // 重置表单数据
    formData.value.dictId = undefined
    formData.value.dictName = ''
    formData.value.dictType = ''
    formData.value.status = 1
    formData.value.remark = ''
  }

  // 编辑字典
  const handleEditDictionary = (row: DictTypeItem) => {
    dialogType.value = 'edit'
    dialogVisible.value = true

    // 填充表单数据
    formData.value.dictId = row.dictId
    formData.value.dictName = row.dictName
    formData.value.dictType = row.dictType
    formData.value.status = Number(row.status)
    formData.value.remark = row.remark || ''
  }

  // 查看字典详情
  const handleDetailDictionary = async (row: DictTypeItem) => {
    permissionDialogVisible.value = true
    currentDict.dictName = row.dictName
    currentDict.dictType = row.dictType
    currentDict.status = Number(row.status)
    currentDict.remark = row.remark || ''
  }

  // 删除单个字典
  const handleDeleteDictionary = (row: DictTypeItem) => {
    ElMessageBox.confirm('确定要删除该字典吗？', '删除字典', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(async () => {
        try {
          const res: any = await deleteDictType(row.dictId.toString())
          if (res.code !== ApiStatus.success) {
            ElMessage.error(res.msg || '删除失败')
            return
          }
          ElMessage.success('删除成功')
          getTableData()
        } catch (error) {
          console.error('删除字典出错:', error)
          ElMessage.error('删除字典出错')
        }
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
      .then(async () => {
        try {
          const ids = selectedRows.value.map((item) => item.dictId)
          const res: any = await deleteDictType(ids.join(','))
          if (res.code !== ApiStatus.success) {
            ElMessage.error(res.msg || '批量删除失败')
            return
          }
          ElMessage.success(`已删除 ${selectedRows.value.length} 条数据`)
          getTableData()
        } catch (error) {
          console.error('批量删除出错:', error)
          ElMessage.error('批量删除出错')
        }
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 设置查询参数
  const setQueryParams = (params: any) => {
    Object.assign(queryParams, params)
    pagination.pageNum = 1
    getTableData()
  }

  return {
    loading,
    tableData,
    selectedRows,
    dialogVisible,
    dialogType,
    formData,
    pagination,
    permissionDialogVisible,
    currentType,
    currentDict,
    dataDetails,
    getTableData,
    handleCurrentChange,
    handleSizeChange,
    handleSelectionChange,
    handleRefresh,
    handleAddDictionary,
    handleEditDictionary,
    handleDetailDictionary,
    handleDeleteDictionary,
    handleBatchDelete,
    setQueryParams
  }
}
