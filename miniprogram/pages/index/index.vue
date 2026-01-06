<template>
  <view class="page-container">
    <!-- 顶部欢迎区域 -->
    <view class="welcome-section">
      <view class="welcome-title">宿舍管理系统</view>
      <view class="welcome-subtitle">便捷办理宿舍业务</view>
    </view>

    <!-- 功能卡片区域 -->
    <view class="function-grid">
      <!-- 入住卡片 -->
      <view class="function-card checkin-card" @click="navigateTo('/pages/checkin/index')">
        <view class="card-icon checkin-icon">
          <text class="icon-text">🏠</text>
        </view>
        <view class="card-content">
          <view class="card-title">入住</view>
          <view class="card-desc">新生入住登记</view>
        </view>
        <view class="card-arrow">›</view>
      </view>

      <!-- 调宿卡片 -->
      <view class="function-card transfer-card" @click="navigateTo('/pages/transfer/index')">
        <view class="card-icon transfer-icon">
          <text class="icon-text">🔄</text>
        </view>
        <view class="card-content">
          <view class="card-title">调宿</view>
          <view class="card-desc">申请更换宿舍</view>
        </view>
        <view class="card-arrow">›</view>
      </view>

      <!-- 退宿卡片 -->
      <view class="function-card checkout-card" @click="navigateTo('/pages/checkout/index')">
        <view class="card-icon checkout-icon">
          <text class="icon-text">🚪</text>
        </view>
        <view class="card-content">
          <view class="card-title">退宿</view>
          <view class="card-desc">办理退宿手续</view>
        </view>
        <view class="card-arrow">›</view>
      </view>

      <!-- 留宿卡片 -->
      <view class="function-card stay-card" @click="navigateTo('/pages/stay/index')">
        <view class="card-icon stay-icon">
          <text class="icon-text">🌙</text>
        </view>
        <view class="card-content">
          <view class="card-title">留宿</view>
          <view class="card-desc">假期留宿申请</view>
        </view>
        <view class="card-arrow">›</view>
      </view>
    </view>

    <!-- 快捷入口 -->
    <view class="quick-section">
      <view class="section-title">快捷入口</view>
      <view class="quick-grid">
        <view class="quick-item" @click="navigateTo('/pages/checkin/index')">
          <view class="quick-icon bg-primary">📋</view>
          <text class="quick-text">我的申请</text>
        </view>
        <view class="quick-item" @click="showTip('功能开发中')">
          <view class="quick-icon bg-success">📢</view>
          <text class="quick-text">公告通知</text>
        </view>
        <view class="quick-item" @click="showTip('功能开发中')">
          <view class="quick-icon bg-warning">📞</view>
          <text class="quick-text">联系管理</text>
        </view>
        <view class="quick-item" @click="showTip('功能开发中')">
          <view class="quick-icon bg-error">❓</view>
          <text class="quick-text">帮助中心</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
  import { onLoad } from '@dcloudio/uni-app'

  onLoad(() => {
    console.log('首页加载')
  })

  /**
   * 页面跳转
   */
  const navigateTo = (url: string) => {
    uni.navigateTo({ url })
  }

  /**
   * 显示提示
   */
  const showTip = (message: string) => {
    uni.showToast({
      title: message,
      icon: 'none'
    })
  }
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
    background-color: #f5f5f5;
    padding: 0 32rpx 32rpx;
  }

  /* 欢迎区域 */
  .welcome-section {
    padding: 48rpx 0 32rpx;
    text-align: center;
  }

  .welcome-title {
    font-size: 44rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 12rpx;
  }

  .welcome-subtitle {
    font-size: 28rpx;
    color: #999;
  }

  /* 功能卡片网格 */
  .function-grid {
    display: flex;
    flex-direction: column;
    gap: 24rpx;
  }

  .function-card {
    display: flex;
    align-items: center;
    background: #fff;
    border-radius: 24rpx;
    padding: 32rpx;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
    transition: transform 0.2s;

    &:active {
      transform: scale(0.98);
    }
  }

  .card-icon {
    width: 100rpx;
    height: 100rpx;
    border-radius: 24rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 28rpx;
  }

  .icon-text {
    font-size: 48rpx;
  }

  /* 不同卡片的图标背景色 */
  .checkin-icon {
    background: linear-gradient(135deg, #5d87ff 0%, #7b9fff 100%);
  }

  .transfer-icon {
    background: linear-gradient(135deg, #f0ad4e 0%, #f5c478 100%);
  }

  .checkout-icon {
    background: linear-gradient(135deg, #dd524d 0%, #e67672 100%);
  }

  .stay-icon {
    background: linear-gradient(135deg, #4cd964 0%, #6ee085 100%);
  }

  .card-content {
    flex: 1;
  }

  .card-title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 8rpx;
  }

  .card-desc {
    font-size: 26rpx;
    color: #999;
  }

  .card-arrow {
    font-size: 40rpx;
    color: #ccc;
  }

  /* 快捷入口区域 */
  .quick-section {
    margin-top: 40rpx;
  }

  .section-title {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 24rpx;
  }

  .quick-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24rpx;
    background: #fff;
    border-radius: 24rpx;
    padding: 32rpx 16rpx;
  }

  .quick-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12rpx;

    &:active {
      opacity: 0.7;
    }
  }

  .quick-icon {
    width: 88rpx;
    height: 88rpx;
    border-radius: 20rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 40rpx;
  }

  .bg-primary {
    background: linear-gradient(135deg, #5d87ff 0%, #7b9fff 100%);
  }

  .bg-success {
    background: linear-gradient(135deg, #4cd964 0%, #6ee085 100%);
  }

  .bg-warning {
    background: linear-gradient(135deg, #f0ad4e 0%, #f5c478 100%);
  }

  .bg-error {
    background: linear-gradient(135deg, #dd524d 0%, #e67672 100%);
  }

  .quick-text {
    font-size: 24rpx;
    color: #666;
  }
</style>
