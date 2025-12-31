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
        <ElSelect
          v-model="form.campusCode"
          placeholder="请选择所属校区"
          filterable
          @change="handleCampusChange"
        >
          <ElOption
            v-for="campus in campusOptions"
            :key="campus.campusCode"
            :label="campus.campusName"
            :value="campus.campusCode"
          />
        </ElSelect>
      </ElFormItem>

      <ElFormItem label="上级院系" prop="parentCode">
        <ElTreeSelect
          v-model="form.parentCode"
          :data="departmentTreeOptions"
          :props="{ value: 'deptCode', label: 'deptName', children: 'children' }"
          placeholder="请选择上级院系（不选则为顶级院系）"
          clearable
          check-strictly
          :render-after-expand="false"
          :disabled="!form.campusCode"
        />
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

      <ElFormItem label="状态" prop="status">
        <ElRadioGroup v-model="form.status">
          <ElRadio :label="1">启用</ElRadio>
          <ElRadio :label="0">停用</ElRadio>
        </ElRadioGroup>
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
    fetchGetCampusTree,
    fetchGetDepartmentTree,
    fetchAddDepartment,
    fetchUpdateDepartment
  } from '@/api/school-manage'
  import { ElMessage } from 'element-plus'
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
  const departmentTreeOptions = ref<Api.SystemManage.DepartmentListItem[]>([])

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => (isEdit.value ? '编辑院系' : '新增院系'))

  const form = reactive<Api.SystemManage.DepartmentSaveParams>({
    deptCode: '',
    deptName: '',
    campusCode: '',
    parentCode: undefined,
    leader: undefined,
    phone: undefined,
    status: 1
  })

  const rules = reactive<FormRules>({
    deptCode: [{ required: true, message: '请输入院系编码', trigger: 'blur' }],
    deptName: [{ required: true, message: '请输入院系名称', trigger: 'blur' }],
    campusCode: [{ required: true, message: '请选择所属校区', trigger: 'change' }],
    status: [{ required: true, message: '请选择状态', trigger: 'change' }]
  })

  /**
   * 加载校区列表
   */
  const loadCampusOptions = async (): Promise<void> => {
    try {
      const list = await fetchGetCampusTree()
      campusOptions.value = flattenCampusTree(list)
    } catch (error) {
      console.error('加载校区列表失败:', error)
    }
  }

  /**
   * 扁平化校区树
   */
  const flattenCampusTree = (
    list: Api.SystemManage.CampusListItem[]
  ): Api.SystemManage.CampusListItem[] => {
    const result: Api.SystemManage.CampusListItem[] = []
    const flatten = (items: Api.SystemManage.CampusListItem[]) => {
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
   * 加载院系树（用于上级院系选择）
   */
  const loadDepartmentTree = async (): Promise<void> => {
    try {
      const params: Api.SystemManage.DepartmentSearchParams = {}
      if (form.campusCode) {
        params.campusCode = form.campusCode
      }
      const list = await fetchGetDepartmentTree(params)
      // 编辑时，排除自己和自己的子院系
      if (isEdit.value && props.editData) {
        departmentTreeOptions.value = filterDepartmentTree(list, props.editData.deptCode)
      } else {
        departmentTreeOptions.value = list
      }
    } catch (error) {
      console.error('加载院系树失败:', error)
    }
  }

  /**
   * 过滤院系树（排除指定院系及其子院系）
   */
  const filterDepartmentTree = (
    list: Api.SystemManage.DepartmentListItem[],
    excludeCode: string
  ): Api.SystemManage.DepartmentListItem[] => {
    return list
      .filter((item) => item.deptCode !== excludeCode)
      .map((item) => {
        if (item.children && item.children.length > 0) {
          return {
            ...item,
            children: filterDepartmentTree(item.children, excludeCode)
          }
        }
        return item
      })
  }

  /**
   * 校区变化时重新加载院系树
   */
  const handleCampusChange = (): void => {
    form.parentCode = undefined
    loadDepartmentTree()
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
        parentCode: props.editData.parentCode || undefined,
        leader: props.editData.leader || undefined,
        phone: props.editData.phone || undefined,
        status: props.editData.status
      })
      loadDepartmentTree()
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
      parentCode: undefined,
      leader: undefined,
      phone: undefined,
      status: 1
    })
    departmentTreeOptions.value = []
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
        ElMessage.success('编辑成功')
      } else {
        await fetchAddDepartment(form)
        ElMessage.success('新增成功')
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
