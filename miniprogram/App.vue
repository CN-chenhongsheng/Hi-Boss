<script setup lang="ts">
  import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'
  import { useUserStore } from '@/store/modules/user'
  import { useAppStore } from '@/store/modules/app'

  /**
   * 初始化应用
   */
  const initApp = () => {
    // 检查登录状态
    const userStore = useUserStore()
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const appStore = useAppStore()

    // 如果有 token，尝试获取用户信息
    if (userStore.isLoggedIn) {
      // 可以在这里自动获取用户信息
      // userStore.fetchUserInfo().catch(() => {
      //   // 如果获取失败，清除 token
      //   userStore.clearUserInfo()
      // })
    }

    // 应用初始化完成
    console.log('App initialized')
  }

  onLaunch(() => {
    console.log('App Launch')
    // 初始化应用
    initApp()
  })

  onShow(() => {
    console.log('App Show')
  })

  onHide(() => {
    console.log('App Hide')
  })
</script>

<style lang="scss">
  /* Tailwind CSS 通过 weapp-tailwindcss 自动处理，无需手动引入 @tailwind 指令 */

  /* 每个页面公共css */
  page {
    background-color: #f5f5f5;
    font-size: 28rpx;
    color: #333;
    box-sizing: border-box;
  }

  /* 全局样式重置 - 微信小程序不支持 * 选择器，使用 page 代替 */
  view,
  text,
  button,
  input,
  textarea,
  image,
  navigator,
  swiper,
  swiper-item {
    box-sizing: border-box;
  }
</style>
