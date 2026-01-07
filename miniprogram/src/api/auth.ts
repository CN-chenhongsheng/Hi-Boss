/**
 * 认证授权API
 * @module api/auth
 */

import { post } from '@/utils/request';
import type { ILoginParams, ILoginResponse } from '@/types';

/**
 * 用户登录
 */
export function loginAPI(data: ILoginParams) {
  return post<ILoginResponse>({
    url: '/api/v1/auth/login',
    data,
  });
}

/**
 * 用户登出
 */
export function logoutAPI() {
  return post({
    url: '/api/v1/auth/logout',
  });
}

/**
 * 刷新token
 */
export function refreshTokenAPI(refreshToken: string) {
  return post<ILoginResponse>({
    url: '/api/v1/auth/refresh',
    data: { refreshToken },
  });
}

/**
 * 微信小程序登录
 */
export function wxLoginAPI(code: string) {
  return post<ILoginResponse>({
    url: '/api/v1/auth/wx-login',
    data: { code },
  });
}
