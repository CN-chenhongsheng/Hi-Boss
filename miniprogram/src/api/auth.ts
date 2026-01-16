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
 * 用户登录
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

/**
 * 更新用户个人信息参数
 */
export interface IUpdateProfileParams {
  phone?: string;
  email?: string;
  emergencyContact?: string;
  emergencyPhone?: string;
  avatar?: string;
}

/**
 * 修改密码参数
 */
export interface IChangePasswordParams {
  oldPassword: string;
  newPassword: string;
  confirmPassword: string;
}

/**
 * 获取当前用户详情
 */
export function getUserProfileAPI() {
  return post<IBackendLoginResponse>({
    url: '/api/v1/auth/user/profile',
  });
}

/**
 * 更新用户个人信息
 */
export function updateUserProfileAPI(data: IUpdateProfileParams) {
  return post<{ success: boolean }>({
    url: '/api/v1/auth/user/profile/update',
    data,
  });
}

/**
 * 修改密码
 */
export function changePasswordAPI(data: IChangePasswordParams) {
  return post<{ success: boolean }>({
    url: '/api/v1/auth/change-password',
    data,
  });
}
