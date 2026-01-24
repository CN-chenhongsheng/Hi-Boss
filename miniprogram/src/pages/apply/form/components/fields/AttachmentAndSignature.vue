<template>
  <view class="attachment-signature-section">
    <!-- 附件上传 -->
    <ImageUpload
      v-model="localImages"
      :label="imageLabel"
      :required="imageRequired"
      :max-count="maxImageCount"
      @update:model-value="handleImagesChange"
    />

    <!-- 本人签名 -->
    <Signature
      v-model="localSignature"
      :label="signatureLabel"
      :required="signatureRequired"
      @update:model-value="handleSignatureChange"
    />
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import ImageUpload from './image-upload.vue';
import Signature from './signature.vue';

interface Props {
  images?: string[];
  signature?: string;
  imageLabel?: string;
  signatureLabel?: string;
  imageRequired?: boolean;
  signatureRequired?: boolean;
  maxImageCount?: number;
}

const props = withDefaults(defineProps<Props>(), {
  images: () => [],
  signature: '',
  imageLabel: '附件上传',
  signatureLabel: '本人签名',
  imageRequired: false,
  signatureRequired: true,
  maxImageCount: 3,
});

const emit = defineEmits<{
  'update:images': [value: string[]];
  'update:signature': [value: string];
}>();

const localImages = ref<string[]>(props.images);
const localSignature = ref(props.signature);

// 监听 props 变化
watch(() => props.images, (newImages) => {
  localImages.value = newImages || [];
}, { deep: true });

watch(() => props.signature, (newSignature) => {
  localSignature.value = newSignature || '';
});

function handleImagesChange(value: string[]) {
  emit('update:images', value);
}

function handleSignatureChange(value: string) {
  emit('update:signature', value);
}
</script>

<style lang="scss" scoped>
.attachment-signature-section {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
}
</style>
