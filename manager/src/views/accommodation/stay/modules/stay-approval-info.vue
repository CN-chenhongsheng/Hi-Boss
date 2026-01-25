<!-- 留宿申请审批信息组件 -->
<template>
  <ArtApprovalInfo
    :business-type="businessType"
    :business-id="businessId"
    @approval-success="handleApprovalSuccess"
  >
    <!-- 申请信息卡片 -->
    <ElCard v-if="stayData" class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:file-text-line" class="header-icon" />
          <span class="header-title">申请信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="stayData.campusName" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:map-pin-line" class="label-icon" />
            <span>校区</span>
          </div>
          <ElTooltip
            :content="stayData.campusName"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.campusName)"
          >
            <div class="row-value">{{ stayData.campusName }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.roomCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
            <span>房间编码</span>
          </div>
          <ElTooltip
            :content="stayData.roomCode"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.roomCode)"
          >
            <div class="row-value is-code">{{ stayData.roomCode }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.bedCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
            <span>床位编码</span>
          </div>
          <ElTooltip
            :content="stayData.bedCode"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.bedCode)"
          >
            <div class="row-value is-code">{{ stayData.bedCode }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.applyDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-line" class="label-icon" />
            <span>申请日期</span>
          </div>
          <ElTooltip
            :content="stayData.applyDate"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.applyDate)"
          >
            <div class="row-value">{{ stayData.applyDate }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.stayStartDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>留宿开始日期</span>
          </div>
          <ElTooltip
            :content="stayData.stayStartDate"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.stayStartDate)"
          >
            <div class="row-value">{{ stayData.stayStartDate }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.stayEndDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-close-line" class="label-icon" />
            <span>留宿结束日期</span>
          </div>
          <ElTooltip
            :content="stayData.stayEndDate"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.stayEndDate)"
          >
            <div class="row-value">{{ stayData.stayEndDate }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.stayReason" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-edit-line" class="label-icon" />
            <span>留宿理由</span>
          </div>
          <ElTooltip
            :content="stayData.stayReason"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.stayReason)"
          >
            <div class="row-value">{{ stayData.stayReason }}</div>
          </ElTooltip>
        </div>
        <div v-if="stayData.remark" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:sticky-note-line" class="label-icon" />
            <span>备注</span>
          </div>
          <ElTooltip
            :content="stayData.remark"
            placement="bottom"
            popper-class="info-card-tooltip"
            :disabled="!isTextOverflow(stayData.remark)"
          >
            <div class="row-value">{{ stayData.remark }}</div>
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
  import { fetchGetStayDetail } from '@/api/accommodation-manage'

  defineOptions({ name: 'StayApprovalInfo' })

  interface Props {
    /** 业务类型 */
    businessType: 'stay'
    /** 业务ID（留宿申请ID） */
    businessId: number | null
    /** 留宿申请数据（可选，用于显示申请信息） */
    stayData?: Api.AccommodationManage.StayListItem | null
  }

  interface Emits {
    (e: 'approval-success'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const stayData = ref<Api.AccommodationManage.StayListItem | null>(props.stayData || null)

  // 判断文字是否可能溢出
  const isTextOverflow = (text: string | undefined): boolean => {
    if (!text) return false
    return text.length > 30
  }

  // 加载申请信息
  const loadStayData = async () => {
    if (!props.businessId) {
      stayData.value = null
      return
    }

    // 如果没有传入 stayData，则通过 businessId 获取
    if (!props.stayData && props.businessId) {
      try {
        stayData.value = await fetchGetStayDetail(props.businessId)
      } catch (error) {
        console.warn('加载申请信息失败:', error)
        stayData.value = null
      }
    } else {
      stayData.value = props.stayData || null
    }
  }

  // 监听 stayData prop 变化
  watch(
    () => props.stayData,
    (newVal) => {
      if (newVal) {
        stayData.value = newVal
      }
    },
    { immediate: true }
  )

  // 监听业务ID变化
  watch(
    () => props.businessId,
    () => {
      loadStayData()
    },
    { immediate: true }
  )

  // 处理审批成功
  const handleApprovalSuccess = () => {
    emit('approval-success')
  }
</script>
