/**
 * 应用配置文件
 * API 地址、超时时间等配置
 */

// 环境配置
const config = {
  // 开发环境
  development: {
    baseURL: 'http://localhost:8080/api',
    timeout: 15000
  },
  // 生产环境
  production: {
    baseURL: 'https://your-domain.com/api', // 请替换为实际生产环境地址
    timeout: 15000
  }
}

// 获取当前环境
let env: 'development' | 'production' = 'development'
// #ifdef H5
// @ts-ignore
env = (process.env.NODE_ENV as 'development' | 'production') || 'development'
// #endif

const currentConfig = config[env] || config.development

export default {
  // API 基础地址
  baseURL: currentConfig.baseURL,
  // 请求超时时间
  timeout: currentConfig.timeout,
  // Token 存储 key
  tokenKey: 'accessToken',
  // 用户信息存储 key
  userInfoKey: 'userInfo',
  // 语言设置存储 key
  languageKey: 'language',
  // 默认语言
  defaultLanguage: 'zh-CN'
}
