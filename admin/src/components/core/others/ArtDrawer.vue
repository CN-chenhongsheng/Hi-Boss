<template>
  <el-drawer
    v-model="dialogVisible"
    :title="title"
    :direction="direction"
    :size="size"
    :destroy-on-close="destroyOnClose"
    :close-on-click-modal="closeOnClickModal"
    :show-close="showClose"
    :before-close="handleBeforeClose"
    :append-to-body="appendToBody"
    :modal="modal"
    :modal-class="modalClass"
    :class="drawerClass"
    :custom-class="customClass"
    :z-index="zIndex"
    :lock-scroll="lockScroll"
    :with-header="withHeader"
  >
    <template v-if="$slots.header && withHeader" #header>
      <slot name="header"></slot>
    </template>

    <div class="art-drawer-body">
      <slot></slot>
    </div>

    <template v-if="$slots.footer" #footer>
      <div class="art-drawer-footer">
        <slot name="footer"></slot>
      </div>
    </template>
  </el-drawer>
</template>

<script setup lang="ts">
import { computed } from 'vue'

export type DrawerDirection = 'rtl' | 'ltr' | 'ttb' | 'btt'
export type DrawerSize = string | number

// 定义组件属性
export interface ArtDrawerProps {
  modelValue: boolean
  title?: string
  direction?: DrawerDirection
  size?: DrawerSize
  destroyOnClose?: boolean
  closeOnClickModal?: boolean
  showClose?: boolean
  beforeClose?: (done: () => void) => void
  appendToBody?: boolean
  modal?: boolean
  modalClass?: string
  drawerClass?: string
  customClass?: string
  zIndex?: number
  lockScroll?: boolean
  withHeader?: boolean
}

// 定义默认值
const props = withDefaults(defineProps<ArtDrawerProps>(), {
  title: '',
  direction: 'rtl',
  size: '30%',
  destroyOnClose: false,
  closeOnClickModal: true,
  showClose: true,
  appendToBody: false,
  modal: true,
  modalClass: '',
  drawerClass: '',
  customClass: '',
  zIndex: 2000,
  lockScroll: true,
  withHeader: true
})

// 定义事件
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'open'): void
  (e: 'opened'): void
  (e: 'close'): void
  (e: 'closed'): void
}>()

// 双向绑定抽屉显示状态
const dialogVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

// 处理关闭前的回调
const handleBeforeClose = (done: () => void) => {
  if (props.beforeClose) {
    props.beforeClose(done)
  } else {
    done()
  }
}

// 暴露方法
defineExpose({
  open: () => {
    dialogVisible.value = true
  },
  close: () => {
    dialogVisible.value = false
  }
})
</script>

<style lang="scss">
.art-drawer-footer {
  padding: 10px 20px;
  text-align: right;
  border-top: 1px solid var(--el-border-color-lighter);
}

/* 抽屉基础样式设置 */
.el-drawer {
  // 右侧弹出的抽屉，左上角和左下角圆角
  &.rtl,
  &.right {
    border-top-left-radius: calc(var(--custom-radius) / 2 + 2px);
    border-bottom-left-radius: calc(var(--custom-radius) / 2 + 2px);
  }

  // 左侧弹出的抽屉，右上角和右下角圆角
  &.ltr,
  &.left {
    border-top-right-radius: calc(var(--custom-radius) / 2 + 2px);
    border-bottom-right-radius: calc(var(--custom-radius) / 2 + 2px);
  }

  // 顶部弹出的抽屉，左下角和右下角圆角
  &.ttb,
  &.top {
    border-bottom-left-radius: calc(var(--custom-radius) / 2 + 2px);
    border-bottom-right-radius: calc(var(--custom-radius) / 2 + 2px);
  }

  // 底部弹出的抽屉，左上角和右上角圆角
  &.btt,
  &.bottom {
    border-top-left-radius: calc(var(--custom-radius) / 2 + 2px);
    border-top-right-radius: calc(var(--custom-radius) / 2 + 2px);
  }

  // --el-drawer-bg-color: var(--el-bg-color);
  // --el-drawer-padding-primary: 0;
  // background: rgba($color: #fff, $alpha: 95%) !important;
  // box-shadow: 0 0 30px #0000001a !important;

  // /* 增加毛玻璃效果 */
  // backdrop-filter: blur(30px);
  // --tw-backdrop-blur: blur(30px);
  // -webkit-backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness)
  //   var(--tw-backdrop-contrast) var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate)
  //   var(--tw-backdrop-invert) var(--tw-backdrop-opacity) var(--tw-backdrop-saturate)
  //   var(--tw-backdrop-sepia);
  // backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness) var(--tw-backdrop-contrast)
  //   var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate) var(--tw-backdrop-invert)
  //   var(--tw-backdrop-opacity) var(--tw-backdrop-saturate) var(--tw-backdrop-sepia);
}

/* 深色模式样式 */
// :root.dark {
//   .el-drawer {
//     background: rgba($color: #000, $alpha: 75%) !important;
//   }
// }

// .el-drawer__header {
//   margin-bottom: 0;
//   padding: 16px 20px;
//   border-bottom: 1px solid var(--el-border-color-lighter);
//   font-size: 16px;
//   font-weight: 500;
//   color: var(--el-text-color-primary);
// }

// .el-drawer__body::-webkit-scrollbar {
//   width: 0 !important;
// }

// .setting-modal {
//   background: transparent !important;
//   transition: all 0.3s ease-in-out;
// }

// .el-overlay.setting-modal {
//   background-color: rgba(0, 0, 0, 0.4) !important;
//   backdrop-filter: blur(4px);
//   transition: all 0.3s ease-in-out;
// }
</style>
