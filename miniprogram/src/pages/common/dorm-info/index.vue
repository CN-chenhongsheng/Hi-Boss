<template>
  <view class="dorm-info-page">
    <view class="info-card">
      <view class="card-title">
        宿舍信息
      </view>
      <view class="info-list">
        <view class="info-item">
          <text class="label">
            校区：
          </text>
          <text class="value">
            南校区
          </text>
        </view>
        <view class="info-item">
          <text class="label">
            楼栋：
          </text>
          <text class="value">
            1号楼
          </text>
        </view>
        <view class="info-item">
          <text class="label">
            楼层：
          </text>
          <text class="value">
            3层
          </text>
        </view>
        <view class="info-item">
          <text class="label">
            房间号：
          </text>
          <text class="value">
            301
          </text>
        </view>
        <view class="info-item">
          <text class="label">
            床位号：
          </text>
          <text class="value">
            2号床
          </text>
        </view>
        <view class="info-item">
          <text class="label">
            入住日期：
          </text>
          <text class="value">
            2024-09-01
          </text>
        </view>
      </view>
    </view>

    <view class="info-card">
      <view class="card-title">
        室友信息
      </view>
      <view class="roommate-list">
        <view v-for="item in roommates" :key="item.id" class="roommate-item">
          <image class="avatar" :src="item.avatar" mode="aspectFill" />
          <view class="info">
            <view class="name">
              {{ item.name }}
            </view>
            <view class="student-no">
              {{ item.studentNo }}
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const roommates = ref([
  { id: 1, name: '张三', studentNo: '2024001', avatar: 'https://via.placeholder.com/100' },
  { id: 2, name: '李四', studentNo: '2024002', avatar: 'https://via.placeholder.com/100' },
  { id: 3, name: '王五', studentNo: '2024003', avatar: 'https://via.placeholder.com/100' },
]);
</script>

<style lang="scss" scoped>
.dorm-info-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
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
        min-width: 160rpx;
        color: #999;
      }

      .value {
        flex: 1;
        color: #333;
      }
    }
  }

  .roommate-list {
    .roommate-item {
      display: flex;
      align-items: center;
      padding: 20rpx 0;
      border-bottom: 1rpx solid #f0f0f0;

      &:last-child {
        border-bottom: none;
      }

      .avatar {
        margin-right: 20rpx;
        width: 80rpx;
        height: 80rpx;
        border-radius: 50%;
      }

      .info {
        flex: 1;

        .name {
          margin-bottom: 8rpx;
          font-size: 28rpx;
          color: #333;
        }

        .student-no {
          font-size: 24rpx;
          color: #999;
        }
      }
    }
  }
}
</style>
