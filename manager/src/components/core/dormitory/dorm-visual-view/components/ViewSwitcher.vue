<!--
  ViewSwitcher 视图切换器组件
  @description 表格/平面图视图切换
  @author 陈鸿昇
-->
<template>
  <div class="art-view-switcher">
    <button
      type="button"
      class="art-view-switcher__btn"
      :class="{ 'is-active': isTableView }"
      @click="switchView('table')"
    >
      <ArtSvgIcon icon="ri:table-line" />
      <span>表格</span>
    </button>
    <button
      type="button"
      class="art-view-switcher__btn"
      :class="{ 'is-active': isVisualView }"
      @click="switchView('visual')"
    >
      <ArtSvgIcon icon="ri:map-2-line" />
      <span>平面图</span>
    </button>
  </div>
</template>

<script setup lang="ts">
  import { computed } from 'vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import type { ViewType } from '../types'

  defineOptions({ name: 'ViewSwitcher' })

  // ==================== Props ====================
  interface Props {
    /** 当前视图类型 */
    modelValue: ViewType
  }

  const props = defineProps<Props>()

  // ==================== Emits ====================
  const emit = defineEmits<{
    (e: 'update:modelValue', value: ViewType): void
  }>()

  // ==================== Computed ====================

  /** 是否为表格视图 */
  const isTableView = computed(() => props.modelValue === 'table')

  /** 是否为可视化视图 */
  const isVisualView = computed(() => props.modelValue === 'visual')

  // ==================== Methods ====================

  /** 切换视图 */
  const switchView = (view: ViewType) => {
    if (props.modelValue !== view) {
      emit('update:modelValue', view)
    }
  }
</script>

<style lang="scss" scoped>
  // 样式通过全局类 .art-view-switcher 实现，见 app.scss
</style>
