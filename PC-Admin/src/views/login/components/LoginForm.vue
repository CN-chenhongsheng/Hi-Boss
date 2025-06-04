<template>
  <div class="login-form">
    <h3 class="title">{{ $t('login.title') }}</h3>
    <p class="sub-title">{{ $t('login.subTitle') }}</p>
    <el-form ref="formRef" :model="formData" :rules="rules" @keyup.enter="handleSubmit">
      <el-form-item>
        <el-select v-model="formData.tenant" placeholder="请选择租户" style="width: 100%">
          <el-option label="测试租户一" value="tenant1" />
          <el-option label="测试租户二" value="tenant2" />
        </el-select>
      </el-form-item>
      <el-form-item prop="username" ref="formItemRef">
        <el-input :placeholder="$t('login.placeholder[0]')" v-model.trim="formData.username" />
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          :placeholder="$t('login.placeholder[1]')"
          v-model.trim="formData.password"
          type="password"
          radius="8px"
          autocomplete="off"
        />
      </el-form-item>
      <div class="drag-verify" ref="dragVerifyContainerRef">
        <div class="drag-verify-content" :class="{ error: !isPassing && isClickPass }">
          <ArtDragVerify
            ref="dragVerify"
            v-model:value="isPassing"
            :width="dragWidth"
            :text="$t('login.sliderText')"
            textColor="var(--art-gray-800)"
            :successText="$t('login.sliderSuccessText')"
            :progressBarBg="getCssVariable('--el-color-primary')"
            :completedBg="getCssVariable('--el-color-primary')"
            background="var(--art-gray-200)"
            handlerBg="var(--art-main-bg-color)"
            @pass="onPass"
          />
        </div>
        <p class="error-text" :class="{ 'show-error-text': !isPassing && isClickPass }">{{
          $t('login.placeholder[2]')
        }}</p>
      </div>

      <div class="remember-password">
        <el-checkbox v-model="formData.rememberPassword">{{ $t('login.rememberPwd') }}</el-checkbox>
      </div>

      <div style="margin-top: 30px">
        <el-button
          class="login-btn"
          type="primary"
          @click="handleSubmit"
          :loading="loading"
          v-ripple
        >
          {{ $t('login.btnText') }}
        </el-button>
      </div>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import AppConfig from '@/config'
import { ElMessage, ElNotification } from 'element-plus'
import { useUserStore } from '@/store/modules/user'
import { HOME_PAGE } from '@/router'
import { ApiStatus } from '@/utils/http/status'
import { getCssVariable } from '@/utils/colors'
import { UserService } from '@/api/usersApi'
import { useI18n } from 'vue-i18n'
import { useWindowSize } from '@vueuse/core'
import type { FormInstance, FormRules } from 'element-plus'

const { t } = useI18n()
const dragVerify = ref()
const formItemRef = ref()
const dragVerifyContainerRef = ref()
const userStore = useUserStore()
const router = useRouter()
const isPassing = ref(false)
const isClickPass = ref(false)

const systemName = AppConfig.systemInfo.name
const formRef = ref<FormInstance>()
const formData = reactive({
  username: AppConfig.systemInfo.login.username,
  password: AppConfig.systemInfo.login.password,
  rememberPassword: true,
  tenant: 'tenant1'
})

const rules = computed<FormRules>(() => ({
  username: [{ required: true, message: t('login.placeholder[0]'), trigger: 'blur' }],
  password: [{ required: true, message: t('login.placeholder[1]'), trigger: 'blur' }]
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

onMounted(() => {
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

const onPass = () => {}

const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      if (!isPassing.value) {
        isClickPass.value = true
        return
      }

      loading.value = true

      // 延时辅助函数
      const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

      try {
        const res = await UserService.login({
          body: JSON.stringify({
            username: formData.username,
            password: formData.password
          })
        })

        if (res.code === ApiStatus.success && res.data) {
          // 设置 token
          userStore.setToken(res.data.accessToken)

          // 获取用户信息
          const userRes = await UserService.getUserInfo()
          if (userRes.code === ApiStatus.success) {
            userStore.setUserInfo(userRes.data)
          }

          // 设置登录状态
          userStore.setLoginStatus(true)
          // 延时辅助函数
          await delay(1000)
          // 登录成功提示
          showLoginSuccessNotice()
          // 跳转首页
          router.push(HOME_PAGE)
        } else {
          ElMessage.error(res.message)
          resetDragVerify()
        }
      } finally {
        await delay(1000)
        loading.value = false
      }
    }
  })
}

// 重置拖拽验证
const resetDragVerify = () => {
  dragVerify.value.reset()
}

// 登录成功提示
const showLoginSuccessNotice = () => {
  setTimeout(() => {
    ElNotification({
      title: t('login.success.title'),
      type: 'success',
      showClose: false,
      duration: 2500,
      zIndex: 10000,
      message: `${t('login.success.message')}, ${systemName}!`
    })
  }, 300)
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

  .login-btn {
    width: 100%;
    height: 40px !important;
    color: #fff;
    border: 0;
    position: relative;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
    z-index: 20;

    // 使用额外元素实现3D效果
    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      z-index: -1;
      transform: translateZ(20px);
      transition:
        transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1),
        box-shadow 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
      pointer-events: none;
      border-radius: inherit;
    }

    &:hover::before {
      transform: translateZ(25px);
      box-shadow: 0 6px 18px rgba(0, 0, 0, 0.2);
    }
  }

  // 输入框样式
  :deep(.el-input__wrapper),
  :deep(.el-select__wrapper) {
    box-shadow: none;
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
    border: none;
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
  }
}

.dark .login-form .title {
  color: var(--art-text-gray-400) !important;
}
</style>
