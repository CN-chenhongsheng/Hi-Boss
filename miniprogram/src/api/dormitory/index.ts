/**
 * 宿舍信息相关API
 * @module api/dormitory
 */

import { get } from '@/utils/request';
import type {
  IDormInfo,
  IRoommate,
} from '@/types/api';

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
