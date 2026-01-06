/**
 * uni-app 扩展类型定义
 */

/**
 * uni.request 请求选项扩展
 */
interface UniRequestOptions {
  showLoading?: boolean
  loadingText?: string
  showErrorMessage?: boolean
}

/**
 * uni.request 响应扩展
 */
interface UniRequestResponse<T = any> {
  statusCode: number
  data: {
    code: number
    message?: string
    msg?: string
    data: T
  }
}
