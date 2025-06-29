// 查询参数类型
export interface DictTypeQuery {
  pageNum: number
  pageSize: number
  dictName?: string
  dictType?: string
  status?: string
}

// 字典类型数据结构
export interface DictTypeItem {
  dictId: number
  dictName: string
  dictType: string
  status: number | string
  createBy?: string
  createTime?: string
  updateBy?: string
  updateTime?: string
  remark?: string
}

// 分页响应数据结构
export interface DictTypeResponse {
  total: number
  rows: DictTypeItem[]
  code: number
  msg: string
}

// 字典数据查询参数
export interface DictDataQuery {
  pageNum: number
  pageSize: number
  dictType: string
}

// 字典数据项结构
export interface DictDataItem {
  dictCode: number
  dictSort: number
  dictLabel: string
  dictValue: string
  dictType: string
  cssClass?: string
  listClass?: string
  isDefault?: string
  status: string | number
  createBy?: string
  createTime?: string
  updateBy?: string
  updateTime?: string
  remark?: string
  default?: boolean
}

// 字典数据响应结构
export interface DictDataResponse {
  total: number
  rows: DictDataItem[]
  code: number
  msg: string
}
