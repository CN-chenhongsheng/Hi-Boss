/**
 * HTTP 请求封装
 * 统一处理 token、错误处理、loading 等
 */
import config from './config'
import storage from './storage'
import type { ApiResponse } from '@/types/api'

interface RequestOptions extends UniApp.RequestOptions {
  showLoading?: boolean
  loadingText?: string
  showErrorMessage?: boolean
}

class Request {
  private baseURL: string
  private timeout: number

  constructor() {
    this.baseURL = config.baseURL
    this.timeout = config.timeout
  }

  /**
   * 请求拦截器 - 添加 token
   */
  private interceptRequest(options: RequestOptions): RequestOptions {
    // 添加 token
    const token = storage.get<string>(config.tokenKey)
    if (token) {
      options.header = options.header || {}
      options.header['Authorization'] = token
    }

    // 设置默认 header
    if (!options.header) {
      options.header = {}
    }
    if (!options.header['Content-Type']) {
      options.header['Content-Type'] = 'application/json'
    }

    return options
  }

  /**
   * 响应拦截器 - 统一处理响应
   */
  private interceptResponse<T = any>(response: UniApp.RequestSuccessCallbackResult): Promise<T> {
    const { statusCode, data } = response

    // HTTP 状态码错误
    if (statusCode !== 200) {
      return Promise.reject(new Error(`请求失败: ${statusCode}`))
    }

    const responseData = data as ApiResponse<T>

    // 业务状态码处理
    if (responseData.code === 200) {
      return Promise.resolve(responseData.data)
    } else if (responseData.code === 401) {
      // Token 过期，跳转登录
      this.handleUnauthorized(responseData.message)
      return Promise.reject(new Error(responseData.message || '登录已过期'))
    } else {
      // 其他错误
      const errorMsg = responseData.message || responseData.msg || '请求失败'
      uni.showToast({
        title: errorMsg,
        icon: 'none',
        duration: 2000
      })
      return Promise.reject(new Error(errorMsg))
    }
  }

  /**
   * 处理 401 未授权
   */
  private handleUnauthorized(message?: string): void {
    // 清除 token 和用户信息
    storage.remove(config.tokenKey)
    storage.remove(config.userInfoKey)

    // 跳转到登录页
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    const route = currentPage ? currentPage.route : ''

    // 如果当前不在登录页，则跳转
    if (!route.includes('login')) {
      uni.reLaunch({
        url: '/pages/login/login'
      })
    }

    if (message) {
      uni.showToast({
        title: message || '登录已过期，请重新登录',
        icon: 'none',
        duration: 2000
      })
    }
  }

  /**
   * 通用请求方法
   */
  private request<T = any>(options: RequestOptions): Promise<T> {
    return new Promise((resolve, reject) => {
      // 处理请求
      const processedOptions = this.interceptRequest(options)
      processedOptions.url = this.baseURL + processedOptions.url

      // 显示 loading（可选）
      if (processedOptions.showLoading !== false) {
        uni.showLoading({
          title: processedOptions.loadingText || '加载中...',
          mask: true
        })
      }

      // 发起请求
      uni.request({
        ...processedOptions,
        timeout: this.timeout,
        success: (response) => {
          uni.hideLoading()
          this.interceptResponse<T>(response).then(resolve).catch(reject)
        },
        fail: (error) => {
          uni.hideLoading()
          let errorMsg = '网络请求失败'

          // 处理不同的错误类型
          if (error.errMsg) {
            if (error.errMsg.includes('timeout')) {
              errorMsg = '请求超时，请稍后重试'
            } else if (error.errMsg.includes('fail')) {
              errorMsg = '网络连接失败，请检查网络'
            }
          }

          uni.showToast({
            title: errorMsg,
            icon: 'none',
            duration: 2000
          })
          reject(error)
        }
      })
    })
  }

  /**
   * GET 请求
   */
  get<T = any>(
    url: string,
    params: Record<string, any> = {},
    options: RequestOptions = {}
  ): Promise<T> {
    return this.request<T>({
      url,
      method: 'GET',
      data: params,
      ...options
    })
  }

  /**
   * POST 请求
   */
  post<T = any>(
    url: string,
    data: Record<string, any> = {},
    options: RequestOptions = {}
  ): Promise<T> {
    return this.request<T>({
      url,
      method: 'POST',
      data,
      ...options
    })
  }

  /**
   * PUT 请求
   */
  put<T = any>(
    url: string,
    data: Record<string, any> = {},
    options: RequestOptions = {}
  ): Promise<T> {
    return this.request<T>({
      url,
      method: 'PUT',
      data,
      ...options
    })
  }

  /**
   * DELETE 请求
   */
  delete<T = any>(
    url: string,
    params: Record<string, any> = {},
    options: RequestOptions = {}
  ): Promise<T> {
    return this.request<T>({
      url,
      method: 'DELETE',
      data: params,
      ...options
    })
  }
}

// 导出单例
export default new Request()
