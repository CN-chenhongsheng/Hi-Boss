import type { SearchFormItem, SearchChangeParams } from '@/types/search-form'

// 定义表单搜索初始值
const initialSearchState = {
  username: '',
  account: '',
  operationType: '',
  startTime: '',
  endTime: ''
}

export function useLogSearch() {
  // 响应式表单数据
  const formFilters = reactive({ ...initialSearchState })

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
  }

  // 搜索处理
  const handleSearch = (callback: () => void) => {
    console.log('搜索参数:', formFilters)
    callback()
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '用户名',
      prop: 'username',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入用户名'
      },
      onChange: handleFormChange
    },
    {
      label: '账号',
      prop: 'account',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入账号'
      },
      onChange: handleFormChange
    },
    {
      label: '类型',
      prop: 'operationType',
      type: 'select',
      options: [
        { label: '全部', value: '' },
        { label: '登录', value: 'login' },
        { label: '查询', value: 'query' },
        { label: '新增', value: 'add' },
        { label: '修改', value: 'update' },
        { label: '删除', value: 'delete' },
        { label: '导出', value: 'export' },
        { label: '导入', value: 'import' }
      ],
      config: {
        clearable: true,
        placeholder: '请选择操作类型'
      },
      onChange: handleFormChange
    },
    {
      label: '开始时间',
      prop: 'startTime',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入开始时间'
      },
      onChange: handleFormChange
    },
    {
      label: '结束时间',
      prop: 'endTime',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入结束时间'
      },
      onChange: handleFormChange
    }
  ]

  return {
    formFilters,
    formItems,
    handleReset,
    handleSearch
  }
}
