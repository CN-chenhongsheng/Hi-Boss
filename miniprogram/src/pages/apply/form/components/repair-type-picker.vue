<template>
  <view class="repair-type-picker-wrapper">
    <view
      class="input-group"
      @click="openPicker()"
    >
      <view class="input-icon">
        <u-icon name="setting" size="20" color="#0adbc3" />
      </view>
      <view class="input-content">
        <view class="input-label">
          报修类型
          <text class="required-mark">
            *
          </text>
        </view>
        <view class="input-value picker-enhanced" :class="{ 'placeholder': !displayLabel, 'has-value': displayLabel }">
          {{ displayLabel }}
        </view>
      </view>
      <view class="input-arrow">
        <u-icon name="arrow-down-fill" size="20" color="#9ca3af" />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, inject } from 'vue';

interface RepairTypeOption {
  label: string;
  value: number;
}

interface Props {
  modelValue: number | undefined;
  options: RepairTypeOption[];
}

const props = defineProps<Props>();

// 从父组件注入打开选择器的函数
const openRepairTypePicker = inject<() => void>('openRepairTypePicker');

const displayLabel = computed(() => {
  if (!props.modelValue) {
    return '请选择报修类型';
  }
  const option = props.options.find(opt => opt.value === props.modelValue);
  return option?.label || '请选择报修类型';
});

function openPicker() {
  if (openRepairTypePicker) {
    openRepairTypePicker();
  }
}
</script>

<style lang="scss" scoped>
.repair-type-picker-wrapper {
  width: 100%;
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
  user-select: none;
  -webkit-tap-highlight-color: transparent;

  .input-icon {
    position: absolute;
    left: 24rpx;
    display: flex;
    align-items: center;
    pointer-events: none;
  }

  .input-content {
    padding: 16rpx 80rpx;
    flex: 1;

    .input-label {
      display: block;
      margin-bottom: 8rpx;
      font-size: 20rpx;
      color: #9ca3af;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1rpx;

      .required-mark {
        color: #ff9f43;
      }
    }

    .input-value {
      display: flex;
      align-items: center;
      width: 100%;
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
    transition: all 0.3s;
  }

  &:active {
    background: rgb(255 255 255 / 100%);
    border-color: #0adbc3;
    box-shadow: 0 4rpx 12rpx rgb(10 219 195 / 15%);
    transform: translateY(-2rpx);

    .input-arrow {
      color: #0adbc3;
      transform: rotate(180deg);
    }
  }
}
</style>
