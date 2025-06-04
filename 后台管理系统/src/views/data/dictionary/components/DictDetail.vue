<template>
  <ArtDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '添加字典数据' : '编辑字典数据'"
    width="30%"
    :open="handleOpen"
    :confirm="handleSubmit"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="字典类型" prop="dictType">
        <ElInput v-model="formData.dictType" disabled />
      </ElFormItem>
      <ElFormItem label="字典编码" prop="code">
        <ElInput v-model="formData.code" />
      </ElFormItem>
      <ElFormItem label="字典名称" prop="name">
        <ElInput v-model="formData.name" />
      </ElFormItem>
      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="formData.remark" type="textarea" :rows="3" />
      </ElFormItem>
      <ElFormItem label="状态" prop="status">
        <ArtStatusSwitch v-model:modelValue="formData.status" :needConfirm="false" />
      </ElFormItem>
    </ElForm>
  </ArtDialog>
</template>

<script setup lang="ts">
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import { FormInstance, FormRules } from 'element-plus'

// 字典明细数据接口
interface DictDetailData {
  id?: number
  dictType: string
  code: string
  name: string
  status: number
  remark: string
}

// 定义对话框是否打开
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const dialogType = defineModel<string>('type', { required: true })
const formData = defineModel<DictDetailData>('data', { required: true })

// 字典明细表单实例
const formRef = ref<FormInstance>()

// 表单验证规则
const rules = reactive<FormRules>({
  code: [
    { required: true, message: '请输入字典编码', trigger: 'blur' },
    { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入字典名称', trigger: 'blur' },
    { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  status: [{ required: true, message: '请选择状态', trigger: 'change', type: 'number' }]
})

// 对话框打开处理
const handleOpen = () => {
  formRef.value?.clearValidate()
}

const emit = defineEmits(['refresh'])

// 提交表单 - 改为返回一个Promise
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
