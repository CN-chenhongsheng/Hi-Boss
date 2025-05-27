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
    @click="handleClick"
  >
    <i v-if="iconContent" class="iconfont-sys" v-html="iconContent" :style="iconStyle" />
  </div>
  <!-- 大尺寸表格：图标+文字 -->
  <div
    v-else-if="tableSize === TableSizeEnum.LARGE"
    :class="['btn-text-large', buttonColor]"
    @click="handleClick"
  >
    <i v-if="iconContent" class="iconfont-sys" v-html="iconContent" :style="iconStyle" />
    <span class="btn-text-label">{{ buttonText }}</span>
  </div>
</template>

<script setup lang="ts">
import { BgColorEnum } from '@/enums/appEnum'
import { computed } from 'vue'
import { useTableStore } from '@/store/modules/table'
import { TableSizeEnum } from '@/enums/formEnum'
const props = withDefaults(
  defineProps<{
    text?: string
    type?: 'add' | 'edit' | 'delete' | 'more' | 'detail'
    icon?: string // 自定义图标
    iconClass?: BgColorEnum // 自定义按钮背景色、文字颜色
    iconColor?: string // 外部传入的图标文字颜色
    iconBgColor?: string // 外部传入的图标背景色
  }>(),
  {}
)
const emit = defineEmits<{
  (e: 'click'): void
}>()
// 获取表格大小设置
const tableStore = useTableStore()
const tableSize = computed(() => tableStore.tableSize)
// 默认按钮配置：type 对应的图标和默认颜色
const defaultButtons = [
  { type: 'add', icon: '&#xe602;', color: BgColorEnum.PRIMARY, text: '添加' },
  { type: 'edit', icon: '&#xe642;', color: BgColorEnum.SECONDARY, text: '编辑' },
  { type: 'delete', icon: '&#xe783;', color: BgColorEnum.ERROR, text: '删除' },
  { type: 'detail', icon: '&#xe73c;', color: BgColorEnum.SUCCESS, text: '详情' },
  { type: 'more', icon: '&#xe6df;', color: '', text: '更多' }
] as const
// 计算最终使用的图标：优先使用外部传入的 icon，否则根据 type 获取默认图标
const iconContent = computed(() => {
  return props.icon || defaultButtons.find((btn) => btn.type === props.type)?.icon || ''
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
const handleClick = () => {
  emit('click')
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
    color: var(--main-color) !important;
    background-color: rgba(var(--art-gray-300-rgb), 0.6) !important;

    .iconfont-sys {
      transform: scale(1.2);
    }
  }

  .iconfont-sys {
    display: inline-block;
    transition: transform 0.3s ease;
  }
}

// 小尺寸 - 仅文字
.btn-text-only {
  @extend .btn-base;
  display: inline-block;
  margin-right: 12px;
  font-size: 13px;
  color: #666;
  text-decoration: none;
  color: var(--main-color) !important;
  transition: transform 0.3s ease;

  &:hover {
    transform: translateY(-2px);
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
    color: var(--main-color) !important;
    background-color: rgba(var(--art-gray-300-rgb), 0.6) !important;
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
}
</style>

