<!-- 审批弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    title="审批处理"
    width="700px"
    :close-on-click-modal="false"
    destroy-on-close
    @opened="loadInstanceDetail"
  >
    <div v-loading="detailLoading">
      <!-- 基本信息 -->
      <ElDescriptions :column="2" border>
        <ElDescriptionsItem label="业务类型">
          <ElTag type="info" size="small">{{ instanceDetail?.businessTypeText }}</ElTag>
        </ElDescriptionsItem>
        <ElDescriptionsItem label="申请人">{{ instanceDetail?.applicantName }}</ElDescriptionsItem>
        <ElDescriptionsItem label="审批流程">{{ instanceDetail?.flowName }}</ElDescriptionsItem>
        <ElDescriptionsItem label="当前节点">
          <ElTag type="warning" size="small">{{ instanceDetail?.currentNodeName }}</ElTag>
        </ElDescriptionsItem>
        <ElDescriptionsItem label="提交时间">{{ instanceDetail?.startTime }}</ElDescriptionsItem>
        <ElDescriptionsItem label="审批状态">
          <ElTag :type="getStatusType(instanceDetail?.status)" size="small">
            {{ instanceDetail?.statusText }}
          </ElTag>
        </ElDescriptionsItem>
      </ElDescriptions>

      <!-- 审批进度 -->
      <ElDivider content-position="left">
        <span class="text-base font-medium">审批进度</span>
      </ElDivider>

      <ElTimeline v-if="instanceDetail?.records && instanceDetail.records.length > 0">
        <ElTimelineItem
          v-for="record in instanceDetail.records"
          :key="record.id"
          :type="record.action === 1 ? 'success' : 'danger'"
          :timestamp="record.approveTime"
          placement="top"
        >
          <div class="flex items-center gap-2">
            <span class="font-medium">{{ record.nodeName }}</span>
            <ElTag :type="record.action === 1 ? 'success' : 'danger'" size="small">
              {{ record.actionText }}
            </ElTag>
          </div>
          <div class="text-gray-500 text-sm mt-1"> 审批人：{{ record.approverName }} </div>
          <div v-if="record.opinion" class="text-gray-600 mt-1"> 意见：{{ record.opinion }} </div>
        </ElTimelineItem>
      </ElTimeline>
      <ElEmpty v-else description="暂无审批记录" :image-size="60" />

      <!-- 审批操作 -->
      <ElDivider content-position="left">
        <span class="text-base font-medium">审批操作</span>
      </ElDivider>

      <ElForm
        v-if="instanceDetail?.canApprove"
        ref="formRef"
        :model="approvalForm"
        label-width="80px"
      >
        <ElFormItem label="审批意见">
          <ElInput
            v-model="approvalForm.opinion"
            type="textarea"
            :rows="3"
            placeholder="请输入审批意见（可选）"
          />
        </ElFormItem>
      </ElForm>
      <div v-else class="text-center text-gray-400 py-4"> 您没有权限审批此申请 </div>
    </div>

    <template #footer>
      <ElButton @click="dialogVisible = false" v-ripple>关闭</ElButton>
      <template v-if="instanceDetail?.canApprove">
        <ElButton type="danger" :loading="rejectLoading" @click="handleApprove(2)" v-ripple>
          拒绝
        </ElButton>
        <ElButton type="primary" :loading="approveLoading" @click="handleApprove(1)" v-ripple>
          通过
        </ElButton>
      </template>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import {
    fetchGetInstanceDetail,
    fetchDoApprove,
    type ApprovalInstance
  } from '@/api/approval-manage'
  import { ElMessage, ElMessageBox } from 'element-plus'

  const props = defineProps<{
    modelValue: boolean
    instanceData: ApprovalInstance | null
  }>()

  const emit = defineEmits<{
    'update:modelValue': [value: boolean]
    success: []
  }>()

  const dialogVisible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  const detailLoading = ref(false)
  const approveLoading = ref(false)
  const rejectLoading = ref(false)
  const instanceDetail = ref<ApprovalInstance | null>(null)

  const approvalForm = reactive({
    opinion: ''
  })

  const getStatusType = (status?: number) => {
    switch (status) {
      case 1:
        return 'warning'
      case 2:
        return 'success'
      case 3:
        return 'danger'
      case 4:
        return 'info'
      default:
        return 'info'
    }
  }

  const loadInstanceDetail = async () => {
    if (!props.instanceData?.id) return

    detailLoading.value = true
    try {
      instanceDetail.value = await fetchGetInstanceDetail(props.instanceData.id)
    } catch (error) {
      console.error('加载详情失败:', error)
    } finally {
      detailLoading.value = false
    }
  }

  const handleApprove = async (action: 1 | 2) => {
    const actionText = action === 1 ? '通过' : '拒绝'

    try {
      await ElMessageBox.confirm(`确定要${actionText}该申请吗？`, `确认${actionText}`, {
        type: action === 1 ? 'success' : 'warning'
      })

      if (action === 1) {
        approveLoading.value = true
      } else {
        rejectLoading.value = true
      }

      await fetchDoApprove({
        instanceId: instanceDetail.value!.id,
        action,
        opinion: approvalForm.opinion || undefined
      })

      ElMessage.success(`审批${actionText}成功`)
      dialogVisible.value = false
      emit('success')
    } catch (error) {
      if (error !== 'cancel') {
        console.error('审批失败:', error)
      }
    } finally {
      approveLoading.value = false
      rejectLoading.value = false
    }
  }
</script>
