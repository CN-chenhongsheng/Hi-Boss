<template>
  <view class="message-page">
    <scroll-view class="message-list" scroll-y>
      <view v-if="loading" class="loading">
        <view class="loading-spinner" />
        <view class="loading-text">
          加载中...
        </view>
      </view>

      <view v-else-if="list.length === 0" class="empty">
        <u-empty mode="list" text="暂无消息" />
      </view>

      <view v-else class="list-content">
        <view
          v-for="item in list"
          :key="item.id"
          class="message-item"
          @click="handleViewDetail(item)"
        >
          <view class="item-left">
            <view class="icon" :class="`icon-${item.type}`">
              <u-icon :name="getIconName(item.type)" size="24" color="#fff" />
            </view>
          </view>
          <view class="item-content">
            <view class="title-row">
              <text class="title">
                {{ item.title }}
              </text>
              <view v-if="!item.isRead" class="unread-dot" />
            </view>
            <view class="content">
              {{ item.content }}
            </view>
            <view class="time">
              {{ item.createTime }}
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { NoticeType } from '@/types';

const loading = ref(false);
const list = ref<any[]>([]);

// 获取图标名称
function getIconName(type: NoticeType) {
  const iconMap: Record<NoticeType, string> = {
    [NoticeType.SYSTEM]: 'bell',
    [NoticeType.DORM]: 'home',
    [NoticeType.SAFETY]: 'warning',
    [NoticeType.MAINTENANCE]: 'setting',
    [NoticeType.OTHER]: 'info-circle',
  };
  return iconMap[type] || 'info-circle';
}

// 查看详情
function handleViewDetail(item: any) {
  uni.navigateTo({
    url: `/pages/service/notice-detail/index?id=${item.id}`,
  });
}

// 加载数据
async function loadData() {
  loading.value = true;
  try {
    // TODO: 调用API加载数据
    await new Promise(resolve => setTimeout(resolve, 1000));
    list.value = [];
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
  loadData();
});
</script>

<style lang="scss" scoped>
.message-page {
  height: 100vh;
  background-color: #f5f5f5;
}

.message-list {
  padding: 20rpx;
  height: 100%;
}

.loading,
.empty {
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

.list-content {
  .message-item {
    display: flex;
    padding: 24rpx;
    margin-bottom: 20rpx;
    background-color: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .item-left {
      margin-right: 20rpx;

      .icon {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 80rpx;
        height: 80rpx;
        border-radius: 50%;

        &.icon-1 {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        &.icon-2 {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        &.icon-3 {
          background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        &.icon-4 {
          background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
        }

        &.icon-99 {
          background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
        }
      }
    }

    .item-content {
      flex: 1;
      min-width: 0;

      .title-row {
        display: flex;
        align-items: center;
        margin-bottom: 12rpx;

        .title {
          overflow: hidden;
          font-size: 30rpx;
          text-overflow: ellipsis;
          white-space: nowrap;
          color: #333;
          flex: 1;
          font-weight: 600;
        }

        .unread-dot {
          margin-left: 12rpx;
          width: 16rpx;
          height: 16rpx;
          background-color: #f44336;
          border-radius: 50%;
        }
      }

      .content {
        display: -webkit-box;
        overflow: hidden;
        margin-bottom: 12rpx;
        font-size: 26rpx;
        text-overflow: ellipsis;
        color: #666;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
      }

      .time {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}
</style>
