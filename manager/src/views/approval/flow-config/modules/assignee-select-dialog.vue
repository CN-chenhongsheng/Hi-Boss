<!-- 审批人选择弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="assigneeType === 1 ? '选择角色' : '选择用户'"
    width="600px"
    :close-on-click-modal="false"
    destroy-on-close
  >
    <!-- 搜索 -->
    <div class="mb-4">
      <ElInput
        v-model="searchKeyword"
        placeholder="请输入搜索关键词"
        clearable
        @input="handleSearch"
      >
        <template #prefix>
          <i class="ri-search-line"></i>
        </template>
      </ElInput>
    </div>

    <!-- 列表 -->
    <div class="max-h-[400px] overflow-y-auto">
      <ElTable
        ref="tableRef"
        :data="filteredList"
        row-key="id"
        @selection-change="handleSelectionChange"
      >
        <ElTableColumn type="selection" width="55" reserve-selection />
        <ElTableColumn prop="name" :label="assigneeType === 1 ? '角色名称' : '用户名'" />
        <ElTableColumn v-if="assigneeType === 1" prop="code" label="角色编码" />
        <ElTableColumn v-else prop="nickname" label="昵称" />
      </ElTable>
    </div>

    <template #footer>
      <ElButton @click="dialogVisible = false" v-ripple>取消</ElButton>
      <ElButton type="primary" @click="handleConfirm" v-ripple>
        确定 ({{ selectedItems.length }})
      </ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchGetAllRoles, fetchGetUserList } from '@/api/system-manage'
  import type { ElTable } from 'element-plus'

  interface SelectItem {
    id: number
    name: string
    code?: string
    nickname?: string
  }

  const props = defineProps<{
    modelValue: boolean
    assigneeType: 1 | 2 // 1角色 2用户
    selectedIds: number[]
  }>()

  const emit = defineEmits<{
    'update:modelValue': [value: boolean]
    confirm: [selected: Array<{ id: number; name: string }>]
  }>()

  const dialogVisible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  const tableRef = ref<InstanceType<typeof ElTable>>()
  const searchKeyword = ref('')
  const dataList = ref<SelectItem[]>([])
  const selectedItems = ref<SelectItem[]>([])

  const filteredList = computed(() => {
    if (!searchKeyword.value) return dataList.value
    const keyword = searchKeyword.value.toLowerCase()
    return dataList.value.filter(
      (item) =>
        item.name.toLowerCase().includes(keyword) ||
        item.code?.toLowerCase().includes(keyword) ||
        item.nickname?.toLowerCase().includes(keyword)
    )
  })

  // 监听弹窗打开
  watch(
    () => props.modelValue,
    async (val) => {
      if (val) {
        await loadData()
        // 设置已选中项
        nextTick(() => {
          if (tableRef.value) {
            dataList.value.forEach((row) => {
              if (props.selectedIds.includes(row.id)) {
                tableRef.value!.toggleRowSelection(row, true)
              }
            })
          }
        })
      } else {
        searchKeyword.value = ''
        selectedItems.value = []
      }
    }
  )

  const loadData = async () => {
    try {
      if (props.assigneeType === 1) {
        // 加载角色列表
        const res = await fetchGetAllRoles()
        dataList.value = res.map((item) => ({
          id: item.id,
          name: item.roleName,
          code: item.roleCode
        }))
      } else {
        // 加载用户列表
        const res = await fetchGetUserList({ pageNum: 1, pageSize: 1000, status: 1 })
        dataList.value = res.list.map((item) => ({
          id: item.id,
          name: item.username,
          nickname: item.nickname
        }))
      }
    } catch (error) {
      console.error('加载数据失败:', error)
    }
  }

  const handleSearch = () => {
    // 搜索由computed属性自动处理
  }

  const handleSelectionChange = (selection: SelectItem[]) => {
    selectedItems.value = selection
  }

  const handleConfirm = () => {
    emit(
      'confirm',
      selectedItems.value.map((item) => ({
        id: item.id,
        name: props.assigneeType === 1 ? item.name : item.nickname || item.name
      }))
    )
    dialogVisible.value = false
  }
</script>
