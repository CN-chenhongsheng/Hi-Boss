/**
 * 响应相关类型定义
 */

// 基础接口返回的数据结构
export interface BaseResponse<T = any> {
  // 状态码
  code: number
  // 消息
  msg: string
  // 数据
  data: T
  // 可选字段，用于返回 token
  token?: string
}

// 分页查询参数
export interface PaginationParams {
  // 当前页码
  page: number
  // 每页数量
  pageSize: number
  // 其他查询参数
  [key: string]: any
}

// 分页响应数据结构
export interface PaginationResponse<T> extends BaseResponse {
  // 当前页
  currentPage: number
  // 每页条数
  pageSize: number
  // 总页数
  lastPage: number
  // 总条数
  total: number
  // 数据列表
  data: T[]
}

// 列表响应数据结构
export interface ListResponse<T> extends BaseResponse {
  data: T[]
}

// 详情响应数据结构
export interface DetailResponse<T> extends BaseResponse {
  data: T
}

// 操作响应数据结构（增删改）
export interface OperationResponse extends BaseResponse {
  data: boolean | null
}

// 用户信息响应类型
export interface UserInfoResponse extends BaseResponse {
  // 权限列表
  permissions: string[]
  // 角色列表
  roles: string[]
  // 是否默认修改密码
  isDefaultModifyPwd: boolean
  // 密码是否过期
  isPasswordExpired: boolean
  // 用户详情
  user: UserDetail
}

// 用户详情
export interface UserDetail {
  // 创建者
  createBy: string
  // 创建时间
  createTime: string
  // 更新者
  updateBy: string | null
  // 更新时间
  updateTime: string | null
  // 备注
  remark: string | null
  // 用户ID
  userId: number
  // 部门ID
  deptId: number
  // 用户名
  userName: string
  // 昵称
  nickName: string
  // 邮箱
  email: string
  // 手机号
  phonenumber: string
  // 性别
  sex: string
  // 头像
  avatar: string
  // 密码
  password: string
  // 状态
  status: string
  // 删除标志
  delFlag: string
  // 登录IP
  loginIp: string
  // 登录时间
  loginDate: string
  // 密码更新时间
  pwdUpdateDate: string
  // 部门信息
  dept: DeptInfo
  // 角色列表
  roles: RoleInfo[]
  // 角色ID列表
  roleIds: number[] | null
  // 岗位ID列表
  postIds: number[] | null
  // 角色ID
  roleId: number | null
  // 是否为管理员
  admin: boolean
}

// 部门信息
export interface DeptInfo {
  // 创建者
  createBy: string | null
  // 创建时间
  createTime: string | null
  // 更新者
  updateBy: string | null
  // 更新时间
  updateTime: string | null
  // 备注
  remark: string | null
  // 部门ID
  deptId: number
  // 父部门ID
  parentId: number
  // 祖级列表
  ancestors: string
  // 部门名称
  deptName: string
  // 显示顺序
  orderNum: number
  // 负责人
  leader: string
  // 联系电话
  phone: string | null
  // 邮箱
  email: string | null
  // 部门状态
  status: string
  // 删除标志
  delFlag: string | null
  // 父部门名称
  parentName: string | null
  // 子部门
  children: DeptInfo[]
}

// 角色信息
export interface RoleInfo {
  // 创建者
  createBy: string | null
  // 创建时间
  createTime: string | null
  // 更新者
  updateBy: string | null
  // 更新时间
  updateTime: string | null
  // 备注
  remark: string | null
  // 角色ID
  roleId: number
  // 角色名称
  roleName: string
  // 角色权限字符串
  roleKey: string
  // 显示顺序
  roleSort: number
  // 数据范围
  dataScope: string
  // 菜单树选择项是否关联显示
  menuCheckStrictly: boolean
  // 部门树选择项是否关联显示
  deptCheckStrictly: boolean
  // 角色状态
  status: string
  // 删除标志
  delFlag: string | null
  // 标志
  flag: boolean
  // 菜单ID列表
  menuIds: number[] | null
  // 部门ID列表
  deptIds: number[] | null
  // 权限列表
  permissions: string[] | null
  // 是否为管理员
  admin: boolean
}
