/**
 * 表单验证组合式函数
 */

import type { IApplyFormData } from '@/types';

/**
 * 验证正常入住申请
 */
export function validateNormalCheckIn(formData: IApplyFormData): boolean {
  if (!formData.reason || formData.reason.trim() === '') {
    uni.showToast({
      title: '请输入申请原因',
      icon: 'none',
    });
    return false;
  }
  return true;
}

/**
 * 验证临时入住申请
 */
export function validateTempCheckIn(formData: IApplyFormData): boolean {
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

  // 验证手机号格式
  const phoneReg = /^1[3-9]\d{9}$/;
  if (!phoneReg.test(formData.parentPhone.trim())) {
    uni.showToast({
      title: '请输入正确的手机号',
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

  // 验证日期范围
  const startDate = new Date(formData.stayStartDate);
  const endDate = new Date(formData.stayEndDate);
  if (endDate < startDate) {
    uni.showToast({
      title: '结束日期不能早于开始日期',
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

  return true;
}

/**
 * 验证调宿申请
 */
export function validateTransfer(formData: IApplyFormData): boolean {
  if (!formData.reason || formData.reason.trim() === '') {
    uni.showToast({
      title: '请输入申请原因',
      icon: 'none',
    });
    return false;
  }
  return true;
}

/**
 * 验证退宿申请
 */
export function validateCheckOut(formData: IApplyFormData): boolean {
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

  return true;
}

/**
 * 验证留宿申请
 */
export function validateStay(formData: IApplyFormData): boolean {
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

  // 验证手机号格式
  const phoneReg = /^1[3-9]\d{9}$/;
  if (!phoneReg.test(formData.parentPhone.trim())) {
    uni.showToast({
      title: '请输入正确的手机号',
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

  // 验证日期范围
  const startDate = new Date(formData.stayStartDate);
  const endDate = new Date(formData.stayEndDate);
  if (endDate < startDate) {
    uni.showToast({
      title: '结束日期不能早于开始日期',
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

  return true;
}

/**
 * 验证表单
 */
export function useFormValidation() {
  const validateForm = (formData: IApplyFormData): boolean => {
    // 基础验证
    if (!formData.applyType) {
      uni.showToast({
        title: '请选择申请类型',
        icon: 'none',
      });
      return false;
    }

    // 根据申请类型执行对应的验证
    switch (formData.applyType) {
      case 'normalCheckIn':
        return validateNormalCheckIn(formData);
      case 'tempCheckIn':
        return validateTempCheckIn(formData);
      case 'transfer':
        return validateTransfer(formData);
      case 'checkOut':
        return validateCheckOut(formData);
      case 'stay':
        return validateStay(formData);
      default:
        uni.showToast({
          title: '未知的申请类型',
          icon: 'none',
        });
        return false;
    }
  };

  return {
    validateForm,
  };
}
