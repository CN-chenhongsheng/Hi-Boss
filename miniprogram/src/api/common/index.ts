/**
 * 通用接口
 */
import type { SendCodeParams, SendCodeResult, UploadImageResult } from './types';
import { post } from '@/utils/request';
import { TokenPrefix, getToken } from '@/utils/auth';

enum URL {
  upload = '/common/upload',
  sendCode = '/sendCode',
  uploadSignature = '/api/v1/common/files/signature',
}

// 图片上传（旧接口，保留兼容）
export const uploadImage = (imagePath: string): Promise<UploadImageResult> => {
  return new Promise((resolve, reject) => {
    const token = getToken();
    uni.uploadFile({
      url: import.meta.env.VITE_APP_BASE_API + URL.upload,
      filePath: imagePath,
      name: 'file',
      header: {
        Authorization: TokenPrefix + token,
      },
      success: (res) => {
        try {
          const data = JSON.parse(res.data);
          if (data.code === 200) {
            resolve(data.data);
          }
          else {
            reject(new Error(data.message || '上传失败'));
          }
        }
        catch (e) {
          reject(e);
        }
      },
      fail: reject,
    });
  });
};

// 签名图片上传（新接口）
export const uploadSignatureAPI = (filePath: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    const token = getToken();
    const baseUrl = import.meta.env.VITE_APP_BASE_API || '';

    uni.uploadFile({
      url: baseUrl + URL.uploadSignature,
      filePath,
      name: 'file',
      header: {
        Authorization: TokenPrefix + token,
      },
      success: (res) => {
        if (res.statusCode !== 200) {
          reject(new Error(`HTTP ${res.statusCode}: 请求失败`));
          return;
        }

        try {
          const data = JSON.parse(res.data);
          if (data.code === 200) {
            resolve(data.data);
          }
          else {
            reject(new Error(data.message || '上传失败'));
          }
        }
        catch (e) {
          reject(new Error('服务器返回格式错误'));
        }
      },
      fail: (err) => {
        reject(new Error(err.errMsg || '上传失败'));
      },
    });
  });
};

// 发送验证码
export const sendCode = (data: SendCodeParams) => post<SendCodeResult>({ url: URL.sendCode, data });
