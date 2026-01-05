<!-- 专业编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="600px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px" label-position="right">
      <ElFormItem label="专业编码" prop="majorCode">
        <ElInput v-model="form.majorCode" placeholder="请输入专业编码" :disabled="isEdit" />
      </ElFormItem>

      <ElFormItem label="专业名称" prop="majorName">
        <ElInput v-model="form.majorName" placeholder="请输入专业名称" />
      </ElFormItem>

      <ElFormItem label="所属院系" prop="deptCode">
        <ElSelect
          v-model="form.deptCode"
          placeholder="请选择所属院系"
          filterable
          clearable
          :loading="deptLoading"
          @focus="handleDeptFocus"
        >
          <ElOption
            v-for="dept in deptOptions"
            :key="dept.deptCode"
            :label="`${dept.deptName} (${dept.deptCode})`"
            :value="dept.deptCode"
          />
        </ElSelect>
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="专业负责人" prop="director">
            <ElInput v-model="form.director" placeholder="请输入专业负责人" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="学位类型" prop="type">
            <ElSelect v-model="form.type" placeholder="请选择学位类型" clearable filterable>
              <ElOption
                v-for="item in degreeTypeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="学制" prop="duration">
        <ElInputNumber
          v-model="durationNumber"
          :min="1"
          :max="10"
          :precision="0"
          placeholder="请输入学制年限"
          controls-position="right"
          :formatter="(value: string) => `${value}年制`"
          :parser="(value: string) => value.replace('年制', '')"
          style="width: 100%"
        />
      </ElFormItem>

      <ElFormItem label="培养目标" prop="goal">
        <ElInput v-model="form.goal" type="textarea" :rows="4" placeholder="请输入培养目标" />
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import {
    fetchGetDepartmentTree,
    fetchGetMajorDetail,
    fetchAddMajor,
    fetchUpdateMajor
  } from '@/api/school-manage'
  import { useDictStore } from '@/store/modules/dict'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Partial<Api.SystemManage.MajorListItem> | null
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
  const deptLoading = ref(false)
  const deptOptions = ref<Api.SystemManage.DepartmentListItem[]>([])
  const degreeTypeOptions = ref<Array<{ label: string; value: string }>>([])

  // 使用字典 store
  const dictStore = useDictStore()

  // 学制数字值（用于数字输入框）
  const durationNumber = ref<number | null>(null)

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => (isEdit.value ? '编辑专业' : '新增专业'))

  const form = reactive<Api.SystemManage.MajorSaveParams>({
    majorCode: '',
    majorName: '',
    deptCode: '',
    director: undefined,
    type: undefined,
    duration: '',
    goal: undefined
  })

  const rules = reactive<FormRules>({
    majorCode: [{ required: true, message: '请输入专业编码', trigger: 'blur' }],
    majorName: [{ required: true, message: '请输入专业名称', trigger: 'blur' }],
    deptCode: [{ required: true, message: '请选择所属院系', trigger: 'change' }],
    type: [{ required: true, message: '请选择学位类型', trigger: 'change' }],
    duration: [
      {
        required: true,
        validator: (_rule, _value, callback) => {
          if (durationNumber.value === null || durationNumber.value === undefined) {
            callback(new Error('请输入学制'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ]
  })

  /**
   * 加载学位类型字典
   */
  const loadDegreeTypeOptions = async (): Promise<void> => {
    try {
      // 使用 store 加载字典数据（自动缓存）
      const data = await dictStore.loadDictData('degree_type')
      degreeTypeOptions.value = data
        .filter((item) => item.status === 1)
        .map((item) => ({
          label: item.label,
          value: item.value
        }))
    } catch (error) {
      console.error('加载学位类型字典失败:', error)
    }
  }

  /**
   * 加载院系列表
   */
  const loadDepartmentOptions = async (): Promise<void> => {
    try {
      const list = await fetchGetDepartmentTree()
      deptOptions.value = flattenDepartmentTree(list)
    } catch (error) {
      console.error('加载院系列表失败:', error)
    }
  }

  /**
   * 扁平化院系树
   */
  const flattenDepartmentTree = (
    list: Api.SystemManage.DepartmentListItem[]
  ): Api.SystemManage.DepartmentListItem[] => {
    const result: Api.SystemManage.DepartmentListItem[] = []
    const flatten = (items: Api.SystemManage.DepartmentListItem[]) => {
      items.forEach((item) => {
        result.push(item)
        if (item.children && item.children.length > 0) {
          flatten(item.children)
        }
      })
    }
    flatten(list)
    return result
  }

  /**
   * 院系下拉框获取焦点时加载数据
   */
  const handleDeptFocus = async (): Promise<void> => {
    if (deptOptions.value.length === 0) {
      deptLoading.value = true
      try {
        await loadDepartmentOptions()
      } finally {
        deptLoading.value = false
      }
    }
  }

  /**
   * 从字符串中提取数字（用于从后端数据中解析学制）
   */
  const parseDuration = (durationStr: string | undefined): number | null => {
    if (!durationStr) return null
    const match = durationStr.match(/^(\d+)/)
    return match ? Number.parseInt(match[1], 10) : null
  }

  /**
   * 将数字转换为学制字符串（用于提交到后端）
   */
  const formatDuration = (num: number | null): string => {
    return num ? `${num}年制` : ''
  }

  /**
   * 加载表单数据
   */
  const loadFormData = async (): Promise<void> => {
    if (isEdit.value && props.editData?.id) {
      try {
        const detail = await fetchGetMajorDetail(props.editData.id)
        Object.assign(form, {
          id: detail.id,
          majorCode: detail.majorCode,
          majorName: detail.majorName,
          deptCode: detail.deptCode,
          director: detail.director || undefined,
          type: detail.type || undefined,
          duration: detail.duration,
          goal: detail.goal || undefined
        })
        // 解析学制数字
        durationNumber.value = parseDuration(detail.duration)
        // 加载该院系到选项列表
        if (detail.deptCode) {
          const list = await fetchGetDepartmentTree({ deptCode: detail.deptCode })
          deptOptions.value = flattenDepartmentTree(list)
        }
      } catch (error) {
        console.error('加载专业详情失败:', error)
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
      majorCode: '',
      majorName: '',
      deptCode: '',
      director: undefined,
      type: undefined,
      duration: '',
      goal: undefined
    })
    durationNumber.value = null
    formRef.value?.clearValidate()
  }

  /**
   * 提交表单
   */
  const handleSubmit = async (): Promise<void> => {
    if (!formRef.value) return

    const valid = await formRef.value.validate().catch(() => false)
    if (!valid) return

    // 将学制数字转换为字符串格式
    form.duration = formatDuration(durationNumber.value)

    loading.value = true
    try {
      if (isEdit.value) {
        await fetchUpdateMajor(form.id!, form)
      } else {
        await fetchAddMajor(form)
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
        loadDegreeTypeOptions()
        loadDepartmentOptions()
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
