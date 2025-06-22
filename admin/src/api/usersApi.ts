import request from '@/utils/http'
// import { BaseResult } from '@/types/axios'
import { BaseResponse, UserInfoResponse } from '@/types/api'

interface LoginParams {
  username: string
  password: string
  code: string
  uuid: string
}

// 验证码响应类型
interface CaptchaResponse extends BaseResponse {
  img: string
  uuid: string
  captchaEnabled: boolean
}

export class UserService {
  // 获取验证码
  static getCodeImg(): Promise<CaptchaResponse> {
    return request.get<CaptchaResponse>({
      url: '/captchaImage'
    })
  }

  // 登录接口
  static login(params: LoginParams): Promise<BaseResponse> {
    return request.post<BaseResponse>({
      url: '/login',
      params
    })
  }

  // 获取用户信息
  static getUserInfo(): Promise<UserInfoResponse> {
    return request.get<UserInfoResponse>({
      url: '/getUserInfo'
    })
  }

  // 登出接口
  static logout(): Promise<BaseResponse> {
    return request.get<BaseResponse>({
      url: '/logout'
    })
  }
}
