<template>
  <view class="form-section">
    <!-- 家长姓名 -->
    <TextInput
      :model-value="formData.parentName"
      label="家长姓名"
      placeholder="请输入家长姓名"
      icon="account"
      @update:model-value="(val) => emit('update', 'parentName', val)"
    />

    <!-- 家长电话 -->
    <TextInput
      :model-value="formData.parentPhone"
      label="家长电话"
      placeholder="请输入家长电话"
      icon="phone"
      type="number"
      @update:model-value="(val) => emit('update', 'parentPhone', val)"
    />

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

    <!-- 日期时间 -->
    <DateRangePicker
      :model-value="dateRange"
      :label="dateLabel"
      :required="true"
      @update:model-value="handleDateRangeChange"
    />

    <!-- 申请原因 -->
    <ReasonTextarea
      :model-value="formData.reason"
      :placeholder="reasonPlaceholder"
      @update:model-value="(val) => emit('update', 'reason', val)"
    />

    <!-- 附件上传 + 签名 -->
    <AttachmentAndSignature
      :images="images"
      :signature="signature"
      @update:images="handleImagesChange"
      @update:signature="handleSignatureChange"
    />
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { DateRangePickerField as DateRangePicker } from '../pickers';
import { AttachmentAndSignature, ReasonTextarea, TextInput } from '../fields';

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
  dateLabel?: string;
  reasonPlaceholder?: string;
}

const props = withDefaults(defineProps<Props>(), {
  dateLabel: '留宿时间',
  reasonPlaceholder: '请详细描述申请原因...',
});

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
</style>
