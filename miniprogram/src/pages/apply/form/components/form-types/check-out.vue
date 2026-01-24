<template>
  <view class="form-section">
    <!-- 申请原因 -->
    <ReasonTextarea
      :model-value="formData.reason"
      placeholder="请详细描述退宿原因..."
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
import { AttachmentAndSignature, ReasonTextarea } from '../fields';

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
</style>
