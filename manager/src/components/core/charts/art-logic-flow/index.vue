<!-- LogicFlow 流程图组件 -->
<template>
  <div
    ref="containerRef"
    class="art-logic-flow-container"
    :class="{ readonly: props.readonly }"
    :style="containerStyle"
  ></div>
</template>

<script setup lang="ts">
  import LogicFlow from '@logicflow/core'
  import '@logicflow/core/dist/index.css'
  import { onMounted, onUnmounted, watch, nextTick } from 'vue'
  import { useWindowSize } from '@vueuse/core'
  import { useSettingStore } from '@/store/modules/setting'
  import { storeToRefs } from 'pinia'
  import { SystemThemeEnum } from '@/enums/appEnum'
  import type {
    LogicFlowData,
    LogicFlowConfig,
    NodeClickEvent,
    EdgeClickEvent,
    DataChangeEvent
  } from './types'
  import { getDefaultConfig, getReadonlyConfig, getDarkThemeConfig } from './config'
  import { validateLogicFlowData } from './utils'
  import { registerGlassNode } from './custom-nodes'

  defineOptions({ name: 'ArtLogicFlow' })

  interface Props {
    /** 流程图数据 */
    data?: LogicFlowData
    /** LogicFlow 配置 */
    config?: LogicFlowConfig
    /** 是否只读模式 */
    readonly?: boolean
    /** 是否允许调整边（拖拽连接） */
    allowEdgeAdjustment?: boolean
    /** 容器高度 */
    height?: string | number
    /** 容器宽度 */
    width?: string | number
    /** 是否自适应容器大小 */
    autoResize?: boolean
  }

  const props = withDefaults(defineProps<Props>(), {
    data: () => ({ nodes: [], edges: [] }),
    config: () => ({}),
    readonly: false,
    allowEdgeAdjustment: true,
    height: '600px',
    width: '100%',
    autoResize: true
  })

  interface Emits {
    (e: 'node:click', event: NodeClickEvent): void
    (e: 'node:add', node: any): void
    (e: 'node:delete', node: any): void
    (e: 'edge:click', event: EdgeClickEvent): void
    (e: 'edge:add', edge: any): void
    (e: 'edge:delete', edge: any): void
    (e: 'data:change', event: DataChangeEvent): void
  }

  const emit = defineEmits<Emits>()

  const containerRef = ref<HTMLDivElement>()
  let lfInstance: LogicFlow | null = null
  const { width: windowWidth, height: windowHeight } = useWindowSize()
  const settingStore = useSettingStore()
  const { systemThemeType } = storeToRefs(settingStore)

  // 容器样式
  const containerStyle = computed(() => {
    const style: Record<string, string> = {}
    if (props.height) {
      style.height = typeof props.height === 'number' ? `${props.height}px` : props.height
    }
    if (props.width) {
      style.width = typeof props.width === 'number' ? `${props.width}px` : props.width
    }
    return style
  })

  /**
   * 获取合并后的配置
   */
  const getMergedConfig = (): any => {
    let baseConfig: LogicFlowConfig

    if (props.readonly) {
      baseConfig = getReadonlyConfig()
    } else {
      baseConfig = getDefaultConfig()
    }

    // 应用主题
    if (systemThemeType.value === SystemThemeEnum.DARK) {
      baseConfig = { ...baseConfig, ...getDarkThemeConfig() }
    }

    // 合并用户配置，LogicFlow 需要 container 属性
    return {
      ...baseConfig,
      ...props.config,
      container: containerRef.value
    }
  }

  /**
   * 初始化 LogicFlow
   */
  const initLogicFlow = async () => {
    if (!containerRef.value) return

    await nextTick()

    const config = getMergedConfig()
    lfInstance = new LogicFlow(config)

    // 注册自定义节点
    registerGlassNode(lfInstance)

    // 注册事件监听
    setupEventListeners()

    // 渲染数据
    if (props.data && props.data.nodes.length > 0) {
      const validation = validateLogicFlowData(props.data)
      if (validation.valid) {
        lfInstance.render(props.data)
        // 渲染后自动居中适应视图
        await nextTick()
        lfInstance.fitView(50) // 50px 边距
      } else {
        console.warn('[ArtLogicFlow] 数据验证失败:', validation.errors)
      }
    }
  }

  /**
   * 设置事件监听
   */
  const setupEventListeners = () => {
    if (!lfInstance) return

    // 节点点击
    lfInstance.on('node:click', ({ data, e }: any) => {
      emit('node:click', { node: data, e })
    })

    // 节点添加
    lfInstance.on('node:add', ({ data }: any) => {
      emit('node:add', data)
      emitDataChange('add')
    })

    // 节点删除
    lfInstance.on('node:delete', ({ data }: any) => {
      emit('node:delete', data)
      emitDataChange('delete')
    })

    // 边点击
    lfInstance.on('edge:click', ({ data, e }: any) => {
      emit('edge:click', { edge: data, e })
    })

    // 边添加
    lfInstance.on('edge:add', ({ data }: any) => {
      emit('edge:add', data)
      emitDataChange('add')
    })

    // 边删除
    lfInstance.on('edge:delete', ({ data }: any) => {
      emit('edge:delete', data)
      emitDataChange('delete')
    })

    // 节点移动
    lfInstance.on('node:mousemove', () => {
      emitDataChange('move')
    })
  }

  /**
   * 触发数据变化事件
   */
  const emitDataChange = (type: DataChangeEvent['type']) => {
    if (!lfInstance) return
    const data = lfInstance.getGraphData() as any as LogicFlowData
    emit('data:change', { data, type })
  }

  /**
   * 调整画布大小
   */
  const resizeLogicFlow = () => {
    if (!lfInstance || !containerRef.value) return
    nextTick(() => {
      lfInstance?.resize()
    })
  }

  // 监听窗口大小变化
  if (props.autoResize) {
    watch([windowWidth, windowHeight], () => {
      resizeLogicFlow()
    })
  }

  // 监听数据变化
  watch(
    () => props.data,
    async (newData) => {
      if (!lfInstance || !newData) return
      const validation = validateLogicFlowData(newData)
      if (validation.valid) {
        lfInstance.render(newData)
        // 渲染后自动居中
        await nextTick()
        lfInstance.fitView(50)
      }
    },
    { deep: true }
  )

  // 监听只读模式变化
  watch(
    () => props.readonly,
    () => {
      if (lfInstance) {
        lfInstance.updateEditConfig({
          isSilentMode: props.readonly,
          adjustNodePosition: !props.readonly,
          adjustEdgeStartAndEnd: !props.readonly && props.allowEdgeAdjustment
        })
      }
    }
  )

  // 暴露方法
  defineExpose({
    /**
     * 获取 LogicFlow 实例
     */
    getInstance: () => lfInstance,
    /**
     * 获取当前流程图数据
     */
    getData: (): LogicFlowData | null => {
      if (!lfInstance) return null
      const data = lfInstance.getGraphData() as any
      return data as LogicFlowData
    },
    /**
     * 设置流程图数据
     */
    setData: (data: LogicFlowData) => {
      if (!lfInstance) return
      const validation = validateLogicFlowData(data)
      if (validation.valid) {
        lfInstance.render(data)
      } else {
        console.error('[ArtLogicFlow] 数据验证失败:', validation.errors)
      }
    },
    /**
     * 添加节点
     */
    addNode: (node: any) => {
      if (!lfInstance) return
      lfInstance.addNode(node)
    },
    /**
     * 添加边
     */
    addEdge: (edge: any) => {
      if (!lfInstance) return
      lfInstance.addEdge(edge)
    },
    /**
     * 删除节点
     */
    deleteNode: (nodeId: string) => {
      if (!lfInstance) return
      lfInstance.deleteNode(nodeId)
    },
    /**
     * 删除边
     */
    deleteEdge: (edgeId: string) => {
      if (!lfInstance) return
      lfInstance.deleteEdge(edgeId)
    },
    /**
     * 放大
     */
    zoomIn: () => {
      if (!lfInstance) return
      lfInstance.zoom(true)
    },
    /**
     * 缩小
     */
    zoomOut: () => {
      if (!lfInstance) return
      lfInstance.zoom(false)
    },
    /**
     * 重置缩放
     */
    resetZoom: () => {
      if (!lfInstance) return
      lfInstance.resetZoom()
    },
    /**
     * 适应视图
     */
    fitView: () => {
      if (!lfInstance) return
      lfInstance.fitView()
    },
    /**
     * 清空画布
     */
    clear: () => {
      if (!lfInstance) return
      lfInstance.clearData()
    },
    /**
     * 调整大小
     */
    resize: () => {
      resizeLogicFlow()
    }
  })

  onMounted(() => {
    initLogicFlow()
  })

  onUnmounted(() => {
    if (lfInstance) {
      lfInstance.destroy()
      lfInstance = null
    }
  })
</script>

<style scoped lang="scss">
  .art-logic-flow-container {
    width: 100%;
    height: 100%;
    position: relative;
    overflow: hidden;
    border-radius: 4px;
    // 直接在容器上设置背景
    background-color: #f8fafc !important;
    background-image: radial-gradient(circle, #d0d5dd 1px, transparent 1px) !important;
    background-size: 20px 20px !important;

    // 强制 LogicFlow 所有内部元素透明
    :deep(.lf-container),
    :deep(.lf-canvas),
    :deep(.lf-canvas-overlay),
    :deep(.lf-background),
    :deep(.lf-grid),
    :deep(lf-graph),
    :deep(svg) {
      background: transparent !important;
      background-color: transparent !important;
    }

    // 隐藏网格 SVG
    :deep(.lf-grid) {
      display: none !important;
    }

    // 节点样式适配
    :deep(.lf-node) {
      cursor: pointer;

      // 强制移除 rect 的默认 stroke 和 fill
      rect {
        stroke: none !important;
        fill: transparent !important;
      }

      // 移除默认的 hover 效果
      &:hover {
        rect {
          stroke: none !important;
          filter: none;
          transform: none;
        }
      }
    }

    // 隐藏 LogicFlow 默认的选中边框（虚线框）
    :deep(.lf-node-select-rect),
    :deep(.lf-outline),
    :deep(.lf-node-anchor),
    :deep(.lf-anchor),
    :deep(.lf-resize-control),
    :deep(.lf-rotate-control) {
      display: none !important;
      visibility: hidden !important;
      opacity: 0 !important;
    }

    // 文本样式适配
    :deep(.lf-node-text) {
      display: none !important;
    }

    // 边样式适配
    :deep(.lf-edge) {
      path {
        transition: all 0.3s ease;
      }
      &:hover {
        path {
          stroke-width: 2px;
          stroke: var(--el-color-primary);
        }
      }
    }

    // 隐藏边的锚点
    :deep(.lf-edge-anchor),
    :deep(.lf-adjust-point) {
      display: none !important;
    }

    // 只读模式样式
    &.readonly {
      :deep(.lf-node) {
        cursor: default;
      }
    }
  }
</style>
