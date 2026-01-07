/**
 * 报修API
 * @module api/service/repair
 */

import { get, post } from '@/utils/request';
import type {
  IRepair,
  IRepairHandleParams,
  IRepairPageResult,
  IRepairQueryParams,
  IRepairRatingParams,
  IRepairSubmitParams,
} from '@/types';

/**
 * 获取报修分页列表
 */
export function getRepairPageAPI(params: IRepairQueryParams) {
  return get<IRepairPageResult>({
    url: '/api/v1/service/repair/page',
    data: params,
  });
}

/**
 * 获取报修详情
 */
export function getRepairDetailAPI(id: number) {
  return get<IRepair>({
    url: `/api/v1/service/repair/${id}`,
  });
}

/**
 * 提交报修
 */
export function submitRepairAPI(data: IRepairSubmitParams) {
  return post({
    url: '/api/v1/service/repair',
    data,
  });
}

/**
 * 更新报修
 */
export function updateRepairAPI(id: number, data: Partial<IRepairSubmitParams>) {
  return post({
    url: `/api/v1/service/repair/${id}`,
    data,
  });
}

/**
 * 删除报修
 */
export function deleteRepairAPI(id: number) {
  return post({
    url: `/api/v1/service/repair/${id}/delete`,
  });
}

/**
 * 处理报修
 */
export function handleRepairAPI(data: IRepairHandleParams) {
  return post({
    url: '/api/v1/service/repair/handle',
    data,
  });
}

/**
 * 评价报修
 */
export function rateRepairAPI(data: IRepairRatingParams) {
  return post({
    url: '/api/v1/service/repair/rate',
    data,
  });
}

/**
 * 上传图片
 */
export function uploadImageAPI(filePath: string) {
  return new Promise<string>((resolve, reject) => {
    uni.uploadFile({
      url: `${import.meta.env.VITE_APP_BASE_API}/api/v1/common/upload`,
      filePath,
      name: 'file',
      success: (res) => {
        if (res.statusCode === 200) {
          const data = JSON.parse(res.data);
          resolve(data.data);
        }
        else {
          reject(new Error('上传失败'));
        }
      },
      fail: reject,
    });
  });
}
