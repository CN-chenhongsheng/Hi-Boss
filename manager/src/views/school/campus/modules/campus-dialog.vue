<!-- 校区编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="校区编码" prop="campusCode">
        <ElInput v-model="form.campusCode" placeholder="请输入校区编码" :disabled="isEdit" />
      </ElFormItem>

      <ElFormItem label="校区名称" prop="campusName">
        <ElInput v-model="form.campusName" placeholder="请输入校区名称" />
      </ElFormItem>

      <ElFormItem label="校区地址" prop="address">
        <ElInput v-model="form.address" type="textarea" :rows="3" placeholder="请输入校区地址" />
      </ElFormItem>

      <ElFormItem label="负责人" prop="manager">
        <ElInput v-model="form.manager" placeholder="请输入负责人姓名" />
      </ElFormItem>

      <ElFormItem label="排序序号" prop="sort">
        <ElInputNumber v-model="form.sort" :min="0" :max="9999" />
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchAddCampus, fetchUpdateCampus } from '@/api/school-manage'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Api.SystemManage.CampusListItem | null
  }

  interface Emits {
    (e: 'update:visible', visible: boolean): void
    (e: 'submit'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    editData: null
  })

  const emit = defineEmits<Emits>()

  const formRef = ref<FormInstance>()
  const loading = ref(false)

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => {
    if (isEdit.value) return '编辑校区'
    return '新增校区'
  })

  const form = reactive<Api.SystemManage.CampusSaveParams>({
    campusCode: '',
    campusName: '',
    address: '',
    manager: undefined,
    status: 1,
    sort: 0
  })

  const rules = reactive<FormRules>({
    campusCode: [{ required: true, message: '请输入校区编码', trigger: 'blur' }],
    campusName: [{ required: true, message: '请输入校区名称', trigger: 'blur' }],
    address: [{ required: true, message: '请输入校区地址', trigger: 'blur' }]
  })

  /**
   * 加载表单数据
   */
  const loadFormData = (): void => {
    if (isEdit.value && props.editData) {
      Object.assign(form, {
        id: props.editData.id,
        campusCode: props.editData.campusCode,
        campusName: props.editData.campusName,
        address: props.editData.address,
        manager: props.editData.manager || undefined,
        status: props.editData.status,
        sort: props.editData.sort || 0
      })
    } else {
      resetForm()
    }
  }

  /**
   * 重置表单
   */
  const resetForm = (): void => {
    Object.assign(form, {
      campusCode: '',
      campusName: '',
      address: '',
      manager: undefined,
      status: 1,
      sort: 0
    })
    formRef.value?.clearValidate()
  }

  /**
   * 提交表单
   */
  const handleSubmit = async (): Promise<void> => {
    if (!formRef.value) return

    const valid = await formRef.value.validate().catch(() => false)
    if (!valid) return

    loading.value = true
    try {
      if (isEdit.value) {
        await fetchUpdateCampus(form.id!, form)
      } else {
        await fetchAddCampus(form)
      }
      emit('submit')
      handleClose()
    } catch (error) {
      console.error('提交失败:', error)
    } finally {
      loading.value = false
    }
  }

  /**
   * 关闭弹窗
   */
  const handleClose = (): void => {
    resetForm()
    emit('update:visible', false)
  }

  watch(
    () => props.visible,
    (val) => {
      if (val) {
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
