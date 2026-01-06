<template>
  <view class="page-container">
    <!-- 页面标题 -->
    <view class="page-header">
      <view class="header-icon">🌙</view>
      <view class="header-title">留宿申请</view>
      <view class="header-desc">请填写留宿信息，提交后等待审核</view>
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

      <!-- 留宿信息 -->
      <view class="form-section">
        <view class="section-title">留宿信息</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            留宿类型
          </view>
          <picker mode="selector" :range="typeList" @change="onTypeChange">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.type }">
                {{ formData.type || '请选择留宿类型' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            留宿开始日期
          </view>
          <picker mode="date" @change="onStartDateChange" :start="today">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.startDate }">
                {{ formData.startDate || '请选择开始日期' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            留宿结束日期
          </view>
          <picker
            mode="date"
            @change="onEndDateChange"
            :start="formData.startDate || today"
          >
            <view class="form-picker">
              <text :class="{ placeholder: !formData.endDate }">
                {{ formData.endDate || '请选择结束日期' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            紧急联系人
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.emergencyContact"
            placeholder="请输入紧急联系人姓名"
            placeholder-class="placeholder"
          />
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            紧急联系电话
          </view>
          <input
            class="form-input"
            type="number"
            v-model="formData.emergencyPhone"
            placeholder="请输入紧急联系电话"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 留宿原因 -->
      <view class="form-section">
        <view class="section-title">留宿原因</view>

        <textarea
          class="form-textarea"
          v-model="formData.reason"
          placeholder="请详细说明留宿原因"
          placeholder-class="placeholder"
          :maxlength="500"
        />
        <view class="textarea-count">{{ formData.reason.length }}/500</view>
      </view>

      <!-- 注意事项 -->
      <view class="form-section">
        <view class="section-title">注意事项</view>
        <view class="notice-box">
          <view class="notice-item">1. 留宿期间请遵守宿舍管理规定</view>
          <view class="notice-item">2. 注意用电安全，节约水电</view>
          <view class="notice-item">3. 保持宿舍卫生整洁</view>
          <view class="notice-item">4. 如有紧急情况请及时联系管理员</view>
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
    startDate: '',
    endDate: '',
    emergencyContact: '',
    emergencyPhone: '',
    reason: ''
  })

  // 选项数据
  const typeList = ref(['寒假留宿', '暑假留宿', '节假日留宿', '其他'])

  onLoad(() => {
    console.log('留宿页面加载')
  })

  // 选择器变化事件
  const onTypeChange = (e: { detail: { value: number } }) => {
    formData.type = typeList.value[e.detail.value]
  }

  const onStartDateChange = (e: { detail: { value: string } }) => {
    formData.startDate = e.detail.value
    // 如果结束日期早于开始日期，清空结束日期
    if (formData.endDate && formData.endDate < formData.startDate) {
      formData.endDate = ''
    }
  }

  const onEndDateChange = (e: { detail: { value: string } }) => {
    formData.endDate = e.detail.value
  }

  // 提交表单
  const handleSubmit = () => {
    // 表单验证
    if (!formData.type) {
      return showToast('请选择留宿类型')
    }
    if (!formData.startDate) {
      return showToast('请选择开始日期')
    }
    if (!formData.endDate) {
      return showToast('请选择结束日期')
    }
    if (!formData.emergencyContact) {
      return showToast('请输入紧急联系人')
    }
    if (!formData.emergencyPhone) {
      return showToast('请输入紧急联系电话')
    }
    if (!formData.reason) {
      return showToast('请填写留宿原因')
    }

    // TODO: 调用 API 提交表单
    console.log('提交表单:', formData)

    uni.showModal({
      title: '提交成功',
      content: '您的留宿申请已提交，请等待审核',
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
    background: linear-gradient(135deg, #4cd964 0%, #6ee085 100%);
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
    border-left: 6rpx solid #4cd964;
  }

  /* 当前宿舍信息展示 */
  .info-row {
    display: flex;
    background: #f0fff4;
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
    background: #f0fff4;
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
    background: linear-gradient(135deg, #4cd964 0%, #6ee085 100%);
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

