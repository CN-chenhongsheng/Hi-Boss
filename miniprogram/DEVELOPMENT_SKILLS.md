# 宿舍管理小程序 - 开发规范 Skills

> 版本: v1.0
> 创建日期: 2026-01-13
> 适用项目: sushe_web_2025/miniprogram

---

## 概述

本文档定义了宿舍管理小程序项目的开发规范，所有开发人员必须遵循这些规范以保证代码质量和项目可维护性。

---

## 一、项目技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| UniApp | 3.x | 跨平台小程序框架 |
| Vue | 3.x | 使用 Composition API |
| TypeScript | 5.x | 严格模式 |
| Pinia | 2.x | 状态管理 |
| UView Plus | 3.x | UI 组件库 |
| UnoCSS | - | 原子化 CSS |
| Vite | 5.x | 构建工具 |

---

## 二、目录结构规范

```
src/
├── api/                    # API 接口层
│   ├── accommodation/      # 住宿相关 API
│   ├── service/           # 服务相关 API
│   ├── common/            # 通用 API
│   └── index.ts           # API 统一导出
├── components/            # 公共组件
│   ├── [component-name]/  # 组件目录（kebab-case）
│   │   ├── index.vue      # 组件入口
│   │   └── types.ts       # 组件类型（可选）
├── hooks/                 # Composables
│   ├── [hook-name]/       # Hook 目录
│   │   └── index.ts       # Hook 入口
│   └── index.ts           # 统一导出
├── pages/                 # 页面
│   ├── tab/              # TabBar 页面
│   ├── common/           # 通用页面
│   ├── apply/            # 申请相关页面
│   ├── service/          # 服务相关页面
│   └── admin/            # 管理员页面
├── store/                # 状态管理
│   └── modules/          # Store 模块
├── types/                # 类型定义
│   └── api/              # API 相关类型
├── utils/                # 工具函数
└── static/               # 静态资源
    └── styles/           # 全局样式
```

---

## 三、命名规范

### 3.1 文件命名

| 类型 | 规范 | 示例 |
|------|------|------|
| Vue 组件 | kebab-case | `user-card.vue`, `apply-list.vue` |
| TypeScript 文件 | kebab-case | `check-in.ts`, `use-loading.ts` |
| 类型定义文件 | kebab-case | `types.ts`, `check-in.ts` |
| 常量文件 | kebab-case | `colors.ts`, `api.ts` |
| 样式文件 | kebab-case | `common.scss`, `variables.scss` |

### 3.2 代码命名

```typescript
// 变量：camelCase
const userName = 'John';
const isLoading = false;
const applyList = ref<IApply[]>([]);

// 常量：UPPER_SNAKE_CASE
const MAX_UPLOAD_COUNT = 9;
const API_BASE_URL = '/api/v1';
const DEFAULT_PAGE_SIZE = 10;

// 函数：camelCase，动词开头
function getUserInfo() { }
function handleSubmit() { }
function formatDate(date: string) { }

// 类/接口：PascalCase
interface IUser { }
interface IApplyParams { }
class UserService { }

// 类型别名：PascalCase
type UserRole = 'student' | 'admin';
type ApplyStatus = 1 | 2 | 3 | 4;

// 枚举：PascalCase，成员 UPPER_SNAKE_CASE
enum ApplyStatus {
  PENDING = 1,
  APPROVED = 2,
  REJECTED = 3,
}

// 组件名：PascalCase
// 文件: user-card.vue
// 使用: <UserCard />

// CSS 类名：kebab-case
.user-card { }
.apply-list-item { }
.glass-card { }
```

### 3.3 接口命名规范

```typescript
// 接口以 I 开头
interface IUser { }
interface IApplyParams { }
interface IPageResult<T> { }

// API 响应类型
interface IResponse<T> {
  code: number;
  message: string;
  data: T;
}

// 查询参数类型：以 Params 结尾
interface ICheckInQueryParams { }
interface IUserPageParams { }

// 提交数据类型：以 SubmitParams 或 Data 结尾
interface ICheckInSubmitParams { }
interface IApplyFormData { }

// 分页结果类型：以 PageResult 结尾
interface ICheckInPageResult { }
```

---

## 四、Vue 组件规范

### 4.1 组件结构

```vue
<template>
  <!-- 模板内容 -->
</template>

<script setup lang="ts">
// 1. 导入语句
import { computed, onMounted, ref } from 'vue';
import { storeToRefs } from 'pinia';
import type { IUser } from '@/types';
import useUserStore from '@/store/modules/user';

// 2. Props 定义
interface Props {
  title: string;
  data?: IUser;
}
const props = withDefaults(defineProps<Props>(), {
  data: undefined,
});

// 3. Emits 定义
const emit = defineEmits<{
  submit: [data: IUser];
  cancel: [];
}>();

// 4. Store
const userStore = useUserStore();
const { userInfo } = storeToRefs(userStore);

// 5. 响应式数据
const loading = ref(false);
const list = ref<IUser[]>([]);

// 6. 计算属性
const isAdmin = computed(() => userInfo.value?.role === 'admin');

// 7. 方法
function handleSubmit() {
  emit('submit', props.data!);
}

// 8. 生命周期
onMounted(() => {
  loadData();
});

// 9. 异步方法
async function loadData() {
  loading.value = true;
  try {
    // ...
  } finally {
    loading.value = false;
  }
}
</script>

<style lang="scss" scoped>
/* 样式内容 */
</style>
```

### 4.2 Props 规范

```typescript
// 必须使用 TypeScript 类型定义
interface Props {
  // 必填属性
  id: number;
  title: string;

  // 可选属性
  subtitle?: string;

  // 复杂类型
  data: IUser;
  list: IApply[];

  // 函数类型
  onSubmit?: (data: IUser) => void;
}

// 使用 withDefaults 设置默认值
const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  list: () => [],
});
```

### 4.3 Emits 规范

```typescript
// 使用类型化的 emits
const emit = defineEmits<{
  // 无参数事件
  close: [];

  // 带参数事件
  submit: [data: IFormData];

  // 多参数事件
  change: [value: string, oldValue: string];
}>();

// 触发事件
emit('close');
emit('submit', formData);
emit('change', newValue, oldValue);
```

---

## 五、TypeScript 规范

### 5.1 类型定义

```typescript
// 禁止使用 any，使用 unknown 或具体类型
// Bad
const data: any = {};

// Good
const data: unknown = {};
const data: Record<string, unknown> = {};
const data: IUser = {} as IUser;

// 使用类型断言时必须有明确理由
const element = document.getElementById('app') as HTMLDivElement;

// 优先使用 interface 而非 type
// Good
interface IUser {
  id: number;
  name: string;
}

// 仅在需要联合类型或交叉类型时使用 type
type UserRole = 'student' | 'admin' | 'dorm_manager';
type UserWithRole = IUser & { role: UserRole };
```

### 5.2 泛型使用

```typescript
// API 请求泛型
function request<T>(config: HttpRequestConfig): Promise<T> {
  // ...
}

// 分页结果泛型
interface IPageResult<T> {
  list: T[];
  total: number;
  pageNum: number;
  pageSize: number;
}

// 使用
const result = await request<IPageResult<IUser>>({ url: '/users' });
```

### 5.3 类型导出

```typescript
// types/api/index.ts
// 统一从 index.ts 导出类型
export * from './common';
export * from './user';
export * from './check-in';
export * from './transfer';

// 使用
import type { IUser, ICheckIn, ApplyStatus } from '@/types';
```

---

## 六、API 规范

### 6.1 API 函数定义

```typescript
/**
 * 获取入住申请分页列表
 * @param params 查询参数
 * @returns 分页结果
 */
export function getCheckInPageAPI(params: ICheckInQueryParams) {
  return get<ICheckInPageResult>({
    url: '/api/v1/system/check-in/page',
    data: params,
  });
}

/**
 * 提交入住申请
 * @param data 申请数据
 */
export function submitCheckInAPI(data: ICheckInSubmitParams) {
  return post<void>({
    url: '/api/v1/system/check-in',
    data,
  });
}
```

### 6.2 API 命名规范

```typescript
// 查询单个：get[Entity]API
export function getUserAPI(id: number) { }

// 查询列表：get[Entity]ListAPI 或 get[Entity]PageAPI
export function getUserListAPI() { }
export function getUserPageAPI(params: IPageParams) { }

// 创建：create[Entity]API 或 submit[Entity]API
export function createUserAPI(data: IUserData) { }
export function submitCheckInAPI(data: ICheckInData) { }

// 更新：update[Entity]API
export function updateUserAPI(id: number, data: Partial<IUserData>) { }

// 删除：delete[Entity]API
export function deleteUserAPI(id: number) { }

// 特殊操作：[action][Entity]API
export function approveCheckInAPI(id: number, data: IApprovalData) { }
export function rejectTransferAPI(id: number, reason: string) { }
```

---

## 七、Store 规范

### 7.1 Store 定义

```typescript
import { defineStore } from 'pinia';
import type { IUser } from '@/types';

interface UserState {
  userInfo: IUser | null;
  token: string;
  isLoggedIn: boolean;
}

const useUserStore = defineStore('user', {
  state: (): UserState => ({
    userInfo: null,
    token: '',
    isLoggedIn: false,
  }),

  getters: {
    // Getter 必须有返回类型
    userRole(state): string | undefined {
      return state.userInfo?.role;
    },

    isAdmin(state): boolean {
      return state.userInfo?.role === 'admin';
    },
  },

  actions: {
    // Action 使用 async/await
    async login(params: ILoginParams) {
      try {
        const res = await loginAPI(params);
        this.setToken(res.token);
        this.setUserInfo(res.userInfo);
        return res;
      } catch (error) {
        throw error;
      }
    },

    setUserInfo(userInfo: IUser) {
      this.userInfo = userInfo;
      this.isLoggedIn = true;
    },

    resetInfo() {
      this.$reset();
    },
  },

  // 持久化配置
  persist: {
    key: 'user-store',
    paths: ['token', 'userInfo'],
  },
});

export default useUserStore;
```

### 7.2 Store 使用

```typescript
// 在组件中使用
import { storeToRefs } from 'pinia';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();

// 解构响应式状态
const { userInfo, isLoggedIn } = storeToRefs(userStore);

// 直接使用 getters
const isAdmin = userStore.isAdmin;

// 调用 actions
await userStore.login(loginForm);
userStore.resetInfo();
```

---

## 八、样式规范

### 8.1 SCSS 变量

```scss
// src/static/styles/variables.scss

// 主题色
$primary: #0adbc3;
$primary-dark: #08bda8;
$primary-light: #e0fbf8;

// 强调色
$accent: #ff9f43;
$accent-dark: #e68a2e;

// 功能色
$success: #22c55e;
$warning: #f59e0b;
$error: #ef4444;
$info: #3b82f6;

// 文字色
$text-main: #111817;
$text-sub: #6b7280;
$text-placeholder: #9ca3af;

// 背景色
$bg-light: #f5f8f8;
$bg-page: #f0fdfa;

// 毛玻璃效果
$glass-bg: rgb(255 255 255 / 65%);
$glass-border: rgb(255 255 255 / 80%);
$glass-border-light: rgb(255 255 255 / 60%);

// 圆角
$radius-sm: 16rpx;
$radius-md: 24rpx;
$radius-lg: 32rpx;
$radius-xl: 48rpx;
$radius-full: 9999rpx;

// 阴影
$shadow-sm: 0 2rpx 8rpx rgb(0 0 0 / 5%);
$shadow-md: 0 8rpx 32rpx rgb(31 38 135 / 7%);
$shadow-lg: 0 16rpx 48rpx rgb(31 38 135 / 10%);
```

### 8.2 样式书写顺序

```scss
.component {
  // 1. 定位属性
  position: relative;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 10;

  // 2. 盒模型
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 200rpx;
  padding: 24rpx;
  margin: 16rpx;
  overflow: hidden;

  // 3. 文字样式
  font-size: 28rpx;
  font-weight: 500;
  color: $text-main;
  text-align: center;
  line-height: 1.5;

  // 4. 视觉样式
  background: $glass-bg;
  border: 2rpx solid $glass-border;
  border-radius: $radius-lg;
  box-shadow: $shadow-md;

  // 5. 其他
  opacity: 1;
  transition: all 0.3s;
  cursor: pointer;

  // 6. 伪类/伪元素
  &:hover {
    transform: translateY(-4rpx);
  }

  &::before {
    content: '';
  }

  // 7. 子元素
  .child {
    // ...
  }
}
```

### 8.3 响应式单位

```scss
// 使用 rpx 作为主要单位（750rpx = 屏幕宽度）
.container {
  width: 686rpx;        // 750 - 32*2 = 686
  padding: 32rpx;
  margin: 0 32rpx;
  font-size: 28rpx;
  border-radius: 24rpx;
}

// 安全区域
.safe-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}

// 状态栏高度
.header {
  padding-top: calc(var(--status-bar-height) + 24rpx);
}
```

---

## 九、Hooks 规范

### 9.1 Hook 定义

```typescript
// src/hooks/use-loading/index.ts
import { ref } from 'vue';

export function useLoading(initialValue = false) {
  const loading = ref(initialValue);

  const startLoading = () => {
    loading.value = true;
  };

  const stopLoading = () => {
    loading.value = false;
  };

  const withLoading = async <T>(fn: () => Promise<T>): Promise<T> => {
    startLoading();
    try {
      return await fn();
    } finally {
      stopLoading();
    }
  };

  return {
    loading,
    startLoading,
    stopLoading,
    withLoading,
  };
}
```

### 9.2 Hook 命名

```typescript
// Hook 必须以 use 开头
export function useLoading() { }
export function useModal() { }
export function useClipboard() { }
export function useApplyForm() { }

// 返回值使用对象解构
const { loading, withLoading } = useLoading();
const { showModal, hideModal } = useModal();
```

---

## 十、注释规范

### 10.1 文件头注释

```typescript
/**
 * 入住申请API
 * @module api/accommodation/check-in
 * @description 处理入住申请相关的所有API请求
 */
```

### 10.2 函数注释

```typescript
/**
 * 获取入住申请分页列表
 * @param params - 查询参数
 * @param params.pageNum - 页码
 * @param params.pageSize - 每页条数
 * @param params.status - 申请状态
 * @returns 分页结果
 * @example
 * const result = await getCheckInPageAPI({ pageNum: 1, pageSize: 10 });
 */
export function getCheckInPageAPI(params: ICheckInQueryParams) {
  // ...
}
```

### 10.3 复杂逻辑注释

```typescript
// 计算指示线位置
// 由于所有 Tab 都是等宽的（flex: 1），直接计算百分比位置
// 每个 Tab 占 100% / tabs.length
// 指示线居中：left = (activeIndex * 100% / tabs.length) + (100% / tabs.length - 60rpx) / 2
const leftPercent = activeIndex * tabWidthPercent + (tabWidthPercent / 2);
```

---

## 十一、Git 提交规范

### 11.1 Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 11.2 Type 类型

| Type | 说明 |
|------|------|
| feat | 新功能 |
| fix | Bug 修复 |
| docs | 文档更新 |
| style | 代码格式（不影响功能） |
| refactor | 重构（不是新功能也不是修复） |
| perf | 性能优化 |
| test | 测试相关 |
| chore | 构建/工具相关 |

### 11.3 示例

```bash
# 新功能
feat(apply): 添加入住申请表单验证

# Bug 修复
fix(request): 修复请求拦截器错误处理

# 重构
refactor(components): 拆分申请表单组件

# 样式
style(home): 统一首页卡片样式
```

---

## 十二、代码审查清单

### 12.1 提交前检查

- [ ] TypeScript 类型检查通过 (`pnpm type-check`)
- [ ] ESLint 检查通过 (`pnpm eslint`)
- [ ] Stylelint 检查通过 (`pnpm stylelint`)
- [ ] 无 `console.log` 调试代码
- [ ] 无硬编码的敏感信息
- [ ] 新增代码有必要的注释
- [ ] 复杂逻辑有单元测试

### 12.2 代码质量检查

- [ ] 无 `any` 类型
- [ ] Props 有完整的类型定义
- [ ] API 函数有 JSDoc 注释
- [ ] 错误处理完善
- [ ] 加载状态处理正确
- [ ] 组件职责单一

### 12.3 性能检查

- [ ] 列表使用 `key` 属性
- [ ] 大列表使用虚拟滚动
- [ ] 图片使用懒加载
- [ ] 避免不必要的响应式数据

---

## 十三、常见问题解决方案

### 13.1 跨平台兼容

```typescript
// 条件编译
// #ifdef MP-WEIXIN
// 微信小程序特有代码
// #endif

// #ifdef H5
// H5 特有代码
// #endif
```

### 13.2 安全区域适配

```scss
// 底部安全区域
.safe-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}

// 顶部状态栏
.header {
  padding-top: calc(var(--status-bar-height) + 24rpx);
}
```

### 13.3 页面传参

```typescript
// 传递参数
uni.navigateTo({
  url: `/pages/detail/index?id=${id}&type=${type}`,
});

// 接收参数
import { onLoad } from '@dcloudio/uni-app';

onLoad((options) => {
  const { id, type } = options as { id: string; type: string };
});
```

---

## 附录：快速参考

### A. 常用颜色

| 名称 | 值 | 用途 |
|------|-----|------|
| primary | #0adbc3 | 主题色 |
| primary-dark | #08bda8 | 主题深色 |
| accent | #ff9f43 | 强调色 |
| success | #22c55e | 成功 |
| warning | #f59e0b | 警告 |
| error | #ef4444 | 错误 |
| text-main | #111817 | 主文字 |
| text-sub | #6b7280 | 次文字 |

### B. 常用尺寸

| 名称 | 值 | 用途 |
|------|-----|------|
| 页面边距 | 32rpx | 页面左右边距 |
| 卡片圆角 | 32rpx / 48rpx | 卡片圆角 |
| 按钮高度 | 88rpx / 96rpx | 按钮高度 |
| 字号-小 | 24rpx | 辅助文字 |
| 字号-中 | 28rpx | 正文 |
| 字号-大 | 32rpx | 标题 |
| 字号-特大 | 48rpx | 页面标题 |

### C. 申请状态

| 状态 | 值 | 颜色 |
|------|-----|------|
| 待审核 | 1 | #FF9800 |
| 已通过 | 2 | #4CAF50 |
| 已拒绝 | 3 | #F44336 |
| 已完成 | 4 | #2196F3 |

---

> 本规范由架构组维护，如有疑问请联系项目负责人。
