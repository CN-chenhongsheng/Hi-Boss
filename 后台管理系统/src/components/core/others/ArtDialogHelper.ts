import { h, render } from 'vue'
import { ElMessageBox, ElMessageBoxOptions } from 'element-plus'
import type { Action, MessageBoxData } from 'element-plus'
import ArtDialog from './ArtDialog.vue'

type DialogOptions = {
  title?: string
  content?: string
  width?: string | number
  cancelText?: string
  confirmText?: string
  showCancel?: boolean
  showConfirm?: boolean
  closeOnClickModal?: boolean
  beforeClose?: (action: Action, instance: any, done: () => void) => void
  customClass?: string
}

/**
 * 提示对话框
 * @param content 内容
 * @param title 标题
 * @param options 配置项
 */
export const alert = (
  content: string,
  title = '提示',
  options: Omit<DialogOptions, 'title' | 'content' | 'showCancel'> = {}
): Promise<MessageBoxData> => {
  const elOptions: ElMessageBoxOptions = {
    confirmButtonText: options.confirmText || '确定',
    dangerouslyUseHTMLString: true,
    closeOnClickModal: options.closeOnClickModal ?? false,
    customClass: options.customClass,
    beforeClose: options.beforeClose
  }

  return ElMessageBox.alert(content, title, elOptions)
}

/**
 * 确认对话框
 * @param content 内容
 * @param title 标题
 * @param options 配置项
 */
export const confirm = (
  content: string,
  title = '确认',
  options: Omit<DialogOptions, 'title' | 'content'> = {}
): Promise<MessageBoxData> => {
  const elOptions: ElMessageBoxOptions = {
    confirmButtonText: options.confirmText || '确定',
    cancelButtonText: options.cancelText || '取消',
    dangerouslyUseHTMLString: true,
    closeOnClickModal: options.closeOnClickModal ?? false,
    customClass: options.customClass,
    beforeClose: options.beforeClose
  }

  return ElMessageBox.confirm(content, title, elOptions)
}

/**
 * 打开自定义对话框
 * @param component 组件
 * @param props 属性
 * @param options 配置项
 */
export const open = (
  component: any,
  props: any = {},
  options: DialogOptions = {}
): Promise<any> => {
  const container = document.createElement('div')
  document.body.appendChild(container)

  return new Promise((resolve, reject) => {
    const dialogProps = {
      modelValue: true,
      title: options.title || '提示',
      width: options.width || '50%',
      closeOnClickModal: options.closeOnClickModal ?? false,
      appendToBody: true,
      destroyOnClose: true,
      cancelText: options.cancelText || '取消',
      confirmText: options.confirmText || '确定',
      customClass: options.customClass || '',
      beforeClose: (done: () => void) => {
        options.beforeClose && options.beforeClose('confirm', null, done)
      },
      onConfirm: (data: any) => {
        resolve(data)
        destroyDialog()
      },
      onCancel: () => {
        reject()
        destroyDialog()
      },
      onClosed: () => {
        destroyDialog()
      }
    }

    const dialogVNode = h(ArtDialog, dialogProps, {
      default: () => h(component, props)
    })

    render(dialogVNode, container)

    // 销毁对话框
    const destroyDialog = () => {
      render(null, container)
      document.body.removeChild(container)
    }
  })
}

export default {
  alert,
  confirm,
  open
}
