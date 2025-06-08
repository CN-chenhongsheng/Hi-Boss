import { RecycleItem } from '../components/RecycleDetail.vue'

export function useRecycleData() {
  // 响应式状态
  const loading = ref(false)
  const tableData = ref<RecycleItem[]>([])
  const currentPage = ref(1)
  const pageSize = ref(10)
  const total = ref(0)
  const selectedRows = ref<RecycleItem[]>([])

  // 加载数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
      tableData.value = generateMockData()
      total.value = tableData.value.length
      loading.value = false
    }, 500)
  }

  // 处理选择变更
  const handleSelectionChange = (selection: RecycleItem[]) => {
    selectedRows.value = selection
  }

  // 处理刷新
  const handleRefresh = () => {
    getTableData()
  }

  // 恢复单条数据
  const recoverItem = (item: RecycleItem) => {
    console.log(item)
    ElMessageBox.confirm('确定要恢复该数据吗？', '恢复确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'success'
    })
      .then(() => {
        ElMessage.success('数据已恢复')
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 批量恢复数据
  const recoverSelectedItems = () => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请先选择要恢复的数据')
      return
    }

    ElMessageBox.confirm(
      `确定要恢复选中的 ${selectedRows.value.length} 条数据吗？`,
      '批量恢复确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'success'
      }
    )
      .then(() => {
        ElMessage.success(`已恢复 ${selectedRows.value.length} 条数据`)
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 删除单条数据
  const deleteItem = (item: RecycleItem) => {
    console.log(item)
    ElMessageBox.confirm('确定要彻底删除该数据吗？此操作将永久无法恢复！', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(() => {
        ElMessage.success('数据已彻底删除')
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 清空回收站
  const clearRecycle = () => {
    ElMessageBox.confirm('确定要清空回收站吗？此操作将永久无法恢复！', '清空回收站', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(() => {
        ElMessage.success('回收站已清空')
        getTableData()
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 模拟数据
  const generateMockData = (): RecycleItem[] => {
    const apis = [
      '/api/user/delete',
      '/api/product/delete',
      '/api/order/delete',
      '/api/category/delete',
      '/api/setting/delete'
    ]

    const operators = ['张三', '李四', '王五', '赵六', '钱七']

    const data = []
    for (let i = 1; i <= 20; i++) {
      const isArray = Math.random() > 0.5
      const deletedCount = Math.floor(Math.random() * 10) + 1

      let deletedData
      if (isArray) {
        deletedData = Array.from({ length: deletedCount }, (_, idx) => ({
          id: 1000 + idx,
          name: `数据项${idx + 1}`,
          status: Math.random() > 0.5 ? 1 : 0
        }))
      } else {
        deletedData = {
          id: 1000 + i,
          name: `数据项${i}`,
          status: Math.random() > 0.5 ? 1 : 0,
          createTime: new Date().toISOString()
        }
      }

      const params = {
        id: isArray ? Array.from({ length: deletedCount }, (_, idx) => 1000 + idx) : 1000 + i,
        force: Math.random() > 0.7
      }

      data.push({
        id: i,
        operator: operators[Math.floor(Math.random() * operators.length)],
        deletedData,
        api: apis[Math.floor(Math.random() * apis.length)],
        params,
        deleteCount: isArray ? deletedCount : 1,
        operateTime: new Date(
          Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000
        ).toLocaleString()
      })
    }

    return data
  }

  return {
    loading,
    tableData,
    currentPage,
    pageSize,
    total,
    selectedRows,
    getTableData,
    handleSelectionChange,
    handleRefresh,
    recoverItem,
    recoverSelectedItems,
    deleteItem,
    clearRecycle
  }
}
