<template>
  <view class="repair-page">
    <u-form ref="formRef" :model="formData" :rules="rules" label-width="140">
      <u-form-item label="报修类型" prop="repairType" required>
        <u-radio-group v-model="formData.repairType">
          <u-radio :name="1" label="水电" />
          <u-radio :name="2" label="门窗" />
          <u-radio :name="3" label="家具" />
          <u-radio :name="4" label="网络" />
          <u-radio :name="99" label="其他" />
        </u-radio-group>
      </u-form-item>

      <u-form-item label="联系电话" prop="phone">
        <u-input v-model="formData.phone" placeholder="请输入联系电话" type="number" />
      </u-form-item>

      <u-form-item label="问题描述" prop="description" required>
        <u-textarea
          v-model="formData.description"
          placeholder="请详细描述问题"
          :maxlength="500"
          count
        />
      </u-form-item>

      <u-form-item label="故障图片">
        <u-upload
          :file-list="fileList"
          :max-count="3"
          @after-read="handleAfterRead"
          @delete="handleDelete"
        />
      </u-form-item>
    </u-form>

    <view class="btn-group">
      <u-button type="primary" @click="handleSubmit">
        提交报修
      </u-button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import type { IRepairSubmitParams } from '@/types';
import { RepairType } from '@/types';
import { submitRepairAPI, uploadImageAPI } from '@/api';
import { USE_MOCK } from '@/mock';

const formRef = ref();
const fileList = ref<any[]>([]);

const formData = reactive<IRepairSubmitParams>({
  repairType: RepairType.WATER_ELECTRICITY,
  description: '',
  images: [],
  phone: '',
});

const rules = {
  repairType: [{ required: true, message: '请选择报修类型', trigger: 'change' }],
  description: [{ required: true, message: '请输入问题描述', trigger: 'blur' }],
};

async function handleAfterRead(event: any) {
  const { file } = event;
  file.status = 'uploading';
  file.message = '上传中...';

  try {
    if (USE_MOCK) {
      await new Promise(resolve => setTimeout(resolve, 1000));
      file.status = 'success';
      file.message = '';
      file.url = 'https://via.placeholder.com/300';
      formData.images?.push(file.url);
    }
    else {
      const url = await uploadImageAPI(file.url);
      file.status = 'success';
      file.message = '';
      file.url = url;
      formData.images?.push(url);
    }
  }
  catch (error) {
    file.status = 'failed';
    file.message = '上传失败';
  }
}

function handleDelete(event: any) {
  const { index } = event;
  formData.images?.splice(index, 1);
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
      await submitRepairAPI(formData);
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
.repair-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.btn-group {
  padding: 40rpx 20rpx;

  :deep(.u-button) {
    width: 100%;
  }
}
</style>
