/**
 * 审批相关API
 * @module api/approval
 */

import { get, post } from '@/utils/request';

/**
 * 审批实例
 */
export interface IApprovalInstance {
  id: number;
  flowId: number;
  flowName: string;
  businessType: string;
  businessTypeText?: string;
  businessId: number;
  applicantId: number;
  applicantName: string;
  currentNodeId?: number;
  currentNodeName?: string;
  status: number;
  statusText?: string;
  startTime?: string;
  endTime?: string;
  nodes?: IApprovalNode[];
  records?: IApprovalRecord[];
}

/**
 * 审批节点
 */
export interface IApprovalNode {
  id: number;
  flowId: number;
  nodeName: string;
  nodeOrder: number;
  nodeType: number;
  nodeTypeText?: string;
  rejectAction: number;
  rejectActionText?: string;
  assignees?: IApprovalAssignee[];
}

/**
 * 审批人
 */
export interface IApprovalAssignee {
  id: number;
  nodeId: number;
  assigneeType: number;
  assigneeId: number;
  assigneeName?: string;
}

/**
 * 审批记录
 */
export interface IApprovalRecord {
  id: number;
  instanceId: number;
  nodeId: number;
  nodeName: string;
  approverId: number;
  approverName: string;
  action: number;
  actionText?: string;
  opinion?: string;
  approveTime: string;
}

/**
 * 根据业务查询审批实例
 */
export function getApprovalInstanceByBusinessAPI(businessType: string, businessId: number) {
  return get<IApprovalInstance>({
    url: `/api/v1/system/approval/instance/business/${businessType}/${businessId}`,
  });
}

/**
 * 获取审批实例详情
 */
export function getApprovalInstanceDetailAPI(id: number) {
  return get<IApprovalInstance>({
    url: `/api/v1/system/approval/instance/${id}`,
  });
}

/**
 * 获取审批实例的审批记录
 */
export function getApprovalRecordsByInstanceAPI(instanceId: number) {
  return get<IApprovalRecord[]>({
    url: `/api/v1/system/approval/record/instance/${instanceId}`,
  });
}
