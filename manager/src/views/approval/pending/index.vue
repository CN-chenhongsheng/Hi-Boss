<!-- 待办审批页面 -->
<template>
  <div class="art-full-height">
    <!-- 搜索 -->
    <ElCard v-show="showSearchBar" class="art-search-card" shadow="never">
      <ElForm :model="formFilters" label-width="80px">
        <ElRow :gutter="16">
          <ElCol :xs="24" :sm="12" :md="8" :lg="6">
            <ElFormItem label="业务类型">
              <ElSelect
                v-model="formFilters.businessType"
                placeholder="请选择业务类型"
                clearable
                style="width: 100%"
              >
                <ElOption
                  v-for="item in businessTypeOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </ElSelect>
            </ElFormItem>
          </ElCol>
          <ElCol :xs="24" :sm="12" :md="8" :lg="6">
            <ElFormItem label="申请人">
              <ElInput
                v-model="formFilters.applicantName"
                placeholder="请输入申请人姓名"
                clearable
                @keyup.enter="handleSearch"
              />
            </ElFormItem>
          </ElCol>
          <ElCol :xs="24" :sm="12" :md="8" :lg="6">
            <ElFormItem label=" ">
              <ElSpace>
                <ElButton type="primary" @click="handleSearch" v-ripple>
                  <i class="ri-search-line mr-1"></i>
                  查询
                </ElButton>
                <ElButton @click="handleReset" v-ripple>
                  <i class="ri-refresh-line mr-1"></i>
                  重置
                </ElButton>
              </ElSpace>
            </ElFormItem>
          </ElCol>
        </ElRow>
      </ElForm>
    </ElCard>

    <ElCard
      class="art-table-card"
      shadow="never"
      :style="{ 'margin-top': showSearchBar ? '12px' : '0' }"
    >
      <ArtTableHeader
        v-model:columns="columnChecks"
        v-model:showSearchBar="showSearchBar"
        :loading="loading"
        @refresh="refreshData"
      />

      <!-- 表格 -->
      <ArtTable
        :loading="loading"
        :data="data"
        :columns="columns"
        :pagination="pagination"
        @pagination:size-change="handleSizeChange"
        @pagination:current-change="handleCurrentChange"
      />
    </ElCard>

    <!-- 审批抽屉 -->
    <ApprovalDrawer
      v-model:visible="approvalDialogVisible"
      :instance-data="currentInstance"
      @success="handleApprovalSuccess"
    />
  </div>
</template>

<script setup lang="ts">
  import { onMounted } from 'vue'
  import { useTable } from '@/hooks/core/useTable'
  import { fetchGetPendingList, type ApprovalInstance } from '@/api/approval-manage'
  import ApprovalDrawer from './modules/approval-drawer.vue'
  import { ElTag } from 'element-plus'
  import { useBusinessType } from '@/hooks'

  defineOptions({ name: 'ApprovalPending' })

  // 业务类型（从字典获取）
  const { businessTypeOptions, fetchBusinessTypes } = useBusinessType()

  onMounted(() => {
    fetchBusinessTypes()
  })

  // 搜索相关
  const formFilters = ref({
    pageNum: 1,
    businessType: undefined,
    applicantName: undefined
  })

  const showSearchBar = ref(false)
  const approvalDialogVisible = ref(false)
  const currentInstance = ref<ApprovalInstance | null>(null)

  const {
    columns,
    columnChecks,
    data,
    loading,
    pagination,
    getData,
    resetSearchParams,
    handleSizeChange,
    handleCurrentChange,
    refreshData
  } = useTable({
    core: {
      apiFn: fetchGetPendingList,
      apiParams: computed(() => ({
        pageNum: formFilters.value.pageNum,
        businessType: formFilters.value.businessType || undefined,
        applicantName: formFilters.value.applicantName || undefined
      })),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        {
          prop: 'businessType',
          label: '业务类型',
          width: 120,
          formatter: (row: ApprovalInstance) => {
            return h(ElTag, { type: 'info', size: 'small' }, () => row.businessTypeText)
          }
        },
        {
          prop: 'applicantName',
          label: '申请人',
          width: 120
        },
        {
          prop: 'flowName',
          label: '审批流程',
          minWidth: 150
        },
        {
          prop: 'currentNodeName',
          label: '当前节点',
          width: 120,
          formatter: (row: ApprovalInstance) => {
            return h(ElTag, { type: 'warning', size: 'small' }, () => row.currentNodeName)
          }
        },
        {
          prop: 'startTime',
          label: '提交时间',
          width: 180,
          sortable: true
        },
        {
          prop: 'action',
          label: '操作',
          width: 120,
          fixed: 'right',
          formatter: (row: ApprovalInstance) => {
            return [{ type: 'view', onClick: () => openApprovalDialog(row), label: '审批' }]
          }
        }
      ]
    },
    adaptive: {
      enabled: true
    }
  })

  const handleSearch = async (): Promise<void> => {
    formFilters.value.pageNum = 1
    await getData()
  }

  const handleReset = async (): Promise<void> => {
    formFilters.value = {
      pageNum: 1,
      businessType: undefined,
      applicantName: undefined
    }
    await resetSearchParams()
  }

  const openApprovalDialog = (row: ApprovalInstance) => {
    currentInstance.value = row
    approvalDialogVisible.value = true
  }

  const handleApprovalSuccess = async () => {
    await refreshData()
  }
</script>
