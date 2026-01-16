<template>
  <view class="dorm-info-page">
    <!-- 加载状态 -->
    <view v-if="loading" class="loading-wrapper">
      <u-loading-icon size="40" />
      <text class="loading-text">
        加载中...
      </text>
    </view>

    <template v-else>
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
              {{ dormInfo.campusName || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              楼栋：
            </text>
            <text class="value">
              {{ dormInfo.buildingName || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              楼层：
            </text>
            <text class="value">
              {{ dormInfo.floorName || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              房间号：
            </text>
            <text class="value">
              {{ dormInfo.roomCode || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              床位号：
            </text>
            <text class="value">
              {{ dormInfo.bedCode || '-' }}
            </text>
          </view>
          <view class="info-item">
            <text class="label">
              入住日期：
            </text>
            <text class="value">
              {{ dormInfo.checkInDate || '-' }}
            </text>
          </view>
        </view>
      </view>

      <view class="info-card">
        <view class="card-title">
          室友信息
        </view>
        <view v-if="roommates.length === 0" class="empty-tip">
          暂无室友信息
        </view>
        <view v-else class="roommate-list">
          <view v-for="item in roommates" :key="item.id" class="roommate-item">
            <image class="avatar" :src="item.avatar || defaultAvatar" mode="aspectFill" />
            <view class="info">
              <view class="name">
                {{ item.studentName }}
              </view>
              <view class="student-no">
                {{ item.studentNo }}
              </view>
            </view>
            <view v-if="item.bedCode" class="bed-code">
              {{ item.bedCode }}
            </view>
          </view>
        </view>
      </view>
    </template>
  </view>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { getDormInfoAPI, getRoommatesAPI } from '@/api/dormitory';
import type { IDormInfo, IRoommate } from '@/api/dormitory';

const defaultAvatar = 'https://via.placeholder.com/100';

const loading = ref(true);
const dormInfo = reactive<IDormInfo>({
  campusName: '',
  buildingName: '',
  floorName: '',
  roomCode: '',
  bedCode: '',
  checkInDate: '',
});
const roommates = ref<IRoommate[]>([]);

// 获取宿舍信息
async function fetchDormInfo() {
  try {
    const res = await getDormInfoAPI();
    Object.assign(dormInfo, res);
  }
  catch (error) {
    console.error('获取宿舍信息失败:', error);
  }
}

// 获取室友列表
async function fetchRoommates() {
  try {
    const res = await getRoommatesAPI();
    roommates.value = res || [];
  }
  catch (error) {
    console.error('获取室友列表失败:', error);
  }
}

// 初始化
onMounted(async () => {
  loading.value = true;
  await Promise.all([fetchDormInfo(), fetchRoommates()]);
  loading.value = false;
});
</script>

<style lang="scss" scoped>
.dorm-info-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.loading-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 100rpx 0;
  flex-direction: column;

  .loading-text {
    margin-top: 20rpx;
    font-size: 28rpx;
    color: #999;
  }
}

.empty-tip {
  padding: 40rpx;
  font-size: 28rpx;
  text-align: center;
  color: #999;
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

      .bed-code {
        padding: 4rpx 12rpx;
        font-size: 24rpx;
        color: #0adbc3;
        background: rgb(10 219 195 / 10%);
        border-radius: 8rpx;
      }
    }
  }
}
</style>
