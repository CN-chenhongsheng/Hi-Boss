<template>
  <view class="form-section">
    <!-- 家长姓名 -->
    <view class="input-group">
      <view class="input-icon">
        <u-icon name="account" size="20" color="#0adbc3" />
      </view>
      <view class="input-content">
        <view class="input-label">
          家长姓名
          <text class="required-mark">
            *
          </text>
        </view>
        <input
          :value="formData.parentName"
          class="input-value"
          placeholder="请输入家长姓名"
          @input="handleInput('parentName', $event)"
        >
      </view>
    </view>

    <!-- 家长电话 -->
    <view class="input-group">
      <view class="input-icon">
        <u-icon name="phone" size="20" color="#0adbc3" />
      </view>
      <view class="input-content">
        <view class="input-label">
          家长电话
          <text class="required-mark">
            *
          </text>
        </view>
        <input
          :value="formData.parentPhone"
          class="input-value"
          type="number"
          placeholder="请输入家长电话"
          @input="handleInput('parentPhone', $event)"
        >
      </view>
    </view>

    <!-- 家长是否同意 -->
    <view class="radio-group-wrapper">
      <view class="input-label">
        家长是否同意
        <text class="required-mark">
          *
        </text>
      </view>
      <view class="radio-group-container">
        <u-radio-group
          :value="formData.parentAgree"
          @change="handleRadioChange('parentAgree', $event)"
        >
          <view class="radio-item-wrapper">
            <u-radio
              name="agree"
              label="同意"
              active-color="#0adbc3"
            />
          </view>
          <view class="radio-item-wrapper">
            <u-radio
              name="disagree"
              label="不同意"
              active-color="#0adbc3"
            />
          </view>
        </u-radio-group>
      </view>
    </view>

    <!-- 留宿时间 -->
    <DateRangePicker
      :model-value="dateRange"
      label="留宿时间"
      :required="true"
      @update:model-value="handleDateRangeChange"
    />

    <!-- 申请原因 -->
    <view class="textarea-group">
      <view class="textarea-header">
        <u-icon name="edit-pen" size="18" color="#0adbc3" />
        <view class="textarea-label">
          申请原因
          <text class="required-mark">
            *
          </text>
        </view>
      </view>
      <textarea
        :value="formData.reason"
        class="textarea-input"
        placeholder="请详细描述申请原因..."
        :maxlength="500"
        @input="handleInput('reason', $event)"
      />
    </view>

    <!-- 附件上传 -->
    <ImageUpload
      v-model="images"
      label="附件上传"
      :required="false"
      :max-count="3"
      @update:model-value="handleImagesChange"
    />

    <!-- 本人签名 -->
    <Signature
      v-model="signature"
      label="本人签名"
      :required="true"
      @update:model-value="handleSignatureChange"
    />
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import DateRangePicker from './date-range-picker.vue';
import ImageUpload from './image-upload.vue';
import Signature from './signature.vue';

interface Props {
  formData: {
    parentName?: string;
    parentPhone?: string;
    parentAgree?: string;
    stayStartDate?: string;
    stayEndDate?: string;
    reason?: string;
    images?: string[];
    signature?: string;
  };
}

const props = defineProps<Props>();

const emit = defineEmits<{
  update: [field: string, value: any];
}>();

const dateRange = ref({
  startDate: props.formData.stayStartDate,
  endDate: props.formData.stayEndDate,
});

const images = ref(props.formData.images || []);
const signature = ref(props.formData.signature || '');

// 监听 formData 变化
watch(() => props.formData, (newData) => {
  dateRange.value = {
    startDate: newData.stayStartDate,
    endDate: newData.stayEndDate,
  };
  images.value = newData.images || [];
  signature.value = newData.signature || '';
}, { deep: true });

function handleInput(field: string, event: any) {
  const value = event.detail?.value || '';
  emit('update', field, value);
}

function handleRadioChange(field: string, value: string) {
  emit('update', field, value);
}

function handleDateRangeChange(value: { startDate?: string; endDate?: string }) {
  // 先更新本地 dateRange（确保小程序中立即更新）
  if (value.startDate && value.endDate) {
    dateRange.value = {
      startDate: value.startDate,
      endDate: value.endDate,
    };
  }
  // 然后通知父组件更新
  if (value.startDate) {
    emit('update', 'stayStartDate', value.startDate);
  }
  if (value.endDate) {
    emit('update', 'stayEndDate', value.endDate);
  }
}

function handleImagesChange(value: string[]) {
  emit('update', 'images', value);
}

function handleSignatureChange(value: string) {
  emit('update', 'signature', value);
}
</script>

<style lang="scss" scoped>
.form-section {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
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

      &::placeholder {
        color: #9ca3af;
        font-weight: 400;
      }
    }
  }
}

.radio-group-wrapper {
  padding: 32rpx;
  background: rgb(255 255 255 / 60%);
  border: 1rpx solid rgb(255 255 255);
  border-radius: 32rpx;
  box-shadow: 0 2rpx 6rpx rgb(0 0 0 / 2%);

  .input-label {
    display: block;
    margin-bottom: 24rpx;
    font-size: 20rpx;
    color: #9ca3af;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1rpx;

    .required-mark {
      color: #ff9f43;
    }
  }

  // 单选框容器
  .radio-group-container {
    :deep(.u-radio-group) {
      display: flex;
      flex-direction: row;
    }
  }

  // 单选框项包装器，添加间距
  .radio-item-wrapper {
    margin-right: 48rpx;

    &:last-child {
      margin-right: 0;
    }
  }

  // H5 和小程序通用样式
  :deep(.u-radio-group) {
    display: flex;
    flex-direction: row;
  }

  :deep(.u-radio) {
    margin-right: 0;
  }
}

.textarea-group {
  padding: 32rpx;
  background: rgb(255 255 255 / 60%);
  border: 1rpx solid rgb(255 255 255);
  border-radius: 32rpx;
  box-shadow: 0 2rpx 6rpx rgb(0 0 0 / 2%);

  .textarea-header {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-bottom: 16rpx;

    .textarea-label {
      font-size: 24rpx;
      font-weight: 700;
      color: #6b7280;
      text-transform: uppercase;
      letter-spacing: 1rpx;

      .required-mark {
        color: #ff9f43;
      }
    }
  }

  .textarea-input {
    padding: 24rpx;
    width: 100%;
    min-height: 200rpx;
    font-size: 28rpx;
    color: #111817;
    background: rgb(255 255 255 / 40%);
    border: none;
    border-radius: 24rpx;
    line-height: 1.6;

    &::placeholder {
      color: #9ca3af;
    }
  }
}
</style>
