/**
 * 统计数据API
 * @module api/statistics
 */

import { get } from '@/utils/request';
import type {
  IAdminDashboardStatistics,
  IComprehensiveStatistics,
  IStatisticsQueryParams,
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

/**
 * 获取管理端工作台统计数据
 */
export function getAdminDashboardStatisticsAPI() {
  return get<IAdminDashboardStatistics>({
    url: '/api/v1/statistics/admin-dashboard',
  });
}

/**
 * 获取综合统计数据
 */
export function getComprehensiveStatisticsAPI(params?: IStatisticsQueryParams) {
  return get<IComprehensiveStatistics>({
    url: '/api/v1/statistics/comprehensive',
    data: params,
  });
}
