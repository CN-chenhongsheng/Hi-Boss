/**
 * 宿舍信息相关API
 * @module api/dormitory
 */

import { get } from '@/utils/request';

/**
 * 宿舍信息
 */
export interface IDormInfo {
  campusName: string;
  buildingName: string;
  floorName: string;
  roomCode: string;
  bedCode: string;
  checkInDate: string;
}

/**
 * 室友信息
 */
export interface IRoommate {
  id: number;
  studentNo: string;
  studentName: string;
  avatar?: string;
  phone?: string;
  bedCode?: string;
}

/**
 * 获取当前学生宿舍信息
 */
export function getDormInfoAPI() {
  return get<IDormInfo>({
    url: '/api/v1/student/dorm-info',
  });
}

/**
 * 获取室友列表
 */
export function getRoommatesAPI() {
  return get<IRoommate[]>({
    url: '/api/v1/student/roommates',
  });
}
