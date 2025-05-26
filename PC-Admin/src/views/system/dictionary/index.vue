<template>
  <ArtTableFullScreen>
    <div class="dictionary-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')" v-ripple>新增字典</ElButton>
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
          row-key="dictType"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>
      </ElCard>
    </div>
  </ArtTableFullScreen>

  <!-- 添加/编辑字典弹窗 -->
  <DictForm
    v-model="dialogVisible"
    v-model:type="dialogType"
    v-model:data="formData"
    @refresh="handleRefresh"
  />

  <!-- 字典数据列表弹窗 -->
  <DictDataList
    v-model="permissionDialogVisible"
    v-model:dictType="currentDictType"
    v-model:details="dictionaryDetails"
    @refresh="handleDetailRefresh"
  />
</template>

<script setup lang="ts">
import { h, ref, reactive, onMounted } from 'vue'
import { DICTIONARY_DATA, DictionaryItem } from '@/mock/temp/dictionaryData'
import { SearchChangeParams, SearchFormItem } from '@/types/search-form'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import DictForm from './components/DictForm.vue'
import DictDataList from './components/DictDataList.vue'

// 定义字典明细数据接口
interface DictionaryDetailItem {
  id: number
  dictType: string
  code: string
  name: string
  status: number
  createTime: string
  remark: string
}

// 明细数据
const DICTIONARY_DETAIL_DATA: Record<string, DictionaryDetailItem[]> = {
  sys_user_type: [
    {
      id: 1,
      dictType: 'sys_user_type',
      code: '0',
      name: '管理员',
      status: 1,
      createTime: '2023-05-15 14:35:00',
      remark: '系统管理员'
    },
    {
      id: 2,
      dictType: 'sys_user_type',
      code: '1',
      name: '普通用户',
      status: 1,
      createTime: '2023-05-15 14:35:10',
      remark: '系统普通用户'
    },
    {
      id: 3,
      dictType: 'sys_user_type',
      code: '2',
      name: '访客',
      status: 0,
      createTime: '2023-05-15 14:35:20',
      remark: '临时访客'
    }
  ],
  sys_gender: [
    {
      id: 4,
      dictType: 'sys_gender',
      code: '0',
      name: '男',
      status: 1,
      createTime: '2023-05-16 09:50:00',
      remark: '男性'
    },
    {
      id: 5,
      dictType: 'sys_gender',
      code: '1',
      name: '女',
      status: 1,
      createTime: '2023-05-16 09:50:10',
      remark: '女性'
    },
    {
      id: 6,
      dictType: 'sys_gender',
      code: '2',
      name: '未知',
      status: 1,
      createTime: '2023-05-16 09:50:20',
      remark: '性别未知'
    }
  ],
  sys_status: [
    {
      id: 7,
      dictType: 'sys_status',
      code: '0',
      name: '禁用',
      status: 1,
      createTime: '2023-05-17 16:25:00',
      remark: '状态禁用'
    },
    {
      id: 8,
      dictType: 'sys_status',
      code: '1',
      name: '启用',
      status: 1,
      createTime: '2023-05-17 16:25:10',
      remark: '状态启用'
    }
  ],
  sys_dept_type: [
    {
      id: 9,
      dictType: 'sys_dept_type',
      code: '0',
      name: '公司',
      status: 1,
      createTime: '2023-05-18 11:15:00',
      remark: '公司单位'
    },
    {
      id: 10,
      dictType: 'sys_dept_type',
      code: '1',
      name: '部门',
      status: 1,
      createTime: '2023-05-18 11:15:10',
      remark: '部门单位'
    },
    {
      id: 11,
      dictType: 'sys_dept_type',
      code: '2',
      name: '小组',
      status: 0,
      createTime: '2023-05-18 11:15:20',
      remark: '团队小组'
    }
  ],
  sys_notice_type: [
    {
      id: 12,
      dictType: 'sys_notice_type',
      code: '0',
      name: '公告',
      status: 1,
      createTime: '2023-05-19 13:30:00',
      remark: '公告通知'
    },
    {
      id: 13,
      dictType: 'sys_notice_type',
      code: '1',
      name: '通知',
      status: 1,
      createTime: '2023-05-19 13:30:10',
      remark: '系统通知'
    },
    {
      id: 14,
      dictType: 'sys_notice_type',
      code: '2',
      name: '警告',
      status: 1,
      createTime: '2023-05-19 13:30:20',
      remark: '警告提醒'
    }
  ]
}

// 显示对话框相关变量
const dialogType = ref('add')
const dialogVisible = ref(false)
const loading = ref(false)
const tableRef = ref()

// 权限弹窗相关变量
const permissionDialogVisible = ref(false)
const currentDictType = ref('')
const currentDict = reactive({
  dictName: '',
  dictType: '',
  status: 1,
  remark: ''
})

// 当前选中字典的明细数据
const dictionaryDetails = ref<DictionaryDetailItem[]>([])

// 查看权限（展示字典值）
const showPermissionDialog = (row: DictionaryItem): void => {
  permissionDialogVisible.value = true
  currentDictType.value = row.dictType
  currentDict.dictName = row.dictName
  currentDict.dictType = row.dictType
  currentDict.status = row.status
  currentDict.remark = row.remark

  // 加载对应的字典明细数据
  dictionaryDetails.value = DICTIONARY_DETAIL_DATA[row.dictType] || []
}

// 刷新字典明细数据
const handleDetailRefresh = () => {
  if (currentDictType.value) {
    dictionaryDetails.value = DICTIONARY_DETAIL_DATA[currentDictType.value] || []
  }
}

// 定义表单搜索初始值
const initialSearchState: {
  dictName: string
  dictType: string
  status: string | number
} = {
  dictName: '',
  dictType: '',
  status: ''
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

// 表单配置项
const formItems: SearchFormItem[] = [
  {
    label: '字典名称',
    prop: 'dictName',
    type: 'input',
    config: {
      clearable: true
    },
    onChange: handleFormChange
  },
  {
    label: '字典类型',
    prop: 'dictType',
    type: 'input',
    config: {
      clearable: true
    },
    onChange: handleFormChange
  },
  {
    label: '状态',
    prop: 'status',
    type: 'select',
    options: [
      { label: '启用', value: 1 },
      { label: '禁用', value: 0 }
    ],
    onChange: handleFormChange
  }
]

// 显示对话框
const showDialog = (type: string, row?: any) => {
  dialogType.value = type
  dialogVisible.value = true

  if (type === 'edit' && row) {
    formData.dictName = row.dictName
    formData.dictType = row.dictType
    formData.status = row.status
    formData.remark = row.remark
  } else {
    formData.dictName = ''
    formData.dictType = ''
    formData.status = 1
    formData.remark = ''
  }
}

// 删除字典
const deleteDictionary = () => {
  ElMessageBox.confirm('确定要删除该字典吗？', '删除字典', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'error'
  }).then(() => {
    ElMessage.success('删除成功')
  })
}

// 动态列配置
const { columnChecks, columns } = useCheckedColumns(() => [
  { type: 'selection' }, // 勾选列
  { type: 'index', label: '序号', width: 80 }, // 序号列
  { prop: 'dictName', label: '字典名称', minWidth: 150 },
  { prop: 'dictType', label: '字典类型', minWidth: 150 },
  {
    prop: 'status',
    label: '状态',
    width: 100,
    formatter: (row: any) => {
      return h(ArtStatusSwitch, {
        modelValue: row.status
      })
    }
  },
  { prop: 'remark', label: '备注', minWidth: 180 },
  {
    prop: 'createTime',
    label: '创建时间',
    sortable: true,
    minWidth: 180
  },
  {
    prop: 'operation',
    label: '操作',
    width: 180,
    formatter: (row: any) => {
      return h('div', [
        h(ArtButtonTable, {
          type: 'detail',
          onClick: () => showPermissionDialog(row)
        }),
        h(ArtButtonTable, {
          type: 'edit',
          onClick: () => showDialog('edit', row)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          onClick: () => deleteDictionary()
        })
      ])
    }
  }
])

// 表单数据
const formData = reactive<{
  dictName: string
  dictType: string
  status: number
  remark: string
}>({
  dictName: '',
  dictType: '',
  status: 1,
  remark: ''
})

// 表格数据
const tableData = ref<DictionaryItem[]>([])

onMounted(() => {
  getTableData()
})

const getTableData = () => {
  loading.value = true
  setTimeout(() => {
    // 使用从模拟数据文件中导入的数据并转换status字段类型
    tableData.value = DICTIONARY_DATA.map((item) => ({
      ...item,
      status: item.status // 确保status是数字类型
    }))
    loading.value = false
  }, 500)
}

const handleRefresh = () => {
  getTableData()
}
</script>

<style lang="scss" scoped>
// 可以添加特定于字典页面的样式
// .dictionary-page {}

.operation-btns {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
</style>
