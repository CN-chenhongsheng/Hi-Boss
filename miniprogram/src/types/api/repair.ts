/**
 * 报修类型定义
 * @module types/api/repair
 */

import type { IBaseEntity, IPageParams, IPageResult } from './common';

/**
 * 报修类型枚举
 */
export enum RepairType {
  /** 水电 */
  WATER_ELECTRICITY = 1,
  /** 门窗 */
  DOOR_WINDOW = 2,
  /** 家具 */
  FURNITURE = 3,
  /** 网络 */
  NETWORK = 4,
  /** 其他 */
  OTHER = 99,
}

/**
 * 报修类型文本映射
 */
export const RepairTypeText: Record<RepairType, string> = {
  [RepairType.WATER_ELECTRICITY]: '水电',
  [RepairType.DOOR_WINDOW]: '门窗',
  [RepairType.FURNITURE]: '家具',
  [RepairType.NETWORK]: '网络',
  [RepairType.OTHER]: '其他',
};

/**
 * 报修状态枚举
 */
export enum RepairStatus {
  /** 待处理 */
  PENDING = 1,
  /** 处理中 */
  PROCESSING = 2,
  /** 已完成 */
  COMPLETED = 3,
  /** 已取消 */
  CANCELLED = 4,
}

/**
 * 报修状态文本映射
 */
export const RepairStatusText: Record<RepairStatus, string> = {
  [RepairStatus.PENDING]: '待处理',
  [RepairStatus.PROCESSING]: '处理中',
  [RepairStatus.COMPLETED]: '已完成',
  [RepairStatus.CANCELLED]: '已取消',
};

/**
 * 报修信息
 */
export interface IRepair extends IBaseEntity {
  /** 学生ID */
  studentId: number;
  /** 学生姓名 */
  studentName?: string;
  /** 学号 */
  studentNo?: string;
  /** 联系电话 */
  phone?: string;
  /** 校区编码 */
  campusCode?: string;
  /** 楼层编码 */
  floorCode?: string;
  /** 房间ID */
  roomId?: number;
  /** 房间编码 */
  roomCode?: string;
  /** 报修类型 */
  repairType: RepairType;
  /** 报修描述 */
  description: string;
  /** 故障图片 */
  images?: string[];
  /** 状态 */
  status: RepairStatus;
  /** 处理人ID */
  handlerId?: number;
  /** 处理人姓名 */
  handlerName?: string;
  /** 处理时间 */
  handleTime?: string;
  /** 完成时间 */
  completeTime?: string;
  /** 处理结果 */
  handleResult?: string;
  /** 满意度评分 1-5 */
  rating?: number;
  /** 评价内容 */
  comment?: string;
  /** 备注 */
  remark?: string;
}

/**
 * 报修查询参数
 */
export interface IRepairQueryParams extends IPageParams {
  /** 学生ID */
  studentId?: number;
  /** 学号 */
  studentNo?: string;
  /** 学生姓名 */
  studentName?: string;
  /** 报修类型 */
  repairType?: RepairType;
  /** 楼层编码 */
  floorCode?: string;
  /** 状态 */
  status?: RepairStatus;
  /** 创建时间开始 */
  createTimeStart?: string;
  /** 创建时间结束 */
  createTimeEnd?: string;
}

/**
 * 报修提交参数
 */
export interface IRepairSubmitParams {
  /** 报修类型 */
  repairType: RepairType;
  /** 报修描述 */
  description: string;
  /** 故障图片 */
  images?: string[];
  /** 联系电话 */
  phone?: string;
}

/**
 * 报修处理参数
 */
export interface IRepairHandleParams {
  /** 报修ID */
  id: number;
  /** 状态 2=处理中 3=已完成 */
  status: 2 | 3;
  /** 处理结果 */
  handleResult?: string;
}

/**
 * 报修评价参数
 */
export interface IRepairRatingParams {
  /** 报修ID */
  id: number;
  /** 满意度评分 1-5 */
  rating: number;
  /** 评价内容 */
  comment?: string;
}

/**
 * 报修分页响应
 */
export type IRepairPageResult = IPageResult<IRepair>;
