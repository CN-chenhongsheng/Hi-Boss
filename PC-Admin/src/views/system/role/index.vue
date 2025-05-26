<template>
  <ArtTableFullScreen>
    <div class="role-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')" v-ripple>新增角色</ElButton>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          :data="tableData"
          :loading="loading"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 角色表单对话框 -->
        <RoleForm
          v-model="dialogVisible"
          v-model:type="dialogType"
          v-model:form="form"
          @refresh="handleRefresh"
        />

        <!-- 权限设置对话框 -->
        <RolePermission v-model="permissionDialog" :menuData="menuList" @refresh="handleRefresh" />
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { h } from 'vue'
import { useMenuStore } from '@/store/modules/menu'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import { SearchFormItem } from '@/types/search-form'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import RoleForm from './components/RoleForm.vue'
import RolePermission from './components/RolePermission.vue'

const dialogVisible = ref(false)
const permissionDialog = ref(false)
const { menuList } = storeToRefs(useMenuStore())
const loading = ref(false)

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
}

// 搜索处理
const handleSearch = () => {
  console.log('搜索参数:', formFilters)
  getTableData()
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

const form = reactive({
  id: '',
  name: '',
  des: '',
  status: 1
})

const tableData = reactive([
  {
    name: '超级管理员',
    allow: '全部权限',
    des: '拥有系统全部权限',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '董事会部',
    allow: '自定义',
    des: '负责董事会部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '监事会部',
    allow: '自定义',
    des: '负责监事会部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 0
  },
  {
    name: '市场部',
    allow: '自定义',
    des: '负责市场部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '人力资源部',
    allow: '自定义',
    des: '负责人力资源部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '财务部',
    allow: '自定义',
    des: '负责财务部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '公关部',
    allow: '自定义',
    des: '负责公关部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 0
  },
  {
    name: '广告部',
    allow: '自定义',
    des: '负责广告部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '营销',
    allow: '自定义',
    des: '负责营销相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '设计部',
    allow: '自定义',
    des: '负责设计部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '开发部',
    allow: '自定义',
    des: '负责开发部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '测试部',
    allow: '自定义',
    des: '负责测试部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  },
  {
    name: '安保部',
    allow: '自定义',
    des: '负责安保部相关工作的管理者',
    date: '2021-01-08 12:30:45',
    status: 1
  }
])

const handleRefresh = () => {
  getTableData()
}

const dialogType = ref('add')

const showDialog = (type: string, row?: any) => {
  dialogVisible.value = true
  dialogType.value = type

  if (type === 'edit' && row) {
    form.id = row.id
    form.name = row.name
    form.des = row.des
    form.status = row.status
  } else {
    form.id = ''
    form.name = ''
    form.des = ''
    form.status = 1
  }
}

const showPermissionDialog = () => {
  permissionDialog.value = true
}

const deleteRole = () => {
  ElMessageBox.confirm('确定删除该角色吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'error'
  }).then(() => {
    ElMessage.success('删除成功')
    getTableData()
  })
}

// 日期格式化函数
const formatDate = (date: string) => {
  return new Date(date)
    .toLocaleString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
    .replace(/\//g, '-')
}

// 动态列配置
const { columnChecks, columns } = useCheckedColumns(() => [
  { prop: 'name', label: '角色名称' },
  { prop: 'des', label: '描述' },
  {
    prop: 'status',
    label: '状态',
    formatter: (row) => {
      return h(ArtStatusSwitch, {
        modelValue: row.status
      })
    }
  },
  {
    prop: 'date',
    label: '创建时间',
    formatter: (row) => {
      return formatDate(row.date)
    }
  },
  {
    prop: 'operation',
    label: '操作',
    width: 180,
    formatter: (row) => {
      return h('div', { class: 'operation-btns' }, [
        h(ArtButtonTable, {
          type: 'detail',
          onClick: () => showPermissionDialog()
        }),
        h(ArtButtonTable, {
          type: 'edit',
          onClick: () => showDialog('edit', row)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          onClick: () => deleteRole()
        })
      ])
    }
  }
])

// 获取表格数据
const getTableData = () => {
  loading.value = true
  setTimeout(() => {
    loading.value = false
  }, 500)
}
</script>

<style lang="scss" scoped>
.role-page {
  .svg-icon {
    width: 1.8em;
    height: 1.8em;
    overflow: hidden;
    vertical-align: -8px;
    fill: currentcolor;
  }
}
</style>
