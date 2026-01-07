<template>
  <view class="transfer-page">
    <u-form ref="formRef" :model="formData" :rules="rules" label-width="160">
      <u-form-item label="调宿日期" prop="transferDate" required>
        <u-input
          v-model="formData.transferDate"
          placeholder="请选择调宿日期"
          readonly
          @click="showDatePicker = true"
        />
      </u-form-item>

      <u-form-item label="目标校区" prop="targetCampusCode">
        <u-input v-model="formData.targetCampusCode" placeholder="请输入目标校区编码" />
      </u-form-item>

      <u-form-item label="目标楼层" prop="targetFloorCode">
        <u-input v-model="formData.targetFloorCode" placeholder="请输入目标楼层编码" />
      </u-form-item>

      <u-form-item label="目标房间" prop="targetRoomId">
        <u-input v-model="formData.targetRoomId" placeholder="请输入目标房间号" type="number" />
      </u-form-item>

      <u-form-item label="目标床位" prop="targetBedId">
        <u-input v-model="formData.targetBedId" placeholder="请输入目标床位号" type="number" />
      </u-form-item>

      <u-form-item label="调宿原因" prop="transferReason" required>
        <u-textarea
          v-model="formData.transferReason"
          placeholder="请输入调宿原因"
          :maxlength="500"
          count
        />
      </u-form-item>
    </u-form>

    <view class="btn-group">
      <u-button type="default" @click="handleSaveDraft">
        保存草稿
      </u-button>
      <u-button type="primary" @click="handleSubmit">
        提交申请
      </u-button>
    </view>

    <u-datetime-picker
      v-model="showDatePicker"
      mode="date"
      @confirm="handleDateConfirm"
      @cancel="showDatePicker = false"
    />
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import type { ITransferSubmitParams } from '@/types';
import { submitTransferAPI } from '@/api';
import { USE_MOCK } from '@/mock';

const formRef = ref();
const showDatePicker = ref(false);

const formData = reactive<ITransferSubmitParams>({
  transferDate: '',
  targetCampusCode: '',
  targetFloorCode: '',
  targetRoomId: undefined,
  targetBedId: undefined,
  transferReason: '',
});

const rules = {
  transferDate: [{ required: true, message: '请选择调宿日期', trigger: 'change' }],
  transferReason: [{ required: true, message: '请输入调宿原因', trigger: 'blur' }],
};

function handleDateConfirm(value: any) {
  const date = new Date(value);
  formData.transferDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  showDatePicker.value = false;
}

function handleSaveDraft() {
  uni.showToast({ title: '草稿已保存', icon: 'success' });
}

async function handleSubmit() {
  try {
    await formRef.value.validate();
    uni.showLoading({ title: '提交中...' });

    if (USE_MOCK) {
      await new Promise(resolve => setTimeout(resolve, 1000));
      uni.hideLoading();
      uni.showToast({ title: '提交成功', icon: 'success' });
      setTimeout(() => uni.navigateBack(), 1500);
    }
    else {
      await submitTransferAPI(formData);
      uni.hideLoading();
      uni.showToast({ title: '提交成功', icon: 'success' });
      setTimeout(() => uni.navigateBack(), 1500);
    }
  }
  catch (error: any) {
    uni.hideLoading();
    console.error('提交失败:', error);
    uni.showToast({ title: error.message || '提交失败', icon: 'none' });
  }
}
</script>

<style lang="scss" scoped>
.transfer-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.btn-group {
  display: flex;
  gap: 20rpx;
  padding: 40rpx 20rpx;

  :deep(.u-button) {
    flex: 1;
  }
}
</style>
