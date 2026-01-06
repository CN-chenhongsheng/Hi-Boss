import App from './App'

// #ifndef VUE3
import Vue from 'vue'
import './uni.promisify.adaptor'
Vue.config.productionTip = false
App.mpType = 'app'
const app = new Vue({
  ...App
})
app.$mount()
// #endif

// #ifdef VUE3
import { createSSRApp } from 'vue'
import pinia from './store/index'
import i18n from './locales/index'

export function createApp() {
  const app = createSSRApp(App)

  // 使用 Pinia
  app.use(pinia)

  // 使用 Vue I18n
  app.use(i18n)

  return {
    app
  }
}
// #endif
