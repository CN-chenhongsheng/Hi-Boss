<template>
  <view class="lifestyle-page">
    <!-- 背景装饰 -->
    <view class="bg-decorations">
      <view class="blob blob-1" />
    </view>

    <view class="page-container">
      <!-- 顶部导航栏 -->
      <header class="top-header">
        <view class="header-back" @click="handleBack">
          <u-icon name="arrow-left" size="24" color="#111817" />
        </view>
        <view class="header-title">
          生活习惯
        </view>
        <view class="header-placeholder" />
      </header>

      <!-- 主内容 -->
      <main class="main-content">
        <!-- 吸烟相关 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="close-circle" size="20" color="#ef4444" />
            <text>基本信息</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              吸烟状态 <text class="required">
                *
              </text>
            </view>
            <u-radio-group
              v-model="formData.smokingStatus"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不吸烟"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="吸烟"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否接受室友吸烟
            </view>
            <u-radio-group
              v-model="formData.smokingTolerance"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不接受"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="接受"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              作息时间
            </view>
            <u-radio-group
              v-model="formData.sleepSchedule"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="早睡早起"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="正常"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="晚睡晚起"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="夜猫子"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 睡眠习惯 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="pause-circle" size="20" color="#0adbc3" />
            <text>睡眠习惯</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              睡眠质量
            </view>
            <u-radio-group
              v-model="formData.sleepQuality"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="浅睡易醒"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="正常"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="深睡"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否打呼噜
            </view>
            <u-radio-group
              v-model="formData.snores"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不打"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="打呼噜"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否对光线敏感
            </view>
            <u-radio-group
              v-model="formData.sensitiveToLight"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不敏感"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="敏感"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否对声音敏感
            </view>
            <u-radio-group
              v-model="formData.sensitiveToSound"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不敏感"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="敏感"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 卫生习惯 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="reload" size="20" color="#60a5fa" />
            <text>卫生习惯</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              整洁程度
            </view>
            <u-radio-group
              v-model="formData.cleanlinessLevel"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="非常整洁"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="整洁"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="一般"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="4"
                  label="随意"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="5"
                  label="不整洁"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              睡前是否整理
            </view>
            <u-radio-group
              v-model="formData.bedtimeCleanup"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不整理"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔整理"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="经常整理"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="总是整理"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 社交偏好 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="account" size="20" color="#8b5cf6" />
            <text>社交偏好</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              社交偏好
            </view>
            <u-radio-group
              v-model="formData.socialPreference"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="喜欢安静"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="中等"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="喜欢热闹"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否允许室友带访客
            </view>
            <u-radio-group
              v-model="formData.allowVisitors"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不允许"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔可以"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="可以"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              电话时间偏好
            </view>
            <u-radio-group
              v-model="formData.phoneCallTime"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="喜欢在宿舍打电话"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔在宿舍"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="不在宿舍打电话"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 学习习惯 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="file-text" size="20" color="#f59e0b" />
            <text>学习习惯</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否在宿舍学习
            </view>
            <u-radio-group
              v-model="formData.studyInRoom"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不在"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="经常"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="总是"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              学习环境偏好
            </view>
            <u-radio-group
              v-model="formData.studyEnvironment"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="需要安静"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="需要轻音乐"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="可以接受声音"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              电脑使用时间
            </view>
            <u-radio-group
              v-model="formData.computerUsageTime"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不用"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="很少(1-2h/天)"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="正常(3-5h/天)"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="很多(6h+/天)"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 娱乐习惯 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="play-circle" size="20" color="#ec4899" />
            <text>娱乐习惯</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              游戏偏好
            </view>
            <u-radio-group
              v-model="formData.gamingPreference"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不玩游戏"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔玩"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="经常玩"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              听音乐偏好
            </view>
            <u-radio-group
              v-model="formData.musicPreference"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不听"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔听"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="经常听"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              音乐音量偏好
            </view>
            <u-radio-group
              v-model="formData.musicVolume"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="喜欢小声"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="中等"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="3"
                  label="喜欢大声"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>

          <view class="form-item">
            <view class="form-label">
              是否在宿舍吃东西
            </view>
            <u-radio-group
              v-model="formData.eatInRoom"
              placement="row"
            >
              <view class="radio-item-wrapper">
                <u-radio
                  :name="0"
                  label="不吃"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="1"
                  label="偶尔"
                  active-color="#0adbc3"
                />
              </view>
              <view class="radio-item-wrapper">
                <u-radio
                  :name="2"
                  label="经常"
                  active-color="#0adbc3"
                />
              </view>
            </u-radio-group>
          </view>
        </view>

        <!-- 特殊需求 -->
        <view class="glass-card form-section">
          <view class="section-title">
            <u-icon name="info-circle" size="20" color="#10b981" />
            <text>特殊需求</text>
          </view>

          <view class="form-item">
            <view class="form-label">
              特殊需求
            </view>
            <u-textarea
              v-model="formData.specialNeeds"
              placeholder="如过敏、健康问题等"
              :maxlength="500"
              :count="true"
              height="200"
            />
          </view>

          <view class="form-item">
            <view class="form-label">
              室友偏好
            </view>
            <u-textarea
              v-model="formData.roommatePreference"
              placeholder="如希望室友不抽烟、安静等"
              :maxlength="200"
              :count="true"
              height="200"
            />
          </view>
        </view>

        <!-- 提交按钮 -->
        <view class="submit-btn-wrapper">
          <u-button
            type="primary"
            :custom-style="{ backgroundColor: '#0adbc3', borderRadius: '24rpx', height: '96rpx', fontSize: '32rpx', fontWeight: '600' }"
            @click="handleSubmit"
          >
            保存
          </u-button>
        </view>
      </main>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';

// Mock数据（实际项目中应通过API获取）
const mockLifestyleData = {
  smokingStatus: 0,
  smokingTolerance: 0,
  sleepSchedule: 1,
  sleepQuality: 1,
  snores: 0,
  sensitiveToLight: 0,
  sensitiveToSound: 0,
  cleanlinessLevel: 2,
  bedtimeCleanup: 1,
  socialPreference: 1,
  allowVisitors: 1,
  phoneCallTime: 1,
  studyInRoom: 1,
  studyEnvironment: 1,
  computerUsageTime: 2,
  gamingPreference: 1,
  musicPreference: 1,
  musicVolume: 1,
  eatInRoom: 1,
  specialNeeds: '',
  roommatePreference: '',
};

// 表单数据
const formData = ref({ ...mockLifestyleData });

// 返回
function handleBack() {
  uni.navigateBack();
}

// 提交表单
function handleSubmit() {
  // 验证必填项
  if (formData.value.smokingStatus === null || formData.value.smokingStatus === undefined) {
    uni.showToast({
      title: '请选择吸烟状态',
      icon: 'none',
    });
    return;
  }

  // 显示成功提示（不实际提交数据）
  uni.showToast({
    title: '保存成功',
    icon: 'success',
  });

  // 模拟延迟后返回
  setTimeout(() => {
    uni.navigateBack();
  }, 1500);
}

// 页面加载时获取数据（mock数据，不需要API）
onMounted(() => {
  // 实际项目中应从API获取数据
  // const res = await getStudentLifestyleAPI();
  // if (res.data) {
  //   formData.value = res.data;
  // }
});
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

.lifestyle-page {
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
    filter: blur(100rpx);

    &.blob-1 {
      top: -10%;
      right: -15%;
      width: 800rpx;
      height: 800rpx;
      background: rgb(10 219 195 / 15%);
      opacity: 0.7;
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
  background: transparent;
  flex-direction: column;
}

// 顶部导航栏
.top-header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  align-items: center;
  padding: calc(var(--status-bar-height) + 50rpx) 32rpx 25rpx;
  background: $glass-bg;
  backdrop-filter: blur(32rpx);

  .header-back {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 64rpx;
    height: 64rpx;
    border-radius: 50%;
    transition: background-color 0.2s;
    flex-shrink: 0;

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
    width: 64rpx;
    flex-shrink: 0;
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
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: 42rpx;
  box-shadow: 0 8rpx 60rpx rgb(0 0 0 / 3%);
  backdrop-filter: blur(32rpx);
}

// 表单区块
.form-section {
  padding: 32rpx;

  .section-title {
    display: flex;
    align-items: center;
    gap: 12rpx;
    margin-bottom: 32rpx;
    font-size: 32rpx;
    color: $text-main;
    font-weight: 700;

    text {
      margin-left: 4rpx;
    }
  }

  .form-item {
    margin-bottom: 32rpx;

    &:last-child {
      margin-bottom: 0;
    }

    .form-label {
      margin-bottom: 16rpx;
      font-size: 28rpx;
      color: $text-main;
      font-weight: 600;

      .required {
        margin-left: 4rpx;
        color: #ef4444;
      }
    }

    .radio-item-wrapper {
      margin-right: 48rpx;
      margin-bottom: 16rpx;

      &:last-child {
        margin-right: 0;
      }
    }
  }
}

// 提交按钮
.submit-btn-wrapper {
  padding: 32rpx 0;
  margin-bottom: 32rpx;
}

// 单选框间距调整
:deep(.u-radio-group) {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}
</style>
