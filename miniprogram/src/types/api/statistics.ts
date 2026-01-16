/**
 * 统计数据类型定义
 * @module types/api/statistics
 */

/**
 * 首页统计数据（学生端）
 */
export interface IStudentHomeStatistics {
  /** 待审核申请数 */
  pendingApplyCount: number;
  /** 待处理报修数 */
  pendingRepairCount: number;
  /** 未读通知数 */
  unreadNoticeCount: number;
  /** 我的宿舍信息 */
  dormInfo?: {
    /** 校区名称 */
    campusName?: string;
    /** 楼栋名称 */
    floorName?: string;
    /** 房间号 */
    roomCode?: string;
    /** 床位号 */
    bedCode?: string;
  };
}
