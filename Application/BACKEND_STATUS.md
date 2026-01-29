# 后端（Application）项目接口状态说明

本文档梳理后端 **Controller 与接口路径**、**与后台管理/微信小程序的对应关系**，以及**尚未实现但前端已约定或已调用的接口**。

---

## 一、全局说明

- **Context Path**：`/api`（见 `application.yml` 中 `server.servlet.context-path`）。
- **实际请求路径**：所有下述 `@RequestMapping` 前均需加 `/api`，例如 `@RequestMapping("/v1/auth")` 对应完整路径 **`/api/v1/auth`**。

---

## 二、已实现的 Controller 与路径一览

| 模块 | Controller | 完整路径前缀 | 主要能力 |
|------|------------|--------------|----------|
| **认证** | AuthController | /api/v1/auth | login、student/login、wx-login、refresh、logout、userinfo |
| **用户资料** | UserProfileController | /api/v1/user/profile | 获取/更新资料、修改密码 |
| **系统-用户** | UserController | /api/v1/system/user | list、详情、增删改、批量删除、重置密码、状态、权限、可用菜单、by-roles |
| **系统-角色** | RoleController | /api/v1/system/role | list、all、详情、增删改、批量删除、权限、状态 |
| **系统-菜单** | MenuController | /api/v1/system/menu | tree、tree-select、tree-permission、user-tree、详情、增删改、状态 |
| **系统-字典** | DictTypeController / DictDataController | /api/v1/system/dict/type、dict/data | 类型/数据分页、增删改、batch、list |
| **系统-操作日志** | OperLogController | /api/v1/system/oper-log | page、详情、batch、clean |
| **系统-用户在线** | UserOnlineController | /api/v1/system/user/online | stream（SSE） |
| **组织-校区** | CampusController | /api/v1/system/campus | 分页、tree、详情、增删改、batch、状态 |
| **组织-院系** | DepartmentController | /api/v1/system/department | 分页、tree、详情、增删改、batch、状态 |
| **组织-专业** | MajorController | /api/v1/system/major | 分页、详情、增删改、batch、状态 |
| **组织-班级** | ClassController | /api/v1/system/class | 分页、详情、增删改、batch、状态 |
| **组织-层级** | SchoolHierarchyController | /api/v1/system/school | hierarchy |
| **学校-学年** | AcademicYearController | /api/v1/system/academic-year | 分页、详情、增删改、batch、状态 |
| **宿舍-楼层** | FloorController | /api/v1/system/floor | 分页、详情、增删改、batch、状态、check-rooms |
| **宿舍-房间** | RoomController | /api/v1/system/room | 分页、详情、增删改、batch、状态、batch-create、check-beds |
| **宿舍-床位** | BedController | /api/v1/system/bed | 分页、详情、增删改、batch、状态、batch-create |
| **住宿-学生** | StudentController（backend） | /api/v1/system/student | 分页、详情、增删改、batch、状态 |
| **住宿-入住** | CheckInController | /api/v1/system/check-in | 分页、详情、增删改、batch、cancel |
| **住宿-调宿** | TransferController | /api/v1/system/transfer | 分页、详情、增删改、batch、cancel |
| **住宿-退宿** | CheckOutController | /api/v1/system/check-out | 分页、详情、增删改、batch、cancel |
| **住宿-留宿** | StayController | /api/v1/system/stay | 分页、详情、增删改、batch、cancel |
| **审批** | ApprovalController | /api/v1/system/approval | flow 列表/全部/详情/增删改/状态、binding 列表/按业务类型/增删、instance 详情/按业务查询、approve、withdraw、pending 列表与数量、record 列表/我的/按实例 |
| **学生端-宿舍与习惯** | StudentController（app） | /api/v1/app/student | dorm-info、roommates、habits（GET/PUT） |
| **公共-文件** | CommonFileController | /api/v1/common/files | upload（多文件） |
| **测试** | TestController | /api/v1/test | generate-password、verify-password |

---

## 三、与微信小程序的对接情况

| 小程序调用的接口/能力 | 后端路径/实现 | 状态 |
|----------------------|----------------|------|
| 登录、刷新、登出、用户信息 | /api/v1/auth/*、/api/v1/user/profile | ✅ 已实现 |
| 入住/调宿/退宿/留宿 详情、撤回、审批实例 | /api/v1/system/check-in、transfer、check-out、stay、approval/* | ✅ 已实现 |
| 入住/调宿/退宿/留宿 提交 | /api/v1/system/check-in、transfer、check-out、stay（POST） | ✅ 已实现 |
| 宿舍信息、室友 | /api/v1/app/student/dorm-info、roommates | ✅ 已实现 |
| 学生习惯 获取/更新 | /api/v1/app/student/habits（GET/PUT） | ✅ 已实现 |
| 个人资料更新、修改密码 | /api/v1/user/profile | ✅ 已实现 |
| 图片/签名上传 | /api/v1/common/files/upload | ✅ 已实现（小程序应使用此路径；部分页面写 /api/v1/common/upload 需改为 files/upload） |
| 通知分页、详情、已读、未读数 | /api/v1/service/notice/* | ❌ **未实现**（小程序已定义 getNoticePageAPI、getNoticeDetailAPI、markNoticeReadAPI、getUnreadNoticeCountAPI） |
| 报修分页、详情、提交、处理、评价等 | /api/v1/service/repair/* | ❌ **未实现**（小程序已定义 getRepairPageAPI、submitRepairAPI 等） |
| 学生端首页统计 | /api/v1/statistics/student-home | ❌ **未实现**（小程序已定义 getStudentHomeStatisticsAPI，当前未调用） |

---

## 四、与后台管理的对接情况

后台管理使用的接口路径均在 **/api/v1/system/** 或 **/api/v1/auth**、**/api/v1/user/profile** 下，对应 Controller 均已实现，**无缺口**。详见 **manager/MANAGER_STATUS.md**。

---

## 五、尚未实现但前端已约定/使用的接口（建议实现顺序）

1. **通知/公告服务**（小程序首页通知、消息中心、公告详情依赖）  
   - 建议路径：`/api/v1/service/notice/*`  
   - 建议能力：分页列表、详情、发布、编辑、删除、标记已读、未读数量（与小程序 api/service/notice 对齐）。

2. **报修服务**（小程序报修列表、报修提交依赖）  
   - 建议路径：`/api/v1/service/repair/*`  
   - 建议能力：分页列表、详情、提交、处理、评价等（与小程序 api/service/repair 对齐）。

3. **学生端首页统计**（小程序首页“近期申请”“统计”等依赖）  
   - 建议路径：`/api/v1/statistics/student-home`  
   - 建议能力：返回待办数量、近期申请摘要、可选水电等统计字段（与小程序 getStudentHomeStatisticsAPI 及类型 IStudentHomeStatistics 对齐）。

4. **小程序上传路径统一**  
   - 小程序端部分页面使用 `/api/v1/common/upload`，后端实际为 `/api/v1/common/files/upload`。  
   - 建议：小程序统一改为 `/api/v1/common/files/upload`，或后端增加 `/api/v1/common/upload` 并转发至现有上传逻辑。

---

## 六、小结

- **后台管理**：当前依赖的后端接口均已实现，无缺项。  
- **微信小程序**：认证、住宿申请、宿舍信息、习惯、个人资料、文件上传等已对接；**通知、报修、学生端首页统计** 三个模块后端尚未实现，需新增 Controller/Service 并实现上表路径与能力。  
- **建议实现顺序**：见根目录 **DEV_TASKS.md**（与前端开发顺序对齐）。

---

*文档基于当前 Application 代码与前端 API 约定整理，后续新增接口请同步更新此文档。*
