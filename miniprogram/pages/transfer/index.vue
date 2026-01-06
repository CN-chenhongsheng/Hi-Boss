<template>
  <view class="page-container">
    <!-- 页面标题 -->
    <view class="page-header">
      <view class="header-icon">🔄</view>
      <view class="header-title">调宿申请</view>
      <view class="header-desc">请填写调宿信息，提交后等待审核</view>
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

      <!-- 目标宿舍信息 -->
      <view class="form-section">
        <view class="section-title">目标宿舍</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            目标楼栋
          </view>
          <picker
            mode="selector"
            :range="buildingList"
            @change="onBuildingChange"
          >
            <view class="form-picker">
              <text :class="{ placeholder: !formData.targetBuilding }">
                {{ formData.targetBuilding || '请选择目标楼栋' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            目标房间号
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.targetRoom"
            placeholder="请输入目标房间号"
            placeholder-class="placeholder"
          />
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            目标床位
          </view>
          <picker mode="selector" :range="bedList" @change="onBedChange">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.targetBed }">
                {{ formData.targetBed || '请选择目标床位' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>
      </view>

      <!-- 调宿原因 -->
      <view class="form-section">
        <view class="section-title">调宿原因</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            原因类型
          </view>
          <picker mode="selector" :range="reasonList" @change="onReasonChange">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.reasonType }">
                {{ formData.reasonType || '请选择原因类型' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            详细说明
          </view>
          <textarea
            class="form-textarea"
            v-model="formData.reason"
            placeholder="请详细说明调宿原因"
            placeholder-class="placeholder"
            :maxlength="500"
          />
          <view class="textarea-count">{{ formData.reason.length }}/500</view>
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

  // 表单数据
  const formData = reactive({
    targetBuilding: '',
    targetRoom: '',
    targetBed: '',
    reasonType: '',
    reason: ''
  })

  // 选项数据
  const buildingList = ref(['1号楼', '2号楼', '3号楼', '4号楼', '5号楼'])
  const bedList = ref(['A床', 'B床', 'C床', 'D床'])
  const reasonList = ref(['室友关系', '学习需要', '生活习惯', '健康原因', '其他原因'])

  onLoad(() => {
    console.log('调宿页面加载')
  })

  // 选择器变化事件
  const onBuildingChange = (e: { detail: { value: number } }) => {
    formData.targetBuilding = buildingList.value[e.detail.value]
  }

  const onBedChange = (e: { detail: { value: number } }) => {
    formData.targetBed = bedList.value[e.detail.value]
  }

  const onReasonChange = (e: { detail: { value: number } }) => {
    formData.reasonType = reasonList.value[e.detail.value]
  }

  // 提交表单
  const handleSubmit = () => {
    // 表单验证
    if (!formData.targetBuilding) {
      return showToast('请选择目标楼栋')
    }
    if (!formData.targetRoom) {
      return showToast('请输入目标房间号')
    }
    if (!formData.targetBed) {
      return showToast('请选择目标床位')
    }
    if (!formData.reasonType) {
      return showToast('请选择原因类型')
    }
    if (!formData.reason) {
      return showToast('请填写详细说明')
    }

    // TODO: 调用 API 提交表单
    console.log('提交表单:', formData)

    uni.showModal({
      title: '提交成功',
      content: '您的调宿申请已提交，请等待审核',
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
    background: linear-gradient(135deg, #f0ad4e 0%, #f5c478 100%);
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
    border-left: 6rpx solid #f0ad4e;
  }

  /* 当前宿舍信息展示 */
  .info-row {
    display: flex;
    background: #fff8f0;
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
    background: linear-gradient(135deg, #f0ad4e 0%, #f5c478 100%);
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

