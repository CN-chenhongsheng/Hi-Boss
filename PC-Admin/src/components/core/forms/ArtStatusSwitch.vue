<template>
  <div class="art-status-switch">
    <el-switch
      v-model="currentValue"
      :active-value="activeValue"
      :inactive-value="inactiveValue"
      :active-text="showText ? activeText : ''"
      :inactive-text="showText ? inactiveText : ''"
      :disabled="disabled"
      :loading="loading"
      :class="switchClass"
      :inline-prompt="inlinePrompt"
      :active-icon="activeIcon"
      :inactive-icon="inactiveIcon"
      @change="handleChange"
    />
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { Check, Close } from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'

const props = withDefaults(
  defineProps<{
    /** 绑定值 */
    modelValue?: number | string | boolean
    /** 打开时的值 */
    activeValue?: number | string | boolean
    /** 关闭时的值 */
    inactiveValue?: number | string | boolean
    /** 打开时的文字描述 */
    activeText?: string
    /** 关闭时的文字描述 */
    inactiveText?: string
    /** 禁用状态 */
    disabled?: boolean
    /** 加载状态 */
    loading?: boolean
    /** 尺寸 */
    size?: 'small' | 'default' | 'large'
    /** 是否显示文字描述 */
    showText?: boolean
    /** 是否显示内嵌提示 */
    inlinePrompt?: boolean
    /** 打开时的图标 */
    activeIcon?: any
    /** 关闭时的图标 */
    inactiveIcon?: any
    /** 是否需要确认 */
    needConfirm?: boolean
    /** 确认标题 */
    confirmTitle?: string
    /** 确认内容 */
    confirmContent?: string
  }>(),
  {
    modelValue: 1,
    activeValue: 1,
    inactiveValue: 0,
    activeText: '启用',
    inactiveText: '禁用',
    disabled: false,
    loading: false,
    size: 'default',
    showText: false,
    inlinePrompt: true,
    activeIcon: Check,
    inactiveIcon: Close,
    needConfirm: true,
    confirmTitle: '确认操作',
    confirmContent: '是否确认更改状态？'
  }
)

const emit = defineEmits<{
  (e: 'update:modelValue', value: number | string | boolean): void
  (e: 'change', value: number | string | boolean): void
}>()

// 内部值
const currentValue = ref(props.modelValue)
// 保存上一次的值，用于取消操作时恢复
const previousValue = ref(props.modelValue)

// 监听外部值变化
watch(
  () => props.modelValue,
  (val) => {
    currentValue.value = val
    previousValue.value = val
  }
)

// 监听内部值变化，向外部发射事件
watch(
  () => currentValue.value,
  (val) => {
    emit('update:modelValue', val)
  }
)

// 根据状态计算类样式
const switchClass = computed(() => {
  return [
    `art-switch-${props.size}`,
    {
      'art-switch-success': currentValue.value === props.activeValue,
      'art-switch-danger': currentValue.value === props.inactiveValue,
      'art-switch-no-text': !props.showText,
      'art-switch-inline-prompt': props.inlinePrompt
    }
  ]
})

// 切换事件处理
const handleChange = (val: number | string | boolean) => {
  if (props.needConfirm) {
    // 保存当前值，以便在用户取消时恢复
    const newValue = val
    // 显示确认对话框
    ElMessageBox.confirm(props.confirmContent, props.confirmTitle, {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
      .then(() => {
        // 用户确认，保持当前值并发出事件
        previousValue.value = newValue
        emit('change', newValue)
      })
      .catch(() => {
        // 用户取消，恢复到之前的值
        currentValue.value = previousValue.value
      })
  } else {
    // 不需要确认，直接发出事件
    previousValue.value = val
    emit('change', val)
  }
}
</script>

<style lang="scss" scoped>
.art-status-switch {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
</style>
