<!-- 审批记录页面 -->
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
            <ElFormItem label="审批人">
              <ElInput
                v-model="formFilters.approverName"
                placeholder="请输入审批人姓名"
                clearable
                @keyup.enter="handleSearch"
              />
            </ElFormItem>
          </ElCol>
          <ElCol :xs="24" :sm="12" :md="8" :lg="6">
            <ElFormItem label="审批结果">
              <ElSelect
                v-model="formFilters.action"
                placeholder="请选择审批结果"
                clearable
                style="width: 100%"
              >
                <ElOption label="通过" :value="1" />
                <ElOption label="拒绝" :value="2" />
              </ElSelect>
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
      >
        <template #left>
          <ElRadioGroup v-model="viewMode" @change="handleViewModeChange">
            <ElRadioButton value="all">全部记录</ElRadioButton>
            <ElRadioButton value="my">我的审批</ElRadioButton>
          </ElRadioGroup>
        </template>
      </ArtTableHeader>

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
  </div>
</template>

<script setup lang="ts">
  import { onMounted } from 'vue'
  import { useTable } from '@/hooks/core/useTable'
  import {
    fetchGetRecordList,
    fetchGetMyRecordList,
    type ApprovalRecord,
    type ApprovalRecordQueryParams
  } from '@/api/approval-manage'
  import { ElTag } from 'element-plus'
  import { useBusinessType } from '@/hooks'

  defineOptions({ name: 'ApprovalHistory' })

  // 业务类型（从字典获取）
  const { businessTypeOptions, fetchBusinessTypes } = useBusinessType()

  onMounted(() => {
    fetchBusinessTypes()
  })

  // 搜索相关
  const formFilters = ref({
    pageNum: 1,
    businessType: undefined,
    applicantName: undefined,
    approverName: undefined,
    action: undefined
  })
  const showSearchBar = ref(false)
  const viewMode = ref<'all' | 'my'>('all')

  // 动态API函数
  const getApiFn = () => {
    return viewMode.value === 'my' ? fetchGetMyRecordList : fetchGetRecordList
  }

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
      apiFn: getApiFn(),
      apiParams: computed(
        () =>
          ({
            pageNum: formFilters.value.pageNum,
            businessType: formFilters.value.businessType || undefined,
            applicantName: formFilters.value.applicantName || undefined,
            approverName: formFilters.value.approverName || undefined,
            action: formFilters.value.action
          }) as ApprovalRecordQueryParams
      ),
      paginationKey: {
        current: 'pageNum',
        size: 'pageSize'
      },
      columnsFactory: () => [
        {
          prop: 'businessType',
          label: '业务类型',
          width: 120,
          formatter: (row: ApprovalRecord) => {
            return h(ElTag, { type: 'info', size: 'small' }, () => row.businessTypeText)
          }
        },
        {
          prop: 'applicantName',
          label: '申请人',
          width: 100
        },
        {
          prop: 'flowName',
          label: '审批流程',
          minWidth: 150
        },
        {
          prop: 'nodeName',
          label: '审批节点',
          width: 120
        },
        {
          prop: 'approverName',
          label: '审批人',
          width: 100
        },
        {
          prop: 'action',
          label: '审批结果',
          width: 100,
          formatter: (row: ApprovalRecord) => {
            return h(
              ElTag,
              {
                type: row.action === 1 ? 'success' : 'danger',
                size: 'small'
              },
              () => row.actionText
            )
          }
        },
        {
          prop: 'opinion',
          label: '审批意见',
          minWidth: 200,
          showOverflowTooltip: true
        },
        {
          prop: 'approveTime',
          label: '审批时间',
          width: 180,
          sortable: true
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
      applicantName: undefined,
      approverName: undefined,
      action: undefined
    }
    await resetSearchParams()
  }

  const handleViewModeChange = async () => {
    formFilters.value.pageNum = 1
    // 重新获取数据需要更新API函数
    await getData()
  }
</script>
