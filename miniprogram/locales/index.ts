/**
 * Vue I18n 国际化配置
 */
import { createI18n } from 'vue-i18n'
import zhCN from './lang/zh-CN'
import enUS from './lang/en-US'
import storage from '@/utils/storage'
import config from '@/utils/config'

// 获取存储的语言设置，默认为中文
const savedLanguage = storage.get<string>(config.languageKey) || config.defaultLanguage

const i18n = createI18n({
  locale: savedLanguage,
  fallbackLocale: 'zh-CN',
  messages: {
    'zh-CN': zhCN,
    'en-US': enUS
  },
  legacy: false, // 使用 Composition API 模式
  globalInjection: true // 全局注入 $t
})

export default i18n
