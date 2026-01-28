<template>
  <view class="message-page">
    <!-- 背景装饰 -->
    <view class="bg-decorations">
      <view class="blob blob-1" />
      <view class="blob blob-2" />
      <view class="blob blob-3" />
    </view>

    <view class="page-container">
      <!-- 精美头部区域 -->
      <view class="header-section">
        <!-- 状态栏占位 -->
        <view class="status-bar" :style="{ height: `${statusBarHeight}px` }" />

        <!-- 头部内容 -->
        <view class="header-content">
          <view class="header-left">
            <view class="header-title-group">
              <text class="header-title">
                消息中心
              </text>
              <text class="header-subtitle">
                Message Center
              </text>
            </view>
          </view>
        </view>

        <!-- 统计卡片 -->
        <view class="stats-cards">
          <view class="glass-card stat-card stat-card-1">
            <view class="stat-icon">
              <u-icon name="bell" size="20" color="#fff" />
            </view>
            <view class="stat-info">
              <text class="stat-value">
                {{ unreadCount }}
              </text>
              <text class="stat-label">
                未读消息
              </text>
            </view>
          </view>
          <view class="glass-card stat-card stat-card-2">
            <view class="stat-icon">
              <u-icon name="clock" size="20" color="#fff" />
            </view>
            <view class="stat-info">
              <text class="stat-value">
                {{ todayCount }}
              </text>
              <text class="stat-label">
                今日消息
              </text>
            </view>
          </view>
        </view>
      </view>

      <!-- 消息分类标签 -->
      <view class="glass-card message-tabs">
        <view
          v-for="tab in tabs"
          :key="tab.value"
          class="tab-item"
          :class="{ active: activeTab === tab.value }"
          @click="handleTabChange(tab.value)"
        >
          <view class="tab-content">
            <u-icon :name="tab.icon" size="16" />
            <text class="tab-label">
              {{ tab.label }}
            </text>
          </view>
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
        :show-scrollbar="false"
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
            class="message-item-wrapper animate-fade-in"
            :style="{ 'animation-delay': `${index * 0.05}s` }"
          >
            <view
              class="glass-card message-item"
              @click="handleViewDetail(item)"
            >
              <!-- 消息内容 -->
              <view class="item-main">
                <!-- 消息头部 -->
                <view class="item-header">
                  <view class="icon-wrapper" :class="`icon-type-${item.type}`">
                    <u-icon :name="getIconName(item.type)" size="18" color="#fff" />
                  </view>
                  <view class="header-info">
                    <view class="title-row">
                      <text class="title">
                        {{ item.title }}
                      </text>
                      <view v-if="!item.isRead" class="new-badge">
                        <view class="badge-dot" />
                      </view>
                    </view>
                    <text class="time">
                      {{ formatTime(item.createTime) }}
                    </text>
                  </view>
                  <u-icon name="arrow-right" size="16" color="#9ca3af" />
                </view>

                <!-- 消息内容 -->
                <view class="item-body">
                  <text class="content">
                    {{ item.content }}
                  </text>
                </view>
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
import { NoticeType } from '@/types';

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
  icon: string;
}

const loading = ref(false);
const list = ref<MessageItem[]>([]);
const activeTab = ref<'all' | NoticeType>('all');
const statusBarHeight = ref(0);

const tabs = ref<TabItem[]>([
  { label: '全部', value: 'all', icon: 'list' },
  { label: '系统', value: NoticeType.SYSTEM, icon: 'bell' },
  { label: '宿舍', value: NoticeType.DORM, icon: 'home' },
  { label: '安全', value: NoticeType.SAFETY, icon: 'warning' },
]);

const INDICATOR_WIDTH_RPX = 50;

// 计算未读消息数量
const unreadCount = computed(() => {
  return list.value.filter(item => !item.isRead).length;
});

// 计算今日消息数量
const todayCount = computed(() => {
  const today = new Date().toISOString().split('T')[0];
  return list.value.filter(item => item.createTime.startsWith(today)).length;
});

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
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync();
  statusBarHeight.value = systemInfo.statusBarHeight || 0;

  loadData();
});
</script>

<style lang="scss" scoped>
// 导入公共样式变量
@import '@/styles/variables.scss';

// ========================================
// 页面布局
// ========================================

.message-page {
  overflow-x: hidden;
  min-height: 100vh;
  background: linear-gradient(135deg, $bg-gradient-start 0%, $bg-gradient-end 100%);
  background-attachment: fixed;
}

// ========================================
// 头部区域
// ========================================

.header-section {
  padding: 0 $spacing-lg $spacing-md;

  .status-bar {
    width: 100%;
  }

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 0 $spacing-md;

    .header-left {
      flex: 1;

      .header-title-group {
        display: flex;
        flex-direction: column;
        gap: 4rpx;

        .header-title {
          font-size: 40rpx;
          color: $text-main;
          font-weight: $font-bold;
          letter-spacing: 0.5rpx;
        }

        .header-subtitle {
          font-size: 22rpx;
          color: $text-sub;
          font-weight: $font-medium;
          letter-spacing: 1rpx;
          text-transform: uppercase;
        }
      }
    }
  }

  // 统计卡片
  .stats-cards {
    display: flex;
    gap: $spacing-sm;
    margin-top: $spacing-sm;

    .stat-card {
      display: flex;
      align-items: center;
      padding: 20rpx $spacing-md;
      border-radius: 20rpx;
      transition: $transition-normal;
      gap: $spacing-sm;
      flex: 1;

      &:active {
        transform: scale(0.98);
      }

      .stat-icon {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 48rpx;
        height: 48rpx;
        border-radius: 12rpx;
        flex-shrink: 0;
      }

      .stat-info {
        display: flex;
        flex-direction: column;
        gap: 4rpx;
        flex: 1;

        .stat-value {
          font-size: $font-lg;
          color: $text-main;
          font-weight: $font-bold;
          line-height: 1;
        }

        .stat-label {
          font-size: 22rpx;
          color: $text-sub;
          font-weight: $font-medium;
        }
      }

      &.stat-card-1 .stat-icon {
        background: linear-gradient(135deg, $primary 0%, $primary-dark 100%);
        box-shadow: $shadow-lg;
      }

      &.stat-card-2 .stat-icon {
        background: linear-gradient(135deg, $accent 0%, $accent-dark 100%);
        box-shadow: 0 4rpx 12rpx rgb(255 159 67 / 30%);
      }
    }
  }
}

// ========================================
// 消息分类标签（扩展公共样式）
// ========================================

.message-tabs {
  margin: 0 $spacing-lg $spacing-md;

  .tab-item {
    position: relative;
    padding: 20rpx 0;
    text-align: center;
    transition: $transition-normal;
    flex: 1;

    .tab-content {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6rpx;
      color: $text-sub;
      transition: $transition-normal;

      .tab-label {
        font-size: 26rpx;
        font-weight: $font-medium;
      }
    }

    &.active .tab-content {
      color: $primary;
      font-weight: $font-bold;
    }
  }

  .tab-indicator {
    position: absolute;
    bottom: 0;
    width: 50rpx;
    height: 4rpx;
    background: linear-gradient(90deg, $primary 0%, $primary-dark 100%);
    border-radius: 2rpx;
    box-shadow: 0 2rpx 8rpx rgb(10 219 195 / 40%);
    transition:
      left 0.3s cubic-bezier(0.4, 0, 0.2, 1),
      transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    pointer-events: none;
  }
}

// ========================================
// 消息列表容器
// ========================================

.message-list {
  padding: 0 $spacing-lg;
  padding-bottom: calc($spacing-md + env(safe-area-inset-bottom));
  width: auto;
  flex: 1;
}

// ========================================
// 加载和空状态
// ========================================

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
    border-top-color: $primary;
    border-radius: 50%;
    animation: loading-spin 1s linear infinite;
  }

  .loading-text {
    margin-top: $spacing-md;
    font-size: $font-md;
    color: $text-sub;
  }
}

.empty {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 120rpx 0;
}

// ========================================
// 列表内容
// ========================================

.list-content {
  display: flex;
  flex-direction: column;
  gap: $spacing-sm;
}

.message-item-wrapper {
  opacity: 0;
}

// ========================================
// 消息项
// ========================================

.message-item {
  position: relative;
  display: flex;
  overflow: hidden;
  padding: 0;
  background: $glass-bg;
  border: 2rpx solid $glass-border-light;
  border-radius: 20rpx;
  box-shadow: 0 4rpx 16rpx rgb(31 38 135 / 5%);
  transition: $transition-normal;
  backdrop-filter: blur(32rpx);

  &:active {
    transform: scale(0.98);
    box-shadow: 0 2rpx 8rpx rgb(31 38 135 / 8%);
  }

  .item-main {
    display: flex;
    padding: 20rpx $spacing-md;
    flex-direction: column;
    gap: 12rpx;
    flex: 1;
    min-width: 0;

    .item-header {
      display: flex;
      align-items: center;
      gap: 12rpx;

      .icon-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 44rpx;
        height: 44rpx;
        border-radius: 12rpx;
        flex-shrink: 0;

        // 图标类型颜色
        &.icon-type-1 {
          background: linear-gradient(135deg, $primary 0%, $primary-dark 100%);
          box-shadow: 0 2rpx 8rpx rgb(10 219 195 / 25%);
        }

        &.icon-type-2 {
          background: linear-gradient(135deg, $accent 0%, $accent-dark 100%);
          box-shadow: 0 2rpx 8rpx rgb(255 159 67 / 25%);
        }

        &.icon-type-3 {
          background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
          box-shadow: 0 2rpx 8rpx rgb(244 63 94 / 25%);
        }

        &.icon-type-4 {
          background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
          box-shadow: 0 2rpx 8rpx rgb(59 130 246 / 25%);
        }

        &.icon-type-99 {
          background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%);
          box-shadow: 0 2rpx 8rpx rgb(139 92 246 / 25%);
        }
      }

      .header-info {
        display: flex;
        flex-direction: column;
        gap: 4rpx;
        flex: 1;
        min-width: 0;

        .title-row {
          display: flex;
          align-items: center;
          gap: $spacing-xs;

          .title {
            overflow: hidden;
            font-size: $font-md;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: $text-main;
            font-weight: $font-semibold;
            flex: 1;
          }

          .new-badge {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-left: $spacing-xs;
            flex-shrink: 0;

            .badge-dot {
              width: 12rpx;
              height: 12rpx;
              background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%);
              border-radius: 50%;
              box-shadow: 0 0 0 0 rgb(255 107 107 / 70%);
              animation: badge-pulse 2s infinite;
            }
          }
        }

        .time {
          font-size: 22rpx;
          color: $text-disabled;
        }
      }
    }

    .item-body {
      overflow: hidden;
      padding-left: 56rpx;
      text-overflow: ellipsis;
      white-space: nowrap;

      .content {
        font-size: $font-sm;
        color: $text-sub;
        line-height: 1.6;
      }
    }
  }
}

// ========================================
// 动画
// ========================================

@keyframes loading-spin {
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
}

@keyframes badge-pulse {
  0% {
    box-shadow: 0 0 0 0 rgb(255 107 107 / 70%);
  }

  70% {
    box-shadow: 0 0 0 10rpx rgb(255 107 107 / 0%);
  }

  100% {
    box-shadow: 0 0 0 0 rgb(255 107 107 / 0%);
  }
}
</style>
