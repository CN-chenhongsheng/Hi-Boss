<template>
  <ArtTableFullScreen>
    <div class="menu-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader :showZebra="false" v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton v-auth="'add'" @click="handleOperation('menu')" v-ripple>添加菜单</ElButton>
            <ElButton @click="toggleExpand" v-ripple>{{ isExpanded ? '收起' : '展开' }}</ElButton>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="filteredTableData"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 菜单表单 -->
        <MenuForm
          v-model="dialogVisible"
          v-model:form="form"
          v-model:labelPosition="labelPosition"
          v-model:isEdit="isEdit"
          v-model:lockMenuType="lockMenuType"
        />
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { useMenuStore } from '@/store/modules/menu'
import { ElMessage, ElMessageBox, ElTag } from 'element-plus'
import { formatMenuTitle } from '@/utils/menu'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import { ElPopover, ElButton } from 'element-plus'
import { SearchFormItem } from '@/types/search-form'
import { MenuListType } from '@/types/menu'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import MenuForm from './components/MenuForm.vue'

const { menuList } = storeToRefs(useMenuStore())

const loading = ref(false)
const isExpanded = ref(false)
const tableRef = ref()
const lockMenuType = ref(false)

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
  getTableData()
}

// 搜索处理
const handleSearch = () => {
  // 将当前输入的筛选条件应用到实际搜索
  Object.assign(appliedFilters, { ...formFilters })
  getTableData()
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

// 构建菜单类型标签
const buildMenuTypeTag = (row: MenuListType) => {
  if (row.children && row.children.length > 0) {
    return 'info'
  } else if (row.meta?.link && row.meta?.isIframe) {
    return 'success'
  } else if (row.path) {
    return 'primary'
  } else if (row.meta?.link) {
    return 'warning'
  }
}

// 构建菜单类型文本
const buildMenuTypeText = (row: MenuListType) => {
  if (row.children && row.children.length > 0) {
    return '目录'
  } else if (row.meta?.link && row.meta?.isIframe) {
    return '内嵌'
  } else if (row.path) {
    return '菜单'
  } else if (row.meta?.link) {
    return '外链'
  }
}

// 动态列配置
const { columnChecks, columns } = useCheckedColumns(() => [
  {
    prop: 'meta.title',
    label: '菜单名称',
    minWidth: 120,
    formatter: (row: MenuListType) => {
      return formatMenuTitle(row.meta?.title)
    }
  },
  {
    prop: 'type',
    label: '菜单类型',
    formatter: (row: MenuListType) => {
      return h(ElTag, { type: buildMenuTypeTag(row) }, () => buildMenuTypeText(row))
    }
  },
  {
    prop: 'path',
    label: '路由',
    formatter: (row: MenuListType) => {
      return row.meta?.link || row.path || ''
    }
  },
  {
    prop: 'meta.authList',
    label: '可操作权限',
    formatter: (row: MenuListType) => {
      return h(
        'div',
        {},
        row.meta.authList?.map((item: MenuListType['meta'], index: number) => {
          return h(
            ElPopover,
            {
              placement: 'top-start',
              title: '操作',
              width: 200,
              trigger: 'click',
              key: index
            },
            {
              default: () =>
                h('div', { style: 'margin: 0; text-align: right' }, [
                  h(
                    ElButton,
                    {
                      size: 'small',
                      type: 'primary',
                      onClick: () => handleOperation('button', item)
                    },
                    { default: () => '编辑' }
                  ),
                  h(
                    ElButton,
                    {
                      size: 'small',
                      type: 'danger',
                      onClick: () => handleOperation('deleteAuth')
                    },
                    { default: () => '删除' }
                  )
                ]),
              reference: () => h(ElButton, { class: 'small-btn' }, { default: () => item.title })
            }
          )
        })
      )
    }
  },
  {
    prop: 'date',
    label: '编辑时间',
    formatter: () => '2022-3-12 12:00:00'
  },
  {
    prop: 'status',
    label: '隐藏菜单',
    formatter: (row) => {
      return h(ArtStatusSwitch, {
        modelValue: row.meta?.isHidden || false,
        activeValue: true,
        inactiveValue: false,
        needConfirm: true
      })
    }
  },
  {
    prop: 'operation',
    label: '操作',
    width: 180,
    formatter: (row: MenuListType) => {
      return h('div', [
        h(ArtButtonTable, {
          type: 'add',
          'v-auth': "'add'",
          onClick: () => handleOperation('menu')
        }),
        h(ArtButtonTable, {
          type: 'edit',
          'v-auth': "'edit'",
          onClick: () => handleOperation('menu', row, true)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          'v-auth': "'delete'",
          onClick: () => handleOperation('deleteMenu')
        })
      ])
    }
  }
])

const handleRefresh = () => {
  getTableData()
}

const dialogVisible = ref(false)
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

const labelPosition = ref('menu')
const isEdit = ref(false)

const tableData = ref<MenuListType[]>([])

onMounted(() => {
  getTableData()
})

const getTableData = () => {
  loading.value = true
  setTimeout(() => {
    tableData.value = menuList.value
    loading.value = false
  }, 500)
}

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

// 统一操作方法
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

const toggleExpand = () => {
  isExpanded.value = !isExpanded.value
  nextTick(() => {
    if (tableRef.value) {
      tableRef.value[isExpanded.value ? 'expandAll' : 'collapseAll']()
    }
  })
}

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
</script>

<style lang="scss" scoped>
.menu-page {
  .svg-icon {
    width: 1.8em;
    height: 1.8em;
    overflow: hidden;
    vertical-align: -8px;
    fill: currentcolor;
  }

  :deep(.small-btn) {
    height: 30px !important;
    padding: 0 10px !important;
    font-size: 12px !important;
  }
}
</style>
