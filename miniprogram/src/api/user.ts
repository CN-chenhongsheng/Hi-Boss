/**
 * 用户API
 * @module api/user
 */

import { get, post } from '@/utils/request';
import type { IUser, IUserPageResult, IUserQueryParams } from '@/types';

/**
 * 获取当前用户信息
 */
export function getUserInfoAPI() {
  return get<IUser>({
    url: '/api/v1/user/info',
  });
}

/**
 * 更新用户信息
 */
export function updateUserInfoAPI(data: Partial<IUser>) {
  return post({
    url: '/api/v1/user/update',
    data,
  });
}

/**
 * 获取用户分页列表
 */
export function getUserPageAPI(params: IUserQueryParams) {
  return get<IUserPageResult>({
    url: '/api/v1/user/page',
    data: params,
  });
}

/**
 * 修改密码
 */
export function changePasswordAPI(data: { oldPassword: string; newPassword: string }) {
  return post({
    url: '/api/v1/user/change-password',
    data,
  });
}
