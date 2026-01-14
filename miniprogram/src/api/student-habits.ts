/**
 * 学生生活习惯相关API
 */
import request from '@/utils/request';
import type { IStudentHabitsForm } from '@/types/api/student-habits';

/**
 * 获取学生生活习惯信息
 */
export function getStudentHabits() {
  return request({
    url: '/api/student/habits',
    method: 'GET',
  });
}

/**
 * 更新学生生活习惯信息
 * @param data 学生生活习惯表单数据
 */
export function updateStudentHabits(data: IStudentHabitsForm) {
  return request({
    url: '/api/student/habits',
    method: 'PUT',
    data,
  });
}

/**
 * 检查学生是否已填写生活习惯
 */
export function checkHabitsStatus() {
  return request({
    url: '/api/student/habits/status',
    method: 'GET',
  });
}
