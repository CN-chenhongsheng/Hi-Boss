/**
 * 字典管理模拟数据
 */
export const DICTIONARY_TABLE_DATA = [
  {
    dictName: '用户类型',
    dictType: 'sys_user_type',
    status: '1',
    remark: '系统用户类型字典',
    createTime: '2023-05-15 14:30:00'
  },
  {
    dictName: '性别',
    dictType: 'sys_gender',
    status: '1',
    remark: '用户性别字典',
    createTime: '2023-05-16 09:45:00'
  },
  {
    dictName: '状态标志',
    dictType: 'sys_status',
    status: '1',
    remark: '通用状态标志',
    createTime: '2023-05-17 16:20:00'
  },
  {
    dictName: '部门类型',
    dictType: 'sys_dept_type',
    status: '0',
    remark: '系统部门分类',
    createTime: '2023-05-18 11:10:00'
  },
  {
    dictName: '通知类型',
    dictType: 'sys_notice_type',
    status: '1',
    remark: '系统通知类型',
    createTime: '2023-05-19 13:25:00'
  },
  {
    dictName: '菜单类型',
    dictType: 'sys_menu_type',
    status: '1',
    remark: '系统菜单类型',
    createTime: '2023-05-20 10:15:00'
  },
  {
    dictName: '职位等级',
    dictType: 'sys_position_level',
    status: '1',
    remark: '职位等级字典',
    createTime: '2023-05-21 15:30:00'
  },
  {
    dictName: '文件类型',
    dictType: 'sys_file_type',
    status: '1',
    remark: '系统文件类型',
    createTime: '2023-05-22 09:20:00'
  },
  {
    dictName: '日志类型',
    dictType: 'sys_log_type',
    status: '1',
    remark: '系统日志类型',
    createTime: '2023-05-23 14:10:00'
  },
  {
    dictName: '通知渠道',
    dictType: 'sys_notice_channel',
    status: '0',
    remark: '系统通知渠道',
    createTime: '2023-05-24 11:05:00'
  }
]

// 定义字典数据接口
export interface DictionaryItem {
  dictName: string
  dictType: string
  status: number
  remark: string
  createTime: string
}

export const DICTIONARY_DATA: DictionaryItem[] = [
  {
    dictName: '用户类型',
    dictType: 'sys_user_type',
    status: 1,
    remark: '系统用户类型字典',
    createTime: '2023-05-15 14:30:00'
  },
  {
    dictName: '性别',
    dictType: 'sys_gender',
    status: 1,
    remark: '用户性别字典',
    createTime: '2023-05-16 09:45:00'
  },
  {
    dictName: '状态标志',
    dictType: 'sys_status',
    status: 1,
    remark: '通用状态标志',
    createTime: '2023-05-17 16:20:00'
  },
  {
    dictName: '部门类型',
    dictType: 'sys_dept_type',
    status: 0,
    remark: '系统部门分类',
    createTime: '2023-05-18 11:10:00'
  },
  {
    dictName: '通知类型',
    dictType: 'sys_notice_type',
    status: 1,
    remark: '系统通知类型',
    createTime: '2023-05-19 13:25:00'
  }
]
