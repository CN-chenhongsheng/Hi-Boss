<template>
  <view class="notice-detail-page">
    <view v-if="loading" class="loading">
      <view class="loading-spinner" />
      <view class="loading-text">
        加载中...
      </view>
    </view>

    <view v-else-if="notice" class="notice-content">
      <view class="notice-header">
        <view class="title">
          {{ notice.title }}
        </view>
        <view class="meta">
          <view class="publisher">
            {{ notice.publisherName }}
          </view>
          <view class="time">
            {{ notice.publishTime }}
          </view>
        </view>
      </view>

      <view class="notice-body">
        <view class="content">
          {{ notice.content }}
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { getNoticeDetailAPI, markNoticeReadAPI } from '@/api';

const loading = ref(false);
const notice = ref<any>(null);
const noticeId = ref(0);

async function loadDetail() {
  loading.value = true;
  try {
    notice.value = await getNoticeDetailAPI(noticeId.value);
    // 标记为已读
    await markNoticeReadAPI(noticeId.value);
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

  noticeId.value = Number(options.id);
  if (noticeId.value) {
    loadDetail();
  }
});
</script>

<style lang="scss" scoped>
.notice-detail-page {
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

.notice-content {
  background: #fff;

  .notice-header {
    padding: 40rpx 30rpx;
    border-bottom: 1rpx solid #f0f0f0;

    .title {
      margin-bottom: 20rpx;
      font-size: 36rpx;
      color: #333;
      font-weight: 600;
      line-height: 1.5;
    }

    .meta {
      display: flex;
      align-items: center;
      font-size: 24rpx;
      color: #999;

      .publisher {
        margin-right: 20rpx;
      }
    }
  }

  .notice-body {
    padding: 30rpx;

    .content {
      font-size: 28rpx;
      white-space: pre-wrap;
      color: #666;
      line-height: 1.8;
    }
  }
}
</style>
