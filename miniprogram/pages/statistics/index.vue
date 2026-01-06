<template>
  <view class="page-container">
    <!-- 空状态 -->
    <view class="empty-container">
      <view class="empty-icon">📊</view>
      <view class="empty-title">统计功能开发中</view>
      <view class="empty-desc">敬请期待</view>
    </view>
  </view>
</template>

<script setup lang="ts">
  import { onLoad } from '@dcloudio/uni-app'

  onLoad(() => {
    console.log('统计页面加载')
  })
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
    background-color: #f5f5f5;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .empty-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 64rpx;
  }

  .empty-icon {
    font-size: 120rpx;
    margin-bottom: 32rpx;
  }

  .empty-title {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 16rpx;
  }

  .empty-desc {
    font-size: 28rpx;
    color: #999;
  }
</style>

