<!-- 待办审批信息组件 -->
<template>
  <ArtApprovalInfo
    :business-type="businessType"
    :business-id="businessId"
    @approval-success="handleApprovalSuccess"
  >
    <!-- 申请信息卡片 -->
    <ElCard v-if="businessData" class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:file-text-line" class="header-icon" />
          <span class="header-title">申请信息</span>
        </div>
      </template>
      <div class="info-list">
        <!-- 业务类型 -->
        <div class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-list-line" class="label-icon" />
            <span>业务类型</span>
          </div>
          <div class="row-value">
            <ElTag type="info" size="small">{{ businessTypeText }}</ElTag>
          </div>
        </div>
        <!-- 入住类型（入住申请特有） -->
        <div v-if="businessType === 'check_in' && businessData.checkInTypeText" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:home-line" class="label-icon" />
            <span>入住类型</span>
          </div>
          <div class="row-value">
            <ElTag :type="businessData.checkInType === 1 ? 'primary' : 'warning'" size="small">
              {{ businessData.checkInTypeText }}
            </ElTag>
          </div>
        </div>
        <!-- 调宿类型（调宿申请特有） -->
        <div v-if="businessType === 'transfer' && businessData.transferTypeText" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:swap-line" class="label-icon" />
            <span>调宿类型</span>
          </div>
          <div class="row-value">
            <ElTag type="primary" size="small">{{ businessData.transferTypeText }}</ElTag>
          </div>
        </div>
        <!-- 留宿类型（留宿申请特有） -->
        <div v-if="businessType === 'stay' && businessData.stayTypeText" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:moon-line" class="label-icon" />
            <span>留宿类型</span>
          </div>
          <div class="row-value">
            <ElTag type="primary" size="small">{{ businessData.stayTypeText }}</ElTag>
          </div>
        </div>
        <!-- 校区 -->
        <div v-if="businessData.campusName" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:map-pin-line" class="label-icon" />
            <span>校区</span>
          </div>
          <div class="row-value">{{ businessData.campusName }}</div>
        </div>
        <!-- 房间编码 -->
        <div v-if="businessData.roomCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
            <span>房间编码</span>
          </div>
          <div class="row-value is-code">{{ businessData.roomCode }}</div>
        </div>
        <!-- 床位编码 -->
        <div v-if="businessData.bedCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
            <span>床位编码</span>
          </div>
          <div class="row-value is-code">{{ businessData.bedCode }}</div>
        </div>
        <!-- 申请日期 -->
        <div v-if="businessData.applyDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-line" class="label-icon" />
            <span>申请日期</span>
          </div>
          <div class="row-value">{{ businessData.applyDate }}</div>
        </div>
        <!-- 入住日期（入住申请特有） -->
        <div v-if="businessType === 'check_in' && businessData.checkInDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>入住日期</span>
          </div>
          <div class="row-value">{{ businessData.checkInDate }}</div>
        </div>
        <!-- 退宿日期（退宿申请特有） -->
        <div v-if="businessType === 'check_out' && businessData.checkOutDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-close-line" class="label-icon" />
            <span>退宿日期</span>
          </div>
          <div class="row-value">{{ businessData.checkOutDate }}</div>
        </div>
        <!-- 开始/结束日期（留宿申请特有） -->
        <div v-if="businessType === 'stay' && businessData.startDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-2-line" class="label-icon" />
            <span>留宿开始</span>
          </div>
          <div class="row-value">{{ businessData.startDate }}</div>
        </div>
        <div v-if="businessType === 'stay' && businessData.endDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-2-line" class="label-icon" />
            <span>留宿结束</span>
          </div>
          <div class="row-value">{{ businessData.endDate }}</div>
        </div>
        <!-- 申请原因 -->
        <div v-if="businessData.applyReason" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-edit-line" class="label-icon" />
            <span>申请原因</span>
          </div>
          <div class="row-value">{{ businessData.applyReason }}</div>
        </div>
        <!-- 备注 -->
        <div v-if="businessData.remark" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:sticky-note-line" class="label-icon" />
            <span>备注</span>
          </div>
          <div class="row-value">{{ businessData.remark }}</div>
        </div>
      </div>
    </ElCard>
  </ArtApprovalInfo>
</template>

<script setup lang="ts">
  import { ref, watch, computed } from 'vue'
  import { ElCard, ElTag } from 'element-plus'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import ArtApprovalInfo from '@/components/core/layouts/art-approval-info/index.vue'
  import {
    fetchGetCheckInDetail,
    fetchGetTransferDetail,
    fetchGetCheckOutDetail,
    fetchGetStayDetail
  } from '@/api/accommodation-manage'

  defineOptions({ name: 'PendingApprovalInfo' })

  interface Props {
    /** 业务类型 */
    businessType: string
    /** 业务ID */
    businessId: number | null
  }

  interface Emits {
    (e: 'approval-success'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const businessData = ref<any>(null)

  // 业务类型文本映射
  const businessTypeText = computed(() => {
    switch (props.businessType) {
      case 'check_in':
        return '入住申请'
      case 'transfer':
        return '调宿申请'
      case 'check_out':
        return '退宿申请'
      case 'stay':
        return '留宿申请'
      default:
        return props.businessType
    }
  })

  // 加载业务数据
  const loadBusinessData = async () => {
    if (!props.businessId || !props.businessType) {
      businessData.value = null
      return
    }

    try {
      switch (props.businessType) {
        case 'check_in':
          businessData.value = await fetchGetCheckInDetail(props.businessId)
          break
        case 'transfer':
          businessData.value = await fetchGetTransferDetail(props.businessId)
          break
        case 'check_out':
          businessData.value = await fetchGetCheckOutDetail(props.businessId)
          break
        case 'stay':
          businessData.value = await fetchGetStayDetail(props.businessId)
          break
        default:
          businessData.value = null
      }
    } catch (error) {
      console.warn('加载业务数据失败:', error)
      businessData.value = null
    }
  }

  // 监听属性变化
  watch(
    () => [props.businessType, props.businessId],
    () => {
      loadBusinessData()
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
        #f8fafc 0%,
        color-mix(in srgb, var(--el-color-primary) 6%, #fff) 100%
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
