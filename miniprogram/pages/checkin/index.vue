<template>
  <view class="page-container">
    <!-- 页面标题 -->
    <view class="page-header">
      <view class="header-icon">🏠</view>
      <view class="header-title">入住申请</view>
      <view class="header-desc">请填写入住信息，提交后等待审核</view>
    </view>

    <!-- 表单区域 -->
    <view class="form-card">
      <!-- 基本信息 -->
      <view class="form-section">
        <view class="section-title">基本信息</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            姓名
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.name"
            placeholder="请输入姓名"
            placeholder-class="placeholder"
          />
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            学号
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.studentId"
            placeholder="请输入学号"
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

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            学院
          </view>
          <picker
            mode="selector"
            :range="collegeList"
            @change="onCollegeChange"
          >
            <view class="form-picker">
              <text :class="{ placeholder: !formData.college }">
                {{ formData.college || '请选择学院' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>
      </view>

      <!-- 宿舍信息 -->
      <view class="form-section">
        <view class="section-title">宿舍信息</view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            楼栋
          </view>
          <picker
            mode="selector"
            :range="buildingList"
            @change="onBuildingChange"
          >
            <view class="form-picker">
              <text :class="{ placeholder: !formData.building }">
                {{ formData.building || '请选择楼栋' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            房间号
          </view>
          <input
            class="form-input"
            type="text"
            v-model="formData.room"
            placeholder="请输入房间号"
            placeholder-class="placeholder"
          />
        </view>

        <view class="form-item">
          <view class="form-label">
            <text class="required">*</text>
            床位
          </view>
          <picker mode="selector" :range="bedList" @change="onBedChange">
            <view class="form-picker">
              <text :class="{ placeholder: !formData.bed }">
                {{ formData.bed || '请选择床位' }}
              </text>
              <text class="picker-arrow">›</text>
            </view>
          </picker>
        </view>
      </view>

      <!-- 备注 -->
      <view class="form-section">
        <view class="section-title">备注说明</view>
        <textarea
          class="form-textarea"
          v-model="formData.remark"
          placeholder="请输入备注信息（选填）"
          placeholder-class="placeholder"
          :maxlength="200"
        />
        <view class="textarea-count">{{ formData.remark.length }}/200</view>
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

  // 表单数据
  const formData = reactive({
    name: '',
    studentId: '',
    phone: '',
    college: '',
    building: '',
    room: '',
    bed: '',
    remark: ''
  })

  // 选项数据
  const collegeList = ref(['计算机学院', '电子信息学院', '机械工程学院', '经济管理学院', '文学院'])
  const buildingList = ref(['1号楼', '2号楼', '3号楼', '4号楼', '5号楼'])
  const bedList = ref(['A床', 'B床', 'C床', 'D床'])

  onLoad(() => {
    console.log('入住页面加载')
  })

  // 选择器变化事件
  const onCollegeChange = (e: { detail: { value: number } }) => {
    formData.college = collegeList.value[e.detail.value]
  }

  const onBuildingChange = (e: { detail: { value: number } }) => {
    formData.building = buildingList.value[e.detail.value]
  }

  const onBedChange = (e: { detail: { value: number } }) => {
    formData.bed = bedList.value[e.detail.value]
  }

  // 提交表单
  const handleSubmit = () => {
    // 表单验证
    if (!formData.name) {
      return showToast('请输入姓名')
    }
    if (!formData.studentId) {
      return showToast('请输入学号')
    }
    if (!formData.phone) {
      return showToast('请输入联系电话')
    }
    if (!formData.college) {
      return showToast('请选择学院')
    }
    if (!formData.building) {
      return showToast('请选择楼栋')
    }
    if (!formData.room) {
      return showToast('请输入房间号')
    }
    if (!formData.bed) {
      return showToast('请选择床位')
    }

    // TODO: 调用 API 提交表单
    console.log('提交表单:', formData)

    uni.showModal({
      title: '提交成功',
      content: '您的入住申请已提交，请等待审核',
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
    background: linear-gradient(135deg, #5d87ff 0%, #7b9fff 100%);
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
    border-left: 6rpx solid #5d87ff;
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
    background: linear-gradient(135deg, #5d87ff 0%, #7b9fff 100%);
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

