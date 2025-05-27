import { SearchFormItem, SearchChangeParams } from '@/types/search-form'

export function useRecycleSearch(onSearch: () => void) {
  // 定义表单搜索初始值
  const initialSearchState = {
    operator: '',
    api: '',
    startTime: '',
    endTime: ''
  }

  // 响应式表单数据
  const formFilters = reactive({ ...initialSearchState })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    onSearch()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    onSearch()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '操作人',
      prop: 'operator',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入操作人'
      },
      onChange: handleFormChange
    },
    {
      label: '请求接口',
      prop: 'api',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入接口地址'
      },
      onChange: handleFormChange
    },
    {
      label: '开始时间',
      prop: 'startTime',
      type: 'datePicker',
      config: {
        type: 'datetime',
        clearable: true,
        placeholder: '请选择开始时间'
      },
      onChange: handleFormChange
    },
    {
      label: '结束时间',
      prop: 'endTime',
      type: 'datePicker',
      config: {
        type: 'datetime',
        clearable: true,
        placeholder: '请选择结束时间'
      },
      onChange: handleFormChange
    }
  ]

  return {
    formFilters,
    formItems,
    handleSearch,
    handleReset
  }
}
