import { SearchFormItem, SearchChangeParams } from '@/types'

export function useDictDataSearch() {
  // 搜索表单数据
  const formFilters = reactive({
    dictLabel: '',
    status: ''
  })

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 搜索表单项配置
  const formItems: SearchFormItem[] = [
    {
      label: '字典标签',
      prop: 'dictLabel',
      type: 'input',
      placeholder: '请输入字典标签',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      prop: 'status',
      label: '状态',
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

  // 重置搜索条件
  const handleReset = () => {
    formFilters.dictLabel = ''
    formFilters.status = ''
  }

  // 搜索方法
  const handleSearch = (callback: (params: any) => void) => {
    const params = { ...formFilters }
    callback(params)
  }

  return {
    formFilters,
    formItems,
    handleReset,
    handleSearch
  }
}
