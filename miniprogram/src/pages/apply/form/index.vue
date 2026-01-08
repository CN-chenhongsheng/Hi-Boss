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

    <!-- 日期范围选择弹窗 - 最外层 -->
    <view
      v-if="dateRangePickerState.show"
      class="picker-overlay"
      @click="closeDateRangePicker"
    />
    <view
      v-if="dateRangePickerState.show"
      class="date-range-picker-popup"
    >
      <view class="picker-popup-header">
        <view class="picker-popup-btn cancel-btn" @click="closeDateRangePicker">
          取消
        </view>
        <view class="picker-popup-title">
          选择日期范围
        </view>
        <view class="picker-popup-btn confirm-btn" @click="confirmDateRange">
          完成
        </view>
      </view>
      <view class="picker-popup-content">
        <view class="date-range-tabs">
          <view
            class="date-tab"
            :class="{ active: dateRangePickerState.activeTab === 'start' }"
            @click="dateRangePickerState.activeTab = 'start'"
          >
            开始日期
          </view>
          <view
            class="date-tab"
            :class="{ active: dateRangePickerState.activeTab === 'end' }"
            @click="dateRangePickerState.activeTab = 'end'"
          >
            结束日期
          </view>
        </view>

        <picker-view
          class="date-picker-view"
          :value="dateRangePickerState.activeTab === 'start' ? dateRangePickerState.startDatePickerValue : dateRangePickerState.endDatePickerValue"
          @change="handleDatePickerViewChange"
        >
          <picker-view-column>
            <view
              v-for="(year, index) in dateRangePickerState.years"
              :key="index"
              class="picker-view-item"
            >
              {{ year }}年
            </view>
          </picker-view-column>
          <picker-view-column>
            <view
              v-for="(month, index) in dateRangePickerState.months"
              :key="index"
              class="picker-view-item"
            >
              {{ month }}月
            </view>
          </picker-view-column>
          <picker-view-column>
            <view
              v-for="(day, index) in (dateRangePickerState.activeTab === 'start' ? dateRangePickerState.startDays : dateRangePickerState.endDays)"
              :key="index"
              class="picker-view-item"
            >
              {{ day }}日
            </view>
          </picker-view-column>
        </picker-view>
      </view>
    </view>

    <!-- 签名弹窗 - 最外层 -->
    <view
      v-if="signaturePickerState.show"
      class="picker-overlay"
      @click="closeSignaturePicker"
    />
    <view
      v-if="signaturePickerState.show"
      class="signature-modal"
    >
      <view class="signature-modal-header">
        <view class="modal-title">
          手写签名
        </view>
        <view class="modal-close" @click="closeSignaturePicker">
          <u-icon name="close" size="24" color="#6b7280" />
        </view>
      </view>

      <view class="signature-canvas-container">
        <!-- #ifdef MP-WEIXIN -->
        <canvas
          id="signatureCanvas"
          type="2d"
          class="signature-canvas"
          :style="{ width: `${signaturePickerState.canvasWidth}rpx`, height: `${signaturePickerState.canvasHeight}rpx` }"
          @touchstart="handleSignatureTouchStart"
          @touchmove="handleSignatureTouchMove"
          @touchend="handleSignatureTouchEnd"
        />
        <!-- #endif -->

        <!-- #ifdef H5 -->
        <canvas
          id="signatureCanvas"
          class="signature-canvas"
          :width="signaturePickerState.canvasWidth"
          :height="signaturePickerState.canvasHeight"
          @touchstart="handleSignatureTouchStart"
          @touchmove="handleSignatureTouchMove"
          @touchend="handleSignatureTouchEnd"
        />
        <!-- #endif -->
      </view>

      <view class="signature-modal-actions">
        <view class="action-btn clear-btn" @click="clearSignature">
          清除
        </view>
        <view class="action-btn confirm-btn" @click="confirmSignature">
          确认
        </view>
      </view>
    </view>

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

            <!-- 申请类型 -->
            <view
              class="input-group"
              :class="{ disabled: !canModifyApplyType }"
              @click="canModifyApplyType ? openApplyTypePicker() : null"
            >
              <view class="input-icon">
                <u-icon name="list" size="20" color="#0adbc3" />
              </view>
              <view class="input-content">
                <view class="input-label">
                  申请类型
                  <text class="required-mark">
                    *
                  </text>
                </view>
                <view class="input-value picker-enhanced" :class="{ 'placeholder': !formData.applyType, 'has-value': formData.applyType }">
                  {{ currentApplyTypeLabel }}
                </view>
              </view>
              <view v-if="canModifyApplyType" class="input-arrow">
                <u-icon name="arrow-down-fill" size="20" color="#9ca3af" />
              </view>
            </view>

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
          </view>
        </main>

        <!-- 底部操作栏 -->
        <view class="bottom-actions">
          <view class="action-btn cancel-btn" @click="handleCancel">
            取消
          </view>
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
import { computed, nextTick, onMounted, provide, reactive, ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import NormalCheckIn from './components/normal-check-in.vue';
import TempCheckIn from './components/temp-check-in.vue';
import Transfer from './components/transfer.vue';
import CheckOut from './components/check-out.vue';
import Stay from './components/stay.vue';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();

// 申请类型选项
const applyTypeOptions = [
  { label: '正常入住', value: 'normalCheckIn' },
  { label: '临时入住', value: 'tempCheckIn' },
  { label: '调宿申请', value: 'transfer' },
  { label: '退宿申请', value: 'checkOut' },
  { label: '留宿申请', value: 'stay' },
];

// 表单数据
const formData = reactive({
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
});

const applyTypeIndex = ref(0);
// 临时选中的索引（用于弹窗中的选择）
const tempApplyTypeIndex = ref(0);

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

// 当前申请类型标签
const currentApplyTypeLabel = computed(() => {
  if (!formData.applyType) {
    return '请选择类型';
  }
  const option = applyTypeOptions.find(opt => opt.value === formData.applyType);
  return option?.label || '请选择类型';
});

// 弹窗控制
const showApplyTypePicker = ref(false);

// 日期范围选择器状态
const dateRangePickerState = reactive({
  show: false,
  activeTab: 'start' as 'start' | 'end',
  startDatePickerValue: [0, 0, 0],
  endDatePickerValue: [0, 0, 0],
  years: [] as number[],
  months: [] as number[],
  startDays: [] as number[],
  endDays: [] as number[],
  currentDateRange: null as { startDate?: string; endDate?: string } | null,
  onConfirm: null as ((value: { startDate?: string; endDate?: string }) => void) | null,
});

// 签名选择器状态
const signaturePickerState = reactive({
  show: false,
  canvasWidth: 600,
  canvasHeight: 400,
  currentValue: '',
  onConfirm: null as ((value: string) => void) | null,
});

let signatureCtx: any = null;
let isDrawing = false;
let lastX = 0;
let lastY = 0;

// 用户信息
const userInfo = computed(() => userStore.userInfo);

// 返回
function handleBack() {
  uni.navigateBack();
}

// 打开申请类型选择器
function openApplyTypePicker() {
  if (!canModifyApplyType.value) {
    return;
  }
  // 初始化临时选中索引为当前选中索引
  tempApplyTypeIndex.value = filteredApplyTypeIndex.value >= 0 ? filteredApplyTypeIndex.value : 0;
  showApplyTypePicker.value = true;
}

// 选择申请类型（在弹窗中）
function handleSelectApplyType(index: number) {
  // 只有在允许修改的情况下才能选择
  if (!canModifyApplyType.value) {
    return;
  }
  // 更新临时选中索引
  tempApplyTypeIndex.value = index;
}

// 确认申请类型
function confirmApplyType() {
  if (!canModifyApplyType.value) {
    showApplyTypePicker.value = false;
    return;
  }
  const oldType = formData.applyType;
  // 使用临时选中的索引来获取选中的选项
  const selectedOption = filteredApplyTypeOptions.value[tempApplyTypeIndex.value];
  if (selectedOption) {
    formData.applyType = selectedOption.value;
    // 同步更新 applyTypeIndex
    const originalIndex = applyTypeOptions.findIndex(opt => opt.value === selectedOption.value);
    if (originalIndex >= 0) {
      applyTypeIndex.value = originalIndex;
    }
  }

  // 如果切换了申请类型，清空表单数据
  if (oldType && oldType !== formData.applyType) {
    // 保留申请类型，清空其他字段
    Object.keys(formData).forEach((key) => {
      if (key !== 'applyType') {
        if (Array.isArray(formData[key as keyof typeof formData])) {
          (formData[key as keyof typeof formData] as any) = [];
        }
        else {
          (formData[key as keyof typeof formData] as any) = '';
        }
      }
    });
  }

  showApplyTypePicker.value = false;
}

// 获取组件所需的表单数据
function getFormDataForComponent() {
  return { ...formData };
}

// 处理表单更新
function handleFormUpdate(field: string, value: any) {
  (formData as any)[field] = value;
}

// 初始化日期选项
function initDateOptions(currentValue?: { startDate?: string; endDate?: string }) {
  const currentYear = new Date().getFullYear();
  const currentMonth = new Date().getMonth() + 1;
  const currentDay = new Date().getDate();

  dateRangePickerState.years = [];
  dateRangePickerState.months = [];
  for (let i = 0; i < 6; i++) {
    dateRangePickerState.years.push(currentYear + i);
  }
  for (let i = 1; i <= 12; i++) {
    dateRangePickerState.months.push(i);
  }

  if (currentValue?.startDate) {
    const [year, month, day] = currentValue.startDate.split('-').map(Number);
    const yearIndex = dateRangePickerState.years.indexOf(year);
    // 如果年份不在范围内，使用当前年份
    const finalYearIndex = yearIndex >= 0 ? yearIndex : 0;
    dateRangePickerState.startDatePickerValue = [
      finalYearIndex,
      Math.max(0, Math.min(11, month - 1)),
      Math.max(0, day - 1),
    ];
    updateStartDays();
    // 再次检查日期索引是否超出范围
    if (dateRangePickerState.startDatePickerValue[2] >= dateRangePickerState.startDays.length) {
      dateRangePickerState.startDatePickerValue[2] = Math.max(0, dateRangePickerState.startDays.length - 1);
    }
  }
  else {
    dateRangePickerState.startDatePickerValue = [0, currentMonth - 1, currentDay - 1];
    updateStartDays();
    // 确保日期索引在有效范围内
    if (dateRangePickerState.startDatePickerValue[2] >= dateRangePickerState.startDays.length) {
      dateRangePickerState.startDatePickerValue[2] = Math.max(0, dateRangePickerState.startDays.length - 1);
    }
  }

  if (currentValue?.endDate) {
    const [year, month, day] = currentValue.endDate.split('-').map(Number);
    const yearIndex = dateRangePickerState.years.indexOf(year);
    // 如果年份不在范围内，使用当前年份
    const finalYearIndex = yearIndex >= 0 ? yearIndex : 0;
    dateRangePickerState.endDatePickerValue = [
      finalYearIndex,
      Math.max(0, Math.min(11, month - 1)),
      Math.max(0, day - 1),
    ];
    updateEndDays();
    // 再次检查日期索引是否超出范围
    if (dateRangePickerState.endDatePickerValue[2] >= dateRangePickerState.endDays.length) {
      dateRangePickerState.endDatePickerValue[2] = Math.max(0, dateRangePickerState.endDays.length - 1);
    }
  }
  else {
    dateRangePickerState.endDatePickerValue = [0, currentMonth - 1, currentDay - 1];
    updateEndDays();
    // 确保日期索引在有效范围内
    if (dateRangePickerState.endDatePickerValue[2] >= dateRangePickerState.endDays.length) {
      dateRangePickerState.endDatePickerValue[2] = Math.max(0, dateRangePickerState.endDays.length - 1);
    }
  }
}

function updateStartDays() {
  const year = dateRangePickerState.years[dateRangePickerState.startDatePickerValue[0]];
  const month = dateRangePickerState.months[dateRangePickerState.startDatePickerValue[1]];
  const maxDay = new Date(year, month, 0).getDate();
  dateRangePickerState.startDays = [];
  for (let i = 1; i <= maxDay; i++) {
    dateRangePickerState.startDays.push(i);
  }
  if (dateRangePickerState.startDatePickerValue[2] >= maxDay) {
    dateRangePickerState.startDatePickerValue[2] = maxDay - 1;
  }
}

function updateEndDays() {
  const year = dateRangePickerState.years[dateRangePickerState.endDatePickerValue[0]];
  const month = dateRangePickerState.months[dateRangePickerState.endDatePickerValue[1]];
  const maxDay = new Date(year, month, 0).getDate();
  dateRangePickerState.endDays = [];
  for (let i = 1; i <= maxDay; i++) {
    dateRangePickerState.endDays.push(i);
  }
  if (dateRangePickerState.endDatePickerValue[2] >= maxDay) {
    dateRangePickerState.endDatePickerValue[2] = maxDay - 1;
  }
}

function handleDatePickerViewChange(e: any) {
  const oldValue = dateRangePickerState.activeTab === 'start'
    ? [...dateRangePickerState.startDatePickerValue]
    : [...dateRangePickerState.endDatePickerValue];

  if (dateRangePickerState.activeTab === 'start') {
    dateRangePickerState.startDatePickerValue = e.detail.value;
    if (oldValue[0] !== e.detail.value[0] || oldValue[1] !== e.detail.value[1]) {
      updateStartDays();
    }
  }
  else {
    dateRangePickerState.endDatePickerValue = e.detail.value;
    if (oldValue[0] !== e.detail.value[0] || oldValue[1] !== e.detail.value[1]) {
      updateEndDays();
    }
  }
}

function openDateRangePicker(currentValue: { startDate?: string; endDate?: string }, onConfirm: (value: { startDate?: string; endDate?: string }) => void) {
  dateRangePickerState.currentDateRange = currentValue;
  dateRangePickerState.onConfirm = onConfirm;
  dateRangePickerState.activeTab = 'start';
  initDateOptions(currentValue);
  dateRangePickerState.show = true;
}

function closeDateRangePicker() {
  dateRangePickerState.show = false;
}

// 格式化日期数字（兼容小程序）
function formatDateNumber(num: number): string {
  if (num < 10) {
    return `0${num}`;
  }
  return String(num);
}

function confirmDateRange() {
  // 确保天数数组已更新
  updateStartDays();
  updateEndDays();

  // 获取开始日期索引（确保索引在有效范围内）
  const startYearIndex = Math.max(0, Math.min(dateRangePickerState.years.length - 1, dateRangePickerState.startDatePickerValue[0] || 0));
  const startMonthIndex = Math.max(0, Math.min(11, dateRangePickerState.startDatePickerValue[1] || 0));
  const startDayIndex = Math.max(0, Math.min(dateRangePickerState.startDays.length - 1, dateRangePickerState.startDatePickerValue[2] || 0));

  const startYear = dateRangePickerState.years[startYearIndex];
  const startMonth = dateRangePickerState.months[startMonthIndex];
  const startDay = dateRangePickerState.startDays[startDayIndex];

  // 获取结束日期索引（确保索引在有效范围内）
  const endYearIndex = Math.max(0, Math.min(dateRangePickerState.years.length - 1, dateRangePickerState.endDatePickerValue[0] || 0));
  const endMonthIndex = Math.max(0, Math.min(11, dateRangePickerState.endDatePickerValue[1] || 0));
  const endDayIndex = Math.max(0, Math.min(dateRangePickerState.endDays.length - 1, dateRangePickerState.endDatePickerValue[2] || 0));

  const endYear = dateRangePickerState.years[endYearIndex];
  const endMonth = dateRangePickerState.months[endMonthIndex];
  const endDay = dateRangePickerState.endDays[endDayIndex];

  // 格式化日期（使用自定义格式化函数，兼容小程序）
  const startDate = `${startYear}-${formatDateNumber(startMonth)}-${formatDateNumber(startDay)}`;
  const endDate = `${endYear}-${formatDateNumber(endMonth)}-${formatDateNumber(endDay)}`;

  // 验证日期范围
  if (new Date(endDate) < new Date(startDate)) {
    uni.showToast({
      title: '结束日期不能早于开始日期',
      icon: 'none',
    });
    return;
  }

  // 执行回调函数，更新数据
  if (dateRangePickerState.onConfirm) {
    // 确保在小程序中也能正确触发更新
    try {
      // 创建一个新对象，确保引用改变（小程序响应式需要）
      const dateValue = {
        startDate,
        endDate,
      };
      dateRangePickerState.onConfirm(dateValue);
    }
    catch (error) {
      console.error('日期选择器回调执行失败:', error);
      uni.showToast({
        title: '日期选择失败，请重试',
        icon: 'none',
      });
      return;
    }
  }
  else {
    console.warn('日期选择器 onConfirm 回调未设置');
    uni.showToast({
      title: '日期选择器未初始化',
      icon: 'none',
    });
    return;
  }
  closeDateRangePicker();
}

// 签名相关函数
function initSignatureCanvas() {
  // #ifdef MP-WEIXIN
  nextTick(() => {
    // 延迟一点确保 canvas 已经渲染
    setTimeout(() => {
      const query = uni.createSelectorQuery();
      query.select('#signatureCanvas').node((res: any) => {
        const canvas = res.node;
        if (canvas) {
          signatureCtx = canvas.getContext('2d');
          if (signatureCtx) {
            // 设置画布实际尺寸（像素）
            // signaturePickerState.canvasWidth 存储的是 rpx，需要转换为 px
            const canvasWidthPx = signaturePickerState.canvasWidth / 2;
            const canvasHeightPx = signaturePickerState.canvasHeight / 2;
            const dpr = uni.getSystemInfoSync().pixelRatio || 2;
            canvas.width = canvasWidthPx * dpr;
            canvas.height = canvasHeightPx * dpr;
            // 缩放上下文以匹配设备像素比
            signatureCtx.scale(dpr, dpr);
            signatureCtx.strokeStyle = '#111817';
            signatureCtx.lineWidth = 3;
            signatureCtx.lineCap = 'round';
            signatureCtx.lineJoin = 'round';
          }
        }
      }).exec();
    }, 100);
  });
  // #endif

  // #ifdef H5
  nextTick(() => {
    // 延迟一点确保 canvas 已经渲染
    setTimeout(() => {
      const canvas = document.getElementById('signatureCanvas') as HTMLCanvasElement;
      if (canvas && canvas instanceof HTMLCanvasElement) {
        signatureCtx = canvas.getContext('2d');
        if (signatureCtx) {
          // 确保 canvas 尺寸正确
          canvas.width = signaturePickerState.canvasWidth;
          canvas.height = signaturePickerState.canvasHeight;
          signatureCtx.strokeStyle = '#111817';
          signatureCtx.lineWidth = 3;
          signatureCtx.lineCap = 'round';
          signatureCtx.lineJoin = 'round';
        }
      }
    }, 100);
  });
  // #endif
}

function handleSignatureTouchStart(e: any) {
  isDrawing = true;
  const touch = e.touches[0];

  // #ifdef MP-WEIXIN
  const query = uni.createSelectorQuery();
  query.select('#signatureCanvas').boundingClientRect((rect: any) => {
    if (rect) {
      // 小程序中使用 clientX 和 clientY
      lastX = (touch.clientX || touch.x) - rect.left;
      lastY = (touch.clientY || touch.y) - rect.top;
      if (signatureCtx) {
        signatureCtx.beginPath();
        signatureCtx.moveTo(lastX, lastY);
      }
    }
  }).exec();
  // #endif

  // #ifdef H5
  const rect = (e.target as HTMLElement).getBoundingClientRect();
  lastX = e.touches[0].clientX - rect.left;
  lastY = e.touches[0].clientY - rect.top;
  if (signatureCtx) {
    signatureCtx.beginPath();
    signatureCtx.moveTo(lastX, lastY);
  }
  // #endif
}

function handleSignatureTouchMove(e: any) {
  if (!isDrawing || !signatureCtx) return;
  e.preventDefault();
  const touch = e.touches[0];
  let currentX = 0;
  let currentY = 0;

  // #ifdef MP-WEIXIN
  const query = uni.createSelectorQuery();
  query.select('#signatureCanvas').boundingClientRect((data: any) => {
    if (data) {
      // 小程序中使用 clientX 和 clientY
      currentX = (touch.clientX || touch.x) - data.left;
      currentY = (touch.clientY || touch.y) - data.top;
      signatureCtx.lineTo(currentX, currentY);
      signatureCtx.stroke();
      lastX = currentX;
      lastY = currentY;
    }
  }).exec();
  // #endif

  // #ifdef H5
  const rect = (e.target as HTMLElement).getBoundingClientRect();
  currentX = e.touches[0].clientX - rect.left;
  currentY = e.touches[0].clientY - rect.top;
  signatureCtx.lineTo(currentX, currentY);
  signatureCtx.stroke();
  lastX = currentX;
  lastY = currentY;
  // #endif
}

function handleSignatureTouchEnd() {
  isDrawing = false;
}

function clearSignature() {
  if (!signatureCtx) return;
  // signaturePickerState.canvasWidth 存储的是 rpx，需要转换为 px
  const canvasWidthPx = signaturePickerState.canvasWidth / 2;
  const canvasHeightPx = signaturePickerState.canvasHeight / 2;
  signatureCtx.clearRect(0, 0, canvasWidthPx, canvasHeightPx);
}

function openSignaturePicker(currentValue: string, onConfirm: (value: string) => void) {
  signaturePickerState.currentValue = currentValue;
  signaturePickerState.onConfirm = onConfirm;
  signaturePickerState.show = true;
  nextTick(() => {
    initSignatureCanvas();
  });
}

function closeSignaturePicker() {
  signaturePickerState.show = false;
}

function confirmSignature() {
  // #ifdef MP-WEIXIN
  nextTick(() => {
    const query = uni.createSelectorQuery();
    query.select('#signatureCanvas').node((res: any) => {
      const canvas = res.node;
      if (canvas) {
        // 对于 2d canvas，使用 canvas 参数
        // signaturePickerState.canvasWidth 存储的是 rpx，需要转换为 px
        const canvasWidthPx = signaturePickerState.canvasWidth / 2;
        const canvasHeightPx = signaturePickerState.canvasHeight / 2;
        uni.canvasToTempFilePath({
          canvas: canvas as any,
          width: canvasWidthPx,
          height: canvasHeightPx,
          destWidth: canvasWidthPx,
          destHeight: canvasHeightPx,
          success: (res: any) => {
            if (signaturePickerState.onConfirm) {
              signaturePickerState.onConfirm(res.tempFilePath);
            }
            closeSignaturePicker();
          },
          fail: (err: any) => {
            console.error('导出签名失败:', err);
            uni.showToast({
              title: '导出签名失败',
              icon: 'none',
            });
          },
        } as any);
      }
    }).exec();
  });
  // #endif

  // #ifdef H5
  // 延迟执行确保 canvas 已经初始化
  setTimeout(() => {
    const canvas = document.getElementById('signatureCanvas') as HTMLCanvasElement;
    if (canvas && canvas instanceof HTMLCanvasElement) {
      try {
        const dataUrl = canvas.toDataURL('image/png');
        if (signaturePickerState.onConfirm) {
          signaturePickerState.onConfirm(dataUrl);
        }
        closeSignaturePicker();
      }
      catch (error) {
        console.error('导出签名失败:', error);
        uni.showToast({
          title: '导出签名失败',
          icon: 'none',
        });
      }
    }
    else {
      console.error('Canvas 元素未找到或不是有效的 canvas 元素');
      uni.showToast({
        title: '导出签名失败',
        icon: 'none',
      });
    }
  }, 100);
  // #endif
}

// Provide 给子组件使用
provide('openDateRangePicker', openDateRangePicker);
provide('openSignaturePicker', openSignaturePicker);

// 页面加载时接收参数
onLoad((options: any) => {
  // 根据传入的type参数设置默认申请类型
  if (options.type) {
    const typeMap: Record<string, string> = {
      checkIn: 'normalCheckIn', // 入住申请默认正常入住
      transfer: 'transfer',
      checkOut: 'checkOut',
      stay: 'stay',
    };
    const defaultType = typeMap[options.type];
    if (defaultType) {
      const typeIndex = applyTypeOptions.findIndex(opt => opt.value === defaultType);
      if (typeIndex >= 0) {
        applyTypeIndex.value = typeIndex;
        formData.applyType = defaultType;
      }
    }
  }
});

// 初始化签名画布尺寸
onMounted(() => {
  const systemInfo = uni.getSystemInfoSync();
  const screenWidth = systemInfo.windowWidth;
  // 画布尺寸：横向布局，宽度约为屏幕宽度的 85%（考虑 padding），高度为宽度的 50%（横向）
  // screenWidth 是 px，转换为 rpx（乘以 2，基于 750rpx = 375px 的标准）
  const displayWidthRpx = Math.floor((screenWidth - 80) * 2); // 显示宽度（rpx）
  const displayHeightRpx = Math.floor(displayWidthRpx * 0.5); // 显示高度（rpx），横向比例为 2:1
  // 实际像素尺寸（用于 canvas 绘制，考虑高分辨率）
  signaturePickerState.canvasWidth = displayWidthRpx; // 实际像素宽度
  signaturePickerState.canvasHeight = displayHeightRpx; // 实际像素高度
});

// 取消
function handleCancel() {
  uni.showModal({
    title: '确认取消',
    content: '确定要取消填写吗？未保存的内容将丢失。',
    success: (res) => {
      if (res.confirm) {
        uni.navigateBack();
      }
    },
  });
}

// 表单验证
function validateForm(): boolean {
  if (!formData.applyType) {
    uni.showToast({
      title: '请选择申请类型',
      icon: 'none',
    });
    return false;
  }

  // 根据不同的申请类型进行验证
  switch (formData.applyType) {
    case 'normalCheckIn':
      if (!formData.reason || formData.reason.trim() === '') {
        uni.showToast({
          title: '请输入申请原因',
          icon: 'none',
        });
        return false;
      }
      break;

    case 'tempCheckIn':
      if (!formData.parentName || formData.parentName.trim() === '') {
        uni.showToast({
          title: '请输入家长姓名',
          icon: 'none',
        });
        return false;
      }
      if (!formData.parentPhone || formData.parentPhone.trim() === '') {
        uni.showToast({
          title: '请输入家长电话',
          icon: 'none',
        });
        return false;
      }
      if (!formData.parentAgree) {
        uni.showToast({
          title: '请选择家长是否同意',
          icon: 'none',
        });
        return false;
      }
      if (!formData.stayStartDate || !formData.stayEndDate) {
        uni.showToast({
          title: '请选择留宿时间',
          icon: 'none',
        });
        return false;
      }
      if (!formData.reason || formData.reason.trim() === '') {
        uni.showToast({
          title: '请输入申请原因',
          icon: 'none',
        });
        return false;
      }
      if (!formData.signature) {
        uni.showToast({
          title: '请完成本人签名',
          icon: 'none',
        });
        return false;
      }
      break;

    case 'transfer':
      if (!formData.reason || formData.reason.trim() === '') {
        uni.showToast({
          title: '请输入申请原因',
          icon: 'none',
        });
        return false;
      }
      break;

    case 'checkOut':
      if (!formData.reason || formData.reason.trim() === '') {
        uni.showToast({
          title: '请输入申请原因',
          icon: 'none',
        });
        return false;
      }
      if (!formData.signature) {
        uni.showToast({
          title: '请完成本人签名',
          icon: 'none',
        });
        return false;
      }
      break;

    case 'stay':
      if (!formData.parentName || formData.parentName.trim() === '') {
        uni.showToast({
          title: '请输入家长姓名',
          icon: 'none',
        });
        return false;
      }
      if (!formData.parentPhone || formData.parentPhone.trim() === '') {
        uni.showToast({
          title: '请输入家长电话',
          icon: 'none',
        });
        return false;
      }
      if (!formData.parentAgree) {
        uni.showToast({
          title: '请选择家长是否同意',
          icon: 'none',
        });
        return false;
      }
      if (!formData.stayStartDate || !formData.stayEndDate) {
        uni.showToast({
          title: '请选择留宿时间',
          icon: 'none',
        });
        return false;
      }
      if (!formData.reason || formData.reason.trim() === '') {
        uni.showToast({
          title: '请输入申请原因',
          icon: 'none',
        });
        return false;
      }
      if (!formData.signature) {
        uni.showToast({
          title: '请完成本人签名',
          icon: 'none',
        });
        return false;
      }
      break;
  }

  return true;
}

// 提交
function handleSubmit() {
  if (!validateForm()) {
    return;
  }

  // TODO: 调用API提交申请
  uni.showLoading({
    title: '提交中...',
  });

  setTimeout(() => {
    uni.hideLoading();
    uni.showToast({
      title: '提交成功',
      icon: 'success',
    });
    setTimeout(() => {
      uni.navigateBack();
    }, 1500);
  }, 1000);
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
  padding-bottom: 200rpx;
  margin: 0 auto;
  max-width: 750rpx;
  min-height: 100vh;
  flex-direction: column;
}

// 顶部导航栏
.top-header {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 32rpx;
  padding-top: calc(var(--status-bar-height) + 24rpx);
  backdrop-filter: blur(32rpx);
  backdrop-filter: blur(32rpx);

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
  padding: 32rpx 48rpx;
  padding-bottom: calc(32rpx + env(safe-area-inset-bottom));
  margin: 0 auto;
  max-width: 750rpx;
  background: $glass-bg;
  box-shadow: 0 -10rpx 40rpx rgb(0 0 0 / 3%);
  backdrop-filter: blur(32rpx);
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

    &.cancel-btn {
      color: $text-sub;
      background: rgb(255 255 255 / 60%);
      border: 1rpx solid rgb(229 231 235);
      flex: 1;
      backdrop-filter: blur(16rpx);
    }

    &.submit-btn {
      color: #fff;
      background: linear-gradient(to right, $primary, $primary-dark);
      box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 30%);
      flex: 2;
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
.date-picker-view {
  width: 100%;
  height: 400rpx;
  background: #fff;
}

// 日期范围选择弹窗样式
.date-range-picker-popup {
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
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    padding: 32rpx 48rpx !important;
    width: 100% !important;
    background: #fff !important;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%) !important;
    box-sizing: border-box !important;

    .picker-popup-btn {
      display: flex !important;
      justify-content: center !important;
      align-items: center !important;
      padding: 8rpx 16rpx !important;
      font-size: 32rpx !important;
      transition: all 0.2s;
      font-weight: 500 !important;

      &.cancel-btn {
        color: #6b7280 !important;

        &:active {
          color: #111817 !important;
        }
      }

      &.confirm-btn {
        color: #0adbc3 !important;
        font-weight: 600 !important;

        &:active {
          color: #08bda8 !important;
        }
      }
    }

    .picker-popup-title {
      display: block !important;
      font-size: 36rpx !important;
      text-align: center !important;
      color: #111817 !important;
      flex: 1 !important;
      font-weight: 700 !important;
    }
  }

  .picker-popup-content {
    overflow-y: auto;
    padding: 0;
    max-height: calc(80vh - 200rpx);
  }

  .date-range-tabs {
    display: flex;
    padding: 0 48rpx;
    border-bottom: 1rpx solid rgb(229 231 235 / 50%);
    margin-bottom: 24rpx;

    .date-tab {
      padding: 24rpx 0;
      font-size: 28rpx;
      text-align: center;
      color: #6b7280;
      transition: all 0.2s;
      flex: 1;
      border-bottom: 2rpx solid transparent;

      &.active {
        color: #0adbc3;
        font-weight: 700;
        border-bottom-color: #0adbc3;
      }
    }
  }

  .date-picker-view {
    width: 100%;
    height: 400rpx;
    background: #fff;
  }

  picker-view {
    width: 100%;
    height: 100%;
    background: #fff;
  }

  picker-view-column {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
  }

  // 未选中项 - 浅灰色
  :deep(.picker-view-item) {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    font-size: 32rpx;
    color: #9ca3af;
    transition: all 0.3s;
    line-height: 1.5;
    font-weight: 400;
  }

  // 选中项 - 深色字体，突出显示
  :deep(.picker-view-item-selected) {
    font-size: 32rpx;
    color: #111817 !important;
    font-weight: 600 !important;
  }
}

// 全局 Picker View 样式（微信小程序）
picker-view {
  width: 100%;
  height: 100%;
  background: #fff;
}

picker-view-column {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

picker-view .picker-view-item {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  font-size: 32rpx;
  color: #111817;
  transition: all 0.3s;
}

// 选中项样式
picker-view .picker-view-item-selected {
  font-size: 36rpx;
  color: #0adbc3;
  font-weight: 700;
}

// 签名弹窗样式
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
    font-size: 36rpx;
    font-weight: 700;
    color: #111817;
  }

  .modal-close {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 64rpx;
    height: 64rpx;
    border-radius: 50%;

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
    font-size: 32rpx;
    border-radius: 24rpx;
    transition: all 0.2s;
    flex: 1;
    font-weight: 700;

    &:active {
      transform: scale(0.95);
    }

    &.clear-btn {
      color: #6b7280;
      background: rgb(229 231 235);
    }

    &.confirm-btn {
      color: #fff;
      background: linear-gradient(to right, #0adbc3, #08bda8);
      box-shadow: 0 8rpx 24rpx rgb(10 219 195 / 30%);
    }
  }
}

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
