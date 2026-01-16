<template>
  <view class="form-section">
    <!-- 联系电话 -->
    <view class="input-group">
      <view class="input-icon">
        <u-icon name="phone" size="20" color="#0adbc3" />
      </view>
      <view class="input-content">
        <view class="input-label">
          联系电话
          <text class="required-mark">
            *
          </text>
        </view>
        <input
          :value="formData.phone"
          class="input-value"
          type="number"
          placeholder="请输入联系电话"
          @input="handleInput('phone', $event)"
        >
      </view>
    </view>

    <!-- 问题描述 -->
    <view class="textarea-group">
      <view class="textarea-header">
        <u-icon name="edit-pen" size="18" color="#0adbc3" />
        <view class="textarea-label">
          问题描述
          <text class="required-mark">
            *
          </text>
        </view>
      </view>
      <textarea
        :value="formData.description"
        class="textarea-input"
        placeholder="请详细描述故障问题..."
        :maxlength="500"
        @input="handleInput('description', $event)"
      />
    </view>

    <!-- 故障图片 -->
    <ImageUpload
      v-model="images"
      label="故障图片"
      :required="false"
      :max-count="3"
      tip="建议上传故障现场照片，最多3张"
      @update:model-value="handleImagesChange"
    />
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import ImageUpload from './image-upload.vue';

interface Props {
  formData: {
    phone?: string;
    description?: string;
    images?: string[];
  };
}

const props = defineProps<Props>();

const emit = defineEmits<{
  update: [field: string, value: any];
}>();

const images = ref(props.formData.images || []);

// 监听 formData 变化
watch(() => props.formData, (newData) => {
  images.value = newData.images || [];
}, { deep: true, immediate: true });

function handleInput(field: string, event: any) {
  const value = event.detail?.value || '';
  emit('update', field, value);
}

function handleImagesChange(value: string[]) {
  emit('update', 'images', value);
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
