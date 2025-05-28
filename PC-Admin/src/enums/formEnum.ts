// 表单枚举

// 页面类型
export enum PageModeEnum {
  Add, // 新增
  Edit // 编辑
}

// 表格大小
export enum TableSizeEnum {
  DEFAULT = 'default',
  SMALL = 'small',
  LARGE = 'large'
}

// 表格最大宽度
export enum TableMaxWidthEnum {
  default = 180,
  small = 160,
  large = 280
}

// 表格最小宽度
export enum TableMinWidthEnum {
  default = 100,
  small = 80,
  large = 140
}

// 表格最小尺寸
export const TableSmallEnum: Record<number, number> = {
  1: 80,
  2: 100,
  3: 140
}

// 表格默认尺寸
export const TableDefaultEnum: Record<number, number> = {
  1: 100,
  2: 140,
  3: 180
}

// 表格大尺寸
export const TableLargeEnum: Record<number, number> = {
  1: 130,
  2: 200,
  3: 280
}

export const TableSizeMap: Record<string, Record<number, number>> = {
  default: TableDefaultEnum,
  small: TableSmallEnum,
  large: TableLargeEnum
}
