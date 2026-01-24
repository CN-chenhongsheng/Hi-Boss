<template>
  <view
    v-if="state.show"
    class="picker-overlay"
    @click="closePicker"
  />
  <view
    v-if="state.show"
    class="date-range-picker-popup"
  >
    <view class="picker-popup-header">
      <view class="cancel-btn picker-popup-btn" @click="closePicker">
        取消
      </view>
      <view class="picker-popup-title">
        选择日期范围
      </view>
      <view class="picker-popup-btn confirm-btn" @click="confirmDateRange">
        完成
      </view>
    </view>
    <view class="picker-popup-content">
      <view class="date-range-tabs">
        <view
          class="date-tab"
          :class="{ active: state.activeTab === 'start' }"
          @click="state.activeTab = 'start'"
        >
          开始日期
        </view>
        <view
          class="date-tab"
          :class="{ active: state.activeTab === 'end' }"
          @click="state.activeTab = 'end'"
        >
          结束日期
        </view>
      </view>

      <picker-view
        class="date-picker-view"
        :value="state.activeTab === 'start' ? state.startDatePickerValue : state.endDatePickerValue"
        @change="handleDatePickerChange"
      >
        <picker-view-column>
          <view
            v-for="(year, index) in state.years"
            :key="index"
            class="picker-view-item"
          >
            {{ year }}年
          </view>
        </picker-view-column>
        <picker-view-column>
          <view
            v-for="(month, index) in state.months"
            :key="index"
            class="picker-view-item"
          >
            {{ month }}月
          </view>
        </picker-view-column>
        <picker-view-column>
          <view
            v-for="(day, index) in (state.activeTab === 'start' ? state.startDays : state.endDays)"
            :key="index"
            class="picker-view-item"
          >
            {{ day }}日
          </view>
        </picker-view-column>
      </picker-view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { useDateRangePicker } from '@/composables/useDateRangePicker';

interface DateRange {
  startDate?: string;
  endDate?: string;
}

const {
  state,
  openPicker,
  closePicker,
  confirmDateRange,
  handleDatePickerChange,
} = useDateRangePicker();

function open(currentValue: DateRange, onConfirm: (value: DateRange) => void) {
  openPicker(currentValue, onConfirm);
}

defineExpose({
  open,
});
</script>

<style lang="scss" scoped>
.date-picker-view {
  width: 100%;
  height: 400rpx;
  background: #fff;
}

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

  .picker-popup-header {
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    padding: 32rpx 48rpx !important;
    width: 100% !important;
    background: #fff !important;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%) !important;
    box-sizing: border-box !important;

    .picker-popup-btn {
      display: flex !important;
      justify-content: center !important;
      align-items: center !important;
      padding: 8rpx 16rpx !important;
      font-size: 32rpx !important;
      transition: all 0.2s;
      font-weight: 500 !important;

      &.cancel-btn {
        color: #6b7280 !important;

        &:active {
          color: #111817 !important;
        }
      }

      &.confirm-btn {
        color: #0adbc3 !important;
        font-weight: 600 !important;

        &:active {
          color: #08bda8 !important;
        }
      }
    }

    .picker-popup-title {
      display: block !important;
      font-size: 36rpx !important;
      text-align: center !important;
      color: #111817 !important;
      flex: 1 !important;
      font-weight: 700 !important;
    }
  }

  .picker-popup-content {
    overflow-y: auto;
    padding: 0;
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
    background: #fff;
  }

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

  :deep(.picker-view-item) {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    font-size: 32rpx;
    color: #9ca3af;
    transition: all 0.3s;
    line-height: 1.5;
    font-weight: 400;
  }

  :deep(.picker-view-item-selected) {
    font-size: 32rpx;
    color: #111817 !important;
    font-weight: 600 !important;
  }
}
</style>
