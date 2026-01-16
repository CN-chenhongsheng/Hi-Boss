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
        <view class="profile-card">
          <!-- 装饰元素 -->
          <view class="profile-decor">
            <view class="decor-circle decor-1" />
            <view class="decor-circle decor-2" />
          </view>

          <view class="profile-content">
            <!-- 头像区域 -->
            <view class="avatar-section">
              <view class="avatar-ring">
                <image
                  class="avatar"
                  :src="userInfo?.avatar || defaultAvatar"
                  mode="aspectFill"
                />
              </view>
              <!-- 在线状态 -->
              <view class="online-badge">
                <view class="online-dot" />
                <text class="online-text">
                  在线
                </text>
              </view>
            </view>

            <!-- 用户信息 -->
            <view class="user-details">
              <view class="name-row">
                <view class="user-name">
                  {{ userInfo?.studentInfo?.studentName || userInfo?.nickname || '未登录' }}
                </view>
                <view class="edit-btn" @click="handleEdit">
                  <u-icon name="edit-pen" size="14" color="#10b981" />
                  <text>编辑</text>
                </view>
              </view>
              <view class="role-tag">
                <u-icon name="star" size="14" color="#f59e0b" />
                <text>{{ userInfo?.roleName || '学生' }}</text>
              </view>
            </view>
          </view>

          <!-- 信息标签 -->
          <view class="info-tags">
            <view class="info-tag">
              <u-icon name="order" size="16" color="#10b981" />
              <text>{{ userInfo?.studentInfo?.studentNo || '2023001' }}</text>
            </view>
            <view class="info-tag">
              <u-icon name="home" size="16" color="#6366f1" />
              <text>{{ userInfo?.studentInfo?.roomCode || 'A栋 302室' }}</text>
            </view>
          </view>
        </view>

        <!-- 快速操作网格 -->
        <view class="quick-actions">
          <view class="section-title">
            <view class="title-icon" />
            <text>快捷服务</text>
          </view>
          <view class="action-grid">
            <!-- 我的申请 -->
            <view class="action-card" @click="handleQuickAction('apply')">
              <view class="apply-icon action-icon">
                <u-icon name="list" size="26" color="#fff" />
              </view>
              <view class="action-info">
                <view class="action-name">
                  我的申请
                </view>
                <view class="action-desc">
                  查看申请记录
                </view>
              </view>
            </view>

            <!-- 报修记录 -->
            <view class="action-card" @click="handleQuickAction('repair')">
              <view class="action-icon repair-icon">
                <u-icon name="setting" size="26" color="#fff" />
              </view>
              <view class="action-info">
                <view class="action-name">
                  报修记录
                </view>
                <view class="action-desc">
                  维修进度查询
                </view>
              </view>
            </view>

            <!-- 宿舍成员 -->
            <view class="action-card" @click="handleQuickAction('roommates')">
              <view class="action-icon roommates-icon">
                <u-icon name="account" size="26" color="#fff" />
              </view>
              <view class="action-info">
                <view class="action-name">
                  宿舍成员
                </view>
                <view class="action-desc">
                  室友信息
                </view>
              </view>
            </view>

            <!-- 通知公告 -->
            <view class="action-card" @click="handleQuickAction('notice')">
              <view class="action-icon notice-icon">
                <u-icon name="bell" size="26" color="#fff" />
                <!-- 红点提示 -->
                <view class="notice-dot" />
              </view>
              <view class="action-info">
                <view class="action-name">
                  通知公告
                </view>
                <view class="action-desc">
                  最新消息
                </view>
              </view>
            </view>
          </view>
        </view>

        <!-- 功能菜单列表 -->
        <view class="menu-section">
          <view class="section-title">
            <view class="title-icon" />
            <text>设置</text>
          </view>
          <view class="menu-list">
            <!-- 修改密码 -->
            <view class="menu-item" @click="handleMenuClick('password')">
              <view class="password-bg menu-icon">
                <u-icon name="lock" size="18" color="#fff" />
              </view>
              <view class="menu-label">
                修改密码
              </view>
              <u-icon name="arrow-right" size="18" color="#c4c4c4" />
            </view>

            <!-- 通用设置 -->
            <view class="menu-item" @click="handleMenuClick('settings')">
              <view class="menu-icon settings-bg">
                <u-icon name="setting" size="18" color="#fff" />
              </view>
              <view class="menu-label">
                通用设置
              </view>
              <u-icon name="arrow-right" size="18" color="#c4c4c4" />
            </view>

            <!-- 帮助与反馈 -->
            <view class="menu-item" @click="handleMenuClick('help')">
              <view class="menu-icon help-bg">
                <u-icon name="info-circle" size="18" color="#fff" />
              </view>
              <view class="menu-label">
                帮助与反馈
              </view>
              <u-icon name="arrow-right" size="18" color="#c4c4c4" />
            </view>

            <!-- 关于我们 -->
            <view class="menu-item" @click="handleMenuClick('about')">
              <view class="menu-icon about-bg">
                <u-icon name="info" size="18" color="#fff" />
              </view>
              <view class="menu-label">
                关于我们
              </view>
              <view class="version-badge">
                v1.2.0
              </view>
              <u-icon name="arrow-right" size="18" color="#c4c4c4" />
            </view>
          </view>
        </view>

        <!-- 退出登录按钮 -->
        <view class="logout-section">
          <view class="logout-btn" @click="handleLogout">
            <u-icon name="arrow-leftward" size="18" color="#ef4444" />
            <text>退出登录</text>
          </view>
        </view>
      </main>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { onShow } from '@dcloudio/uni-app';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();
const defaultAvatar = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB1JhVdkgPRVmEBExS0YehcQ10P72onHobtiZJ0rdv4crelIznydQa9E0SH0nqNH0mDheCZuKECSYNzW6swWmOyiY2JuW3KRd8mI67CiEYqLla4FXLPapNSkbn-r9kLNFa9RU82GWhiG7IKB7VQiqw_cgfAKdQ4uw9fMKA_1GBRiITCRXLqnw2FgJ4GxGa_4T_EQQvbIer3JkyPy8qkEDBrUFOMntcaEexRiAYr7jTrxmY8H7qMkTE-kpUExISpzTxkifDrhBj4Ow7S';

const userInfo = computed(() => userStore.userInfo);

// 页面显示时检查登录状态
onShow(() => {
  if (!userStore.token) {
    uni.reLaunch({ url: '/pages/common/login/index' });
  }
});

// 编辑个人信息
function handleEdit() {
  uni.navigateTo({ url: '/pages/profile/edit/index' });
}

// 快速操作
function handleQuickAction(type: string) {
  const routes: Record<string, string> = {
    apply: '/pages/apply/form/index',
    repair: '/pages/service/repair-list/index',
    roommates: '/pages/common/dorm-info/index',
    notice: '/pages/service/message/index',
  };

  if (routes[type]) {
    if (type === 'apply') {
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
    password: () => {
      uni.navigateTo({ url: '/pages/profile/change-password/index' });
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
// 主题变量 - 浅色温暖系
$primary: #10b981;
$primary-light: #d1fae5;
$accent-purple: #8b5cf6;
$accent-blue: #3b82f6;
$accent-orange: #f59e0b;
$accent-pink: #ec4899;
$bg-page: #f8fafc;
$bg-card: #fff;
$text-main: #1e293b;
$text-sub: #64748b;
$text-light: #94a3b8;
$shadow-sm: 0 2rpx 8rpx rgb(0 0 0 / 4%);
$shadow-md: 0 4rpx 16rpx rgb(0 0 0 / 6%);
$shadow-lg: 0 8rpx 32rpx rgb(0 0 0 / 8%);

.profile-page {
  position: relative;
  overflow-x: hidden;
  min-height: 100vh;
  background: linear-gradient(180deg, #e0f2fe 0%, #f0fdf4 50%, $bg-page 100%);
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
      top: -5%;
      right: -10%;
      width: 500rpx;
      height: 500rpx;
      background: rgb(167 243 208 / 50%);
    }

    &.blob-2 {
      top: 30%;
      left: -15%;
      width: 400rpx;
      height: 400rpx;
      background: rgb(191 219 254 / 40%);
    }
  }
}

.page-container {
  position: relative;
  z-index: 10;
  display: flex;
  padding-bottom: 192rpx;
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
  gap: 28rpx;
  padding: 16rpx 28rpx;
}

// 个人资料卡片
.profile-card {
  position: relative;
  overflow: hidden;
  padding: 40rpx 32rpx;
  background: $bg-card;
  border-radius: 32rpx;
  box-shadow: $shadow-lg;

  .profile-decor {
    position: absolute;
    inset: 0;
    pointer-events: none;
    overflow: hidden;

    .decor-circle {
      position: absolute;
      border-radius: 50%;

      &.decor-1 {
        right: -10rpx;
        bottom: -80rpx;
        width: 200rpx;
        height: 200rpx;
        background: linear-gradient(135deg, #a7f3d0 0%, #6ee7b7 100%);
        opacity: 0.6;
      }

      &.decor-2 {
        bottom: -50rpx;
        left: -50rpx;
        width: 120rpx;
        height: 120rpx;
        background: linear-gradient(135deg, #c7d2fe 0%, #a5b4fc 100%);
        opacity: 0.4;
      }
    }
  }

  .profile-content {
    position: relative;
    z-index: 10;
    display: flex;
    align-items: center;
    gap: 28rpx;
  }
}

// 头像区域
.avatar-section {
  position: relative;
  flex-shrink: 0;

  .avatar-ring {
    padding: 6rpx;
    background: linear-gradient(135deg, #10b981 0%, #3b82f6 50%, #8b5cf6 100%);
    border-radius: 50%;

    .avatar {
      width: 140rpx;
      height: 140rpx;
      border: 6rpx solid #fff;
      border-radius: 50%;
      object-fit: cover;
    }
  }

  .online-badge {
    position: absolute;
    right: -10rpx;
    bottom: 10rpx;
    display: flex;
    align-items: center;
    gap: 6rpx;
    padding: 4rpx 12rpx;
    background: #fff;
    border-radius: 20rpx;
    box-shadow: $shadow-md;

    .online-dot {
      width: 12rpx;
      height: 12rpx;
      background: #10b981;
      border-radius: 50%;
      animation: pulse 2s infinite;
    }

    .online-text {
      font-size: 18rpx;
      color: #10b981;
      font-weight: 600;
    }
  }
}

@keyframes pulse {
  0%,
  100% {
    opacity: 1;
    transform: scale(1);
  }

  50% {
    opacity: 0.6;
    transform: scale(1.1);
  }
}

// 用户详情
.user-details {
  flex: 1;
  min-width: 0;

  .name-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12rpx;
    gap: 12rpx;

    .user-name {
      overflow: hidden;
      min-width: 0;
      font-size: 40rpx;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: $text-main;
      font-weight: 700;
      flex: 1;
    }

    .edit-btn {
      display: flex;
      align-items: center;
      gap: 6rpx;
      padding: 6rpx 16rpx;
      background: rgb(16 185 129 / 10%);
      border-radius: 20rpx;
      transition: all 0.2s;
      flex-shrink: 0;

      text {
        font-size: 22rpx;
        color: #10b981;
        font-weight: 600;
      }

      &:active {
        background: rgb(16 185 129 / 20%);
        transform: scale(0.95);
      }
    }
  }

  .role-tag {
    display: inline-flex;
    align-items: center;
    gap: 8rpx;
    padding: 6rpx 16rpx;
    background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
    border-radius: 20rpx;

    text {
      font-size: 22rpx;
      color: #92400e;
      font-weight: 600;
    }
  }
}

// 信息标签
.info-tags {
  position: relative;
  z-index: 10;
  display: flex;
  gap: 16rpx;
  margin-top: 24rpx;

  .info-tag {
    display: flex;
    align-items: center;
    gap: 8rpx;
    padding: 12rpx 20rpx;
    background: #f8fafc;
    border-radius: 16rpx;

    text {
      font-size: 24rpx;
      color: $text-sub;
      font-weight: 500;
    }
  }
}

// 区块标题
.section-title {
  display: flex;
  align-items: center;
  padding-left: 4rpx;
  margin-bottom: 20rpx;
  gap: 12rpx;

  .title-icon {
    width: 8rpx;
    height: 32rpx;
    background: linear-gradient(180deg, #10b981 0%, #3b82f6 100%);
    border-radius: 4rpx;
  }

  text {
    font-size: 30rpx;
    color: $text-main;
    font-weight: 600;
  }
}

// 快速操作
.quick-actions {
  .action-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20rpx;
  }

  .action-card {
    display: flex;
    align-items: center;
    gap: 20rpx;
    padding: 28rpx 24rpx;
    background: $bg-card;
    border-radius: 24rpx;
    box-shadow: $shadow-md;
    transition: all 0.2s;

    &:active {
      transform: scale(0.98);
      box-shadow: $shadow-sm;
    }

    .action-icon {
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 80rpx;
      height: 80rpx;
      border-radius: 20rpx;
      flex-shrink: 0;

      &.apply-icon {
        background: linear-gradient(135deg, #6ee7b7 0%, #10b981 100%);
      }

      &.repair-icon {
        background: linear-gradient(135deg, #93c5fd 0%, #3b82f6 100%);
      }

      &.roommates-icon {
        background: linear-gradient(135deg, #c4b5fd 0%, #8b5cf6 100%);
      }

      &.notice-icon {
        background: linear-gradient(135deg, #fcd34d 0%, #f59e0b 100%);
      }

      .notice-dot {
        position: absolute;
        top: -4rpx;
        right: -4rpx;
        width: 20rpx;
        height: 20rpx;
        background: #ef4444;
        border: 4rpx solid #fff;
        border-radius: 50%;
        animation: pulse 2s infinite;
      }
    }

    .action-info {
      flex: 1;
      min-width: 0;

      .action-name {
        margin-bottom: 4rpx;
        font-size: 28rpx;
        color: $text-main;
        font-weight: 600;
      }

      .action-desc {
        font-size: 22rpx;
        color: $text-light;
      }
    }
  }
}

// 菜单区块
.menu-section {
  .menu-list {
    overflow: hidden;
    background: $bg-card;
    border-radius: 24rpx;
    box-shadow: $shadow-md;
  }

  .menu-item {
    display: flex;
    align-items: center;
    gap: 20rpx;
    padding: 28rpx 24rpx;
    transition: background-color 0.2s;
    border-bottom: 1rpx solid #f1f5f9;

    &:last-child {
      border-bottom: none;
    }

    &:active {
      background: #f8fafc;
    }

    .menu-icon {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 56rpx;
      height: 56rpx;
      border-radius: 14rpx;
      flex-shrink: 0;

      &.password-bg {
        background: linear-gradient(135deg, #fca5a5 0%, #ef4444 100%);
      }

      &.settings-bg {
        background: linear-gradient(135deg, #a5b4fc 0%, #6366f1 100%);
      }

      &.help-bg {
        background: linear-gradient(135deg, #86efac 0%, #22c55e 100%);
      }

      &.about-bg {
        background: linear-gradient(135deg, #fdba74 0%, #f97316 100%);
      }
    }

    .menu-label {
      flex: 1;
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
    }

    .version-badge {
      padding: 4rpx 12rpx;
      margin-right: 8rpx;
      font-size: 20rpx;
      color: $text-light;
      background: #f1f5f9;
      border-radius: 8rpx;
    }
  }
}

// 退出登录
.logout-section {
  padding: 0 4rpx;
  margin-top: 8rpx;

  .logout-btn {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 12rpx;
    padding: 28rpx;
    background: #fff;
    border: 2rpx solid #fecaca;
    border-radius: 24rpx;
    box-shadow: $shadow-sm;
    transition: all 0.2s;

    text {
      font-size: 28rpx;
      color: #ef4444;
      font-weight: 500;
    }

    &:active {
      background: #fef2f2;
      transform: scale(0.99);
    }
  }
}
</style>
