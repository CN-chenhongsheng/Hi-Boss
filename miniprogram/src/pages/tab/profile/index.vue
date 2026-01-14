<template>
  <view class="profile-page">
    <!-- 背景装饰 -->
    <view class="bg-decorations">
      <view class="blob blob-1" />
      <view class="blob blob-2" />
    </view>

    <view class="page-container">
      <!-- 顶部导航栏 -->
      <header class="top-header">
        <view class="header-title">
          我的
        </view>
      </header>

      <!-- 主内容 -->
      <main class="main-content">
        <!-- 个人资料卡片 -->
        <view class="glass-card profile-card">
          <!-- 装饰光效 -->
          <view class="shine-effect" />

          <view class="profile-content">
            <!-- 头像 -->
            <view class="avatar-wrapper">
              <image
                class="avatar"
                :src="userInfo?.avatar || defaultAvatar"
                mode="aspectFill"
              />
              <!-- 在线状态指示器 -->
              <view class="status-indicator" />
            </view>

            <!-- 用户信息 -->
            <view class="user-info">
              <view class="name-row">
                <view class="name">
                  {{ userInfo?.studentInfo?.studentName || userInfo?.nickname || '未登录' }}
                </view>
                <view class="role-badge">
                  {{ userInfo?.roleName || '学生' }}
                </view>
              </view>
              <view class="info-list">
                <view class="info-item">
                  学号: {{ userInfo?.studentInfo?.studentNo || '2023001' }}
                </view>
                <view class="info-item">
                  宿舍: {{ userInfo?.studentInfo?.roomCode || 'A栋 302室' }}
                </view>
              </view>
            </view>

            <!-- 编辑按钮 -->
            <view class="edit-btn" @click="handleEdit">
              <u-icon name="edit-pen" size="22" color="#608a85" />
            </view>
          </view>
        </view>

        <!-- 快速操作网格 -->
        <view class="glass-card quick-actions">
          <view class="action-grid">
            <!-- 我的申请 -->
            <view class="action-item" @click="handleQuickAction('apply')">
              <view class="action-icon-wrapper">
                <u-icon name="list" size="28" color="#0adbc3" />
              </view>
              <view class="action-label">
                我的申请
              </view>
            </view>

            <!-- 报修记录 -->
            <view class="action-item" @click="handleQuickAction('repair')">
              <view class="action-icon-wrapper">
                <u-icon name="setting" size="28" color="#0adbc3" />
              </view>
              <view class="action-label">
                报修记录
              </view>
            </view>

            <!-- 宿舍成员 -->
            <view class="action-item" @click="handleQuickAction('roommates')">
              <view class="action-icon-wrapper">
                <u-icon name="account" size="28" color="#0adbc3" />
              </view>
              <view class="action-label">
                宿舍成员
              </view>
            </view>

            <!-- 通知公告 -->
            <view class="action-item" @click="handleQuickAction('notice')">
              <view class="action-icon-wrapper relative">
                <u-icon name="bell" size="28" color="#0adbc3" />
                <!-- 红点提示 -->
                <view class="badge-dot" />
              </view>
              <view class="action-label">
                通知公告
              </view>
            </view>
          </view>
        </view>

        <!-- 功能菜单列表 -->
        <view class="glass-card menu-list">
          <!-- 生活习惯 -->
          <view class="menu-item" @click="handleMenuClick('lifestyle')">
            <u-icon name="grid" size="20" color="#111817" />
            <view class="menu-label">
              生活习惯
            </view>
            <u-icon name="arrow-right" size="20" color="#9ca3af" />
          </view>

          <!-- 通用设置 -->
          <view class="menu-item" @click="handleMenuClick('settings')">
            <u-icon name="setting" size="20" color="#111817" />
            <view class="menu-label">
              通用设置
            </view>
            <u-icon name="arrow-right" size="20" color="#9ca3af" />
          </view>

          <!-- 帮助与反馈 -->
          <view class="menu-item" @click="handleMenuClick('help')">
            <u-icon name="info-circle" size="20" color="#111817" />
            <view class="menu-label">
              帮助与反馈
            </view>
            <u-icon name="arrow-right" size="20" color="#9ca3af" />
          </view>

          <!-- 关于我们 -->
          <view class="menu-item" @click="handleMenuClick('about')">
            <u-icon name="info" size="20" color="#111817" />
            <view class="menu-label">
              关于我们
            </view>
            <view class="version-text">
              v1.2.0
            </view>
            <u-icon name="arrow-right" size="20" color="#9ca3af" />
          </view>
        </view>

        <!-- 退出登录按钮 -->
        <view class="logout-btn" @click="handleLogout">
          退出登录
        </view>
      </main>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();
const defaultAvatar = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB1JhVdkgPRVmEBExS0YehcQ10P72onHobtiZJ0rdv4crelIznydQa9E0SH0nqNH0mDheCZuKECSYNzW6swWmOyiY2JuW3KRd8mI67CiEYqLla4FXLPapNSkbn-r9kLNFa9RU82GWhiG7IKB7VQiqw_cgfAKdQ4uw9fMKA_1GBRiITCRXLqnw2FgJ4GxGa_4T_EQQvbIer3JkyPy8qkEDBrUFOMntcaEexRiAYr7jTrxmY8H7qMkTE-kpUExISpzTxkifDrhBj4Ow7S';

const userInfo = computed(() => userStore.userInfo);

// 编辑个人信息
function handleEdit() {
  uni.showToast({
    title: '编辑功能开发中',
    icon: 'none',
  });
}

// 快速操作
function handleQuickAction(type: string) {
  const routes: Record<string, string> = {
    apply: '/pages/apply/form/index',
    repair: '/pages/service/repair-list/index',
    roommates: '/pages/common/dorm-info/index',
    notice: '/pages/tab/message/index',
  };

  if (routes[type]) {
    if (type === 'apply' || type === 'notice') {
      uni.switchTab({ url: routes[type] });
    }
    else {
      uni.navigateTo({ url: routes[type] });
    }
  }
  else {
    uni.showToast({
      title: '功能开发中',
      icon: 'none',
    });
  }
}

// 菜单点击
function handleMenuClick(type: string) {
  const actions: Record<string, () => void> = {
    lifestyle: () => {
      uni.navigateTo({ url: '/pages/profile/lifestyle/index' });
    },
    settings: () => {
      uni.showToast({
        title: '设置功能开发中',
        icon: 'none',
      });
    },
    help: () => {
      uni.showToast({
        title: '帮助与反馈功能开发中',
        icon: 'none',
      });
    },
    about: () => {
      uni.showToast({
        title: '关于我们功能开发中',
        icon: 'none',
      });
    },
  };

  if (actions[type]) {
    actions[type]();
  }
}

// 退出登录
async function handleLogout() {
  uni.showModal({
    title: '确认退出',
    content: '确定要退出登录吗？',
    success: async (res) => {
      if (res.confirm) {
        try {
          // @ts-expect-error - logout方法在store中已定义
          await userStore.logout();
          uni.reLaunch({ url: '/pages/common/login/index' });
        }
        catch (error) {
          console.error('退出登录失败:', error);
          uni.reLaunch({ url: '/pages/common/login/index' });
        }
      }
    },
  });
}
</script>

<style lang="scss" scoped>
// 主题变量
$primary: #0adbc3;
$primary-dark: #08b3a0;
$bg-light: #f5f8f8;
$bg-dark: #102220;
$text-main: #111817;
$text-sub: #608a85;
$glass-bg: rgb(255 255 255 / 75%);
$glass-border: rgb(255 255 255 / 80%);

.profile-page {
  position: relative;
  overflow-x: hidden;
  min-height: 100vh;
  background-color: $bg-light;
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
    opacity: 0.7;
    filter: blur(100rpx);

    &.blob-1 {
      top: -10%;
      right: -15%;
      width: 800rpx;
      height: 800rpx;
      background: rgb(10 219 195 / 15%);
      opacity: 0.7;
    }

    &.blob-2 {
      top: 20%;
      left: -10%;
      width: 600rpx;
      height: 600rpx;
      background: rgb(96 165 250 / 10%);
      opacity: 0.6;
    }
  }
}

.page-container {
  position: relative;
  z-index: 10;
  display: flex;
  padding-bottom: 192rpx; // 为底部TabBar留空间
  margin: 0 auto;
  max-width: 750rpx;
  min-height: 100vh;
  background: transparent;
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
  padding: calc(var(--status-bar-height) + 50rpx) 32rpx 25rpx;

  .header-title {
    display: flex;
    justify-content: center;
    align-items: center;
    width: auto;
    font-size: 36rpx;
    color: $text-main;
    border-radius: 50%;
    font-weight: 700;
    letter-spacing: 0.5rpx;
  }
}

// 主内容
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 32rpx;
  padding: 16rpx 32rpx;
}

// 毛玻璃卡片
.glass-card {
  overflow: hidden;
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: 32rpx;
  box-shadow: 0 8rpx 24rpx rgb(0 0 0 / 5%);
  backdrop-filter: blur(32rpx);
}

// 个人资料卡片
.profile-card {
  position: relative;
  padding: 30rpx;

  .shine-effect {
    position: absolute;
    top: 0;
    right: 0;
    width: 256rpx;
    height: 256rpx;
    background: linear-gradient(to bottom right, rgb(255 255 255 / 40%), transparent);
    border-radius: 0 0 0 100%;
    pointer-events: none;
  }

  .profile-content {
    position: relative;
    z-index: 10;
    display: flex;
    align-items: center;
    gap: 32rpx;
  }
}

// 头像包装器
.avatar-wrapper {
  position: relative;
  flex-shrink: 0;

  .avatar {
    width: 144rpx;
    height: 144rpx;
    border: 6rpx solid #fff;
    border-radius: 50%;
    box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 10%);
    object-fit: cover;
  }

  .status-indicator {
    position: absolute;
    right: 4rpx;
    bottom: 4rpx;
    width: 28rpx;
    height: 28rpx;
    background: #10b981;
    border: 4rpx solid #fff;
    border-radius: 50%;
  }
}

// 用户信息
.user-info {
  display: flex;
  justify-content: center;
  min-width: 0;
  flex: 1;
  flex-direction: column;

  .name-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-bottom: 8rpx;

    .name {
      overflow: hidden;
      font-size: 40rpx;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: $text-main;
      font-weight: 700;
      line-height: 1.2;
    }

    .role-badge {
      padding: 4rpx 16rpx;
      font-size: 20rpx;
      color: #fff;
      background: rgb(10 219 195 / 90%);
      border-radius: 8rpx;
      box-shadow: 0 2rpx 4rpx rgb(0 0 0 / 10%);
      flex-shrink: 0;
      font-weight: 700;
      letter-spacing: 1rpx;
    }
  }

  .info-list {
    display: flex;
    flex-direction: column;
    gap: 4rpx;

    .info-item {
      overflow: hidden;
      font-size: 28rpx;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: $text-sub;
    }
  }
}

// 编辑按钮
.edit-btn {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  transition: background-color 0.2s;
  flex-shrink: 0;

  &:active {
    background: rgb(0 0 0 / 5%);
  }
}

// 快速操作网格
.quick-actions {
  padding: 32rpx;

  .action-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16rpx;
  }

  .action-item {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 8rpx 0;
    transition: transform 0.2s;
    flex-direction: column;
    gap: 16rpx;

    &:active {
      transform: scale(0.95);
    }

    .action-icon-wrapper {
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 56rpx;
      height: 56rpx;
      transition: transform 0.2s;

      &.relative {
        position: relative;
      }

      .badge-dot {
        position: absolute;
        top: 0;
        right: 0;
        width: 16rpx;
        height: 16rpx;
        background: #ef4444;
        border: 4rpx solid #fff;
        border-radius: 50%;
        transform: translate(25%, -25%);
      }
    }

    .action-label {
      font-size: 22rpx;
      text-align: center;
      color: $text-main;
      font-weight: 500;
    }
  }
}

// 功能菜单列表
.menu-list {
  display: flex;
  flex-direction: column;
  overflow: hidden;

  .menu-item {
    display: flex;
    align-items: center;
    gap: 24rpx;
    padding: 32rpx;
    min-height: 62rpx;
    text-align: left;
    transition: background-color 0.2s;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%);

    &:last-child {
      border-bottom: none;
    }

    &:active {
      background: rgb(10 219 195 / 10%);
    }

    .menu-label {
      flex: 1;
      font-size: 30rpx;
      font-weight: 500;
      color: $text-main;
    }

    .version-text {
      margin-right: 8rpx;
      font-size: 20rpx;
      color: #9ca3af;
    }
  }
}

// 退出登录按钮
.logout-btn {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 32rpx;
  margin-top: 16rpx;
  margin-bottom: 32rpx;
  font-size: 30rpx;
  color: #ef4444;
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: 32rpx;
  box-shadow: 0 8rpx 24rpx rgb(0 0 0 / 5%);
  transition: all 0.2s;
  backdrop-filter: blur(32rpx);
  font-weight: 500;

  &:active {
    transform: scale(0.99);
    background: rgb(239 68 68 / 5%);
  }
}
</style>
