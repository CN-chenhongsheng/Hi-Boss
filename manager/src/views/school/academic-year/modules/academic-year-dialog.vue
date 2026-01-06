<!-- 学年编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="800px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="学年编码" prop="yearCode">
        <ElInput v-model="form.yearCode" placeholder="请输入学年编码" :disabled="isEdit" />
      </ElFormItem>

      <ElFormItem label="学年名称" prop="yearName">
        <ElInput v-model="form.yearName" placeholder="请输入学年名称，如：2023-2024学年" />
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="开始日期" prop="startDate">
            <ElDatePicker
              v-model="form.startDate"
              type="date"
              placeholder="选择开始日期"
              style="width: 100%"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="结束日期" prop="endDate">
            <ElDatePicker
              v-model="form.endDate"
              type="date"
              placeholder="选择结束日期"
              style="width: 100%"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <!-- 学期列表 -->
      <ElFormItem label="学期管理">
        <div class="semester-list">
          <div v-for="(semester, index) in form.semesters" :key="index" class="semester-item">
            <ElRow :gutter="10">
              <ElCol :span="6">
                <ElInput v-model="semester.semesterName" placeholder="学期名称，如：第一学期" />
              </ElCol>
              <ElCol :span="6">
                <ElInput v-model="semester.semesterCode" placeholder="学期编码" />
              </ElCol>
              <ElCol :span="4">
                <ElDatePicker
                  v-model="semester.startDate"
                  type="date"
                  placeholder="开始日期"
                  style="width: 100%"
                />
              </ElCol>
              <ElCol :span="4">
                <ElDatePicker
                  v-model="semester.endDate"
                  type="date"
                  placeholder="结束日期"
                  style="width: 100%"
                />
              </ElCol>
              <ElCol :span="4">
                <ElButton type="danger" :icon="Delete" circle @click="removeSemester(index)" />
              </ElCol>
            </ElRow>
          </div>
          <ElButton type="primary" :icon="Plus" @click="addSemester"> 添加学期 </ElButton>
        </div>
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { Plus, Delete } from '@element-plus/icons-vue'
  import { ElDatePicker, ElMessage } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import { fetchAddAcademicYear, fetchUpdateAcademicYear } from '@/api/school-manage'

  interface SemesterItem {
    semesterName: string
    semesterCode: string
    startDate: string | null
    endDate: string | null
    semesterType?: string
  }

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: any | null
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
    if (isEdit.value) return '编辑学年'
    return '新增学年'
  })

  const form = reactive({
    id: undefined as number | undefined,
    yearCode: '',
    yearName: '',
    startDate: null as string | null,
    endDate: null as string | null,
    status: 1,
    semesters: [] as SemesterItem[]
  })

  const rules = reactive<FormRules>({
    yearCode: [{ required: true, message: '请输入学年编码', trigger: 'blur' }],
    yearName: [{ required: true, message: '请输入学年名称', trigger: 'blur' }],
    startDate: [{ required: true, message: '请选择开始日期', trigger: 'change' }],
    endDate: [{ required: true, message: '请选择结束日期', trigger: 'change' }]
  })

  /**
   * 添加学期
   */
  const addSemester = (): void => {
    form.semesters.push({
      semesterName: '',
      semesterCode: '',
      startDate: null,
      endDate: null
    })
  }

  /**
   * 删除学期
   */
  const removeSemester = (index: number): void => {
    form.semesters.splice(index, 1)
  }

  /**
   * 加载表单数据
   */
  const loadFormData = (): void => {
    if (isEdit.value && props.editData) {
      Object.assign(form, {
        id: props.editData.id,
        yearCode: props.editData.yearCode || '',
        yearName: props.editData.yearName || '',
        startDate: props.editData.startDate || null,
        endDate: props.editData.endDate || null,
        status: props.editData.status || 1,
        semesters: props.editData.semesters || []
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
      id: undefined,
      yearCode: '',
      yearName: '',
      startDate: null,
      endDate: null,
      status: 1,
      semesters: []
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
      // 格式化提交数据
      const submitData: Api.SystemManage.AcademicYearSaveParams = {
        id: form.id,
        yearCode: form.yearCode,
        yearName: form.yearName,
        startDate: form.startDate || '',
        endDate: form.endDate || '',
        status: form.status,
        semesters: form.semesters.map((semester) => ({
          id: (semester as any).id,
          semesterCode: semester.semesterCode,
          semesterName: semester.semesterName,
          startDate: semester.startDate || '',
          endDate: semester.endDate || '',
          semesterType: semester.semesterType
        }))
      }

      if (isEdit.value && form.id) {
        await fetchUpdateAcademicYear(form.id, submitData)
      } else {
        await fetchAddAcademicYear(submitData)
      }
      ElMessage.success(isEdit.value ? '编辑成功' : '新增成功')
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

<style scoped lang="scss">
  .semester-list {
    .semester-item {
      margin-bottom: 10px;
      padding: 10px;
      background-color: var(--el-fill-color-lighter);
      border-radius: calc(var(--custom-radius) / 1.2 + 2px) !important;
    }
  }
</style>
