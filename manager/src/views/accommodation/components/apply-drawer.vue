<!-- 申请详情抽屉（通用组件） -->
<template>
  <ElDrawer
    v-model="drawerVisible"
    :title="drawerTitle"
    size="600px"
    :close-on-click-modal="false"
    destroy-on-close
    @opened="loadApprovalInfo"
  >
    <ElTabs v-model="activeTab">
      <!-- 申请详情 -->
      <ElTabPane label="申请详情" name="detail">
        <slot name="detail">
          <ElEmpty description="暂无详情信息" />
        </slot>
      </ElTabPane>

      <!-- 审批信息 -->
      <ElTabPane label="审批信息" name="approval">
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
                <div class="text-gray-500 text-sm mt-1"> 审批人：{{ record.approverName }} </div>
                <div v-if="record.opinion" class="text-gray-600 mt-1">
                  意见：{{ record.opinion }}
                </div>
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
                    <ElButton
                      type="danger"
                      :loading="rejectLoading"
                      @click="handleApprove(2)"
                      v-ripple
                    >
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
      </ElTabPane>
    </ElTabs>
  </ElDrawer>
</template>

<script setup lang="ts">
  import {
    fetchGetInstanceByBusiness,
    fetchDoApprove,
    type ApprovalInstance
  } from '@/api/approval-manage'
  import { ElMessage, ElMessageBox } from 'element-plus'

  const props = defineProps<{
    modelValue: boolean
    businessType: 'check_in' | 'transfer' | 'check_out' | 'stay'
    businessId: number | null
    title?: string
  }>()

  const emit = defineEmits<{
    'update:modelValue': [value: boolean]
    'approval-success': []
  }>()

  const drawerVisible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  const drawerTitle = computed(() => {
    const typeMap: Record<string, string> = {
      check_in: '入住申请详情',
      transfer: '调宿申请详情',
      check_out: '退宿申请详情',
      stay: '留宿申请详情'
    }
    return props.title || typeMap[props.businessType] || '申请详情'
  })

  const activeTab = ref('detail')
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
    if (!props.businessId) return

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
</script>
