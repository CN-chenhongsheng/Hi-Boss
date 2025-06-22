<template>
  <ElConfigProvider size="default" :locale="locales[language]" :z-index="3000">
    <RouterView></RouterView>
  </ElConfigProvider>
</template>

<script setup lang="ts">
import { useUserStore } from './store/modules/user'
import zh from 'element-plus/es/locale/lang/zh-cn'
import en from 'element-plus/es/locale/lang/en'
import { systemUpgrade } from './utils/sys/upgrade'
import { UserService } from './api/usersApi'
import { ApiStatus } from './utils/http/status'
import { checkStorageCompatibility } from './utils/storage/storage'
import { setThemeTransitionClass } from './utils/theme/animation'

const userStore = useUserStore()
const { language } = storeToRefs(userStore)

const locales = {
  zh: zh,
  en: en
}

onBeforeMount(() => {
  setThemeTransitionClass(true)
})

onMounted(() => {
  // 检查存储兼容性
  checkStorageCompatibility()
  // 提升暗黑主题下页面刷新视觉体验
  setThemeTransitionClass(false)
  // 系统升级
  systemUpgrade()
  // 获取用户信息
  getUserInfo()
})

// 获取用户信息
const getUserInfo = async () => {
  // 如果用户未登录，直接返回
  if (!userStore.isLogin) return

  try {
    // 发送获取用户信息请求
    const userRes = await UserService.getUserInfo()

    // 请求失败，记录错误并返回
    if (userRes.code !== ApiStatus.success) {
      console.error('获取用户信息失败:', userRes.msg)
      return
    }

    // 提取用户信息、权限和角色
    const { user, permissions, roles } = userRes

    // 将用户详情转换为UserInfo格式并设置到store
    userStore.setUserInfo({
      userId: user.userId,
      userName: user.userName,
      nickName: user.nickName,
      avatar: user.avatar || '',
      email: user.email || '',
      phone: user.phonenumber || '',
      roles: roles,
      buttons: permissions
    })

    // 设置权限和角色
    userStore.setPermissions(permissions)
    userStore.setRoles(roles)
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}
</script>
