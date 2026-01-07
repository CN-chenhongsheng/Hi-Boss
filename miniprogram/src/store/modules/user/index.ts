/**
 * 用户状态管理
 * @module store/modules/user
 */

import { defineStore } from 'pinia';
import type { UserState, providerType } from './types';
import type { ILoginParams, IUser, UserRole } from '@/types';
import { getUserInfoAPI, loginAPI, logoutAPI, wxLoginAPI } from '@/api';
import { clearToken, getToken, setToken } from '@/utils/auth';
import { USE_MOCK, getMockUserByRole, mockLoginResponse } from '@/mock';

const useUserStore = defineStore('user', {
  state: (): UserState => ({
    userInfo: null,
    token: getToken() || '',
    refreshToken: '',
    isLoggedIn: false,
  }),

  getters: {
    /**
     * 用户角色
     */
    userRole(state): UserRole | undefined {
      return state.userInfo?.role;
    },

    /**
     * 是否是学生
     */
    isStudent(state): boolean {
      return state.userInfo?.role === 'student';
    },

    /**
     * 是否是宿管员
     */
    isDormManager(state): boolean {
      return state.userInfo?.role === 'dorm_manager';
    },

    /**
     * 是否是管理员
     */
    isAdmin(state): boolean {
      return state.userInfo?.role === 'admin';
    },

    /**
     * 是否有管理权限（宿管员或管理员）
     */
    hasManagePermission(state): boolean {
      return state.userInfo?.role === 'dorm_manager' || state.userInfo?.role === 'admin';
    },
  },

  actions: {
    /**
     * 设置用户信息
     */
    setUserInfo(userInfo: IUser) {
      this.userInfo = userInfo;
      this.isLoggedIn = true;
    },

    /**
     * 设置Token
     */
    setToken(token: string, refreshToken?: string) {
      this.token = token;
      if (refreshToken) {
        this.refreshToken = refreshToken;
      }
      setToken(token);
    },

    /**
     * 重置用户信息
     */
    resetInfo() {
      this.userInfo = null;
      this.token = '';
      this.refreshToken = '';
      this.isLoggedIn = false;
      clearToken();
    },

    /**
     * 用户名密码登录
     */
    async login(loginForm: ILoginParams) {
      try {
        // Mock数据模式
        if (USE_MOCK) {
          const mockData = mockLoginResponse;
          this.setToken(mockData.accessToken, mockData.refreshToken);
          this.setUserInfo(mockData.userInfo);
          return mockData;
        }

        // 真实API调用
        const res = await loginAPI(loginForm);
        this.setToken(res.accessToken, res.refreshToken);
        this.setUserInfo(res.userInfo);
        return res;
      }
      catch (error) {
        console.error('登录失败:', error);
        throw error;
      }
    },

    /**
     * 微信小程序授权登录
     */
    async wxLogin(provider: providerType = 'weixin') {
      return new Promise((resolve, reject) => {
        uni.login({
          provider,
          success: async (result: UniApp.LoginRes) => {
            try {
              if (result.code) {
                // Mock数据模式
                if (USE_MOCK) {
                  const mockData = mockLoginResponse;
                  this.setToken(mockData.accessToken, mockData.refreshToken);
                  this.setUserInfo(mockData.userInfo);
                  resolve(mockData);
                  return;
                }

                // 真实API调用
                const res = await wxLoginAPI(result.code);
                this.setToken(res.accessToken, res.refreshToken);
                this.setUserInfo(res.userInfo);
                resolve(res);
              }
              else {
                reject(new Error(result.errMsg));
              }
            }
            catch (error) {
              console.error('微信登录失败:', error);
              reject(error);
            }
          },
          fail: (err: any) => {
            console.error('微信登录失败:', err);
            reject(err);
          },
        });
      });
    },

    /**
     * 获取用户信息
     */
    async getUserInfo() {
      try {
        // Mock数据模式
        if (USE_MOCK) {
          const mockUser = getMockUserByRole('student');
          this.setUserInfo(mockUser);
          return mockUser;
        }

        // 真实API调用
        const userInfo = await getUserInfoAPI();
        this.setUserInfo(userInfo);
        return userInfo;
      }
      catch (error) {
        console.error('获取用户信息失败:', error);
        throw error;
      }
    },

    /**
     * 登出
     */
    async logout() {
      try {
        if (!USE_MOCK) {
          await logoutAPI();
        }
        this.resetInfo();
      }
      catch (error) {
        console.error('登出失败:', error);
        // 即使登出失败也清除本地信息
        this.resetInfo();
        throw error;
      }
    },

    /**
     * 检查登录状态
     */
    async checkLoginStatus() {
      if (this.token && !this.userInfo) {
        try {
          await this.getUserInfo();
        }
        catch (error) {
          // Token无效，清除登录状态
          this.resetInfo();
        }
      }
      return this.isLoggedIn;
    },
  },

  // 持久化配置
  persist: {
    key: 'user-store',
    paths: ['userInfo', 'token', 'refreshToken', 'isLoggedIn'],
  },
});

export default useUserStore;
