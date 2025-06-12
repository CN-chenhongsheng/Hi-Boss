<!-- 表格按钮，支持文字和图标 -->
<template>
  <!-- 小尺寸表格：只显示文字 -->
  <span v-if="tableSize === TableSizeEnum.SMALL" class="btn-text-only" @click="handleClick">
    {{ buttonText }}
  </span>
  <!-- 默认尺寸表格：仅图标方块按钮 -->
  <div
    v-else-if="tableSize === TableSizeEnum.DEFAULT"
    :class="['btn-text', buttonColor]"
    :style="buttonStyle"
    @click="handleClick"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave"
  >
    <i v-if="iconContent" class="iconfont-sys" v-html="currentIconContent" :style="iconStyle" />
  </div>
  <!-- 大尺寸表格：图标+文字 -->
  <div
    v-else-if="tableSize === TableSizeEnum.LARGE"
    :class="['btn-text-large', buttonColor]"
    :style="buttonStyle"
    @click="handleClick"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave"
  >
    <i v-if="iconContent" class="iconfont-sys" v-html="currentIconContent" :style="iconStyle" />
    <span class="btn-text-label">{{ buttonText }}</span>
  </div>
</template>

<script setup lang="ts">
import { BgColorEnum } from '@/enums/appEnum'
import { computed, ref } from 'vue'
import { useTableStore } from '@/store/modules/table'
import { TableSizeEnum } from '@/enums/formEnum'
import { getDarkColor } from '@/utils/ui'

const props = withDefaults(
  defineProps<{
    text?: string
    type?: 'add' | 'edit' | 'delete' | 'more' | 'detail' | 'restore'
    icon?: string // 自定义图标
    hoverIcon?: string // 自定义悬停时的图标
    iconClass?: BgColorEnum // 自定义按钮背景色、文字颜色
    iconColor?: string // 外部传入的图标文字颜色
    iconBgColor?: string // 外部传入的图标背景色
    darkLevel?: number // 颜色加深程度，默认0.2
  }>(),
  {
    darkLevel: 0.2
  }
)
const emit = defineEmits<{
  (e: 'click'): void
}>()
// 获取表格大小设置
const tableStore = useTableStore()
const tableSize = computed(() => tableStore.tableSize)
// 默认按钮配置：type 对应的图标和默认颜色
const defaultButtons = [
  {
    type: 'detail',
    icon: '&#xe73d;',
    hoverIcon: '&#xe73c;',
    color: BgColorEnum.SUCCESS,
    text: '详情'
  },
  { type: 'add', icon: '&#xe602;', color: BgColorEnum.PRIMARY, text: '添加' },
  { type: 'restore', icon: '&#xe6be;', color: BgColorEnum.WARNING, text: '恢复' },
  {
    type: 'edit',
    icon: '&#xe642;',
    hoverIcon: '&#xe65f;',
    color: BgColorEnum.SECONDARY,
    text: '编辑'
  },
  { type: 'delete', icon: '&#xe783;', color: BgColorEnum.ERROR, text: '删除' },
  { type: 'more', icon: '&#xe6df;', color: '', text: '更多' }
] as const

// 鼠标悬停状态
const isHovered = ref(false)

// 计算最终使用的图标：优先使用外部传入的 icon，否则根据 type 获取默认图标
const iconContent = computed(() => {
  return props.icon || defaultButtons.find((btn) => btn.type === props.type)?.icon || ''
})

// 计算悬停时的图标：优先使用外部传入的 hoverIcon，否则查找按钮类型默认的 hoverIcon
const hoverIconContent = computed(() => {
  const foundButton = defaultButtons.find((btn) => btn.type === props.type)
  return (
    props.hoverIcon ||
    (foundButton && 'hoverIcon' in foundButton ? foundButton.hoverIcon : null) ||
    iconContent.value
  ) // 如果没有定义悬停图标，则使用默认图标
})

// 根据悬停状态确定当前显示的图标
const currentIconContent = computed(() => {
  return isHovered.value && hoverIconContent.value ? hoverIconContent.value : iconContent.value
})

// 计算按钮的背景色：优先使用外部传入的 iconClass，否则根据 type 选默认颜色
const buttonColor = computed(() => {
  return props.iconClass || defaultButtons.find((btn) => btn.type === props.type)?.color || ''
})
// 计算按钮文本：优先使用传入的 text，否则使用默认文本
const buttonText = computed(() => {
  return props.text || defaultButtons.find((btn) => btn.type === props.type)?.text || ''
})
// 计算图标的颜色与背景色，支持外部传入
const iconStyle = computed(() => {
  return {
    ...(props.iconColor ? { color: props.iconColor } : {}),
    ...(props.iconBgColor ? { backgroundColor: props.iconBgColor } : {})
  }
})

// 计算按钮的CSS变量，用于hover效果
const buttonStyle = computed(() => {
  if (!props.iconBgColor) return {}

  // 计算更深的颜色用于hover效果
  const darkerColor = getDarkColor(props.iconBgColor, props.darkLevel)

  return {
    '--hover-bg-color': darkerColor
  }
})

const handleClick = () => {
  emit('click')
}

// 鼠标进入事件
const handleMouseEnter = () => {
  isHovered.value = true
}

// 鼠标离开事件
const handleMouseLeave = () => {
  isHovered.value = false
}
</script>

<style scoped lang="scss">
// 基础样式
.btn-base {
  cursor: pointer;
  transition: all 0.2s;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

// 默认大小按钮 - 方块形式
.btn-text {
  @extend .btn-base;
  display: inline-block;
  min-width: 34px;
  height: 34px;
  padding: 0 10px;
  margin-right: 10px;
  font-size: 13px;
  line-height: 34px;
  color: #666;
  background-color: rgba(var(--art-gray-200-rgb), 0.7);
  border-radius: 6px;

  &:hover {
    .iconfont-sys {
      transform: scale(1.2);
    }
  }

  .iconfont-sys {
    display: inline-block;
    transition: transform 0.3s ease;
  }

  &:last-child {
    margin-right: 0;
  }
}

// 小尺寸 - 仅文字
.btn-text-only {
  @extend .btn-base;
  display: inline-block;
  margin-right: 12px;
  font-size: 13px;
  color: var(--main-color);
  text-decoration: none;
  transition: transform 0.3s ease;

  &:hover {
    transform: translateY(-2px);
  }

  &:last-child {
    margin-right: 0;
  }
}

// 大尺寸 - 图标+文字
.btn-text-large {
  @extend .btn-base;
  display: inline-flex;
  align-items: center;
  height: 34px;
  padding: 0 12px;
  margin-right: 10px;
  font-size: 13px;
  line-height: 34px;
  color: #666;
  background-color: rgba(var(--art-gray-200-rgb), 0.7);
  border-radius: 6px;

  &:hover {
    .iconfont-sys {
      transform: scale(1.2);
    }
  }

  .iconfont-sys {
    display: inline-block;
    margin-right: 5px;
    transition: transform 0.3s ease;
  }

  .btn-text-label {
    display: inline-block;
  }

  &:last-child {
    margin-right: 0;
  }
}
</style>
