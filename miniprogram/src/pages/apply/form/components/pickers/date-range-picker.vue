<template>
  <view class="date-range-picker-wrapper">
    <view v-if="label" class="picker-label">
      {{ label }}
      <text v-if="required" class="required-mark">
        *
      </text>
    </view>

    <view class="input-group" @click="openDateRangePickerLocal">
      <view class="input-icon">
        <u-icon name="calendar" size="20" color="#0adbc3" />
      </view>
      <view class="input-content">
        <view class="input-value" :class="{ 'placeholder': !displayValue, 'has-value': displayValue }">
          {{ displayValue || '请选择日期范围' }}
        </view>
      </view>
      <view class="input-arrow">
        <u-icon name="arrow-down-fill" size="20" color="#9ca3af" />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { inject, nextTick, ref, watch } from 'vue';

interface Props {
  modelValue?: {
    startDate?: string;
    endDate?: string;
  };
  label?: string;
  required?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: () => ({}),
  label: '留宿时间',
  required: false,
});

const emit = defineEmits<{
  'update:modelValue': [value: { startDate?: string; endDate?: string }];
}>();

const openDateRangePicker = inject<(currentValue: { startDate?: string; endDate?: string }, onConfirm: (value: { startDate?: string; endDate?: string }) => void) => void>('openDateRangePicker');

// 使用本地状态存储显示值（小程序兼容性更好）
const displayValue = ref('');

// 更新显示值
function updateDisplayValue() {
  const { startDate, endDate } = props.modelValue || {};
  if (startDate && endDate) {
    displayValue.value = `${startDate} 至 ${endDate}`;
  }
  else {
    displayValue.value = '';
  }
}

// 监听 props.modelValue 变化（小程序需要显式监听）
watch(() => [props.modelValue?.startDate, props.modelValue?.endDate], () => {
  updateDisplayValue();
}, { immediate: true });

// 打开日期范围选择器
function openDateRangePickerLocal() {
  if (openDateRangePicker) {
    openDateRangePicker(props.modelValue || {}, (value) => {
      // 先更新本地显示值（确保小程序中立即显示）
      if (value.startDate && value.endDate) {
        displayValue.value = `${value.startDate} 至 ${value.endDate}`;
      }
      // 然后触发 emit 更新父组件
      emit('update:modelValue', value);
      // 使用 nextTick 确保响应式更新完成
      nextTick(() => {
        updateDisplayValue();
      });
    });
  }
}
</script>

<style lang="scss" scoped>
.date-range-picker-wrapper {
  width: 100%;
}

.picker-label {
  margin-bottom: 16rpx;
  font-size: 24rpx;
  color: #6b7280;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1rpx;

  .required-mark {
    margin-left: 4rpx;
    color: #ff9f43;
  }
}

.input-group {
  position: relative;
  display: flex;
  align-items: center;
  padding: 8rpx;
  background: rgb(255 255 255 / 60%);
  border: 1rpx solid rgb(255 255 255);
  border-radius: 32rpx;
  box-shadow: 0 2rpx 6rpx rgb(0 0 0 / 2%);
  transition: all 0.3s;
  cursor: pointer;

  .input-icon {
    position: absolute;
    left: 24rpx;
    display: flex;
    align-items: center;
    pointer-events: none;
  }

  .input-content {
    flex: 1;
    padding: 16rpx 80rpx;

    .input-value {
      display: flex;
      align-items: center;
      min-height: 48rpx;
      font-size: 28rpx;
      color: #111817;
      font-weight: 600;

      &.placeholder {
        color: #9ca3af;
        font-weight: 400;
      }

      &.has-value {
        color: #111817;
        font-weight: 600;
      }
    }
  }

  .input-arrow {
    position: absolute;
    right: 24rpx;
    display: flex;
    align-items: center;
    pointer-events: none;
  }
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

// 日期选择弹窗 - 固定在屏幕底部，不受父容器影响
.date-range-picker-popup {
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
}

@keyframes slideUp {
  from {
    transform: translateY(100%);
  }

  to {
    transform: translateY(0);
  }
}

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
  max-height: calc(80vh - 200rpx);
}

.date-range-tabs {
  display: flex;
  padding: 0 48rpx;
  border-bottom: 1rpx solid rgb(229 231 235 / 50%);
  margin-bottom: 24rpx;

  .date-tab {
    padding: 24rpx 0;
    font-size: 28rpx;
    text-align: center;
    color: #6b7280;
    transition: all 0.2s;
    flex: 1;
    border-bottom: 2rpx solid transparent;

    &.active {
      color: #0adbc3;
      font-weight: 700;
      border-bottom-color: #0adbc3;
    }
  }
}

.date-picker-view {
  width: 100%;
  height: 400rpx;
}

// 全局 Picker View 样式（微信小程序）
picker-view {
  width: 100%;
  height: 100%;
  background: #fff;
}

picker-view-column {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

picker-view .picker-view-item {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 16rpx 0;
  width: 100%;
  font-size: 32rpx;
  color: #111817;
  transition: all 0.3s;
}

picker-view .picker-view-item-selected {
  font-size: 36rpx;
  color: #0adbc3;
  font-weight: 700;
}
</style>
