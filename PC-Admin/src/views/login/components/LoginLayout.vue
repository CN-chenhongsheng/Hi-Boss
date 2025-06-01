<template>
  <div class="login-layout">
    <div class="left-wrap animate-left">
      <LoginLeftView></LoginLeftView>
    </div>

    <div class="right-wrap animate-right">
      <div class="svg-container">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          viewBox="0 0 500 350"
          class="filtered-bg"
        >
          <g transform="">
            <g transform="translate(628,-17) scale(100)" opacity="0.3">
              <path
                :style="{ fill: primaryColor }"
                d="M4.10125 0 C4.10125 0.5525 4.3542 0.8338 4.1835 1.3593 S3.6427 1.9637 3.318 2.4107 S3.0325 3.2339 2.5855 3.5587 S1.7928 3.7298 1.2674 3.9005 S0.5525 4.3988 0 4.3988 S-0.7419 4.0713 -1.2674 3.9005 S-2.1385 3.8834 -2.5855 3.5587 S-2.9932 2.8576 -3.318 2.4107 S-4.0127 1.8847 -4.1835 1.3593 S-4.1013 0.5525 -4.1013 0 S-4.3542 -0.8338 -4.1835 -1.3593 S-3.6427 -1.9637 -3.318 -2.4107 S-3.0325 -3.2339 -2.5855 -3.5587 S-1.7928 -3.7298 -1.2674 -3.9005 S-0.5525 -4.3988 0 -4.3988 S0.7419 -4.0713 1.2674 -3.9005 S2.1385 -3.8834 2.5855 -3.5587 S2.9932 -2.8576 3.318 -2.4107 S4.0127 -1.8847 4.1835 -1.3593 S4.1013 -0.5525 4.1013 0"
                stroke-width="0"
                transform="rotate(19)"
              >
                <animateTransform
                  attributeName="transform"
                  type="rotate"
                  dur="10s"
                  repeatCount="indefinite"
                  values="0;36"
                ></animateTransform>
              </path>
            </g>
            <g transform="translate(704,-56) scale(100)" opacity="0.9">
              <path
                :style="{ fill: primaryColor }"
                d="M4.9215 0 C4.9215 0.663 5.225 1.0006 5.0202 1.6311 S4.3713 2.3564 3.9816 2.8928 S3.639 3.8807 3.1026 4.2704 S2.1514 4.4757 1.5208 4.6806 S0.663 5.2785 0 5.2785 S-0.8903 4.8855 -1.5208 4.6806 S-2.5662 4.6601 -3.1026 4.2704 S-3.5919 3.4292 -3.9816 2.8928 S-4.8153 2.2617 -5.0202 1.6311 S-4.9215 0.663 -4.9215 0 S-5.225 -1.0006 -5.0202 -1.6311 S-4.3713 -2.3564 -3.9816 -2.8928 S-3.639 -3.8807 -3.1026 -4.2704 S-2.1514 -4.4757 -1.5208 -4.6806 S-0.663 -5.2785 0 -5.2785 S0.8903 -4.8855 1.5208 -4.6806 S2.5662 -4.6601 3.1026 -4.2704 S3.5919 -3.4292 3.9816 -2.8928 S4.8153 -2.2617 5.0202 -1.6311 S4.9215 -0.663 4.9215 0"
                stroke-width="0"
                transform="rotate(2.04427)"
              >
                <animateTransform
                  attributeName="transform"
                  type="rotate"
                  dur="6s"
                  repeatCount="indefinite"
                  values="0;36"
                ></animateTransform>
              </path>
            </g>
          </g>
        </svg>
      </div>
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useSettingStore } from '@/store/modules/setting'
import LoginLeftView from './LoginLeftView.vue'

// 获取主题色
const settingStore = useSettingStore()
const primaryColor = computed(() => {
  return getComputedStyle(document.documentElement).getPropertyValue('--el-color-primary').trim() || '#5D87FF'
})

defineProps({
  bgSrc: {
    type: String,
    default: () => new URL('@svg/login/bg.svg', import.meta.url).href
  }
})
</script>

<style lang="scss" scoped>
@use '../index.scss' as *;

@keyframes slideInLeft {
  from {
    transform: translateX(-100%) rotate(180deg) scaleY(-1);
    opacity: 0;
  }
  to {
    transform: translateX(0) rotate(180deg) scaleY(-1);
    opacity: 1;
  }
}

@keyframes slideInRight {
  from {
    transform: translateX(100%) scaleY(-1);
    opacity: 0;
  }
  to {
    transform: translateX(0) scaleY(-1);
    opacity: 1;
  }
}

.login-layout {
  box-sizing: border-box;
  display: flex;
  height: 100vh;
  overflow: hidden;
  position: relative;

  .right-view {
    height: 100%;
  }

  .left-wrap {
    width: 70%;
    flex-shrink: 0;
    pointer-events: none;
    transform: rotate(180deg) scaleY(-1);
    opacity: 0;

    &.animate-left {
      animation: slideInLeft 0.6s ease-out forwards;
    }
  }

  .right-wrap {
    width: 30%;
    box-sizing: border-box;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    opacity: 0;

    &.animate-right {
      animation: slideInRight 0.6s ease-out forwards;
    }

    .svg-container {
      position: absolute;
      bottom: 50%;
      right: 0;
      height: 100%;
      width: 100%;
      overflow: hidden;
      z-index: 0;
    }
    
    .filtered-bg {
      position: absolute;
      bottom: 0;
      right: 0;
      height: 100%;
      width: 100%;
      overflow: hidden;
      z-index: 0;
      filter: blur(5px);
    }
  }
}

@media only screen and (max-width: 1024px) {
  .login-layout {
    .left-wrap {
      display: none;
    }

    .right-wrap {
      width: 100%;
      .filtered-bg,
      .svg-container {
        filter: none;
        bottom: 0;
      }
    }
  }
}
</style>
