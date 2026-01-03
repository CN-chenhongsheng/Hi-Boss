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

  /**
   * 表单数据双向绑定
   */
  const formData = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  /**
   * 表单校验规则
   */
  const rules = {}

  /**
   * 状态选项
   */
  const statusOptions = ref([
    { label: '正常', value: 1 },
    { label: '停用', value: 0 }
  ])

  /**
   * 床位状态选项
   */
  const bedStatusOptions = ref([
    { label: '空闲', value: 1 },
    { label: '已占用', value: 2 },
    { label: '维修中', value: 3 },
    { label: '已预订', value: 4 }
  ])

  /**
   * 搜索表单配置项
   */
  const formItems = computed(() => [
    {
      label: '床位编码',
      key: 'bedCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入床位编码' }
    },
    {
      label: '床位号',
      key: 'bedNumber',
      type: 'input',
      props: { clearable: true, placeholder: '请输入床位号' }
    },
    {
      label: '房间',
      key: 'roomCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入房间编码' }
    },
    {
      label: '楼层',
      key: 'floorCode',
      type: 'input',
      props: { clearable: true, placeholder: '请输入楼层编码' }
    },
    {
      label: '校区',
      key: 'campusCode',
      type: 'select',
      props: {
        clearable: true,
        placeholder: '请选择校区',
        options: [] // 需要从API获取校区列表
      }
    },
    {
      label: '床位状态',
      key: 'bedStatus',
      type: 'select',
      props: {
        clearable: true,
        placeholder: '请选择床位状态',
        options: bedStatusOptions.value
      }
    },
    {
      label: '状态',
      key: 'status',
      type: 'select',
      props: {
        clearable: true,
        placeholder: '请选择状态',
        options: statusOptions.value
      }
    }
  ])

  /**
   * 处理重置事件
   */
  const handleReset = () => {
    emit('reset')
  }

  /**
   * 处理搜索事件
   */
  const handleSearch = async () => {
    await searchBarRef.value.validate()
    emit('search', formData.value)
  }
</script>
