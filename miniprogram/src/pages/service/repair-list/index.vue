<template>
  <view class="repair-list-page">
    <view class="repair-list">
      <view v-for="item in repairList" :key="item.id" class="repair-item">
        <view class="item-header">
          <view class="type">
            {{ getRepairTypeText(item.repairType) }}
          </view>
          <view class="status" :style="{ color: getStatusColor(item.status) }">
            {{ getStatusText(item.status) }}
          </view>
        </view>
        <view class="item-content">
          <view class="description">
            {{ item.description }}
          </view>
          <view class="time">
            {{ item.createTime }}
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const repairList = ref([
  { id: 1, repairType: 1, description: '宿舍水龙头漏水', status: 1, createTime: '2024-01-07 10:00' },
  { id: 2, repairType: 2, description: '窗户关不严', status: 2, createTime: '2024-01-06 15:30' },
]);

function getRepairTypeText(type: number) {
  const map: Record<number, string> = {
    1: '水电',
    2: '门窗',
    3: '家具',
    4: '网络',
    99: '其他',
  };
  return map[type] || '未知';
}

function getStatusText(status: number) {
  const map: Record<number, string> = {
    1: '待处理',
    2: '处理中',
    3: '已完成',
  };
  return map[status] || '未知';
}

function getStatusColor(status: number) {
  const map: Record<number, string> = {
    1: '#FF9800',
    2: '#2196F3',
    3: '#4CAF50',
  };
  return map[status] || '#999';
}
</script>

<style lang="scss" scoped>
.repair-list-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.repair-list {
  .repair-item {
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

      .type {
        font-size: 28rpx;
        font-weight: 600;
        color: #333;
      }

      .status {
        font-size: 24rpx;
      }
    }

    .item-content {
      .description {
        margin-bottom: 12rpx;
        font-size: 26rpx;
        color: #666;
      }

      .time {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}
</style>
