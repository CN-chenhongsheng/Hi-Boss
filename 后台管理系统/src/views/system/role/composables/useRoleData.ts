export function useRoleData() {
  const loading = ref(false)
  const dialogVisible = ref(false)
  const permissionDialogVisible = ref(false)
  const dialogType = ref('add')

  // 表单数据
  const form = reactive({
    id: '',
    name: '',
    des: '',
    status: 1
  })

  // 表格数据
  const tableData = reactive([
    {
      name: '超级管理员',
      allow: '全部权限',
      des: '拥有系统全部权限',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '董事会部',
      allow: '自定义',
      des: '负责董事会部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '监事会部',
      allow: '自定义',
      des: '负责监事会部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 0
    },
    {
      name: '市场部',
      allow: '自定义',
      des: '负责市场部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '人力资源部',
      allow: '自定义',
      des: '负责人力资源部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '财务部',
      allow: '自定义',
      des: '负责财务部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '公关部',
      allow: '自定义',
      des: '负责公关部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 0
    },
    {
      name: '广告部',
      allow: '自定义',
      des: '负责广告部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '营销',
      allow: '自定义',
      des: '负责营销相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '设计部',
      allow: '自定义',
      des: '负责设计部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '开发部',
      allow: '自定义',
      des: '负责开发部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '测试部',
      allow: '自定义',
      des: '负责测试部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    },
    {
      name: '安保部',
      allow: '自定义',
      des: '负责安保部相关工作的管理者',
      date: '2021-01-08 12:30:45',
      status: 1
    }
  ])

  // 获取表格数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
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
          form.id = row.id
          form.name = row.name
          form.des = row.des
          form.status = row.status
        } else {
          form.id = ''
          form.name = ''
          form.des = ''
          form.status = 1
        }
        break
      case 'detail':
        permissionDialogVisible.value = true
        break
      case 'delete':
        ElMessageBox.confirm('确定删除该角色吗？', '删除确认', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'error'
        }).then(() => {
          ElMessage.success('删除成功')
          getTableData()
        })
        break
      default:
        break
    }
  }

  return {
    loading,
    dialogVisible,
    permissionDialogVisible,
    dialogType,
    form,
    tableData,
    getTableData,
    handleOperation
  }
} 