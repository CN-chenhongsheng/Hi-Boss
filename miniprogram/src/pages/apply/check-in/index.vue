<template>
  <view class="check-in-page">
    <u-form ref="formRef" :model="formData" :rules="rules" label-width="160">
      <u-form-item label="入住类型" prop="checkInType" required>
        <u-radio-group v-model="formData.checkInType">
          <u-radio :name="1" label="长期住宿" />
          <u-radio :name="2" label="临时住宿" />
        </u-radio-group>
      </u-form-item>

      <u-form-item label="入住日期" prop="checkInDate" required>
        <u-input
          v-model="formData.checkInDate"
          placeholder="请选择入住日期"
          readonly
          @click="showDatePicker = true"
        />
      </u-form-item>

      <u-form-item
        v-if="formData.checkInType === 2"
        label="预计退宿日期"
        prop="expectedCheckOutDate"
        required
      >
        <u-input
          v-model="formData.expectedCheckOutDate"
          placeholder="请选择预计退宿日期"
          readonly
          @click="showExpectedDatePicker = true"
        />
      </u-form-item>

      <u-form-item label="意向校区" prop="campusCode">
        <u-input v-model="formData.campusCode" placeholder="请输入校区编码" />
      </u-form-item>

      <u-form-item label="意向楼层" prop="floorCode">
        <u-input v-model="formData.floorCode" placeholder="请输入楼层编码" />
      </u-form-item>

      <u-form-item label="意向房间" prop="roomId">
        <u-input v-model="formData.roomId" placeholder="请输入房间号" type="number" />
      </u-form-item>

      <u-form-item label="意向床位" prop="bedId">
        <u-input v-model="formData.bedId" placeholder="请输入床位号" type="number" />
      </u-form-item>

      <u-form-item label="申请原因" prop="applyReason">
        <u-textarea
          v-model="formData.applyReason"
          placeholder="请输入申请原因"
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

    <!-- 日期选择器 -->
    <u-datetime-picker
      v-model="showDatePicker"
      mode="date"
      @confirm="handleDateConfirm"
      @cancel="showDatePicker = false"
    />

    <u-datetime-picker
      v-model="showExpectedDatePicker"
      mode="date"
      @confirm="handleExpectedDateConfirm"
      @cancel="showExpectedDatePicker = false"
    />
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import type { ICheckInSubmitParams } from '@/types';
import { submitCheckInAPI } from '@/api';
import { USE_MOCK } from '@/mock';

const formRef = ref();
const showDatePicker = ref(false);
const showExpectedDatePicker = ref(false);

const formData = reactive<ICheckInSubmitParams>({
  checkInType: 1,
  checkInDate: '',
  expectedCheckOutDate: '',
  campusCode: '',
  floorCode: '',
  roomId: undefined,
  bedId: undefined,
  applyReason: '',
});

const rules = {
  checkInType: [{ required: true, message: '请选择入住类型', trigger: 'change' }],
  checkInDate: [{ required: true, message: '请选择入住日期', trigger: 'change' }],
  expectedCheckOutDate: [
    {
      required: true,
      message: '请选择预计退宿日期',
      trigger: 'change',
      validator: (_rule: any, value: string) => {
        if (formData.checkInType === 2 && !value) {
          return false;
        }
        return true;
      },
    },
  ],
};

// 日期确认
function handleDateConfirm(value: any) {
  const date = new Date(value);
  formData.checkInDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  showDatePicker.value = false;
}

function handleExpectedDateConfirm(value: any) {
  const date = new Date(value);
  formData.expectedCheckOutDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  showExpectedDatePicker.value = false;
}

// 保存草稿
function handleSaveDraft() {
  uni.showToast({
    title: '草稿已保存',
    icon: 'success',
  });
}

// 提交申请
async function handleSubmit() {
  try {
    await formRef.value.validate();

    uni.showLoading({ title: '提交中...' });

    if (USE_MOCK) {
      // Mock模式
      await new Promise(resolve => setTimeout(resolve, 1000));
      uni.hideLoading();
      uni.showToast({
        title: '提交成功',
        icon: 'success',
      });
      setTimeout(() => {
        uni.navigateBack();
      }, 1500);
    }
    else {
      // 真实API
      await submitCheckInAPI(formData);
      uni.hideLoading();
      uni.showToast({
        title: '提交成功',
        icon: 'success',
      });
      setTimeout(() => {
        uni.navigateBack();
      }, 1500);
    }
  }
  catch (error: any) {
    uni.hideLoading();
    console.error('提交失败:', error);
    uni.showToast({
      title: error.message || '提交失败',
      icon: 'none',
    });
  }
}
</script>

<style lang="scss" scoped>
.check-in-page {
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
