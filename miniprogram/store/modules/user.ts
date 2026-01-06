/**
 * 用户状态模块
 */
import { defineStore } from 'pinia'
import auth from '@/utils/auth'
import storage from '@/utils/storage'
import config from '@/utils/config'
import type { UserInfo, LoginResponse } from '@/types/api'
import type { UserState } from '@/types/store'

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    // 访问令牌
    accessToken: storage.get<string>(config.tokenKey) || '',
    // 用户信息
    userInfo: storage.get<UserInfo>(config.userInfoKey) || null
  }),

  getters: {
    // 是否已登录
    isLoggedIn: (state): boolean => !!state.accessToken,
    // 用户ID
    userId: (state): number | null => state.userInfo?.userId || null,
    // 用户名
    username: (state): string => state.userInfo?.username || '',
    // 昵称
    nickname: (state): string => state.userInfo?.nickname || ''
  },

  actions: {
    /**
     * 设置 token
     * @param token token 字符串
     */
    setToken(token: string): void {
      this.accessToken = token
      storage.set(config.tokenKey, token)
    },

    /**
     * 设置用户信息
     * @param userInfo 用户信息对象
     */
    setUserInfo(userInfo: UserInfo): void {
      this.userInfo = userInfo
      storage.set(config.userInfoKey, userInfo)
    },

    /**
     * 登录
     * @param username 用户名
     * @param password 密码
     */
    async login(username: string, password: string): Promise<LoginResponse> {
      try {
        const data = await auth.login(username, password)

        if (data.token) {
          this.setToken(data.token)
        }
        if (data.userInfo) {
          this.setUserInfo(data.userInfo)
        }

        return data
      } catch (error) {
        throw error
      }
    },

    /**
     * 登出
     */
    async logout(): Promise<void> {
      try {
        await auth.logout()
      } catch (error) {
        console.error('登出失败:', error)
      } finally {
        this.accessToken = ''
        this.userInfo = null
        storage.remove(config.tokenKey)
        storage.remove(config.userInfoKey)
      }
    },

    /**
     * 获取用户信息
     */
    async fetchUserInfo(): Promise<UserInfo> {
      try {
        const userInfo = await auth.getUserInfo()
        this.setUserInfo(userInfo)
        return userInfo
      } catch (error) {
        throw error
      }
    },

    /**
     * 清除用户信息（用于登出或 token 过期）
     */
    clearUserInfo(): void {
      this.accessToken = ''
      this.userInfo = null
      storage.remove(config.tokenKey)
      storage.remove(config.userInfoKey)
    }
  }
})
