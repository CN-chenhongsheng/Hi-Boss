<template>
  <view class="home-page">
    <!-- 背景装饰球 -->
    <view class="ambient-blob blob-primary" />
    <view class="ambient-blob blob-accent" />
    <view class="ambient-blob blob-blue" />

    <!-- 顶部导航 -->
    <view class="header">
      <view class="header-left">
        <view class="date-text">
          {{ currentDate }}
        </view>
        <!-- 未登录状态 -->
        <view v-if="!isLoggedIn" class="header-unlogged">
          <view class="greeting-text">
            欢迎来到智慧宿舍
          </view>
          <view class="login-btn" @click="handleGoLogin">
            <text>点击登录</text>
            <u-icon name="arrow-right" size="14" color="#0adbc3" />
          </view>
        </view>
        <!-- 已登录状态 -->
        <view v-else class="greeting-text">
          {{ greeting }}，{{ userInfo?.nickname || '同学' }}
        </view>
      </view>
    </view>

    <!-- 学生端首页 -->
    <view v-if="isStudent || !isLoggedIn" class="student-home">
      <!-- 用户信息卡片（仅登录后显示） -->
      <view v-if="isLoggedIn" class="glass-card user-card">
        <view class="user-card-content">
          <image class="avatar" :src="userInfo?.avatar || defaultAvatar" mode="aspectFill" />
          <view class="user-info">
            <view class="user-name">
              {{ userInfo?.nickname || '未登录' }}
            </view>
            <view class="student-no">
              学号: {{ userInfo?.studentInfo?.studentNo || '-' }}
            </view>
            <view v-if="dormInfo !== '未分配'" class="dorm-tag">
              <u-icon name="home" size="14" color="#009688" />
              <text>{{ dormInfo }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 通知公告 -->
      <view class="section notice-section">
        <view class="section-header">
          <view class="section-title">
            通知公告
          </view>
          <view class="section-more" @click="handleGoNoticeList">
            查看全部
          </view>
        </view>
        <scroll-view class="notice-scroll" scroll-x enable-flex>
          <view
            v-for="notice in noticeList"
            :key="notice.id"
            class="glass-card notice-card"
            @click="handleViewNotice(notice)"
          >
            <view class="notice-bg-icon">
              <u-icon :name="notice.icon || 'volume'" size="80" color="rgba(0,0,0,0.03)" />
            </view>
            <view class="notice-content">
              <view class="notice-meta">
                <view class="notice-tag" :class="notice.tagClass">
                  {{ notice.tag }}
                </view>
                <view class="notice-date">
                  {{ notice.date }}
                </view>
              </view>
              <view class="notice-title">
                {{ notice.title }}
              </view>
              <view class="notice-desc">
                {{ notice.desc }}
              </view>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 快捷服务 -->
      <view class="section">
        <view class="section-title">
          快捷服务
        </view>
        <view class="service-grid">
          <view
            v-for="item in quickServices"
            :key="item.id"
            class="glass-card service-item"
            @click="handleQuickEntry(item)"
          >
            <view class="service-gradient" :style="getGradientStyle(item.color)" />
            <view class="service-bg-icon" :style="{ color: item.color }">
              <u-icon :name="item.icon" size="100" :color="item.color" />
            </view>
            <view class="service-content">
              <u-icon :name="item.icon" :size="32" :color="item.color" />
              <view class="service-name">
                {{ item.name }}
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 我的申请进度（仅登录后显示） -->
      <view v-if="isLoggedIn" class="section">
        <view class="section-header">
          <view class="section-title">
            我的申请进度
          </view>
          <view class="filter-btn" @click="handleGoApplyList">
            <u-icon name="list" size="20" color="#94a3b8" />
          </view>
        </view>
        <view v-if="applyList.length === 0" class="empty-apply">
          <u-empty mode="list" text="暂无申请记录" icon-size="120" />
        </view>
        <view v-else class="apply-list">
          <view
            v-for="item in applyList"
            :key="item.id"
            class="glass-card apply-item"
            @click="handleViewApply(item)"
          >
            <view class="apply-icon" :style="{ background: item.bgColor }">
              <u-icon :name="item.icon" size="18" :color="item.iconColor" />
            </view>
            <view class="apply-info">
              <view class="apply-header">
                <view class="apply-title">
                  {{ item.typeName }}
                </view>
                <view class="apply-status" :class="item.statusClass">
                  {{ item.statusText }}
                </view>
              </view>
              <view class="apply-date">
                {{ item.applyDate }}
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部安全区域 -->
    <view class="safe-bottom" />

    <!-- 隐私协议组件 -->
    <!-- #ifdef MP-WEIXIN -->
    <agree-privacy v-model="showAgreePrivacy" :disable-check-privacy="false" @agree="handleAgree" />
    <!-- #endif -->
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();
const { userInfo, isLoggedIn } = storeToRefs(userStore);

const defaultAvatar = 'https://via.placeholder.com/150';
const showAgreePrivacy = ref(false);

// 是否是学生
const isStudent = computed(() => userInfo.value?.role === 'student');

// 宿舍信息
const dormInfo = computed(() => {
  const student = userInfo.value?.studentInfo;
  if (!student || !student.floorCode || !student.roomCode) {
    return '未分配';
  }
  return `${student.floorCode} ${student.roomCode}室`;
});

// 当前日期
const currentDate = computed(() => {
  const now = new Date();
  const weekDays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
  return `${now.getMonth() + 1}月${now.getDate()}日 ${weekDays[now.getDay()]}`;
});

// 问候语
const greeting = computed(() => {
  const hour = new Date().getHours();
  if (hour < 6) return '凌晨好';
  if (hour < 9) return '早上好';
  if (hour < 12) return '上午好';
  if (hour < 14) return '中午好';
  if (hour < 17) return '下午好';
  if (hour < 19) return '傍晚好';
  return '晚上好';
});

// 快捷服务（学生端）
const quickServices = ref([
  { id: 1, name: '入住申请', icon: 'home', color: '#14b8a6', type: 'checkIn', path: '/pages/apply/form/index' },
  { id: 2, name: '调宿申请', icon: 'reload', color: '#6366f1', type: 'transfer', path: '/pages/apply/form/index' },
  { id: 3, name: '退宿申请', icon: 'arrow-left', color: '#f43f5e', type: 'checkOut', path: '/pages/apply/form/index' },
  { id: 4, name: '留宿申请', icon: 'calendar', color: '#3b82f6', type: 'stay', path: '/pages/apply/form/index' },
  { id: 5, name: '故障报修', icon: 'setting', color: '#f97316', type: 'repair', path: '/pages/service/repair/index' },
  { id: 6, name: '水电统计', icon: 'grid', color: '#a855f7', type: 'statistics', path: '/pages/tab/statistics/index' },
]);

// 通知列表
const noticeList = ref<any[]>([]);

// 申请列表
const applyList = ref<any[]>([]);

// 获取渐变背景样式
function getGradientStyle(color: string) {
  // 将十六进制颜色转换为 rgba，透明度为 0.05
  const hex = color.replace('#', '');
  const r = Number.parseInt(hex.substring(0, 2), 16);
  const g = Number.parseInt(hex.substring(2, 4), 16);
  const b = Number.parseInt(hex.substring(4, 6), 16);
  return {
    background: `linear-gradient(to bottom right, rgba(${r}, ${g}, ${b}, 0.05), transparent)`,
  };
}

// 快捷入口点击
function handleQuickEntry(item: any) {
  // 数据统计直接跳转到统计页面
  if (item.type === 'statistics') {
    uni.switchTab({ url: item.path });
    return;
  }
  // 其他业务类型跳转到form页面，传递type参数
  if (item.type && item.path === '/pages/apply/form/index') {
    uni.navigateTo({ url: `${item.path}?type=${item.type}` });
  }
  else {
    uni.navigateTo({ url: item.path });
  }
}

// 跳转通知列表
function handleGoNoticeList() {
  uni.switchTab({ url: '/pages/tab/message/index' });
}

// 查看通知详情
function handleViewNotice(notice: any) {
  uni.navigateTo({ url: `/pages/service/notice-detail/index?id=${notice.id}` });
}

// 跳转申请列表
function handleGoApplyList() {
  uni.switchTab({ url: '/pages/tab/apply/index' });
}

// 查看申请详情
function handleViewApply(item: any) {
  uni.navigateTo({ url: `/pages/apply/detail/index?id=${item.id}&type=${item.type}` });
}

// 同意隐私协议
function handleAgree() {
  console.log('同意隐私政策');
}

function handleGoLogin() {
  uni.navigateTo({
    url: '/pages/common/login/index',
  });
}

// 加载数据
async function loadData() {
  try {
    // TODO: 调用API加载数据
    // 模拟数据
    noticeList.value = [
      {
        id: 1,
        title: '宿舍停水通知',
        desc: '因管道维修，明日9:00-17:00将暂停供水。',
        tag: '紧急',
        tagClass: 'tag-urgent',
        date: '10-23',
        icon: 'warning',
      },
      {
        id: 2,
        title: '宿舍文化节报名',
        desc: '本周五截止报名，欢迎各寝室踊跃参加！',
        tag: '活动',
        tagClass: 'tag-activity',
        date: '10-21',
        icon: 'bell',
      },
      {
        id: 3,
        title: '消防演练通知',
        desc: '本周六下午进行消防演练，请同学们积极配合。',
        tag: '通知',
        tagClass: 'tag-notice',
        date: '10-20',
        icon: 'info-circle',
      },
    ];

    if (true) {
      applyList.value = [
        {
          id: 1,
          type: 'repair',
          typeName: '洗手台报修',
          icon: 'setting',
          iconColor: '#f97316',
          bgColor: 'rgba(249, 115, 22, 0.1)',
          statusText: '处理中',
          statusClass: 'status-processing',
          applyDate: '01-07 14:30',
        },
        {
          id: 2,
          type: 'transfer',
          typeName: '调宿申请',
          icon: 'reload',
          iconColor: '#6366f1',
          bgColor: 'rgba(99, 102, 241, 0.1)',
          statusText: '审核中',
          statusClass: 'status-pending',
          applyDate: '01-05 10:20',
        },
        {
          id: 3,
          type: 'check-in',
          typeName: '入住申请',
          icon: 'checkmark-circle',
          iconColor: '#22c55e',
          bgColor: 'rgba(34, 197, 94, 0.1)',
          statusText: '已通过',
          statusClass: 'status-approved',
          applyDate: '12-25',
        },
        {
          id: 4,
          type: 'stay',
          typeName: '留宿申请',
          icon: 'calendar',
          iconColor: '#3b82f6',
          bgColor: 'rgba(59, 130, 246, 0.1)',
          statusText: '已通过',
          statusClass: 'status-approved',
          applyDate: '12-20',
        },
        {
          id: 5,
          type: 'check-out',
          typeName: '退宿申请',
          icon: 'arrow-left',
          iconColor: '#f43f5e',
          bgColor: 'rgba(244, 63, 94, 0.1)',
          statusText: '审核中',
          statusClass: 'status-pending',
          applyDate: '01-03 16:45',
        },
        {
          id: 6,
          type: 'repair',
          typeName: '门锁维修',
          icon: 'setting',
          iconColor: '#f97316',
          bgColor: 'rgba(249, 115, 22, 0.1)',
          statusText: '已完成',
          statusClass: 'status-approved',
          applyDate: '12-28',
        },
        {
          id: 7,
          type: 'transfer',
          typeName: '调宿申请',
          icon: 'reload',
          iconColor: '#ef4444',
          bgColor: 'rgba(239, 68, 68, 0.1)',
          statusText: '已拒绝',
          statusClass: 'status-rejected',
          applyDate: '12-15',
        },
        {
          id: 8,
          type: 'repair',
          typeName: '空调故障',
          icon: 'setting',
          iconColor: '#f97316',
          bgColor: 'rgba(249, 115, 22, 0.1)',
          statusText: '处理中',
          statusClass: 'status-processing',
          applyDate: '01-06 09:15',
        },
      ];
    }
  }
  catch (error) {
    console.error('加载数据失败:', error);
  }
}

onMounted(() => {
  loadData();
});
</script>

<style lang="scss" scoped>
// 主题变量
$primary: #0adbc3;
$primary-dark: #009688;
$accent: #ff8c42;
$bg-light: #F0F4F8;

.home-page {
  position: relative;
  overflow: hidden;
  padding-bottom: env(safe-area-inset-bottom);
  min-height: 100vh;
  background-color: $bg-light;
}

// 背景装饰球
.ambient-blob {
  position: absolute;
  z-index: 0;
  border-radius: 50%;
  opacity: 0.6;
  filter: blur(120rpx);
  pointer-events: none;

  &.blob-primary {
    top: -100rpx;
    right: -100rpx;
    width: 500rpx;
    height: 500rpx;
    background-color: rgb(10 219 195 / 30%);
  }

  &.blob-accent {
    top: 400rpx;
    left: -200rpx;
    width: 560rpx;
    height: 560rpx;
    background-color: rgb(255 140 66 / 25%);
  }

  &.blob-blue {
    right: -100rpx;
    bottom: 200rpx;
    width: 500rpx;
    height: 500rpx;
    background-color: rgb(59 130 246 / 25%);
  }
}

// 毛玻璃卡片
.glass-card {
  background: rgb(255 255 255 / 65%);
  border: 2rpx solid rgb(255 255 255 / 60%);
  border-radius: 42rpx;
  box-shadow: 0 8rpx 60rpx rgb(0 0 0 / 3%);
  backdrop-filter: blur(32rpx);
}

// 顶部导航
.header {
  position: relative;
  z-index: 10;
  align-items: flex-start;
  padding: calc(var(--status-bar-height) + 20rpx) 32rpx 20rpx;
  margin-bottom: 10rpx;

  .header-left {
    .date-text {
      font-size: 24rpx;
      color: #64748b;
      font-weight: 500;
    }

    .greeting-text {
      margin-top: 8rpx;
      font-size: 48rpx;
      color: #0f172a;
      font-weight: 700;
      line-height: 1.2;
    }

    .header-unlogged {
      margin-top: 8rpx;

      .greeting-text {
        margin-top: 0;
        margin-bottom: 12rpx;
      }

      .login-btn {
        display: inline-flex;
        align-items: center;
        padding: 8rpx 16rpx;
        font-size: 24rpx;
        color: $primary;
        background: rgb(10 219 195 / 10%);
        border-radius: 9999rpx;
        transition: all 0.2s;
        gap: 4rpx;
        font-weight: 700;

        &:active {
          background: rgb(10 219 195 / 20%);
        }
      }
    }
  }
}

// 学生端首页
.student-home {
  position: relative;
  z-index: 10;
  padding: 0 32rpx;
}

// 用户卡片
.user-card {
  padding: 32rpx;
  margin-bottom: 32rpx;

  .user-card-content {
    display: flex;
    align-items: center;
    gap: 24rpx;
  }

  .avatar {
    width: 120rpx;
    height: 120rpx;
    background: #e2e8f0;
    border: 4rpx solid rgb(255 255 255 / 80%);
    border-radius: 50%;
    flex-shrink: 0;
  }

  .user-info {
    flex: 1;

    .user-name {
      font-size: 36rpx;
      font-weight: 700;
      color: #0f172a;
      line-height: 1.2;
    }

    .student-no {
      margin-top: 8rpx;
      font-size: 24rpx;
      color: #64748b;
      font-weight: 500;
    }

    .dorm-tag {
      display: inline-flex;
      align-items: center;
      padding: 8rpx 20rpx;
      margin-top: 16rpx;
      font-size: 24rpx;
      color: $primary-dark;
      background: rgb(10 219 195 / 10%);
      border-radius: 12rpx;
      gap: 8rpx;
      font-weight: 600;
    }
  }
}

// 区块样式
.section {
  margin-bottom: 32rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.section-title {
  margin-bottom: 20rpx;
  font-size: 36rpx;
  color: #0f172a;
  font-weight: 700;

  .section-header & {
    margin-bottom: 0;
  }
}

.section-more {
  font-size: 24rpx;
  color: #64748b;
  font-weight: 500;
}

.filter-btn {
  padding: 8rpx;
}

// 通知公告区域
.notice-section {
  padding-right: 32rpx;
  padding-left: 32rpx;
  margin-right: -32rpx;
  margin-bottom: 0;
  margin-left: -32rpx;

  .section-header {
    padding-right: 0rpx;
  }
}

.notice-scroll {
  display: flex;
  margin-right: -32rpx;
  margin-bottom: 32rpx;
  height: 190rpx;
  white-space: nowrap;
  background: transparent;

  :deep(.uni-scroll-view-content) {
    display: flex;
  }
}

.notice-card {
  position: relative;
  display: flex;
  overflow: hidden;
  padding: 24rpx;
  margin-right: 24rpx;
  width: 480rpx;
  min-width: 480rpx;
  height: 140rpx;
  max-height: 140rpx;
  white-space: normal;

  &:last-child {
    margin-right: 0;
  }

  .notice-bg-icon {
    position: absolute;
    right: -20rpx;
    bottom: -20rpx;
    transform: rotate(12deg);
    opacity: 0.5;
  }

  .notice-content {
    position: relative;
    z-index: 1;
    margin: auto 0;
  }

  .notice-meta {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-bottom: 12rpx;
  }

  .notice-tag {
    display: inline-block;
    padding: 4rpx 12rpx;
    font-size: 20rpx;
    border-radius: 16rpx;
    font-weight: 700;

    &.tag-urgent {
      color: $accent;
      background: rgb(255 140 66 / 10%);
      border: 2rpx solid rgb(255 140 66 / 20%);
    }

    &.tag-activity {
      color: #3b82f6;
      background: rgb(59 130 246 / 10%);
      border: 2rpx solid rgb(59 130 246 / 20%);
    }

    &.tag-notice {
      color: #22c55e;
      background: rgb(34 197 94 / 10%);
      border: 2rpx solid rgb(34 197 94 / 20%);
    }
  }

  .notice-date {
    font-size: 22rpx;
    color: #94a3b8;
  }

  .notice-title {
    overflow: hidden;
    margin-bottom: 8rpx;
    font-size: 28rpx;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #0f172a;
    font-weight: 700;
    line-height: 1.3;
  }

  .notice-desc {
    overflow: hidden;
    font-size: 24rpx;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #64748b;
    line-height: 1.5;
  }
}

// 快捷服务
.service-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24rpx;
}

.service-item {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  width: 100%;
  height: 160rpx;
  transition: all 0.3s;
  flex-direction: column;

  &:active {
    transform: scale(0.95);
  }

  .service-gradient {
    position: absolute;
    inset: 0;
    pointer-events: none;
  }

  .service-bg-icon {
    position: absolute;
    right: -50rpx;
    bottom: -50rpx;
    z-index: 0;
    opacity: 0.08;
    transition: all 0.5s;
    transform: rotate(12deg);
    pointer-events: none;

    :deep(.u-icon) {
      color: inherit !important;
    }

    .service-item:active & {
      transform: rotate(0deg) scale(1.25);
    }
  }

  .service-content {
    position: relative;
    z-index: 10;
    display: flex;
    flex-direction: column;
    align-items: center;
    transition: transform 0.3s;

    .service-item:active & {
      transform: translateY(-4rpx);
    }
  }

  .service-name {
    font-size: 24rpx;
    font-weight: 700;
    color: #334155;
  }
}

// 申请列表
.empty-apply {
  padding: 60rpx 0;
}

.apply-list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.apply-item {
  display: flex;
  align-items: center;
  padding: 24rpx;

  .apply-icon {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 24rpx;
    width: 72rpx;
    height: 72rpx;
    border-radius: 25rpx;
    flex-shrink: 0;
  }

  .apply-info {
    flex: 1;
    min-width: 0;

    .apply-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 6rpx;
    }

    .apply-title {
      font-size: 26rpx;
      font-weight: 700;
      color: #0f172a;
    }

    .apply-status {
      padding: 4rpx 12rpx;
      font-size: 20rpx;
      border-radius: 8rpx;
      font-weight: 500;

      &.status-processing {
        color: $accent;
        background: rgb(255 140 66 / 10%);
      }

      &.status-pending {
        color: #3b82f6;
        background: rgb(59 130 246 / 10%);
      }

      &.status-approved {
        color: #22c55e;
        background: rgb(34 197 94 / 10%);
      }

      &.status-rejected {
        color: #ef4444;
        background: rgb(239 68 68 / 10%);
      }
    }

    .apply-date {
      font-size: 22rpx;
      color: #94a3b8;
    }
  }
}

// 底部安全区域
.safe-bottom {
  height: calc(env(safe-area-inset-bottom) + 80rpx);
}
</style>
