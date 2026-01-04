<!-- 楼层编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="楼层编码" prop="floorCode">
        <ElInput
          v-model="form.floorCode"
          placeholder="请输入楼层编码（如：F1、F2）"
          :disabled="isEdit"
        />
      </ElFormItem>

      <ElFormItem label="楼层名称" prop="floorName">
        <ElInput v-model="form.floorName" placeholder="请输入楼层名称（如：1楼、2楼）" />
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="楼层数" prop="floorNumber">
            <ElInputNumber
              v-model="form.floorNumber"
              :min="1"
              :max="999"
              placeholder="请输入楼层数"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="所属校区" prop="campusCode">
            <ElSelect v-model="form.campusCode" placeholder="请选择校区" filterable clearable>
              <ElOption
                v-for="item in campusList"
                :key="item.campusCode"
                :label="item.campusName"
                :value="item.campusCode"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="适用性别" prop="genderType">
        <ElRadioGroup v-model="form.genderType">
          <ElRadio :label="1">男</ElRadio>
          <ElRadio :label="2">女</ElRadio>
          <ElRadio :label="3">混合</ElRadio>
        </ElRadioGroup>
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="状态" prop="status">
            <ElRadioGroup v-model="form.status">
              <ElRadio :label="1">启用</ElRadio>
              <ElRadio :label="0">停用</ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="排序序号" prop="sort">
            <ElInputNumber v-model="form.sort" :min="0" :max="9999" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchGetCampusTree } from '@/api/school-manage'
  import { fetchAddFloor, fetchUpdateFloor } from '@/api/dormitory-manage'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Api.SystemManage.FloorListItem | null
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
  const campusList = ref<Api.SystemManage.CampusListItem[]>([])

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => {
    if (isEdit.value) return '编辑楼层'
    return '新增楼层'
  })

  const form = reactive<Api.SystemManage.FloorSaveParams>({
    floorCode: '',
    floorName: '',
    floorNumber: 1,
    campusCode: '',
    genderType: 3,
    sort: 0,
    status: 1,
    remark: undefined
  })

  const rules = reactive<FormRules>({
    floorCode: [{ required: true, message: '请输入楼层编码', trigger: 'blur' }],
    floorNumber: [{ required: true, message: '请输入楼层数', trigger: 'blur' }],
    campusCode: [{ required: true, message: '请选择所属校区', trigger: 'change' }],
    genderType: [{ required: true, message: '请选择适用性别', trigger: 'change' }]
  })

  /**
   * 加载校区列表
   */
  const loadCampusList = async (): Promise<void> => {
    try {
      const res = await fetchGetCampusTree()
      campusList.value = res || []
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
        floorCode: props.editData.floorCode,
        floorName: props.editData.floorName || '',
        floorNumber: props.editData.floorNumber,
        campusCode: props.editData.campusCode,
        genderType: props.editData.genderType,
        sort: props.editData.sort || 0,
        status: props.editData.status,
        remark: props.editData.remark || undefined
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
      floorCode: '',
      floorName: '',
      floorNumber: 1,
      campusCode: '',
      genderType: 3,
      sort: 0,
      status: 1,
      remark: undefined
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
        await fetchUpdateFloor(form.id!, form)
      } else {
        await fetchAddFloor(form)
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
        loadCampusList()
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
