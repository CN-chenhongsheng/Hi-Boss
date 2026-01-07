<template>
  <view class="stay-page">
    <u-form ref="formRef" :model="formData" :rules="rules" label-width="160">
      <u-form-item label="留宿开始日期" prop="stayStartDate" required>
        <u-input
          v-model="formData.stayStartDate"
          placeholder="请选择留宿开始日期"
          readonly
          @click="showStartDatePicker = true"
        />
      </u-form-item>

      <u-form-item label="留宿结束日期" prop="stayEndDate" required>
        <u-input
          v-model="formData.stayEndDate"
          placeholder="请选择留宿结束日期"
          readonly
          @click="showEndDatePicker = true"
        />
      </u-form-item>

      <u-form-item label="留宿理由" prop="stayReason" required>
        <u-textarea
          v-model="formData.stayReason"
          placeholder="请输入留宿理由"
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
      v-model="showStartDatePicker"
      mode="date"
      @confirm="handleStartDateConfirm"
      @cancel="showStartDatePicker = false"
    />

    <u-datetime-picker
      v-model="showEndDatePicker"
      mode="date"
      @confirm="handleEndDateConfirm"
      @cancel="showEndDatePicker = false"
    />
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import type { IStaySubmitParams } from '@/types';
import { submitStayAPI } from '@/api';
import { USE_MOCK } from '@/mock';

const formRef = ref();
const showStartDatePicker = ref(false);
const showEndDatePicker = ref(false);

const formData = reactive<IStaySubmitParams>({
  stayStartDate: '',
  stayEndDate: '',
  stayReason: '',
});

const rules = {
  stayStartDate: [{ required: true, message: '请选择留宿开始日期', trigger: 'change' }],
  stayEndDate: [{ required: true, message: '请选择留宿结束日期', trigger: 'change' }],
  stayReason: [{ required: true, message: '请输入留宿理由', trigger: 'blur' }],
};

function handleStartDateConfirm(value: any) {
  const date = new Date(value);
  formData.stayStartDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  showStartDatePicker.value = false;
}

function handleEndDateConfirm(value: any) {
  const date = new Date(value);
  formData.stayEndDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  showEndDatePicker.value = false;
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
      await submitStayAPI(formData);
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
.stay-page {
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
