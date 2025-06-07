import { SearchFormItem } from '@/types/search-form'

export function useRoleSearch(onSearch: () => void) {
  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    des: ''
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

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '角色名称',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      }
    },
    {
      label: '描述',
      prop: 'des',
      type: 'input',
      config: {
        clearable: true
      }
    }
  ]

  return {
    formFilters,
    formItems,
    handleSearch,
    handleReset
  }
}
