# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **three-project monorepo** for a dormitory management system:
- **`Application/`** - Java Spring Boot backend (RESTful API server)
- **`manager/`** - Web admin dashboard (Vue 3 + TypeScript + Element Plus)
- **`miniprogram/`** - WeChat mini-program (UniApp + Vue 3 + TypeScript)

All three projects work together: backend provides APIs, manager provides admin UI, miniprogram provides mobile student-facing UI.

---

## Quick Commands

### Application (Java Backend)

```bash
cd Application

# Development (Windows)
快速启动.bat                # Quick start (checks Java, prompts for MySQL/Redis)
mvn spring-boot:run       # Start Spring Boot (port 8080)

# Development (Linux/Mac)
./mvnw spring-boot:run    # Start with Maven wrapper

# Build
mvn clean package         # Build JAR file
mvn clean install         # Install to local Maven repo

# Testing
mvn test                  # Run tests
```

**Requirements:**
- Java 21+
- Maven 3.6+
- MySQL 8.0+ (localhost:3306)
- Redis (localhost:6379)
- Database: `project_management` (see `Application/sql/project_management.sql`)

**API Documentation:**
- Knife4j: http://localhost:8080/api/doc.html (after starting backend)

### Manager (Web Admin Dashboard)

```bash
cd manager

# Development
pnpm install              # Install dependencies
pnpm dev                  # Start dev server (port 3006)
pnpm build                # Production build
pnpm serve                # Preview production build

# Code Quality
pnpm lint                 # Run ESLint + Stylelint
pnpm fix                  # Auto-fix linting issues
pnpm type-check           # TypeScript type checking

# Git
pnpm commit               # Interactive commit with Commitizen
```

**Requirements:**
- Node.js >= 20.19.0
- pnpm >= 8.8.0

### Miniprogram (WeChat Mini-Program)

```bash
cd miniprogram

# Development
pnpm install              # Install dependencies
pnpm dev:mp-weixin        # WeChat mini-program dev mode
pnpm dev:h5               # H5 web version dev mode
pnpm build:mp-weixin      # WeChat mini-program build
pnpm build:h5             # H5 web version build

# Code Quality
pnpm eslint               # ESLint auto-fix
pnpm stylelint            # Stylelint auto-fix
pnpm type-check           # TypeScript type checking
```

**Requirements:**
- Node.js >= 20.19.0
- pnpm >= 8.8.0
- WeChat DevTools (for mini-program development)

---

## Architecture Overview

### Application (Java Backend)

**Tech Stack:**
- Spring Boot 3.2.12 (Java 21)
- MyBatis-Plus 3.5.5 (ORM)
- MySQL 8.0 (database)
- Redis (caching)
- Sa-Token 1.37.0 (authentication)
- Knife4j 4.4.0 (API documentation)

**Package Structure:**
```
com.project
├── core/               # Core shared utilities (no business logic)
│   ├── entity/         # Base entities (BaseEntity with soft delete)
│   ├── exception/      # Global exception handling
│   ├── result/         # Unified API response (R<T>)
│   ├── config/         # Spring configuration
│   └── util/           # Utility classes
├── backend/            # Backend business logic (admin dashboard APIs)
│   ├── accommodation/  # Accommodation management
│   ├── approval/       # Approval workflow
│   ├── organization/   # Organization/department
│   ├── repair/         # Repair management
│   ├── room/           # Room/building management
│   ├── school/         # School management
│   ├── statistics/     # Statistics
│   ├── system/         # System management (user/role/menu/dict)
│   └── notice/         # Notice management
└── app/                # Mobile app APIs (mini-program)
    ├── controller/     # Mobile API controllers
    └── service/        # Mobile API services
```

**Key Architectural Rules:**
1. **Package Dependency:** `core` ← `backend`/`app` (core NEVER depends on backend/app)
2. **API Pattern:** RESTful (GET/POST/PUT/DELETE), noun resources, unified `R<T>` response
3. **Layering:** Controller → Service → Mapper (DTO/VO separate from Entity)
4. **Exception Handling:** `BusinessException` + `GlobalExceptionHandler`
5. **Soft Delete:** All tables use `deleted` field (0=active, 1=deleted)

**Critical Files:**
- `src/main/java/com/project/Application.java` - Main entry point
- `src/main/resources/application.yml` - Configuration
- `src/main/java/com/project/core/result/R.java` - Unified response wrapper
- `src/main/java/com/project/core/exception/GlobalExceptionHandler.java` - Global error handler
- `sql/project_management.sql` - Complete database schema (20 tables)

**API Response Format:**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": { ... },
  "success": true
}
```

### Manager (Web Admin Dashboard)

**Tech Stack:**
- Vue 3.5.21 (Composition API with `<script setup>`)
- TypeScript 5.6.3 (strict mode)
- Vite 7.1.5 (build tool)
- Vue Router 4.5.1 (dynamic routing)
- Pinia 3.0.3 (state management with persistence)
- Element Plus 2.11.2 (UI library)
- Tailwind CSS 4.1.14 + SCSS (styling)
- ECharts 6.0.0 (charts)

**Key Patterns:**
1. **Dynamic Routing:** Routes loaded from backend menu data, NOT hardcoded
2. **Permission Validation:** RBAC with route guards (`RoutePermissionValidator`)
3. **Auto-imports:** Vue APIs, Router, Pinia, VueUse, Element Plus components (no manual imports)
4. **Token Refresh:** Automatic 401 handling with request queue mechanism
5. **Component Priority:** Use `ArtTable`, `ArtForm`, `ArtSwitch` instead of raw Element Plus components

**Critical Files:**
- `src/router/core/RouteRegistry.ts` - Dynamic route registration
- `src/router/guards/beforeEach.ts` - Route permission guard
- `src/store/modules/user.ts` - User state (auth tokens, user info)
- `src/store/modules/menu.ts` - Menu state (dynamic routes)
- `src/utils/http/index.ts` - Axios client with interceptors
- `src/components/core/tables/art-table/` - Table component
- `src/components/core/forms/art-form/` - Form component

**Common Components:**
- `ArtTable` - Table with pagination, sorting, right-click menu
- `ArtForm` - Config-based form with validation
- `ArtSwitch` - Switch with inline prompt
- `ArtDrawer` - Drawer with header/footer slots
- `ArtBasicInfo` - Basic information display
- `ArtStudentInfoPopover` - Student info hover card

### Miniprogram (WeChat Mini-Program)

**Tech Stack:**
- UniApp 3.0 (cross-platform framework)
- Vue 3 + TypeScript
- Pinia (state management with persistence)
- UView Plus (mobile UI library)
- z-paging (pagination)
- SCSS (glass-morphism design)

**Key Patterns:**
1. **Mock-First Development:** `USE_MOCK = true` allows development without backend
2. **Role-Based UI:** Different TabBar/pages for student/dorm_manager/admin roles
3. **Glass-Morphism Design:** Warm colors (pink/peach/coral) with `backdrop-filter`
4. **Folder+Index:** API/types follow `src/types/api/{module}/` structure
5. **Form Entry Consolidation:** All forms route to `pages/apply/form`

**Critical Files:**
- `src/pages.json` - Page routing configuration
- `src/manifest.json` - App configuration
- `src/store/modules/user.ts` - User state (role-based logic)
- `src/utils/request/index.ts` - HTTP request wrapper
- `src/mock/index.ts` - Mock data configuration (`USE_MOCK` flag)
- `src/constants/` - Route constants, colors, etc.

**TabBar Pages:**
- `pages/home/` - Home page (dashboard)
- `pages/apply/` - Apply for accommodation
- `pages/statistics/` - Statistics
- `pages/message/` - Message center
- `pages/profile/` - User profile

---

## Code Standards

### TypeScript

- **Strict Mode:** Enabled in all projects
- **No `any`:** Use proper type definitions
- **Path Aliases:**
  - Manager: `@/`, `@views/`, `@utils/`, `@stores/`, `@styles/`, `@imgs/`, `@icons/`
  - Miniprogram: `@/` for src
- **API Types:** Defined in `types/api/` (Manager uses `Api.` namespace, Miniprogram uses module exports)

### Naming Conventions

- **Files:** kebab-case (`user-store.ts`, `check-in.vue`)
- **Components:** PascalCase (`UserCard.vue`, `ApplyForm.vue`)
- **Functions/Variables:** camelCase (`getUserInfo()`, `isLoggedIn`)
- **Constants:** UPPER_SNAKE_CASE (`API_BASE_URL`, `MAX_RETRIES`)
- **CSS Classes:** kebab-case (`.user-card`, `.apply-form`)
- **Java Classes:** PascalCase with JavaDoc (`@author`, `@since`)
- **Java Packages:** lowercase (`com.project.backend.accommodation`)

### Code Style

**Frontend (Manager & Miniprogram):**
- **Quotes:** Single quotes (`'string'`)
- **Semicolons:** None (ESLint configured)
- **Indentation:** 2 spaces
- **Line Length:** 100 characters (Prettier)
- **Trailing Commas:** No

**Backend (Application):**
- **Indentation:** 4 spaces
- **Line Length:** 120 characters
- **JavaDoc:** Required for all public classes/methods
- **Author Tag:** `@author 陈鸿昇`

### Git Commits

Use Conventional Commits format (enforced by Commitlint):
```
<type>: <subject>

<body>

<footer>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`, `chore`

Example:
```
feat: add user authentication module

Implement login, registration, and token refresh functionality
with automatic token refresh on 401 responses.

Closes #123
```

---

## Key Dependencies & Patterns

### Application (Backend)

- **Spring Boot:** Web framework with auto-configuration
- **MyBatis-Plus:** ORM with automatic CRUD, pagination, soft delete support
- **Sa-Token:** JWT-free authentication (session-based with Redis)
- **Knife4j:** OpenAPI 3.0 documentation
- **Hutool:** Java utility toolkit
- **EasyExcel:** Excel import/export

**Authentication Flow:**
1. User logs in → Sa-Token creates session → Token stored in Redis
2. Client sends `Authorization: Bearer {token}` header
3. Backend validates token via Sa-Token interceptor
4. Token expires after 30 days (configurable in `application.yml`)

### Manager (Frontend)

- **Vue Router 4:** Dynamic route loading with permission guards
- **Pinia:** State management with `pinia-plugin-persistedstate`
- **Element Plus:** UI components with theme customization
- **Tailwind CSS:** Utility-first CSS
- **ECharts:** Data visualization
- **Axios:** HTTP client with interceptors (auto token refresh)
- **VueUse:** Composition API utilities

**Token Refresh Flow:**
1. Backend returns 401 → Manager queues requests
2. Refresh token via `/auth/refresh` API
3. Retry queued requests with new token
4. If refresh fails → Logout user

### Miniprogram

- **UniApp:** Cross-platform (WeChat, H5, etc.)
- **Pinia:** State management with `pinia-plugin-persistedstate`
- **UView Plus:** Mobile UI library
- **z-paging:** Pagination component
- **Mock Mode:** Built-in mock data for development

**Mock Mode:**
- Enable: `USE_MOCK = true` in `src/mock/index.ts`
- Mock data in `src/mock/` files
- Auto-used in API calls without code changes

---

## Important Architectural Decisions

### Backend (Application)

1. **Package Structure:** Core/Backend/App separation prevents circular dependencies
2. **Soft Delete:** All business tables use `deleted` field (0=active, 1=deleted)
3. **Unified Response:** All APIs return `R<T>` with code/msg/data/success
4. **Exception Handling:** `BusinessException` for business errors, global handler for all others
5. **Default Password:** New users get `123456` (configurable in `application.yml`)

**Database Schema:**
- 20 tables total (see `Application/sql/project_management.sql`)
- Base entity: `id`, `created_at`, `updated_at`, `deleted_at`, `deleted`
- Indexes on foreign keys, `deleted` field in unique indexes
- Soft delete implemented via MyBatis-Plus global config

### Manager (Frontend)

1. **Dynamic Routing:** Routes loaded from backend menu, NOT hardcoded in `router/modules/`
2. **Menu-Driven Navigation:** Menu structure drives route generation (via `RouteTransformer`)
3. **Token Refresh Queue:** Concurrent 401 requests queued, retry after refresh
4. **Table State Caching:** Table configs (pagination, sorting, filters) cached in Pinia store
5. **Component Auto-import:** No manual imports needed (via `unplugin-vue-components`)

**Route Registration Flow:**
```
Login → Fetch User Info → Fetch Menu Data →
RouteRegistry.register() → RouteTransformer.transform() →
Router.addRoute() → Navigate
```

### Miniprogram

1. **Mock-First Development:** Mock mode allows full development without backend
2. **Role-Based UI:** Different TabBar and pages based on user role (student/dorm_manager/admin)
3. **Glass-Morphism Design:** Consistent frosted glass styling with warm colors
4. **Pinia Persistence:** User state persists across app restarts
5. **Form Entry Consolidation:** All forms route to `pages/apply/form` (no duplicate form pages)

**Role-Based TabBar:**
- Student: Home, Apply, Statistics, Message, Profile
- Dorm Manager: Home, Approval, Repair, Message, Profile
- Admin: Home, Management, Statistics, Message, Profile

---

## Common Development Tasks

### Backend (Application)

**Adding a New API Endpoint:**
1. Create Entity in `core/entity/` (if new table)
2. Create Mapper in `backend/{module}/mapper/`
3. Create Service in `backend/{module}/service/`
4. Create Controller in `backend/{module}/controller/`
5. Use `@RestController`, return `R<T>`

**Example:**
```java
@RestController
@RequestMapping("/api/backend/accommodation")
public class AccommodationController {
    @GetMapping("/list")
    public R<PageResult<AccommodationVO>> list(AccommodationQuery query) {
        PageResult<AccommodationVO> result = accommodationService.list(query);
        return R.ok(result);
    }
}
```

**Common Patterns:**
- `R.ok(data)` - Success response
- `R.fail("错误信息")` - Error response
- `throw new BusinessException("业务错误")` - Business error
- `@SaCheckLogin` - Require login
- `@SaCheckRole("admin")` - Require role

### Manager (Frontend)

**Adding a New Page:**
1. Create component in `src/views/{module}/`
2. Backend adds menu item (system will auto-register route)
3. Use `ArtTable`, `ArtForm`, `ArtSwitch` components
4. Follow naming conventions: `handleSearch`, `handleReset`, `data`, `loading`, `pagination`

**Table Page Template:**
```vue
<script setup lang="ts">
const { data, loading, pagination, handleSearch, handleReset } = useTable({
  fetchApi: fetchList,
  defaultFilters: {}
})

const columns = columnsFactory([
  { prop: 'name', label: '名称' },
  { prop: 'status', label: '状态', formatter: (row) => ... }
])
</script>

<template>
  <ArtTable
    :data="data"
    :columns="columns"
    :loading="loading"
    :pagination="pagination"
    @refresh="handleSearch"
  />
</template>
```

**API Call Pattern:**
```typescript
// Define type
export namespace Api.Module {
  export interface GetListRequest { page: number }
  export interface GetListResponse { items: Item[] }
}

// Define API
export const fetchList = (params: Api.Module.GetListRequest) =>
  api.get<Api.Module.GetListResponse>({ url: '/module/list', params })

// Use in component
const { data } = await fetchList({ page: 1 })
```

### Miniprogram

**Adding a New Page:**
1. Create `.vue` file in `src/pages/{module}/`
2. Register in `src/pages.json`
3. Add route constant in `src/constants/routes.ts`
4. Update TabBar if needed (in `src/pages.json`)

**Mock Data Pattern:**
```typescript
// src/mock/module.ts
export const mockData = {
  code: 200,
  msg: 'success',
  data: { ... }
}

// src/api/module/index.ts
import { USE_MOCK } from '@/mock'
import { mockData } from '@/mock/module'

export const fetchList = async () => {
  if (USE_MOCK) return mockData
  return request.get('/module/list')
}
```

**Testing Different Roles:**
- Login page has role selector
- Select role → See role-specific TabBar/pages
- Check `src/store/modules/user.ts` for role logic

---

## Pre-commit Hooks & Linting

**Manager & Miniprogram:**
- **Husky:** Git hooks
- **lint-staged:** Run linters on staged files
- **ESLint:** JavaScript/TypeScript linting
- **Stylelint:** CSS/SCSS linting
- **Prettier:** Code formatting
- **Commitlint:** Commit message validation

Pre-commit runs:
- ESLint fix on `.js`, `.jsx`, `.ts`, `.tsx` files
- Stylelint fix on `.scss`, `.css`, `.vue` files
- Prettier format
- Commit message validation

**Application:**
- Use `mvn spotless:apply` for code formatting (if configured)

---

## Environment Configuration

### Application (Backend)

**application.yml:**
```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/project_management
    username: root
    password: root123
  data:
    redis:
      host: localhost
      port: 6379

sa-token:
  timeout: 2592000  # 30 days
  token-name: Authorization
  token-prefix: Bearer

system:
  default-password: 123456  # New user default password
```

### Manager (Frontend)

**.env.development:**
```
VITE_BASE_URL = /
VITE_PORT = 3006
VITE_API_URL = http://localhost:8080
VITE_API_PROXY_URL = http://localhost:8080/api
```

**.env.production:**
- Set `VITE_API_URL` to actual backend URL
- Console statements stripped in build

### Miniprogram

**Mock Mode:**
- `src/mock/index.ts`: Set `USE_MOCK = true`
- `src/utils/request/index.ts`: Checks `USE_MOCK` flag
- Development: Use mock data (no backend needed)
- Production: Set `USE_MOCK = false`

---

## Debugging Tips

### Backend (Application)

- **API Docs:** http://localhost:8080/api/doc.html (Knife4j)
- **Logs:** Check console for SQL logs (MyBatis logging enabled)
- **Database:** Use MySQL Workbench or similar tool
- **Redis:** Use Redis CLI or RedisInsight
- **Debug:** Set breakpoints in IntelliJ IDEA, run in debug mode

### Manager (Frontend)

- **Vue DevTools:** Browser extension for component inspection
- **Network Tab:** Check API calls and responses
- **Console:** Check for TypeScript errors
- **Pinia DevTools:** Inspect state changes
- **Router Logs:** Enable in `src/router/guards/beforeEach.ts`
- **Storage:** Check localStorage (keys prefixed with `sys-v`)

### Miniprogram

- **WeChat DevTools:** Built-in debugger
- **Console Logs:** Check mock data and API calls
- **Mock Mode:** Toggle `USE_MOCK` to test with/without backend
- **Role Switching:** Login page allows role selection
- **Pinia State:** Check `src/store/modules/` for state

---

## Performance Considerations

### Backend (Application)

- **MyBatis-Plus Pagination:** Use `Page<T>` for large lists
- **Redis Caching:** Cache frequently accessed data
- **Index Optimization:** Ensure indexes on foreign keys, `deleted` field
- **Connection Pooling:** HikariCP configured (min 5, max 20 connections)

### Manager (Frontend)

- **Route Lazy Loading:** Routes loaded on-demand
- **Component Auto-import:** Only imported components bundled
- **Table Virtualization:** Use virtual scrolling for large tables
- **Image Optimization:** WebP format, lazy loading
- **Code Splitting:** Third-party libraries separated

### Miniprogram

- **Mock Mode:** Speeds up development (no network calls)
- **Image Lazy Loading:** Images load on scroll
- **Component Reuse:** Shared components across pages
- **State Persistence:** Reduces API calls on app restart

---

## Project-Specific Skills

This repository includes specialized coding standards enforced via skills:

- **backend-java:** Java backend coding standards (Application module)
  - Use when working with Java files in `Application/`
  - Enforces package structure, RESTful API patterns, JavaDoc requirements

- **manager-frontend:** Vue 3 frontend coding standards (Manager module)
  - Use when working with Vue files in `manager/`
  - Enforces component usage priorities (ArtTable, ArtForm), API writing standards

- **miniprogram-standards:** UniApp miniprogram architecture (Miniprogram module)
  - Use when working in `miniprogram/`
  - Enforces folder+index structure, API/types alignment, form entry consolidation

- **git-commit-zh:** Chinese commit message formatting
  - Use when writing commit messages
  - Enforces bullet points and fixed author line

Refer to `.cursor/skills/` for detailed skill documentation.

---

## Documentation

**Core Docs (in `docs/`):**
- `README.md` - Project overview and navigation
- `01-系统分析报告.md` - System analysis (36 features, API design)
- `02-数据库设计文档.md` - Database design (20 tables, ER diagram)
- `03-前端重构开发计划.md` - Development plan (12 weeks)

**Implementation Guides:**
- `IMPLEMENTATION_SUMMARY.md` - Recent implementation summary
- `TESTING_GUIDE.md` - Testing guide
- `Application/BACKEND_STATUS.md` - Backend development status
- `miniprogram/CODE_OPTIMIZATION_TASKS.md` - Miniprogram optimization history

---

## When to Use Each Project

- **Application:** Backend API development, database operations, business logic
- **Manager:** Admin dashboard for system management, data visualization, user/role management
- **Miniprogram:** Student-facing mobile app for applying for accommodations, checking status, reporting repairs

All three projects work together as a complete system.
