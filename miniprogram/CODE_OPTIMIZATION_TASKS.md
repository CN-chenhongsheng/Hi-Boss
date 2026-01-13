# 宿舍管理小程序 - 代码优化任务书

> 版本: v1.0
> 创建日期: 2026-01-13
> 项目: sushe_web_2025/miniprogram

---

## 一、项目概述

本项目是基于 **UniApp + Vue 3 + TypeScript + Pinia** 的宿舍管理系统小程序，包含学生端和管理员端功能。经过代码审查，发现以下需要优化的问题和任务。

---

## 二、优先级说明

| 优先级 | 说明 | 建议处理时间 |
|--------|------|-------------|
| P0 | 严重问题，影响功能或安全 | 立即处理 |
| P1 | 重要问题，影响代码质量 | 本迭代处理 |
| P2 | 一般问题，影响可维护性 | 下迭代处理 |
| P3 | 优化建议，提升代码质量 | 有空处理 |

---

## 三、代码优化任务清单

### 3.1 【P0】严重问题

#### 3.1.1 请求封装缺少错误处理

**文件**: `src/utils/request/index.ts:20-28`

**问题描述**:
```typescript
export function request<T = any>(config: HttpRequestConfig): Promise<T> {
  return new Promise((resolve) => {
    http.request(config).then((res: HttpResponse<IResponse<T>>) => {
      console.log('[ res ] >', res);  // 生产环境不应有 console.log
      const { data } = res.data;
      resolve(data as T);
    });
    // 缺少 .catch() 处理，Promise 永远不会 reject
  });
}
```

**优化方案**:
```typescript
export function request<T = any>(config: HttpRequestConfig): Promise<T> {
  return new Promise((resolve, reject) => {
    http.request(config)
      .then((res: HttpResponse<IResponse<T>>) => {
        const { data } = res.data;
        resolve(data as T);
      })
      .catch((error) => {
        reject(error);
      });
  });
}
```

---

#### 3.1.2 拦截器中调用不存在的方法

**文件**: `src/utils/request/interceptors.ts:92`

**问题描述**:
```typescript
await useUserStore().authLogin();  // authLogin 方法不存在于 userStore 中
```

**优化方案**:
应改为调用正确的登录方法或 Token 刷新方法：
```typescript
await useUserStore().login(savedCredentials);
// 或者实现 refreshToken 逻辑
```

---

#### 3.1.3 硬编码的 Mock 数据

**文件**: `src/pages/tab/home/index.vue:505`

**问题描述**:
```typescript
if (true) {  // 永远为 true 的条件判断
  applyList.value = [...]
}
```

**优化方案**:
```typescript
if (isLoggedIn.value) {
  // 调用真实 API 或使用 Mock 开关
  if (USE_MOCK) {
    applyList.value = mockApplyList;
  } else {
    applyList.value = await getApplyListAPI();
  }
}
```

---

### 3.2 【P1】重要问题

#### 3.2.1 大量使用 `any` 类型

**涉及文件**:
- `src/pages/tab/home/index.vue:312` - `noticeList.value = ref<any[]>([])`
- `src/pages/tab/apply/index.vue:143` - `list.value = ref<any[]>([])`
- `src/pages/apply/form/index.vue:517` - `handleFormUpdate(field: string, value: any)`

**优化方案**:
定义明确的类型接口：
```typescript
// types/api/notice.ts
interface INotice {
  id: number;
  title: string;
  desc: string;
  tag: string;
  tagClass: string;
  date: string;
  icon?: string;
}

// 使用
const noticeList = ref<INotice[]>([]);
```

---

#### 3.2.2 重复的样式代码

**问题描述**:
多个页面存在大量重复的 SCSS 变量和样式定义：

```scss
// 以下代码在多个文件中重复出现
$primary: #0adbc3;
$primary-dark: #08bda8;
$accent: #ff9f43;
$bg-light: #f5f8f8;
$text-main: #111817;
$text-sub: #6b7280;
$glass-bg: rgb(255 255 255 / 65%);
$glass-border: rgb(255 255 255 / 80%);
```

**涉及文件**:
- `src/pages/tab/home/index.vue`
- `src/pages/tab/apply/index.vue`
- `src/pages/apply/form/index.vue`
- 其他页面...

**优化方案**:
创建全局 SCSS 变量文件：
```scss
// src/static/styles/variables.scss
$primary: #0adbc3;
$primary-dark: #08bda8;
$primary-light: #e0fbf8;
$accent: #ff9f43;
$bg-light: #f5f8f8;
$text-main: #111817;
$text-sub: #6b7280;
$glass-bg: rgb(255 255 255 / 65%);
$glass-border: rgb(255 255 255 / 80%);
$glass-border-light: rgb(255 255 255 / 60%);
```

在 `vite.config.ts` 中配置全局引入。

---

#### 3.2.3 重复的工具函数

**问题描述**:
多个页面重复定义相同的工具函数：

```typescript
// 在多个文件中重复出现
function getApplyTypeName(type: string) { ... }
function getApplyTypeIcon(type: string) { ... }
function getStatusText(status: ApplyStatus) { ... }
function getStatusColor(status: ApplyStatus) { ... }
function formatTime(time: string) { ... }
```

**涉及文件**:
- `src/pages/tab/apply/index.vue`
- `src/pages/tab/home/index.vue`
- `src/pages/apply/detail/index.vue`

**优化方案**:
提取到公共工具函数：
```typescript
// src/utils/apply/index.ts
export const ApplyTypeConfig = {
  checkIn: { name: '入住申请', icon: 'home', color: '#14b8a6' },
  transfer: { name: '调宿申请', icon: 'reload', color: '#6366f1' },
  checkOut: { name: '退宿申请', icon: 'arrow-left', color: '#f43f5e' },
  stay: { name: '留宿申请', icon: 'calendar', color: '#3b82f6' },
};

export function getApplyTypeName(type: string): string { ... }
export function getApplyTypeIcon(type: string): ApplyTypeIconConfig { ... }
```

---

#### 3.2.4 组件文件过大

**问题描述**:
`src/pages/apply/form/index.vue` 文件超过 2000 行，包含：
- 多个弹窗组件（申请类型选择、日期范围选择、签名）
- 复杂的表单逻辑
- 大量样式代码

**优化方案**:
1. 将弹窗组件拆分为独立组件：
   - `components/apply-type-picker.vue`
   - `components/date-range-picker.vue`（已存在但未使用）
   - `components/signature-picker.vue`（已存在但未使用）

2. 将表单验证逻辑提取到 composable：
   ```typescript
   // src/hooks/use-apply-form/index.ts
   export function useApplyForm() {
     const validateForm = (formData: ApplyFormData): boolean => { ... }
     const submitForm = async (formData: ApplyFormData): Promise<void> => { ... }
     return { validateForm, submitForm };
   }
   ```

---

#### 3.2.5 缺少统一的加载状态管理

**问题描述**:
各页面独立管理加载状态，代码重复：
```typescript
const loading = ref(false);
loading.value = true;
try { ... } finally { loading.value = false; }
```

**优化方案**:
使用已有的 `use-loading` hook 或扩展功能：
```typescript
// src/hooks/use-loading/index.ts
export function useLoading() {
  const loading = ref(false);

  const withLoading = async <T>(fn: () => Promise<T>): Promise<T> => {
    loading.value = true;
    try {
      return await fn();
    } finally {
      loading.value = false;
    }
  };

  return { loading, withLoading };
}
```

---

### 3.3 【P2】一般问题

#### 3.3.1 魔法数字和硬编码字符串

**问题描述**:
```typescript
// src/utils/request/interceptors.ts:51
const interval = 1000; // 间隔时间(ms)

// src/pages/tab/home/index.vue:267
const defaultAvatar = 'https://via.placeholder.com/150';

// 多处硬编码的颜色值
iconColor: '#14b8a6'
bgColor: 'rgba(20, 184, 166, 0.1)'
```

**优化方案**:
提取为常量：
```typescript
// src/constants/index.ts
export const REQUEST_INTERVAL = 1000;
export const DEFAULT_AVATAR = 'https://via.placeholder.com/150';

// src/constants/colors.ts
export const COLORS = {
  primary: '#0adbc3',
  primaryDark: '#08bda8',
  accent: '#ff9f43',
  // ...
};
```

---

#### 3.3.2 console.log 未清理

**涉及文件**:
- `src/utils/request/index.ts:23` - `console.log('[ res ] >', res);`
- `src/pages/tab/home/index.vue:461` - `console.log('同意隐私政策');`
- `src/pages/tab/home/index.vue:599` - `console.error('加载数据失败:', error);`
- `src/store/modules/user/index.ts` - 多处 `console.error`

**优化方案**:
1. 移除调试用的 `console.log`
2. 使用统一的日志工具：
```typescript
// src/utils/logger/index.ts
const isDev = import.meta.env.DEV;

export const logger = {
  log: (...args: any[]) => isDev && console.log(...args),
  warn: (...args: any[]) => isDev && console.warn(...args),
  error: (...args: any[]) => console.error(...args), // 错误始终记录
};
```

---

#### 3.3.3 缺少组件 Props 类型定义

**问题描述**:
子组件的 Props 缺少明确的类型定义和默认值。

**优化方案**:
```typescript
// src/pages/apply/form/components/normal-check-in.vue
interface Props {
  formData: {
    reason: string;
    images: string[];
  };
}

const props = withDefaults(defineProps<Props>(), {
  formData: () => ({ reason: '', images: [] }),
});
```

---

#### 3.3.4 API 路径不统一

**问题描述**:
```typescript
// 有的使用 /api/v1/system/ 前缀
url: '/api/v1/system/check-in/page'

// 有的可能使用其他前缀
// 缺少统一的 API 版本管理
```

**优化方案**:
```typescript
// src/constants/api.ts
export const API_PREFIX = '/api/v1';
export const API_SYSTEM = `${API_PREFIX}/system`;

// 使用
url: `${API_SYSTEM}/check-in/page`
```

---

### 3.4 【P3】优化建议

#### 3.4.1 添加页面骨架屏

**建议**:
为列表页面添加骨架屏组件，提升用户体验。

```vue
<!-- src/components/skeleton/list-skeleton.vue -->
<template>
  <view class="skeleton-list">
    <view v-for="i in count" :key="i" class="skeleton-item">
      <view class="skeleton-avatar" />
      <view class="skeleton-content">
        <view class="skeleton-title" />
        <view class="skeleton-desc" />
      </view>
    </view>
  </view>
</template>
```

---

#### 3.4.2 添加请求缓存

**建议**:
对于不常变化的数据（如公告列表），添加请求缓存：

```typescript
// src/utils/request/cache.ts
const cache = new Map<string, { data: any; timestamp: number }>();
const CACHE_DURATION = 5 * 60 * 1000; // 5分钟

export function getCachedData<T>(key: string): T | null { ... }
export function setCachedData<T>(key: string, data: T): void { ... }
```

---

#### 3.4.3 添加错误边界

**建议**:
添加全局错误处理和错误边界组件：

```typescript
// src/utils/error-handler/index.ts
export function setupErrorHandler() {
  uni.onError((error) => {
    logger.error('Global error:', error);
    // 上报错误到监控平台
  });
}
```

---

#### 3.4.4 优化图片加载

**建议**:
1. 使用图片懒加载
2. 添加图片加载失败的占位图
3. 考虑使用 WebP 格式

```vue
<image
  :src="imageUrl"
  mode="aspectFill"
  lazy-load
  @error="handleImageError"
/>
```

---

## 四、重构建议

### 4.1 目录结构优化

```
src/
├── api/                    # API 层（保持现状）
├── components/             # 公共组件
│   ├── business/          # 业务组件（新增）
│   │   ├── apply-card/    # 申请卡片
│   │   ├── notice-card/   # 公告卡片
│   │   └── user-card/     # 用户卡片
│   ├── form/              # 表单组件（新增）
│   │   ├── date-picker/
│   │   ├── signature/
│   │   └── image-upload/
│   └── feedback/          # 反馈组件（新增）
│       ├── skeleton/
│       ├── empty/
│       └── error/
├── constants/             # 常量定义（新增）
│   ├── index.ts
│   ├── colors.ts
│   └── api.ts
├── hooks/                 # Composables（扩展）
│   ├── use-apply/        # 申请相关 hooks
│   ├── use-request/      # 请求相关 hooks
│   └── ...
├── styles/               # 全局样式（新增）
│   ├── variables.scss
│   ├── mixins.scss
│   └── common.scss
└── ...
```

### 4.2 状态管理优化

建议将申请相关的状态提取到独立的 store：

```typescript
// src/store/modules/apply/index.ts
export const useApplyStore = defineStore('apply', {
  state: () => ({
    applyList: [],
    currentApply: null,
    loading: false,
  }),
  actions: {
    async fetchApplyList(params) { ... },
    async submitApply(data) { ... },
  },
});
```

---

## 五、执行计划

### 第一阶段：修复严重问题（P0）
- [ ] 修复请求封装的错误处理
- [ ] 修复拦截器中的方法调用错误
- [ ] 移除硬编码的 Mock 条件

### 第二阶段：处理重要问题（P1）
- [ ] 定义完整的类型接口，消除 `any`
- [ ] 提取公共 SCSS 变量
- [ ] 提取公共工具函数
- [ ] 拆分大型组件文件
- [ ] 统一加载状态管理

### 第三阶段：处理一般问题（P2）
- [ ] 提取魔法数字为常量
- [ ] 清理 console.log
- [ ] 完善组件 Props 类型
- [ ] 统一 API 路径管理

### 第四阶段：优化建议（P3）
- [ ] 添加骨架屏组件
- [ ] 实现请求缓存
- [ ] 添加错误边界
- [ ] 优化图片加载

---

## 六、验收标准

1. **TypeScript 严格模式通过**: 无 `any` 类型警告
2. **ESLint 检查通过**: 无错误和警告
3. **Stylelint 检查通过**: 样式规范统一
4. **单元测试覆盖率**: 核心工具函数 > 80%
5. **构建成功**: 生产环境构建无错误

---

## 七、相关文档

- [开发规范 Skills](./DEVELOPMENT_SKILLS.md)
- [API 文档](./API_DOCS.md)
- [组件文档](./COMPONENT_DOCS.md)
