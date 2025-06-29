<template>
  <div class="login-form">
    <h3 class="title">{{ $t('login.title') }}</h3>
    <p class="sub-title">{{ $t('login.subTitle') }}</p>
    <el-form ref="formRef" :model="formData" :rules="rules" @keyup.enter="handleSubmit">
      <el-form-item prop="username" ref="formItemRef">
        <el-input :placeholder="$t('login.placeholder[0]')" v-model.trim="formData.username">
          <template #prefix>
            <el-icon><User /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          :placeholder="$t('login.placeholder[1]')"
          v-model.trim="formData.password"
          type="password"
          radius="8px"
          autocomplete="off"
        >
          <template #prefix>
            <el-icon><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <!-- 验证码输入区域 -->
      <div class="captcha-wrapper">
        <el-form-item prop="captcha" v-if="captchaEnabled" class="captcha-form-item">
          <el-input
            class="captcha-input"
            v-model.trim="formData.captcha"
            :placeholder="$t('login.placeholder[2]')"
          >
            <template #prefix>
              <el-icon><Key /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        <img
          v-if="captchaEnabled"
          class="captcha-img"
          :src="captchaImg"
          @click="refreshCaptcha"
          alt="验证码"
          title="点击刷新验证码"
        />
      </div>
      <div class="remember-password">
        <el-checkbox v-model="formData.rememberPassword">{{ $t('login.rememberPwd') }}</el-checkbox>
      </div>

      <div class="drag-verify" ref="dragVerifyContainerRef">
        <div
          class="drag-verify-content"
          :class="{ error: !isPassing && isClickPass, loading: loading }"
        >
          <ArtDragVerify
            ref="dragVerify"
            v-model:value="isPassing"
            :width="dragWidth"
            :text="$t('login.sliderLoginText')"
            textColor="var(--art-gray-800)"
            :successText="$t('login.sliderSuccessText')"
            :progressBarBg="getCssVariable('--el-color-primary')"
            :completedBg="getCssVariable('--el-color-primary')"
            background="var(--art-gray-200)"
            handlerBg="var(--art-main-bg-color)"
            @passCallback="onPass"
          />
          <div class="loading-indicator" :class="{ show: loading }">
            <el-icon class="is-loading"><Loading /></el-icon>
          </div>
        </div>
      </div>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import AppConfig from '@/config'
import { ElMessage, ElNotification } from 'element-plus'
import { useUserStore } from '@/store/modules/user'
import { HOME_PAGE } from '@/router/routesAlias'
import { ApiStatus } from '@/utils/http/status'
import { getCssVariable } from '@/utils/ui'
import { UserService } from '@/api/usersApi'
import { useI18n } from 'vue-i18n'
import { useWindowSize } from '@vueuse/core'
import type { FormInstance, FormRules } from 'element-plus'
import avatar from '@imgs/avatar/avatar1.webp'

const { t } = useI18n()
const dragVerify = ref()
const formItemRef = ref()
const dragVerifyContainerRef = ref()
const userStore = useUserStore()
const router = useRouter()
const isPassing = ref(false)
const isClickPass = ref(false)

// 验证码相关状态
const captchaImg = ref('')
const captchaUuid = ref('')
const captchaEnabled = ref(true)

const systemName = AppConfig.systemInfo.name
const formRef = ref<FormInstance>()
const formData = reactive({
  username: AppConfig.systemInfo.username,
  password: AppConfig.systemInfo.password,
  captcha: '',
  rememberPassword: true
})

const rules = computed<FormRules>(() => ({
  username: [{ required: true, message: t('login.placeholder[0]'), trigger: 'blur' }],
  password: [{ required: true, message: t('login.placeholder[1]'), trigger: 'blur' }],
  captcha: [{ required: captchaEnabled.value, message: t('login.placeholder[2]'), trigger: 'blur' }]
}))

const loading = ref(false)
const { width } = useWindowSize()
// 初始宽度设置为0，组件内部会自动计算实际宽度
const dragWidth = ref(0)

// 更新滑块宽度
const updateDragWidth = () => {
  if (dragVerifyContainerRef.value) {
    // 直接获取容器宽度，这样更准确
    const containerWidth = dragVerifyContainerRef.value.clientWidth
    // 确保宽度有效
    if (containerWidth > 0) {
      dragWidth.value = containerWidth
      // 如果滑块组件实例存在，且有reset方法，重新设置后需要重置一下
      if (
        dragVerify.value &&
        typeof dragVerify.value.reset === 'function' &&
        isPassing.value === false
      ) {
        nextTick(() => {
          dragVerify.value.reset()
        })
      }
    }
  }
}

// 使用ResizeObserver监听元素尺寸变化
let resizeObserver: ResizeObserver | null = null

// 获取验证码
const getCaptcha = async () => {
  try {
    const res = await UserService.getCodeImg()
    if (res.code !== ApiStatus.success) {
      ElMessage.error(t('login.captchaFailed'))
      captchaEnabled.value = false
      return
    }
    captchaImg.value = `data:image/gif;base64,${res.img}`
    captchaUuid.value = res.uuid
    captchaEnabled.value = res.captchaEnabled
  } catch (error: any) {
    console.error(t('login.captchaFailed'), error)
    captchaEnabled.value = false
  }
}

// 刷新验证码
const refreshCaptcha = () => {
  getCaptcha()
}

onMounted(() => {
  // 获取验证码
  getCaptcha()

  // 等待DOM更新
  nextTick(() => {
    // 首先更新一次
    updateDragWidth()

    // 使用ResizeObserver监听容器尺寸变化
    if (dragVerifyContainerRef.value && window.ResizeObserver) {
      resizeObserver = new ResizeObserver(() => {
        updateDragWidth()
      })
      resizeObserver.observe(dragVerifyContainerRef.value)
    }
  })
})

// 监听窗口大小变化，作为备用机制
watch(
  () => width.value,
  () => {
    nextTick(() => {
      updateDragWidth()
    })
  },
  { immediate: true }
)

// 组件卸载时清理ResizeObserver
onBeforeUnmount(() => {
  if (resizeObserver) {
    resizeObserver.disconnect()
    resizeObserver = null
  }
})

// 滑动验证成功时触发登录
const onPass = async () => {
  await handleSubmit()
}

const handleSubmit = async () => {
  // 前置条件检查：表单实例不存在则直接返回
  if (!formRef.value) return

  // 如果滑动验证未通过，标记点击状态并直接返回
  if (!isPassing.value) {
    isClickPass.value = true
    return
  }

  // 验证表单，验证失败则重置滑动验证并返回
  try {
    await formRef.value.validate()
  } catch {
    resetDragVerify()
    return
  }

  // 开始登录流程，设置加载状态
  loading.value = true

  try {
    // 发送登录请求
    const res = await UserService.login({
      username: formData.username,
      password: formData.password,
      code: formData.captcha,
      uuid: captchaUuid.value
    })

    // 登录请求失败，显示错误信息并重置状态
    if (res.code !== ApiStatus.success) {
      ElMessage.error(res.msg)
      resetDragVerify()
      refreshCaptcha()
      return
    }

    // 检查token是否存在
    if (!res.token) {
      ElMessage.error('登录成功但未获取到令牌')
      resetDragVerify()
      refreshCaptcha()
      return
    }

    // 设置token
    userStore.setToken(res.token)

    // 获取用户信息
    const userRes = await UserService.getUserInfo()

    // 用户信息获取失败
    if (userRes.code !== ApiStatus.success) {
      ElMessage.error(userRes.msg || '获取用户信息失败')
      resetDragVerify()
      refreshCaptcha()
      return
    }

    // 提取用户信息、权限和角色
    const { user, permissions, roles } = userRes

    // 将用户详情转换为UserInfo格式并设置到store
    userStore.setUserInfo({
      userId: user.userId,
      userName: user.userName,
      nickName: user.nickName,
      avatar: user.avatar || avatar,
      email: user.email || '',
      phone: user.phonenumber || '',
      roles: roles,
      buttons: permissions
    })

    // 设置权限和角色
    userStore.setPermissions(permissions)
    userStore.setRoles(roles)

    // 设置登录状态
    userStore.setLoginStatus(true)

    // 跳转首页
    router.push(HOME_PAGE)

    // 登录成功提示
    showLoginSuccessNotice()
  } catch {
    ElMessage.error('登录失败，请重试')
    resetDragVerify()
    refreshCaptcha()
  } finally {
    loading.value = false
  }
}

// 重置拖拽验证
const resetDragVerify = () => {
  // 先更新状态，再重置组件
  isPassing.value = false
  nextTick(() => {
    dragVerify.value.reset()
  })
}

// 登录成功提示
const showLoginSuccessNotice = () => {
  const { getUserInfo: userInfo } = storeToRefs(userStore)

  // 根据当前时间获取问候语
  const getGreeting = () => {
    const hour = new Date().getHours()
    if (hour < 6) return t('login.greeting.dawn')
    if (hour < 9) return t('login.greeting.morning')
    if (hour < 12) return t('login.greeting.forenoon')
    if (hour < 14) return t('login.greeting.noon')
    if (hour < 18) return t('login.greeting.afternoon')
    if (hour < 22) return t('login.greeting.evening')
    return t('login.greeting.night')
  }

  // 获取用户称呼
  const userName = userInfo.value?.nickName || systemName

  // 构建欢迎消息 - 优化排版
  const welcomeMessage = `<div class="welcome-message">
    <div class="greeting">${getGreeting()}，<strong>${userName}</strong>！</div>
    <div class="welcome-text">${t('login.welcomeBack')}</div>
  </div>`

  ElNotification({
    title: t('login.success.title'),
    type: 'success',
    showClose: false,
    duration: 3000,
    zIndex: 10000,
    dangerouslyUseHTMLString: true,
    message: welcomeMessage,
    position: 'top-right',
    offset: 35,
    customClass: 'login-success-notification'
  })
}
</script>

<style lang="scss" scoped>
.login-form {
  box-sizing: border-box;
  height: 100%;
  padding: 40px 0;
  width: 100%;
  transform-style: preserve-3d;

  // 标题和副标题保持3D效果
  .title {
    margin-left: -2px;
    font-size: 34px;
    font-weight: 600;
    color: var(--art-text-gray-900) !important;
    transform: translateZ(30px);
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.12);
    transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  .sub-title {
    margin-top: 10px;
    font-size: 14px;
    color: var(--art-text-gray-500) !important;
    transform: translateZ(20px);
    transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  // 表单项容器效果
  :deep(.el-form) {
    position: relative;
    z-index: 1;
    margin-top: 25px;
    transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  // 增强表单项浮起效果 - 使用附加的装饰元素
  :deep(.el-form-item) {
    position: relative;
    margin-bottom: 22px;

    // 使用装饰元素实现3D效果
    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: transparent;
      border-radius: 8px;
      z-index: -1;
      transform: translateZ(10px);
      transition:
        box-shadow 0.6s cubic-bezier(0.34, 1.56, 0.64, 1),
        transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
      pointer-events: none;
    }

    &:hover::before {
      transform: translateZ(15px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
  }

  // 输入框图标样式
  :deep(.el-input__prefix) {
    margin-right: 5px;

    .el-icon {
      color: var(--el-text-color-secondary);
      font-size: 18px;
    }
  }

  // 验证码容器样式
  .captcha-wrapper {
    display: flex;
    align-items: center;
    width: 100%;
    margin-bottom: 22px;

    .captcha-form-item {
      flex: 1;
      margin-right: 10px;
      margin-bottom: 0;
    }

    .captcha-img {
      height: 40px;
      border-radius: 4px;
      cursor: pointer;
      transition: opacity 0.3s;

      &:hover {
        opacity: 0.8;
      }
    }
  }

  .drag-verify {
    position: relative;
    padding-bottom: 20px;
    margin-top: 25px;
    width: 100%;
    z-index: 10;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      z-index: -1;
      transform: translateZ(10px);
      transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
      pointer-events: none;
    }

    &:hover::before {
      transform: translateZ(15px);
    }

    .drag-verify-content {
      position: relative;
      z-index: 2;
      box-sizing: border-box;
      user-select: none;
      border-radius: 8px;
      transition: all 0.3s;
      width: 100%;

      &.error {
        border-color: #f56c6c;
      }

      &.loading {
        opacity: 0.7;
        pointer-events: none;
      }
    }

    .error-text {
      position: absolute;
      top: 0;
      z-index: 1;
      margin-top: 10px;
      font-size: 13px;
      color: #f56c6c;
      transition: all 0.3s;

      &.show-error-text {
        transform: translateY(40px);
      }
    }

    .loading-indicator {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 10;
      display: none;
      font-size: 24px;
      color: var(--el-color-primary);

      &.show {
        display: block;
      }
    }
  }

  .remember-password {
    display: flex;
    align-items: center;
    margin-top: 10px;
    font-size: 14px;
    color: var(--art-text-gray-500);
    position: relative;
    z-index: 10;

    &::before {
      content: '';
      position: absolute;
      top: -5px;
      left: -10px;
      right: -10px;
      bottom: -5px;
      z-index: -1;
      transform: translateZ(10px);
      transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
      pointer-events: none;
    }

    &:hover::before {
      transform: translateZ(15px);
    }
  }

  // 输入框样式
  :deep(.el-input__wrapper),
  :deep(.el-select__wrapper) {
    border-radius: 8px;
    transition: box-shadow 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
    color: var(--art-text-gray-500) !important;

    &:focus-within {
      box-shadow:
        0 0 0 1px var(--el-input-focus-border-color, var(--el-color-primary)) inset,
        0 5px 15px rgba(0, 0, 0, 0.05);
    }
  }

  .drag_verify {
    transition: box-shadow 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);

    &:hover {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
  }
}

@media only screen and (max-width: $device-phone) {
  .login-form {
    .title {
      text-align: center;
    }
    .sub-title {
      text-align: center;
    }

    :deep(.el-form) {
      margin-top: 30px;
    }

    .captcha-wrapper {
      flex-direction: column;

      .captcha-form-item {
        margin-right: 0;
        margin-bottom: 10px;
        width: 100%;
      }

      .captcha-img {
        width: 100%;
        height: auto;
      }
    }
  }

  // 移除原有的手机样式
  .captcha-container {
    display: none;
  }
}

.dark .login-form .title {
  color: var(--art-text-gray-400) !important;
}

// 登录成功通知样式
:global(.login-success-notification) {
  .el-notification__title {
    color: var(--el-color-success-dark-1);
    font-weight: 600;
    margin-bottom: 10px;
    padding-top: 6px;
  }

  .el-notification__content {
    color: var(--el-text-color-primary);
    margin: 0;
    padding-bottom: 8px;

    .welcome-message {
      padding: 10px 0 10px 10px;

      .greeting {
        font-size: 15px;
        margin-bottom: 8px;

        strong {
          font-weight: 600;
          color: var(--el-color-success-dark-1);
        }
      }

      .welcome-text {
        font-size: 14px;
        color: var(--el-text-color-secondary);
        line-height: 1.5;
      }
    }
  }

  .el-notification__icon {
    color: var(--el-color-success);
    font-size: 20px;
    margin-top: 6px;
  }
}
</style>
