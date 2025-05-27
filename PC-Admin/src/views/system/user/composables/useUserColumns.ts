import { h } from 'vue'
import { ElTag } from 'element-plus'
import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'

export function useUserColumns(handleOperation: (type: string, row?: any) => void) {
  // 获取标签类型
  // 1: 在线 2: 离线 3: 异常 4: 注销
  const getTagType = (status: string) => {
    switch (status) {
      case '1':
        return 'success'
      case '2':
        return 'info'
      case '3':
        return 'warning'
      case '4':
        return 'danger'
      default:
        return 'info'
    }
  }

  // 构建标签文本
  const buildTagText = (status: string) => {
    let text = ''
    if (status === '1') {
      text = '在线'
    } else if (status === '2') {
      text = '离线'
    } else if (status === '3') {
      text = '异常'
    } else if (status === '4') {
      text = '注销'
    }
    return text
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    {
      prop: 'avatar',
      label: '用户名',
      minWidth: 220,
      formatter: (row: any) => {
        return h('div', { class: 'user', style: 'display: flex; align-items: center' }, [
          h('img', { class: 'avatar', src: row.avatar }),
          h('div', {}, [
            h('p', { class: 'user-name' }, row.username),
            h('p', { class: 'email' }, row.email)
          ])
        ])
      }
    },
    { prop: 'mobile', label: '手机号' },
    {
      prop: 'sex',
      label: '性别',
      sortable: true,
      formatter: (row) => (row.sex === 1 ? '男' : '女')
    },
    { prop: 'dep', label: '部门' },
    {
      prop: 'status',
      label: '状态',
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => buildTagText(row.status))
      }
    },
    {
      prop: 'create_time',
      label: '创建日期',
      sortable: true
    },
    {
      prop: 'operation',
      label: '操作',
      width: 150,
      formatter: (row: any) => {
        return h('div', [
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