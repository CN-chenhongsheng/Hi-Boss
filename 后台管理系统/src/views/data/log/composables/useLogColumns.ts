import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import type { LogItem } from './useLogData'

export function useLogColumns(handleOperation: (type: string, row?: any) => void) {
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    { prop: 'username', label: '用户名', minWidth: 100 },
    { prop: 'account', label: '账号', minWidth: 100 },
    { prop: 'operationType', label: '类型', minWidth: 100 },
    { prop: 'content', label: '内容', minWidth: 180 },
    { prop: 'result', label: '结果', minWidth: 100 },
    { prop: 'ip', label: 'IP', minWidth: 120 },
    { prop: 'browser', label: '浏览器', minWidth: 100 },
    { prop: 'status', label: '请求耗时', minWidth: 90 },
    { prop: 'create_time', label: '时间', minWidth: 150 },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row: LogItem) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'detail',
            onClick: () => handleOperation('detail', row)
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
