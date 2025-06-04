<template>
  <div class="art-dialog-container">
    <el-dialog
      v-model="dialogVisible"
      :title="title"
      :width="width"
      :top="top"
      :modal="modal"
      :append-to-body="appendToBody"
      :destroy-on-close="destroyOnClose"
      :close-on-click-modal="closeOnClickModal"
      :close-on-press-escape="closeOnPressEscape"
      :show-close="showClose"
      :before-close="handleBeforeClose"
      :draggable="draggable"
      :center="center"
      :align-center="alignCenter"
      class="art-dialog"
      :class="[customClass]"
      @open="handleOpen"
      @opened="$emit('opened')"
      @close="$emit('close')"
      @closed="handleClosed"
      ref="dialogRef"
    >
      <!-- 自定义标题插槽 -->
      <template #header v-if="$slots.header">
        <slot name="header"></slot>
      </template>

      <!-- 默认内容插槽 -->
      <slot></slot>

      <!-- 自定义底部插槽 -->
      <template #footer v-if="!hideFooter">
        <slot name="footer">
          <div class="art-dialog-footer">
            <el-button @click="handleCancel">{{ cancelText }}</el-button>
            <el-button
              type="primary"
              @click="handleConfirm"
              :loading="confirmLoading || internalLoading"
            >
              {{ confirmText }}
            </el-button>
          </div>
        </slot>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

// 定义Props
const props = defineProps({
  // 对话框是否显示
  modelValue: {
    type: Boolean,
    default: false
  },
  // 标题
  title: {
    type: String,
    default: '提示'
  },
  // 宽度
  width: {
    type: [String, Number],
    default: '50%'
  },
  // 距离顶部的位置
  top: {
    type: String,
    default: '15vh'
  },
  // 是否显示遮罩层
  modal: {
    type: Boolean,
    default: true
  },
  // 是否将对话框追加到 body 元素
  appendToBody: {
    type: Boolean,
    default: true
  },
  // 关闭时是否销毁组件内的元素
  destroyOnClose: {
    type: Boolean,
    default: false
  },
  // 点击遮罩层是否关闭对话框
  closeOnClickModal: {
    type: Boolean,
    default: true
  },
  // 按下ESC是否关闭对话框
  closeOnPressEscape: {
    type: Boolean,
    default: true
  },
  // 是否显示关闭按钮
  showClose: {
    type: Boolean,
    default: true
  },
  // 是否可拖拽
  draggable: {
    type: Boolean,
    default: true // 默认启用可拖拽功能
  },
  // 标题和底部是否居中
  center: {
    type: Boolean,
    default: false
  },
  // 对话框是否垂直居中
  alignCenter: {
    type: Boolean,
    default: true
  },
  // 自定义类名
  customClass: {
    type: String,
    default: ''
  },
  // 取消按钮文本
  cancelText: {
    type: String,
    default: '取消'
  },
  // 确认按钮文本
  confirmText: {
    type: String,
    default: '确定'
  },
  // 确认按钮加载状态
  confirmLoading: {
    type: Boolean,
    default: false
  },
  // 是否隐藏底部按钮
  hideFooter: {
    type: Boolean,
    default: false
  },
  // 是否在关闭后自动将modelValue设为false
  autoClose: {
    type: Boolean,
    default: true
  },
  // 关闭前的回调，返回false会阻止关闭
  beforeClose: {
    type: Function,
    default: null
  },
  // 确认回调函数，支持异步
  confirm: {
    type: Function,
    default: null
  },
  // 对话框打开时的回调
  open: {
    type: Function,
    default: null
  }
})

// 定义事件
const emit = defineEmits([
  'update:modelValue',
  'open',
  'opened',
  'close',
  'closed',
  'cancel',
  'confirm'
])

// 对话框引用
const dialogRef = ref<any>(null)

// 对话框可见状态
const dialogVisible = ref(props.modelValue)

// 内部loading状态，用于异步confirm处理
const internalLoading = ref(false)

// 监听modelValue变化
watch(
  () => props.modelValue,
  (val) => {
    dialogVisible.value = val
  }
)

// 监听dialogVisible变化
watch(dialogVisible, (val) => {
  emit('update:modelValue', val)
})

// 处理取消按钮点击
const handleCancel = () => {
  emit('cancel')
  if (props.autoClose) {
    dialogVisible.value = false
  }
}

// 处理确认按钮点击，支持异步操作
const handleConfirm = async () => {
  try {
    internalLoading.value = true

    // 触发confirm事件
    emit('confirm')

    // 如果提供了confirm回调函数，则执行它并等待结果
    if (typeof props.confirm === 'function') {
      try {
        const result = await props.confirm()
        // 如果confirm函数返回false，则阻止关闭
        if (result === false) {
          return
        }
      } catch (error) {
        console.error('ArtDialog confirm callback error:', error)
        // 出错时不关闭对话框
        return
      }
    }

    // 如果配置了自动关闭且没有被阻止，则关闭对话框
    if (props.autoClose && !props.confirmLoading) {
      dialogVisible.value = false
    }
  } finally {
    internalLoading.value = false
  }
}

// 处理对话框打开
const handleOpen = () => {
  emit('open')
  if (typeof props.open === 'function') {
    props.open()
  }
}

// 处理对话框关闭前的回调
const handleBeforeClose = (done: () => void) => {
  if (props.beforeClose) {
    props.beforeClose(done)
  } else {
    done()
  }
}

// 处理对话框关闭后的回调
const handleClosed = () => {
  emit('closed')
}
</script>

<style lang="scss" scoped>
.art-dialog-container {
  display: contents; /* 使该元素不产生盒模型，但其子元素仍正常显示 */
}

.art-dialog {
  :deep(.el-dialog__header) {
    padding: 16px 20px;
    margin-right: 0;
    border-bottom: 1px solid var(--el-border-color-lighter);
  }

  :deep(.el-dialog__body) {
    padding: 20px;
    max-height: calc(80vh - 110px);
    overflow-y: auto;
  }

  :deep(.el-dialog__footer) {
    padding: 16px 20px;
    border-top: 1px solid var(--el-border-color-lighter);
  }

  .art-dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
  }
}
</style>
