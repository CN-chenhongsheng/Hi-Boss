<template>
  <view
    v-if="show"
    class="picker-overlay"
    @click="close"
  />
  <view
    v-if="show"
    class="signature-modal"
  >
    <view class="signature-modal-header">
      <view class="modal-title">
        手写签名
      </view>
      <view class="modal-close" @click="close">
        <u-icon name="close" size="24" color="#6b7280" />
      </view>
    </view>

    <view class="signature-canvas-container">
      <!-- #ifdef MP-WEIXIN -->
      <canvas
        id="signatureCanvas"
        type="2d"
        class="signature-canvas"
        :style="{ width: `${canvasConfig.canvasWidth}rpx`, height: `${canvasConfig.canvasHeight}rpx` }"
        @touchstart="onTouchStart"
        @touchmove="onTouchMove"
        @touchend="handleTouchEnd"
      />
      <!-- #endif -->

      <!-- #ifdef H5 -->
      <canvas
        id="signatureCanvas"
        class="signature-canvas"
        :width="canvasConfig.canvasWidth"
        :height="canvasConfig.canvasHeight"
        @touchstart="onTouchStart"
        @touchmove="onTouchMove"
        @touchend="handleTouchEnd"
      />
      <!-- #endif -->
    </view>

    <view class="signature-modal-actions">
      <view class="action-btn clear-btn" @click="handleClear">
        清除
      </view>
      <view class="action-btn confirm-btn" @click="handleConfirm">
        确认
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { nextTick, onMounted, reactive, ref } from 'vue';
import { useSignatureCanvas } from '@/composables/useSignatureCanvas';

const show = ref(false);
const currentValue = ref('');
const onConfirm = ref<((value: string) => void) | null>(null);

const canvasConfig = reactive({
  canvasWidth: 600,
  canvasHeight: 400,
});

const {
  initSignatureCanvas,
  handleTouchStart,
  handleTouchMove,
  handleTouchEnd,
  clearSignature,
  exportSignature,
} = useSignatureCanvas(canvasConfig);

function onTouchStart(event: any) {
  handleTouchStart(event as TouchEvent);
}

function onTouchMove(event: any) {
  handleTouchMove(event as TouchEvent);
}

onMounted(() => {
  const systemInfo = uni.getSystemInfoSync();
  const screenWidth = systemInfo.windowWidth;
  const displayWidthRpx = Math.floor((screenWidth - 80) * 2);
  const displayHeightRpx = Math.floor(displayWidthRpx * 0.5);
  canvasConfig.canvasWidth = displayWidthRpx;
  canvasConfig.canvasHeight = displayHeightRpx;
});

function open(value: string, onConfirmCallback: (value: string) => void) {
  currentValue.value = value;
  onConfirm.value = onConfirmCallback;
  show.value = true;
  nextTick(() => initSignatureCanvas());
}

function close() {
  show.value = false;
}

function handleClear() {
  clearSignature();
}

async function handleConfirm() {
  try {
    const signatureValue = await exportSignature();
    if (onConfirm.value) {
      onConfirm.value(signatureValue);
    }
    close();
  }
  catch (error) {
    console.error('导出签名失败:', error);
    uni.showToast({ title: '导出签名失败', icon: 'none' });
  }
}

defineExpose({
  open,
});
</script>

<style lang="scss" scoped>
.signature-modal {
  position: fixed !important;
  top: 50% !important;
  left: 50% !important;
  z-index: 99999 !important;
  display: flex;
  overflow: hidden;
  width: 680rpx;
  max-height: 90vh;
  background: #fff;
  border-radius: 32rpx;
  transform: translate(-50%, -50%) !important;
  flex-direction: column;
  animation: scaleIn 0.3s;
}

@keyframes scaleIn {
  from {
    opacity: 0;
    transform: translate(-50%, -50%) scale(0.9);
  }

  to {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
  }
}

.signature-modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 32rpx 40rpx;
  border-bottom: 1rpx solid rgb(229 231 235 / 50%);

  .modal-title {
    font-size: 32rpx;
    font-weight: 700;
    color: #111817;
  }

  .modal-close {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 64rpx;
    height: 64rpx;
    color: #6b7280;
    border-radius: 50%;
    transition: all 0.2s;

    &:active {
      background: rgb(0 0 0 / 5%);
    }
  }
}

.signature-canvas-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40rpx;
  background: #f9fafb;
}

.signature-canvas {
  background: #fff;
  border: 1rpx solid #e5e7eb;
  border-radius: 16rpx;
  touch-action: none;
}

.signature-modal-actions {
  display: flex;
  gap: 24rpx;
  padding: 32rpx 40rpx;
  border-top: 1rpx solid rgb(229 231 235 / 50%);

  .action-btn {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 88rpx;
    font-size: 28rpx;
    border-radius: 16rpx;
    flex: 1;
    font-weight: 600;

    &.clear-btn {
      color: #6b7280;
      background: #e5e7eb;
    }

    &.confirm-btn {
      color: #fff;
      background: linear-gradient(to right, #0adbc3, #08bda8);
    }
  }
}
</style>
