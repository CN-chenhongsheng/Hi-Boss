<template>
  <view class="notice-manage-page">
    <view class="notice-list">
      <view v-for="item in noticeList" :key="item.id" class="notice-item">
        <view class="item-header">
          <view class="title">
            {{ item.title }}
          </view>
          <view class="status" :style="{ color: item.published ? '#4CAF50' : '#999' }">
            {{ item.published ? '已发布' : '草稿' }}
          </view>
        </view>
        <view class="item-footer">
          <text class="time">
            {{ item.createTime }}
          </text>
        </view>
      </view>
    </view>

    <view class="fab">
      <u-button type="primary" shape="circle" @click="handleAdd">
        <u-icon name="plus" size="24" color="#fff" />
      </u-button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const noticeList = ref([
  { id: 1, title: '关于宿舍卫生检查的通知', published: true, createTime: '2024-01-07 10:00' },
  { id: 2, title: '寒假留宿申请通知', published: true, createTime: '2024-01-06 15:30' },
]);

function handleAdd() {
  uni.showToast({ title: '功能开发中', icon: 'none' });
}
</script>

<style lang="scss" scoped>
.notice-manage-page {
  padding: 20rpx;
  padding-bottom: 120rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.notice-list {
  .notice-item {
    padding: 30rpx;
    margin-bottom: 20rpx;
    background: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16rpx;

      .title {
        flex: 1;
        font-size: 28rpx;
        font-weight: 600;
        color: #333;
      }

      .status {
        margin-left: 20rpx;
        font-size: 24rpx;
      }
    }

    .item-footer {
      .time {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}

.fab {
  position: fixed;
  right: 40rpx;
  bottom: 120rpx;
  z-index: 999;
}
</style>
