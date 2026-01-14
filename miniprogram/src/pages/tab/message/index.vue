<template>
  <view class="message-page">
    <!-- 背景装饰 -->
    <view class="bg-decorations">
      <view class="blob blob-1" />
      <view class="blob blob-2" />
    </view>

    <view class="page-container">
      <!-- 顶部导航栏 -->
      <header class="top-header">
        <view class="header-title">
          消息中心
        </view>
      </header>

      <!-- 消息分类标签 -->
      <view class="glass-card message-tabs">
        <view
          v-for="tab in tabs"
          :key="tab.value"
          class="tab-item"
          :class="{ active: activeTab === tab.value }"
          @click="handleTabChange(tab.value)"
        >
          {{ tab.label }}
        </view>
        <view
          class="tab-indicator"
          :style="indicatorStyle"
        />
      </view>

      <!-- 消息列表 -->
      <scroll-view
        class="message-list"
        scroll-y
      >
        <!-- 加载状态 -->
        <view v-if="loading" class="loading">
          <view class="loading-spinner" />
          <view class="loading-text">
            加载中...
          </view>
        </view>

        <!-- 空状态 -->
        <view v-else-if="list.length === 0" class="empty">
          <u-empty mode="list" text="暂无消息" icon-size="120" />
        </view>

        <!-- 消息列表内容 -->
        <view v-else class="list-content">
          <view
            v-for="(item, index) in list"
            :key="item.id"
            class="glass-card message-item animate-fade-in"
            :style="{ 'animation-delay': `${index * 0.05}s` }"
            @click="handleViewDetail(item)"
          >
            <!-- 消息图标 -->
            <view class="item-left">
              <view class="icon" :class="`icon-${item.type}`">
                <u-icon :name="getIconName(item.type)" size="20" color="#fff" />
              </view>
            </view>

            <!-- 消息内容 -->
            <view class="item-content">
              <view class="title-row">
                <view class="title-badge">
                  <text class="title">
                    {{ item.title }}
                  </text>
                  <view v-if="!item.isRead" class="unread-badge">
                    新
                  </view>
                </view>
                <u-icon name="arrow-right" size="16" color="#9ca3af" />
              </view>
              <view class="content">
                {{ item.content }}
              </view>
              <view class="meta-info">
                <text class="time">
                  {{ formatTime(item.createTime) }}
                </text>
              </view>
            </view>
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { ROUTE_CONSTANTS } from '@/constants';

interface MessageItem {
  id: number;
  type: NoticeType;
  title: string;
  content: string;
  createTime: string;
  isRead: boolean;
}

interface TabItem {
  label: string;
  value: 'all' | NoticeType;
}

const loading = ref(false);
const list = ref<MessageItem[]>([]);
const activeTab = ref<'all' | NoticeType>('all');

const tabs = ref<TabItem[]>([
  { label: '全部', value: 'all' },
  { label: '系统', value: NoticeType.SYSTEM },
  { label: '宿舍', value: NoticeType.DORM },
  { label: '安全', value: NoticeType.SAFETY },
]);

const INDICATOR_WIDTH_RPX = 50;

const indicatorStyle = computed(() => {
  const activeIndex = tabs.value.findIndex(tab => tab.value === activeTab.value);
  if (activeIndex === -1) {
    return { width: '50rpx', left: '0rpx' };
  }

  const tabWidthPercent = 100 / tabs.value.length;
  const leftPercent = activeIndex * tabWidthPercent + tabWidthPercent / 2;

  return {
    width: `${INDICATOR_WIDTH_RPX}rpx`,
    left: `${leftPercent}%`,
    transform: 'translateX(-50%)',
  };
});

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

// 格式化时间
function formatTime(time: string): string {
  if (!time) return '';
  const date = new Date(time);
  const now = new Date();
  const diff = now.getTime() - date.getTime();
  const minutes = Math.floor(diff / 60000);
  const hours = Math.floor(diff / 3600000);
  const days = Math.floor(diff / 86400000);

  if (minutes < 1) return '刚刚';
  if (minutes < 60) return `${minutes}分钟前`;
  if (hours < 24) return `${hours}小时前`;
  if (days < 7) return `${days}天前`;

  return time.split(' ')[0];
}

// 处理标签切换
function handleTabChange(value: 'all' | NoticeType): void {
  activeTab.value = value;
  loadData();
}

// 查看详情
function handleViewDetail(item: MessageItem) {
  uni.navigateTo({
    url: `${ROUTE_CONSTANTS.NOTICE_DETAIL}?id=${item.id}`,
  });
}

// 加载数据
async function loadData(): Promise<void> {
  loading.value = true;
  try {
    await new Promise(resolve => setTimeout(resolve, 1000));

    const mockData: MessageItem[] = [
      {
        id: 1,
        type: NoticeType.SYSTEM,
        title: '系统维护通知',
        content: '系统将于本周日凌晨2点进行维护，预计维护时间为2小时，期间服务暂时不可用...',
        createTime: '2026-01-14 10:30',
        isRead: false,
      },
      {
        id: 2,
        type: NoticeType.DORM,
        title: '宿舍卫生检查',
        content: '本周五进行宿舍卫生检查，请各位同学提前做好卫生工作，感谢配合...',
        createTime: '2026-01-13 15:45',
        isRead: true,
      },
      {
        id: 3,
        type: NoticeType.SAFETY,
        title: '安全提示',
        content: '近期校园周边发生多起诈骗案件，请各位同学提高警惕，不要相信陌生人...',
        createTime: '2026-01-12 09:20',
        isRead: true,
      },
      {
        id: 4,
        type: NoticeType.DORM,
        title: '宿舍用电安全提醒',
        content: '禁止在宿舍使用大功率电器，如发现违规使用将进行处罚...',
        createTime: '2026-01-11 14:00',
        isRead: true,
      },
      {
        id: 5,
        type: NoticeType.SYSTEM,
        title: '新功能上线',
        content: '宿舍管理系统新增了在线报修功能，欢迎各位同学使用...',
        createTime: '2026-01-10 11:30',
        isRead: true,
      },
    ];

    list.value = activeTab.value === 'all'
      ? mockData
      : mockData.filter(item => item.type === activeTab.value);
  }
  catch (error) {
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
// 主题变量
$primary: #0adbc3;
$primary-dark: #08bda8;
$accent: #ff9f43;
$bg-light: #f5f8f8;
$text-main: #111817;
$text-sub: #6b7280;
$glass-bg: rgb(255 255 255 / 65%);
$glass-border: rgb(255 255 255 / 80%);
$glass-border-light: rgb(255 255 255 / 60%);

.message-page {
  overflow-x: hidden;
  min-height: 100vh;
  background: linear-gradient(135deg, #f0fdfa 0%, #ecfccb 100%);
  background-attachment: fixed;
}

// 背景装饰
.bg-decorations {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;

  .blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(80rpx);

    &.blob-1 {
      top: -200rpx;
      right: -100rpx;
      width: 600rpx;
      height: 600rpx;
      background: rgb(10 219 195 / 5%);
    }

    &.blob-2 {
      bottom: -150rpx;
      left: -100rpx;
      width: 500rpx;
      height: 500rpx;
      background: rgb(255 159 67 / 3%);
    }
  }
}

.page-container {
  position: relative;
  z-index: 1;
  display: flex;
  margin: 0 auto;
  max-width: 750rpx;
  min-height: 100vh;
  flex-direction: column;
}

// 顶部导航栏
.top-header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 24rpx 32rpx;
  padding-top: calc(var(--status-bar-height) + 24rpx);

  .header-title {
    font-size: 36rpx;
    text-align: center;
    color: $text-main;
    font-weight: 700;
    letter-spacing: 0.5rpx;
  }
}

// 消息分类标签
.message-tabs {
  position: sticky;
  top: calc(var(--status-bar-height) + 88rpx);
  z-index: 40;
  display: flex;
  overflow: hidden;
  padding: 0;
  margin: 0 32rpx;
  margin-top: 24rpx;
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 32rpx rgb(31 38 135 / 7%);
  backdrop-filter: blur(32rpx);

  .tab-item {
    position: relative;
    padding: 20rpx 0;
    font-size: 26rpx;
    text-align: center;
    color: $text-sub;
    transition: color 0.3s, font-weight 0.3s;
    flex: 1;
    font-weight: 500;

    &.active {
      color: $primary;
      font-weight: 700;
    }
  }

  // 指示线
  .tab-indicator {
    position: absolute;
    bottom: 0;
    width: 50rpx;
    height: 4rpx;
    background: $primary;
    border-radius: 2rpx;
    transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1), transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    pointer-events: none;
  }
}

// 消息列表容器
.message-list {
  padding: 24rpx 32rpx;
  padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  width: auto;
  flex: 1;
}

// 加载状态
.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 120rpx 0;
  flex-direction: column;

  .loading-spinner {
    width: 60rpx;
    height: 60rpx;
    border: 4rpx solid rgb(243 243 243);
    border-top: 4rpx solid $primary;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  .loading-text {
    margin-top: 24rpx;
    font-size: 28rpx;
    color: $text-sub;
  }
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

// 空状态
.empty {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 120rpx 0;
}

// 列表内容
.list-content {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

// 消息项
.message-item {
  display: flex;
  padding: 24rpx;
  background: $glass-bg;
  border: 0.0625rem solid $glass-border-light;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 32rpx rgb(31 38 135 / 7%);
  transition: all 0.3s;
  backdrop-filter: blur(32rpx);
  gap: 16rpx;

  &:active {
    transform: scale(0.98);
    box-shadow: 0 4rpx 16rpx rgb(31 38 135 / 10%);
  }

  .item-left {
    flex-shrink: 0;

    .icon {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 56rpx;
      height: 56rpx;
      border-radius: 16rpx;
      flex-shrink: 0;

      &.icon-1 {
        background: linear-gradient(135deg, #0adbc3 0%, #08bda8 100%);
      }

      &.icon-2 {
        background: linear-gradient(135deg, #ff9f43 0%, #ff8f2b 100%);
      }

      &.icon-3 {
        background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
      }

      &.icon-4 {
        background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
      }

      &.icon-99 {
        background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%);
      }
    }
  }

  .item-content {
    display: flex;
    justify-content: space-between;
    min-width: 0;
    flex: 1;
    flex-direction: column;

    .title-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 8rpx;

      .title-badge {
        display: flex;
        align-items: center;
        gap: 8rpx;
        flex: 1;
        min-width: 0;

        .title {
          overflow: hidden;
          font-size: 28rpx;
          text-overflow: ellipsis;
          white-space: nowrap;
          color: $text-main;
          font-weight: 600;
        }

        .unread-badge {
          padding: 4rpx 8rpx;
          font-size: 20rpx;
          color: #fff;
          background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
          border-radius: 8rpx;
          flex-shrink: 0;
          font-weight: 600;
        }
      }
    }

    .content {
      display: -webkit-box;
      overflow: hidden;
      margin-bottom: 8rpx;
      font-size: 24rpx;
      text-overflow: ellipsis;
      color: $text-sub;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      line-height: 1.5;
    }

    .meta-info {
      display: flex;
      align-items: center;
      gap: 12rpx;

      .time {
        font-size: 22rpx;
        color: #9ca3af;
      }
    }
  }
}

// 毛玻璃卡片
.glass-card {
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  box-shadow: 0 8rpx 32rpx rgb(31 38 135 / 7%);
  backdrop-filter: blur(32rpx);
}

// 淡入动画
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20rpx);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  opacity: 0;
  animation: fadeIn 0.5s ease-out forwards;
}
</style>
