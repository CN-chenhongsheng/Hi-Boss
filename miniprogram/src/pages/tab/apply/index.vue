<template>
  <view class="apply-list-page">
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
                {{ pageTitle }}
              </text>
              <text class="header-subtitle">
                {{ hasManagePermission ? 'Approval Center' : 'My Applications' }}
              </text>
            </view>
          </view>
        </view>
      </view>

      <!-- Tab切换栏 -->
      <view class="glass-card apply-tabs">
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
        <!-- 筋斗云指示线 -->
        <view
          class="tab-indicator"
          :style="indicatorStyle"
        />
      </view>

      <!-- 列表内容 -->
      <scroll-view
        class="apply-list"
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
          <u-empty mode="list" text="暂无申请记录" icon-size="120" />
        </view>

        <!-- 列表内容 -->
        <view v-else class="list-content">
          <view
            v-for="(item, index) in list"
            :key="item.id"
            class="glass-card apply-item animate-fade-in"
            :style="{ 'animation-delay': `${index * 0.05}s` }"
            @click="handleViewDetail(item)"
          >
            <!-- 列表项头部 -->
            <view class="item-header">
              <view class="item-left">
                <view class="item-icon">
                  <u-icon
                    :name="getApplyTypeIcon(item.type).icon"
                    size="20"
                    :color="getApplyTypeIcon(item.type).iconColor"
                  />
                </view>
                <view class="item-info">
                  <view class="item-title">
                    {{ getApplyTypeName(item.type) }}
                  </view>
                  <view class="item-date">
                    {{ item.applyDate || item.createTime }}
                  </view>
                </view>
              </view>
              <view
                class="item-status"
                :style="{ color: getStatusColor(item.status) }"
              >
                {{ getStatusText(item.status) }}
              </view>
            </view>

            <!-- 列表项内容 -->
            <view v-if="item.approveTime || item.reason" class="item-content">
              <view v-if="item.approveTime" class="info-row">
                <text class="info-label">
                  审批时间：
                </text>
                <text class="info-value">
                  {{ item.approveTime }}
                </text>
              </view>
              <view v-if="item.reason" class="info-row reason-row">
                <text class="info-label">
                  申请理由：
                </text>
                <text class="info-value reason-text">
                  {{ item.reason }}
                </text>
              </view>
            </view>

            <!-- 列表项底部 -->
            <view class="item-footer">
              <view class="item-meta">
                <text class="meta-text">
                  {{ formatTime(item.createTime) }}
                </text>
              </view>
              <u-icon name="arrow-right" size="16" color="#9ca3af" />
            </view>
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { onShow } from '@dcloudio/uni-app';
import type { IApplyListItem } from '@/types';
import { ApplyStatus, UserRole } from '@/types';
import useUserStore from '@/store/modules/user';
import {
  formatTime,
  getApplyTypeIcon,
  getApplyTypeName,
  getStatusColor,
  getStatusText,
} from '@/utils/apply';
import { ROUTE_CONSTANTS } from '@/constants';

/** Tab 项类型 */
interface TabItem {
  label: string;
  value: 'all' | ApplyStatus;
  count: number;
  icon: string;
}

const userStore = useUserStore();
const { userInfo } = storeToRefs(userStore);

// 页面显示时检查登录状态
onShow(() => {
  if (!userStore.token) {
    uni.reLaunch({ url: '/pages/common/login/index' });
  }
});

const tabs = ref<TabItem[]>([
  { label: '全部', value: 'all', count: 0, icon: 'list' },
  { label: '待审核', value: ApplyStatus.PENDING, count: 0, icon: 'clock' },
  { label: '已通过', value: ApplyStatus.APPROVED, count: 0, icon: 'checkmark-circle' },
  { label: '已拒绝', value: ApplyStatus.REJECTED, count: 0, icon: 'close-circle' },
]);

const activeTab = ref<'all' | ApplyStatus>('all');
const loading = ref(false);
const list = ref<IApplyListItem[]>([]);
const statusBarHeight = ref(0);

const INDICATOR_WIDTH_RPX = 60;

const indicatorStyle = computed(() => {
  const activeIndex = tabs.value.findIndex(tab => tab.value === activeTab.value);
  if (activeIndex === -1) {
    return { width: '60rpx', left: '0rpx' };
  }

  const tabWidthPercent = 100 / tabs.value.length;
  const leftPercent = activeIndex * tabWidthPercent + tabWidthPercent / 2;

  return {
    width: `${INDICATOR_WIDTH_RPX}rpx`,
    left: `${leftPercent}%`,
    transform: 'translateX(-50%)',
  };
});

const hasManagePermission = computed(() => {
  const role = userInfo.value?.role;
  return role === UserRole.DORM_MANAGER || role === UserRole.ADMIN;
});

const pageTitle = computed(() => {
  return hasManagePermission.value ? '审批中心' : '我的申请';
});

function handleTabChange(value: 'all' | ApplyStatus): void {
  activeTab.value = value;
  loadData();
}

function handleViewDetail(item: IApplyListItem): void {
  const basePath = hasManagePermission.value
    ? ROUTE_CONSTANTS.ADMIN_APPROVAL_DETAIL
    : ROUTE_CONSTANTS.STUDENT_APPLY_DETAIL;

  uni.navigateTo({ url: `${basePath}?id=${item.id}&type=${item.type}` });
}

async function loadData(): Promise<void> {
  loading.value = true;
  try {
    // TODO: 调用API加载数据
    await new Promise(resolve => setTimeout(resolve, 1000));

    const mockData: IApplyListItem[] = [
      {
        id: 1,
        type: 'transfer',
        status: ApplyStatus.PENDING,
        applyDate: '2026-01-05',
        createTime: '2026-01-05 10:20',
        reason: '希望调换到更安静的宿舍',
      },
      {
        id: 2,
        type: 'checkIn',
        status: ApplyStatus.APPROVED,
        applyDate: '2026-01-03',
        createTime: '2026-01-03 14:30',
        approveTime: '2026-01-04 09:15',
        reason: '新生入住申请',
      },
      {
        id: 3,
        type: 'checkOut',
        status: ApplyStatus.PENDING,
        applyDate: '2026-01-07',
        createTime: '2026-01-07 16:45',
        reason: '毕业离校',
      },
      {
        id: 4,
        type: 'stay',
        status: ApplyStatus.APPROVED,
        applyDate: '2026-01-01',
        createTime: '2026-01-01 08:00',
        approveTime: '2026-01-02 10:30',
        reason: '寒假留校申请',
      },
    ];

    list.value = activeTab.value === 'all'
      ? mockData
      : mockData.filter(item => item.status === activeTab.value);

    updateTabCounts(mockData);
  }
  catch (error) {
    console.error('加载失败:', error);
    uni.showToast({ title: '加载失败', icon: 'none' });
  }
  finally {
    loading.value = false;
  }
}

function updateTabCounts(data: IApplyListItem[]): void {
  tabs.value.forEach((tab) => {
    tab.count = tab.value === 'all'
      ? data.length
      : data.filter(item => item.status === tab.value).length;
  });
}

onMounted(() => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync();
  statusBarHeight.value = systemInfo.statusBarHeight || 0;

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

.apply-list-page {
  overflow-x: hidden;
  min-height: 100vh;
  background: linear-gradient(135deg, #f0fdfa 0%, #ecfccb0c 100%);
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
    filter: blur(100rpx);
    animation: float 20s ease-in-out infinite;

    &.blob-1 {
      top: -200rpx;
      right: -100rpx;
      width: 600rpx;
      height: 600rpx;
      background: rgb(255 220 220 / 75%);
      animation-delay: 0s;
    }

    &.blob-2 {
      bottom: -150rpx;
      left: -100rpx;
      width: 500rpx;
      height: 500rpx;
      background: rgb(255 220 180 / 45%);
      animation-delay: 5s;
    }

    &.blob-3 {
      top: 50%;
      left: 50%;
      width: 400rpx;
      height: 400rpx;
      background: rgb(255 200 180 / 30%);
      animation-delay: 10s;
      transform: translate(-50%, -50%);
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

// 精美头部区域
.header-section {
  padding: 0 32rpx 24rpx;
  padding-bottom: 0;

  .status-bar {
    width: 100%;
  }

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 0 24rpx;

    .header-left {
      flex: 1;

      .header-title-group {
        display: flex;
        flex-direction: column;
        gap: 4rpx;

        .header-title {
          font-size: 40rpx;
          color: $text-main;
          font-weight: 700;
          letter-spacing: 0.5rpx;
        }

        .header-subtitle {
          font-size: 22rpx;
          color: $text-sub;
          font-weight: 500;
          letter-spacing: 1rpx;
          text-transform: uppercase;
        }
      }
    }
  }
}

// Tab切换栏
.apply-tabs {
  position: sticky;
  top: 0;
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
    text-align: center;
    transition: all 0.3s;
    flex: 1;

    .tab-content {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6rpx;
      color: $text-sub;
      transition: all 0.3s;

      .tab-label {
        font-size: 26rpx;
        font-weight: 500;
      }
    }

    &.active {
      .tab-content {
        color: $primary;
        font-weight: 700;
      }
    }
  }

  // 筋斗云指示线
  .tab-indicator {
    position: absolute;
    bottom: 0;
    width: 60rpx;
    height: 4rpx;
    background: linear-gradient(90deg, $primary 0%, $primary-dark 100%);
    border-radius: 2rpx;
    box-shadow: 0 2rpx 8rpx rgb(10 219 195 / 40%);
    transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1), transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    pointer-events: none;
  }
}

// 列表容器
.apply-list {
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
  gap: 16rpx;
}

// 列表项
.apply-item {
  padding: 0;
  background: $glass-bg;
  border: 2rpx solid $glass-border-light;
  border-radius: 20rpx;
  box-shadow: 0 4rpx 16rpx rgb(31 38 135 / 5%);
  transition: all 0.3s;
  backdrop-filter: blur(32rpx);

  &:active {
    transform: scale(0.98);
    box-shadow: 0 2rpx 8rpx rgb(31 38 135 / 8%);
  }

  .item-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 20rpx 24rpx 0;

    .item-left {
      flex: 1;
      display: flex;
      align-items: center;
      gap: 24rpx;

      .item-icon {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 40rpx;
        height: 40rpx;
        border-radius: 20rpx;
        flex-shrink: 0;
      }

      .item-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 8rpx;

        .item-title {
          font-size: 32rpx;
          font-weight: 700;
          color: $text-main;
        }

        .item-date {
          font-size: 24rpx;
          color: $text-sub;
        }
      }
    }

    .item-status {
      padding: 8rpx 16rpx;
      font-size: 24rpx;
      background: rgb(255 255 255 / 60%);
      border-radius: 16rpx;
      flex-shrink: 0;
      font-weight: 600;
    }
  }

  .item-content {
    padding: 12rpx 24rpx 0;

    .info-row {
      display: flex;
      margin-bottom: 12rpx;
      font-size: 26rpx;
      line-height: 1.6;

      &:last-child {
        margin-bottom: 0;
      }

      &.reason-row {
        flex-direction: row;
        align-items: flex-start;
      }

      .info-label {
        flex-shrink: 0;
        color: $text-sub;
        font-weight: 500;
      }

      .info-value {
        flex: 1;
        color: $text-main;

        &.reason-text {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          color: $text-sub;
          line-height: 1.6;
        }
      }
    }
  }

  .item-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12rpx 24rpx 20rpx;
    margin-top: 12rpx;
    border-top: 1rpx solid rgb(229 231 235 / 50%);

    .item-meta {
      display: flex;
      align-items: center;
      gap: 16rpx;

      .meta-text {
        font-size: 24rpx;
        color: $text-sub;
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
