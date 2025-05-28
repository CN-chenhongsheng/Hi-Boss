import { useCheckedColumns } from '@/composables/useCheckedColumns'
import { formatMenuTitle } from '@/utils/menu'
import { MenuListType } from '@/types/menu'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'

export function useMenuColumns(handleOperation: (type: string, row?: any, lock?: boolean) => void) {
  // 构建菜单类型标签
  const buildMenuTypeTag = (row: MenuListType) => {
    if (row.children && row.children.length > 0) {
      return 'info'
    } else if (row.meta?.link && row.meta?.isIframe) {
      return 'success'
    } else if (row.path) {
      return 'primary'
    } else if (row.meta?.link) {
      return 'warning'
    }
  }

  // 构建菜单类型文本
  const buildMenuTypeText = (row: MenuListType) => {
    if (row.children && row.children.length > 0) {
      return '目录'
    } else if (row.meta?.link && row.meta?.isIframe) {
      return '内嵌'
    } else if (row.path) {
      return '菜单'
    } else if (row.meta?.link) {
      return '外链'
    }
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    {
      prop: 'meta.title',
      label: '菜单名称',
      minWidth: 120,
      formatter: (row: MenuListType) => {
        return formatMenuTitle(row.meta?.title)
      }
    },
    {
      prop: 'type',
      label: '菜单类型',
      formatter: (row: MenuListType) => {
        return h(ElTag, { type: buildMenuTypeTag(row) }, () => buildMenuTypeText(row))
      }
    },
    {
      prop: 'path',
      label: '路由',
      formatter: (row: MenuListType) => {
        return row.meta?.link || row.path || ''
      }
    },
    {
      prop: 'meta.authList',
      label: '可操作权限',
      formatter: (row: MenuListType) => {
        return h(
          'div',
          {},
          row.meta?.authList?.map((item: MenuListType['meta'], index: number) => {
            return h(
              ElPopover,
              {
                placement: 'top-start',
                title: '操作',
                width: 200,
                trigger: 'click',
                key: index
              },
              {
                default: () =>
                  h('div', { style: 'margin: 0; text-align: right' }, [
                    h(
                      ElButton,
                      {
                        size: 'small',
                        type: 'primary',
                        onClick: () => handleOperation('button', item)
                      },
                      { default: () => '编辑' }
                    ),
                    h(
                      ElButton,
                      {
                        size: 'small',
                        type: 'danger',
                        onClick: () => handleOperation('deleteAuth')
                      },
                      { default: () => '删除' }
                    )
                  ]),
                reference: () => h(ElButton, { class: 'small-btn' }, { default: () => item.title })
              }
            )
          })
        )
      }
    },
    {
      prop: 'date',
      label: '编辑时间',
      formatter: () => '2022-3-12 12:00:00'
    },
    {
      prop: 'status',
      label: '隐藏菜单',
      formatter: (row) => {
        return h(ArtStatusSwitch, {
          modelValue: row.meta?.isHidden || false,
          activeValue: true,
          inactiveValue: false,
          needConfirm: true
        })
      }
    },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row: MenuListType) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'add',
            'v-auth': "'add'",
            onClick: () => handleOperation('menu')
          }),
          h(ArtButtonTable, {
            type: 'edit',
            'v-auth': "'edit'",
            onClick: () => handleOperation('menu', row, true)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            'v-auth': "'delete'",
            onClick: () => handleOperation('deleteMenu')
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
