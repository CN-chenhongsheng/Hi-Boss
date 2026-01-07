<template>
  <view class="approval-page">
    <view v-if="loading" class="loading">
      <view class="loading-spinner" />
      <view class="loading-text">
        加载中...
      </view>
    </view>

    <view v-else-if="detail" class="approval-content">
      <!-- 申请人信息 -->
      <view class="info-card">
        <view class="card-title">
          申请人信息
        </view>
        <view class="info-list">
          <view class="info-item">
            <text class="label">
              姓名：
            </text>
            <text class="value">
              {{ detail.studentName }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              学号：
            </text>
            <text class="value">
              {{ detail.studentNo }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              申请时间：
            </text>
            <text class="value">
              {{ detail.applyDate }}
            </text>
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
              留宿时间：
            </text>
            <text class="value">
              {{ detail.stayStartDate }} 至 {{ detail.stayEndDate }}
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

      <!-- 审批表单 -->
      <view v-if="detail.status === 1" class="approval-form">
        <view class="card-title">
          审批操作
        </view>

        <!-- 床位分配（入住和调宿申请） -->
        <view v-if="applyType === 'checkIn' || applyType === 'transfer'" class="form-section">
          <view class="section-title">
            床位分配
          </view>
          <u-form ref="formRef" :model="approvalData" label-width="140">
            <u-form-item label="校区编码">
              <u-input v-model="approvalData.campusCode" placeholder="请输入校区编码" />
            </u-form-item>
            <u-form-item label="楼层编码">
              <u-input v-model="approvalData.floorCode" placeholder="请输入楼层编码" />
            </u-form-item>
            <u-form-item label="房间ID">
              <u-input v-model="approvalData.roomId" placeholder="请输入房间ID" type="number" />
            </u-form-item>
            <u-form-item label="床位ID">
              <u-input v-model="approvalData.bedId" placeholder="请输入床位ID" type="number" />
            </u-form-item>
          </u-form>
        </view>

        <!-- 审批意见 -->
        <view class="form-section">
          <view class="section-title">
            审批意见
          </view>
          <u-textarea
            v-model="approvalData.approveOpinion"
            placeholder="请输入审批意见（选填）"
            :maxlength="500"
            count
          />
        </view>

        <!-- 操作按钮 -->
        <view class="btn-group">
          <u-button type="error" @click="handleReject">
            拒绝
          </u-button>
          <u-button type="success" @click="handleApprove">
            通过
          </u-button>
        </view>
      </view>

      <!-- 已审批信息 -->
      <view v-else class="info-card">
        <view class="card-title">
          审批信息
        </view>
        <view class="info-list">
          <view class="info-item">
            <text class="label">
              审批结果：
            </text>
            <text class="value" :style="{ color: getStatusColor(detail.status) }">
              {{ getStatusText(detail.status) }}
            </text>
          </view>
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
    </view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { ApplyStatusColor, ApplyStatusText } from '@/types';
import type { ApplyStatus, ICheckInApprovalParams, ITransferApprovalParams } from '@/types';
import {
  approveCheckInAPI,
  approveCheckOutAPI,
  approveStayAPI,
  approveTransferAPI,
  getCheckInDetailAPI,
  getCheckOutDetailAPI,
  getStayDetailAPI,
  getTransferDetailAPI,
} from '@/api';

const loading = ref(false);
const detail = ref<any>(null);
const applyType = ref('');
const applyId = ref(0);
const formRef = ref();

const approvalData = reactive<any>({
  id: 0,
  status: 2,
  campusCode: '',
  floorCode: '',
  roomId: undefined,
  bedId: undefined,
  approveOpinion: '',
});

function getStatusText(status: ApplyStatus) {
  return ApplyStatusText[status] || '未知';
}

function getStatusColor(status: ApplyStatus) {
  return ApplyStatusColor[status] || '#999';
}

function getApplyReason(item: any) {
  return item.applyReason || item.transferReason || item.checkOutReason || item.stayReason || '-';
}

// 通过审批
async function handleApprove() {
  try {
    uni.showModal({
      title: '确认通过',
      content: '确定要通过此申请吗？',
      success: async (res) => {
        if (res.confirm) {
          uni.showLoading({ title: '处理中...' });

          approvalData.id = applyId.value;
          approvalData.status = 2;

          let apiCall;
          switch (applyType.value) {
            case 'checkIn':
              apiCall = approveCheckInAPI;
              break;
            case 'transfer':
              apiCall = approveTransferAPI;
              break;
            case 'checkOut':
              apiCall = approveCheckOutAPI;
              break;
            case 'stay':
              apiCall = approveStayAPI;
              break;
            default:
              throw new Error('未知的申请类型');
          }

          await apiCall(approvalData);
          uni.hideLoading();
          uni.showToast({ title: '审批成功', icon: 'success' });
          setTimeout(() => uni.navigateBack(), 1500);
        }
      },
    });
  }
  catch (error: any) {
    uni.hideLoading();
    console.error('审批失败:', error);
    uni.showToast({ title: error.message || '审批失败', icon: 'none' });
  }
}

// 拒绝审批
async function handleReject() {
  try {
    uni.showModal({
      title: '确认拒绝',
      content: '确定要拒绝此申请吗？',
      success: async (res) => {
        if (res.confirm) {
          uni.showLoading({ title: '处理中...' });

          approvalData.id = applyId.value;
          approvalData.status = 3;

          let apiCall;
          switch (applyType.value) {
            case 'checkIn':
              apiCall = approveCheckInAPI;
              break;
            case 'transfer':
              apiCall = approveTransferAPI;
              break;
            case 'checkOut':
              apiCall = approveCheckOutAPI;
              break;
            case 'stay':
              apiCall = approveStayAPI;
              break;
            default:
              throw new Error('未知的申请类型');
          }

          await apiCall(approvalData);
          uni.hideLoading();
          uni.showToast({ title: '已拒绝', icon: 'success' });
          setTimeout(() => uni.navigateBack(), 1500);
        }
      },
    });
  }
  catch (error: any) {
    uni.hideLoading();
    console.error('审批失败:', error);
    uni.showToast({ title: error.message || '审批失败', icon: 'none' });
  }
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

    // 预填充床位信息
    if (detail.value.campusCode) {
      approvalData.campusCode = detail.value.campusCode;
    }
    if (detail.value.floorCode) {
      approvalData.floorCode = detail.value.floorCode;
    }
    if (detail.value.roomId) {
      approvalData.roomId = detail.value.roomId;
    }
    if (detail.value.bedId) {
      approvalData.bedId = detail.value.bedId;
    }
  }
  catch (error) {
    console.error('加载失败:', error);
    uni.showToast({ title: '加载失败', icon: 'none' });
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
.approval-page {
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

.approval-content {
  .info-card,
  .approval-form {
    padding: 30rpx;
    margin-bottom: 20rpx;
    background: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);
  }

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
        min-width: 160rpx;
        color: #999;
      }

      .value {
        flex: 1;
        color: #333;
        word-break: break-all;
      }
    }
  }

  .form-section {
    margin-bottom: 30rpx;

    &:last-child {
      margin-bottom: 0;
    }

    .section-title {
      margin-bottom: 20rpx;
      font-size: 28rpx;
      color: #666;
      font-weight: 600;
    }
  }

  .btn-group {
    display: flex;
    gap: 20rpx;
    margin-top: 40rpx;

    :deep(.u-button) {
      flex: 1;
    }
  }
}
</style>
