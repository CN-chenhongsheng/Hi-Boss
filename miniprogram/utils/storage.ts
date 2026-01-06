/**
 * 本地存储工具
 * 统一封装 uni.setStorageSync 和 uni.getStorageSync
 */

/**
 * 设置存储
 * @param key 键名
 * @param value 值
 */
export function setStorage(key: string, value: any): boolean {
  try {
    uni.setStorageSync(key, value)
    return true
  } catch (error) {
    console.error('存储失败:', error)
    return false
  }
}

/**
 * 获取存储
 * @param key 键名
 * @param defaultValue 默认值
 * @returns 存储的值
 */
export function getStorage<T = any>(key: string, defaultValue: T | null = null): T | null {
  try {
    const value = uni.getStorageSync(key)
    return value !== '' ? (value as T) : defaultValue
  } catch (error) {
    console.error('获取存储失败:', error)
    return defaultValue
  }
}

/**
 * 移除存储
 * @param key 键名
 */
export function removeStorage(key: string): boolean {
  try {
    uni.removeStorageSync(key)
    return true
  } catch (error) {
    console.error('移除存储失败:', error)
    return false
  }
}

/**
 * 清空所有存储
 */
export function clearStorage(): boolean {
  try {
    uni.clearStorageSync()
    return true
  } catch (error) {
    console.error('清空存储失败:', error)
    return false
  }
}

export default {
  set: setStorage,
  get: getStorage,
  remove: removeStorage,
  clear: clearStorage
}
