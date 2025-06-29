import request from '@/utils/http'
import { DictTypeQuery, DictTypeResponse, DictDataQuery, DictDataResponse } from './model'

// 获取字典类型列表
export function getDictTypeList(query: DictTypeQuery) {
  return request.get<DictTypeResponse>({
    url: '/system/dict/type/list',
    params: query
  })
}

// 新增字典类型
export function addDictType(data: any) {
  return request.post({
    url: '/system/dict/type',
    data
  })
}

// 修改字典类型
export function updateDictType(data: any) {
  return request.put({
    url: '/system/dict/type',
    data
  })
}

// 删除字典类型（支持单个和批量）
export function deleteDictType(ids: string) {
  return request.del({
    url: `/system/dict/type/${ids}`
  })
}

// 获取字典数据列表
export function getDictDataList(query: DictDataQuery) {
  return request.get<DictDataResponse>({
    url: '/system/dict/data/list',
    params: query
  })
}

// 添加字典数据
export function addDictData(data: any) {
  return request.post({
    url: '/system/dict/data',
    data
  })
}

// 修改字典数据
export function updateDictData(data: any) {
  return request.put({
    url: '/system/dict/data',
    data
  })
}

// 删除字典数据（支持单个和批量）
export function deleteDictData(ids: string) {
  return request.del({
    url: `/system/dict/data/${ids}`
  })
}
