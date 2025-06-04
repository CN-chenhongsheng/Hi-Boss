import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import { RecycleItem } from '../components/RecycleDetail.vue'

export function useRecycleColumns(
  onDetail: (row: RecycleItem) => void,
  onRecover: (row: RecycleItem) => void,
  onDelete: (row: RecycleItem) => void
) {
  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    { prop: 'operator', label: '操作人', minWidth: 100 },
    {
      prop: 'deletedData',
      label: '被删除的数据',
      minWidth: 150,
      formatter: (row: RecycleItem) => {
        // 显示删除数据的概要信息
        const data =
          typeof row.deletedData === 'string' ? JSON.parse(row.deletedData) : row.deletedData

        if (Array.isArray(data)) {
          return `[数组] ${data.length}条记录`
        } else if (typeof data === 'object') {
          const keys = Object.keys(data).slice(0, 2)
          return `{对象} ${keys.join(', ')}${keys.length < Object.keys(data).length ? '...' : ''}`
        }
        return String(data).substring(0, 30) + (String(data).length > 30 ? '...' : '')
      }
    },
    { prop: 'api', label: '请求的接口', minWidth: 150 },
    {
      prop: 'params',
      label: '请求的参数',
      minWidth: 150,
      formatter: (row: RecycleItem) => {
        const params = typeof row.params === 'string' ? JSON.parse(row.params) : row.params

        const str = JSON.stringify(params)
        return str.substring(0, 30) + (str.length > 30 ? '...' : '')
      }
    },
    { prop: 'deleteCount', label: '删除条数', width: 100 },
    { prop: 'operateTime', label: '操作时间', minWidth: 180 },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row: RecycleItem) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'detail',
            onClick: () => onDetail(row)
          }),
          h(ArtButtonTable, {
            type: 'restore',
            onClick: () => onRecover(row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => onDelete(row)
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
