# 宿舍管理系统小程序

基于 uni-app + Vue 3 + Pinia + Vue I18n + Vant 构建的宿舍管理系统小程序。

## 项目结构

```
miniprogram/
├── api/                    # API 接口定义
├── components/             # 组件目录
│   └── common/            # 公共组件
├── store/                  # Pinia 状态管理
│   ├── index.js           # Pinia 实例
│   └── modules/           # 状态模块
│       ├── user.js        # 用户状态
│       └── app.js         # 应用状态
├── utils/                  # 工具函数
│   ├── config.js          # 配置文件
│   ├── request.js         # 请求封装
│   ├── auth.js            # 认证工具
│   └── storage.js         # 存储工具
├── locales/                # 国际化
│   ├── index.js           # i18n 配置
│   └── lang/              # 语言包
│       ├── zh-CN.js       # 中文
│       └── en-US.js       # 英文
├── pages/                  # 页面
├── static/                 # 静态资源
└── [配置文件]
```

## 技术栈

- **框架**: uni-app (Vue 3)
- **状态管理**: Pinia
- **国际化**: Vue I18n
- **UI 组件库**: Vant Weapp
- **HTTP 请求**: uni.request (已封装)

## 快速开始

### 1. 安装依赖

```bash
cd miniprogram
npm install
# 或
pnpm install
```

### 2. 配置

#### API 地址配置

编辑 `utils/config.js`，修改 API 基础地址：

```javascript
const config = {
  development: {
    baseURL: 'http://localhost:8080/api' // 开发环境
  },
  production: {
    baseURL: 'https://your-domain.com/api' // 生产环境
  }
}
```

#### 小程序 AppID 配置

编辑 `manifest.json`，填入小程序 AppID：

```json
{
  "mp-weixin": {
    "appid": "你的小程序AppID"
  }
}
```

### 3. 运行

#### 方式一：使用 HBuilderX（推荐）

1. 下载并安装 [HBuilderX](https://www.dcloud.io/hbuilderx.html)
2. 在 HBuilderX 中打开 `miniprogram` 文件夹
3. 点击菜单：**运行** → **运行到小程序模拟器** → **微信开发者工具**
4. 首次运行需要配置微信开发者工具的安装路径

#### 方式二：使用命令行

```bash
# 安装依赖
pnpm install

# 开发模式（需要先全局安装 @dcloudio/uni-app-cli）
npm install -g @dcloudio/uni-app-cli
pnpm dev:mp-weixin

# 或使用 HBuilderX 内置的 CLI
```

**注意**：推荐使用 HBuilderX 开发，因为它内置了所有必要的工具，无需额外配置。

### 4. 构建

```bash
npm run build:mp-weixin
```

## 功能特性

### 已配置功能

- ✅ Pinia 状态管理
- ✅ Vue I18n 国际化（中英文）
- ✅ Vant UI 组件库（easycom 自动引入）
- ✅ HTTP 请求封装（自动添加 token、错误处理）
- ✅ 认证工具（登录、登出、用户信息）
- ✅ 本地存储工具
- ✅ 路径别名 `@` 支持

### 使用示例

#### 状态管理

```javascript
import { useUserStore } from '@/store/modules/user.js'

const userStore = useUserStore()
// 登录
await userStore.login(username, password)
// 获取用户信息
await userStore.fetchUserInfo()
```

#### 国际化

```javascript
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
const message = t('auth.login')
```

#### API 请求

```javascript
import { authApi } from '@/api/index.js'

// 登录
await authApi.login({ username, password })
```

#### Vant 组件

直接使用，无需导入（easycom 自动引入）：

```vue
<template>
  <van-button type="primary">按钮</van-button>
</template>
```

## 注意事项

1. **域名白名单**: 小程序需要在微信公众平台配置服务器域名白名单
2. **开发环境**: 开发阶段可在微信开发者工具中关闭域名校验
3. **Token 管理**: Token 自动存储在本地，请求时自动添加到 header
4. **401 处理**: Token 过期会自动跳转到登录页

## 开发规范

- 使用 `@` 别名引用项目文件
- API 接口统一在 `api/index.js` 中定义
- 状态管理使用 Pinia
- 国际化文案在 `locales/lang/` 中维护
- 公共组件放在 `components/common/` 中

## 后续开发

1. 创建登录页面
2. 创建首页
3. 实现住宿相关功能页面
4. 实现个人中心页面
