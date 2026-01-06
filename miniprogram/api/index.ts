/**
 * API 接口定义
 */
import request from '@/utils/request'
import type {
  LoginParams,
  LoginResponse,
  UserInfo,
  UserProfile,
  ChangePasswordParams,
  PageParams,
  PageResult
} from '@/types/api'

// 认证相关接口
export const authApi = {
  /**
   * 登录
   * @param params 登录参数
   */
  login(params: LoginParams): Promise<LoginResponse> {
    return request.post<LoginResponse>('/v1/auth/login', params)
  },

  /**
   * 登出
   */
  logout(): Promise<void> {
    return request.post('/v1/auth/logout')
  },

  /**
   * 获取当前用户信息
   */
  getUserInfo(): Promise<UserInfo> {
    return request.get<UserInfo>('/v1/auth/userinfo')
  }
}

// 用户相关接口
export const userApi = {
  /**
   * 获取用户个人信息（详细）
   */
  getProfile(): Promise<UserProfile> {
    return request.get<UserProfile>('/v1/user/profile')
  },

  /**
   * 更新用户个人信息
   * @param data 用户信息数据
   */
  updateProfile(data: Partial<UserProfile>): Promise<void> {
    return request.put('/v1/user/profile', data)
  },

  /**
   * 修改密码
   * @param data 密码信息
   */
  changePassword(data: ChangePasswordParams): Promise<void> {
    return request.put('/v1/user/profile/password', data)
  }
}

// 住宿相关接口（示例，根据实际后端接口调整）
export const accommodationApi = {
  /**
   * 获取住宿列表
   * @param params 查询参数
   */
  getList(params: PageParams): Promise<PageResult<any>> {
    return request.get<PageResult<any>>('/v1/accommodation/page', params)
  },

  /**
   * 获取住宿详情
   * @param id 住宿ID
   */
  getDetail(id: number): Promise<any> {
    return request.get(`/v1/accommodation/${id}`)
  },

  /**
   * 提交住宿申请
   * @param data 申请数据
   */
  apply(data: Record<string, any>): Promise<any> {
    return request.post('/v1/accommodation', data)
  }
}

export default {
  auth: authApi,
  user: userApi,
  accommodation: accommodationApi
}
