import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import { useTableStore } from '@/store/modules/table'
import { TableWidthEnum } from '@/enums/formEnum'
import { ref, computed, watch } from 'vue'

// 获取表格大小设置
const tableStore = useTableStore()
const tableSize = computed(() => tableStore.tableSize)
const width = ref<number>(TableWidthEnum[tableSize.value])
// TODO: 监听表格大小变化，并更新宽度(未完成)
watch(
  tableSize,
  (newSize) => {
    width.value = TableWidthEnum[newSize]
  }
)

export function useDictionaryColumns(handleOperation: (type: string, row?: any) => void) {
  // 将操作列定义为计算属性
  const operationColumn = computed(() => ({
    prop: 'operation',
    label: '操作',
    width: width.value,
    formatter: (row: any) => {
      return h('div', [
        h(ArtButtonTable, {
          type: 'detail',
          onClick: () => handleOperation('detail', row)
        }),
        h(ArtButtonTable, {
          type: 'edit',
          onClick: () => handleOperation('edit', row)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          onClick: () => handleOperation('delete', row)
        })
      ])
    }
  }))

  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    { prop: 'dictName', label: '字典名称', minWidth: 150 },
    { prop: 'dictType', label: '字典类型', minWidth: 150 },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: any) => {
        return h(ArtStatusSwitch, {
          modelValue: row.status
        })
      }
    },
    { prop: 'remark', label: '备注', minWidth: 180 },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      minWidth: 180
    },
    operationColumn.value // 使用计算属性的值
  ])

  return {
    columnChecks,
    columns
  }
}

// 字典数据列表表格列配置
export function useDictDataColumns(handleOperation: (type: string, row?: any) => void) {
  // 为这个函数也添加响应式操作列
  const operationColumn = computed(() => ({
    prop: 'operation',
    label: '操作',
    width: width.value,
    formatter: (row: any) => {
      return h('div', { class: 'operation-btns' }, [
        h(ArtButtonTable, {
          type: 'edit',
          onClick: () => handleOperation('edit', row)
        }),
        h(ArtButtonTable, {
          type: 'delete',
          onClick: () => handleOperation('delete', row)
        })
      ])
    }
  }))

  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection', width: 55 },
    { prop: 'code', label: '字典编码', width: 150 },
    { prop: 'name', label: '字典名称', width: 150 },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: any) => {
        return h(ArtStatusSwitch, {
          modelValue: row.status
        })
      }
    },
    { prop: 'createTime', label: '创建时间', sortable: true, width: 180 },
    { prop: 'remark', label: '备注' },
    operationColumn.value // 使用计算属性的值
  ])

  return {
    columnChecks,
    columns
  }
}
