<!-- 调宿申请审批信息组件 -->
<template>
  <ArtApprovalInfo
    :business-type="businessType"
    :business-id="businessId"
    @approval-success="handleApprovalSuccess"
  >
    <!-- 申请信息卡片 -->
    <ElCard v-if="transferData" class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:file-text-line" class="header-icon" />
          <span class="header-title">申请信息</span>
        </div>
      </template>
      <div class="info-list">
        <!-- 原住宿信息 -->
        <div class="info-section">
          <div class="section-title">原住宿信息</div>
          <div v-if="transferData.originalCampusName" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:map-pin-line" class="label-icon" />
              <span>原校区</span>
            </div>
            <ElTooltip
              :content="transferData.originalCampusName"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.originalCampusName)"
            >
              <div class="row-value">{{ transferData.originalCampusName }}</div>
            </ElTooltip>
          </div>
          <div v-if="transferData.originalRoomCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
              <span>原房间</span>
            </div>
            <ElTooltip
              :content="transferData.originalRoomCode"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.originalRoomCode)"
            >
              <div class="row-value is-code">{{ transferData.originalRoomCode }}</div>
            </ElTooltip>
          </div>
          <div v-if="transferData.originalBedCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
              <span>原床位</span>
            </div>
            <ElTooltip
              :content="transferData.originalBedCode"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.originalBedCode)"
            >
              <div class="row-value is-code">{{ transferData.originalBedCode }}</div>
            </ElTooltip>
          </div>
        </div>

        <!-- 目标住宿信息 -->
        <div class="info-section">
          <div class="section-title">目标住宿信息</div>
          <div v-if="transferData.targetCampusName" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:map-pin-line" class="label-icon" />
              <span>目标校区</span>
            </div>
            <ElTooltip
              :content="transferData.targetCampusName"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.targetCampusName)"
            >
              <div class="row-value">{{ transferData.targetCampusName }}</div>
            </ElTooltip>
          </div>
          <div v-if="transferData.targetRoomCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
              <span>目标房间</span>
            </div>
            <ElTooltip
              :content="transferData.targetRoomCode"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.targetRoomCode)"
            >
              <div class="row-value is-code">{{ transferData.targetRoomCode }}</div>
            </ElTooltip>
          </div>
          <div v-if="transferData.targetBedCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
              <span>目标床位</span>
            </div>
            <ElTooltip
              :content="transferData.targetBedCode"
              placement="bottom"
              popper-class="info-card-tooltip"
              :disabled="!isTextOverflow(transferData.targetBedCode)"
            >
              <div class="row-value is-code">{{ transferData.targetBedCode }}</div>
            </ElTooltip>
          </div>
        </div>

        <!-- 其他信息 -->
        <div v-if="transferData.applyDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-line" class="label-icon" />
            <span>申请日期</span>
          </div>
          <ElTooltip
            :content="transferData.applyDate"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(transferData.applyDate)"
          >
            <div class="row-value">{{ transferData.applyDate }}</div>
          </ElTooltip>
        </div>
        <div v-if="transferData.transferDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>调宿日期</span>
          </div>
          <ElTooltip
            :content="transferData.transferDate"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(transferData.transferDate)"
          >
            <div class="row-value">{{ transferData.transferDate }}</div>
          </ElTooltip>
        </div>
        <div v-if="transferData.transferReason" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-edit-line" class="label-icon" />
            <span>调宿理由</span>
          </div>
          <ElTooltip
            :content="transferData.transferReason"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(transferData.transferReason)"
          >
            <div class="row-value">{{ transferData.transferReason }}</div>
          </ElTooltip>
        </div>
        <div v-if="transferData.remark" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:sticky-note-line" class="label-icon" />
            <span>备注</span>
          </div>
          <ElTooltip
            :content="transferData.remark"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(transferData.remark)"
          >
            <div class="row-value">{{ transferData.remark }}</div>
          </ElTooltip>
        </div>
      </div>
    </ElCard>
  </ArtApprovalInfo>
</template>

<script setup lang="ts">
  import { ref, watch } from 'vue'
  import { ElCard, ElTooltip } from 'element-plus'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import ArtApprovalInfo from '@/components/core/layouts/art-approval-info/index.vue'
  import { fetchGetTransferDetail } from '@/api/accommodation-manage'

  defineOptions({ name: 'TransferApprovalInfo' })

  interface Props {
    /** 业务类型 */
    businessType: 'transfer'
    /** 业务ID（调宿申请ID） */
    businessId: number | null
    /** 调宿申请数据（可选，用于显示申请信息） */
    transferData?: Api.AccommodationManage.TransferListItem | null
  }

  interface Emits {
    (e: 'approval-success'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const transferData = ref<Api.AccommodationManage.TransferListItem | null>(
    props.transferData || null
  )

  // 判断文字是否可能溢出
  const isTextOverflow = (text: string | undefined): boolean => {
    if (!text) return false
    return text.length > 30
  }

  // 加载申请信息
  const loadTransferData = async () => {
    if (!props.businessId) {
      transferData.value = null
      return
    }

    // 如果没有传入 transferData，则通过 businessId 获取
    if (!props.transferData && props.businessId) {
      try {
        transferData.value = await fetchGetTransferDetail(props.businessId)
      } catch (error) {
        console.warn('加载申请信息失败:', error)
        transferData.value = null
      }
    } else {
      transferData.value = props.transferData || null
    }
  }

  // 监听 transferData prop 变化
  watch(
    () => props.transferData,
    (newVal) => {
      if (newVal) {
        transferData.value = newVal
      }
    },
    { immediate: true }
  )

  // 监听业务ID变化
  watch(
    () => props.businessId,
    () => {
      loadTransferData()
    },
    { immediate: true }
  )

  // 处理审批成功
  const handleApprovalSuccess = () => {
    emit('approval-success')
  }
</script>

<style lang="scss" scoped>
  .info-card {
    .info-section {
      padding: 12px 0;
      border-bottom: 1px solid var(--el-border-color-extra-light);

      .section-title {
        margin-bottom: 8px;
        font-size: 14px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
    }
  }
</style>
