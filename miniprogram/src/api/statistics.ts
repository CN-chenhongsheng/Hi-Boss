/**
 * 统计数据API
 * @module api/statistics
 */

import { get } from '@/utils/request';
import type {
  IStudentHomeStatistics,
} from '@/types';

/**
 * 获取学生端首页统计数据
 */
export function getStudentHomeStatisticsAPI() {
  return get<IStudentHomeStatistics>({
    url: '/api/v1/statistics/student-home',
  });
}
