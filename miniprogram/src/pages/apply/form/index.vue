<template>
  <view>
    <FormLayout
      title="业务填报"
      submit-text="提交申请"
      @submit="handleSubmit"
    >
      <!-- 弹窗插槽 -->
      <template #popups>
        <!-- 申请类型选择弹窗 -->
        <view
          v-if="showApplyTypePicker"
          class="picker-overlay"
          @click="showApplyTypePicker = false"
        />
        <view
          v-if="showApplyTypePicker"
          class="custom-picker-popup"
        >
          <view class="picker-popup-header">
            <view class="cancel-btn picker-popup-btn" @click="showApplyTypePicker = false">
              取消
            </view>
            <view class="picker-popup-title">
              申请类型
            </view>
            <view class="picker-popup-btn confirm-btn" @click="confirmApplyType">
              完成
            </view>
          </view>
          <view class="picker-popup-content">
            <view
              v-for="(option, index) in filteredApplyTypeOptions"
              :key="index"
              class="picker-popup-item"
              :class="{ active: tempApplyTypeIndex === index }"
              @click="handleSelectApplyType(index)"
            >
              <view class="picker-item-icon">
                <u-icon
                  v-if="tempApplyTypeIndex === index"
                  name="checkmark"
                  size="20"
                  color="#0adbc3"
                />
              </view>
              <view class="picker-item-text">
                {{ option.label }}
              </view>
            </view>
          </view>
        </view>

        <DateRangePicker ref="dateRangePickerRef" />

        <!-- 报修类型选择弹窗 -->
        <view
          v-if="showRepairTypePicker"
          class="picker-overlay"
          @click="closeRepairTypePicker"
        />
        <view
          v-if="showRepairTypePicker"
          class="custom-picker-popup"
        >
          <view class="picker-popup-header">
            <view class="cancel-btn picker-popup-btn" @click="closeRepairTypePicker">
              取消
            </view>
            <view class="picker-popup-title">
              报修类型
            </view>
            <view class="picker-popup-btn confirm-btn" @click="confirmRepairType">
              完成
            </view>
          </view>
          <view class="picker-popup-content">
            <view
              v-for="(option, index) in repairTypeOptions"
              :key="index"
              class="picker-popup-item"
              :class="{ active: tempRepairTypeIndex === index }"
              @click="handleSelectRepairType(index)"
            >
              <view class="picker-item-icon">
                <u-icon
                  v-if="tempRepairTypeIndex === index"
                  name="checkmark"
                  size="20"
                  color="#0adbc3"
                />
              </view>
              <view class="picker-item-text">
                {{ option.label }}
              </view>
            </view>
          </view>
        </view>

        <SignaturePicker ref="signaturePickerRef" />
      </template>

      <!-- 主内容插槽 -->
      <template #content>
        <!-- 微信小程序 slot 会创建包装层，需要额外容器来应用 gap -->
        <view class="content-wrapper">
          <!-- 标题区域 -->
          <TitleSection />

          <!-- 基础信息卡片 -->
          <BaseInfoCard :user-info="userInfo" />

          <!-- 业务详情卡片 -->
          <ApplyDetailCard
            v-model="formData.applyType"
            :form-data="formData"
            :hide-type-picker="hideTypePicker"
            :filtered-apply-type-options="filteredApplyTypeOptions"
            :can-modify-apply-type="canModifyApplyType"
            :repair-type-options="repairTypeOptions"
            :repair-type="formData.repairType"
            @update:repair-type="(val) => formData.repairType = val"
            @form-update="handleFormUpdate"
          />
        </view>
      </template>
    </FormLayout>
  </view>
</template>

<script setup lang="ts">
import { provide } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
// 小程序不支持 barrel export，必须直接导入 .vue 文件
import DateRangePicker from './components/pickers/DateRangePicker.vue';
import SignaturePicker from './components/pickers/SignaturePicker.vue';
import ApplyDetailCard from './sections/ApplyDetailCard.vue';
import BaseInfoCard from './sections/BaseInfoCard.vue';
import FormLayout from './sections/FormLayout.vue';
import TitleSection from './sections/TitleSection.vue';
// 小程序不支持 barrel export，必须直接导入
import { repairTypeOptions, useApplyFormState } from './composables/useApplyFormState';
import { useApplyFormPickers } from './composables/useApplyFormPickers';
import { useApplyFormActions } from './composables/useApplyFormActions';

// 表单状态
const {
  formData,
  applyTypeIndex,
  hideTypePicker,
  userInfo,
  canModifyApplyType,
  filteredApplyTypeOptions,
  filteredApplyTypeIndex,
  handleFormUpdate,
  initApplyType,
  resetFormFields,
} = useApplyFormState();

// Picker 状态与行为
const {
  showApplyTypePicker,
  tempApplyTypeIndex,
  openApplyTypePicker,
  handleSelectApplyType,
  confirmApplyType,
  showRepairTypePicker,
  tempRepairTypeIndex,
  openRepairTypePicker,
  handleSelectRepairType,
  confirmRepairType,
  closeRepairTypePicker,
  dateRangePickerRef,
  signaturePickerRef,
  openDateRangePicker,
  openSignaturePicker,
} = useApplyFormPickers({
  formData,
  applyTypeIndex,
  canModifyApplyType,
  filteredApplyTypeOptions,
  filteredApplyTypeIndex,
  resetFormFields,
});

// 表单提交
const { handleSubmit } = useApplyFormActions(formData);

// Provide 给子组件使用
provide('openDateRangePicker', openDateRangePicker);
provide('openSignaturePicker', openSignaturePicker);
provide('openApplyTypePicker', openApplyTypePicker);
provide('openRepairTypePicker', openRepairTypePicker);

// 页面加载时接收参数
onLoad((options: any) => {
  initApplyType(options?.type);
});
</script>

<style lang="scss" scoped>
// slot 内容包装器 - 应用 gap 布局
.content-wrapper {
  display: flex;
  flex-direction: column;
  gap: 40rpx;
}

// 遮罩层 - 固定在屏幕，不受父容器影响
.picker-overlay {
  position: fixed !important;
  inset: 0 !important;
  z-index: 99998 !important;
  background: rgb(0 0 0 / 50%);
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }

  to {
    opacity: 1;
  }
}

// 自定义 Picker 弹窗样式 - 固定在屏幕底部，不受父容器影响
.custom-picker-popup {
  position: fixed !important;
  right: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  z-index: 99999 !important;
  overflow: hidden;
  padding-bottom: env(safe-area-inset-bottom);
  width: 100vw !important;
  max-height: 80vh;
  background: #fff;
  border-radius: 32rpx 32rpx 0 0;
  animation: slideUp 0.3s;

  .picker-popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 32rpx 48rpx;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%);
    background: #fff;

    .picker-popup-btn {
      padding: 8rpx 16rpx;
      font-size: 32rpx;
      transition: all 0.2s;
      font-weight: 500;

      &.cancel-btn {
        color: #6b7280;

        &:active {
          color: #111817;
        }
      }

      &.confirm-btn {
        color: #0adbc3;
        font-weight: 600;

        &:active {
          color: #08bda8;
        }
      }
    }

    .picker-popup-title {
      font-size: 36rpx;
      text-align: center;
      color: #111817;
      flex: 1;
      font-weight: 700;
    }
  }

  .picker-popup-content {
    overflow-y: auto;
    padding: 16rpx 0;
    max-height: calc(80vh - 120rpx);

    .picker-popup-item {
      position: relative;
      padding: 32rpx 48rpx;
      font-size: 32rpx;
      text-align: center;
      color: #111817;
      transition: all 0.2s;

      .picker-item-icon {
        position: absolute;
        top: 50%;
        right: 75rpx;
        display: flex;
        justify-content: center;
        align-items: center;
        transform: translateY(-50%);
      }

      .picker-item-text {
        display: block;
        width: 100%;
        text-align: center;
      }

      &.active {
        color: #0adbc3;
        font-weight: 700;
      }
    }
  }
}

@keyframes slideUp {
  from {
    transform: translateY(100%);
  }

  to {
    transform: translateY(0);
  }
}
</style>
