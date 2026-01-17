<!-- 入住申请审批信息组件 -->
<template>
  <div class="check-in-approval-info">
    <div v-loading="approvalLoading">
      <template v-if="approvalInstance">
        <!-- 审批状态 -->
        <ElDescriptions :column="2" border class="mb-4">
          <ElDescriptionsItem label="审批状态">
            <ElTag :type="getStatusType(approvalInstance.status)" size="small">
              {{ approvalInstance.statusText }}
            </ElTag>
          </ElDescriptionsItem>
          <ElDescriptionsItem label="当前节点">
            <ElTag v-if="approvalInstance.currentNodeName" type="warning" size="small">
              {{ approvalInstance.currentNodeName }}
            </ElTag>
            <span v-else>-</span>
          </ElDescriptionsItem>
          <ElDescriptionsItem label="审批流程">
            {{ approvalInstance.flowName }}
          </ElDescriptionsItem>
          <ElDescriptionsItem label="提交时间">
            {{ approvalInstance.startTime }}
          </ElDescriptionsItem>
        </ElDescriptions>

        <!-- 审批进度 -->
        <div class="mb-2 font-medium">审批进度</div>
        <ElTimeline v-if="approvalInstance.records?.length">
          <ElTimelineItem
            v-for="record in approvalInstance.records"
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
            <div class="text-gray-500 text-sm mt-1">审批人：{{ record.approverName }}</div>
            <div v-if="record.opinion" class="text-gray-600 mt-1">意见：{{ record.opinion }}</div>
          </ElTimelineItem>
        </ElTimeline>
        <ElEmpty v-else description="暂无审批记录" :image-size="60" />

        <!-- 审批操作 -->
        <template v-if="approvalInstance.canApprove && approvalInstance.status === 1">
          <ElDivider />
          <div class="mb-2 font-medium">审批操作</div>
          <ElForm label-width="80px">
            <ElFormItem label="审批意见">
              <ElInput
                v-model="approvalOpinion"
                type="textarea"
                :rows="2"
                placeholder="请输入审批意见（可选）"
              />
            </ElFormItem>
            <ElFormItem>
              <ElSpace>
                <ElButton type="danger" :loading="rejectLoading" @click="handleApprove(2)" v-ripple>
                  拒绝
                </ElButton>
                <ElButton
                  type="primary"
                  :loading="approveLoading"
                  @click="handleApprove(1)"
                  v-ripple
                >
                  通过
                </ElButton>
              </ElSpace>
            </ElFormItem>
          </ElForm>
        </template>
      </template>

      <!-- 未发起审批 -->
      <ElEmpty v-else description="该申请尚未发起审批流程" :image-size="80" />
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, watch } from 'vue'
  import {
    ElDescriptions,
    ElDescriptionsItem,
    ElTag,
    ElTimeline,
    ElTimelineItem,
    ElEmpty,
    ElDivider,
    ElForm,
    ElFormItem,
    ElInput,
    ElButton,
    ElSpace,
    ElMessage,
    ElMessageBox
  } from 'element-plus'
  import {
    fetchGetInstanceByBusiness,
    fetchDoApprove,
    type ApprovalInstance
  } from '@/api/approval-manage'

  defineOptions({ name: 'CheckInApprovalInfo' })

  interface Props {
    /** 业务类型 */
    businessType: 'check_in'
    /** 业务ID（入住申请ID） */
    businessId: number | null
  }

  interface Emits {
    (e: 'approval-success'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const approvalLoading = ref(false)
  const approveLoading = ref(false)
  const rejectLoading = ref(false)
  const approvalInstance = ref<ApprovalInstance | null>(null)
  const approvalOpinion = ref('')

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

  const loadApprovalInfo = async () => {
    if (!props.businessId) {
      approvalInstance.value = null
      return
    }

    approvalLoading.value = true
    try {
      approvalInstance.value = await fetchGetInstanceByBusiness(
        props.businessType,
        props.businessId
      )
    } catch (error) {
      console.error('加载审批信息失败:', error)
      approvalInstance.value = null
    } finally {
      approvalLoading.value = false
    }
  }

  const handleApprove = async (action: 1 | 2) => {
    if (!approvalInstance.value) return

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
        instanceId: approvalInstance.value.id,
        action,
        opinion: approvalOpinion.value || undefined
      })

      ElMessage.success(`审批${actionText}成功`)
      approvalOpinion.value = ''

      // 重新加载审批信息
      await loadApprovalInfo()

      emit('approval-success')
    } catch (error) {
      if (error !== 'cancel') {
        console.error('审批失败:', error)
      }
    } finally {
      approveLoading.value = false
      rejectLoading.value = false
    }
  }

  // 监听业务ID变化
  watch(
    () => props.businessId,
    () => {
      loadApprovalInfo()
    },
    { immediate: true }
  )
</script>

<style lang="scss" scoped>
  .check-in-approval-info {
    .mb-2 {
      margin-bottom: 8px;
    }

    .mb-4 {
      margin-bottom: 16px;
    }

    .mt-1 {
      margin-top: 4px;
    }

    .font-medium {
      font-weight: 500;
    }

    .text-gray-500 {
      color: var(--el-text-color-secondary);
    }

    .text-gray-600 {
      color: var(--el-text-color-regular);
    }

    .text-sm {
      font-size: 13px;
    }

    .flex {
      display: flex;
    }

    .items-center {
      align-items: center;
    }

    .gap-2 {
      gap: 8px;
    }
  }
</style>
