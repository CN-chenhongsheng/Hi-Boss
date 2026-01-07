/**
 * API统一导出
 * @module api
 */

// 认证授权
export * from './auth';

// 用户
export * from './user';

// 申请相关
export * from './accommodation/check-in';
export * from './accommodation/transfer';
export * from './accommodation/check-out';
export * from './accommodation/stay';

// 服务相关
export * from './service/repair';
export * from './service/notice';

// 统计
export * from './statistics';
