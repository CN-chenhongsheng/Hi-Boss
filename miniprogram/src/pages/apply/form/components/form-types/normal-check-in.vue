<template>
  <view class="form-section">
    <ReasonTextarea
      :model-value="formData.reason"
      placeholder="请详细描述申请原因..."
      @update:model-value="(val) => emit('update', 'reason', val)"
    />
  </view>
</template>

<script setup lang="ts">
import { ReasonTextarea } from '../fields';

interface Props {
  formData: {
    reason?: string;
  };
}

defineProps<Props>();

const emit = defineEmits<{
  update: [field: string, value: any];
}>();
</script>

<style lang="scss" scoped>
.form-section {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
}
</style>
