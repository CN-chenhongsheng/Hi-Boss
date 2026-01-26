<!-- 流程编辑弹窗 - 可视化流程编辑器 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '新建审批流程' : '编辑审批流程'"
    width="90%"
    top="5vmin"
    :close-on-click-modal="false"
    destroy-on-close
    @closed="handleClosed"
  >
    <div class="dialog-content">
      <!-- 可视化流程编辑区域 -->
      <div class="flow-canvas-wrapper">
        <div class="canvas-container" ref="canvasContainerRef">
          <!-- LogicFlow 画布 -->
          <div ref="lfContainerRef" class="lf-container"></div>

          <!-- LogicFlow 工具栏 -->
          <LogicFlowToolbar
            :show-zoom-in="true"
            :show-zoom-out="true"
            :show-reset-zoom="true"
            :show-fit-view="true"
            :show-undo="false"
            :show-redo="false"
            :show-mini-map="true"
            :show-fullscreen="true"
            :show-export="true"
            :mini-map-visible="miniMapVisible"
            :is-fullscreen="isFullscreen"
            @zoom-in="handleZoomIn"
            @zoom-out="handleZoomOut"
            @reset-zoom="handleResetZoom"
            @fit-view="handleFitView"
            @toggle-minimap="handleToggleMiniMap"
            @toggle-fullscreen="handleToggleFullscreen"
            @export-image="handleExportImage"
          />

          <!-- 节点编辑卡片 -->
          <NodeEditorCard
            ref="nodeEditorRef"
            v-model:visible="nodeEditorVisible"
            :node-data="selectedNodeData"
            :node-type="selectedNodeType"
            :position="nodeEditorPosition"
            :flow-data="formData"
            :business-type-options="businessTypeOptionsList"
            :dialog-type="dialogType"
            @update="handleNodeUpdate"
            @delete="handleNodeDelete"
            @select-approver="openAssigneeSelect"
            @update-flow="handleFlowInfoUpdate"
            @update:position="handleNodeEditorPositionUpdate"
          />
        </div>
      </div>
    </div>

    <template #footer>
      <ElButton @click="dialogVisible = false" v-ripple>取消</ElButton>
      <ElButton type="primary" :loading="submitLoading" @click="handleSubmit" v-ripple>
        保存流程
      </ElButton>
    </template>

    <!-- 审批人选择弹窗 -->
    <AssigneeSelectDialog
      v-model="assigneeDialogVisible"
      :selected-ids="currentSelectedIds"
      @confirm="handleAssigneeConfirm"
    />
  </ElDialog>
</template>

<script setup lang="ts">
  import { ref, reactive, computed, watch, nextTick, onUnmounted, onMounted } from 'vue'
  import LogicFlow from '@logicflow/core'
  import '@logicflow/core/dist/index.css'
  import { MiniMap, Snapshot } from '@logicflow/extension'
  import '@logicflow/extension/lib/style/index.css'
  import { useFullscreen } from '@vueuse/core'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import {
    fetchAddFlow,
    fetchUpdateFlow,
    fetchGetFlowDetail,
    type ApprovalFlow,
    type ApprovalNode,
    type ApprovalAssignee
  } from '@/api/approval-manage'
  import { registerApprovalNodes } from '@/components/core/charts/art-logic-flow/approval-node'
  import LogicFlowToolbar from '@/components/core/charts/art-logic-flow/toolbar.vue'
  import { useBusinessType } from '@/hooks'
  import { approvalNodesToLogicFlow, createNewApprovalNode, reorderNodes } from './flow-data-utils'
  import NodeEditorCard from './node-editor-card.vue'
  import AssigneeSelectDialog from './assignee-select-dialog.vue'

  const props = defineProps<{
    modelValue: boolean
    dialogType: 'add' | 'edit'
    flowData: ApprovalFlow | null
  }>()

  const emit = defineEmits<{
    'update:modelValue': [value: boolean]
    success: []
  }>()

  const dialogVisible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  // Refs
  const canvasContainerRef = ref<HTMLElement>()
  const lfContainerRef = ref<HTMLElement>()
  const nodeEditorRef = ref<InstanceType<typeof NodeEditorCard>>()

  // State
  const submitLoading = ref(false)
  const activeCollapse = ref(['info'])
  let lfInstance: LogicFlow | null = null

  // 工具栏状态
  const miniMapVisible = ref(false)
  const { isFullscreen, toggle: toggleFullscreen } = useFullscreen(canvasContainerRef)

  // 节点编辑器状态
  const nodeEditorVisible = ref(false)
  const selectedNodeData = ref<ApprovalNode | null>(null)
  const selectedNodeId = ref<string | null>(null)
  const selectedNodeType = ref<'start' | 'approval' | 'end' | null>(null)
  const nodeEditorPosition = ref({ x: 0, y: 0 })

  // 审批人选择状态
  const assigneeDialogVisible = ref(false)
  const currentSelectedIds = ref<number[]>([])

  // 业务类型（从字典获取）
  const { businessTypeOptions, fetchBusinessTypes } = useBusinessType()

  // 组件挂载时获取业务类型
  onMounted(() => {
    fetchBusinessTypes()
  })

  // 转换为可变数组，用于传递给组件
  const businessTypeOptionsList = computed(() => [...businessTypeOptions.value])

  // 初始表单数据
  const initialFormData = (): ApprovalFlow => ({
    flowName: '',
    flowCode: '',
    businessType: '',
    description: '',
    status: 1,
    nodes: []
  })

  const formData = reactive<ApprovalFlow>(initialFormData())

  // ResizeObserver 用于监听容器尺寸变化
  let resizeObserver: ResizeObserver | null = null

  // 初始化 LogicFlow
  const initLogicFlow = async () => {
    if (!lfContainerRef.value) return

    // 等待 DOM 完全渲染，确保容器尺寸正确
    await nextTick()
    // 增加延迟时间，确保弹窗完全展开
    await new Promise((resolve) => setTimeout(resolve, 300))
    // 使用 requestAnimationFrame 确保浏览器完成布局计算
    await new Promise((resolve) => requestAnimationFrame(resolve))

    // 注册插件
    LogicFlow.use(MiniMap)
    LogicFlow.use(Snapshot)

    // 获取容器的父元素尺寸（canvas-container）
    const parentEl = lfContainerRef.value.parentElement
    // 如果尺寸为 0 或未定义，使用默认值，后续会在 renderFlow 中重新调整
    const width = parentEl?.clientWidth || 800
    const height = parentEl?.clientHeight || 600

    lfInstance = new LogicFlow({
      width,
      height,
      container: lfContainerRef.value,
      grid: false,
      background: {
        color: '#f8fafc'
      },
      keyboard: {
        enabled: true
      },
      // 禁用默认的文本编辑
      textEdit: false,
      // 节点不可拖拽连线
      nodeTextDraggable: false,
      edgeTextDraggable: false,
      // 调整节点位置
      adjustNodePosition: false,
      // 禁止调整边
      adjustEdge: false,
      adjustEdgeStartAndEnd: false,
      // 静默模式（部分禁用交互）
      isSilentMode: false,
      // 禁止缩放滚动
      stopScrollGraph: false,
      stopZoomGraph: false,
      // 禁止移动节点
      stopMoveGraph: false,
      // 节点可选
      nodeSelectedOutline: false
    })

    // 注册自定义节点
    registerApprovalNodes(lfInstance)

    // 监听节点点击
    lfInstance.on('node:click', ({ data }) => {
      handleNodeClick(data)
    })

    // 监听边（连接线）点击 - 在边中间添加节点
    lfInstance.on('edge:click', ({ data }) => {
      handleEdgeClick(data)
    })

    // 监听自定义节点删除事件（从节点卡片删除按钮触发）
    handleNodeDeleteFromButton = (e: Event) => {
      const customEvent = e as CustomEvent
      const { nodeId } = customEvent.detail || {}

      // 尝试从 LogicFlow 实例获取节点属性（最可靠的方式）
      if (lfInstance && nodeId) {
        try {
          const lfNodeModel = lfInstance.getNodeModelById(nodeId)
          if (lfNodeModel) {
            // 节点属性将在 handleNodeDelete 中获取
          }
        } catch (error) {
          console.warn('[FlowEditDialog] 无法从 LogicFlow 获取节点属性:', error)
        }
      }

      // 选中节点并删除 - 使用 LogicFlow 的节点 ID 作为 selectedNodeId
      selectedNodeId.value = nodeId
      selectedNodeType.value = 'approval'

      // 调用删除函数（handleNodeDelete 会尝试多种方式查找节点）
      handleNodeDelete()
    }

    // 监听 DOM 自定义事件（从 document 监听，确保能捕获所有事件）
    if (handleNodeDeleteFromButton) {
      document.addEventListener('logicflow-node-delete', handleNodeDeleteFromButton)
    }

    // 监听画布点击（取消选中）
    lfInstance.on('blank:click', () => {
      clearSelection()
    })

    // 监听容器尺寸变化，自动调整画布尺寸
    if (parentEl) {
      resizeObserver = new ResizeObserver(() => {
        if (lfInstance && parentEl) {
          const newWidth = parentEl.clientWidth
          const newHeight = parentEl.clientHeight
          if (newWidth > 0 && newHeight > 0) {
            lfInstance.resize(newWidth, newHeight)
          }
        }
      })
      resizeObserver.observe(parentEl)
    }

    // 渲染流程（会在 renderFlow 中重新调整尺寸）
    renderFlow()
  }

  // 键盘事件处理函数（用于删除节点）
  let keyDownHandler: ((e: KeyboardEvent) => void) | null = null

  // 节点删除按钮点击事件处理函数
  let handleNodeDeleteFromButton: ((e: Event) => void) | null = null

  // 渲染流程图
  const renderFlow = () => {
    if (!lfInstance) return

    try {
      // 先清空画布，确保完全重新渲染
      lfInstance.clearData()

      const flowData = approvalNodesToLogicFlow(formData.nodes || [], selectedNodeId.value, {
        flowName: formData.flowName,
        businessType: formData.businessType,
        status: formData.status
      })

      // 确保有边数据
      if (!flowData.edges || flowData.edges.length === 0) {
        console.warn(
          '[FlowEditDialog] 生成的流程数据中没有边，节点数:',
          flowData.nodes?.length || 0
        )
      }

      // 获取容器实际尺寸并调整画布
      const parentEl = lfContainerRef.value?.parentElement
      if (parentEl && lfInstance) {
        const actualWidth = parentEl.clientWidth
        const actualHeight = parentEl.clientHeight
        // 只有当尺寸大于 0 时才调整（避免在容器未完全渲染时使用错误尺寸）
        if (actualWidth > 0 && actualHeight > 0) {
          lfInstance.resize(actualWidth, actualHeight)
        }
      }

      // 重新渲染流程（包括所有节点和边）
      lfInstance.render(flowData)
    } catch (error) {
      console.error('[FlowEditDialog] 渲染流程失败:', error)
    }
  }

  // 处理节点点击
  const handleNodeClick = (data: any) => {
    const { type, id, x, y, properties } = data

    // 处理开始节点
    if (type === 'start-node') {
      selectedNodeId.value = id
      selectedNodeType.value = 'start'
      selectedNodeData.value = null

      // 计算编辑器位置
      const canvasRect = canvasContainerRef.value?.getBoundingClientRect()
      if (canvasRect && lfInstance) {
        const { transformModel } = lfInstance.graphModel
        const { SCALE_X, SCALE_Y, TRANSLATE_X, TRANSLATE_Y } = transformModel
        const screenX = x * SCALE_X + TRANSLATE_X
        const screenY = y * SCALE_Y + TRANSLATE_Y
        nodeEditorPosition.value = { x: screenX, y: screenY }
      }

      nodeEditorVisible.value = true
      updateNodeSelection()
      return
    }

    // 处理结束节点（只显示选中状态，不弹出编辑器）
    if (type === 'end-node') {
      selectedNodeId.value = id
      selectedNodeType.value = 'end'
      selectedNodeData.value = null
      nodeEditorVisible.value = false
      updateNodeSelection()
      return
    }

    // 处理审批节点
    if (type !== 'approval-node') {
      clearSelection()
      return
    }

    // 更新选中状态
    selectedNodeId.value = id
    selectedNodeType.value = 'approval'

    // 找到对应的节点数据
    const nodeIndex = formData.nodes?.findIndex((n) => `approval-${n.id}` === id)
    if (nodeIndex !== undefined && nodeIndex >= 0 && formData.nodes) {
      selectedNodeData.value = { ...formData.nodes[nodeIndex] }
    } else {
      // 新节点（还没有ID）
      selectedNodeData.value = {
        nodeName: properties?.nodeName || '',
        nodeOrder: properties?.nodeOrder || 1,
        nodeType: properties?.nodeType || 1,
        rejectAction: properties?.rejectAction || 1,
        assignees: properties?.assignees || []
      }
    }

    // 计算编辑器位置（画布坐标转换为容器坐标）
    const canvasRect = canvasContainerRef.value?.getBoundingClientRect()
    if (canvasRect && lfInstance) {
      const { transformModel } = lfInstance.graphModel
      const { SCALE_X, SCALE_Y, TRANSLATE_X, TRANSLATE_Y } = transformModel

      // 将 LogicFlow 坐标转换为屏幕坐标
      const screenX = x * SCALE_X + TRANSLATE_X
      const screenY = y * SCALE_Y + TRANSLATE_Y

      nodeEditorPosition.value = {
        x: screenX,
        y: screenY
      }
    }

    nodeEditorVisible.value = true

    // 更新节点选中状态
    updateNodeSelection()
  }

  // 更新节点选中状态
  const updateNodeSelection = () => {
    if (!lfInstance) return

    // 更新所有节点的选中状态
    const graphData = lfInstance.getGraphData() as any
    graphData.nodes.forEach((node: any) => {
      const isSelected = node.id === selectedNodeId.value
      lfInstance?.setProperties(node.id, { isSelected })
    })
  }

  // 清除选中状态
  const clearSelection = () => {
    selectedNodeId.value = null
    selectedNodeData.value = null
    selectedNodeType.value = null
    nodeEditorVisible.value = false
    updateNodeSelection()
  }

  // 处理流程基本信息更新（从开始节点编辑）
  const handleFlowInfoUpdate = (flowInfo: {
    flowName?: string
    flowCode?: string
    businessType?: string
    status?: number
    description?: string
  }) => {
    if (flowInfo.flowName !== undefined) {
      formData.flowName = flowInfo.flowName
    }
    if (flowInfo.flowCode !== undefined) {
      formData.flowCode = flowInfo.flowCode
    }
    if (flowInfo.businessType !== undefined) {
      formData.businessType = flowInfo.businessType
    }
    if (flowInfo.status !== undefined) {
      formData.status = flowInfo.status
    }
    if (flowInfo.description !== undefined) {
      formData.description = flowInfo.description
    }

    // 更新开始节点的显示
    if (lfInstance) {
      lfInstance.setProperties('start-node', {
        flowName: formData.flowName,
        businessType: formData.businessType
      })
    }
  }

  // 处理节点编辑器位置更新
  const handleNodeEditorPositionUpdate = (newPosition: { x: number; y: number }) => {
    nodeEditorPosition.value = newPosition
  }

  // 处理节点更新
  const handleNodeUpdate = (updatedNode: ApprovalNode) => {
    if (!formData.nodes) return

    // 查找并更新节点 - 简化逻辑，直接通过 LogicFlow 节点的 nodeOrder 查找
    // 因为新节点没有 id，必须使用 nodeOrder 来定位
    const sortedNodes = [...formData.nodes].sort((a, b) => a.nodeOrder - b.nodeOrder)

    let index = -1

    // 优先通过 LogicFlow 节点属性中的 nodeOrder 查找（最可靠的方式）
    if (selectedNodeId.value && lfInstance) {
      try {
        const lfNodeModel = lfInstance.getNodeModelById(selectedNodeId.value)
        if (lfNodeModel) {
          const lfProperties = (lfNodeModel as any).properties || {}
          const lfNodeOrder = lfProperties.nodeOrder
          if (lfNodeOrder !== undefined) {
            index = sortedNodes.findIndex((n) => n.nodeOrder === lfNodeOrder)
          }
        }
      } catch (error) {
        console.warn('[FlowEditDialog] 无法从 LogicFlow 获取节点属性:', error)
      }
    }

    // 备用方案：如果节点有 id，通过 id 查找
    if (index < 0 && updatedNode.id) {
      index = sortedNodes.findIndex((n) => n.id && n.id === updatedNode.id)
    }

    if (index >= 0) {
      // 在排序后的数组中找到了节点
      const sortedNode = sortedNodes[index]

      // 如果节点有 id，使用 id 在原数组中精确匹配
      if (sortedNode.id) {
        const actualIndex = formData.nodes.findIndex((n) => n.id === sortedNode.id)
        if (actualIndex >= 0) {
          const originalNodeOrder = formData.nodes[actualIndex].nodeOrder
          formData.nodes[actualIndex] = {
            ...formData.nodes[actualIndex],
            ...updatedNode,
            nodeOrder: originalNodeOrder
          }
        }
      } else {
        // 如果没有 id（新节点），直接更新排序后的数组，然后替换原数组
        // 这样可以确保节点顺序正确
        const originalNodeOrder = sortedNode.nodeOrder
        sortedNodes[index] = { ...sortedNode, ...updatedNode, nodeOrder: originalNodeOrder }
        formData.nodes = sortedNodes
      }
    } else {
      // 备用方法：在排序后的数组中通过 updatedNode.nodeOrder 查找
      const sortedIndex = sortedNodes.findIndex(
        (n) => !n.id && n.nodeOrder === updatedNode.nodeOrder
      )
      if (sortedIndex >= 0) {
        const originalNodeOrder = sortedNodes[sortedIndex].nodeOrder
        sortedNodes[sortedIndex] = {
          ...sortedNodes[sortedIndex],
          ...updatedNode,
          nodeOrder: originalNodeOrder
        }
        formData.nodes = sortedNodes
      }
    }

    // 更新 LogicFlow 节点属性
    if (selectedNodeId.value && lfInstance) {
      lfInstance.setProperties(selectedNodeId.value, {
        nodeName: updatedNode.nodeName,
        nodeType: updatedNode.nodeType,
        rejectAction: updatedNode.rejectAction,
        assignees: updatedNode.assignees,
        assigneeCount: updatedNode.assignees?.length || 0
      })
    }
  }

  // 处理节点删除
  const handleNodeDelete = async () => {
    // 开始节点和结束节点不能删除
    if (selectedNodeType.value === 'start' || selectedNodeType.value === 'end') {
      ElMessage.warning('开始节点和结束节点不能删除')
      return
    }

    if (!formData.nodes || !selectedNodeId.value || selectedNodeType.value !== 'approval') return

    // 找到要删除的节点 - 尝试多种匹配方式
    let index = -1

    // 方法1: 通过 LogicFlow 实例查找节点属性（优先使用此方法）
    // 从 LogicFlow 节点获取 nodeOrder，因为新节点可能没有 id
    if (lfInstance && selectedNodeId.value) {
      try {
        const lfNodeModel = lfInstance.getNodeModelById(selectedNodeId.value)
        if (lfNodeModel) {
          const lfProperties = (lfNodeModel as any).properties || {}

          // 优先使用 originalId（如果节点已保存到数据库）
          const lfOriginalId = lfProperties.originalId
          if (lfOriginalId) {
            index = formData.nodes.findIndex((n) => n.id === lfOriginalId)
          }

          // 如果通过 originalId 找不到，使用 nodeOrder（适用于新创建的节点）
          if (index < 0 && lfProperties.nodeOrder !== undefined) {
            index = formData.nodes.findIndex((n) => n.nodeOrder === lfProperties.nodeOrder)
          }
        }
      } catch (error) {
        console.warn('[FlowEditDialog] 无法从 LogicFlow 获取节点属性:', error)
      }
    }

    // 方法2: 通过 LogicFlow ID 格式匹配 (approval-{id}) - 仅当节点有 id 时
    if (index < 0 && selectedNodeId.value) {
      // 如果 selectedNodeId 是 'approval-{id}' 格式，提取 id
      if (selectedNodeId.value.startsWith('approval-')) {
        const extractedId = selectedNodeId.value.replace('approval-', '')
        index = formData.nodes.findIndex((n) => n.id && String(n.id) === extractedId)
      }
    }

    // 方法3: 通过节点顺序匹配（备用方法，用于新创建的节点）
    if (index < 0 && selectedNodeData.value?.nodeOrder !== undefined) {
      const nodeOrder = selectedNodeData.value.nodeOrder
      index = formData.nodes.findIndex((n) => n.nodeOrder === nodeOrder)
    }

    if (index < 0) {
      console.warn('[FlowEditDialog] 无法找到要删除的节点，selectedNodeId:', selectedNodeId.value)
      return
    }

    const nodeName = formData.nodes[index]?.nodeName || '节点'

    try {
      // 确认删除
      await ElMessageBox.confirm(`确定要删除节点 "${nodeName}" 吗？`, '删除节点', {
        confirmButtonText: '删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      })

      // 执行删除
      formData.nodes.splice(index, 1)
      formData.nodes = reorderNodes(formData.nodes)

      clearSelection()

      // 等待 DOM 更新后再重新渲染流程
      await nextTick()
      renderFlow()

      ElMessage.success('节点已删除')
    } catch {
      // 用户取消删除
    }
  }

  // 添加新节点
  // const handleAddNode = () => {
  //   if (!formData.nodes) {
  //     formData.nodes = []
  //   }

  //   const newNode = createNewApprovalNode(formData.nodes.length + 1)
  //   formData.nodes.push(newNode)

  //   renderFlow()

  //   // 选中新添加的节点
  //   nextTick(() => {
  //     // 简单地重新渲染，新节点会显示
  //     ElMessage.success('节点已添加，请点击节点进行编辑')
  //   })
  // }

  // 处理边（连接线）点击 - 在边中间添加节点
  // 重构后的简化逻辑：直接通过 nodeOrder 计算插入位置
  const handleEdgeClick = (edgeData: any) => {
    if (!lfInstance || !formData.nodes) return

    const { sourceNodeId, targetNodeId } = edgeData

    // 步骤1：获取源节点和目标节点的 nodeOrder
    let sourceOrder = 0 // 开始节点的 order 视为 0
    let targetOrder = 0

    // 获取源节点的 nodeOrder
    if (sourceNodeId === 'start-node') {
      sourceOrder = 0
    } else {
      try {
        const sourceModel = lfInstance.getNodeModelById(sourceNodeId)
        if (sourceModel) {
          sourceOrder = (sourceModel as any).properties?.nodeOrder || 0
        }
      } catch (error) {
        console.warn('[handleEdgeClick] 无法获取源节点属性:', error)
      }
    }

    // 获取目标节点的 nodeOrder
    if (targetNodeId === 'end-node') {
      // 结束节点的 order 视为 最大nodeOrder + 1
      const maxOrder =
        formData.nodes.length > 0 ? Math.max(...formData.nodes.map((n) => n.nodeOrder)) : 0
      targetOrder = maxOrder + 1
    } else {
      try {
        const targetModel = lfInstance.getNodeModelById(targetNodeId)
        if (targetModel) {
          targetOrder = (targetModel as any).properties?.nodeOrder || 0
        }
      } catch (error) {
        console.warn('[handleEdgeClick] 无法获取目标节点属性:', error)
      }
    }

    // 步骤2：计算新节点的 nodeOrder（在源和目标之间）
    const newNodeOrder = (sourceOrder + targetOrder) / 2

    // 步骤3：创建新节点并添加到数组
    const newNode = createNewApprovalNode(newNodeOrder)
    formData.nodes.push(newNode)

    // 步骤4：按 nodeOrder 排序
    formData.nodes.sort((a, b) => a.nodeOrder - b.nodeOrder)

    // 步骤5：重新分配整数 nodeOrder (1, 2, 3...)
    formData.nodes = reorderNodes(formData.nodes)

    // 步骤6：清除选中状态并重新渲染
    clearSelection()
    renderFlow()

    ElMessage.success('节点已添加，请点击节点进行编辑')
  }

  // ============ 工具栏功能处理函数 ============

  // 放大
  const handleZoomIn = () => {
    if (!lfInstance) return
    lfInstance.zoom(true)
  }

  // 缩小
  const handleZoomOut = () => {
    if (!lfInstance) return
    lfInstance.zoom(false)
  }

  // 重置缩放
  const handleResetZoom = () => {
    if (!lfInstance) return
    lfInstance.resetZoom()
  }

  // 适应视图
  const handleFitView = () => {
    if (!lfInstance) return
    // 使用当前配置的 fitView 和 zoom，确保缩放和居中效果一致
    lfInstance.fitView(800)
    lfInstance.zoom(0.7)
  }

  // 切换小地图
  const handleToggleMiniMap = () => {
    if (!lfInstance) return
    miniMapVisible.value = !miniMapVisible.value
    const extension = (lfInstance as any).extension
    if (extension?.miniMap) {
      if (miniMapVisible.value) {
        extension.miniMap.show()
      } else {
        extension.miniMap.hide()
      }
    }
  }

  // 切换全屏
  const handleToggleFullscreen = () => {
    toggleFullscreen()
  }

  // 导出图片
  const handleExportImage = async () => {
    if (!lfInstance) return

    try {
      const extension = (lfInstance as any).extension
      if (extension?.snapshot) {
        extension.snapshot.getSnapshot('approval-flow', 'png')
        ElMessage.success('图片导出成功')
      } else {
        // 备用方案：使用 getSnapshot 方法
        const snapshot = (lfInstance as any).getSnapshot?.()
        if (snapshot) {
          const link = document.createElement('a')
          link.download = 'approval-flow.png'
          link.href = snapshot
          link.click()
          ElMessage.success('图片导出成功')
        } else {
          ElMessage.warning('导出功能暂不可用')
        }
      }
    } catch (error) {
      console.error('导出图片失败:', error)
      ElMessage.error('导出图片失败')
    }
  }

  // 打开审批人选择
  const openAssigneeSelect = () => {
    // 获取当前已选中的用户ID列表（只保留用户类型）
    if (selectedNodeData.value?.assignees) {
      currentSelectedIds.value = selectedNodeData.value.assignees
        .filter((a) => a.assigneeType === 2) // 只保留用户类型
        .map((a) => a.assigneeId)
    } else {
      currentSelectedIds.value = []
    }

    assigneeDialogVisible.value = true
  }

  // 处理审批人选择确认
  const handleAssigneeConfirm = (selectedUsers: Array<{ id: number; name: string }>) => {
    if (!selectedNodeData.value) return

    // 只保存用户类型的审批人
    const newAssignees: ApprovalAssignee[] = selectedUsers.map((user) => ({
      assigneeType: 2, // 固定为用户类型
      assigneeId: user.id,
      assigneeName: user.name
    }))

    // 更新节点编辑器
    if (nodeEditorRef.value) {
      nodeEditorRef.value.updateAssignees(newAssignees)
    }
  }

  // 监听弹窗打开
  watch(
    () => props.modelValue,
    async (val) => {
      if (val) {
        // 重置状态
        clearSelection()
        activeCollapse.value = ['info']

        if (props.dialogType === 'edit' && props.flowData?.id) {
          // 加载流程详情
          try {
            const res = await fetchGetFlowDetail(props.flowData.id)
            Object.assign(formData, res)
          } catch (error) {
            console.error('加载流程详情失败:', error)
          }
        } else {
          Object.assign(formData, initialFormData())
        }

        // 初始化 LogicFlow
        await nextTick()
        initLogicFlow()
      }
    }
  )

  // 弹窗关闭时清理
  const handleClosed = () => {
    Object.assign(formData, initialFormData())
    clearSelection()

    // 清理 ResizeObserver
    if (resizeObserver) {
      resizeObserver.disconnect()
      resizeObserver = null
    }

    // 销毁 LogicFlow 实例
    if (lfInstance) {
      lfInstance.destroy()
      lfInstance = null
    }
  }

  // 提交表单
  const handleSubmit = async () => {
    try {
      // 验证流程基本信息
      if (!formData.flowName?.trim()) {
        ElMessage.warning('请输入流程名称')
        return
      }
      if (!formData.businessType) {
        ElMessage.warning('请选择业务类型')
        return
      }

      // 验证节点
      if (!formData.nodes || formData.nodes.length === 0) {
        ElMessage.warning('请至少添加一个审批节点')
        return
      }

      // 验证每个节点
      for (let i = 0; i < formData.nodes.length; i++) {
        const node = formData.nodes[i]
        if (!node.nodeName?.trim()) {
          ElMessage.warning(`节点 ${i + 1} 未设置名称`)
          return
        }
        if (!node.assignees || node.assignees.length === 0) {
          ElMessage.warning(`节点 "${node.nodeName}" 未配置审批人`)
          return
        }
      }

      submitLoading.value = true

      if (props.dialogType === 'add') {
        await fetchAddFlow(formData)
      } else {
        await fetchUpdateFlow(formData.id!, formData)
      }

      dialogVisible.value = false
      emit('success')
    } catch (error) {
      console.error('保存失败:', error)
    } finally {
      submitLoading.value = false
    }
  }

  // 监听弹窗打开/关闭，添加/移除键盘事件监听
  watch(dialogVisible, (isOpen) => {
    if (isOpen) {
      // 弹窗打开时添加键盘事件监听
      keyDownHandler = (e: KeyboardEvent) => {
        // 如果焦点在输入框等可编辑元素上，不处理
        const target = e.target as HTMLElement
        if (
          target.tagName === 'INPUT' ||
          target.tagName === 'TEXTAREA' ||
          target.isContentEditable
        ) {
          return
        }

        // Delete 或 Backspace 键删除节点
        // 兼容不同浏览器的键值：e.key, e.code, e.keyCode
        const isDeleteKey = e.key === 'Delete' || e.code === 'Delete' || e.keyCode === 46
        const isBackspaceKey = e.key === 'Backspace' || e.code === 'Backspace' || e.keyCode === 8

        if (isDeleteKey || isBackspaceKey) {
          // 检查是否选中了审批节点（开始节点和结束节点不能删除）
          if (selectedNodeId.value && selectedNodeType.value === 'approval') {
            e.preventDefault()
            e.stopPropagation()
            handleNodeDelete()
          }
        }
      }
      document.addEventListener('keydown', keyDownHandler)
    } else {
      // 弹窗关闭时移除键盘事件监听
      if (keyDownHandler) {
        document.removeEventListener('keydown', keyDownHandler)
        keyDownHandler = null
      }
    }
  })

  // 组件卸载时清理
  onUnmounted(() => {
    // 清理键盘事件监听
    if (keyDownHandler) {
      document.removeEventListener('keydown', keyDownHandler)
      keyDownHandler = null
    }

    // 清理 DOM 事件监听
    if (handleNodeDeleteFromButton) {
      document.removeEventListener('logicflow-node-delete', handleNodeDeleteFromButton)
      handleNodeDeleteFromButton = null
    }

    // 清理 ResizeObserver
    if (resizeObserver) {
      resizeObserver.disconnect()
      resizeObserver = null
    }

    // 清理 LogicFlow 实例
    if (lfInstance) {
      lfInstance.destroy()
      lfInstance = null
    }
  })
</script>

<style scoped lang="scss">
  .dialog-content {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .flow-info-collapse {
    background: #f8fafc;
    border: none;

    :deep(.el-collapse-item__header) {
      height: auto;
      padding: 12px 20px;
      line-height: 1.5;
      background: #f8fafc;
      border-bottom: 1px solid #e2e8f0;
    }

    :deep(.el-collapse-item__wrap) {
      background: #fff;
      border-bottom: 1px solid #e2e8f0;
    }

    :deep(.el-collapse-item__content) {
      padding: 20px;
    }

    .collapse-title {
      display: flex;
      gap: 8px;
      align-items: center;
      font-weight: 500;
      color: #334155;

      i {
        font-size: 18px;
        color: #64748b;
      }
    }
  }

  .flow-form {
    :deep(.el-form-item) {
      margin-bottom: 16px;
    }
  }

  .flow-canvas-wrapper {
    display: flex;
    flex: 1;
    flex-direction: column;
    min-height: 0;

    .canvas-container {
      position: relative;
      flex: 1;
      width: 100%;
      min-height: 600px;
      overflow: hidden;
      background: #f8fafc;
      background-image: radial-gradient(circle, #d0d5dd 1px, transparent 1px);
      background-size: 20px 20px;
      border-radius: var(--el-border-radius-base);

      .lf-container {
        width: 100% !important;
        height: 100% !important;

        > div {
          width: 100% !important;
          height: 100% !important;
        }

        .lf-graph {
          width: 100% !important;
          height: 100% !important;

          svg {
            width: 100% !important;
            height: 100% !important;
          }
        }
      }
    }
  }

  // 暗色主题适配
  :global(.dark) {
    .flow-info-collapse {
      background: #1e293b;

      :deep(.el-collapse-item__header) {
        background: #1e293b;
        border-bottom-color: #334155;
      }

      :deep(.el-collapse-item__wrap) {
        background: #0f172a;
        border-bottom-color: #334155;
      }

      .collapse-title {
        color: #e2e8f0;

        i {
          color: #94a3b8;
        }
      }
    }

    .flow-canvas-wrapper {
      .canvas-container {
        background-image: radial-gradient(circle, #334155 1px, transparent 1px);
      }
    }
  }
</style>
