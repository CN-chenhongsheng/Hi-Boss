<template>
  <ArtDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
    width="30%"
    :open="handleOpen"
    :confirm="handleSubmit"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="80px">
      <ElFormItem label="用户名" prop="username">
        <ElInput v-model="formData.username" />
      </ElFormItem>
      <ElFormItem label="手机号" prop="phone">
        <ElInput v-model="formData.phone" />
      </ElFormItem>
      <ElFormItem label="性别" prop="sex">
        <ElSelect v-model="formData.sex">
          <ElOption label="男" value="男" />
          <ElOption label="女" value="女" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem label="部门" prop="dep">
        <ElSelect v-model="formData.dep">
          <ElOption label="董事会部" :value="1" />
          <ElOption label="市场部" :value="2" />
          <ElOption label="技术部" :value="3" />
        </ElSelect>
      </ElFormItem>
    </ElForm>
  </ArtDialog>
</template>

<script setup lang="ts">
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'

// 用户表单数据接口
interface UserFormData {
  username: string
  phone: string
  sex: string
  dep: number | string
}

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const dialogType = defineModel<string>('type', { required: true })
const formData = defineModel<UserFormData>('data', { required: true })

// 表单实例
const formRef = ref<FormInstance>()

// 表单验证规则
const rules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
  ],
  sex: [{ required: true, message: '请选择性别', trigger: 'change' }],
  dep: [{ required: true, message: '请选择部门', trigger: 'change', type: 'number' }]
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
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
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
