<template>
  <view class="habits-page">
    <!-- 背景装饰球 -->
    <view class="ambient-blob blob-primary" />
    <view class="ambient-blob blob-accent" />
    <view class="ambient-blob blob-blue" />

    <!-- 顶部导航 -->
    <view class="header">
      <view class="header-content">
        <view class="header-title">
          完善生活习惯
        </view>
        <view class="header-placeholder" />
      </view>
    </view>

    <!-- 表单内容区域 -->
    <scroll-view class="content-scroll" scroll-y>
      <view class="form-container">
        <!-- 提示卡片 -->
        <view class="glass-card info-card">
          <view class="info-icon">
            <u-icon name="info-circle" size="24" color="#0adbc3" />
          </view>
          <view class="info-content">
            <view class="info-title">
              为什么需要填写？
            </view>
            <view class="info-text">
              填写您的生活习惯将帮助我们为您匹配更合适的室友，创造和谐的宿舍环境。所有信息将严格保密。
            </view>
          </view>
        </view>

        <!-- 作息与睡眠 -->
        <view class="glass-card section-card">
          <view class="section-header">
            <view class="section-icon" style="background: rgb(10 219 195 / 10%);">
              <u-icon name="pause-circle" size="20" color="#0adbc3" />
            </view>
            <view class="section-title">
              作息与睡眠
            </view>
          </view>

          <!-- 作息时间 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                作息时间
              </text>
            </view>
            <u-radio-group v-model="formData.sleepSchedule" placement="column">
              <u-radio
                v-for="item in sleepScheduleOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 睡眠质量 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                睡眠质量
              </text>
            </view>
            <u-radio-group v-model="formData.sleepQuality" placement="column">
              <u-radio
                v-for="item in sleepQualityOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 是否打呼噜 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                是否打呼噜
              </text>
            </view>
            <u-radio-group v-model="formData.snores">
              <u-radio
                v-for="item in yesNoOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginRight: '32rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 对光线敏感 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                对光线敏感
              </text>
            </view>
            <u-radio-group v-model="formData.sensitiveToLight">
              <u-radio
                v-for="item in sensitiveOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginRight: '32rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 对声音敏感 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                对声音敏感
              </text>
            </view>
            <u-radio-group v-model="formData.sensitiveToSound">
              <u-radio
                v-for="item in sensitiveOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginRight: '32rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 吸烟状态 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                吸烟状态
              </text>
            </view>
            <u-radio-group v-model="formData.smokingStatus">
              <u-radio
                v-for="item in smokingOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginRight: '32rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 接受室友吸烟 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                接受室友吸烟
              </text>
            </view>
            <u-radio-group v-model="formData.smokingTolerance">
              <u-radio
                v-for="item in acceptOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginRight: '32rpx' }"
              />
            </u-radio-group>
          </view>
        </view>

        <!-- 卫生习惯 -->
        <view class="section-card glass-card">
          <view class="section-header">
            <view class="section-icon" style="background: rgb(255 140 66 / 10%);">
              <u-icon name="reload" size="20" color="#ff8c42" />
            </view>
            <view class="section-title">
              卫生习惯
            </view>
          </view>

          <!-- 整洁程度 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                整洁程度
              </text>
            </view>
            <u-radio-group v-model="formData.cleanlinessLevel" placement="column">
              <u-radio
                v-for="item in cleanlinessOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 睡前整理 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                睡前是否整理
              </text>
            </view>
            <u-radio-group v-model="formData.bedtimeCleanup" placement="column">
              <u-radio
                v-for="item in cleanupOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>
        </view>

        <!-- 社交与生活 -->
        <view class="section-card glass-card">
          <view class="section-header">
            <view class="section-icon" style="background: rgb(99 102 241 / 10%);">
              <u-icon name="account" size="20" color="#6366f1" />
            </view>
            <view class="section-title">
              社交与生活
            </view>
          </view>

          <!-- 社交偏好 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                社交偏好
              </text>
            </view>
            <u-radio-group v-model="formData.socialPreference" placement="column">
              <u-radio
                v-for="item in socialOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 允许访客 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                是否允许室友带访客
              </text>
            </view>
            <u-radio-group v-model="formData.allowVisitors" placement="column">
              <u-radio
                v-for="item in visitorOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 打电话习惯 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                打电话习惯
              </text>
            </view>
            <u-radio-group v-model="formData.phoneCallTime" placement="column">
              <u-radio
                v-for="item in phoneOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 在宿舍吃东西 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                是否在宿舍吃东西
              </text>
            </view>
            <u-radio-group v-model="formData.eatInRoom" placement="column">
              <u-radio
                v-for="item in frequencyOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>
        </view>

        <!-- 学习与娱乐 -->
        <view class="section-card glass-card">
          <view class="section-header">
            <view class="section-icon" style="background: rgb(168 85 247 / 10%);">
              <u-icon name="play-circle" size="20" color="#a855f7" />
            </view>
            <view class="section-title">
              学习与娱乐
            </view>
          </view>

          <!-- 在宿舍学习 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                是否在宿舍学习
              </text>
            </view>
            <u-radio-group v-model="formData.studyInRoom" placement="column">
              <u-radio
                v-for="item in studyFrequencyOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 学习环境 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                学习环境偏好
              </text>
            </view>
            <u-radio-group v-model="formData.studyEnvironment" placement="column">
              <u-radio
                v-for="item in studyEnvOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 电脑使用时间 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                电脑使用时间
              </text>
            </view>
            <u-radio-group v-model="formData.computerUsageTime" placement="column">
              <u-radio
                v-for="item in computerOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 游戏偏好 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                游戏偏好
              </text>
            </view>
            <u-radio-group v-model="formData.gamingPreference" placement="column">
              <u-radio
                v-for="item in frequencyOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 听音乐偏好 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                听音乐偏好
              </text>
            </view>
            <u-radio-group v-model="formData.musicPreference" placement="column">
              <u-radio
                v-for="item in frequencyOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>

          <!-- 音乐音量 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                音乐音量偏好
              </text>
            </view>
            <u-radio-group v-model="formData.musicVolume" placement="column">
              <u-radio
                v-for="item in volumeOptions"
                :key="item.value"
                :name="item.value"
                :label="item.label"
                active-color="#0adbc3"
                :custom-style="{ marginBottom: '16rpx' }"
              />
            </u-radio-group>
          </view>
        </view>

        <!-- 额外信息 -->
        <view class="section-card glass-card">
          <view class="section-header">
            <view class="section-icon" style="background: rgb(59 130 246 / 10%);">
              <u-icon name="file-text" size="20" color="#3b82f6" />
            </view>
            <view class="section-title">
              额外信息
            </view>
          </view>

          <!-- 特殊需求 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                特殊需求
              </text>
              <text class="label-hint">
                （如过敏、健康问题等）
              </text>
            </view>
            <u-textarea
              v-model="formData.specialNeeds"
              placeholder="请输入您的特殊需求"
              :maxlength="500"
              count
              :custom-style="textareaStyle"
            />
          </view>

          <!-- 室友偏好 -->
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">
                室友偏好
              </text>
              <text class="label-hint">
                （如希望室友不抽烟、安静等）
              </text>
            </view>
            <u-textarea
              v-model="formData.roommatePreference"
              placeholder="请输入您对室友的期望"
              :maxlength="200"
              count
              :custom-style="textareaStyle"
            />
          </view>
        </view>

        <!-- 底部安全区域 -->
        <view class="safe-bottom" />
      </view>
    </scroll-view>

    <!-- 底部提交按钮 -->
    <view class="footer">
      <view class="submit-btn" @click="handleSubmit">
        <text class="submit-text">
          提交
        </text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { IOptionItem, IStudentHabitsForm } from '@/types/api/student-habits';

// 表单数据
const formData = ref<IStudentHabitsForm>({
  sleepSchedule: null,
  sleepQuality: null,
  snores: null,
  sensitiveToLight: null,
  sensitiveToSound: null,
  smokingStatus: null,
  smokingTolerance: null,
  cleanlinessLevel: null,
  bedtimeCleanup: null,
  socialPreference: null,
  allowVisitors: null,
  phoneCallTime: null,
  eatInRoom: null,
  studyInRoom: null,
  studyEnvironment: null,
  computerUsageTime: null,
  gamingPreference: null,
  musicPreference: null,
  musicVolume: null,
  specialNeeds: '',
  roommatePreference: '',
});

// 选项配置
const sleepScheduleOptions: IOptionItem[] = [
  { label: '早睡早起（22:00-6:00）', value: 0 },
  { label: '正常（23:00-7:00）', value: 1 },
  { label: '晚睡晚起（24:00-8:00）', value: 2 },
  { label: '夜猫子（01:00-9:00）', value: 3 },
];

const sleepQualityOptions: IOptionItem[] = [
  { label: '浅睡易醒', value: 0 },
  { label: '正常', value: 1 },
  { label: '深睡', value: 2 },
];

const yesNoOptions: IOptionItem[] = [
  { label: '不打', value: 0 },
  { label: '打', value: 1 },
];

const sensitiveOptions: IOptionItem[] = [
  { label: '不敏感', value: 0 },
  { label: '敏感', value: 1 },
];

const smokingOptions: IOptionItem[] = [
  { label: '不吸烟', value: 0 },
  { label: '吸烟', value: 1 },
];

const acceptOptions: IOptionItem[] = [
  { label: '不接受', value: 0 },
  { label: '接受', value: 1 },
];

const cleanlinessOptions: IOptionItem[] = [
  { label: '非常整洁', value: 1 },
  { label: '整洁', value: 2 },
  { label: '一般', value: 3 },
  { label: '随意', value: 4 },
  { label: '不整洁', value: 5 },
];

const cleanupOptions: IOptionItem[] = [
  { label: '不整理', value: 0 },
  { label: '偶尔整理', value: 1 },
  { label: '经常整理', value: 2 },
  { label: '总是整理', value: 3 },
];

const socialOptions: IOptionItem[] = [
  { label: '喜欢安静', value: 1 },
  { label: '中等', value: 2 },
  { label: '喜欢热闹', value: 3 },
];

const visitorOptions: IOptionItem[] = [
  { label: '不允许', value: 0 },
  { label: '偶尔可以', value: 1 },
  { label: '可以', value: 2 },
];

const phoneOptions: IOptionItem[] = [
  { label: '喜欢在宿舍打电话', value: 0 },
  { label: '偶尔在宿舍', value: 1 },
  { label: '不在宿舍打电话', value: 2 },
];

const frequencyOptions: IOptionItem[] = [
  { label: '不', value: 0 },
  { label: '偶尔', value: 1 },
  { label: '经常', value: 2 },
];

const studyFrequencyOptions: IOptionItem[] = [
  { label: '不在', value: 0 },
  { label: '偶尔', value: 1 },
  { label: '经常', value: 2 },
  { label: '总是', value: 3 },
];

const studyEnvOptions: IOptionItem[] = [
  { label: '需要安静', value: 1 },
  { label: '需要轻音乐', value: 2 },
  { label: '可以接受声音', value: 3 },
];

const computerOptions: IOptionItem[] = [
  { label: '不用', value: 0 },
  { label: '很少（1-2h/天）', value: 1 },
  { label: '正常（3-5h/天）', value: 2 },
  { label: '很多（6h+/天）', value: 3 },
];

const volumeOptions: IOptionItem[] = [
  { label: '喜欢小声', value: 1 },
  { label: '中等', value: 2 },
  { label: '喜欢大声', value: 3 },
];

// 文本域样式
const textareaStyle = {
  backgroundColor: '#f8fafc',
  borderRadius: '16rpx',
  padding: '24rpx',
  fontSize: '28rpx',
};

// 验证表单
function validateForm(): boolean {
  // 检查必填的选择题是否已填写（至少一项）
  const hasBasicInfo = formData.value.sleepSchedule !== undefined
    || formData.value.sleepQuality !== undefined
    || formData.value.cleanlinessLevel !== undefined;

  if (!hasBasicInfo) {
    uni.showToast({
      title: '请至少填写一项生活习惯',
      icon: 'none',
      duration: 2000,
    });
    return false;
  }

  // 验证文本字段长度
  if (formData.value.specialNeeds && formData.value.specialNeeds.length > 500) {
    uni.showToast({
      title: '特殊需求不能超过500字符',
      icon: 'none',
      duration: 2000,
    });
    return false;
  }

  if (formData.value.roommatePreference && formData.value.roommatePreference.length > 200) {
    uni.showToast({
      title: '室友偏好不能超过200字符',
      icon: 'none',
      duration: 2000,
    });
    return false;
  }

  return true;
}

// 提交
function handleSubmit(): void {
  // 验证表单
  if (!validateForm()) {
    return;
  }

  // 显示加载提示
  uni.showLoading({
    title: '提交中...',
    mask: true,
  });

  // 打印提交的数据（用于调试）
  console.log('提交的表单数据：', formData.value);

  // 模拟API调用延迟
  setTimeout(() => {
    uni.hideLoading();

    // TODO: 实际项目中这里应该调用API
    // 示例：
    // import { updateStudentHabits } from '@/api/student';
    // updateStudentHabits(formData.value).then(() => {
    //   uni.showToast({ title: '提交成功', icon: 'success' });
    //   setTimeout(() => uni.navigateBack(), 2000);
    // }).catch(() => {
    //   uni.showToast({ title: '提交失败', icon: 'error' });
    // });

    uni.showModal({
      title: '提交成功',
      content: '您的生活习惯信息已保存，我们将为您匹配更合适的室友。',
      showCancel: false,
      success: () => {
        setTimeout(() => {
          uni.navigateBack();
        }, 500);
      },
    });
  }, 1000);
}
</script>

<style lang="scss" scoped>
// 主题变量
$primary: #0adbc3;
$primary-dark: #009688;
$accent: #ff8c42;
$bg-light: #F0F4F8;

.habits-page {
  position: relative;
  overflow: hidden;
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
    top: 600rpx;
    left: -200rpx;
    width: 560rpx;
    height: 560rpx;
    background-color: rgb(255 140 66 / 25%);
  }

  &.blob-blue {
    right: -100rpx;
    bottom: 400rpx;
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
  z-index: 100;
  padding: calc(var(--status-bar-height) + 50rpx) 32rpx 25rpx;

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .header-title {
    font-size: 36rpx;
    font-weight: 700;
    color: #0f172a;
  }

  .header-placeholder {
    width: 64rpx;
  }
}

// 内容滚动区域
.content-scroll {
  position: relative;
  z-index: 10;
  height: calc(100vh - var(--status-bar-height) - 84rpx - 120rpx);
}

// 表单容器
.form-container {
  padding: 0 32rpx 32rpx;
}

// 提示卡片
.info-card {
  display: flex;
  align-items: flex-start;
  padding: 32rpx;
  margin-bottom: 32rpx;
  gap: 20rpx;

  .info-icon {
    flex-shrink: 0;
    margin-top: 4rpx;
  }

  .info-content {
    flex: 1;
  }

  .info-title {
    margin-bottom: 12rpx;
    font-size: 28rpx;
    font-weight: 700;
    color: #0f172a;
  }

  .info-text {
    font-size: 24rpx;
    color: #64748b;
    line-height: 1.6;
  }
}

// 区块卡片
.section-card {
  padding: 32rpx;
  margin-bottom: 24rpx;
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 32rpx;
  gap: 16rpx;
}

.section-icon {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
}

.section-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #0f172a;
}

// 表单项
.form-item {
  margin-bottom: 40rpx;

  &:last-child {
    margin-bottom: 0;
  }
}

.form-label {
  display: flex;
  align-items: baseline;
  margin-bottom: 20rpx;

  .label-text {
    font-size: 28rpx;
    font-weight: 600;
    color: #334155;
  }

  .label-hint {
    margin-left: 8rpx;
    font-size: 24rpx;
    color: #94a3b8;
  }
}

// 底部安全区域
.safe-bottom {
  height: 40rpx;
}

// 底部提交按钮
.footer {
  position: fixed;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 100;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: linear-gradient(to top, rgb(240 244 248 / 98%), rgb(240 244 248 / 90%));
  backdrop-filter: blur(20rpx);
}

.submit-btn {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 96rpx;
  background: linear-gradient(135deg, #0adbc3 0%, #009688 100%);
  border-radius: 48rpx;
  box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 30%);
  transition: all 0.3s;

  &:active {
    transform: scale(0.98);
    box-shadow: 0 4rpx 16rpx rgb(10 219 195 / 30%);
  }

  .submit-text {
    font-size: 32rpx;
    font-weight: 700;
    color: #fff;
  }
}
</style>
