import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ACCOUNT_TABLE_DATA } from '@/mock/temp/formData'

export function useUserData() {
  const loading = ref(false)
  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const tableData = ref<any[]>([])
  // 添加选中行数据数组
  const selectedRows = ref<any[]>([])

  // 表单数据
  const formData = reactive({
    username: '',
    phone: '',
    sex: '',
    dep: ''
  })

  // 获取表格数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
      tableData.value = ACCOUNT_TABLE_DATA
      loading.value = false
    }, 500)
  }

  // 处理表格选择变更
  const handleSelectionChange = (rows: any[]) => {
    selectedRows.value = rows
  }

  // 处理批量删除
  const handleBatchDelete = () => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请至少选择一个用户')
      return
    }

    ElMessageBox.confirm(
      `确定要删除选中的 ${selectedRows.value.length} 个用户吗？`,
      '批量删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    ).then(() => {
      // 实际项目中这里会调用批量删除API
      ElMessage.success(`成功删除 ${selectedRows.value.length} 个用户`)
      // 重新加载数据
      getTableData()
      // 清空选中
      selectedRows.value = []
    })
  }

  // 统一操作方法
  const handleOperation = (type: string, row?: any) => {
    switch (type) {
      case 'add':
      case 'edit':
        dialogVisible.value = true
        dialogType.value = type

        if (type === 'edit' && row) {
          formData.username = row.username
          formData.phone = row.mobile
          formData.sex = row.sex === 1 ? '男' : '女'
          formData.dep = row.dep
        } else {
          formData.username = ''
          formData.phone = ''
          formData.sex = '男'
          formData.dep = ''
        }
        break
      case 'delete':
        ElMessageBox.confirm('确定要注销该用户吗？', '注销用户', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'error'
        }).then(() => {
          ElMessage.success('注销成功')
        })
        break
      default:
        break
    }
  }

  return {
    loading,
    dialogType,
    dialogVisible,
    tableData,
    formData,
    selectedRows,
    getTableData,
    handleOperation,
    handleSelectionChange,
    handleBatchDelete
  }
} 