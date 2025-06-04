import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'

export function useRoleColumns(handleOperation: (type: string, row?: any) => void) {
  // 日期格式化函数
  const formatDate = (date: string) => {
    return new Date(date)
      .toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
      .replace(/\//g, '-')
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { prop: 'name', label: '角色名称' },
    { prop: 'des', label: '描述' },
    {
      prop: 'status',
      label: '状态',
      formatter: (row) => {
        return h(ArtStatusSwitch, {
          modelValue: row.status
        })
      }
    },
    {
      prop: 'date',
      label: '创建时间',
      formatter: (row) => {
        return formatDate(row.date)
      }
    },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row) => {
        return h('div', { class: 'operation-btns' }, [
          h(ArtButtonTable, {
            type: 'detail',
            onClick: () => handleOperation('detail')
          }),
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => handleOperation('edit', row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => handleOperation('delete')
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
