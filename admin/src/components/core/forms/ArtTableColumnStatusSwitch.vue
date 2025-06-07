<template>
  <el-table-column :prop="prop" :label="label" :width="width" :min-width="minWidth" :align="align">
    <template #default="scope">
      <el-switch
        :model-value="getRowValue(scope.row)"
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
        @update:model-value="(val) => handleChange(val, scope.row)"
      />
    </template>
  </el-table-column>
</template>

<script setup lang="ts">
import { Check, Close } from '@element-plus/icons-vue'

const props = withDefaults(
  defineProps<{
    /** 对应列的字段名 */
    prop: string
    /** 列标题 */
    label: string
    /** 列宽度 */
    width?: string | number
    /** 列最小宽度 */
    minWidth?: string | number
    /** 对齐方式 */
    align?: 'left' | 'center' | 'right'
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
  }>(),
  {
    width: undefined,
    minWidth: undefined,
    align: 'center',
    activeValue: 1,
    inactiveValue: 0,
    activeText: '启用',
    inactiveText: '禁用',
    disabled: true,
    loading: false,
    size: 'default',
    showText: false,
    inlinePrompt: true,
    activeIcon: Check,
    inactiveIcon: Close
  }
)

const emit = defineEmits<{
  (e: 'change', value: number | string | boolean, row: any): void
}>()

// 获取行数据的值
const getRowValue = (row: any) => {
  return row[props.prop]
}

// 根据状态计算类样式
const switchClass = computed(() => {
  return [
    `art-switch-${props.size}`,
    {
      'art-switch-success': true,
      'art-switch-danger': true,
      'art-switch-no-text': !props.showText,
      'art-switch-inline-prompt': props.inlinePrompt
    }
  ]
})

// 切换事件处理
const handleChange = (val: number | string | boolean, row: any) => {
  emit('change', val, row)
}
</script>

<style lang="scss" scoped>
:deep(.el-switch) {
  &.art-switch-success {
    &.is-checked {
      .el-switch__core {
        background-color: var(--el-color-success);
        border-color: var(--el-color-success);
      }
    }
  }

  &.art-switch-danger {
    &:not(.is-checked) {
      .el-switch__core {
        background-color: var(--el-color-danger);
        border-color: var(--el-color-danger);
      }
    }
  }

  &.art-switch-small {
    --el-switch-on-color: var(--el-color-primary);
    --el-switch-off-color: var(--el-color-danger);
    transform: scale(0.85);
    transform-origin: center left;
  }

  &.art-switch-large {
    --el-switch-on-color: var(--el-color-primary);
    --el-switch-off-color: var(--el-color-danger);
    transform: scale(1.15);
    transform-origin: center left;
  }

  &.art-switch-no-text {
    .el-switch__label {
      display: none;
    }
  }

  &.art-switch-inline-prompt {
    .el-switch__inner {
      .is-icon {
        color: var(--el-color-white);
      }
    }
  }
}
</style>
