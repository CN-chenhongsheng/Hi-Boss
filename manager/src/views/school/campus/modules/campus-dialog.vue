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

      <ElFormItem label="上级校区" prop="parentCode">
        <ElTreeSelect
          v-model="form.parentCode"
          :data="campusTreeOptions"
          :props="{ value: 'campusCode', label: 'campusName', children: 'children' }"
          placeholder="请选择上级校区（不选则为顶级校区）"
          clearable
          check-strictly
          :render-after-expand="false"
          :disabled="isAddChild"
        />
      </ElFormItem>

      <ElFormItem label="校区地址" prop="address">
        <ElInput v-model="form.address" type="textarea" :rows="3" placeholder="请输入校区地址" />
      </ElFormItem>

      <ElFormItem label="负责人" prop="manager">
        <ElInput v-model="form.manager" placeholder="请输入负责人姓名" />
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
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchGetCampusTree, fetchAddCampus, fetchUpdateCampus } from '@/api/school-manage'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit' | 'addChild'
    editData?: Api.SystemManage.CampusListItem | null
    parentData?: Api.SystemManage.CampusListItem | null
  }

  interface Emits {
    (e: 'update:visible', visible: boolean): void
    (e: 'submit'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    editData: null,
    parentData: null
  })

  const emit = defineEmits<Emits>()

  const formRef = ref<FormInstance>()
  const loading = ref(false)
  const campusTreeOptions = ref<Api.SystemManage.CampusListItem[]>([])

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')
  const isAddChild = computed(() => props.type === 'addChild')

  const dialogTitle = computed(() => {
    if (isEdit.value) return '编辑校区'
    if (isAddChild.value) return '新增子校区'
    return '新增校区'
  })

  const form = reactive<Api.SystemManage.CampusSaveParams>({
    campusCode: '',
    campusName: '',
    parentCode: undefined,
    address: '',
    manager: undefined,
    status: 1,
    sort: 0
  })

  const rules = reactive<FormRules>({
    campusCode: [{ required: true, message: '请输入校区编码', trigger: 'blur' }],
    campusName: [{ required: true, message: '请输入校区名称', trigger: 'blur' }],
    address: [{ required: true, message: '请输入校区地址', trigger: 'blur' }],
    status: [{ required: true, message: '请选择状态', trigger: 'change' }]
  })

  /**
   * 加载校区树（用于上级校区选择）
   */
  const loadCampusTree = async (): Promise<void> => {
    try {
      const list = await fetchGetCampusTree()
      // 编辑时，排除自己和自己的子校区
      if (isEdit.value && props.editData) {
        campusTreeOptions.value = filterCampusTree(list, props.editData.campusCode)
      } else if (isAddChild.value && props.parentData) {
        // 新增子校区时，排除父校区及其子校区
        campusTreeOptions.value = filterCampusTree(list, props.parentData.campusCode)
      } else {
        campusTreeOptions.value = list
      }
    } catch (error) {
      console.error('加载校区树失败:', error)
    }
  }

  /**
   * 过滤校区树（排除指定校区及其子校区）
   */
  const filterCampusTree = (
    list: Api.SystemManage.CampusListItem[],
    excludeCode: string
  ): Api.SystemManage.CampusListItem[] => {
    return list
      .filter((item) => item.campusCode !== excludeCode)
      .map((item) => {
        if (item.children && item.children.length > 0) {
          return {
            ...item,
            children: filterCampusTree(item.children, excludeCode)
          }
        }
        return item
      })
  }

  /**
   * 加载表单数据
   */
  const loadFormData = (): void => {
    if (isEdit.value && props.editData) {
      Object.assign(form, {
        id: props.editData.id,
        campusCode: props.editData.campusCode,
        campusName: props.editData.campusName,
        parentCode: props.editData.parentCode || undefined,
        address: props.editData.address,
        manager: props.editData.manager || undefined,
        status: props.editData.status,
        sort: props.editData.sort || 0
      })
    } else if (isAddChild.value && props.parentData) {
      // 新增子校区时，默认填充父校区
      resetForm()
      form.parentCode = props.parentData.campusCode
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
      parentCode: undefined,
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
        loadCampusTree()
        loadFormData()
      }
    },
    { immediate: true }
  )
</script>
