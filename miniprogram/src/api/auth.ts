/**
 * 认证授权API
 * @module api/auth
 */

import { post } from '@/utils/request';
import type { ILoginParams, IStudent } from '@/types';

/**
 * 后端登录响应（统一格式，对应后端 LoginVO）
 */
export interface IBackendLoginResponse {
  token: string;
  userId: number;
  username: string;
  nickname?: string;
  avatar?: string;
  role: string;
  studentInfo?: IStudent;
}

/**
 * 用户登录（管理员/宿管员）
 */
export function loginAPI(data: ILoginParams) {
  return post<IBackendLoginResponse>({
    url: '/api/v1/auth/login',
    data,
  });
}

/**
 * 学生登录（学号+密码）
 */
export function studentLoginAPI(data: { studentNo: string; password: string }) {
  return post<IBackendLoginResponse>({
    url: '/api/v1/auth/student/login',
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
  return post<IBackendLoginResponse>({
    url: '/api/v1/auth/refresh',
    data: { refreshToken },
  });
}

/**
 * 微信小程序登录
 */
export function wxLoginAPI(code: string) {
  return post<IBackendLoginResponse>({
    url: '/api/v1/auth/wx-login',
    data: { code },
  });
}
