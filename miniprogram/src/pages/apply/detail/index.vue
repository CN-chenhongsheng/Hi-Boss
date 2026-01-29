<template>
  <view class="detail-page">
    <!-- 背景渐变 -->
    <view class="bg-gradient" />

    <view class="page-container">
      <!-- 顶部导航 -->
      <view class="header">
        <view class="header-title">
          申请详情
        </view>
      </view>

      <!-- 主内容 -->
      <scroll-view class="content-scroll" scroll-y>
        <view class="main-content">
          <!-- 状态展示区域 -->
          <view class="status-section">
            <view class="status-icon-wrapper">
              <view class="status-icon-pulse" />
              <u-icon name="clock-fill" size="64" color="#0adbc3" class="status-icon-main" />
            </view>
            <view class="status-text">
              <view class="status-title">
                {{ statusText }}
              </view>
              <view class="status-desc">
                {{ statusDesc }}
              </view>
            </view>
          </view>

          <!-- 申请信息卡片 -->
          <view class="glass-card info-card">
            <!-- 卡片头部 -->
            <view class="card-header">
              <view class="card-header-left">
                <view class="pulse-dot" />
                <text class="apply-no">
                  NO. {{ applyNo }}
                </text>
              </view>
              <view class="apply-type-tag">
                {{ applyTypeName }}
              </view>
            </view>

            <!-- 卡片内容 -->
            <view class="card-body">
              <!-- 学生信息 -->
              <view class="student-info">
                <image class="student-avatar" :src="studentInfo.avatar || defaultAvatar" mode="aspectFill" />
                <view class="student-detail">
                  <view class="student-name">
                    {{ studentInfo.name }}
                  </view>
                  <view class="student-meta">
                    {{ studentInfo.grade }} {{ studentInfo.department }} · {{ studentInfo.level }}
                  </view>
                </view>
              </view>

              <!-- 申请详情 -->
              <view class="apply-details">
                <!-- 目标宿舍 -->
                <view v-if="detail.targetDorm" class="detail-item">
                  <view class="detail-icon">
                    <u-icon name="home-fill" size="18" color="#608a85" />
                  </view>
                  <view class="detail-content">
                    <view class="detail-label">
                      目标宿舍
                    </view>
                    <view class="detail-value">
                      {{ detail.targetDorm }}
                    </view>
                  </view>
                </view>

                <!-- 申请理由 -->
                <view v-if="detail.applyReason" class="detail-item">
                  <view class="detail-icon">
                    <u-icon name="edit-pen-fill" size="18" color="#608a85" />
                  </view>
                  <view class="detail-content">
                    <view class="detail-label">
                      申请理由
                    </view>
                    <view class="detail-value">
                      {{ detail.applyReason }}
                    </view>
                  </view>
                </view>
              </view>
            </view>
          </view>

          <!-- 处理进度卡片 -->
          <view class="glass-card progress-card">
            <view class="progress-title">
              <u-icon name="clock-fill" size="20" color="#0adbc3" />
              <text>处理进度</text>
            </view>

            <view class="progress-timeline">
              <!-- 提交申请 -->
              <view class="timeline-item">
                <view class="timeline-icon-wrapper">
                  <u-icon name="checkmark-circle" size="24" color="#0adbc3" />
                  <view v-if="currentStep > 0" class="timeline-line timeline-line-active" />
                </view>
                <view class="timeline-content">
                  <view class="timeline-header">
                    <view class="timeline-title">
                      提交申请
                    </view>
                    <view class="timeline-time">
                      {{ progressSteps[0].time }}
                    </view>
                  </view>
                  <view class="timeline-desc">
                    {{ progressSteps[0].desc }}
                  </view>
                </view>
              </view>

              <!-- 辅导员审核 -->
              <view class="timeline-item">
                <view class="timeline-icon-wrapper">
                  <u-icon name="checkmark-circle" size="24" color="#0adbc3" />
                  <view v-if="currentStep > 1" class="timeline-line timeline-line-active" />
                </view>
                <view class="timeline-content">
                  <view class="timeline-header">
                    <view class="timeline-title">
                      辅导员审核
                    </view>
                    <view class="timeline-time">
                      {{ progressSteps[1].time }}
                    </view>
                  </view>
                  <view v-if="progressSteps[1].reviewer" class="timeline-reviewer">
                    <image class="reviewer-avatar" :src="progressSteps[1].reviewer.avatar" mode="aspectFill" />
                    <view class="reviewer-info">
                      <text>{{ progressSteps[1].reviewer.name }}</text>
                      <view class="reviewer-status">
                        通过
                      </view>
                    </view>
                  </view>
                  <view v-if="progressSteps[1].reviewReason" class="review-reason-card">
                    <view class="review-reason-triangle" />
                    <view class="review-reason-header">
                      <u-icon name="checkmark-circle-fill" size="16" color="#0adbc3" />
                      <text>审核原因</text>
                    </view>
                    <view class="review-reason-text">
                      {{ progressSteps[1].reviewReason }}
                    </view>
                  </view>
                </view>
              </view>

              <!-- 宿管站确认 -->
              <view class="timeline-item">
                <view class="timeline-icon-wrapper">
                  <view v-if="currentStep === 2" class="timeline-icon-pulse">
                    <view class="pulse-circle-bg" />
                    <view class="custom-radio-icon custom-radio-icon-active" />
                  </view>
                  <view v-else class="custom-radio-icon" :class="currentStep > 2 ? 'custom-radio-icon-active' : 'custom-radio-icon-gray'" />
                  <view class="timeline-line" :class="currentStep > 2 ? 'timeline-line-active' : 'timeline-line-gray'" />
                </view>
                <view class="timeline-content">
                  <view class="timeline-header">
                    <view class="timeline-title" :class="{ active: currentStep === 2, gray: currentStep < 2 }">
                      宿管站确认
                    </view>
                    <view v-if="currentStep === 2" class="timeline-status-badge">
                      进行中
                    </view>
                    <view v-else-if="progressSteps[2].time" class="timeline-time">
                      {{ progressSteps[2].time }}
                    </view>
                  </view>
                  <view class="timeline-desc" :class="{ gray: currentStep < 2 }">
                    {{ progressSteps[2].desc }}
                  </view>
                </view>
              </view>

              <!-- 完成 -->
              <view class="timeline-item">
                <view class="timeline-icon-wrapper">
                  <view class="custom-radio-icon custom-radio-icon-unchecked" :class="currentStep > 3 ? 'custom-radio-icon-active' : ''" />
                </view>
                <view class="timeline-content">
                  <view class="timeline-header">
                    <view class="timeline-title" :class="{ gray: currentStep < 3 }">
                      完成
                    </view>
                    <view class="timeline-time" :class="{ gray: currentStep < 3 }">
                      {{ progressSteps[3].time || '--' }}
                    </view>
                  </view>
                  <view class="timeline-desc" :class="{ gray: currentStep < 3 }">
                    {{ progressSteps[3].desc }}
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
      </scroll-view>

      <!-- 底部安全区域 -->
      <view class="safe-bottom" />

      <!-- 底部操作栏 -->
      <view class="bottom-actions">
        <view
          v-if="canCancel"
          class="action-btn cancel-btn"
          @click="handleCancel"
        >
          撤回申请
        </view>
        <view
          class="action-btn primary-btn"
          :class="{ 'full-width': !canCancel }"
          @click="handleUrge"
        >
          <u-icon name="bell" size="20" color="#fff" />
          <text>催办一下</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { getApplyTypeName, getStatusText } from '@/utils/apply';
import { cancelCheckInAPI, getCheckInDetailAPI } from '@/api/accommodation/check-in';
import { cancelCheckOutAPI, getCheckOutDetailAPI } from '@/api/accommodation/check-out';
import { cancelTransferAPI, getTransferDetailAPI } from '@/api/accommodation/transfer';
import { cancelStayAPI, getStayDetailAPI } from '@/api/accommodation/stay';
import { getApprovalInstanceByBusinessAPI } from '@/api/approval';
import type { IApprovalInstance } from '@/types/api';

const defaultAvatar = 'https://via.placeholder.com/150';

// 申请详情
const detail = ref<any>(null);
const applyType = ref('');
const applyId = ref(0);
const approvalInstance = ref<IApprovalInstance | null>(null);

// 学生信息
const studentInfo = computed(() => ({
  avatar: detail.value?.studentInfo?.avatar || '',
  name: detail.value?.studentInfo?.name || '张三',
  grade: detail.value?.studentInfo?.grade || '2021级',
  department: detail.value?.studentInfo?.department || '计算机系',
  level: detail.value?.studentInfo?.level || '本科生',
}));

// 申请编号
const applyNo = computed(() => {
  return detail.value?.applyNo || '20231024001';
});

// 申请类型名称
const applyTypeName = computed(() => {
  return getApplyTypeName(applyType.value);
});

// 状态文本
const statusText = computed(() => {
  if (!detail.value) return '审核中';
  const status = detail.value.status;
  return getStatusText(status);
});

// 状态描述
const statusDesc = computed(() => {
  if (statusText.value === '审核中') {
    return '预计24小时内完成宿管确认';
  }
  if (statusText.value === '已通过') {
    return '申请已通过，请等待后续通知';
  }
  if (statusText.value === '已拒绝') {
    return '申请已被拒绝';
  }
  if (statusText.value === '已完成') {
    return '申请已完成';
  }
  return '';
});

// 当前步骤（0: 提交申请, 1: 辅导员审核, 2: 宿管站确认, 3: 完成）
const currentStep = computed(() => {
  if (!detail.value) return 2;
  const status = detail.value.status;
  if (status === 1 || status === 'pending') return 2; // 进行中
  if (status === 2 || status === 'approved') return 3; // 已完成审核，等待完成
  if (status === 3 || status === 'rejected') return 1; // 已拒绝，在审核阶段
  if (status === 4 || status === 'done') return 3; // 完成
  return 2;
});

// 是否可以撤回（只有待审批状态才能撤回）
const canCancel = computed(() => {
  if (!detail.value) return false;
  const status = detail.value.status;
  // 状态为1或'pending'表示待审批，可以撤回
  return status === 1 || status === 'pending';
});

// 进度步骤（基于审批记录动态生成）
const progressSteps = computed(() => {
  const records = approvalInstance.value?.records || [];
  const nodes = approvalInstance.value?.nodes || [];

  // 基础步骤：提交申请
  const steps: any[] = [
    {
      title: '提交申请',
      time: detail.value?.applyDate || approvalInstance.value?.startTime || '--',
      desc: '申请已成功提交至系统',
      completed: true,
    },
  ];

  // 根据流程节点添加步骤
  nodes.forEach((node) => {
    const record = records.find(r => r.nodeId === node.id);
    steps.push({
      title: node.nodeName,
      time: record?.approveTime || '',
      desc: record ? (record.action === 1 ? '审批通过' : '审批拒绝') : '等待审批',
      completed: !!record,
      reviewer: record
        ? {
            avatar: 'https://via.placeholder.com/40',
            name: record.approverName,
          }
        : null,
      reviewReason: record?.opinion || '',
      action: record?.action,
    });
  });

  // 添加完成步骤
  steps.push({
    title: '完成',
    time: approvalInstance.value?.endTime || '--',
    desc: '流程结束',
    completed: approvalInstance.value?.status === 2, // 2表示已通过
  });

  return steps;
});

// 撤回申请
async function handleCancel() {
  if (!canCancel.value) {
    uni.showToast({ title: '当前状态不可撤回', icon: 'none' });
    return;
  }

  uni.showModal({
    title: '确认撤回',
    content: '确定要撤回此申请吗？撤回后需要重新提交。',
    success: async (res) => {
      if (res.confirm) {
        uni.showLoading({ title: '撤回中...' });
        try {
          // 根据申请类型调用对应的撤回API
          const cancelAPIs: Record<string, (id: number) => Promise<any>> = {
            'check-in': cancelCheckInAPI,
            'check-out': cancelCheckOutAPI,
            'transfer': cancelTransferAPI,
            'stay': cancelStayAPI,
          };
          const cancelFn = cancelAPIs[applyType.value];
          if (cancelFn) {
            await cancelFn(applyId.value);
          }
          uni.hideLoading();
          uni.showToast({ title: '撤回成功', icon: 'success' });
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        }
        catch (error: any) {
          uni.hideLoading();
          uni.showToast({
            title: error?.message || '撤回失败',
            icon: 'none',
          });
        }
      }
    },
  });
}

// 催办
function handleUrge() {
  uni.showToast({
    title: '催办消息已发送',
    icon: 'success',
  });
}

// 加载详情
async function loadDetail() {
  try {
    uni.showLoading({ title: '加载中...' });

    // 根据申请类型调用对应的详情API
    const detailAPIs: Record<string, (id: number) => Promise<any>> = {
      'check-in': getCheckInDetailAPI,
      'check-out': getCheckOutDetailAPI,
      'transfer': getTransferDetailAPI,
      'stay': getStayDetailAPI,
    };

    const detailFn = detailAPIs[applyType.value];
    if (detailFn) {
      detail.value = await detailFn(applyId.value);
    }

    // 加载审批实例信息
    const businessTypeMap: Record<string, string> = {
      'check-in': 'check_in',
      'check-out': 'check_out',
      'transfer': 'transfer',
      'stay': 'stay',
    };
    const businessType = businessTypeMap[applyType.value];
    if (businessType) {
      try {
        approvalInstance.value = await getApprovalInstanceByBusinessAPI(businessType, applyId.value);
      }
      catch {
        // 可能没有审批实例（如未发起审批流程）
        approvalInstance.value = null;
      }
    }

    uni.hideLoading();
  }
  catch (error) {
    uni.hideLoading();
    console.error('加载失败:', error);
    uni.showToast({
      title: '加载失败',
      icon: 'none',
    });
  }
}

onMounted(() => {
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1] as any;
  const options = currentPage.options || currentPage.$route?.query;

  applyId.value = Number(options.id) || 1;
  applyType.value = options.type || 'transfer';

  loadDetail();
});
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.detail-page {
  position: relative;
  overflow: hidden;
  min-height: 100vh;
  background-color: $bg-light;
}

// 背景渐变
.bg-gradient {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  background-image:
    radial-gradient(circle at 10% 20%, rgb(10 219 195 / 15%) 0%, transparent 40%),
    radial-gradient(circle at 90% 60%, rgb(10 219 195 / 10%) 0%, transparent 40%);
}

.page-container {
  position: relative;
  z-index: 10;
  display: flex;
  margin: 0 auto;
  max-width: 750rpx;
  min-height: 100vh;
  background: transparent;
  box-shadow: 0 0 40rpx rgb(0 0 0 / 10%);
  flex-direction: column;
  border-left: 2rpx solid rgb(255 255 255 / 20%);
  border-right: 2rpx solid rgb(255 255 255 / 20%);
}

// 内容滚动区域
.content-scroll {
  position: relative;
  z-index: 10;
  height: calc(100vh - var(--status-bar-height) - 84rpx);
}

// 顶部导航
.header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: calc(var(--status-bar-height) + 45rpx) 32rpx 25rpx;
  backdrop-filter: blur(20rpx);

  .header-title {
    font-size: 36rpx;
    text-align: center;
    color: $text-main;
    flex: 1;
    font-weight: 700;
    letter-spacing: 1rpx;
  }
}

// 主内容
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 40rpx;
  padding: 16rpx 32rpx;
}

// 状态展示区域
.status-section {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 48rpx 0;
  flex-direction: column;
  gap: 24rpx;

  .status-icon-wrapper {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 128rpx;
    height: 128rpx;

    .status-icon-pulse {
      position: absolute;
      inset: 0;
      background: rgb(10 219 195 / 20%);
      border-radius: 50%;
      filter: blur(60rpx);
      transform: scale(1.5);
      animation: pulse 2s ease-in-out infinite;
    }

    .status-icon-main {
      position: relative;
      z-index: 10;
    }
  }

  .status-text {
    text-align: center;

    .status-title {
      margin-bottom: 8rpx;
      font-size: 48rpx;
      color: $text-main;
      font-weight: 700;
    }

    .status-desc {
      margin-top: 8rpx;
      font-size: 28rpx;
      color: $text-sub;
    }
  }
}

// 申请信息卡片
.info-card {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: $spacing-lg 40rpx;
    background: rgb(255 255 255 / 30%);
    border-bottom: 2rpx solid rgb(255 255 255 / 40%);

    .card-header-left {
      display: flex;
      align-items: center;
      gap: $spacing-sm;

      .pulse-dot {
        width: $spacing-sm;
        height: $spacing-sm;
        background: $primary;
        border-radius: 50%;
        animation: pulse-dot 2s ease-in-out infinite;
      }

      .apply-no {
        font-size: $font-sm;
        color: $text-sub;
        font-weight: $font-medium;
        letter-spacing: 2rpx;
        text-transform: uppercase;
      }
    }

    .apply-type-tag {
      padding: 8rpx 20rpx;
      font-size: $font-sm;
      color: $primary-dark;
      background: rgb(10 219 195 / 10%);
      border: 2rpx solid rgb(10 219 195 / 10%);
      border-radius: 12rpx;
      font-weight: $font-bold;
    }
  }

  .card-body {
    padding: 40rpx;
  }
}

// 学生信息
.student-info {
  display: flex;
  align-items: center;
  gap: $spacing-lg;
  margin-bottom: 48rpx;

  .student-avatar {
    width: 96rpx;
    height: 96rpx;
    background: #e5e7eb;
    border: 4rpx solid #fff;
    border-radius: 50%;
    box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 5%);
    flex-shrink: 0;
  }

  .student-detail {
    flex: 1;

    .student-name {
      margin-bottom: 8rpx;
      font-size: $font-lg;
      color: $text-main;
      font-weight: $font-bold;
      line-height: 1.2;
    }

    .student-meta {
      margin-top: 8rpx;
      font-size: $font-sm;
      color: $text-sub;
    }
  }
}

// 申请详情
.apply-details {
  display: flex;
  flex-direction: column;
  gap: 40rpx;
}

.detail-item {
  display: flex;
  gap: $spacing-lg;

  .detail-icon {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 64rpx;
    height: 64rpx;
    color: $text-sub;
    background: rgb(255 255 255 / 60%);
    border: 2rpx solid rgb(255 255 255 / 80%);
    border-radius: 16rpx;
    flex-shrink: 0;
  }

  .detail-content {
    flex: 1;
    display: flex;
    flex-direction: column;

    .detail-label {
      margin-bottom: 8rpx;
      font-size: $font-sm;
      color: $text-sub;
    }

    .detail-value {
      font-size: $font-md;
      text-align: justify;
      color: $text-main;
      font-weight: $font-medium;
      line-height: 1.6;
    }
  }
}

// 处理进度卡片
.progress-card {
  padding: 40rpx;

  .progress-title {
    display: flex;
    align-items: center;
    margin-bottom: 48rpx;
    font-size: $font-lg;
    color: $text-main;
    gap: $spacing-sm;
    font-weight: $font-bold;
  }
}

// 进度时间线
.progress-timeline {
  position: relative;
  padding-left: $spacing-lg;
}

.timeline-item {
  position: relative;
  display: flex;
  margin-bottom: 64rpx;
  gap: $spacing-lg;

  &:last-child {
    margin-bottom: 0;

    .timeline-icon-wrapper .timeline-line {
      display: none;
    }
  }

  .timeline-icon-wrapper {
    position: relative;
    display: flex;
    align-items: center;
    padding-top: 15rpx;
    width: 48rpx;
    flex-direction: column;
    flex-shrink: 0;

    .timeline-line {
      position: absolute;
      top: 70rpx;
      left: 22rpx;
      z-index: 0;
      width: 4rpx;
      height: 100%;
      min-height: 90rpx;
      background: rgb(10 219 195 / 30%);

      &.timeline-line-active {
        background: rgb(10 219 195 / 30%);
      }

      &.timeline-line-gray {
        background: #dbe6e5;
      }
    }

    .timeline-icon-pulse {
      position: relative;
      z-index: 10;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 48rpx;
      height: 48rpx;

      .pulse-circle-bg {
        position: absolute;
        width: 48rpx;
        height: 48rpx;
        background: rgb(10 219 195 / 20%);
        border-radius: 50%;
        animation: pulse-ring 2s ease-in-out infinite;
      }
    }

    // 自定义单选图标（模拟 radio_button_checked）
    .custom-radio-icon {
      position: relative;
      z-index: 10;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 36rpx;
      height: 36rpx;

      // 外圈（未选中时为空心，选中时为实心）
      &::before {
        content: '';
        position: absolute;
        width: 36rpx;
        height: 36rpx;
        border-radius: 50%;
        transition: all 0.3s;
      }

      // 内点（选中时显示）
      &::after {
        position: absolute;
        z-index: 1;
        border-radius: 50%;
        content: '';
      }

      // 选中状态（实心圆形）
      &.custom-radio-icon-active {
        &::before {
          background: #fff;
          border: 4rpx solid $primary;
        }

        &::after {
          width: 20rpx;
          height: 20rpx;
          background: $primary;
        }
      }

      // 灰色未选中状态
      &.custom-radio-icon-gray {
        &::before {
          background: transparent;
          border: 4rpx solid #dbe6e5;
        }

        &::after {
          display: none;
        }
      }

      // 未选中空心状态（完成步骤）
      &.custom-radio-icon-unchecked {
        &::before {
          margin-top: 12rpx;
          width: 30rpx;
          height: 30rpx;
          background: #fff;
          border: 4rpx solid #dbe6e5;
        }

        &::after {
          display: none;
        }

        // 如果变为激活状态
        &.custom-radio-icon-active {
          &::before {
            background: $primary;
            border-color: $primary;
          }

          &::after {
            display: block;
            width: 20rpx;
            height: 20rpx;
            background: #fff;
          }
        }
      }
    }
  }

  .timeline-content {
    position: relative;
    z-index: 1;
    display: flex;
    margin-top: -4rpx;
    flex: 1;
    flex-direction: column;

    .timeline-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 8rpx;
    }

    .timeline-title {
      font-size: $font-lg;
      font-weight: $font-bold;
      color: $text-main;

      &.active {
        color: $primary;
      }

      &.gray {
        color: $text-disabled;
        font-weight: $font-medium;
      }
    }

    .timeline-time {
      font-size: $font-sm;
      color: $text-sub;
      font-weight: $font-medium;

      &.gray {
        color: $text-disabled;
      }
    }

    .timeline-status-badge {
      padding: 4rpx $spacing-sm;
      font-size: $font-sm;
      color: $primary;
      background: rgb(10 219 195 / 10%);
      border-radius: 9999rpx;
      font-weight: $font-medium;
    }

    .timeline-desc {
      margin-top: 8rpx;
      font-size: $font-md;
      color: $text-sub;

      &.gray {
        color: $text-disabled;
      }
    }
  }
}

@keyframes pulse-ring {
  0%, 100% {
    transform: scale(1);
    opacity: 0.2;
  }

  50% {
    transform: scale(1.2);
    opacity: 0.1;
  }
}

// 审核人信息
.timeline-reviewer {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  margin: 8rpx 0 $spacing-md;

  .reviewer-avatar {
    width: 40rpx;
    height: 40rpx;
    background: #e5e7eb;
    border-radius: 50%;
    flex-shrink: 0;
  }

  .reviewer-info {
    display: flex;
    align-items: center;
    gap: 12rpx;
    font-size: $font-md;
    color: $text-sub;

    .reviewer-status {
      padding: 2rpx 8rpx;
      margin-left: 8rpx;
      font-size: $font-sm;
      color: $primary;
      background: rgb(10 219 195 / 5%);
      border-radius: 4rpx;
      font-weight: $font-medium;
    }
  }
}

// 审核原因卡片
.review-reason-card {
  position: relative;
  padding: 28rpx;
  margin-top: $spacing-sm;
  background: linear-gradient(to bottom right, rgb(10 219 195 / 5%), rgb(255 255 255 / 60%));
  border: 2rpx solid rgb(10 219 195 / 10%);
  border-radius: $spacing-sm;
  box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 5%);

  .review-reason-triangle {
    position: absolute;
    top: -12rpx;
    left: 64rpx;
    width: 24rpx;
    height: 24rpx;
    background: #eefbf9;
    border-top: 2rpx solid rgb(10 219 195 / 10%);
    border-left: 2rpx solid rgb(10 219 195 / 10%);
    transform: rotate(45deg);
  }

  .review-reason-header {
    display: flex;
    align-items: center;
    gap: $spacing-sm;
    margin-bottom: 8rpx;
    font-size: $font-sm;
    font-weight: $font-bold;
    color: $text-main;
  }

  .review-reason-text {
    padding-left: 48rpx;
    font-size: $font-md;
    color: #4b5563;
    line-height: 1.6;
  }
}

// 底部安全区域
.safe-bottom {
  height: calc(env(safe-area-inset-bottom) + 250rpx);
}

// 底部操作栏
.bottom-actions {
  position: fixed;
  bottom: 0;
  left: 50%;
  z-index: 50;
  display: flex;
  padding: $spacing-lg;
  margin: 0 auto;
  width: calc(100% - 64rpx);
  max-width: 750rpx;
  background: rgb(255 255 255 / 80%);
  transform: translateX(-50%);
  backdrop-filter: blur(40rpx);
  border-top: 2rpx solid rgb(229 231 235 / 100%);
  gap: $spacing-md;

  .action-btn {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 86rpx;
    font-size: $font-md;
    border-radius: $radius-md;
    transition: $transition-fast;
    font-weight: $font-bold;

    &:active {
      transform: scale(0.98);
    }
  }

  .cancel-btn {
    color: $text-sub;
    background: #fff;
    border: 2rpx solid #dbe6e5;
    flex: 1;

    &:active {
      background: #f9fafb;
    }
  }

  .primary-btn {
    color: #fff;
    background: $primary;
    box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 40%);
    flex: 2;
    gap: $spacing-sm;

    &:active {
      background: $primary-dark;
    }

    &.full-width {
      flex: 1;
    }
  }
}

// UView Plus 图标样式穿透
::v-deep(.u-icon__icon) > span {
  overflow: hidden;
}
</style>
