# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **dual-project monorepo** for a dormitory management system:
- **`manager/`** - Web admin dashboard (Vue 3 + TypeScript + Vite + Element Plus)
- **`miniprogram/`** - WeChat mini-program (UniApp + Vue 3 + TypeScript)

Both projects are independent but share similar architecture patterns and coding standards.

---

## Quick Commands

### Manager (Web Admin Dashboard)

```bash
cd manager

# Development
pnpm install
pnpm dev              # Start dev server
pnpm build            # Production build
pnpm serve            # Preview production build

# Code Quality
pnpm lint             # Run ESLint + Stylelint
pnpm fix              # Auto-fix linting issues
pnpm type-check       # TypeScript type checking

# Commits
pnpm commit           # Interactive commit with Commitizen
```

### Miniprogram (WeChat Mini-Program)

```bash
cd miniprogram

# Development
pnpm install
pnpm dev:mp-weixin    # WeChat mini-program dev
pnpm dev:h5           # H5 web version dev
pnpm build:mp-weixin  # WeChat mini-program build
pnpm build:h5         # H5 web version build

# Code Quality
pnpm eslint           # ESLint auto-fix
pnpm stylelint        # Stylelint auto-fix
pnpm type-check       # TypeScript type checking
```

---

## Architecture Overview

### Manager (Web Admin)

**Key Patterns:**
- **Routing**: Dynamic route loading with permission validation (`router/core/`)
- **State Management**: Pinia stores for user, menu, settings, table config, worktabs
- **HTTP**: Axios with interceptors for auth, error handling, token refresh
- **Components**: Organized by type (business, core, forms, tables, charts, layouts)
- **Styling**: Tailwind CSS + SCSS with theme system (light/dark modes)
- **Auto-imports**: Vue 3 APIs, Router, Pinia, VueUse, Element Plus components

**Critical Files:**
- `src/router/core/` - Route registration, permission validation, menu processing
- `src/store/modules/` - Pinia stores (user, menu, setting, table, worktab)
- `src/utils/http/` - HTTP client with interceptors
- `src/types/` - TypeScript definitions for API responses, components, config

### Miniprogram (WeChat Mini-Program)

**Key Patterns:**
- **Framework**: UniApp (cross-platform: WeChat, H5, etc.)
- **State Management**: Pinia with persistence plugin
- **HTTP**: Custom request wrapper with error handling
- **Pages**: Tab-based navigation (home, apply, statistics, message, profile)
- **Components**: UView Plus UI library + custom components
- **Styling**: SCSS with glass-morphism design (毛玻璃风格)
- **Mock Data**: Built-in mock mode for development without backend

**Critical Files:**
- `src/pages/` - Page structure mirrors business logic
- `src/store/modules/` - User and app state
- `src/utils/request/` - HTTP request wrapper
- `src/types/` - API type definitions
- `src/mock/` - Mock data and configuration

---

## Code Organization Patterns

### Manager Project Structure

```
src/
├── api/              # API endpoint definitions
├── assets/           # Images, styles, SVG icons
├── components/       # Vue components (business, core)
├── config/           # Configuration files
├── directives/       # Custom Vue directives (auth, roles)
├── enums/            # TypeScript enums
├── hooks/            # Composition API functions
├── locales/          # i18n translations
├── mock/             # Mock data
├── plugins/          # Vue plugins (ECharts)
├── router/           # Route definitions and guards
├── store/            # Pinia stores
├── types/            # TypeScript type definitions
├── utils/            # Utility functions
└── views/            # Page components
```

### Miniprogram Project Structure

```
src/
├── api/              # API definitions
├── components/       # Vue components
├── hooks/            # Composition functions
├── mock/             # Mock data
├── pages/            # Page components (tab-based)
├── store/            # Pinia stores
├── types/            # TypeScript types
├── utils/            # Utilities (request, auth)
├── App.vue           # Root component
├── main.ts           # Entry point
├── manifest.json     # App config
└── pages.json        # Page routing config
```

---

## Important Architectural Decisions

### Manager

1. **Dynamic Routing**: Routes are loaded dynamically based on user permissions. See `router/core/RouteRegistry.ts` and `router/guards/beforeEach.ts`
2. **Menu-Driven Navigation**: Menu structure from backend drives route generation
3. **Theme System**: Dual theme (light/dark) with CSS variables and SCSS mixins
4. **Table State Caching**: Table configurations cached in Pinia store
5. **Auto-import**: Components and APIs auto-imported via Vite plugins

### Miniprogram

1. **Mock-First Development**: Mock mode allows full development without backend
2. **Role-Based UI**: Different TabBar and pages shown based on user role (student/dorm_manager/admin)
3. **Glass-Morphism Design**: Consistent frosted glass card styling across pages
4. **Pinia Persistence**: User state persists across app restarts
5. **UniApp Compatibility**: Code runs on WeChat mini-program and H5 web

---

## Code Standards

### TypeScript

- **Strict Mode**: Enabled in `tsconfig.json`
- **No `any`**: Avoid `any` type; use proper type definitions
- **Path Aliases**: Use `@/` for src, `@views/`, `@utils/`, etc.
- **Type Files**: API types in `types/api/`, component types in `types/component/`

### Naming Conventions

- **Files**: kebab-case (`user-store.ts`, `check-in.vue`)
- **Components**: PascalCase (`UserCard.vue`, `ApplyForm.vue`)
- **Functions/Variables**: camelCase (`getUserInfo()`, `isLoggedIn`)
- **Constants**: UPPER_SNAKE_CASE (`API_BASE_URL`, `MAX_RETRIES`)
- **CSS Classes**: kebab-case (`.user-card`, `.apply-form`)

### Code Style

- **Quotes**: Single quotes (`'string'`)
- **Semicolons**: None (configured in ESLint/Prettier)
- **Indentation**: 2 spaces
- **Line Length**: 100 characters (Prettier)
- **Trailing Commas**: No (Prettier config)

### Git Commits

Use Conventional Commits format:
```
<type>: <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`, `chore`

Example:
```
feat: add user authentication module

Implement login, registration, and token refresh functionality
with automatic token refresh on 401 responses.

Closes #123
```

---

## Key Dependencies & Patterns

### Manager

- **Vue Router 4**: Dynamic route loading with permission guards
- **Pinia**: State management with auto-import
- **Element Plus**: UI component library with theme customization
- **Tailwind CSS**: Utility-first CSS framework
- **ECharts**: Data visualization
- **Axios**: HTTP client with interceptors
- **VueUse**: Composition API utilities

### Miniprogram

- **UniApp**: Cross-platform framework
- **Pinia**: State management with persistence
- **UView Plus**: Mobile UI component library
- **uCharts**: Mobile-optimized charts
- **z-paging**: Pagination component
- **Vite**: Build tool

---

## Common Development Tasks

### Manager

**Adding a New Page:**
1. Create component in `src/views/`
2. Define route in `src/router/modules/`
3. Add menu item in backend (or mock data)
4. Route will auto-load with permission checks

**Adding API Endpoint:**
1. Define type in `src/types/api/`
2. Create function in `src/api/`
3. Use in component with `useRouter` and `useStore`

**Styling:**
- Use Tailwind classes first
- Complex styles in SCSS with BEM naming
- Theme colors via CSS variables

### Miniprogram

**Adding a New Page:**
1. Create `.vue` file in `src/pages/`
2. Register in `src/pages.json`
3. Add route constant in `src/constants/`
4. Update TabBar if needed

**Adding Mock Data:**
1. Add to `src/mock/` files
2. Enable `USE_MOCK = true` in `src/mock/index.ts`
3. Mock data auto-used in API calls

**Testing Different Roles:**
- Login page has role selector (student/dorm_manager/admin)
- Different pages/features shown based on role
- Check `src/store/modules/user.ts` for role logic

---

## Pre-commit Hooks & Linting

Both projects use:
- **Husky**: Git hooks
- **lint-staged**: Run linters on staged files
- **ESLint**: JavaScript/TypeScript linting
- **Stylelint**: CSS/SCSS linting
- **Prettier**: Code formatting
- **Commitlint**: Commit message validation

**Pre-commit runs automatically:**
- ESLint fix on `.js`, `.jsx`, `.ts`, `.tsx` files
- Stylelint fix on `.scss`, `.css`, `.vue` files
- Commit message validation

If hooks fail, fix issues and re-commit.

---

## Performance Considerations

### Manager

- **Route Lazy Loading**: Routes loaded on-demand
- **Component Auto-import**: Only imported components bundled
- **Table Virtualization**: Large tables use virtual scrolling
- **Image Optimization**: WebP format, lazy loading
- **Code Splitting**: Third-party libraries separated

### Miniprogram

- **Mock Mode**: Speeds up development without network
- **Image Lazy Loading**: Images load on scroll
- **Component Reuse**: Shared components across pages
- **State Persistence**: Reduces API calls on app restart

---

## Debugging Tips

### Manager

- **Vue DevTools**: Browser extension for component inspection
- **Network Tab**: Check API calls and responses
- **Console**: Check for TypeScript errors
- **Pinia DevTools**: Inspect state changes
- **Router Logs**: Enable in `router/guards/beforeEach.ts`

### Miniprogram

- **WeChat DevTools**: Built-in debugger
- **Console Logs**: Check mock data and API calls
- **Mock Mode**: Toggle `USE_MOCK` to test with/without backend
- **Role Switching**: Login page allows role selection for testing
- **Pinia State**: Check `src/store/modules/` for state structure

---

## Recent Optimization Work

The miniprogram has undergone significant UI/UX improvements:
- **Message Center**: Redesigned with glass-morphism cards, pulsing badges
- **Background Colors**: Optimized to warm tones (pink/peach/coral)
- **Decorator Lines**: Removed from message cards for cleaner design
- **Badge Design**: Changed from text to animated pulsing dots
- **Code Quality**: Extracted utilities, composables, and constants

See `miniprogram/CODE_OPTIMIZATION_TASKS.md` for detailed optimization history.

---

## When to Use Each Project

- **Manager**: Admin dashboard for system management, data visualization, user/role management
- **Miniprogram**: Student-facing mobile app for applying for accommodations, checking status, reporting repairs

Both share similar patterns but are deployed separately.
