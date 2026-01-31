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

  const searchBarRef = ref()

  const formData = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  const rules = {}

  // 报修状态选项
  const statusOptions = [
    { label: '待接单', value: 1 },
    { label: '已接单', value: 2 },
    { label: '维修中', value: 3 },
    { label: '已完成', value: 4 },
    { label: '已取消', value: 5 }
  ]

  // 报修类型选项
  const repairTypeOptions = [
    { label: '水电', value: 1 },
    { label: '门窗', value: 2 },
    { label: '家具', value: 3 },
    { label: '网络', value: 4 },
    { label: '其他', value: 5 }
  ]

  // 紧急程度选项
  const urgentLevelOptions = [
    { label: '一般', value: 1 },
    { label: '紧急', value: 2 },
    { label: '非常紧急', value: 3 }
  ]

  const formItems = computed(() => [
    {
      label: '学号',
      key: 'studentNo',
      type: 'input',
      placeholder: '请输入学号',
      clearable: true
    },
    {
      label: '学生姓名',
      key: 'studentName',
      type: 'input',
      placeholder: '请输入学生姓名',
      clearable: true
    },
    {
      label: '报修类型',
      key: 'repairType',
      type: 'select',
      props: {
        placeholder: '请选择报修类型',
        clearable: true,
        options: repairTypeOptions
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
    },
    {
      label: '紧急程度',
      key: 'urgentLevel',
      type: 'select',
      props: {
        placeholder: '请选择紧急程度',
        clearable: true,
        options: urgentLevelOptions
      }
    },
    {
      label: '报修日期开始',
      key: 'createDateStart',
      type: 'date',
      props: {
        placeholder: '请选择报修日期开始',
        clearable: true,
        valueFormat: 'YYYY-MM-DD'
      }
    },
    {
      label: '报修日期结束',
      key: 'createDateEnd',
      type: 'date',
      props: {
        placeholder: '请选择报修日期结束',
        clearable: true,
        valueFormat: 'YYYY-MM-DD'
      }
    }
  ])

  const handleReset = () => {
    emit('reset')
  }

  const handleSearch = () => {
    emit('search', formData.value)
  }
</script>
