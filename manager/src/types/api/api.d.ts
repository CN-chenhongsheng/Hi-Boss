/**
 * API 接口类型定义模块
 *
 * 提供所有后端接口的类型定义
 *
 * ## 主要功能
 *
 * - 通用类型（分页参数、响应结构等）
 * - 认证类型（登录、用户信息等）
 * - 系统管理类型（用户、角色等）
 * - 全局命名空间声明
 *
 * ## 使用场景
 *
 * - API 请求参数类型约束
 * - API 响应数据类型定义
 * - 接口文档类型同步
 *
 * ## 注意事项
 *
 * - 在 .vue 文件使用需要在 eslint.config.mjs 中配置 globals: { Api: 'readonly' }
 * - 使用全局命名空间，无需导入即可使用
 *
 * ## 使用方式
 *
 * ```typescript
 * const params: Api.Auth.LoginParams = { userName: 'admin', password: '123456' }
 * const response: Api.Auth.UserInfo = await fetchUserInfo()
 * ```
 *
 * @module types/api/api
 * @author HongSheng_Chen Team
 */

declare namespace Api {
  /** 通用类型 */
  namespace Common {
    /** 分页参数 */
    interface PaginationParams {
      /** 当前页码 */
      current: number
      /** 每页条数 */
      size: number
      /** 总条数 */
      total: number
    }

    /** 通用搜索参数 */
    type CommonSearchParams = Pick<PaginationParams, 'current' | 'size'>

    /** 分页响应基础结构 */
    interface PaginatedResponse<T = any> {
      records: T[]
      current: number
      size: number
      total: number
    }

    /** 启用状态 */
    type EnableStatus = '1' | '2'
  }

  /** 认证类型 */
  namespace Auth {
    /** 登录参数 */
    interface LoginParams {
      username: string
      password: string
    }

    /** 登录响应 */
    interface LoginResponse {
      token: string
      userId: number
      username: string
      nickname: string
      avatar?: string
    }

    /** 用户信息 */
    interface UserInfo {
      userId: number
      username: string
      nickname: string
      avatar?: string
      email?: string
      phone?: string
      manageScope?: string
      roles: string[]
      permissions: string[]
    }

    /** 用户个人信息（详细） */
    interface UserProfile {
      id: number
      username: string
      nickname: string
      avatar?: string
      email?: string
      phone?: string
      manageScope?: string
      status: number
      statusText?: string
      gender?: number
      genderText?: string
      address?: string
      introduction?: string
      cpUserId?: string
      openid?: string
      roleIds?: number[]
      roleNames?: string[]
      createTime?: string
      updateTime?: string
      lastLoginTime?: string
      isOnline?: boolean
    }

    /** 用户简单信息 */
    interface UserSimpleItem {
      id: number
      username: string
      nickname: string
      phone?: string
      email?: string
    }

    /** 角色用户查询参数 */
    interface RoleUserQueryParams {
      roleCodes: string[]
    }

    /** 角色用户信息（Map格式，key为角色代码，value为用户列表） */
    type RoleUserMap = Record<string, UserSimpleItem[]>

    /** 更新个人信息参数 */
    interface UserProfileUpdateParams {
      nickname?: string
      avatar?: string
      email?: string
      phone?: string
      gender?: number
      address?: string
      introduction?: string
    }

    /** 修改密码参数 */
    interface ChangePasswordParams {
      oldPassword: string
      newPassword: string
      confirmPassword: string
    }
  }

  /** 系统管理类型 */
  namespace SystemManage {
    /** ==================== 用户管理 ==================== */
    /** 用户查询参数 */
    interface UserSearchParams {
      username?: string
      nickname?: string
      phone?: string
      manageScope?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 用户保存参数 */
    interface UserSaveParams {
      id?: number
      username: string
      password?: string
      nickname: string
      avatar?: string
      email?: string
      phone?: string
      gender?: number
      manageScope?: string
      status?: number
      roleIds?: number[]
    }

    /** 用户重置密码参数 */
    interface UserResetPasswordParams {
      newPassword: string
    }

    /** 用户分页响应 */
    interface UserPageResponse extends Api.Common.PaginatedResponse<UserListItem> {
      records: UserListItem[]
      current: number
      size: number
      total: number
    }

    /** 用户列表 */
    type UserList = UserPageResponse

    /** 用户列表项 */
    interface UserListItem {
      id: number
      username: string
      nickname: string
      avatar?: string
      email?: string
      phone?: string
      gender?: number
      genderText?: string
      manageScope?: string
      status: number
      statusText?: string
      gender?: number
      genderText?: string
      address?: string
      introduction?: string
      cpUserId?: string
      openid?: string
      roleIds?: number[]
      roleNames?: string[]
      createTime?: string
      updateTime?: string
      lastLoginTime?: string
      isOnline?: boolean
      // 兼容旧字段
      userName?: string
      userGender?: string
      userEmail?: string
      userPhone?: string
    }

    /** 用户简单信息 */
    interface UserSimpleItem {
      id: number
      username: string
      nickname: string
      phone?: string
      email?: string
    }

    /** 角色用户查询参数 */
    interface RoleUserQueryParams {
      roleCodes: string[]
    }

    /** 角色用户信息（Map格式，key为角色代码，value为用户列表） */
    type RoleUserMap = Record<string, UserSimpleItem[]>

    /** ==================== 角色管理 ==================== */
    /** 角色查询参数 */
    interface RoleSearchParams {
      roleCode?: string
      roleName?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 角色保存参数 */
    interface RoleSaveParams {
      id?: number
      roleCode: string
      roleName: string
      sort?: number
      status?: number
      remark?: string
      menuIds?: number[]
    }

    /** 角色分页响应 */
    interface RolePageResponse {
      list: RoleListItem[]
      total: number
      pageNum: number
      pageSize: number
      totalPages: number
    }

    /** 角色列表 */
    type RoleList = RolePageResponse

    /** 角色权限项（包含菜单ID和状态） */
    interface RolePermissionItem {
      menuId: number
      status: number
    }

    /** 角色列表项 */
    interface RoleListItem {
      id: number
      roleCode: string
      roleName: string
      sort?: number
      status: number
      statusText?: string
      remark?: string
      menuIds?: number[]
      createTime?: string
      updateTime?: string
    }

    /** ==================== 菜单管理 ==================== */
    /** 菜单查询参数 */
    interface MenuSearchParams {
      menuName?: string
      menuType?: string
      status?: number
    }

    /** 菜单保存参数 */
    interface MenuSaveParams {
      id?: number
      parentId: number
      menuName: string
      menuType: string
      path?: string
      component?: string
      permission?: string
      icon?: string
      sort?: number
      visible?: number
      status?: number
      keepAlive?: number
    }

    /** 菜单列表项 */
    interface MenuListItem {
      id: number
      parentId: number
      menuName: string
      menuType: string
      menuTypeText?: string
      path?: string
      component?: string
      permission?: string
      icon?: string
      sort?: number
      visible?: number
      visibleText?: string
      status: number
      statusText?: string
      keepAlive?: number
      children?: MenuListItem[]
      createTime?: string
      updateTime?: string
    }

    /** 菜单树列表 */
    type MenuTreeList = MenuListItem[]

    /** ==================== 字典类型管理 ==================== */
    /** 字典类型查询参数 */
    interface DictTypeSearchParams {
      dictName?: string
      dictCode?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 字典类型保存参数 */
    interface DictTypeSaveParams {
      id?: number
      dictName: string
      dictCode: string
      status?: number
      remark?: string
    }

    /** 字典类型列表项 */
    interface DictTypeListItem {
      id: number
      dictName: string
      dictCode: string
      status: number
      statusText?: string
      remark?: string
      createTime?: string
      updateTime?: string
    }

    /** 字典类型分页响应 */
    interface DictTypePageResponse extends Api.Common.PaginatedResponse<DictTypeListItem> {
      records: DictTypeListItem[]
      current: number
      size: number
      total: number
    }

    /** ==================== 字典数据管理 ==================== */
    /** 字典数据查询参数 */
    interface DictDataSearchParams {
      dictCode?: string
      label?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 字典数据保存参数 */
    interface DictDataSaveParams {
      id?: number
      dictCode: string
      label: string
      value: string
      cssClass?: string
      listClass?: string
      sort?: number
      isDefault?: number
      status?: number
      remark?: string
    }

    /** 字典数据列表项 */
    interface DictDataListItem {
      id: number
      dictCode: string
      label: string
      value: string
      cssClass?: string
      listClass?: string
      sort?: number
      isDefault?: number
      status: number
      statusText?: string
      remark?: string
      createTime?: string
      updateTime?: string
    }

    /** 字典数据分页响应 */
    interface DictDataPageResponse extends Api.Common.PaginatedResponse<DictDataListItem> {
      records: DictDataListItem[]
      current: number
      size: number
      total: number
    }

    /** 字典数据列表 */
    type DictDataList = DictDataListItem[]

    /** ==================== 校区管理 ==================== */
    /** 校区查询参数 */
    interface CampusSearchParams {
      campusCode?: string
      campusName?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 校区保存参数 */
    interface CampusSaveParams {
      id?: number
      campusCode: string
      campusName: string
      address: string
      manager?: string
      status: number
      sort?: number
    }

    /** 校区列表项 */
    interface CampusListItem {
      id: number
      campusCode: string
      campusName: string
      address: string
      manager?: string
      status: number
      statusText?: string
      sort?: number
      createTime?: string
      updateTime?: string
    }

    /** 校区分页响应 */
    interface CampusPageResponse extends Api.Common.PaginatedResponse<CampusListItem> {
      records: CampusListItem[]
      current: number
      size: number
      total: number
    }

    /** 校区树列表 */
    type CampusTreeList = CampusListItem[]

    /** ==================== 院系管理 ==================== */
    /** 院系查询参数 */
    interface DepartmentSearchParams {
      deptCode?: string
      deptName?: string
      campusCode?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 院系保存参数 */
    interface DepartmentSaveParams {
      id?: number
      deptCode: string
      deptName: string
      campusCode: string
      leader?: string
      phone?: string
      sort?: number
      status: number
    }

    /** 院系列表项 */
    interface DepartmentListItem {
      id: number
      deptCode: string
      deptName: string
      campusCode: string
      campusName?: string
      leader?: string
      phone?: string
      sort?: number
      status: number
      statusText?: string
      createTime?: string
      updateTime?: string
    }

    /** 院系分页响应 */
    interface DepartmentPageResponse extends Api.Common.PaginatedResponse<DepartmentListItem> {
      records: DepartmentListItem[]
      current: number
      size: number
      total: number
    }

    /** 院系树列表 */
    type DepartmentTreeList = DepartmentListItem[]

    /** ==================== 专业管理 ==================== */
    /** 专业查询参数 */
    interface MajorSearchParams {
      majorCode?: string
      majorName?: string
      deptCode?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 专业保存参数 */
    interface MajorSaveParams {
      id?: number
      majorCode: string
      majorName: string
      deptCode: string
      director?: string
      type?: string
      duration: string
      goal?: string
    }

    /** 专业列表项 */
    interface MajorListItem {
      id: number
      majorCode: string
      majorName: string
      deptCode: string
      deptName?: string
      director?: string
      type?: string
      typeText?: string
      duration: string
      goal?: string
      status?: number
      statusText?: string
      createTime?: string
      updateTime?: string
    }

    /** 专业分页响应 */
    interface MajorPageResponse extends Api.Common.PaginatedResponse<MajorListItem> {
      list: MajorListItem[]
      current: number
      size: number
      total: number
    }

    /** ==================== 班级管理 ==================== */
    /** 班级查询参数 */
    interface ClassSearchParams {
      classCode?: string
      className?: string
      majorCode?: string
      grade?: string
      enrollmentYear?: number
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 班级保存参数 */
    interface ClassSaveParams {
      id?: number
      classCode: string
      className: string
      majorCode: string
      grade: string
      teacherId?: number
      enrollmentYear: number
      currentCount?: number
    }

    /** 班级列表项 */
    interface ClassListItem {
      id: number
      classCode: string
      className: string
      majorCode: string
      majorName?: string
      grade: string
      teacherName?: string
      teacherId?: number
      enrollmentYear: number
      currentCount?: number
      status?: number
      statusText?: string
      createTime?: string
      updateTime?: string
    }

    /** 班级分页响应 */
    interface ClassPageResponse extends Api.Common.PaginatedResponse<ClassListItem> {
      records: ClassListItem[]
      current: number
      size: number
      total: number
    }

    /** ==================== 学年管理 ==================== */
    /** 学年查询参数 */
    interface AcademicYearSearchParams {
      yearCode?: string
      yearName?: string
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 学期保存参数 */
    interface SemesterSaveParams {
      id?: number
      semesterCode: string
      semesterName: string
      startDate: string
      endDate: string
      semesterType?: string
    }

    /** 学年保存参数 */
    interface AcademicYearSaveParams {
      id?: number
      yearCode: string
      yearName: string
      startDate: string
      endDate: string
      status: number
      semesters?: SemesterSaveParams[]
    }

    /** 学期列表项 */
    interface SemesterListItem {
      id: number
      academicYearId: number
      semesterCode: string
      semesterName: string
      startDate: string
      endDate: string
      semesterType?: string
      createTime?: string
      updateTime?: string
    }

    /** 学年列表项 */
    interface AcademicYearListItem {
      id: number
      yearCode: string
      yearName: string
      startDate: string
      endDate: string
      status: number
      statusText?: string
      semesters?: SemesterListItem[]
      createTime?: string
      updateTime?: string
    }

    /** 学年分页响应 */
    interface AcademicYearPageResponse extends Api.Common.PaginatedResponse<AcademicYearListItem> {
      records: AcademicYearListItem[]
      current: number
      size: number
      total: number
    }

    /** ==================== 学校层级管理 ==================== */

    /** 层级树节点 */
    interface SchoolHierarchyNode {
      id: number
      code: string
      name: string
      type: 'campus' | 'department' | 'major' | 'class'
      parentCode?: string
      status: number
      children?: SchoolHierarchyNode[]
    }

    /** 学校层级树响应 */
    interface SchoolHierarchyResponse {
      campuses: SchoolHierarchyNode[]
    }

    /** ==================== 楼层管理 ==================== */
    /** 楼层查询参数 */
    interface FloorSearchParams {
      floorCode?: string
      floorName?: string
      campusCode?: string
      genderType?: number
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 楼层保存参数 */
    interface FloorSaveParams {
      id?: number
      floorCode: string
      floorName?: string
      floorNumber: number
      campusCode: string
      genderType: number
      sort?: number
      status: number
      remark?: string
    }

    /** 楼层列表项 */
    interface FloorListItem {
      id: number
      floorCode: string
      floorName?: string
      floorNumber: number
      campusCode: string
      campusName?: string
      genderType: number
      genderTypeText?: string
      totalRooms?: number
      totalBeds?: number
      currentOccupancy?: number
      hasRooms?: boolean
      sort?: number
      status: number
      statusText?: string
      remark?: string
      createTime?: string
      updateTime?: string
    }

    /** 楼层分页响应 */
    interface FloorPageResponse extends Api.Common.PaginatedResponse<FloorListItem> {
      list: FloorListItem[]
      total: number
      pageNum: number
      pageSize: number
      totalPages: number
    }

    /** ==================== 房间管理 ==================== */
    /** 房间查询参数 */
    interface RoomSearchParams {
      roomCode?: string
      roomNumber?: string
      floorId?: number
      floorCode?: string
      campusCode?: string
      roomType?: string
      roomStatus?: number
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 房间保存参数 */
    interface RoomSaveParams {
      id?: number
      roomCode: string
      roomNumber: string
      floorId: number
      floorNumber: number
      roomType?: string
      bedCount?: number
      maxOccupancy?: number
      area?: number
      hasAirConditioner?: number
      hasBathroom?: number
      hasBalcony?: number
      roomStatus?: number
      sort?: number
      status: number
      remark?: string
    }

    /** 房间批量创建参数 */
    interface RoomBatchCreateParams {
      floorId: number
      floorNumbers: number[]
      generateCount: number
      roomType?: string
      roomStatus?: number
      bedCount?: number
      area?: number
      maxOccupancy?: number
      status: number
      hasAirConditioner?: number
      hasBathroom?: number
      hasBalcony?: number
      remark?: string
    }

    /** 房间列表项 */
    interface RoomListItem {
      id: number
      roomCode: string
      roomNumber: string
      floorId: number
      floorNumber?: number
      floorCode?: string
      floorName?: string
      campusCode?: string
      campusName?: string
      roomType?: string
      roomTypeText?: string
      bedCount?: number
      totalBeds?: number
      currentOccupancy?: number
      maxOccupancy?: number
      area?: number
      hasAirConditioner?: number
      hasBathroom?: number
      hasBalcony?: number
      roomStatus?: number
      roomStatusText?: string
      sort?: number
      status: number
      statusText?: string
      remark?: string
      createTime?: string
      updateTime?: string
    }

    /** 房间分页响应 */
    interface RoomPageResponse extends Api.Common.PaginatedResponse<RoomListItem> {
      list: RoomListItem[]
      total: number
      pageNum: number
      pageSize: number
      totalPages: number
    }

    /** ==================== 床位管理 ==================== */
    /** 床位查询参数 */
    interface BedSearchParams {
      bedCode?: string
      bedNumber?: string
      roomId?: number
      roomCode?: string
      floorId?: number
      floorCode?: string
      campusCode?: string
      bedPosition?: string
      bedStatus?: number
      status?: number
      pageNum?: number
      pageSize?: number
    }

    /** 床位保存参数 */
    interface BedSaveParams {
      id?: number
      bedCode: string
      bedNumber: string
      roomId: number | undefined
      bedPosition?: string
      bedStatus?: number
      studentId?: number
      studentName?: string
      checkInDate?: string
      checkOutDate?: string
      sort?: number
      status: number
      remark?: string
    }

    /** 床位批量创建参数 */
    interface BedBatchCreateParams {
      roomId: number
      generateCount: number
      bedPosition?: string
      bedStatus?: number
      checkInDate?: string
      checkOutDate?: string
      status: number
      remark?: string
    }

    /** 床位列表项 */
    interface BedListItem {
      id: number
      bedCode: string
      bedNumber: string
      roomId: number
      roomCode?: string
      roomNumber?: string
      floorId?: number
      floorCode?: string
      floorName?: string
      campusCode?: string
      campusName?: string
      bedPosition?: string
      bedPositionText?: string
      bedStatus?: number
      bedStatusText?: string
      studentId?: number
      studentName?: string
      checkInDate?: string
      checkOutDate?: string
      sort?: number
      status: number
      statusText?: string
      remark?: string
      createTime?: string
      updateTime?: string
    }

    /** 床位分页响应 */
    interface BedPageResponse extends Api.Common.PaginatedResponse<BedListItem> {
      list: BedListItem[]
      total: number
      pageNum: number
      pageSize: number
      totalPages: number
    }

    /** ==================== 操作日志管理 ==================== */
    /** 操作日志查询参数 */
    interface OperLogSearchParams {
      title?: string
      operName?: string
      businessType?: number
      status?: number
      operTimeStart?: string
      operTimeEnd?: string
      pageNum?: number
      pageSize?: number
    }

    /** 操作日志列表项 */
    interface OperLogListItem {
      id: number
      title: string
      businessType: number
      businessTypeText: string
      method: string
      requestMethod: string
      operatorType: number
      operName: string
      deviceType: number
      deviceTypeText: string
      operUrl: string
      operIp: string
      operLocation: string
      operParam: string
      jsonResult: string
      status: number
      statusText: string
      errorMsg: string
      operTime: string
      costTime: number
    }

    /** 操作日志分页响应 */
    interface OperLogPageResponse {
      list: OperLogListItem[]
      total: number
      pageNum: number
      pageSize: number
    }
  }
}
