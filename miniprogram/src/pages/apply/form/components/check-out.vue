<template>
  <view class="form-section">
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
        placeholder="请详细描述退宿原因..."
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
import ImageUpload from './image-upload.vue';
import Signature from './signature.vue';

interface Props {
  formData: {
    reason?: string;
    images?: string[];
    signature?: string;
  };
}

const props = defineProps<Props>();

const emit = defineEmits<{
  update: [field: string, value: any];
}>();

const images = ref(props.formData.images || []);
const signature = ref(props.formData.signature || '');

// 监听 formData 变化
watch(() => props.formData, (newData) => {
  images.value = newData.images || [];
  signature.value = newData.signature || '';
}, { deep: true });

function handleInput(field: string, event: any) {
  const value = event.detail?.value || '';
  emit('update', field, value);
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
