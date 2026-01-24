/**
 * 宿舍信息相关类型定义
 * @module types/api/dormitory
 */

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
