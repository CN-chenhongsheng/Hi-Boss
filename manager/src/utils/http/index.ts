/**
 * HTTP 请求封装模块
 * 基于 Axios 封装的 HTTP 请求工具，提供统一的请求/响应处理
 *
 * ## 主要功能
 *
 * - 请求/响应拦截器（自动添加 Token、统一错误处理）
 * - 401 未授权自动登出（带防抖机制）
 * - 请求失败自动重试（可配置）
 * - 统一的成功/错误消息提示
 * - 支持 GET/POST/PUT/DELETE 等常用方法
 *
 * @module utils/http
 * @author HongSheng_Chen Team
 */

import axios, {
  AxiosRequestConfig,
  AxiosError,
  AxiosResponse,
  InternalAxiosRequestConfig
} from 'axios'
import { useUserStore } from '@/store/modules/user'
import { ApiStatus } from './status'
import { HttpError, handleError, showError, showSuccess, ErrorResponse } from './error'
import { $t } from '@/locales'
import { BaseResponse } from '@/types'
import { fetchLogout, fetchRefreshToken } from '@/api/auth'

/** 请求配置常量 */
const REQUEST_TIMEOUT = 15000
const LOGOUT_DELAY = 500
const MAX_RETRIES = 0
const RETRY_DELAY = 1000
const UNAUTHORIZED_DEBOUNCE_TIME = 3000

/** 401防抖状态 */
let isUnauthorizedErrorShown = false
let unauthorizedTimer: NodeJS.Timeout | null = null

/** Token 刷新相关状态 */
let isRefreshing = false // 是否正在刷新 Token
let failedQueue: Array<{
  resolve: (value?: any) => void
  reject: (error?: any) => void
}> = [] // 等待刷新完成的请求队列

/** 扩展 AxiosRequestConfig */
interface ExtendedAxiosRequestConfig extends AxiosRequestConfig {
  showErrorMessage?: boolean
  showSuccessMessage?: boolean
  /** 自定义成功提示消息，如果设置了则优先使用，否则使用后端返回的 message */
  successMessage?: string
}

const { VITE_API_URL, VITE_WITH_CREDENTIALS } = import.meta.env

/** Axios实例 */
const axiosInstance = axios.create({
  timeout: REQUEST_TIMEOUT,
  baseURL: VITE_API_URL,
  withCredentials: VITE_WITH_CREDENTIALS === 'true',
  validateStatus: (status) => status >= 200 && status < 300,
  transformResponse: [
    (data, headers) => {
      const contentType = headers['content-type']
      if (contentType?.includes('application/json')) {
        try {
          return JSON.parse(data)
        } catch {
          return data
        }
      }
      return data
    }
  ]
})

/** 请求拦截器 */
axiosInstance.interceptors.request.use(
  (request: InternalAxiosRequestConfig) => {
    const { accessToken } = useUserStore()
    // 使用 Bearer 格式发送 Access Token
    if (accessToken) {
      request.headers.set('Authorization', `Bearer ${accessToken}`)
    }

    if (request.data && !(request.data instanceof FormData) && !request.headers['Content-Type']) {
      request.headers.set('Content-Type', 'application/json')
      request.data = JSON.stringify(request.data)
    }

    return request
  },
  (error) => {
    showError(createHttpError($t('httpMsg.requestConfigError'), ApiStatus.error))
    return Promise.reject(error)
  }
)

/** 响应拦截器 */
axiosInstance.interceptors.response.use(
  (response: AxiosResponse<BaseResponse>) => {
    const { code, message, msg } = response.data
    // 使用 message 或 msg（兼容旧格式）
    const responseMsg = message || msg || ''

    if (code === ApiStatus.success) return response
    if (code === ApiStatus.unauthorized) {
      // 尝试刷新 Token
      return handleTokenRefresh(response.config).catch(() => {
        handleUnauthorizedError(responseMsg)
        throw createHttpError(responseMsg || $t('httpMsg.unauthorized'), code)
      })
    }
    throw createHttpError(responseMsg || $t('httpMsg.requestFailed'), code)
  },
  async (error: AxiosError<ErrorResponse>) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean }

    // 如果是 401 错误且不是刷新 Token 的请求，尝试刷新 Token
    if (
      error.response?.status === ApiStatus.unauthorized &&
      originalRequest &&
      !originalRequest._retry
    ) {
      // 排除刷新接口本身，避免无限循环
      if (originalRequest.url?.includes('/auth/refresh')) {
        handleUnauthorizedError()
        return Promise.reject(handleError(error))
      }

      try {
        return await handleTokenRefresh(originalRequest)
      } catch {
        handleUnauthorizedError()
        return Promise.reject(handleError(error))
      }
    }

    return Promise.reject(handleError(error))
  }
)

/** 统一创建HttpError */
function createHttpError(message: string, code: number) {
  return new HttpError(message, code)
}

/**
 * 处理 Token 刷新
 * @param originalRequest 原始请求配置
 * @returns 重试后的响应
 */
async function handleTokenRefresh(
  originalRequest: InternalAxiosRequestConfig & { _retry?: boolean }
): Promise<AxiosResponse> {
  // 如果正在刷新，将请求加入队列等待
  if (isRefreshing) {
    return new Promise((resolve, reject) => {
      failedQueue.push({ resolve, reject })
    }).then(() => {
      // 刷新完成后，使用新的 Token 重试原请求
      return axiosInstance.request(originalRequest)
    })
  }

  // 标记正在刷新
  isRefreshing = true
  originalRequest._retry = true

  try {
    // 调用刷新接口
    const newAccessToken = await fetchRefreshToken()

    // 更新 store 中的 Access Token
    const userStore = useUserStore()
    userStore.setToken(newAccessToken)

    // 处理队列中的请求
    failedQueue.forEach(({ resolve }) => resolve())
    failedQueue = []

    // 使用新的 Token 重试原请求
    originalRequest.headers = originalRequest.headers || {}
    originalRequest.headers['Authorization'] = `Bearer ${newAccessToken}`

    return axiosInstance.request(originalRequest)
  } catch (error) {
    // 刷新失败，拒绝队列中的所有请求
    failedQueue.forEach(({ reject }) => reject(error))
    failedQueue = []
    throw error
  } finally {
    isRefreshing = false
  }
}

/** 处理401错误（带防抖） */
function handleUnauthorizedError(message?: string): never {
  const error = createHttpError(message || $t('httpMsg.unauthorized'), ApiStatus.unauthorized)

  if (!isUnauthorizedErrorShown) {
    isUnauthorizedErrorShown = true
    logOut()

    unauthorizedTimer = setTimeout(resetUnauthorizedError, UNAUTHORIZED_DEBOUNCE_TIME)

    showError(error, true)
    throw error
  }

  throw error
}

/** 重置401防抖状态 */
function resetUnauthorizedError() {
  isUnauthorizedErrorShown = false
  if (unauthorizedTimer) clearTimeout(unauthorizedTimer)
  unauthorizedTimer = null
}

/** 退出登录函数 */
function logOut() {
  const userStore = useUserStore()
  const userId = userStore.info.userId
  const token = userStore.accessToken

  // 如果有 token，尝试调用 logout API 通知服务器用户离线
  if (token && userId) {
    fetchLogout().catch(() => {
      // 即使失败也继续执行清理，不阻塞退出流程
      console.warn('[HTTP] Logout API call failed in interceptor')
    })
  }

  setTimeout(() => {
    userStore.logOut()
  }, LOGOUT_DELAY)
}

/** 是否需要重试 */
function shouldRetry(statusCode: number) {
  return [
    ApiStatus.requestTimeout,
    ApiStatus.internalServerError,
    ApiStatus.badGateway,
    ApiStatus.serviceUnavailable,
    ApiStatus.gatewayTimeout
  ].includes(statusCode)
}

/** 请求重试逻辑 */
async function retryRequest<T>(
  config: ExtendedAxiosRequestConfig,
  retries: number = MAX_RETRIES
): Promise<T> {
  try {
    return await request<T>(config)
  } catch (error) {
    if (retries > 0 && error instanceof HttpError && shouldRetry(error.code)) {
      await delay(RETRY_DELAY)
      return retryRequest<T>(config, retries - 1)
    }
    throw error
  }
}

/** 延迟函数 */
function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

/** 请求函数 */
async function request<T = any>(config: ExtendedAxiosRequestConfig): Promise<T> {
  // POST | PUT 参数自动填充
  if (
    ['POST', 'PUT'].includes(config.method?.toUpperCase() || '') &&
    config.params &&
    !config.data
  ) {
    config.data = config.params
    config.params = undefined
  }

  try {
    const res = await axiosInstance.request<BaseResponse<T>>(config)

    // 显示成功消息（优先使用自定义消息，否则使用后端返回的消息）
    if (config.showSuccessMessage) {
      const successMsg = config.successMessage || res.data.message || res.data.msg || '操作成功'
      showSuccess(successMsg)
    }

    return res.data.data as T
  } catch (error) {
    if (error instanceof HttpError && error.code !== ApiStatus.unauthorized) {
      const showMsg = config.showErrorMessage !== false
      showError(error, showMsg)
    }
    return Promise.reject(error)
  }
}

/** API方法集合 */
const api = {
  get<T>(config: ExtendedAxiosRequestConfig) {
    return retryRequest<T>({ ...config, method: 'GET' })
  },
  post<T>(config: ExtendedAxiosRequestConfig) {
    return retryRequest<T>({ ...config, method: 'POST' })
  },
  put<T>(config: ExtendedAxiosRequestConfig) {
    return retryRequest<T>({ ...config, method: 'PUT' })
  },
  del<T>(config: ExtendedAxiosRequestConfig) {
    return retryRequest<T>({ ...config, method: 'DELETE' })
  },
  request<T>(config: ExtendedAxiosRequestConfig) {
    return retryRequest<T>(config)
  }
}

export default api
