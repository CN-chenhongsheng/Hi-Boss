<template>
  <ArtSearchBar
    ref="searchBarRef"
    v-model="formData"
    :items="formItems"
    :rules="rules"
    @reset="handleReset"
    @search="handleSearch"
  >
  </ArtSearchBar>
</template>

<script setup lang="ts">
  import { computed } from 'vue'

  interface Props {
    modelValue: Record<string, any>
  }
  interface Emits {
    (e: 'update:modelValue', value: Record<string, any>): void
    (e: 'search', params: Record<string, any>): void
    (e: 'reset'): void
  }
  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  // 表单数据双向绑定
  const searchBarRef = ref()
  const formData = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  // 校验规则
  const rules = {}

  // 状态选项
  const statusOptions = [
    { label: '正常', value: 1 },
    { label: '停用', value: 0 }
  ]

  // 学籍状态选项
  const academicStatusOptions = [
    { label: '在读', value: 1 },
    { label: '休学', value: 2 },
    { label: '毕业', value: 3 },
    { label: '退学', value: 4 }
  ]

  // 表单配置
  const formItems = computed(() => [
    {
      label: '学号',
      key: 'studentNo',
      type: 'input',
      placeholder: '请输入学号',
      clearable: true
    },
    {
      label: '姓名',
      key: 'studentName',
      type: 'input',
      placeholder: '请输入姓名',
      clearable: true
    },
    {
      label: '手机号',
      key: 'phone',
      type: 'input',
      props: { placeholder: '请输入手机号', maxlength: '11', clearable: true }
    },
    {
      label: '校区编码',
      key: 'campusCode',
      type: 'input',
      props: { placeholder: '请输入校区编码', clearable: true }
    },
    {
      label: '院系编码',
      key: 'deptCode',
      type: 'input',
      props: { placeholder: '请输入院系编码', clearable: true }
    },
    {
      label: '专业编码',
      key: 'majorCode',
      type: 'input',
      props: { placeholder: '请输入专业编码', clearable: true }
    },
    {
      label: '学籍状态',
      key: 'academicStatus',
      type: 'select',
      props: {
        placeholder: '请选择学籍状态',
        clearable: true,
        options: academicStatusOptions
      }
    },
    {
      label: '状态',
      key: 'status',
      type: 'select',
      props: {
        placeholder: '请选择状态',
        clearable: true,
        options: statusOptions
      }
    }
  ])

  // 事件
  function handleReset() {
    emit('reset')
  }

  async function handleSearch() {
    await searchBarRef.value.validate()
    emit('search', formData.value)
  }
</script>
