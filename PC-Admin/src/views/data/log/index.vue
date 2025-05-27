<template>
  <ArtTableFullScreen>
    <div class="log-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      />

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <!-- 如果需要按钮可以在这里添加 -->
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          :loading="loading"
          :data="tableData"
          :currentPage="1"
          :pageSize="20"
          :total="500"
          :marginTop="10"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>
      </ElCard>
    </div>

    <!-- 引入日志详情抽屉组件 -->
    <LogDetailDrawer v-model="drawerVisible" :data="currentLog" />
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { SearchChangeParams, SearchFormItem } from '@/types/search-form'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import LogDetailDrawer, { LogItem } from './components/LogDetailDrawer.vue'

// 响应式变量
const loading = ref(false)
const tableRef = ref()
const drawerVisible = ref(false)
const currentLog = ref<LogItem | null>(null)

// 定义表单搜索初始值
const initialSearchState = {
  username: '',
  account: '',
  operationType: '',
  startTime: '',
  endTime: ''
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

// 表单项变更处理
const handleFormChange = (params: SearchChangeParams): void => {
  console.log('表单项变更:', params)
}

// 统一操作方法
const handleOperation = (type: string, row?: any) => {
  switch (type) {
    case 'detail':
      currentLog.value = row
      drawerVisible.value = true
      break
    default:
      break
  }
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

// 动态列配置
const { columnChecks, columns } = useCheckedColumns(() => [
  { prop: 'username', label: '用户名', minWidth: 100 },
  { prop: 'account', label: '账号', minWidth: 100 },
  { prop: 'operationType', label: '类型', minWidth: 100 },
  { prop: 'content', label: '内容', minWidth: 180 },
  { prop: 'result', label: '结果', minWidth: 100 },
  { prop: 'ip', label: 'IP', minWidth: 120 },
  { prop: 'browser', label: '浏览器', minWidth: 100 },
  { prop: 'status', label: '请求耗时', minWidth: 90 },
  { prop: 'create_time', label: '时间', minWidth: 150 },
  {
    prop: 'operation',
    label: '操作',
    width: 100,
    formatter: (row: any) => {
      return h('div', [
        h(ArtButtonTable, {
          type: 'detail',
          onClick: () => handleOperation('detail', row)
        })
      ])
    }
  }
])

// 表格数据
const tableData = reactive([
  {
    username: '中小鱼',
    account: 'admin',
    operationType: '登录',
    content: '用户登录系统',
    result: '成功',
    ip: '143.133.312.563',
    browser: 'Chrome',
    status: '125ms',
    create_time: '2023-05-14 08:25:36'
  },
  {
    username: '何小荷',
    account: 'hexiaohe',
    operationType: '查询',
    content: '查询用户列表',
    result: '成功',
    ip: '131.133.313.424',
    browser: 'Firefox',
    status: '98ms',
    create_time: '2023-05-14 09:12:45'
  },
  {
    username: '誶誶淰',
    account: 'yuanmou',
    operationType: '新增',
    content: '新增部门"市场部"',
    result: '成功',
    ip: '127.133.313.132',
    browser: 'Chrome',
    status: '145ms',
    create_time: '2023-05-14 10:35:12'
  },
  {
    username: '发呆草',
    account: 'fadaicao',
    operationType: '修改',
    content: '修改用户"张三"的权限',
    result: '成功',
    ip: '143.133.313.456',
    browser: 'Edge',
    status: '112ms',
    create_time: '2023-05-14 11:42:23'
  },
  {
    username: '甜筒',
    account: 'tiantong',
    operationType: '删除',
    content: '删除角色"临时用户"',
    result: '失败',
    ip: '127.133.567.675',
    browser: 'Chrome',
    status: '87ms',
    create_time: '2023-05-14 13:15:49'
  },
  {
    username: '冷月呆呆',
    account: 'lengyue',
    operationType: '导出',
    content: '导出用户数据',
    result: '成功',
    ip: '127.133.145.545',
    browser: 'Safari',
    status: '235ms',
    create_time: '2023-05-14 14:22:18'
  },
  {
    username: '唐不苦',
    account: 'tangbuku',
    operationType: '导入',
    content: '导入部门数据',
    result: '成功',
    ip: '156.133.313.756',
    browser: 'Chrome',
    status: '198ms',
    create_time: '2023-05-14 15:36:42'
  },
  {
    username: '笑很甜',
    account: 'xiaohengtian',
    operationType: '登录',
    content: '用户登录系统',
    result: '成功',
    ip: '131.133.234.424',
    browser: 'Firefox',
    status: '103ms',
    create_time: '2023-05-14 16:45:33'
  },
  {
    username: '青隐篱',
    account: 'qingyinli',
    operationType: '查询',
    content: '查询角色列表',
    result: '成功',
    ip: '167.133.355.534',
    browser: 'Chrome',
    status: '92ms',
    create_time: '2023-05-14 17:28:11'
  },
  {
    username: '有你一生',
    account: 'youni',
    operationType: '新增',
    content: '新增用户"李四"',
    result: '成功',
    ip: '234.133.545.533',
    browser: 'Edge',
    status: '156ms',
    create_time: '2023-05-15 08:56:24'
  },
  {
    username: '中小鱼',
    account: 'admin',
    operationType: '修改',
    content: '修改系统配置',
    result: '成功',
    ip: '245.567.313.890',
    browser: 'Chrome',
    status: '134ms',
    create_time: '2023-05-15 09:34:47'
  },
  {
    username: '何小荷',
    account: 'hexiaohe',
    operationType: '删除',
    content: '删除用户"王五"',
    result: '成功',
    ip: '235.789.313.345',
    browser: 'Firefox',
    status: '108ms',
    create_time: '2023-05-15 10:42:15'
  }
])

// 获取表格数据
const getTableData = () => {
  loading.value = true
  setTimeout(() => {
    // 在实际项目中这里会是一个API调用
    loading.value = false
  }, 500)
}

// 刷新表格数据
const handleRefresh = () => {
  getTableData()
}

// 初始加载
getTableData()
</script>

<style lang="scss" scoped>
// 可以添加特定于日志页面的样式
// .log-page {}
</style>
