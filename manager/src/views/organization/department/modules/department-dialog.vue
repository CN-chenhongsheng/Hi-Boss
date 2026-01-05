<!-- 院系编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="院系编码" prop="deptCode">
        <ElInput v-model="form.deptCode" placeholder="请输入院系编码" :disabled="isEdit" />
      </ElFormItem>

      <ElFormItem label="院系名称" prop="deptName">
        <ElInput v-model="form.deptName" placeholder="请输入院系名称" />
      </ElFormItem>

      <ElFormItem label="所属校区" prop="campusCode">
        <ElSelect v-model="form.campusCode" placeholder="请选择所属校区" filterable>
          <ElOption
            v-for="campus in campusOptions"
            :key="campus.campusCode"
            :label="campus.campusName"
            :value="campus.campusCode"
          />
        </ElSelect>
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="院系领导" prop="leader">
            <ElInput v-model="form.leader" placeholder="请输入院系领导" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="联系电话" prop="phone">
            <ElInput v-model="form.phone" placeholder="请输入联系电话" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="排序" prop="sort">
            <ElInputNumber v-model="form.sort" :min="0" :max="9999" placeholder="请输入排序值" />
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchAddDepartment, fetchUpdateDepartment } from '@/api/school-manage'
  import { useReferenceStore } from '@/store/modules/reference'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Api.SystemManage.DepartmentListItem | null
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
  const campusOptions = ref<Api.SystemManage.CampusListItem[]>([])

  // 使用参考数据 store
  const referenceStore = useReferenceStore()

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => {
    if (isEdit.value) return '编辑院系'
    return '新增院系'
  })

  const form = reactive<Api.SystemManage.DepartmentSaveParams>({
    deptCode: '',
    deptName: '',
    campusCode: '',
    leader: undefined,
    phone: undefined,
    sort: 0,
    status: 1
  })

  const rules = reactive<FormRules>({
    deptCode: [{ required: true, message: '请输入院系编码', trigger: 'blur' }],
    deptName: [{ required: true, message: '请输入院系名称', trigger: 'blur' }],
    campusCode: [{ required: true, message: '请选择所属校区', trigger: 'change' }]
  })

  /**
   * 加载校区列表（使用 store 缓存）
   */
  const loadCampusOptions = async (): Promise<void> => {
    try {
      campusOptions.value = await referenceStore.loadCampusTree()
    } catch (error) {
      console.error('加载校区列表失败:', error)
    }
  }

  /**
   * 加载表单数据
   */
  const loadFormData = (): void => {
    if (isEdit.value && props.editData) {
      Object.assign(form, {
        id: props.editData.id,
        deptCode: props.editData.deptCode,
        deptName: props.editData.deptName,
        campusCode: props.editData.campusCode,
        leader: props.editData.leader || undefined,
        phone: props.editData.phone || undefined,
        sort: props.editData.sort || 0,
        status: props.editData.status
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
      deptCode: '',
      deptName: '',
      campusCode: '',
      leader: undefined,
      phone: undefined,
      sort: 0,
      status: 1
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
        await fetchUpdateDepartment(form.id!, form)
      } else {
        await fetchAddDepartment(form)
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
        loadCampusOptions()
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
