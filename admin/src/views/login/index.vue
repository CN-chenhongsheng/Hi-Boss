<template>
  <div class="login" :style="{ backgroundImage: `url(${backgroundImage})` }">
    <LoginHeader />
    <LoginLayout />
    <div
      class="form animate-up"
      ref="formRef"
      :style="{
        transform: formStyle.transform
      }"
    >
      <LoginForm />
    </div>
  </div>
</template>

<script setup lang="ts">
import LoginHeader from './components/LoginHeader.vue'
import LoginLayout from './components/LoginLayout.vue'
import LoginForm from './components/LoginForm.vue'
import { onMounted, onBeforeUnmount, ref, reactive } from 'vue'
import { randomNum } from '@/utils/dataprocess'

// 导入背景图片
import bg1 from '@/assets/img/login/bg1.webp'
import bg2 from '@/assets/img/login/bg2.png'

// 随机选择背景图片
const bgImages = [bg1, bg2]
const backgroundImage = ref(bgImages[randomNum(0, 1)])

// 定义扩展的HTMLElement接口，包含自定义属性
interface ExtendedHTMLElement extends HTMLElement {
  _mouseEnterHandler?: (e: MouseEvent) => void
  _mouseLeaveHandler?: (e: MouseEvent) => void
}

const formRef = ref<ExtendedHTMLElement | null>(null)

// 3D 倾斜效果参数
const MAX_ROTATION = 2
const perspective = 1000

// 反应式状态
const formStyle = reactive({
  transform: 'translate(-50%, -50%) perspective(1000px) rotateX(0deg) rotateY(0deg)'
})

// 状态跟踪
const isHovering = ref(false)
let transitionTimeout: number | null = null

// 监听鼠标移入移出
onMounted(() => {
  if (!formRef.value) return

  // 使用函数引用以便正确移除事件监听
  const handleMouseEnter = () => {
    isHovering.value = true
    // 设置更平滑的过渡效果
    if (formRef.value) {
      formRef.value.style.transition = 'transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)'
    }
  }

  const handleMouseLeave = () => {
    isHovering.value = false
    resetTransform(true)
  }

  formRef.value.addEventListener('mouseenter', handleMouseEnter)
  formRef.value.addEventListener('mouseleave', handleMouseLeave)
  formRef.value.addEventListener('mousemove', handleMouseMove)

  // 保存引用以便卸载时使用
  formRef.value._mouseEnterHandler = handleMouseEnter
  formRef.value._mouseLeaveHandler = handleMouseLeave
})

// 鼠标移动时计算倾斜角度
const handleMouseMove = (e: MouseEvent) => {
  if (!isHovering.value || !formRef.value) return

  const form = formRef.value
  const rect = form.getBoundingClientRect()

  // 计算鼠标相对于表单中心的位置（-1到1之间）
  const x = ((e.clientX - rect.left) / rect.width) * 2 - 1
  const y = ((e.clientY - rect.top) / rect.height) * 2 - 1

  // 计算倾斜角度，对Y轴反转以获得更自然的效果
  const rotateX = -y * MAX_ROTATION
  const rotateY = x * MAX_ROTATION

  // 应用变换到响应式对象
  formStyle.transform = `translate(-50%, -50%) perspective(${perspective}px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) !important`
}

// 重置变换
const resetTransform = (withTransition = false) => {
  // 清除之前的超时以避免冲突
  if (transitionTimeout !== null) {
    clearTimeout(transitionTimeout)
    transitionTimeout = null
  }

  // 重置为初始状态
  if (withTransition) {
    // 为移出添加平滑过渡
    if (formRef.value) {
      formRef.value.style.transition =
        'transform 0.8s cubic-bezier(0.23, 1, 0.32, 1), box-shadow 0.8s cubic-bezier(0.23, 1, 0.32, 1)'

      // 设置目标位置为初始状态
      formStyle.transform = 'translate(-50%, -50%) perspective(1000px) rotateX(0deg) rotateY(0deg)'

      // 一段时间后重置transition，以便鼠标再次进入时立即响应
      transitionTimeout = window.setTimeout(() => {
        if (formRef.value) formRef.value.style.transition = 'transform 0.2s ease'
        transitionTimeout = null
      }, 800)
    }
  } else {
    // 不需要过渡时直接重置
    formStyle.transform = 'translate(-50%, -50%) perspective(1000px) rotateX(0deg) rotateY(0deg)'
  }
}

// 组件卸载时清理事件监听
onBeforeUnmount(() => {
  const form = formRef.value
  if (!form) return

  if (form._mouseEnterHandler) form.removeEventListener('mouseenter', form._mouseEnterHandler)
  if (form._mouseLeaveHandler) form.removeEventListener('mouseleave', form._mouseLeaveHandler)
  form.removeEventListener('mousemove', handleMouseMove)

  if (transitionTimeout !== null) {
    clearTimeout(transitionTimeout)
  }
})
</script>

<style lang="scss" scoped>
@use './index';
@use '@styles/variables.scss' as *;

$padding: 40px;

@keyframes slideInUp {
  from {
    transform: translate(-50%, 20%) perspective(1000px) rotateX(0deg) rotateY(0deg);
    opacity: 0;
  }
  to {
    transform: translate(-50%, -50%) perspective(1000px) rotateX(0deg) rotateY(0deg);
    opacity: 1;
  }
}

.form {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) perspective(1000px) rotateX(0deg) rotateY(0deg);
  width: 440px;
  height: 610px;
  padding: 0 $padding;
  margin: auto;
  overflow: hidden;
  user-select: none;
  background-size: cover;
  background-color: #ffffffe0;
  filter: drop-shadow(0 0 10px rgba(0, 0, 0, 0.1));
  backdrop-filter: blur(10px);
  border-radius: 20px;
  z-index: 1;
  opacity: 0;
  transform-style: preserve-3d;
  transition:
    transform 0.8s cubic-bezier(0.23, 1, 0.32, 1),
    box-shadow 0.5s cubic-bezier(0.23, 1, 0.32, 1) !important;

  &.animate-up {
    animation: slideInUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
  }
}

@media only screen and (max-width: $device-phone) {
  .form {
    width: calc(90% - $padding);
    height: auto;
    padding: 0 calc($padding / 2);
    min-height: 70vh;
    transform: translate(-50%, -50%) perspective(800px) rotateX(0deg) rotateY(0deg);
    border-radius: 25px;
  }
}
</style>
