// 字典明细数据接口
export interface DictionaryDetailItem {
  dictCode: number
  dictSort: number
  dictLabel: string
  dictValue: string
  dictType: string
  cssClass?: string
  listClass?: string
  isDefault?: string
  status: string | number
  createBy?: string
  createTime?: string
  updateBy?: string
  updateTime?: string
  remark?: string
  default?: boolean
}

// 导入删除字典数据的API
import { deleteDictData } from '@/api/dictionary'
import { ApiStatus } from '@/utils/http/status'

// 修改函数签名，添加emit参数
export function useDictDataOperations(dictTypeRef: Ref<string>, emit?: (event: 'refresh') => void) {
  // 监听dictTypeRef值的变化
  const dictType = computed(() => dictTypeRef.value)

  // 响应式状态
  const selectedRows = ref<DictionaryDetailItem[]>([])
  const dictDetails = ref<DictionaryDetailItem[]>([])

  // 对话框状态
  const dialogType = ref('add')
  const dialogDetailsVisible = ref(false)

  // 表单数据
  const detailFormData = ref<{
    dictCode?: number
    dictSort: number
    dictLabel: string
    dictValue: string
    dictType: string
    status: string | number
    remark: string
  }>({
    dictType: dictType.value,
    dictLabel: '',
    dictValue: '',
    dictSort: 0,
    status: 1,
    remark: ''
  })

  // 监听dictType变化，同步更新detailFormData中的dictType
  watch(dictType, (newValue) => {
    detailFormData.value.dictType = newValue
  })

  // 处理选择变更
  const handleSelectionChange = (selection: DictionaryDetailItem[]) => {
    console.log('选中的行数:', selection.length, '选中的行数据:', selection)
    // 确保每次都是新数组，避免引用问题
    selectedRows.value = [...selection]
  }

  // 处理添加字典数据
  const handleAddDictData = () => {
    dialogType.value = 'add'
    dialogDetailsVisible.value = true

    detailFormData.value.dictCode = undefined
    detailFormData.value.dictType = dictType.value // 使用响应式引用的值
    detailFormData.value.dictLabel = ''
    detailFormData.value.dictValue = ''
    detailFormData.value.dictSort = 0
    detailFormData.value.status = 0
    detailFormData.value.remark = ''
  }

  // 处理编辑字典数据
  const handleEditDictData = (row: DictionaryDetailItem) => {
    dialogType.value = 'edit'
    dialogDetailsVisible.value = true

    detailFormData.value.dictCode = row.dictCode
    detailFormData.value.dictType = dictType.value // 使用响应式引用的值
    detailFormData.value.dictLabel = row.dictLabel
    detailFormData.value.dictValue = row.dictValue
    detailFormData.value.dictSort = row.dictSort
    detailFormData.value.status = row.status
    detailFormData.value.remark = row.remark || ''
  }

  // 刷新字典数据列表
  const refreshDictDataList = () => {
    // 清空选中行
    selectedRows.value = []

    // 触发父组件的刷新方法
    if (emit) {
      emit('refresh')
    }
  }

  // 删除单个字典数据
  const handleDeleteDictData = async (row: DictionaryDetailItem) => {
    ElMessageBox.confirm('确定要删除该字典数据吗？', '删除字典数据', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(async () => {
        try {
          // 调用API删除字典数据
          const dictCode = row.dictCode.toString()

          const res: any = await deleteDictData(dictCode)

          if (res.code === ApiStatus.success) {
            ElMessage.success('删除成功')
            // 删除成功后刷新数据列表
            refreshDictDataList()
          } else {
            ElMessage.error(res.msg || '删除失败')
          }
        } catch (error) {
          console.error('删除字典数据出错:', error)
          ElMessage.error('删除字典数据出错')
        }
      })
      .catch(() => {
        // 取消操作
        console.log('用户取消删除')
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
      .then(async () => {
        try {
          // 获取所有选中行的dictCode，并用逗号拼接
          const dictCodes = selectedRows.value.map((item) => item.dictCode).join(',')

          // 调用API批量删除
          const res: any = await deleteDictData(dictCodes)

          if (res.code === ApiStatus.success) {
            ElMessage.success(`已删除 ${selectedRows.value.length} 条数据`)
            // 删除成功后刷新数据列表
            refreshDictDataList()
          } else {
            ElMessage.error(res.msg || '批量删除失败')
          }
        } catch (error) {
          console.error('批量删除字典数据出错:', error)
          ElMessage.error('批量删除字典数据出错')
        }
      })
      .catch(() => {
        // 取消操作
        console.log('用户取消批量删除')
      })
  }

  return {
    selectedRows,
    dictDetails,
    dialogType,
    dialogDetailsVisible,
    detailFormData,
    handleSelectionChange,
    handleAddDictData,
    handleEditDictData,
    handleDeleteDictData,
    handleBatchDelete
  }
}
