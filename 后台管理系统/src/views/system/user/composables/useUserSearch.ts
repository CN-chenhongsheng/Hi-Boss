import { reactive } from 'vue'
import { SearchFormItem, SearchChangeParams } from '@/types/search-form'

export function useUserSearch(onSearch: () => void) {
  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    gender: '',
    phone: '',
    address: '',
    level: '',
    email: '',
    company: ''
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
      label: '用户名',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },

    {
      label: '电话',
      prop: 'phone',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '用户等级',
      prop: 'level',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '普通用户', value: 'normal' },
        { label: 'VIP用户', value: 'vip' },
        { label: '高级VIP', value: 'svip' },
        { label: '企业用户', value: 'enterprise', disabled: true }
      ],
      onChange: handleFormChange
    },
    {
      label: '地址',
      prop: 'address',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '邮箱',
      prop: 'email',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '公司',
      prop: 'company',
      type: 'input',
      config: {
        placeholder: '请输入公司名称',
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '性别',
      prop: 'gender',
      type: 'select',
      options: [
        { label: '男', value: 'male' },
        { label: '女', value: 'female' }
      ],
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
