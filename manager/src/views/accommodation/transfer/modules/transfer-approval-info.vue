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
            <div class="row-value">{{ transferData.originalCampusName }}</div>
          </div>
          <div v-if="transferData.originalRoomCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
              <span>原房间</span>
            </div>
            <div class="row-value is-code">{{ transferData.originalRoomCode }}</div>
          </div>
          <div v-if="transferData.originalBedCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
              <span>原床位</span>
            </div>
            <div class="row-value is-code">{{ transferData.originalBedCode }}</div>
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
            <div class="row-value">{{ transferData.targetCampusName }}</div>
          </div>
          <div v-if="transferData.targetRoomCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
              <span>目标房间</span>
            </div>
            <div class="row-value is-code">{{ transferData.targetRoomCode }}</div>
          </div>
          <div v-if="transferData.targetBedCode" class="info-row">
            <div class="row-label">
              <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
              <span>目标床位</span>
            </div>
            <div class="row-value is-code">{{ transferData.targetBedCode }}</div>
          </div>
        </div>

        <!-- 其他信息 -->
        <div v-if="transferData.applyDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-line" class="label-icon" />
            <span>申请日期</span>
          </div>
          <div class="row-value">{{ transferData.applyDate }}</div>
        </div>
        <div v-if="transferData.transferDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>调宿日期</span>
          </div>
          <div class="row-value">{{ transferData.transferDate }}</div>
        </div>
        <div v-if="transferData.transferReason" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-edit-line" class="label-icon" />
            <span>调宿理由</span>
          </div>
          <div class="row-value">{{ transferData.transferReason }}</div>
        </div>
        <div v-if="transferData.remark" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:sticky-note-line" class="label-icon" />
            <span>备注</span>
          </div>
          <div class="row-value">{{ transferData.remark }}</div>
        </div>
      </div>
    </ElCard>
  </ArtApprovalInfo>
</template>

<script setup lang="ts">
  import { ref, watch } from 'vue'
  import { ElCard } from 'element-plus'
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
    border: 1px solid var(--el-border-color-lighter);
    border-radius: var(--el-border-radius-base);
    transition: all 0.3s;

    &:hover {
      border-color: var(--el-color-primary-light-7);
      box-shadow: 0 2px 12px 0 rgb(0 0 0 / 10%);
    }

    :deep(.el-card__header) {
      padding: 12px 16px;
      background: linear-gradient(
        135deg,
        var(--el-fill-color-lighter) 0%,
        color-mix(in srgb, var(--el-color-primary) 6%, var(--el-bg-color)) 100%
      );
      border-bottom: 1px solid var(--el-border-color-lighter);
    }

    :deep(.el-card__body) {
      padding: 4px 16px;
    }

    .card-header {
      display: flex;
      gap: 8px;
      align-items: center;

      .header-icon {
        font-size: 18px;
        color: var(--el-color-primary);
      }

      .header-title {
        font-size: 15px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
    }

    .info-list {
      display: flex;
      flex-direction: column;
      gap: 0;
    }

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

    .info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid var(--el-border-color-extra-light);

      &:last-of-type {
        border-bottom: none;
      }

      .row-label {
        display: flex;
        gap: 8px;
        align-items: center;
        font-size: 13px;
        color: var(--el-text-color-secondary);

        .label-icon {
          width: 16px;
          height: 16px;
          color: var(--el-text-color-placeholder);
        }
      }

      .row-value {
        display: flex;
        gap: 6px;
        align-items: center;
        font-size: 13px;
        font-weight: 500;
        color: var(--el-text-color-primary);

        &.is-code {
          padding: 2px 8px;
          font-family: 'SF Mono', Menlo, Consolas, monospace;
          font-size: 12px;
          color: var(--el-color-primary);
          background: var(--el-color-primary-light-9);
          border-radius: 4px;
        }
      }
    }
  }
</style>
