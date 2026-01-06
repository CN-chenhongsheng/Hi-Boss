<template>
  <view class="page-container">
    <!-- 用户信息卡片 -->
    <view class="user-card">
      <view class="avatar-section">
        <view class="avatar-placeholder" v-if="!userInfo.avatar">
          <text class="avatar-text">{{ userInfo.name ? userInfo.name.charAt(0) : '?' }}</text>
        </view>
        <image
          v-else
          class="avatar"
          :src="userInfo.avatar"
          mode="aspectFill"
        />
        <view class="user-info">
          <view class="user-name">{{ userInfo.name || '未登录' }}</view>
          <view class="user-id">{{ userInfo.studentId || '请先登录' }}</view>
        </view>
      </view>
      <view class="edit-btn" @click="handleEdit">
        <text>编辑</text>
      </view>
    </view>

    <!-- 宿舍信息 -->
    <view class="info-card" v-if="userInfo.dormitory">
      <view class="info-title">宿舍信息</view>
      <view class="info-item">
        <text class="info-label">楼栋</text>
        <text class="info-value">{{ userInfo.dormitory.building }}</text>
      </view>
      <view class="info-item">
        <text class="info-label">房间</text>
        <text class="info-value">{{ userInfo.dormitory.room }}</text>
      </view>
      <view class="info-item">
        <text class="info-label">床位</text>
        <text class="info-value">{{ userInfo.dormitory.bed }}</text>
      </view>
    </view>

    <!-- 功能列表 -->
    <view class="menu-card">
      <view class="menu-item" @click="navigateTo('/pages/checkin/index')">
        <view class="menu-icon">📋</view>
        <view class="menu-text">我的申请</view>
        <view class="menu-arrow">›</view>
      </view>
      <view class="menu-item" @click="showTip('功能开发中')">
        <view class="menu-icon">🔔</view>
        <view class="menu-text">消息通知</view>
        <view class="menu-arrow">›</view>
      </view>
      <view class="menu-item" @click="showTip('功能开发中')">
        <view class="menu-icon">⚙️</view>
        <view class="menu-text">设置</view>
        <view class="menu-arrow">›</view>
      </view>
      <view class="menu-item" @click="showTip('功能开发中')">
        <view class="menu-icon">❓</view>
        <view class="menu-text">帮助与反馈</view>
        <view class="menu-arrow">›</view>
      </view>
      <view class="menu-item" @click="showTip('功能开发中')">
        <view class="menu-icon">ℹ️</view>
        <view class="menu-text">关于</view>
        <view class="menu-arrow">›</view>
      </view>
    </view>

    <!-- 退出登录按钮 -->
    <view class="logout-btn" @click="handleLogout">
      <text>退出登录</text>
    </view>
  </view>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { onLoad } from '@dcloudio/uni-app'
  import { useUserStore } from '@/store/modules/user'

  const userStore = useUserStore()

  // 用户信息（示例数据）
  const userInfo = ref({
    name: '张三',
    studentId: '2021001234',
    avatar: '',
    dormitory: {
      building: '1号楼',
      room: '101',
      bed: 'A床'
    }
  })

  onLoad(() => {
    console.log('我的页面加载')
    // 获取用户信息
    if (userStore.userInfo) {
      // userInfo.value = userStore.userInfo
    }
  })

  /**
   * 页面跳转
   */
  const navigateTo = (url: string) => {
    uni.navigateTo({ url })
  }

  /**
   * 显示提示
   */
  const showTip = (message: string) => {
    uni.showToast({
      title: message,
      icon: 'none'
    })
  }

  /**
   * 编辑个人信息
   */
  const handleEdit = () => {
    showTip('功能开发中')
  }

  /**
   * 退出登录
   */
  const handleLogout = () => {
    uni.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (res.confirm) {
          userStore.clearUserInfo()
          uni.showToast({
            title: '已退出登录',
            icon: 'success'
          })
        }
      }
    })
  }
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
    background-color: #f5f5f5;
    padding: 32rpx;
  }

  /* 用户信息卡片 */
  .user-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: linear-gradient(135deg, #5d87ff 0%, #7b9fff 100%);
    border-radius: 24rpx;
    padding: 40rpx 32rpx;
    margin-bottom: 24rpx;
  }

  .avatar-section {
    display: flex;
    align-items: center;
  }

  .avatar,
  .avatar-placeholder {
    width: 120rpx;
    height: 120rpx;
    border-radius: 50%;
    background: #fff;
    margin-right: 24rpx;
  }

  .avatar-placeholder {
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.3);
  }

  .avatar-text {
    font-size: 48rpx;
    font-weight: 600;
    color: #fff;
  }

  .user-info {
    color: #fff;
  }

  .user-name {
    font-size: 36rpx;
    font-weight: 600;
    margin-bottom: 8rpx;
  }

  .user-id {
    font-size: 26rpx;
    opacity: 0.9;
  }

  .edit-btn {
    background: rgba(255, 255, 255, 0.2);
    padding: 12rpx 24rpx;
    border-radius: 32rpx;
    color: #fff;
    font-size: 26rpx;

    &:active {
      background: rgba(255, 255, 255, 0.3);
    }
  }

  /* 宿舍信息卡片 */
  .info-card {
    background: #fff;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 24rpx;
  }

  .info-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 24rpx;
    padding-bottom: 16rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .info-item {
    display: flex;
    justify-content: space-between;
    padding: 16rpx 0;
  }

  .info-label {
    font-size: 28rpx;
    color: #666;
  }

  .info-value {
    font-size: 28rpx;
    color: #333;
  }

  /* 功能列表 */
  .menu-card {
    background: #fff;
    border-radius: 24rpx;
    overflow: hidden;
    margin-bottom: 24rpx;
  }

  .menu-item {
    display: flex;
    align-items: center;
    padding: 32rpx;
    border-bottom: 1rpx solid #f5f5f5;

    &:last-child {
      border-bottom: none;
    }

    &:active {
      background: #f9f9f9;
    }
  }

  .menu-icon {
    font-size: 40rpx;
    margin-right: 24rpx;
  }

  .menu-text {
    flex: 1;
    font-size: 30rpx;
    color: #333;
  }

  .menu-arrow {
    font-size: 36rpx;
    color: #ccc;
  }

  /* 退出登录按钮 */
  .logout-btn {
    background: #fff;
    border-radius: 24rpx;
    padding: 32rpx;
    text-align: center;
    color: #dd524d;
    font-size: 30rpx;

    &:active {
      background: #fef0f0;
    }
  }
</style>

