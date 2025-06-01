<template>
  <div class="login-form">
    <h3 class="title">{{ $t('login.title') }}</h3>
    <p class="sub-title">{{ $t('login.subTitle') }}</p>
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      @keyup.enter="handleSubmit"
      style="margin-top: 25px"
    >
      <el-form-item prop="username">
        <el-input
          :placeholder="$t('login.placeholder[0]')"
          v-model.trim="formData.username"
        />
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
      <div class="drag-verify">
        <div class="drag-verify-content" :class="{ error: !isPassing && isClickPass }">
          <ArtDragVerify
            ref="dragVerify"
            v-model:value="isPassing"
            :width="width < 500 ? 328 : 438"
            :text="$t('login.sliderText')"
            textColor="var(--art-gray-800)"
            :successText="$t('login.sliderSuccessText')"
            :progressBarBg="getCssVariable('--el-color-primary')"
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
        <el-checkbox v-model="formData.rememberPassword">{{
          $t('login.rememberPwd')
        }}</el-checkbox>
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
import { storeToRefs } from 'pinia'
import type { FormInstance, FormRules } from 'element-plus'

const { t } = useI18n()
const dragVerify = ref()
const userStore = useUserStore()
const router = useRouter()
const isPassing = ref(false)
const isClickPass = ref(false)

const systemName = AppConfig.systemInfo.name
const formRef = ref<FormInstance>()
const formData = reactive({
  username: AppConfig.systemInfo.login.username,
  password: AppConfig.systemInfo.login.password,
  rememberPassword: true
})

const rules = computed<FormRules>(() => ({
  username: [{ required: true, message: t('login.placeholder[0]'), trigger: 'blur' }],
  password: [{ required: true, message: t('login.placeholder[1]'), trigger: 'blur' }]
}))

const loading = ref(false)
const { width } = useWindowSize()

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

  .title {
    margin-left: -2px;
    font-size: 34px;
    font-weight: 600;
    color: var(--art-text-gray-900) !important;
  }

  .sub-title {
    margin-top: 10px;
    font-size: 14px;
    color: var(--art-text-gray-500) !important;
  }

  .drag-verify {
    position: relative;
    padding-bottom: 20px;
    margin-top: 25px;

    .drag-verify-content {
      position: relative;
      z-index: 2;
      box-sizing: border-box;
      user-select: none;
      border-radius: 8px;
      transition: all 0.3s;

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
  }

  .login-btn {
    width: 100%;
    height: 40px !important;
    color: #fff;
    border: 0;
  }
}
</style> 