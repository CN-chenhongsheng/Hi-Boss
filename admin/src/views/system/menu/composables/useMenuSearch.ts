import { SearchFormItem } from '@/types'
import { MenuListType } from '@/types/menu'
import { formatMenuTitle } from '@/router/utils/utils'

export function useMenuSearch(tableData: Ref<MenuListType[]>, onSearch: () => void) {
  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    route: ''
  }

  // 响应式表单数据
  const formFilters = reactive({ ...initialSearchState })

  // 增加实际应用的搜索条件状态
  const appliedFilters = reactive({ ...initialSearchState })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    Object.assign(appliedFilters, { ...initialSearchState })
    onSearch()
  }

  // 搜索处理
  const handleSearch = () => {
    // 将当前输入的筛选条件应用到实际搜索
    Object.assign(appliedFilters, { ...formFilters })
    onSearch()
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '菜单名称',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      }
    },
    {
      label: '路由地址',
      prop: 'route',
      type: 'input',
      config: {
        clearable: true
      }
    }
  ]
  
  // 过滤后的表格数据
  const filteredTableData = computed(() => {
    // 递归搜索函数
    const searchMenu = (items: MenuListType[]): MenuListType[] => {
      return items.filter((item) => {
        // 获取搜索关键词，转换为小写并去除首尾空格
        const searchName = appliedFilters.name?.toLowerCase().trim() || ''
        const searchRoute = appliedFilters.route?.toLowerCase().trim() || ''

        // 获取菜单标题和路径，确保它们存在
        const menuTitle = formatMenuTitle(item.meta?.title || '').toLowerCase()
        const menuPath = (item.path || '').toLowerCase()

        // 使用 includes 进行模糊匹配
        const nameMatch = !searchName || menuTitle.includes(searchName)
        const routeMatch = !searchRoute || menuPath.includes(searchRoute)

        // 如果有子菜单，递归搜索
        if (item.children && item.children.length > 0) {
          const matchedChildren = searchMenu(item.children)
          // 如果子菜单有匹配项，保留当前菜单
          if (matchedChildren.length > 0) {
            item.children = matchedChildren
            return true
          }
        }

        return nameMatch && routeMatch
      })
    }
    return searchMenu(tableData.value)
  })

  return {
    formFilters,
    formItems,
    appliedFilters,
    filteredTableData,
    handleSearch,
    handleReset
  }
} 