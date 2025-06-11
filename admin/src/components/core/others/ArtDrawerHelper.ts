import { createVNode, render, type Component, type VNode } from 'vue'
import type { DrawerDirection, DrawerSize } from './ArtDrawer.vue'

/**
 * 抽屉选项接口
 */
export interface DrawerOptions {
  title?: string
  direction?: DrawerDirection
  size?: DrawerSize
  destroyOnClose?: boolean
  closeOnClickModal?: boolean
  showClose?: boolean
  appendToBody?: boolean
  modal?: boolean
  modalClass?: string
  drawerClass?: string
  customClass?: string
  zIndex?: number
  lockScroll?: boolean
  withHeader?: boolean
  content?: string | VNode | Component
  footer?: string | VNode | Component
}

/**
 * 创建抽屉节点
 * @param component 抽屉内容组件
 * @param options 抽屉选项
 * @returns
 */
function createDrawerNode(component: Component, options: DrawerOptions = {}) {
  // 创建容器
  const container = document.createElement('div')

  // 抽屉关闭后的回调
  const onDestroy = () => {
    // 从DOM中移除节点
    render(null, container)
    container.remove()
  }

  // 打开抽屉的方法
  const openDrawer = () => {
    if (vm.component && vm.component.exposed) {
      vm.component.exposed.open()
    }
  }

  // 关闭抽屉的方法
  const closeDrawer = () => {
    if (vm.component && vm.component.exposed) {
      vm.component.exposed.close()
    }
  }

  // 创建虚拟节点
  const vnode = createVNode(component, {
    ...options,
    modelValue: true,
    'onUpdate:modelValue': (val: boolean) => {
      if (vm.component && vm.component.props) {
        vm.component.props.modelValue = val
      }
      // 如果关闭了抽屉，需要销毁组件
      if (val === false && options.destroyOnClose) {
        setTimeout(onDestroy, 300)
      }
    },
    onClosed: () => {
      if (!options.destroyOnClose) {
        onDestroy()
      }
    }
  })

  // 渲染虚拟节点到容器
  render(vnode, container)
  // 将容器添加到document.body
  document.body.appendChild(container)

  // 保存虚拟节点实例
  const vm = {
    vnode,
    component: vnode.component,
    open: openDrawer,
    close: closeDrawer
  }

  return vm
}

/**
 * 抽屉辅助类
 */
class ArtDrawerHelper {
  /**
   * 打开抽屉
   * @param component 抽屉内容组件
   * @param options 抽屉选项
   */
  static open(component: Component, options: DrawerOptions = {}) {
    // 默认配置，可以在调用时被覆盖
    const defaultOptions: DrawerOptions = {
      destroyOnClose: true,
      direction: 'rtl',
      size: '30%',
      appendToBody: true, // 默认添加到body，避免样式问题
      modal: true // 默认显示模态框
    }
    // 合并配置，传入的options会覆盖默认配置
    const drawerOptions = { ...defaultOptions, ...options }
    return createDrawerNode(component, drawerOptions)
  }
}

export default ArtDrawerHelper
