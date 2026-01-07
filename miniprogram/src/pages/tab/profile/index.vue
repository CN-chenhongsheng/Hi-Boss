<template>
  <view class="profile-page">
    <!-- 用户信息头部 -->
    <view class="profile-header">
      <view class="user-info">
        <image class="avatar" :src="userInfo?.avatar || defaultAvatar" mode="aspectFill" />
        <view class="info">
          <view class="name">
            {{ userInfo?.nickname || '未登录' }}
          </view>
          <view class="role">
            {{ userInfo?.roleName || '-' }}
          </view>
        </view>
      </view>
    </view>

    <!-- 功能列表 -->
    <view class="menu-list">
      <view v-for="group in menuGroups" :key="group.title" class="menu-group">
        <view v-if="group.title" class="group-title">
          {{ group.title }}
        </view>
        <view class="menu-items">
          <view
            v-for="item in group.items"
            :key="item.id"
            class="menu-item"
            @click="handleMenuClick(item)"
          >
            <view class="item-left">
              <view class="icon" :style="{ background: item.color }">
                <u-icon :name="item.icon" size="20" color="#fff" />
              </view>
              <text class="label">
                {{ item.label }}
              </text>
            </view>
            <u-icon name="arrow-right" size="16" color="#999" />
          </view>
        </view>
      </view>
    </view>

    <!-- 退出登录 -->
    <view class="logout-btn">
      <u-button type="error" @click="handleLogout">
        退出登录
      </u-button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();
const defaultAvatar = 'https://via.placeholder.com/150';

const userInfo = computed(() => userStore.userInfo);

const menuGroups = computed(() => {
  const groups = [
    {
      title: '',
      items: [
        { id: 1, label: '个人信息', icon: 'account', color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', path: '' },
        { id: 2, label: '我的宿舍', icon: 'home', color: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', path: '/pages/common/dorm-info/index' },
      ],
    },
    {
      title: '其他',
      items: [
        { id: 3, label: '关于我们', icon: 'info-circle', color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', path: '' },
        { id: 4, label: '设置', icon: 'setting', color: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)', path: '' },
      ],
    },
  ];

  return groups;
});

function handleMenuClick(item: any) {
  if (item.path) {
    uni.navigateTo({ url: item.path });
  }
  else {
    uni.showToast({ title: '功能开发中', icon: 'none' });
  }
}

function handleLogout() {
  uni.showModal({
    title: '确认退出',
    content: '确定要退出登录吗？',
    success: async (res) => {
      if (res.confirm) {
        await userStore.logout();
        uni.reLaunch({ url: '/pages/common/login/index' });
      }
    },
  });
}
</script>

<style lang="scss" scoped>
.profile-page {
  padding-bottom: 20rpx;
  min-height: 100vh;
  background: linear-gradient(180deg, #2196F3 0%, #00BCD4 100%);
}

.profile-header {
  padding: 60rpx 30rpx 40rpx;

  .user-info {
    display: flex;
    align-items: center;

    .avatar {
      margin-right: 24rpx;
      width: 120rpx;
      height: 120rpx;
      border: 4rpx solid rgb(255 255 255 / 30%);
      border-radius: 50%;
    }

    .info {
      flex: 1;

      .name {
        margin-bottom: 12rpx;
        font-size: 40rpx;
        color: #fff;
        font-weight: 600;
      }

      .role {
        font-size: 26rpx;
        color: rgb(255 255 255 / 80%);
      }
    }
  }
}

.menu-list {
  padding: 0 20rpx;

  .menu-group {
    margin-bottom: 20rpx;

    .group-title {
      padding: 20rpx 16rpx 12rpx;
      font-size: 26rpx;
      color: rgb(255 255 255 / 80%);
    }

    .menu-items {
      overflow: hidden;
      background: #fff;
      border-radius: 16rpx;

      .menu-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 28rpx 24rpx;
        border-bottom: 1rpx solid #f0f0f0;

        &:last-child {
          border-bottom: none;
        }

        .item-left {
          display: flex;
          align-items: center;

          .icon {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-right: 20rpx;
            width: 64rpx;
            height: 64rpx;
            border-radius: 12rpx;
          }

          .label {
            font-size: 28rpx;
            color: #333;
          }
        }
      }
    }
  }
}

.logout-btn {
  padding: 40rpx 20rpx;

  :deep(.u-button) {
    width: 100%;
  }
}
</style>
