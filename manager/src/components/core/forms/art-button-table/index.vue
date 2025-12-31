<!-- 表格按钮 -->
<template>
  <div
    :class="[
      'art-button-table inline-flex items-center justify-center min-w-8 h-8 px-2.5 mr-2.5 text-sm c-p rounded-md align-middle',
      isCompactMode ? 'compact-mode' : buttonClass
    ]"
    :style="buttonStyle"
    @click="handleClick"
  >
    <ArtSvgIcon :icon="iconContent" />
  </div>
</template>

<script setup lang="ts">
  import { storeToRefs } from 'pinia'
  import { useTableStore } from '@/store/modules/table'
  import { TableSizeEnum } from '@/enums/formEnum'

  defineOptions({ name: 'ArtButtonTable' })

  interface Props {
    /** 按钮类型 */
    type?: 'add' | 'edit' | 'delete' | 'more' | 'view'
    /** 按钮图标 */
    icon?: string
    /** 按钮样式类 */
    iconClass?: string
    /** icon 颜色 */
    iconColor?: string
    /** 按钮背景色 */
    buttonBgColor?: string
  }

  const props = withDefaults(defineProps<Props>(), {})

  const emit = defineEmits<{
    (e: 'click'): void
  }>()

  // 获取表格大小
  const tableStore = useTableStore()
  const { tableSize } = storeToRefs(tableStore)

  // 判断是否为紧凑模式（紧凑或默认）
  const isCompactMode = computed(() => {
    return tableSize.value === TableSizeEnum.SMALL || tableSize.value === TableSizeEnum.DEFAULT
  })

  // 默认按钮配置
  const defaultButtons = {
    add: { icon: 'ri:add-fill', class: 'bg-theme/12 text-theme' },
    edit: { icon: 'ri:pencil-line', class: 'bg-secondary/12 text-secondary' },
    delete: { icon: 'ri:delete-bin-5-line', class: 'bg-error/12 text-error' },
    view: { icon: 'ri:eye-line', class: 'bg-info/12 text-info' },
    more: { icon: 'ri:more-2-fill', class: '' }
  } as const

  // 获取图标内容
  const iconContent = computed(() => {
    return props.icon || (props.type ? defaultButtons[props.type]?.icon : '') || ''
  })

  // 获取按钮样式类
  const buttonClass = computed(() => {
    return props.iconClass || (props.type ? defaultButtons[props.type]?.class : '') || ''
  })

  // 动态按钮样式
  const buttonStyle = computed(() => {
    const style: Record<string, string> = {}

    if (isCompactMode.value) {
      // 紧凑模式：背景透明，只显示图标颜色
      style.backgroundColor = 'transparent'
      if (props.iconColor) {
        style.color = props.iconColor
      } else if (props.type) {
        // 根据按钮类型设置图标颜色
        const typeColors: Record<string, string> = {
          add: 'var(--el-color-primary)',
          edit: 'var(--el-color-info)',
          delete: 'var(--el-color-danger)',
          view: 'var(--el-color-info)',
          more: 'var(--el-text-color-regular)'
        }
        style.color = typeColors[props.type] || 'var(--el-text-color-regular)'
      }
    } else {
      // 宽松模式：使用原有样式
      if (props.buttonBgColor) {
        style.backgroundColor = props.buttonBgColor
      }
      if (props.iconColor) {
        style.color = props.iconColor
      }
    }

    return style
  })

  const handleClick = () => {
    emit('click')
  }
</script>

<style scoped lang="scss">
  .art-button-table {
    :deep(.art-svg-icon) {
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      transform-origin: center;
    }

    &:hover :deep(.art-svg-icon) {
      transform: scale(1.1);
    }

    &:active :deep(.art-svg-icon) {
      transform: scale(0.95);
    }
  }

  // 紧凑模式下的透明度效果
  .art-button-table.compact-mode {
    transition: background-color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    background-color: transparent !important;

    &:hover {
      background-color: rgba(0, 0, 0, 0.05) !important;
    }

    &.dark-mode:hover {
      background-color: rgba(255, 255, 255, 0.05) !important;
    }
  }
</style>
