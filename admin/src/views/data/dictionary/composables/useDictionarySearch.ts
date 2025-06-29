import type { SearchFormItem, SearchChangeParams } from '@/types'

// 定义表单搜索初始值
const initialSearchState = {
  dictName: '',
  dictType: '',
  status: ''
}

export function useDictionarySearch() {
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
  const handleSearch = (callback: (params: any) => void) => {
    // 将表单数据传递给回调函数
    callback(formFilters)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '字典名称',
      prop: 'dictName',
      type: 'input',
      placeholder: '请输入字典名称',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '字典类型',
      prop: 'dictType',
      type: 'input',
      placeholder: '请输入字典类型',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '状态',
      prop: 'status',
      type: 'select',
      placeholder: '请选择状态',
      config: {
        clearable: true
      },
      options: [
        { label: '启用', value: 1 },
        { label: '禁用', value: 0 }
      ],
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
