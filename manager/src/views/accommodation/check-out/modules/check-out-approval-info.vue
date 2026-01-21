<!-- 退宿申请审批信息组件 -->
<template>
  <ArtApprovalInfo
    :business-type="businessType"
    :business-id="businessId"
    @approval-success="handleApprovalSuccess"
  >
    <!-- 申请信息卡片 -->
    <ElCard v-if="checkOutData" class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:file-text-line" class="header-icon" />
          <span class="header-title">申请信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="checkOutData.campusName" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:map-pin-line" class="label-icon" />
            <span>校区</span>
          </div>
          <div class="row-value">{{ checkOutData.campusName }}</div>
        </div>
        <div v-if="checkOutData.roomCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
            <span>房间编码</span>
          </div>
          <div class="row-value is-code">{{ checkOutData.roomCode }}</div>
        </div>
        <div v-if="checkOutData.bedCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
            <span>床位编码</span>
          </div>
          <div class="row-value is-code">{{ checkOutData.bedCode }}</div>
        </div>
        <div v-if="checkOutData.applyDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-line" class="label-icon" />
            <span>申请日期</span>
          </div>
          <div class="row-value">{{ checkOutData.applyDate }}</div>
        </div>
        <div v-if="checkOutData.checkOutDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>退宿日期</span>
          </div>
          <div class="row-value">{{ checkOutData.checkOutDate }}</div>
        </div>
        <div v-if="checkOutData.checkOutReason" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-edit-line" class="label-icon" />
            <span>退宿理由</span>
          </div>
          <div class="row-value">{{ checkOutData.checkOutReason }}</div>
        </div>
        <div v-if="checkOutData.remark" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:sticky-note-line" class="label-icon" />
            <span>备注</span>
          </div>
          <div class="row-value">{{ checkOutData.remark }}</div>
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
  import { fetchGetCheckOutDetail } from '@/api/accommodation-manage'

  defineOptions({ name: 'CheckOutApprovalInfo' })

  interface Props {
    /** 业务类型 */
    businessType: 'check_out'
    /** 业务ID（退宿申请ID） */
    businessId: number | null
    /** 退宿申请数据（可选，用于显示申请信息） */
    checkOutData?: Api.AccommodationManage.CheckOutListItem | null
  }

  interface Emits {
    (e: 'approval-success'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const checkOutData = ref<Api.AccommodationManage.CheckOutListItem | null>(
    props.checkOutData || null
  )

  // 加载申请信息
  const loadCheckOutData = async () => {
    if (!props.businessId) {
      checkOutData.value = null
      return
    }

    // 如果没有传入 checkOutData，则通过 businessId 获取
    if (!props.checkOutData && props.businessId) {
      try {
        checkOutData.value = await fetchGetCheckOutDetail(props.businessId)
      } catch (error) {
        console.warn('加载申请信息失败:', error)
        checkOutData.value = null
      }
    } else {
      checkOutData.value = props.checkOutData || null
    }
  }

  // 监听 checkOutData prop 变化
  watch(
    () => props.checkOutData,
    (newVal) => {
      if (newVal) {
        checkOutData.value = newVal
      }
    },
    { immediate: true }
  )

  // 监听业务ID变化
  watch(
    () => props.businessId,
    () => {
      loadCheckOutData()
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
