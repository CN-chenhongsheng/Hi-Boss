<template>
  <view class="detail-page">
    <view v-if="loading" class="loading">
      <view class="loading-spinner" />
      <view class="loading-text">
        加载中...
      </view>
    </view>

    <view v-else-if="detail" class="detail-content">
      <!-- 状态卡片 -->
      <view class="status-card">
        <view class="status-icon" :style="{ background: getStatusColor(detail.status) }">
          <u-icon :name="getStatusIcon(detail.status)" size="32" color="#fff" />
        </view>
        <view class="status-info">
          <view class="status-text">
            {{ getStatusText(detail.status) }}
          </view>
          <view class="apply-date">
            申请时间：{{ detail.applyDate }}
          </view>
        </view>
      </view>

      <!-- 申请信息 -->
      <view class="info-card">
        <view class="card-title">
          申请信息
        </view>
        <view class="info-list">
          <view v-if="applyType === 'checkIn'" class="info-item">
            <text class="label">
              入住类型：
            </text>
            <text class="value">
              {{ detail.checkInType === 1 ? '长期住宿' : '临时住宿' }}
            </text>
          </view>
          <view v-if="applyType === 'checkIn'" class="info-item">
            <text class="label">
              入住日期：
            </text>
            <text class="value">
              {{ detail.checkInDate }}
            </text>
          </view>
          <view v-if="applyType === 'checkIn' && detail.checkInType === 2" class="info-item">
            <text class="label">
              预计退宿日期：
            </text>
            <text class="value">
              {{ detail.expectedCheckOutDate }}
            </text>
          </view>
          <view v-if="applyType === 'transfer'" class="info-item">
            <text class="label">
              调宿日期：
            </text>
            <text class="value">
              {{ detail.transferDate }}
            </text>
          </view>
          <view v-if="applyType === 'checkOut'" class="info-item">
            <text class="label">
              退宿日期：
            </text>
            <text class="value">
              {{ detail.checkOutDate }}
            </text>
          </view>
          <view v-if="applyType === 'stay'" class="info-item">
            <text class="label">
              留宿开始日期：
            </text>
            <text class="value">
              {{ detail.stayStartDate }}
            </text>
          </view>
          <view v-if="applyType === 'stay'" class="info-item">
            <text class="label">
              留宿结束日期：
            </text>
            <text class="value">
              {{ detail.stayEndDate }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              申请原因：
            </text>
            <text class="value">
              {{ getApplyReason(detail) }}
            </text>
          </view>
        </view>
      </view>

      <!-- 审批信息 -->
      <view v-if="detail.approveTime" class="info-card">
        <view class="card-title">
          审批信息
        </view>
        <view class="info-list">
          <view class="info-item">
            <text class="label">
              审批人：
            </text>
            <text class="value">
              {{ detail.approverName || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              审批时间：
            </text>
            <text class="value">
              {{ detail.approveTime }}
            </text>
          </view>
          <view v-if="detail.approveOpinion" class="info-item">
            <text class="label">
              审批意见：
            </text>
            <text class="value">
              {{ detail.approveOpinion }}
            </text>
          </view>
        </view>
      </view>

      <!-- 操作按钮 -->
      <view v-if="detail.status === 1" class="btn-group">
        <u-button type="error" @click="handleCancel">
          撤回申请
        </u-button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { ApplyStatus, ApplyStatusColor, ApplyStatusText } from '@/types';
import {
  getCheckInDetailAPI,
  getCheckOutDetailAPI,
  getStayDetailAPI,
  getTransferDetailAPI,
} from '@/api';

const loading = ref(false);
const detail = ref<any>(null);
const applyType = ref('');
const applyId = ref(0);

// 获取状态文本
function getStatusText(status: ApplyStatus) {
  return ApplyStatusText[status] || '未知';
}

// 获取状态颜色
function getStatusColor(status: ApplyStatus) {
  return ApplyStatusColor[status] || '#999';
}

// 获取状态图标
function getStatusIcon(status: ApplyStatus) {
  const iconMap: Record<ApplyStatus, string> = {
    [ApplyStatus.PENDING]: 'clock',
    [ApplyStatus.APPROVED]: 'checkmark-circle',
    [ApplyStatus.REJECTED]: 'close-circle',
    [ApplyStatus.DONE]: 'checkmark-circle-fill',
  };
  return iconMap[status] || 'info-circle';
}

// 获取申请原因
function getApplyReason(item: any) {
  return item.applyReason || item.transferReason || item.checkOutReason || item.stayReason || '-';
}

// 撤回申请
function handleCancel() {
  uni.showModal({
    title: '确认撤回',
    content: '确定要撤回此申请吗？',
    success: (res) => {
      if (res.confirm) {
        uni.showToast({
          title: '撤回成功',
          icon: 'success',
        });
        setTimeout(() => {
          uni.navigateBack();
        }, 1500);
      }
    },
  });
}

// 加载详情
async function loadDetail() {
  loading.value = true;
  try {
    let apiCall;
    switch (applyType.value) {
      case 'checkIn':
        apiCall = getCheckInDetailAPI;
        break;
      case 'transfer':
        apiCall = getTransferDetailAPI;
        break;
      case 'checkOut':
        apiCall = getCheckOutDetailAPI;
        break;
      case 'stay':
        apiCall = getStayDetailAPI;
        break;
      default:
        throw new Error('未知的申请类型');
    }

    detail.value = await apiCall(applyId.value);
  }
  catch (error) {
    console.error('加载失败:', error);
    uni.showToast({
      title: '加载失败',
      icon: 'none',
    });
  }
  finally {
    loading.value = false;
  }
}

onMounted(() => {
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1] as any;
  const options = currentPage.options || currentPage.$route.query;

  applyId.value = Number(options.id);
  applyType.value = options.type;

  if (applyId.value && applyType.value) {
    loadDetail();
  }
});
</script>

<style lang="scss" scoped>
.detail-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 100rpx 0;
  font-size: 28rpx;
  color: #999;
  flex-direction: column;

  .loading-spinner {
    width: 60rpx;
    height: 60rpx;
    border: 4rpx solid #f3f3f3;
    border-top: 4rpx solid #2196F3;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  .loading-text {
    margin-top: 20rpx;
  }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.detail-content {
  .status-card {
    display: flex;
    align-items: center;
    padding: 30rpx;
    margin-bottom: 20rpx;
    background: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .status-icon {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 24rpx;
      width: 100rpx;
      height: 100rpx;
      border-radius: 50%;
    }

    .status-info {
      flex: 1;

      .status-text {
        margin-bottom: 12rpx;
        font-size: 36rpx;
        color: #333;
        font-weight: 600;
      }

      .apply-date {
        font-size: 26rpx;
        color: #999;
      }
    }
  }

  .info-card {
    padding: 30rpx;
    margin-bottom: 20rpx;
    background: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .card-title {
      padding-bottom: 16rpx;
      margin-bottom: 24rpx;
      font-size: 32rpx;
      color: #333;
      font-weight: 600;
      border-bottom: 1rpx solid #f0f0f0;
    }

    .info-list {
      .info-item {
        display: flex;
        margin-bottom: 20rpx;
        font-size: 28rpx;

        &:last-child {
          margin-bottom: 0;
        }

        .label {
          min-width: 200rpx;
          color: #999;
        }

        .value {
          flex: 1;
          color: #333;
          word-break: break-all;
        }
      }
    }
  }

  .btn-group {
    padding: 40rpx 20rpx;

    :deep(.u-button) {
      width: 100%;
    }
  }
}
</style>
