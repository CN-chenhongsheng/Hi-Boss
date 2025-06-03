# 宿管新web2025

## 项目简介
该项目是宿舍管理系统的2025版本Web应用。

## 项目结构

```
sushe_web_2025/
├── .git/                # Git仓库文件
├── .gitignore           # Git忽略配置
├── .husky/              # Git钩子配置
├── .lintstagedrc.json   # lint-staged配置
├── commitlint.config.cjs # commit规范配置
├── package.json         # 项目依赖管理
├── pnpm-lock.yaml       # pnpm锁定文件
├── PC-Admin/            # 管理端Web应用
│   ├── .gitattributes   # Git属性配置
│   ├── .gitignore       # Git忽略配置
│   ├── .husky/          # Git钩子配置
│   ├── .prettierignore  # Prettier忽略配置
│   ├── .prettierrc      # Prettier配置
│   ├── .stylelintignore # Stylelint忽略配置
│   ├── .stylelintrc.cjs # Stylelint配置
│   ├── LICENSE          # 许可证文件
│   ├── README.en.md     # 英文说明文档
│   ├── README.md        # 项目说明文档
│   ├── components.d.ts  # 组件类型定义
│   ├── eslint.config.mjs # ESLint配置
│   ├── index.html       # HTML入口文件
│   ├── package.json     # 项目依赖管理
│   ├── pnpm-lock.yaml   # pnpm锁定文件
│   ├── tsconfig.json    # TypeScript配置
│   ├── vite.config.ts   # Vite配置
│   ├── .auto-import.json # 自动导入配置
│   ├── public/          # 静态资源目录
│   │   └── favicon.ico  # 网站图标
│   └── src/             # 源代码目录
│       ├── App.vue      # 应用入口组件
│       ├── main.ts      # 应用入口文件
│       ├── env.d.ts     # 环境变量类型声明
│       ├── api/         # API接口
│       ├── assets/      # 资源文件
│       ├── components/  # 组件
│       ├── config/      # 配置
│       ├── directives/  # 自定义指令
│       ├── enums/       # 枚举定义
│       ├── language/    # 国际化
│       ├── mock/        # 模拟数据
│       ├── plugins/     # 插件
│       ├── router/      # 路由配置
│       ├── store/       # 状态管理
│       ├── types/       # 类型定义
│       ├── utils/       # 工具函数
│       ├── views/       # 页面视图
│       └── composables/ # 组合式函数
```

## 技术栈
- 前端框架：Vue.js
- 构建工具：Vite
- 包管理器：pnpm
- 代码规范：ESLint, Prettier, Stylelint
- 提交规范：Husky, commitlint

## 开发指南
请参考各模块下的README.md文件获取详细开发指南。