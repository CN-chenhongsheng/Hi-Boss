/**
 * 报修管理模块 API
 * 包含报修工单管理、接单、完成等接口
 *
 * @module api/repair-manage
 * @date 2026-01-29
 */

import request from '@/utils/http'

/** ==================== 报修工单管理 ==================== */

/**
 * 获取报修分页列表
 * @param params 查询参数
 */
export function fetchGetRepairPage(params: Api.RepairManage.RepairSearchParams) {
  return request.get<Api.RepairManage.RepairPageResponse>({
    url: '/api/v1/system/repair/page',
    params
  })
}

/**
 * 获取报修详情
 * @param id 报修ID
 */
export function fetchGetRepairDetail(id: number) {
  return request.get<Api.RepairManage.RepairListItem>({
    url: `/api/v1/system/repair/${id}`
  })
}

/**
 * 新增报修
 * @param data 报修数据
 */
export function fetchAddRepair(data: Api.RepairManage.RepairSaveParams) {
  return request.post({
    url: '/api/v1/system/repair',
    data,
    showSuccessMessage: true
  })
}

/**
 * 更新报修
 * @param data 报修数据
 */
export function fetchUpdateRepair(data: Api.RepairManage.RepairSaveParams) {
  return request.put({
    url: '/api/v1/system/repair',
    data,
    showSuccessMessage: true
  })
}

/**
 * 删除报修
 * @param id 报修ID
 */
export function fetchDeleteRepair(id: number) {
  return request.del({
    url: `/api/v1/system/repair/${id}`,
    showSuccessMessage: true
  })
}

/**
 * 批量删除报修
 * @param ids 报修ID数组
 */
export function fetchBatchDeleteRepair(ids: number[]) {
  return request.del({
    url: '/api/v1/system/repair/batch',
    data: ids,
    showSuccessMessage: true
  })
}

/** ==================== 报修操作 ==================== */

/**
 * 接单
 * @param id 报修ID
 */
export function fetchAcceptRepair(id: number) {
  return request.post({
    url: `/api/v1/system/repair/${id}/accept`,
    showSuccessMessage: true
  })
}

/**
 * 完成维修
 * @param id 报修ID
 * @param data 完成维修数据
 */
export function fetchCompleteRepair(id: number, data: Api.RepairManage.CompleteRepairParams) {
  return request.post({
    url: `/api/v1/system/repair/${id}/complete`,
    data,
    showSuccessMessage: true
  })
}
