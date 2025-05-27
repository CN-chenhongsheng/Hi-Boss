import { h } from 'vue'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'

export function useDictionaryColumns(handleOperation: (type: string, row?: any) => void) {
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
    {
      prop: 'operation',
      label: '操作',
      width: 180,
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
    }
  ])

  return {
    columnChecks,
    columns
  }
}

// 字典数据列表表格列配置
export function useDictDataColumns(handleOperation: (type: string, row?: any) => void) {
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
    {
      prop: 'operation',
      label: '操作',
      width: 150,
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
    }
  ])

  return {
    columnChecks,
    columns
  }
}
