<template>
  <ElDialog
    v-model="visible"
    :title="dialogTitle"
    width="700px"
    align-center
    class="el-dialog-border"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="字典编码" prop="dictCode">
            <ElInput v-model="form.dictCode" placeholder="请输入字典编码" :disabled="true" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="字典标签" prop="label">
            <ElInput
              v-model="form.label"
              placeholder="请输入字典标签"
              maxlength="100"
              show-word-limit
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="字典值" prop="value">
            <ElInput
              v-model="form.value"
              placeholder="请输入字典值"
              maxlength="100"
              show-word-limit
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="排序" prop="sort">
            <ElInputNumber
              v-model="form.sort"
              :min="0"
              :max="999"
              placeholder="排序"
              style="width: 100%"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="表格样式" prop="listClass">
            <ElSelect
              v-model="form.listClass"
              placeholder="请选择表格样式"
              clearable
              style="width: 100%"
            >
              <ElOption label="primary" value="primary" />
              <ElOption label="success" value="success" />
              <ElOption label="info" value="info" />
              <ElOption label="warning" value="warning" />
              <ElOption label="danger" value="danger" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="CSS类名" prop="cssClass">
            <ElInput v-model="form.cssClass" placeholder="请输入CSS类名" maxlength="100" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="是否默认" prop="isDefault">
            <ElRadioGroup v-model="form.isDefault">
              <ElRadio :label="1">是</ElRadio>
              <ElRadio :label="0">否</ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="状态" prop="status">
            <ElRadioGroup v-model="form.status">
              <ElRadio :label="1">正常</ElRadio>
              <ElRadio :label="0">停用</ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="备注" prop="remark">
        <ElInput
          v-model="form.remark"
          type="textarea"
          :rows="3"
          placeholder="请输入备注"
          maxlength="500"
          show-word-limit
        />
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElSpace>
        <ElButton @click="handleClose">取消</ElButton>
        <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import {
    fetchAddDictData,
    fetchUpdateDictData,
    fetchGetDictDataDetail
  } from '@/api/system-manage'
  import { ElMessage, type FormInstance, type FormRules } from 'element-plus'

  type DictDataListItem = Api.SystemManage.DictDataListItem

  interface Props {
    modelValue: boolean
    dialogType: 'add' | 'edit'
    dataData?: DictDataListItem
    dictCode: string
  }

  interface Emits {
    (e: 'update:modelValue', value: boolean): void
    (e: 'success'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    modelValue: false,
    dialogType: 'add',
    dataData: undefined,
    dictCode: ''
  })

  const emit = defineEmits<Emits>()

  const formRef = ref<FormInstance>()
  const loading = ref(false)

  const visible = computed({
    get: () => props.modelValue,
    set: (value) => emit('update:modelValue', value)
  })

  const dialogTitle = computed(() => {
    return props.dialogType === 'add' ? '新增字典数据' : '编辑字典数据'
  })

  const form = reactive<Api.SystemManage.DictDataSaveParams>({
    dictCode: '',
    label: '',
    value: '',
    cssClass: '',
    listClass: '',
    sort: 0,
    isDefault: 0,
    status: 1,
    remark: ''
  })

  const rules = computed<FormRules>(() => ({
    label: [{ required: true, message: '请输入字典标签', trigger: 'blur' }],
    value: [{ required: true, message: '请输入字典值', trigger: 'blur' }],
    sort: [{ required: true, message: '请输入排序', trigger: 'blur' }]
  }))

  // 初始化表单数据
  watch(
    () => props.modelValue,
    async (newVal) => {
      if (newVal) {
        if (props.dialogType === 'edit' && props.dataData?.id) {
          try {
            const detail = await fetchGetDictDataDetail(props.dataData.id)
            Object.assign(form, {
              id: detail.id,
              dictCode: detail.dictCode,
              label: detail.label,
              value: detail.value,
              cssClass: detail.cssClass || '',
              listClass: detail.listClass || '',
              sort: detail.sort || 0,
              isDefault: detail.isDefault || 0,
              status: detail.status,
              remark: detail.remark || ''
            })
          } catch (error) {
            console.error('获取字典数据详情失败:', error)
          }
        } else {
          // 重置表单，设置字典编码
          Object.assign(form, {
            id: undefined,
            dictCode: props.dictCode,
            label: '',
            value: '',
            cssClass: '',
            listClass: '',
            sort: 0,
            isDefault: 0,
            status: 1,
            remark: ''
          })
        }
        nextTick(() => {
          formRef.value?.clearValidate()
        })
      }
    },
    { immediate: true }
  )

  const handleClose = () => {
    visible.value = false
    formRef.value?.resetFields()
  }

  const handleSubmit = async () => {
    if (!formRef.value) return

    try {
      const valid = await formRef.value.validate()
      if (!valid) return

      loading.value = true

      if (props.dialogType === 'add') {
        await fetchAddDictData(form)
      } else {
        if (!form.id) {
          ElMessage.error('字典数据ID不能为空')
          return
        }
        await fetchUpdateDictData(form.id, form)
      }

      emit('success')
      handleClose()
    } catch (error) {
      console.error('提交失败:', error)
    } finally {
      loading.value = false
    }
  }
</script>
