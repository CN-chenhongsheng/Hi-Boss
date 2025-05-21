简体中文 | [English](./README.en.md)

## 关于 Art Design Pro

作为一名开发者，我在多个项目中需要搭建后台管理系统，但发现传统系统在用户体验和视觉设计上不能完全满足需求。因此，我创建了一款专注于用户体验和快速开发的开源后台管理解决方案。基于 ElementPlus 设计规范，进行了视觉上的精心优化，提供更美观、更实用的前端界面，帮助你轻松构建高质量的后台系统。

## 演示图

### 浅色主题

![浅色主题](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover1.png)

![浅色主题](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover2.png)

### 暗黑主题

![暗黑主题](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover3.png)

![暗黑主题](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover4.png)

## 特点

- 使用最新技术栈
- 内置常用业务组件模版
- 提供多种主题模式，可以自定义主题
- 漂亮的 UI设计、极致的用户体验和细节处理
- 系统全面支持自定义设置，满足您的个性化需求

## 技术栈

- 开发框架：Vue3、TypeScript、Vite、Element-Plus
- 代码规范：Eslint、Prettier、Stylelint、Husky、Lint-staged、cz-git

## 功能

- 丰富主题切换
- 全局搜索
- 锁屏
- 多标签页
- 全局面包屑
- 多语言
- 图标库
- 富文本编辑器
- Echarts 图表
- Utils工具包
- 网络异常处理
- 路由级别鉴权
- 侧边栏菜单鉴权
- 鉴权指令
- 移动端适配
- 优秀的持久化存储方案
- 本地数据存储校验
- 代码提交校验与格式化
- 代码提交规范化

## 兼容性

- 支持 Chrome、Safari、Firefox 等现代主流浏览器。

## 安装运行

```bash
# 安装依赖
pnpm install

# 如果 pnpm install 安装失败，尝试使用下面的命令安装依赖
pnpm install --ignore-scripts

# 本地开发环境启动
pnpm dev

# 生产环境打包
pnpm build
```

## 开发方案

### 项目结构

```
src
├── api                   # API 接口管理
├── assets                # 静态资源
├── components            # 全局公共组件
├── composables           # 组合式函数
├── config                # 全局配置
├── directives            # 自定义指令
├── enums                 # 枚举定义
├── language              # 国际化语言包
├── mock                  # 数据模拟
├── plugins               # 插件配置
├── router                # 路由配置
├── store                 # 状态管理
├── types                 # 类型定义
├── utils                 # 全局工具函数
├── views                 # 页面组件
├── App.vue               # 根组件
├── env.d.ts              # 环境变量类型声明
└── main.ts               # 入口文件
```

### 开发规范

1. **命名规范**
   - 文件夹：小写字母 + 连字符（如：user-info）
   - 组件文件：大驼峰命名法（如：UserInfo.vue）
   - 工具类文件：小驼峰命名法（如：formatDate.ts）
   - CSS 类名：BEM 命名规范（如：.user-card__title--primary）

2. **代码提交规范**
   - 使用 commitizen 规范提交信息
   - 提交前运行 lint-staged 进行代码检查和格式化
   - 遵循 commitlint 配置的提交消息规范

3. **组件开发规范**
   - 优先使用组合式 API（Composition API）
   - 组件按功能拆分，保持单一职责
   - 公共组件放在 components 目录，页面组件放在 views 目录
   - 组件 props 必须定义类型和默认值

4. **样式规范**
   - 使用 SCSS 预处理器
   - 遵循 stylelint 配置的样式规范
   - 全局样式放在 assets/styles 目录
   - 组件样式使用 scoped 或 CSS modules 隔离

### 开发流程

1. **环境准备**
   - 安装 Node.js（推荐 v16+）和 pnpm
   - 克隆代码库并安装依赖
   - 配置编辑器（推荐 VSCode）的 ESLint、Prettier、Volar 插件

2. **功能开发**
   - 根据需求创建新分支（如：feature/user-management）
   - 开发完成后进行自测
   - 运行 lint 和 build 检查代码质量
   - 提交代码并创建合并请求

3. **测试与部署**
   - 执行单元测试和集成测试
   - 部署到测试环境进行功能验证
   - 修复发现的问题
   - 部署到生产环境

### 性能优化

1. **代码分割**
   - 路由懒加载
   - 组件按需导入
   - 第三方库按需引入

2. **资源优化**
   - 图片压缩和 WebP 格式转换
   - CSS 和 JavaScript 代码压缩
   - 启用 gzip/brotli 压缩

3. **缓存策略**
   - 合理使用浏览器缓存
   - 实现数据持久化存储
   - 优化 API 调用频率

4. **渲染优化**
   - 虚拟列表处理大数据渲染
   - 避免不必要的组件重渲染
   - 使用 Suspense 和异步组件

## 开发规范详细说明

### 1. 代码风格规范

#### 1.1 JavaScript/TypeScript
- 使用 TypeScript 开发所有新功能
- 禁止使用 `any` 类型，除非绝对必要
- 使用 ES6+ 语法特性，如箭头函数、解构赋值、模板字符串
- 变量和函数使用 camelCase 命名
- 常量使用 UPPER_SNAKE_CASE 命名
- 类型和接口使用 PascalCase 命名
- 避免嵌套三层以上的回调或 Promise 链

#### 1.2 Vue 组件
- 使用 Composition API 而非 Options API
- 组件名称使用 PascalCase 命名
- 单文件组件的顺序：`<script>`, `<template>`, `<style>`
- 组件选项顺序：name, components, props, emits, setup
- Props 必须声明类型和默认值
- 事件名使用 kebab-case（如：`@click-item`）
- 避免在模板中使用复杂表达式，提取为计算属性

#### 1.3 CSS/SCSS
- 使用 SCSS 预处理器
- 遵循 BEM 命名规范：`.block__element--modifier`
- 全局样式使用 CSS 变量定义主题
- 组件样式使用 `scoped` 或 CSS Modules
- 媒体查询按照移动端优先原则编写
- 避免使用 `!important`

### 2. 项目结构规范

#### 2.1 文件组织
- 按功能模块组织文件，不按文件类型
- 功能相关的文件应放在同一目录
- 页面组件放在 `views` 目录，可重用组件放在 `components` 目录
- 工具函数按功能分类放在 `utils` 目录的子文件夹中
- API 接口按业务模块组织在 `api` 目录下

#### 2.2 命名规则
- 文件夹使用小写字母+连字符（如：`user-profile`）
- 组件文件使用 PascalCase（如：`UserProfile.vue`）
- 工具类文件使用 camelCase（如：`formatDate.ts`）
- 测试文件添加 `.spec.ts` 或 `.test.ts` 后缀
- 类型定义文件使用 `.d.ts` 后缀或放在 `types` 目录

### 3. Git 工作流规范

#### 3.1 分支管理
- `main` 分支保持稳定，随时可发布
- `develop` 分支作为开发主分支
- 功能开发使用 `feature/功能名` 分支
- 缺陷修复使用 `bugfix/问题描述` 分支
- 紧急修复使用 `hotfix/问题描述` 分支

#### 3.2 提交规范
- 使用 commitizen 和 cz-git 进行规范化提交
- 提交类型：
  - `feat`：新功能
  - `fix`：修复缺陷
  - `docs`：文档更改
  - `style`：格式调整（不影响代码逻辑）
  - `refactor`：重构代码（不是新功能也不是修复缺陷）
  - `perf`：性能优化
  - `test`：添加或修改测试
  - `build`：构建系统或外部依赖项更改
  - `ci`：CI 配置文件和脚本更改
  - `chore`：其他不修改源代码或测试的更改
- 提交消息格式：`类型(范围): 简短描述`
- 每个提交只做一件事，保持原子性

### 4. 组件开发规范

#### 4.1 通用原则
- 组件设计遵循单一职责原则
- 优先使用函数式组件
- 使用 `defineProps` 和 `defineEmits` 声明 props 和事件
- 大型组件拆分为小组件
- 避免嵌套超过三层的组件结构

#### 4.2 状态管理
- 使用 Pinia 进行状态管理
- Store 按业务领域划分
- 简单组件状态使用 `ref` 和 `reactive`
- 复杂表单状态使用 VueUse 的 `useForm` 或自定义 hooks
- 避免过度使用全局状态，优先考虑组件通信

#### 4.3 性能优化
- 合理使用 `computed` 缓存计算结果
- 大型列表使用虚拟滚动
- 使用 `v-once` 或 `v-memo` 减少不必要的渲染
- 使用 `shallowRef` 和 `shallowReactive` 处理大型对象
- 按需加载组件，使用异步组件

### 5. API 调用规范

#### 5.1 请求封装
- 使用 Axios 统一封装 HTTP 请求
- 请求函数按业务模块组织
- 请求地址使用环境变量配置
- 请求参数和响应结果使用 TypeScript 类型定义

#### 5.2 错误处理
- 全局统一处理通用错误（如 401、404、500）
- 业务错误在各个业务模块中处理
- 使用 try-catch 处理异步请求异常
- 提供友好的错误提示和恢复机制

### 6. 测试规范

#### 6.1 单元测试
- 业务组件核心功能必须有单元测试
- 工具函数必须有单元测试
- 测试覆盖率目标：行覆盖率 > 80%
- 使用 Vitest 进行单元测试
- 模拟 API 调用和外部依赖

#### 6.2 集成测试
- 关键业务流程需要集成测试
- 测试组件间交互和状态管理
- 验证路由跳转和页面渲染
- 测试表单提交和数据处理

### 7. 文档规范

#### 7.1 代码注释
- 公共函数、组件、类型必须有 JSDoc 注释
- 复杂逻辑需要有解释性注释
- 临时代码需要有 TODO 注释并附加处理计划
- 避免无意义的注释，代码应该自解释

#### 7.2 组件文档
- 每个可重用组件需要有使用示例和文档
- 文档包括：组件说明、Props、事件、插槽
- 关键组件提供在线 Demo
- 更新组件时同步更新文档

### 8. 安全规范

#### 8.1 前端安全
- 防止 XSS：对用户输入进行转义
- 防止 CSRF：使用 CSRF Token
- 敏感数据不直接存储在前端
- 使用 HTTPS 进行数据传输
- 避免在 URL 参数中传递敏感信息

#### 8.2 认证和授权
- 使用 JWT 进行身份验证
- 实现细粒度的权限控制
- 敏感操作需要二次确认
- 自动登出非活动会话
- 记录安全相关的操作日志

### 9. 性能优化规范

#### 9.1 加载优化
- 路由组件懒加载
- 图片使用适当尺寸和格式（WebP/AVIF）
- 第三方库按需引入
- 使用 Tree-shaking 减小包体积
- 长列表数据分页加载

#### 9.2 运行时优化
- 使用 Web Workers 处理复杂计算
- 缓存重复请求数据
- 避免频繁 DOM 操作
- 减少不必要的计算和渲染
- 大型表单分步显示

### 10. 发布与部署规范

#### 10.1 构建流程
- 使用环境变量区分开发、测试和生产环境
- 生产构建启用代码压缩和优化
- 生成 sourcemap 便于问题定位
- 自动生成构建报告分析包大小

#### 10.2 部署流程
- 使用 CI/CD 自动构建和部署
- 执行自动化测试确保质量
- 实施蓝绿部署或金丝雀发布
- 保留版本回滚能力
- 监控部署后的应用性能和错误
