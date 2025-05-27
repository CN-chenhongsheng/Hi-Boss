import { useMenuStore } from '@/store/modules/menu'
import { MenuListType } from '@/types/menu'
import { formatMenuTitle } from '@/utils/menu'

export function useMenuData() {
  const { menuList } = storeToRefs(useMenuStore())
  const loading = ref(false)
  const isExpanded = ref(false)
  const tableRef = ref()
  const tableData = ref<MenuListType[]>([])
  const lockMenuType = ref(false)
  
  // 表单数据
  const form = reactive({
    // 菜单
    name: '',
    path: '',
    label: '',
    icon: '',
    isEnable: true,
    sort: 1,
    isMenu: true,
    keepAlive: true,
    isHidden: true,
    link: '',
    isIframe: false,
    // 权限
    authName: '',
    authLabel: '',
    authIcon: '',
    authSort: 1
  })
  
  // 对话框状态
  const dialogVisible = ref(false)
  const labelPosition = ref('menu')
  const isEdit = ref(false)

  // 加载数据
  const getTableData = () => {
    loading.value = true
    setTimeout(() => {
      tableData.value = menuList.value
      loading.value = false
    }, 500)
  }
  
  // 切换展开/收起
  const toggleExpand = () => {
    isExpanded.value = !isExpanded.value
    nextTick(() => {
      if (tableRef.value) {
        tableRef.value[isExpanded.value ? 'expandAll' : 'collapseAll']()
      }
    })
  }
  
  // 重置表单
  const resetForm = () => {
    // 不再需要重置表单字段，只需要重置数据对象
    Object.assign(form, {
      // 菜单
      name: '',
      path: '',
      label: '',
      icon: '',
      sort: 1,
      isMenu: true,
      keepAlive: true,
      isHidden: true,
      link: '',
      isIframe: false,
      // 权限
      authName: '',
      authLabel: '',
      authIcon: '',
      authSort: 1
    })
  }

  // 处理操作
  const handleOperation = (type: string, row?: any, lock: boolean = false) => {
    switch (type) {
      case 'menu':
      case 'button':
        dialogVisible.value = true
        labelPosition.value = type
        isEdit.value = false
        lockMenuType.value = lock || false
        resetForm()

        if (row) {
          isEdit.value = true
          nextTick(() => {
            // 回显数据
            if (type === 'menu') {
              // 菜单数据回显
              form.name = formatMenuTitle(row.meta?.title || '')
              form.path = row.path || ''
              form.label = row.name || ''
              form.icon = row.meta?.icon || ''
              form.sort = row.meta?.sort || 1
              form.isMenu = row.meta?.isMenu || true
              form.keepAlive = row.meta?.keepAlive || true
              form.isHidden = row.meta?.isHidden || true
              form.isEnable = row.meta?.isEnable || true
              form.link = row.meta?.link || ''
              form.isIframe = row.meta?.isIframe || false
            } else {
              // 权限按钮数据回显
              form.authName = row.title || ''
              form.authLabel = row.auth_mark || ''
              form.authIcon = row.icon || ''
              form.authSort = row.sort || 1
            }
          })
        }
        break
      case 'deleteAuth':
        ElMessageBox.confirm('确定要删除该权限吗？删除后无法恢复', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            ElMessage.success('删除成功')
          })
          .catch((error) => {
            if (error !== 'cancel') {
              ElMessage.error('删除失败')
            }
          })
        break
      case 'deleteMenu':
        ElMessageBox.confirm('确定要删除该菜单吗？删除后无法恢复', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            ElMessage.success('删除成功')
          })
          .catch((error) => {
            if (error !== 'cancel') {
              ElMessage.error('删除失败')
            }
          })
        break
      default:
        break
    }
  }
  
  return {
    loading,
    tableData,
    tableRef,
    isExpanded,
    form,
    dialogVisible,
    labelPosition,
    isEdit,
    lockMenuType,
    getTableData,
    toggleExpand,
    handleOperation,
  }
} 