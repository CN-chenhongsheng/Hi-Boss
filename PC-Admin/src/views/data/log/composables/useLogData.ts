// 日志项接口定义
export interface LogItem {
  username: string
  account: string
  operationType: string
  content: string
  result: string
  ip: string
  browser: string
  status: string
  create_time: string
}

// 模拟日志数据
const mockLogData: LogItem[] = [
  {
    username: '中小鱼',
    account: 'admin',
    operationType: '登录',
    content: '用户登录系统',
    result: '成功',
    ip: '143.133.312.563',
    browser: 'Chrome',
    status: '125ms',
    create_time: '2023-05-14 08:25:36'
  },
  {
    username: '何小荷',
    account: 'hexiaohe',
    operationType: '查询',
    content: '查询用户列表',
    result: '成功',
    ip: '131.133.313.424',
    browser: 'Firefox',
    status: '98ms',
    create_time: '2023-05-14 09:12:45'
  },
  {
    username: '誶誶淰',
    account: 'yuanmou',
    operationType: '新增',
    content: '新增部门"市场部"',
    result: '成功',
    ip: '127.133.313.132',
    browser: 'Chrome',
    status: '145ms',
    create_time: '2023-05-14 10:35:12'
  },
  {
    username: '发呆草',
    account: 'fadaicao',
    operationType: '修改',
    content: '修改用户"张三"的权限',
    result: '成功',
    ip: '143.133.313.456',
    browser: 'Edge',
    status: '112ms',
    create_time: '2023-05-14 11:42:23'
  },
  {
    username: '甜筒',
    account: 'tiantong',
    operationType: '删除',
    content: '删除角色"临时用户"',
    result: '失败',
    ip: '127.133.567.675',
    browser: 'Chrome',
    status: '87ms',
    create_time: '2023-05-14 13:15:49'
  },
  {
    username: '冷月呆呆',
    account: 'lengyue',
    operationType: '导出',
    content: '导出用户数据',
    result: '成功',
    ip: '127.133.145.545',
    browser: 'Safari',
    status: '235ms',
    create_time: '2023-05-14 14:22:18'
  },
  {
    username: '唐不苦',
    account: 'tangbuku',
    operationType: '导入',
    content: '导入部门数据',
    result: '成功',
    ip: '156.133.313.756',
    browser: 'Chrome',
    status: '198ms',
    create_time: '2023-05-14 15:36:42'
  },
  {
    username: '笑很甜',
    account: 'xiaohengtian',
    operationType: '登录',
    content: '用户登录系统',
    result: '成功',
    ip: '131.133.234.424',
    browser: 'Firefox',
    status: '103ms',
    create_time: '2023-05-14 16:45:33'
  },
  {
    username: '青隐篱',
    account: 'qingyinli',
    operationType: '查询',
    content: '查询角色列表',
    result: '成功',
    ip: '167.133.355.534',
    browser: 'Chrome',
    status: '92ms',
    create_time: '2023-05-14 17:28:11'
  },
  {
    username: '有你一生',
    account: 'youni',
    operationType: '新增',
    content: '新增用户"李四"',
    result: '成功',
    ip: '234.133.545.533',
    browser: 'Edge',
    status: '156ms',
    create_time: '2023-05-15 08:56:24'
  },
  {
    username: '中小鱼',
    account: 'admin',
    operationType: '修改',
    content: '修改系统配置',
    result: '成功',
    ip: '245.567.313.890',
    browser: 'Chrome',
    status: '134ms',
    create_time: '2023-05-15 09:34:47'
  },
  {
    username: '何小荷',
    account: 'hexiaohe',
    operationType: '删除',
    content: '删除用户"王五"',
    result: '成功',
    ip: '235.789.313.345',
    browser: 'Firefox',
    status: '108ms',
    create_time: '2023-05-15 10:42:15'
  }
]

export function useLogData() {
  // 响应式状态
  const loading = ref(false)
  const tableData = ref<LogItem[]>([...mockLogData])
  const selectedRows = ref<LogItem[]>([])

  // 抽屉状态
  const drawerVisible = ref(false)
  const currentLog = ref<LogItem | null>(null)

  // 获取表格数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
      // 模拟API请求
      tableData.value = [...mockLogData]
      loading.value = false
    }, 500)
  }

  // 处理选择变更
  const handleSelectionChange = (selection: LogItem[]) => {
    selectedRows.value = selection
  }

  // 处理刷新
  const handleRefresh = () => {
    getTableData()
  }

  // 查看日志详情
  const handleViewDetail = (row: LogItem) => {
    currentLog.value = row
    drawerVisible.value = true
  }

  // 删除单个日志
  const handleDeleteLog = (row: LogItem) => {
    ElMessageBox.confirm('确定要删除该日志吗？', '删除日志', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(() => {
        // 模拟删除操作，实际项目中应该调用API
        const index = tableData.value.findIndex(
          (item) => item.account === row.account && item.create_time === row.create_time
        )

        if (index !== -1) {
          tableData.value.splice(index, 1)
          ElMessage.success('删除成功')
        }
      })
      .catch(() => {
        // 取消操作
      })
  }

  // 批量删除日志
  const handleBatchDelete = () => {
    if (selectedRows.value.length === 0) {
      ElMessage.warning('请先选择要删除的数据')
      return
    }

    ElMessageBox.confirm(
      `确定要删除选中的 ${selectedRows.value.length} 条日志吗？`,
      '批量删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
      .then(() => {
        // 模拟批量删除，在实际项目中应该调用API
        // 使用account和create_time的组合作为唯一标识
        const uniqueIds = selectedRows.value.map((item) => `${item.account}_${item.create_time}`)

        tableData.value = tableData.value.filter(
          (item) => !uniqueIds.includes(`${item.account}_${item.create_time}`)
        )

        ElMessage.success(`已删除 ${selectedRows.value.length} 条日志`)
        selectedRows.value = []
      })
      .catch(() => {
        // 取消操作
      })
  }

  return {
    loading,
    tableData,
    selectedRows,
    drawerVisible,
    currentLog,
    getTableData,
    handleSelectionChange,
    handleRefresh,
    handleViewDetail,
    handleDeleteLog,
    handleBatchDelete
  }
}
