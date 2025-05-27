<template>
  <ArtDialog
    v-model="dialogVisible"
    title="菜单权限"
    width="30%"
    :confirm="handleSubmit"
    :open="handleOpen"
  >
    <div :style="{ maxHeight: '500px', overflowY: 'scroll' }">
      <ElTree
        ref="treeRef"
        :data="menuData"
        show-checkbox
        node-key="id"
        :default-expanded-keys="expandedKeys"
        :default-checked-keys="checkedKeys"
        :props="defaultProps"
      />
    </div>
  </ArtDialog>
</template>

<script setup lang="ts">
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import { formatMenuTitle } from '@/utils/menu'
import { MenuListType } from '@/types/menu'

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })

// 获取传入的菜单列表
defineProps<{
  menuData: MenuListType[]
}>()

// 定义检查表单实例
const treeRef = ref()

// 默认展开的节点
const expandedKeys = ref<number[]>([1, 2, 3, 4, 5, 6, 7, 8])

// 默认选中的节点
const checkedKeys = ref<number[]>([1, 2, 3])

// 对话框打开处理
const handleOpen = () => {
  // 权限树不需要清除验证，但可以在这里进行其他初始化操作
  // 例如根据当前角色重新加载权限
}

// 树形控件属性
const defaultProps = {
  children: 'children',
  label: (data: any) => formatMenuTitle(data.meta?.title) || ''
}

const emit = defineEmits(['refresh'])

// 提交表单 - 返回一个Promise
const handleSubmit = async () => {
  try {
    // 获取选中的节点
    const checkedNodes = treeRef.value?.getCheckedNodes()
    const halfCheckedNodes = treeRef.value?.getHalfCheckedNodes()

    console.log('选中的节点:', checkedNodes)
    console.log('半选中的节点:', halfCheckedNodes)

    // 这里可以添加实际保存逻辑
    ElMessage.success('权限设置成功')
    emit('refresh')
    return true
  } catch {
    ElMessage.error('权限设置失败')
    return false
  }
}
</script>

<style scoped></style>
