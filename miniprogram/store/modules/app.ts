/**
 * 应用状态模块
 */
import { defineStore } from 'pinia'
import storage from '@/utils/storage'
import config from '@/utils/config'
import type { AppState } from '@/types/store'

export const useAppStore = defineStore('app', {
  state: (): AppState => ({
    // 当前语言
    language: storage.get<string>(config.languageKey) || config.defaultLanguage,
    // 主题（预留）
    theme: 'light'
  }),

  getters: {
    // 当前语言
    currentLanguage: (state): string => state.language
  },

  actions: {
    /**
     * 设置语言
     * @param lang 语言代码，如 'zh-CN', 'en-US'
     */
    setLanguage(lang: string): void {
      this.language = lang
      storage.set(config.languageKey, lang)

      // 触发语言切换事件（如果需要）
      // uni.$emit('language-changed', lang)
    },

    /**
     * 设置主题（预留）
     * @param theme 主题，如 'light', 'dark'
     */
    setTheme(theme: string): void {
      this.theme = theme
      // 可以存储到本地
      // storage.set('theme', theme)
    }
  }
})
