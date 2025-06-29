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
      <ElFormItem label="字典标签" prop="dictLabel">
        <ElInput v-model="formData.dictLabel" />
      </ElFormItem>
      <ElFormItem label="字典键值" prop="dictValue">
        <ElInput v-model="formData.dictValue" />
      </ElFormItem>
      <ElFormItem label="字典排序" prop="dictSort">
        <ElInputNumber v-model="formData.dictSort" :min="0" style="width: 100%" />
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
import { addDictData, updateDictData } from '@/api/dictionary'
import { ApiStatus } from '@/utils/http/status'

// 字典明细数据接口
interface DictDetailData {
  dictCode?: number
  dictSort: number
  dictLabel: string
  dictValue: string
  dictType: string
  status: string | number
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
  dictLabel: [
    { required: true, message: '请输入字典标签', trigger: 'blur' },
    { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  dictValue: [
    { required: true, message: '请输入字典键值', trigger: 'blur' },
    { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  dictSort: [{ required: true, message: '请输入字典排序', trigger: 'blur', type: 'number' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }]
})

// 对话框打开处理
const handleOpen = () => {
  formRef.value?.clearValidate()
}

const emit = defineEmits(['refresh'])

// 提交表单 - 改为返回一个Promise
const handleSubmit = async () => {
  if (!formRef.value) return false

  // 检查dictType是否为空，如果为空则尝试从父组件获取
  if (!formData.value.dictType || formData.value.dictType === '') {
    console.error('dictType为空，提交失败')
    ElMessage.error('字典类型不能为空')
    return false
  }

  return new Promise<boolean>((resolve) => {
    formRef.value!.validate(async (valid) => {
      if (valid) {
        try {
          // 构建提交数据
          const submitData = {
            dictCode: formData.value.dictCode,
            dictSort: formData.value.dictSort,
            dictLabel: formData.value.dictLabel,
            dictValue: formData.value.dictValue,
            dictType: formData.value.dictType,
            status: formData.value.status,
            remark: formData.value.remark
          }

          // 再次确认dictType不为空
          if (!submitData.dictType || submitData.dictType === '') {
            console.error('dictType为空，提交失败')
            ElMessage.error('字典类型不能为空')
            resolve(false)
            return
          }

          // 根据dialogType决定使用哪个API
          let res: any
          if (dialogType.value === 'add') {
            res = await addDictData(submitData)
          } else {
            res = await updateDictData(submitData)
          }

          if (res.code === ApiStatus.success) {
            ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
            emit('refresh')
            resolve(true) // 验证通过，返回true表示可以关闭对话框
          } else {
            ElMessage.error(res.msg || (dialogType.value === 'add' ? '添加失败' : '更新失败'))
            resolve(false)
          }
        } catch (error) {
          console.error('提交字典数据出错:', error)
          ElMessage.error(dialogType.value === 'add' ? '添加失败' : '更新失败')
          resolve(false)
        }
      } else {
        resolve(false) // 验证失败，返回false阻止关闭对话框
      }
    })
  })
}
</script>

<style scoped></style>
