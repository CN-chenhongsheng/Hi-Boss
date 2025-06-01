<template>
  <div class="login-header animate-fade-in">
    <div class="logo">
      <svg class="icon" aria-hidden="true" fill="#4e83fd">
        <use xlink:href="#iconsys-zhaopian-copy"></use>
      </svg>
      <h1 class="title">{{ AppConfig.systemInfo.name }}</h1>
    </div>

    <div class="top-right-wrap">
      <div class="btn theme-btn" @click="toggleTheme">
        <i class="iconfont-sys">
          {{ isDark ? '&#xe6b5;' : '&#xe725;' }}
        </i>
      </div>
      <el-dropdown @command="changeLanguage" popper-class="langDropDownStyle">
        <div class="btn language-btn">
          <i class="iconfont-sys icon-language">&#xe611;</i>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <div v-for="lang in languageOptions" :key="lang.value" class="lang-btn-item">
              <el-dropdown-item
                :command="lang.value"
                :class="{ 'is-selected': locale === lang.value }"
              >
                <span class="menu-txt">{{ lang.label }}</span>
                <i v-if="locale === lang.value" class="iconfont-sys icon-check">&#xe621;</i>
              </el-dropdown-item>
            </div>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup lang="ts">
import AppConfig from '@/config'
import { languageOptions } from '@/language'
import { LanguageEnum, SystemThemeEnum } from '@/enums/appEnum'
import { useI18n } from 'vue-i18n'
import { useSettingStore } from '@/store/modules/setting'
import { useTheme } from '@/composables/useTheme'
import { useUserStore } from '@/store/modules/user'
import { storeToRefs } from 'pinia'

const { locale } = useI18n()
const settingStore = useSettingStore()
const { isDark, systemThemeType } = storeToRefs(settingStore)
const userStore = useUserStore()

// 切换语言
const changeLanguage = (lang: LanguageEnum) => {
  if (locale.value === lang) return
  locale.value = lang
  userStore.setLanguage(lang)
}

// 切换主题
const toggleTheme = () => {
  let { LIGHT, DARK } = SystemThemeEnum
  useTheme().switchThemeStyles(systemThemeType.value === LIGHT ? DARK : LIGHT)
}
</script>

<style lang="scss" scoped>
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  position: absolute;
  top: 30px;
  width: 100vw;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0px 30px;
  box-sizing: border-box;
  z-index: 9;
  opacity: 0;
  
  &.animate-fade-in {
    animation: fadeIn 0.8s ease-out 0.2s forwards;
  }
}

.logo {
  display: flex;
  align-items: center;

  .title {
    margin: 3px 0 0 10px;
    font-size: 20px;
    font-weight: 400;
    color: var(--art-text-gray-100);
  }
}

.top-right-wrap {
  display: flex;
  align-items: center;
  justify-content: flex-end;

  .btn {
    display: inline-block;
    padding: 5px;
    margin-left: 15px;
    cursor: pointer;
    user-select: none;
    transition: all 0.3s;

    i {
      font-size: 18px;
    }

    &:hover {
      color: var(--main-color) !important;
    }
  }
}

.icon {
  width: 32px;
  height: 32px;
}

@media only screen and (max-width: 1024px) {
  .logo .title {
    color: var(--art-text-gray-900);
  }
}
</style>
