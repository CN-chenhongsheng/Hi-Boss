/**
 * LogicFlow 组件使用示例
 *
 * @module components/core/charts/art-logic-flow/README
 * @author HongSheng_Chen Team
 */

/**
 * 基础使用
 */
export const basicExample = `
<template>
  <ArtLogicFlow
    ref="logicFlowRef"
    :data="flowData"
    height="600px"
    @node:click="handleNodeClick"
  />
</template>

<script setup>
import ArtLogicFlow from '@/components/core/charts/art-logic-flow/index.vue'

const logicFlowRef = ref()
const flowData = ref({
  nodes: [
    { id: '1', type: 'rect', x: 100, y: 100, text: '节点1' },
    { id: '2', type: 'rect', x: 300, y: 100, text: '节点2' }
  ],
  edges: [
    { sourceNodeId: '1', targetNodeId: '2', type: 'polyline' }
  ]
})

const handleNodeClick = ({ node }) => {
  console.log('点击了节点:', node)
}
</script>
`

/**
 * 树形数据转换示例
 */
export const treeDataExample = `
import { treeToLogicFlowData } from '@/components/core/charts/art-logic-flow/utils'

const treeData = [
  {
    id: 'campus-1',
    label: '校区1',
    children: [
      {
        id: 'dept-1',
        label: '院系1',
        children: [
          { id: 'major-1', label: '专业1' },
          { id: 'major-2', label: '专业2' }
        ]
      }
    ]
  }
]

const flowData = treeToLogicFlowData(treeData, {
  nodeSpacingX: 200,
  nodeSpacingY: 100,
  direction: 'vertical'
})
`

/**
 * 只读模式示例
 */
export const readonlyExample = `
<ArtLogicFlow
  :data="flowData"
  :readonly="true"
  height="600px"
/>
`

/**
 * 自定义配置示例
 */
export const customConfigExample = `
<ArtLogicFlow
  :data="flowData"
  :config="{
    grid: {
      size: 20,
      visible: true
    },
    background: {
      color: '#f0f0f0'
    }
  }"
  height="600px"
/>
`

/**
 * 方法调用示例
 */
export const methodsExample = `
const logicFlowRef = ref()

// 获取数据
const getData = () => {
  const data = logicFlowRef.value?.getData()
  console.log(data)
}

// 添加节点
const addNode = () => {
  logicFlowRef.value?.addNode({
    id: 'new-node',
    type: 'rect',
    x: 200,
    y: 200,
    text: '新节点'
  })
}

// 适应视图
const fitView = () => {
  logicFlowRef.value?.fitView()
}

// 清空画布
const clear = () => {
  logicFlowRef.value?.clear()
}
`

