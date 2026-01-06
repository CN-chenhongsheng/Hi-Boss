/**
 * Store 状态类型定义
 */

import type { UserInfo } from './api'

/**
 * 用户状态
 */
export interface UserState {
  accessToken: string
  userInfo: UserInfo | null
}

/**
 * 应用状态
 */
export interface AppState {
  language: string
  theme: string
}
