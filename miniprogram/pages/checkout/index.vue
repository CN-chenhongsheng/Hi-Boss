<template>
  <view class="page-container">
    <!-- 页面标题 -->
    <view class="page-header">
      <view class="header-icon">🚪</view>
      <view class="header-title">退宿申请</view>
      <view class="header-desc">请填写退宿信息，提交后等待审核</view>
    </view>

    <!-- 表单区域 -->
    <view class="form-card">
      <!-- 当前宿舍信息 -->
      <view class="form-section">
        <view class="section-title">当前宿舍</view>

        <view class="info-row">
          <view class="info-item">
            <text class="info-label">楼栋</text>
            <text class="info-value">{{ currentDorm.building }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">房间</text>
            <text class="info-value">{{ currentDorm.room }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">床位</text>
            <text class="info-value">{{ currentDorm.bed }}</text>
          </view>
        </view>
      </view>

      <!-- 退宿信息 -->
      <view class="form-section">
        <view class="section-title">退宿信息</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            退宿类型
          </view>
          <picker mode="selector" :range="typeList" @change="onTypeChange">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.type }">
                {{ formData.type || '请选择退宿类型' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            预计退宿日期
          </view>
          <picker mode="date" @change="onDateChange" :start="today">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.checkoutDate }">
                {{ formData.checkoutDate || '请选择退宿日期' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            退宿后去向
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.destination"
            placeholder="请输入退宿后去向"
            placeholder-class="placeholder"
          />
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            联系电话
          </view>
          <input
            class="form-input"
            type="number"
            v-model="formData.phone"
            placeholder="请输入联系电话"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 退宿原因 -->
      <view class="form-section">
        <view class="section-title">退宿原因</view>

        <textarea
          class="form-textarea"
          v-model="formData.reason"
          placeholder="请详细说明退宿原因"
          placeholder-class="placeholder"
          :maxlength="500"
        />
        <view class="textarea-count">{{ formData.reason.length }}/500</view>
      </view>

      <!-- 注意事项 -->
      <view class="form-section">
        <view class="section-title">注意事项</view>
        <view class="notice-box">
          <view class="notice-item">1. 退宿前请确保已结清所有费用</view>
          <view class="notice-item">2. 请在退宿日期前完成物品搬离</view>
          <view class="notice-item">3. 退宿需归还宿舍钥匙和门禁卡</view>
          <view class="notice-item">4. 审核通过后请按时办理手续</view>
        </view>
      </view>
    </view>

    <!-- 提交按钮 -->
    <view class="submit-section">
      <button class="submit-btn" @click="handleSubmit">提交申请</button>
    </view>
  </view>
</template>

<script setup lang="ts">
  import { ref, reactive } from 'vue'
  import { onLoad } from '@dcloudio/uni-app'

  // 当前宿舍信息（示例数据）
  const currentDorm = ref({
    building: '1号楼',
    room: '101',
    bed: 'A床'
  })

  // 今天日期
  const today = new Date().toISOString().split('T')[0]

  // 表单数据
  const formData = reactive({
    type: '',
    checkoutDate: '',
    destination: '',
    phone: '',
    reason: ''
  })

  // 选项数据
  const typeList = ref(['毕业离校', '休学', '退学', '校外租房', '其他'])

  onLoad(() => {
    console.log('退宿页面加载')
  })

  // 选择器变化事件
  const onTypeChange = (e: { detail: { value: number } }) => {
    formData.type = typeList.value[e.detail.value]
  }

  const onDateChange = (e: { detail: { value: string } }) => {
    formData.checkoutDate = e.detail.value
  }

  // 提交表单
  const handleSubmit = () => {
    // 表单验证
    if (!formData.type) {
      return showToast('请选择退宿类型')
    }
    if (!formData.checkoutDate) {
      return showToast('请选择退宿日期')
    }
    if (!formData.destination) {
      return showToast('请输入退宿后去向')
    }
    if (!formData.phone) {
      return showToast('请输入联系电话')
    }
    if (!formData.reason) {
      return showToast('请填写退宿原因')
    }

    // TODO: 调用 API 提交表单
    console.log('提交表单:', formData)

    uni.showModal({
      title: '提交成功',
      content: '您的退宿申请已提交，请等待审核',
      showCancel: false,
      success: () => {
        uni.navigateBack()
      }
    })
  }

  const showToast = (title: string) => {
    uni.showToast({
      title,
      icon: 'none'
    })
  }
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
    background-color: #f5f5f5;
    padding-bottom: 120rpx;
  }

  /* 页面头部 */
  .page-header {
    background: linear-gradient(135deg, #dd524d 0%, #e67672 100%);
    padding: 48rpx 32rpx;
    text-align: center;
    color: #fff;
  }

  .header-icon {
    font-size: 80rpx;
    margin-bottom: 16rpx;
  }

  .header-title {
    font-size: 40rpx;
    font-weight: 600;
    margin-bottom: 12rpx;
  }

  .header-desc {
    font-size: 26rpx;
    opacity: 0.9;
  }

  /* 表单卡片 */
  .form-card {
    margin: -24rpx 32rpx 32rpx;
    background: #fff;
    border-radius: 24rpx;
    padding: 32rpx;
    box-shadow: 0 4rpx 24rpx rgba(0, 0, 0, 0.08);
  }

  .form-section {
    margin-bottom: 32rpx;

    &:last-child {
      margin-bottom: 0;
    }
  }

  .section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 24rpx;
    padding-left: 16rpx;
    border-left: 6rpx solid #dd524d;
  }

  /* 当前宿舍信息展示 */
  .info-row {
    display: flex;
    background: #fef0f0;
    border-radius: 12rpx;
    padding: 24rpx;
  }

  .info-item {
    flex: 1;
    text-align: center;
  }

  .info-label {
    display: block;
    font-size: 24rpx;
    color: #999;
    margin-bottom: 8rpx;
  }

  .info-value {
    display: block;
    font-size: 28rpx;
    color: #333;
    font-weight: 500;
  }

  .form-item {
    margin-bottom: 24rpx;
  }

  .form-label {
    font-size: 28rpx;
    color: #333;
    margin-bottom: 12rpx;
  }

  .required {
    color: #dd524d;
    margin-right: 4rpx;
  }

  .form-input {
    width: 100%;
    height: 88rpx;
    background: #f8f8f8;
    border-radius: 12rpx;
    padding: 0 24rpx;
    font-size: 28rpx;
    color: #333;
  }

  .form-picker {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 88rpx;
    background: #f8f8f8;
    border-radius: 12rpx;
    padding: 0 24rpx;
    font-size: 28rpx;
    color: #333;
  }

  .picker-arrow {
    font-size: 32rpx;
    color: #999;
  }

  .placeholder {
    color: #999;
  }

  .form-textarea {
    width: 100%;
    height: 200rpx;
    background: #f8f8f8;
    border-radius: 12rpx;
    padding: 24rpx;
    font-size: 28rpx;
    color: #333;
  }

  .textarea-count {
    text-align: right;
    font-size: 24rpx;
    color: #999;
    margin-top: 8rpx;
  }

  /* 注意事项 */
  .notice-box {
    background: #fff8f0;
    border-radius: 12rpx;
    padding: 24rpx;
  }

  .notice-item {
    font-size: 26rpx;
    color: #666;
    line-height: 1.8;
  }

  /* 提交按钮 */
  .submit-section {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 24rpx 32rpx;
    background: #fff;
    box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.05);
  }

  .submit-btn {
    width: 100%;
    height: 96rpx;
    background: linear-gradient(135deg, #dd524d 0%, #e67672 100%);
    border-radius: 48rpx;
    color: #fff;
    font-size: 32rpx;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;

    &:active {
      opacity: 0.9;
    }
  }
</style>

