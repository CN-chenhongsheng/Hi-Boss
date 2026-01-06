/**
 * API 接口类型定义
 */

/**
 * 统一响应格式
 */
export interface ApiResponse<T = any> {
  code: number
  message?: string
  msg?: string
  data: T
}

/**
 * 登录请求参数
 */
export interface LoginParams {
  username: string
  password: string
}

/**
 * 登录响应数据
 */
export interface LoginResponse {
  token: string
  userInfo?: UserInfo
}

/**
 * 用户信息
 */
export interface UserInfo {
  userId: number
  username: string
  nickname?: string
  avatar?: string
  phone?: string
  email?: string
  [key: string]: any
}

/**
 * 用户详细信息
 */
export interface UserProfile extends UserInfo {
  deptId?: number
  deptName?: string
  roleIds?: number[]
  roleNames?: string[]
  [key: string]: any
}

/**
 * 修改密码参数
 */
export interface ChangePasswordParams {
  oldPassword: string
  newPassword: string
}

/**
 * 分页查询参数
 */
export interface PageParams {
  pageNum?: number
  pageSize?: number
  [key: string]: any
}

/**
 * 分页响应数据
 */
export interface PageResult<T> {
  list: T[]
  total: number
  pageNum: number
  pageSize: number
}
