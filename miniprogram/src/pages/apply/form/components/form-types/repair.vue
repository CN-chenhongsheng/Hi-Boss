<template>
  <view class="form-section">
    <!-- 联系电话 -->
    <TextInput
      :model-value="formData.phone"
      label="联系电话"
      placeholder="请输入联系电话"
      icon="phone"
      type="number"
      @update:model-value="(val) => emit('update', 'phone', val)"
    />

    <!-- 问题描述 -->
    <ReasonTextarea
      :model-value="formData.description"
      label="问题描述"
      placeholder="请详细描述故障问题..."
      @update:model-value="(val) => emit('update', 'description', val)"
    />

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
import { ImageUpload, ReasonTextarea, TextInput } from '../fields';

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
</style>
