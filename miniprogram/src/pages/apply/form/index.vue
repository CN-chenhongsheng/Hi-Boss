<template>
  <view class="page-root-wrapper">
    <!-- 申请类型选择弹窗 - 最外层 -->
    <view
      v-if="showApplyTypePicker"
      class="picker-overlay"
      @click="showApplyTypePicker = false"
    />
    <view
      v-if="showApplyTypePicker"
      class="custom-picker-popup"
    >
      <view class="picker-popup-header">
        <view class="cancel-btn picker-popup-btn" @click="showApplyTypePicker = false">
          取消
        </view>
        <view class="picker-popup-title">
          申请类型
        </view>
        <view class="picker-popup-btn confirm-btn" @click="confirmApplyType">
          完成
        </view>
      </view>
      <view class="picker-popup-content">
        <view
          v-for="(option, index) in filteredApplyTypeOptions"
          :key="index"
          class="picker-popup-item"
          :class="{ active: tempApplyTypeIndex === index }"
          @click="handleSelectApplyType(index)"
        >
          <view class="picker-item-icon">
            <u-icon
              v-if="tempApplyTypeIndex === index"
              name="checkmark"
              size="20"
              color="#0adbc3"
            />
          </view>
          <view class="picker-item-text">
            {{ option.label }}
          </view>
        </view>
      </view>
    </view>

    <DateRangePicker ref="dateRangePickerRef" />

    <!-- 报修类型选择弹窗 - 最外层 -->
    <view
      v-if="showRepairTypePicker"
      class="picker-overlay"
      @click="closeRepairTypePicker"
    />
    <view
      v-if="showRepairTypePicker"
      class="custom-picker-popup"
    >
      <view class="picker-popup-header">
        <view class="cancel-btn picker-popup-btn" @click="closeRepairTypePicker">
          取消
        </view>
        <view class="picker-popup-title">
          报修类型
        </view>
        <view class="picker-popup-btn confirm-btn" @click="confirmRepairType">
          完成
        </view>
      </view>
      <view class="picker-popup-content">
        <view
          v-for="(option, index) in repairTypeOptions"
          :key="index"
          class="picker-popup-item"
          :class="{ active: tempRepairTypeIndex === index }"
          @click="handleSelectRepairType(index)"
        >
          <view class="picker-item-icon">
            <u-icon
              v-if="tempRepairTypeIndex === index"
              name="checkmark"
              size="20"
              color="#0adbc3"
            />
          </view>
          <view class="picker-item-text">
            {{ option.label }}
          </view>
        </view>
      </view>
    </view>

    <SignaturePicker ref="signaturePickerRef" />

    <view class="apply-form-page">
      <!-- 背景装饰 -->
      <view class="bg-decorations">
        <view class="blob blob-1" />
        <view class="blob blob-2" />
        <view class="blob blob-3" />
      </view>

      <view class="page-container">
        <!-- 顶部导航栏 -->
        <header class="top-header">
          <view class="header-back" @click="handleBack">
            <u-icon name="arrow-left" size="22" color="#111817" />
          </view>
          <view class="header-title">
            业务填报
          </view>
          <view class="header-placeholder" />
        </header>

        <!-- 主内容 -->
        <scroll-view class="content-scroll" scroll-y>
          <main class="main-content">
            <!-- 标题区域 -->
            <view class="title-section">
              <view class="title-row">
                <view class="title-text">
                  申请信息填写
                </view>
                <view class="status-badge">
                  进行中
                </view>
              </view>
              <view class="title-desc">
                请如实填写以下信息，带
                <text class="required-mark">
                  *
                </text>
                为必填项。
                <br>
                提交后将由宿管员进行审核。
              </view>
            </view>

            <!-- 基础信息卡片 -->
            <view class="glass-card section-card">
              <view class="section-header">
                <view class="section-title-wrapper">
                  <view class="section-indicator section-indicator-primary" />
                  <view class="section-title">
                    基础信息
                  </view>
                </view>
                <view class="readonly-badge">
                  <u-icon name="lock" size="12" color="#6b7280" />
                  <text>只读</text>
                </view>
              </view>

              <view class="user-info-card">
                <view class="user-icon-wrapper">
                  <u-icon name="account" size="26" color="#fff" />
                </view>
                <view class="user-info-grid">
                  <view class="user-info-item">
                    <view class="info-label">
                      姓名
                    </view>
                    <view class="info-value">
                      {{ userInfo?.studentInfo?.studentName || userInfo?.nickname || '--' }}
                    </view>
                  </view>
                  <view class="user-info-item user-info-item-border">
                    <view class="info-label">
                      学号
                    </view>
                    <view class="info-value">
                      {{ userInfo?.studentInfo?.studentNo || '--' }}
                    </view>
                  </view>
                </view>
                <view class="user-info-decoration" />
              </view>
            </view>

            <!-- 业务详情卡片 -->
            <view class="glass-card section-card">
              <view class="section-header">
                <view class="section-title-wrapper">
                  <view class="section-indicator section-indicator-accent" />
                  <view class="section-title">
                    业务详情
                  </view>
                </view>
              </view>

              <!-- 申请类型（type 直达时隐藏，无二次选择） -->
              <ApplyTypePicker
                v-if="!hideTypePicker"
                v-model="formData.applyType"
                :options="filteredApplyTypeOptions"
                :can-modify="canModifyApplyType"
              />

              <!-- 动态表单组件 -->
              <NormalCheckIn
                v-if="formData.applyType === 'normalCheckIn'"
                :form-data="getFormDataForComponent()"
                @update="handleFormUpdate"
              />
              <TempCheckIn
                v-else-if="formData.applyType === 'tempCheckIn'"
                :form-data="getFormDataForComponent()"
                @update="handleFormUpdate"
              />
              <Transfer
                v-else-if="formData.applyType === 'transfer'"
                :form-data="getFormDataForComponent()"
                @update="handleFormUpdate"
              />
              <CheckOut
                v-else-if="formData.applyType === 'checkOut'"
                :form-data="getFormDataForComponent()"
                @update="handleFormUpdate"
              />
              <Stay
                v-else-if="formData.applyType === 'stay'"
                :form-data="getFormDataForComponent()"
                @update="handleFormUpdate"
              />
              <template v-else-if="formData.applyType === 'repair'">
                <RepairTypePicker
                  v-model="formData.repairType"
                  :options="repairTypeOptions"
                />
                <Repair
                  :form-data="getFormDataForComponent()"
                  @update="handleFormUpdate"
                />
              </template>
            </view>
          </main>
        </scroll-view>

        <!-- 底部操作栏 -->
        <view class="bottom-actions">
          <view class="action-btn submit-btn" @click="handleSubmit">
            <text>提交申请</text>
            <u-icon name="arrow-right" size="18" color="#fff" />
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, provide, reactive, ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import NormalCheckIn from './components/normal-check-in.vue';
import TempCheckIn from './components/temp-check-in.vue';
import Transfer from './components/transfer.vue';
import CheckOut from './components/check-out.vue';
import Stay from './components/stay.vue';
import Repair from './components/repair.vue';
import ApplyTypePicker from './components/apply-type-picker.vue';
import RepairTypePicker from './components/repair-type-picker.vue';
import DateRangePicker from './components/pickers/DateRangePicker.vue';
import SignaturePicker from './components/pickers/SignaturePicker.vue';
import type { IApplyFormData } from '@/types';
import useUserStore from '@/store/modules/user';
import { useFormValidation } from '@/composables/useFormValidation';
import { submitCheckInAPI } from '@/api/accommodation/check-in';
import { submitTransferAPI } from '@/api/accommodation/transfer';
import { submitCheckOutAPI } from '@/api/accommodation/check-out';
import { submitStayAPI } from '@/api/accommodation/stay';

// 类型定义
type ApplyType = 'normalCheckIn' | 'tempCheckIn' | 'transfer' | 'checkOut' | 'stay' | 'repair';

interface ApplyTypeOption {
  label: string;
  value: ApplyType;
}

interface DateRange {
  startDate?: string;
  endDate?: string;
}

interface RepairTypeOption {
  label: string;
  value: number;
}

const userStore = useUserStore();
const { validateForm } = useFormValidation();

// 申请类型选项
const applyTypeOptions: ApplyTypeOption[] = [
  { label: '正常入住', value: 'normalCheckIn' },
  { label: '临时入住', value: 'tempCheckIn' },
  { label: '调宿申请', value: 'transfer' },
  { label: '退宿申请', value: 'checkOut' },
  { label: '留宿申请', value: 'stay' },
  { label: '故障报修', value: 'repair' },
];

// 表单数据
const formData = reactive<IApplyFormData>({
  applyType: '',
  // 通用字段
  reason: '',
  images: [] as string[],
  signature: '',
  // 临时入住/留宿申请字段
  parentName: '',
  parentPhone: '',
  parentAgree: '',
  stayStartDate: '',
  stayEndDate: '',
  // 报修申请字段
  repairType: undefined,
  phone: '',
  description: '',
});

const applyTypeIndex = ref(0);
// 临时选中的索引（用于弹窗中的选择）
const tempApplyTypeIndex = ref(0);
// 是否通过 type 参数直达（无二次选择，隐藏类型选择器）
const hideTypePicker = ref(false);

// 是否允许修改申请类型（只有入住申请可以修改）
const canModifyApplyType = computed(() => {
  // 如果没有设置申请类型，允许选择
  if (!formData.applyType) {
    return true;
  }
  // 如果是入住申请（正常入住或临时入住），允许修改
  return formData.applyType === 'normalCheckIn' || formData.applyType === 'tempCheckIn';
});

// 过滤后的申请类型选项（如果当前是入住申请，只显示正常入住和临时入住）
const filteredApplyTypeOptions = computed(() => {
  // 如果当前申请类型是入住申请（正常入住或临时入住），只显示这两个选项
  if (formData.applyType === 'normalCheckIn' || formData.applyType === 'tempCheckIn') {
    return applyTypeOptions.filter(opt => opt.value === 'normalCheckIn' || opt.value === 'tempCheckIn');
  }
  // 否则显示所有选项（但会被禁用）
  return applyTypeOptions;
});

// 过滤后的选中索引
const filteredApplyTypeIndex = computed(() => {
  const currentValue = formData.applyType;
  return filteredApplyTypeOptions.value.findIndex(opt => opt.value === currentValue);
});

// 弹窗控制
const showApplyTypePicker = ref(false);

// 报修类型选择器
const repairTypeOptions: RepairTypeOption[] = [
  { label: '水电', value: 1 },
  { label: '门窗', value: 2 },
  { label: '家具', value: 3 },
  { label: '网络', value: 4 },
  { label: '其他', value: 99 },
];
const showRepairTypePicker = ref(false);
const tempRepairTypeIndex = ref(-1);

const dateRangePickerRef = ref<InstanceType<typeof DateRangePicker> | null>(null);
const signaturePickerRef = ref<InstanceType<typeof SignaturePicker> | null>(null);

// 用户信息
const userInfo = computed(() => userStore.userInfo);

// 返回
function handleBack(): void {
  uni.navigateBack();
}

// 打开申请类型选择器
function openApplyTypePicker(): void {
  if (!canModifyApplyType.value) {
    return;
  }
  // 初始化临时选中索引为当前选中索引
  tempApplyTypeIndex.value = filteredApplyTypeIndex.value >= 0 ? filteredApplyTypeIndex.value : 0;
  showApplyTypePicker.value = true;
}

// 选择申请类型（在弹窗中）
function handleSelectApplyType(index: number): void {
  if (!canModifyApplyType.value) {
    return;
  }
  tempApplyTypeIndex.value = index;
}

// 确认申请类型
function confirmApplyType(): void {
  if (!canModifyApplyType.value) {
    showApplyTypePicker.value = false;
    return;
  }
  const oldType = formData.applyType;
  const selectedOption = filteredApplyTypeOptions.value[tempApplyTypeIndex.value];
  if (selectedOption) {
    formData.applyType = selectedOption.value;
    const originalIndex = applyTypeOptions.findIndex(opt => opt.value === selectedOption.value);
    if (originalIndex >= 0) {
      applyTypeIndex.value = originalIndex;
    }
  }

  // 如果切换了申请类型，清空表单数据
  if (oldType && oldType !== formData.applyType) {
    Object.keys(formData).forEach((key) => {
      if (key !== 'applyType') {
        const formKey = key as keyof IApplyFormData;
        if (Array.isArray(formData[formKey])) {
          (formData[formKey] as string[]) = [];
        }
        else {
          (formData[formKey] as string) = '';
        }
      }
    });
  }

  showApplyTypePicker.value = false;
}

// 获取组件所需的表单数据
function getFormDataForComponent(): IApplyFormData {
  return { ...formData };
}

// 处理表单更新
function handleFormUpdate(field: string, value: any): void {
  // 类型安全的字段更新
  if (field in formData) {
    (formData as any)[field] = value;
  }
}

function openDateRangePicker(currentValue: DateRange, onConfirm: (value: DateRange) => void): void {
  dateRangePickerRef.value?.open(currentValue, onConfirm);
}

function openSignaturePicker(currentValue: string, onConfirm: (value: string) => void): void {
  signaturePickerRef.value?.open(currentValue, onConfirm);
}

// 打开报修类型选择器
function openRepairTypePicker(): void {
  // 初始化临时选中索引为当前选中索引
  if (formData.repairType) {
    const index = repairTypeOptions.findIndex(opt => opt.value === formData.repairType);
    tempRepairTypeIndex.value = index >= 0 ? index : -1;
  }
  else {
    tempRepairTypeIndex.value = -1;
  }
  showRepairTypePicker.value = true;
}

// 选择报修类型（在弹窗中）
function handleSelectRepairType(index: number): void {
  tempRepairTypeIndex.value = index;
}

// 确认报修类型
function confirmRepairType(): void {
  if (tempRepairTypeIndex.value >= 0 && tempRepairTypeIndex.value < repairTypeOptions.length) {
    const selectedOption = repairTypeOptions[tempRepairTypeIndex.value];
    formData.repairType = selectedOption.value;
  }
  closeRepairTypePicker();
}

// 关闭报修类型选择器
function closeRepairTypePicker(): void {
  showRepairTypePicker.value = false;
}

// Provide 给子组件使用
provide('openDateRangePicker', openDateRangePicker);
provide('openSignaturePicker', openSignaturePicker);
provide('openApplyTypePicker', openApplyTypePicker);
provide('openRepairTypePicker', openRepairTypePicker);

// 页面加载时接收参数
onLoad((options: any) => {
  // 根据传入的 type 参数设置默认申请类型，支持 form?type=checkIn|checkOut|stay|transfer 直达
  if (options.type) {
    const typeMap: Record<string, string> = {
      checkIn: 'normalCheckIn', // 入住申请默认正常入住
      transfer: 'transfer',
      checkOut: 'checkOut',
      stay: 'stay',
      repair: 'repair',
    };
    const defaultType = typeMap[options.type];
    if (defaultType) {
      const typeIndex = applyTypeOptions.findIndex(opt => opt.value === defaultType);
      if (typeIndex >= 0) {
        applyTypeIndex.value = typeIndex;
        formData.applyType = defaultType;
        hideTypePicker.value = true;
      }
    }
  }
});

// 提交
async function handleSubmit() {
  if (!validateForm(formData)) {
    return;
  }

  uni.showLoading({
    title: '提交中...',
  });

  try {
    const applyType = formData.applyType;

    if (applyType === 'normalCheckIn' || applyType === 'tempCheckIn') {
      // 入住申请
      await submitCheckInAPI({
        checkInType: applyType === 'normalCheckIn' ? 1 : 2,
        checkInDate: formData.stayStartDate || new Date().toISOString().slice(0, 10),
        expectedCheckOutDate: applyType === 'tempCheckIn' ? formData.stayEndDate : undefined,
        applyReason: formData.reason,
      });
    }
    else if (applyType === 'transfer') {
      // 调宿申请
      await submitTransferAPI({
        transferDate: new Date().toISOString().slice(0, 10),
        transferReason: formData.reason,
      });
    }
    else if (applyType === 'checkOut') {
      // 退宿申请
      await submitCheckOutAPI({
        checkOutReason: formData.reason,
        checkOutDate: formData.stayStartDate || new Date().toISOString().slice(0, 10),
      });
    }
    else if (applyType === 'stay') {
      // 留宿申请
      await submitStayAPI({
        stayStartDate: formData.stayStartDate || '',
        stayEndDate: formData.stayEndDate || '',
        stayReason: formData.reason,
      });
    }
    else if (applyType === 'repair') {
      // 报修申请 - 暂时提示
      uni.hideLoading();
      uni.showToast({
        title: '报修功能开发中',
        icon: 'none',
      });
      return;
    }

    uni.hideLoading();
    uni.showToast({
      title: '提交成功',
      icon: 'success',
    });
    setTimeout(() => {
      uni.navigateBack();
    }, 1500);
  }
  catch (error: any) {
    uni.hideLoading();
    uni.showToast({
      title: error?.message || '提交失败',
      icon: 'none',
    });
  }
}
</script>

<style lang="scss" scoped>
// 主题变量
$primary: #0adbc3;
$primary-dark: #08bda8;
$primary-light: #e0fbf8;
$accent: #ff9f43;
$bg-light: #f5f8f8;
$text-main: #111817;
$text-sub: #6b7280;
$glass-bg: rgb(255 255 255 / 65%);
$glass-border: rgb(255 255 255 / 80%);

.page-root-wrapper {
  position: relative;
  width: 100%;
  min-height: 100vh;
}

.apply-form-page {
  overflow-x: hidden;
  min-height: 100vh;
  background: linear-gradient(135deg, #f0fdfa 0%, #ecfccb 100%);
  background-attachment: fixed;
}

// 背景装饰
.bg-decorations {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;

  .blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(80rpx);

    &.blob-1 {
      top: -200rpx;
      right: -100rpx;
      width: 600rpx;
      height: 600rpx;
      background: rgb(10 219 195 / 15%);
    }

    &.blob-2 {
      top: 40%;
      left: -200rpx;
      width: 500rpx;
      height: 500rpx;
      background: rgb(234 179 8 / 20%);
    }

    &.blob-3 {
      bottom: -100rpx;
      left: 40%;
      width: 700rpx;
      height: 700rpx;
      background: rgb(96 165 250 / 20%);
    }
  }
}

.page-container {
  position: relative;
  z-index: 1;
  display: flex;
  margin: 0 auto;
  flex-direction: column;
}

// 内容滚动区域
.content-scroll {
  position: relative;
  z-index: 10;
  height: calc(100vh - var(--status-bar-height) - 84rpx - 160rpx);
}

// 顶部导航栏
.top-header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: calc(var(--status-bar-height) + 45rpx) 32rpx 25rpx;

  .header-back {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;

    &:active {
      background: rgb(0 0 0 / 5%);
    }
  }

  .header-title {
    font-size: 36rpx;
    text-align: center;
    color: $text-main;
    flex: 1;
    font-weight: 700;
    letter-spacing: 0.5rpx;
  }

  .header-placeholder {
    width: 80rpx;
  }
}

// 主内容
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 40rpx;
  padding: 40rpx 32rpx;
  padding-top: 0;
  padding-bottom: calc(70rpx + env(safe-area-inset-bottom));
}

// 标题区域
.title-section {
  .title-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-bottom: 8rpx;

    .title-text {
      font-size: 48rpx;
      font-weight: 700;
      color: $text-main;
      letter-spacing: 0.5rpx;
    }

    .status-badge {
      padding: 4rpx 16rpx;
      font-size: 20rpx;
      color: $primary-dark;
      background: rgb(10 219 195 / 10%);
      border: 1rpx solid rgb(10 219 195 / 20%);
      border-radius: 9999rpx;
      font-weight: 700;
    }
  }

  .title-desc {
    margin-top: 8rpx;
    font-size: 28rpx;
    color: $text-sub;
    line-height: 1.6;

    .required-mark {
      color: $accent;
    }
  }
}

// 毛玻璃卡片
.glass-card {
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: 48rpx;
  box-shadow: 0 8rpx 32rpx rgb(31 38 135 / 7%);
  backdrop-filter: blur(32rpx);
}

.section-card {
  display: flex;
  padding: 40rpx;
  flex-direction: column;
  gap: 32rpx;
}

// 区块标题
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8rpx;

  .section-title-wrapper {
    display: flex;
    align-items: center;
    gap: 20rpx;

    .section-indicator {
      width: 8rpx;
      height: 40rpx;
      border-radius: 4rpx;

      &.section-indicator-primary {
        background: $primary;
      }

      &.section-indicator-accent {
        background: $accent;
      }

      &.section-indicator-gray {
        background: #9ca3af;
      }
    }

    .section-title {
      font-size: 32rpx;
      font-weight: 700;
      color: $text-main;
    }
  }

  .readonly-badge {
    display: flex;
    align-items: center;
    padding: 4rpx 16rpx;
    font-size: 20rpx;
    color: $text-sub;
    background: rgb(255 255 255 / 50%);
    border: 1rpx solid rgb(255 255 255 / 60%);
    border-radius: 9999rpx;
    gap: 4rpx;
    font-weight: 700;
    backdrop-filter: blur(8rpx);
  }

  .upload-limit {
    padding: 4rpx 16rpx;
    font-size: 20rpx;
    color: $text-sub;
    background: rgb(255 255 255 / 50%);
    border-radius: 9999rpx;
  }
}

// 用户信息卡片
.user-info-card {
  position: relative;
  display: flex;
  align-items: center;
  overflow: hidden;
  padding: 32rpx;
  background: rgb(255 255 255 / 40%);
  border: 1rpx solid rgb(255 255 255);
  border-radius: 32rpx;
  box-shadow: 0 2rpx 6rpx rgb(0 0 0 / 2%);
  gap: 32rpx;

  .user-icon-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 96rpx;
    height: 96rpx;
    background: linear-gradient(to bottom right, $primary, $primary-dark);
    border-radius: 24rpx;
    box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 20%);
    flex-shrink: 0;
  }

  .user-info-grid {
    flex: 1;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 32rpx;

    .user-info-item {
      display: flex;
      flex-direction: column;

      &.user-info-item-border {
        border-left: 1rpx solid rgb(229 231 235 / 50%);
        padding-left: 32rpx;
      }

      .info-label {
        margin-bottom: 8rpx;
        font-size: 20rpx;
        color: #9ca3af;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1rpx;
      }

      .info-value {
        font-size: 32rpx;
        font-weight: 700;
        color: $text-main;
      }
    }
  }

  .user-info-decoration {
    position: absolute;
    top: -48rpx;
    right: -48rpx;
    width: 160rpx;
    height: 160rpx;
    background: rgb(10 219 195 / 10%);
    border-radius: 50%;
    filter: blur(40rpx);
    pointer-events: none;
  }
}

// 输入组
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
  cursor: pointer;
  user-select: none;
  -webkit-tap-highlight-color: transparent;

  &.disabled {
    opacity: 0.6;
    cursor: not-allowed;
    pointer-events: none;
  }

  .input-icon {
    position: absolute;
    left: 24rpx;
    display: flex;
    align-items: center;
    pointer-events: none;
  }

  .input-content {
    padding: 16rpx 80rpx;
    padding-right: 80rpx;
    padding-left: 80rpx;
    flex: 1;

    .input-label {
      display: block;
      margin-bottom: 8rpx;
      font-size: 20rpx;
      color: #9ca3af;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1rpx;

      .required-mark {
        color: $accent;
      }
    }

    .input-value {
      display: flex;
      align-items: center;
      width: 100%;
      min-height: 48rpx;
      font-size: 28rpx;
      color: $text-main;
      font-weight: 600;

      &.placeholder {
        color: #9ca3af;
        font-weight: 400;
      }

      &.has-value {
        color: $text-main;
        font-weight: 600;
      }
    }
  }

  .input-arrow {
    position: absolute;
    right: 24rpx;
    display: flex;
    align-items: center;
    pointer-events: none;
    transition: all 0.3s;
  }

  // Picker 样式增强
  .input-picker-wrapper {
    display: block;
    width: 100%;
    cursor: pointer;

    .picker-enhanced {
      width: 100%;
      transition: all 0.3s;
    }
  }

  // 聚焦状态下的样式
  &:focus-within,
  &.active {
    background: rgb(255 255 255 / 100%);
    border-color: $primary;
    box-shadow: 0 4rpx 12rpx rgb(10 219 195 / 15%);
    transform: translateY(-2rpx);

    .input-arrow {
      color: $primary;
      transform: rotate(180deg);
    }
  }
}

// 文本域组
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
      color: $text-sub;
      text-transform: uppercase;
      letter-spacing: 1rpx;

      .required-mark {
        color: $accent;
      }
    }
  }

  .textarea-input {
    padding: 24rpx;
    width: 100%;
    min-height: 200rpx;
    font-size: 28rpx;
    color: $text-main;
    background: rgb(255 255 255 / 40%);
    border: none;
    border-radius: 24rpx;
    line-height: 1.6;

    &::placeholder {
      color: #9ca3af;
    }
  }
}

// 上传列表
.upload-list {
  display: flex;
  overflow-x: auto;
  padding: 4rpx;
  white-space: nowrap;
  gap: 24rpx;

  &::-webkit-scrollbar {
    display: none;
  }
}

.upload-item {
  position: relative;
  overflow: hidden;
  width: 192rpx;
  height: 192rpx;
  border-radius: 32rpx;
  flex-shrink: 0;

  &.upload-add {
    display: flex;
    justify-content: center;
    align-items: center;
    background: rgb(10 219 195 / 5%);
    border: 2rpx dashed rgb(10 219 195 / 30%);
    transition: all 0.2s;
    flex-direction: column;
    gap: 8rpx;

    &:active {
      transform: scale(0.95);
      background: rgb(10 219 195 / 10%);
    }

    .upload-add-icon {
      color: $primary;
    }

    .upload-add-text {
      font-size: 20rpx;
      font-weight: 700;
      color: rgb(10 219 195 / 80%);
    }
  }

  &.upload-preview {
    border: 1rpx solid rgb(255 255 255);
    box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 5%);

    .upload-image {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .upload-delete {
      position: absolute;
      top: 0;
      right: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 48rpx;
      height: 48rpx;
      background: #ef4444;
      border-radius: 0 0 0 24rpx;
      box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 20%);
      transition: all 0.2s;

      &:active {
        transform: scale(0.9);
      }
    }
  }
}

.upload-tip {
  display: flex;
  align-items: flex-start;
  padding: 24rpx;
  font-size: 24rpx;
  color: $text-sub;
  background: rgb(96 165 250 / 10%);
  border: 1rpx solid rgb(96 165 250 / 20%);
  border-radius: 24rpx;
  gap: 12rpx;
  line-height: 1.5;
}

// 底部操作栏
.bottom-actions {
  position: fixed;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 50;
  display: flex;
  padding: 20rpx 48rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  margin: 0 auto;
  max-width: 750rpx;
  background: $glass-bg;
  box-shadow: 0 -10rpx 40rpx rgb(0 0 0 / 3%);
  backdrop-filter: blur(32rpx);
  border-top: 1rpx solid rgb(255 255 255 / 60%);
  gap: 32rpx;

  .action-btn {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 96rpx;
    font-size: 28rpx;
    border-radius: 32rpx;
    transition: all 0.2s;
    font-weight: 700;

    &:active {
      transform: scale(0.95);
    }

    &.submit-btn {
      color: #fff;
      background: linear-gradient(to right, $primary, $primary-dark);
      box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 30%);
      flex: 1;
      gap: 16rpx;

      &:active {
        box-shadow: 0 4rpx 12rpx rgb(10 219 195 / 30%);
      }
    }
  }
}

// 遮罩层 - 固定在屏幕，不受父容器影响
.picker-overlay {
  position: fixed !important;
  inset: 0 !important;
  z-index: 99998 !important;
  background: rgb(0 0 0 / 50%);
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }

  to {
    opacity: 1;
  }
}

// 自定义 Picker 弹窗样式 - 固定在屏幕底部，不受父容器影响
.custom-picker-popup {
  position: fixed !important;
  right: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  z-index: 99999 !important;
  overflow: hidden;
  padding-bottom: env(safe-area-inset-bottom);
  width: 100vw !important;
  max-height: 80vh;
  background: #fff;
  border-radius: 32rpx 32rpx 0 0;
  animation: slideUp 0.3s;

  .picker-popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 32rpx 48rpx;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%);
    background: #fff;

    .picker-popup-btn {
      padding: 8rpx 16rpx;
      font-size: 32rpx;
      transition: all 0.2s;
      font-weight: 500;

      &.cancel-btn {
        color: #6b7280;

        &:active {
          color: #111817;
        }
      }

      &.confirm-btn {
        color: #0adbc3;
        font-weight: 600;

        &:active {
          color: #08bda8;
        }
      }
    }

    .picker-popup-title {
      font-size: 36rpx;
      text-align: center;
      color: #111817;
      flex: 1;
      font-weight: 700;
    }
  }

  .picker-popup-content {
    overflow-y: auto;
    padding: 16rpx 0;
    max-height: calc(80vh - 120rpx);

    .picker-popup-item {
      position: relative;
      padding: 32rpx 48rpx;
      font-size: 32rpx;
      text-align: center;
      color: #111817;
      transition: all 0.2s;

      .picker-item-icon {
        position: absolute;
        top: 50%;
        right: 75rpx;
        display: flex;
        justify-content: center;
        align-items: center;
        transform: translateY(-50%);
      }

      .picker-item-text {
        display: block;
        width: 100%;
        text-align: center;
      }

      &.active {
        color: #0adbc3;
        font-weight: 700;
      }
    }
  }
}

// 日期选择器样式
// 遮罩层
.picker-overlay {
  position: fixed;
  inset: 0;
  z-index: 9998;
  background: rgb(0 0 0 / 50%);
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }

  to {
    opacity: 1;
  }
}

// 申请类型选择弹窗 - 固定在屏幕底部
.custom-picker-popup {
  position: fixed !important;
  right: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  z-index: 99999 !important;
  overflow: hidden;
  padding-bottom: env(safe-area-inset-bottom);
  width: 100vw !important;
  max-height: 80vh;
  background: #fff;
  border-radius: 32rpx 32rpx 0 0;
  animation: slideUp 0.3s;
}

@keyframes slideUp {
  from {
    transform: translateY(100%);
  }

  to {
    transform: translateY(0);
  }
}
</style>
