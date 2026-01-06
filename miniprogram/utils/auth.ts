/**
 * 认证相关工具函数
 */
import request from './request'
import storage from './storage'
import config from './config'
import type { LoginParams, LoginResponse, UserInfo } from '@/types/api'

export default {
  /**
   * 登录
   * @param username 用户名
   * @param password 密码
   * @returns 登录响应数据
   */
  async login(username: string, password: string): Promise<LoginResponse> {
    try {
      const data = await request.post<LoginResponse>('/v1/auth/login', {
        username,
        password
      } as LoginParams)

      // 保存 token 和用户信息
      if (data.token) {
        storage.set(config.tokenKey, data.token)
      }
      if (data.userInfo) {
        storage.set(config.userInfoKey, data.userInfo)
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
      await request.post('/v1/auth/logout')
    } catch (error) {
      console.error('登出失败:', error)
    } finally {
      // 清除本地存储
      storage.remove(config.tokenKey)
      storage.remove(config.userInfoKey)
    }
  },

  /**
   * 获取当前用户信息
   */
  async getUserInfo(): Promise<UserInfo> {
    try {
      const data = await request.get<UserInfo>('/v1/auth/userinfo')
      if (data) {
        storage.set(config.userInfoKey, data)
      }
      return data
    } catch (error) {
      throw error
    }
  },

  /**
   * 检查是否已登录
   * @returns 是否已登录
   */
  isLoggedIn(): boolean {
    const token = storage.get<string>(config.tokenKey)
    return !!token
  },

  /**
   * 获取 token
   * @returns token 字符串或 null
   */
  getToken(): string | null {
    return storage.get<string>(config.tokenKey)
  },

  /**
   * 获取用户信息（从本地存储）
   * @returns 用户信息或 null
   */
  getUserInfoFromStorage(): UserInfo | null {
    return storage.get<UserInfo>(config.userInfoKey)
  }
}
