import type { IApplyFormData } from '@/types';
import { useFormValidation } from '@/composables/useFormValidation';
import { submitCheckInAPI } from '@/api/accommodation/check-in';
import { submitTransferAPI } from '@/api/accommodation/transfer';
import { submitCheckOutAPI } from '@/api/accommodation/check-out';
import { submitStayAPI } from '@/api/accommodation/stay';

export function useApplyFormActions(formData: IApplyFormData) {
  const { validateForm } = useFormValidation();

  // 提交
  async function handleSubmit(): Promise<void> {
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

  return {
    handleSubmit,
  };
}
