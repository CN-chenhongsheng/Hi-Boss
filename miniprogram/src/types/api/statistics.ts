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

/**
 * 工作台统计数据（管理端）
 */
export interface IAdminDashboardStatistics {
  /** 待审批申请数 */
  pendingApprovalCount: number;
  /** 今日新增申请数 */
  todayApplyCount: number;
  /** 待处理报修数 */
  pendingRepairCount: number;
  /** 今日已处理数 */
  todayHandledCount: number;
  /** 宿舍入住率 */
  occupancyRate: number;
  /** 总床位数 */
  totalBeds: number;
  /** 已入住床位数 */
  occupiedBeds: number;
  /** 预警信息 */
  warnings?: IWarningItem[];
}

/**
 * 预警信息项
 */
export interface IWarningItem {
  /** 预警类型 */
  type: 'repair' | 'apply' | 'safety' | 'other';
  /** 预警标题 */
  title: string;
  /** 预警内容 */
  content: string;
  /** 预警级别 */
  level: 'info' | 'warning' | 'error';
  /** 创建时间 */
  createTime: string;
}

/**
 * 申请趋势数据
 */
export interface IApplyTrendData {
  /** 日期 */
  date: string;
  /** 入住申请数 */
  checkInCount: number;
  /** 调宿申请数 */
  transferCount: number;
  /** 退宿申请数 */
  checkOutCount: number;
  /** 留宿申请数 */
  stayCount: number;
}

/**
 * 申请类型占比数据
 */
export interface IApplyTypeRatioData {
  /** 申请类型 */
  type: 'checkIn' | 'transfer' | 'checkOut' | 'stay';
  /** 类型名称 */
  typeName: string;
  /** 数量 */
  count: number;
  /** 占比 */
  ratio: number;
}

/**
 * 楼栋入住统计数据
 */
export interface IFloorOccupancyData {
  /** 楼栋编码 */
  floorCode: string;
  /** 楼栋名称 */
  floorName: string;
  /** 总床位数 */
  totalBeds: number;
  /** 已入住床位数 */
  occupiedBeds: number;
  /** 入住率 */
  occupancyRate: number;
}

/**
 * 报修类型统计数据
 */
export interface IRepairTypeStatistics {
  /** 报修类型 */
  type: number;
  /** 类型名称 */
  typeName: string;
  /** 数量 */
  count: number;
  /** 占比 */
  ratio: number;
}

/**
 * 综合统计数据
 */
export interface IComprehensiveStatistics {
  /** 申请趋势数据（近30天） */
  applyTrend: IApplyTrendData[];
  /** 申请类型占比 */
  applyTypeRatio: IApplyTypeRatioData[];
  /** 楼栋入住统计 */
  floorOccupancy: IFloorOccupancyData[];
  /** 报修类型统计 */
  repairTypeStatistics: IRepairTypeStatistics[];
}

/**
 * 统计查询参数
 */
export interface IStatisticsQueryParams {
  /** 开始日期 */
  startDate?: string;
  /** 结束日期 */
  endDate?: string;
  /** 楼层编码（宿管员筛选） */
  floorCode?: string;
  /** 校区编码 */
  campusCode?: string;
}
