<template>
  <view class="apply-list-page">
    <!-- 背景装饰 -->
    <view class="bg-decorations">
      <view class="blob blob-1" />
    </view>

    <view class="page-container">
      <!-- 顶部导航栏 -->
      <header class="top-header">
        <view class="header-back" @click="handleBack">
          <u-icon name="arrow-left" size="22" color="#111817" />
        </view>
        <view class="header-title">
          {{ pageTitle }}
        </view>
        <view class="header-placeholder" />
      </header>

      <!-- Tab切换栏 -->
      <view class="apply-tabs glass-card">
        <view
          v-for="tab in tabs"
          :key="tab.value"
          class="tab-item"
          :class="{ active: activeTab === tab.value }"
          @click="handleTabChange(tab.value)"
        >
          {{ tab.label }}
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
import { ApplyStatus, ApplyStatusColor, ApplyStatusText } from '@/types';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();
const { userInfo } = storeToRefs(userStore);

// Tab选项
const tabs = ref([
  { label: '全部', value: 'all', count: 0 },
  { label: '待审核', value: ApplyStatus.PENDING, count: 0 },
  { label: '已通过', value: ApplyStatus.APPROVED, count: 0 },
  { label: '已拒绝', value: ApplyStatus.REJECTED, count: 0 },
]);

const activeTab = ref<string | number>('all');
const loading = ref(false);
const list = ref<any[]>([]);

// 指示线样式
const indicatorStyle = computed(() => {
  const activeIndex = tabs.value.findIndex(tab => tab.value === activeTab.value);
  if (activeIndex === -1) {
    return {
      width: '60rpx',
      left: '0rpx',
    };
  }

  // 由于所有 Tab 都是等宽的（flex: 1），直接计算百分比位置
  // 每个 Tab 占 100% / tabs.length
  // 指示线居中：left = (activeIndex * 100% / tabs.length) + (100% / tabs.length - 60rpx) / 2
  const tabCount = tabs.value.length;
  const tabWidthPercent = 100 / tabCount;
  const indicatorWidthRpx = 60;

  // 使用百分比 + transform 的方式实现居中
  // left = activeIndex * tabWidthPercent + tabWidthPercent / 2 (每个 Tab 的中心位置)
  // 然后使用 translateX(-50%) 让指示线居中
  const leftPercent = activeIndex * tabWidthPercent + (tabWidthPercent / 2);

  return {
    width: `${indicatorWidthRpx}rpx`,
    left: `${leftPercent}%`,
    transform: 'translateX(-50%)',
  };
});

// 获取管理权限状态
const hasManagePermission = computed(() => {
  const role = userInfo.value?.role;
  return role === 'dorm_manager' || role === 'admin';
});

// 根据角色显示不同的标题
const pageTitle = computed(() => {
  return hasManagePermission.value ? '审批中心' : '我的申请';
});

// 获取申请类型名称
function getApplyTypeName(type: string) {
  const typeMap: Record<string, string> = {
    checkIn: '入住申请',
    normalCheckIn: '正常入住',
    tempCheckIn: '临时入住',
    transfer: '调宿申请',
    checkOut: '退宿申请',
    stay: '留宿申请',
  };
  return typeMap[type] || '申请';
}

// 获取申请类型图标和颜色
function getApplyTypeIcon(type: string) {
  const iconMap: Record<string, { icon: string; iconColor: string; bgColor: string }> = {
    checkIn: { icon: 'home', iconColor: '#14b8a6', bgColor: 'rgba(20, 184, 166, 0.1)' },
    normalCheckIn: { icon: 'home', iconColor: '#14b8a6', bgColor: 'rgba(20, 184, 166, 0.1)' },
    tempCheckIn: { icon: 'home', iconColor: '#14b8a6', bgColor: 'rgba(20, 184, 166, 0.1)' },
    transfer: { icon: 'reload', iconColor: '#6366f1', bgColor: 'rgba(99, 102, 241, 0.1)' },
    checkOut: { icon: 'arrow-left', iconColor: '#f43f5e', bgColor: 'rgba(244, 63, 94, 0.1)' },
    stay: { icon: 'calendar', iconColor: '#3b82f6', bgColor: 'rgba(59, 130, 246, 0.1)' },
  };
  return iconMap[type] || { icon: 'list', iconColor: '#6b7280', bgColor: 'rgba(107, 114, 128, 0.1)' };
}

// 获取状态文本
function getStatusText(status: ApplyStatus) {
  return ApplyStatusText[status] || '未知';
}

// 获取状态颜色
function getStatusColor(status: ApplyStatus) {
  return ApplyStatusColor[status] || '#999';
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  // 如果是完整时间戳，提取日期部分
  if (time.includes(' ')) {
    return time.split(' ')[0];
  }
  return time;
}

// Tab切换
function handleTabChange(value: string | number) {
  activeTab.value = value;
  loadData();
}

// 返回
function handleBack() {
  uni.navigateBack();
}

// 查看详情
function handleViewDetail(item: any) {
  const url = hasManagePermission.value
    ? `/pages/admin/approval-detail/index?id=${item.id}&type=${item.type}`
    : `/pages/apply/detail/index?id=${item.id}&type=${item.type}`;

  uni.navigateTo({ url });
}

// 加载数据
async function loadData() {
  loading.value = true;
  try {
    // TODO: 调用API加载数据
    // 根据activeTab筛选数据
    await new Promise(resolve => setTimeout(resolve, 1000));

    // 模拟数据
    const mockData = [
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

    // 根据activeTab筛选
    if (activeTab.value === 'all') {
      list.value = mockData;
    }
    else {
      list.value = mockData.filter(item => item.status === Number(activeTab.value));
    }

    // 更新Tab计数
    tabs.value.forEach((tab) => {
      if (tab.value === 'all') {
        tab.count = mockData.length;
      }
      else {
        tab.count = mockData.filter(item => item.status === tab.value).length;
      }
    });
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
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 32rpx;
  padding-top: calc(var(--status-bar-height) + 24rpx);

  .header-back {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;

    &:active {
      background: rgb(0 0 0 / 5%);
    }
  }

  .header-title {
    font-size: 36rpx;
    text-align: center;
    color: $text-main;
    flex: 1;
    font-weight: 700;
    letter-spacing: 0.5rpx;
  }

  .header-placeholder {
    width: 80rpx;
  }
}

// Tab切换栏
.apply-tabs {
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
  backdrop-filter: blur(32rpx);

  .tab-item {
    position: relative;
    padding: 24rpx 0;
    font-size: 28rpx;
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

  // 筋斗云指示线
  .tab-indicator {
    position: absolute;
    bottom: 0;
    width: 60rpx;
    height: 4rpx;
    background: $primary;
    border-radius: 2rpx;
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
  gap: 24rpx;
}

// 列表项
.apply-item {
  padding: 32rpx;
  background: $glass-bg;
  border: 0.0625rem solid $glass-border-light;
  border-radius: 32rpx;
  box-shadow: 0 8rpx 32rpx rgb(31 38 135 / 7%);
  transition: all 0.3s;
  backdrop-filter: blur(32rpx);
  backdrop-filter: blur(32rpx);

  &:active {
    transform: scale(0.98);
    box-shadow: 0 4rpx 16rpx rgb(31 38 135 / 10%);
  }

  .item-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;

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
    padding-top: 24rpx;
    margin-bottom: 24rpx;

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
          font-size: 24rpx;
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
    padding-top: 24rpx;
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
