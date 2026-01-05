<!-- 班级编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="班级编码" prop="classCode">
        <ElInput v-model="form.classCode" placeholder="请输入班级编码" :disabled="isEdit" />
      </ElFormItem>

      <ElFormItem label="班级名称" prop="className">
        <ElInput v-model="form.className" placeholder="请输入班级名称" />
      </ElFormItem>

      <ElFormItem label="所属专业" prop="majorCode">
        <ElSelect
          v-model="form.majorCode"
          placeholder="请选择所属专业"
          filterable
          clearable
          :loading="majorLoading"
          @focus="handleMajorFocus"
        >
          <ElOption
            v-for="major in majorOptions"
            :key="major.majorCode"
            :label="`${major.majorName} (${major.majorCode})`"
            :value="major.majorCode"
          />
        </ElSelect>
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="年级" prop="grade">
            <ElInput v-model="form.grade" placeholder="如：2023" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="入学年份" prop="enrollmentYear">
            <ElInputNumber
              v-model="form.enrollmentYear"
              :min="2000"
              :max="2100"
              placeholder="如：2023"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="负责人" prop="teacherId">
            <ElSelect
              v-model="form.teacherId"
              placeholder="请选择负责人"
              filterable
              clearable
              :loading="teacherLoading"
              @focus="handleTeacherFocus"
            >
              <ElOption
                v-for="user in teacherOptions"
                :key="user.id"
                :label="
                  user.nickname && user.phone
                    ? `${user.nickname} (${user.phone})`
                    : user.nickname || user.username
                "
                :value="user.id"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="当前人数" prop="currentCount">
            <ElInputNumber v-model="form.currentCount" :min="0" :max="9999" />
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
  import { fetchGetClassDetail, fetchAddClass, fetchUpdateClass } from '@/api/school-manage'
  import { useReferenceStore } from '@/store/modules/reference'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Partial<Api.SystemManage.ClassListItem> | null
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
  const majorLoading = ref(false)
  const majorOptions = ref<Api.SystemManage.MajorListItem[]>([])
  const teacherLoading = ref(false)
  const teacherOptions = ref<Api.SystemManage.UserSimpleItem[]>([])

  // 使用参考数据 store
  const referenceStore = useReferenceStore()

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => (isEdit.value ? '编辑班级' : '新增班级'))

  const form = reactive<Api.SystemManage.ClassSaveParams>({
    classCode: '',
    className: '',
    majorCode: '',
    grade: '',
    teacherId: undefined,
    enrollmentYear: new Date().getFullYear(),
    currentCount: 0
  })

  const rules = reactive<FormRules>({
    classCode: [{ required: true, message: '请输入班级编码', trigger: 'blur' }],
    className: [{ required: true, message: '请输入班级名称', trigger: 'blur' }],
    majorCode: [{ required: true, message: '请选择所属专业', trigger: 'change' }],
    grade: [{ required: true, message: '请输入年级', trigger: 'blur' }],
    enrollmentYear: [{ required: true, message: '请输入入学年份', trigger: 'blur' }]
  })

  /**
   * 加载专业列表（使用 store 缓存）
   */
  const loadMajorOptions = async (): Promise<void> => {
    majorLoading.value = true
    try {
      majorOptions.value = await referenceStore.loadMajorList()
    } catch (error) {
      console.error('加载专业列表失败:', error)
    } finally {
      majorLoading.value = false
    }
  }

  /**
   * 专业下拉框获取焦点时加载数据
   */
  const handleMajorFocus = async (): Promise<void> => {
    if (majorOptions.value.length === 0) {
      await loadMajorOptions()
    }
  }

  /**
   * 加载负责人列表（辅导员角色）（使用 store 缓存）
   */
  const loadTeacherOptions = async (): Promise<void> => {
    if (teacherOptions.value.length > 0) return

    teacherLoading.value = true
    try {
      teacherOptions.value = await referenceStore.loadUsersByRoleCodes(['COUNSELOR'])
    } catch (error) {
      console.error('加载负责人列表失败:', error)
    } finally {
      teacherLoading.value = false
    }
  }

  /**
   * 负责人下拉框获取焦点时加载数据
   */
  const handleTeacherFocus = async (): Promise<void> => {
    await loadTeacherOptions()
  }

  /**
   * 加载表单数据
   */
  const loadFormData = async (): Promise<void> => {
    if (isEdit.value && props.editData?.id) {
      try {
        const detail = await fetchGetClassDetail(props.editData.id)
        Object.assign(form, {
          id: detail.id,
          classCode: detail.classCode,
          className: detail.className,
          majorCode: detail.majorCode,
          grade: detail.grade,
          teacherId: detail.teacherId || undefined,
          enrollmentYear: detail.enrollmentYear,
          currentCount: detail.currentCount || 0
        })
        // 加载专业列表到选项列表（使用 store 缓存）
        if (detail.majorCode) {
          majorOptions.value = await referenceStore.loadMajorList()
        }
      } catch (error) {
        console.error('加载班级详情失败:', error)
      }
    } else {
      resetForm()
    }
  }

  /**
   * 重置表单
   */
  const resetForm = (): void => {
    Object.assign(form, {
      classCode: '',
      className: '',
      majorCode: '',
      grade: '',
      teacherId: undefined,
      enrollmentYear: new Date().getFullYear(),
      currentCount: 0
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
        await fetchUpdateClass(form.id!, form)
      } else {
        await fetchAddClass(form)
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
        loadMajorOptions()
        loadTeacherOptions()
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
