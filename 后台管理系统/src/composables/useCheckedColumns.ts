// 动态列配置
import { useTableStore } from '@/store/modules/table'
import { TableMaxWidthEnum, TableMinWidthEnum, TableSizeMap } from '@/enums/formEnum'

// 定义列配置接口
export interface ColumnOption {
  type?: 'selection' | 'expand' | 'index'
  prop?: string
  label?: string
  width?: number
  minWidth?: number
  fixed?: boolean | 'left' | 'right'
  sortable?: boolean
  disabled?: boolean
  formatter?: (row: any) => any
  [key: string]: any
}

// 定义列选择状态接口
export interface ColumnCheck {
  prop: string
  label: string
  checked: boolean
}

// 特殊列类型常量
const SELECTION_KEY = '__selection__'
const EXPAND_KEY = '__expand__'
const INDEX_KEY = '__index__'

// 获取表格大小设置
const tableStore = useTableStore()
const tableSize = computed(() => tableStore.tableSize)

// 工具函数：根据列配置生成列选择状态
const getColumnChecks = (columns: ColumnOption[]): ColumnCheck[] => {
  const checks: ColumnCheck[] = []

  columns.forEach((column) => {
    if (column.type === 'selection') {
      checks.push({
        prop: SELECTION_KEY,
        label: '勾选',
        checked: true
      })
    } else if (column.type === 'expand') {
      checks.push({
        prop: EXPAND_KEY,
        label: '展开',
        checked: true
      })
    } else if (column.type === 'index') {
      checks.push({
        prop: INDEX_KEY,
        label: '序号',
        checked: true
      })
    } else {
      checks.push({
        prop: column.prop as string,
        label: column.label as string,
        checked: true
      })
    }
  })

  return checks
}

export function useCheckedColumns(columnsFactory: () => ColumnOption[]) {
  // 获取所有列定义
  const allColumns = columnsFactory()

  // 列选中状态，初始包含所有普通列和特殊类型列
  const columnChecks = ref<ColumnCheck[]>(getColumnChecks(allColumns))

  // 当前显示的列
  const columns = computed(() => {
    const columnMap = new Map<string, ColumnOption>()

    allColumns.forEach((column) => {
      // 使用映射关系确定列的键
      let key = column.prop as string
      if (column.type) {
        const typeKeyMap: Record<string, string> = {
          selection: SELECTION_KEY,
          expand: EXPAND_KEY,
          index: INDEX_KEY
        }
        key = typeKeyMap[column.type] || key
      }

      if (column.prop === 'operation') {
        const num = (column as any).formatter()?.children?.length
        // 根据operation列的实际情况设置适当的宽度
        columnMap.set(key, {
          ...column,
          align: 'center',
          width: TableSizeMap[tableSize.value][num] as number,
          minWidth: TableMinWidthEnum[tableSize.value] as number,
          maxWidth: TableMaxWidthEnum[tableSize.value] as number
        })
      } else {
        columnMap.set(key, column)
      }
    })

    return columnChecks.value
      .filter((item) => item.checked)
      .map((check) => columnMap.get(check.prop) as ColumnOption)
  })

  return {
    columns,
    columnChecks
  }
}
