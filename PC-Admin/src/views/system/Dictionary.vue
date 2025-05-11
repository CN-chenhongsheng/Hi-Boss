<template>
    <ArtTableFullScreen>
      <div class="dictionary-page" id="table-full-screen">
        <!-- 搜索栏 -->
        <ArtSearchBar
          v-model:filter="formFilters"
          :items="formItems"
          @reset="handleReset"
          @search="handleSearch"
        ></ArtSearchBar>
  
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
            :expand-row-keys="expandedRows"
            @expand-change="handleExpandChange"
          >
            <template #default>
              <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col">
                <!-- 自定义展开行模板 -->
                <template #default="scope" v-if="col.type === 'expand'">
                  <div class="dict-detail-container">
                    <div class="dict-detail-header">
                      <h3>字典数据列表</h3>
                    </div>
                    <!-- 字典明细表格 -->
                    <ArtTable :data="getDictDetails(scope.row.dictType)" style="width: 100%">
                      <template #default>
                        <ElTableColumn v-for="detailCol in detailColumns" :key="detailCol.prop || detailCol.type" v-bind="detailCol" />
                      </template>
                    </ArtTable>
                    
                    <ElButton @click="addDictDetail(scope.row)" v-ripple class="mt-1" style="width: 100%">新增子字典</ElButton>
                  </div>
                </template>
              </ElTableColumn>
            </template>
          </ArtTable>
  
          <ElDialog
            v-model="dialogVisible"
            :title="dialogType === 'add' ? '添加字典' : '编辑字典'"
            width="30%"
          >
            <ElForm ref="formRef" :model="formData" :rules="rules" label-width="80px">
              <ElFormItem label="字典名称" prop="dictName">
                <ElInput v-model="formData.dictName" />
              </ElFormItem>
              <ElFormItem label="字典类型" prop="dictType">
                <ElInput v-model="formData.dictType" />
              </ElFormItem>
              <ElFormItem label="备注" prop="remark">
                <ElInput v-model="formData.remark" type="textarea" :rows="3" />
              </ElFormItem>
              <ElFormItem label="状态" prop="status">
                <ArtStatusSwitch v-model:modelValue="formData.status" :needConfirm="false" />
              </ElFormItem>
            </ElForm>
            <template #footer>
              <div class="dialog-footer">
                <ElButton @click="dialogVisible = false">取消</ElButton>
                <ElButton type="primary" @click="handleSubmit">提交</ElButton>
              </div>
            </template>
          </ElDialog>

          <!-- 字典明细对话框 -->
          <ElDialog
            v-model="detailDialogVisible"
            :title="detailDialogType === 'add' ? '添加字典数据' : '编辑字典数据'"
            width="30%"
          >
            <ElForm ref="detailFormRef" :model="detailFormData" :rules="detailRules" label-width="100px">
              <ElFormItem label="字典类型" prop="dictType">
                <ElInput v-model="detailFormData.dictType" disabled />
              </ElFormItem>
              <ElFormItem label="字典编码" prop="code">
                <ElInput v-model="detailFormData.code" />
              </ElFormItem>
              <ElFormItem label="字典名称" prop="name">
                <ElInput v-model="detailFormData.name" />
              </ElFormItem>
              <ElFormItem label="备注" prop="remark">
                <ElInput v-model="detailFormData.remark" type="textarea" :rows="3" />
              </ElFormItem>
              <ElFormItem label="状态" prop="status">
                <ArtStatusSwitch v-model:modelValue="detailFormData.status" :needConfirm="false" />
              </ElFormItem>
            </ElForm>
            <template #footer>
              <div class="dialog-footer">
                <ElButton @click="detailDialogVisible = false">取消</ElButton>
                <ElButton type="primary" @click="handleDetailSubmit">提交</ElButton>
              </div>
            </template>
          </ElDialog>
        </ElCard>
      </div>
    </ArtTableFullScreen>
  </template>
  
  <script setup lang="ts">
    import { h, ref, reactive, onMounted, computed } from 'vue'
    import { DICTIONARY_DATA, DictionaryItem } from '@/mock/temp/dictionaryData'
    import { SearchChangeParams, SearchFormItem } from '@/types/search-form'
    import { 
      ElDialog, 
      ElMessage, 
      ElMessageBox,
      ElTag, 
      ElTable, 
      ElTableColumn, 
      ElSelect, 
      ElOption,
      FormInstance
    } from 'element-plus'
    import type { FormRules } from 'element-plus'
    import { useCheckedColumns } from '@/composables/useCheckedColumns'
    import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
    import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'

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
      'sys_user_type': [
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
      'sys_gender': [
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
      'sys_status': [
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
      'sys_dept_type': [
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
      'sys_notice_type': [
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
  
    const dialogType = ref('add')
    const dialogVisible = ref(false)
    const loading = ref(false)
    const tableRef = ref()
    
    // 控制行展开的状态
    const expandedRows = ref<string[]>([])
    
    // 处理行展开/折叠事件
    const handleExpandChange = (row: DictionaryItem, expanded: boolean) => {
      const dictType = row.dictType
      if (expanded) {
        // 添加到展开行数组
        if (!expandedRows.value.includes(dictType)) {
          expandedRows.value.push(dictType)
        }
      } else {
        // 从展开行数组中移除
        const index = expandedRows.value.indexOf(dictType)
        if (index !== -1) {
          expandedRows.value.splice(index, 1)
        }
      }
    }
    
    // 获取行是否应展开的状态
    const getRowExpanded = (row: DictionaryItem) => {
      return expandedRows.value.includes(row.dictType)
    }

    // 字典明细相关变量
    const detailDialogType = ref('add')
    const detailDialogVisible = ref(false)
    const currentDictType = ref('')
    
    // 获取字典明细数据
    const getDictDetails = (dictType: string) => {
      return DICTIONARY_DETAIL_DATA[dictType] || []
    }

    // 添加字典明细
    const addDictDetail = (row: DictionaryItem) => {
      detailDialogType.value = 'add'
      detailDialogVisible.value = true
      currentDictType.value = row.dictType
      
      // 初始化表单数据
      detailFormData.dictType = row.dictType
      detailFormData.code = ''
      detailFormData.name = ''
      detailFormData.status = 1
      detailFormData.remark = ''
    }

    // 编辑字典明细
    const editDictDetail = (row: DictionaryDetailItem) => {
      detailDialogType.value = 'edit'
      detailDialogVisible.value = true
      currentDictType.value = row.dictType
      
      // 填充表单数据
      detailFormData.id = row.id
      detailFormData.dictType = row.dictType
      detailFormData.code = row.code
      detailFormData.name = row.name
      detailFormData.status = row.status
      detailFormData.remark = row.remark
    }

    // 删除字典明细
    const deleteDictDetail = (row: DictionaryDetailItem) => {
      ElMessageBox.confirm('确定要删除该字典数据吗？', '删除字典数据', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }).then(() => {
        // 模拟删除操作，实际项目中应该调用API
        if (DICTIONARY_DETAIL_DATA[row.dictType]) {
          const index = DICTIONARY_DETAIL_DATA[row.dictType].findIndex(item => item.id === row.id)
          if (index !== -1) {
            DICTIONARY_DETAIL_DATA[row.dictType].splice(index, 1)
            ElMessage.success('删除成功')
          }
        }
      })
    }

    // 字典明细表单数据
    const detailFormData = reactive<{
      id?: number
      dictType: string
      code: string
      name: string
      status: number
      remark: string
    }>({
      dictType: '',
      code: '',
      name: '',
      status: 1,
      remark: ''
    })

    // 字典明细表单规则
    const detailRules = reactive<FormRules>({
      code: [
        { required: true, message: '请输入字典编码', trigger: 'blur' },
        { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
      ],
      name: [
        { required: true, message: '请输入字典名称', trigger: 'blur' },
        { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
      ],
      status: [{ required: true, message: '请选择状态', trigger: 'change', type: 'number' }]
    })

    // 字典明细表单实例
    const detailFormRef = ref<FormInstance>()

    // 提交字典明细表单
    const handleDetailSubmit = async () => {
      if (!detailFormRef.value) return
      
      await detailFormRef.value.validate((valid) => {
        if (valid) {
          // 模拟提交操作，实际项目中应该调用API
          if (detailDialogType.value === 'add') {
            // 添加新数据
            if (!DICTIONARY_DETAIL_DATA[currentDictType.value]) {
              DICTIONARY_DETAIL_DATA[currentDictType.value] = []
            }
            
            // 生成ID（实际项目中应由后端生成）
            const newId = Math.max(...Object.values(DICTIONARY_DETAIL_DATA).flat().map(item => item.id), 0) + 1
            
            DICTIONARY_DETAIL_DATA[currentDictType.value].push({
              id: newId,
              dictType: detailFormData.dictType,
              code: detailFormData.code,
              name: detailFormData.name,
              status: detailFormData.status,
              createTime: new Date().toISOString().replace('T', ' ').substring(0, 19),
              remark: detailFormData.remark
            })
          } else {
            // 更新现有数据
            if (DICTIONARY_DETAIL_DATA[currentDictType.value] && detailFormData.id) {
              const index = DICTIONARY_DETAIL_DATA[currentDictType.value].findIndex(item => item.id === detailFormData.id)
              if (index !== -1) {
                DICTIONARY_DETAIL_DATA[currentDictType.value][index] = {
                  ...DICTIONARY_DETAIL_DATA[currentDictType.value][index],
                  code: detailFormData.code,
                  name: detailFormData.name,
                  status: detailFormData.status,
                  remark: detailFormData.remark
                }
              }
            }
          }
          
          ElMessage.success(detailDialogType.value === 'add' ? '添加成功' : '更新成功')
          detailDialogVisible.value = false
        }
      })
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
      dialogVisible.value = true
      dialogType.value = type
  
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
      { type: 'expand', label: '展开', width: 80 }, // 展开列
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
        width: 150,
        formatter: (row: any) => {
          return h('div', [
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
  
    // 动态子列配置
    const { columnChecks: detailColumnChecks, columns: detailColumns } = useCheckedColumns(() => [
      { type: 'selection', width: 55 },
      { type: 'index', label: '序号', width: 80 },
      { prop: 'code', label: '字典编码', width: 150 },
      { prop: 'name', label: '字典名称', width: 150 },
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
      { prop: 'createTime', label: '创建时间', sortable: true, width: 180 },
      { prop: 'remark', label: '备注' },
      {
        prop: 'operation',
        label: '操作',
        width: 150,
        formatter: (row: any) => {
          return h('div', { class: 'operation-btns' }, [
            h(ArtButtonTable, {
              type: 'edit',
              onClick: () => editDictDetail(row)
            }),
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => deleteDictDetail(row)
            })
          ])
        }
      }
    ])

    // 表单实例
    const formRef = ref<FormInstance>()
  
    // 表格数据
    const tableData = ref<DictionaryItem[]>([])
  
    onMounted(() => {
      getTableData()
    })
  
    const getTableData = () => {
      loading.value = true
      setTimeout(() => {
        // 使用从模拟数据文件中导入的数据并转换status字段类型
        tableData.value = DICTIONARY_DATA.map(item => ({
          ...item,
          status: item.status // 确保status是数字类型
        }))
        loading.value = false
      }, 500)
    }
  
    const handleRefresh = () => {
      getTableData()
    }
  
    // 表单验证规则
    const rules = reactive<FormRules>({
      dictName: [
        { required: true, message: '请输入字典名称', trigger: 'blur' },
        { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
      ],
      dictType: [
        { required: true, message: '请输入字典类型', trigger: 'blur' },
        { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
      ],
      status: [{ required: true, message: '请选择状态', trigger: 'change', type: 'number' }]
    })
  
    // 提交表单
    const handleSubmit = async () => {
      if (!formRef.value) return
  
      await formRef.value.validate((valid) => {
        if (valid) {
          ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
          dialogVisible.value = false
        }
      })
    }
  
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
  </script>
  
  <style lang="scss" scoped>
    .dictionary-page {
      // 可以添加特定于字典页面的样式
    }

    .dict-detail-container {
      padding: 10px;
    }

    .dict-detail-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;

      h3 {
        margin: 0;
      }
    }

    .operation-btns {
      display: flex;
      justify-content: flex-start;
      align-items: center;
    }

    .art-btn-table {
      display: inline-block;
      min-width: 34px;
      height: 34px;
      padding: 0 10px;
      margin-right: 10px;
      font-size: 13px;
      line-height: 34px;
      color: #666;
      cursor: pointer;
      background-color: rgba(var(--art-gray-200-rgb), 0.7);
      border-radius: 6px;

      &:hover {
        color: var(--main-color);
        background-color: rgba(var(--art-gray-300-rgb), 0.5);
      }

      &.error {
        color: #f56c6c;

        &:hover {
          color: #f56c6c;
          background-color: rgba(245, 108, 108, 0.1);
        }
      }
    }

    .mt-1 {
      margin-top: 10px;
    }
  </style>
  