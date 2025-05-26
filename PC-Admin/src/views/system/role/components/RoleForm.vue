<template>
  <ArtDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '新增角色' : '编辑角色'"
    width="30%"
    :confirm="handleSubmit"
    :open="handleOpen"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="120px">
      <ElFormItem label="角色名称" prop="name">
        <ElInput v-model="form.name" />
      </ElFormItem>
      <ElFormItem label="描述" prop="des">
        <ElInput v-model="form.des" type="textarea" :rows="3" />
      </ElFormItem>
      <ElFormItem label="状态">
        <ArtStatusSwitch v-model:modelValue="form.status" />
      </ElFormItem>
    </ElForm>
  </ArtDialog>
</template>

<script setup lang="ts">
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'

// 角色数据接口
interface RoleFormData {
  id: string
  name: string
  des: string
  status: number
}

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const dialogType = defineModel<string>('type', { required: true })
const form = defineModel<RoleFormData>('form', { required: true })

// 表单实例
const formRef = ref<FormInstance>()

// 表单验证规则
const rules = reactive<FormRules>({
  name: [
    { required: true, message: '请输入角色名称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  des: [{ required: true, message: '请输入角色描述', trigger: 'blur' }]
})

// 对话框打开处理
const handleOpen = () => {
  formRef.value?.clearValidate()
}

const emit = defineEmits(['refresh'])

// 提交表单 - 返回一个Promise
const handleSubmit = async () => {
  if (!formRef.value) return false

  return new Promise<boolean>((resolve) => {
    formRef.value!.validate((valid) => {
      if (valid) {
        const message = dialogType.value === 'add' ? '新增成功' : '修改成功'
        ElMessage.success(message)
        emit('refresh')
        resolve(true) // 验证通过，返回true表示可以关闭对话框
      } else {
        resolve(false) // 验证失败，返回false阻止关闭对话框
      }
    })
  })
}
</script>

<style scoped></style>
