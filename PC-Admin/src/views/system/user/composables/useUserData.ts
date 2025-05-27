import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ACCOUNT_TABLE_DATA } from '@/mock/temp/formData'

export function useUserData() {
  const loading = ref(false)
  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const tableData = ref<any[]>([])

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
    getTableData,
    handleOperation
  }
} 