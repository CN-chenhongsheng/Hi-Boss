English | [简体中文](./README.md)

## About Art Design Pro

As a developer, I needed to build admin management systems for multiple projects but found that traditional systems couldn't fully meet the requirements for user experience and visual design. Therefore, I created an open-source admin management solution focused on user experience and rapid development. Based on the ElementPlus design specifications, it has been visually optimized to provide a more beautiful and practical front-end interface, helping you easily build high-quality admin systems.

## Demo Images

### Light Theme

![Light Theme](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover1.png)

![Light Theme](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover2.png)

### Dark Theme

![Dark Theme](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover3.png)

![Dark Theme](https://www.qiniu.lingchen.kim/art_design_pro_readme_cover4.png)

## Features

- Uses the latest technology stack
- Built-in common business component templates
- Provides multiple theme modes and customizable themes
- Beautiful UI design, excellent user experience, and attention to detail
- System fully supports customization, meeting your personalized needs

## Functionality

- Rich theme switching
- Global search
- Lock screen
- Multi-tabs
- Global breadcrumbs
- Multi-language support
- Icon library
- Rich text editor
- Echarts charts
- Utils toolkit
- Network exception handling
- Route-level authentication
- Sidebar menu authentication
- Authentication directives
- Mobile adaptation
- Excellent persistent storage solution
- Local data storage validation
- Code commit validation and formatting
- Code commit standardization

## Compatibility

- Supports modern mainstream browsers such as Chrome, Safari, Firefox, etc.

## Installation and Running

```bash
# Install dependencies
pnpm install

# If pnpm install fails, try using the following command to install dependencies
pnpm install --ignore-scripts

# Start local development environment
pnpm dev

# Build for production
pnpm build
```

## Development Plan

### Project Structure

```
src
├── api                   # API interface management
├── assets                # Static resources
├── components            # Global common components
├── composables           # Composition functions
├── config                # Global configuration
├── directives            # Custom directives
├── enums                 # Enum definitions
├── language              # Internationalization language packs
├── mock                  # Data simulation
├── plugins               # Plugin configurations
├── router                # Route configurations
├── store                 # State management
├── types                 # Type definitions
├── utils                 # Global utility functions
├── views                 # Page components
├── App.vue               # Root component
├── env.d.ts              # Environment variable type declarations
└── main.ts               # Entry file
```

### Development Standards

1. **Naming Conventions**
   - Folders: lowercase letters + hyphens (e.g., user-info)
   - Component files: PascalCase (e.g., UserInfo.vue)
   - Utility class files: camelCase (e.g., formatDate.ts)
   - CSS class names: BEM naming convention (e.g., .user-card__title--primary)

2. **Code Commit Standards**
   - Use commitizen to standardize commit messages
   - Run lint-staged before committing for code checking and formatting
   - Follow commit message specifications configured in commitlint

3. **Component Development Standards**
   - Prioritize using Composition API
   - Split components by functionality, maintaining single responsibility
   - Place common components in the components directory, page components in the views directory
   - Component props must define types and default values

4. **Style Standards**
   - Use SCSS preprocessor
   - Follow style specifications configured in stylelint
   - Place global styles in the assets/styles directory
   - Use scoped or CSS modules to isolate component styles

### Development Process

1. **Environment Setup**
   - Install Node.js (recommended v16+) and pnpm
   - Clone the repository and install dependencies
   - Configure editor (recommended VSCode) with ESLint, Prettier, and Volar plugins

2. **Feature Development**
   - Create new branches based on requirements (e.g., feature/user-management)
   - Self-test after development completion
   - Run lint and build to check code quality
   - Commit code and create merge requests

3. **Testing and Deployment**
   - Execute unit tests and integration tests
   - Deploy to testing environment for functional verification
   - Fix discovered issues
   - Deploy to production environment

### Performance Optimization

1. **Code Splitting**
   - Lazy loading routes
   - Import components on demand
   - Import third-party libraries as needed

2. **Resource Optimization**
   - Image compression and WebP format conversion
   - CSS and JavaScript code minification
   - Enable gzip/brotli compression

3. **Caching Strategy**
   - Sensible use of browser cache
   - Implement data persistence storage
   - Optimize API call frequency

4. **Rendering Optimization**
   - Virtual lists for handling large data rendering
   - Avoid unnecessary component re-rendering
   - Use Suspense and async components

## Detailed Development Rules

### 1. Code Style Guidelines

#### 1.1 JavaScript/TypeScript
- Use TypeScript for all new features
- Avoid using `any` type unless absolutely necessary
- Utilize ES6+ syntax features like arrow functions, destructuring, and template literals
- Use camelCase for variables and functions
- Use UPPER_SNAKE_CASE for constants
- Use PascalCase for types and interfaces
- Avoid nesting callbacks or Promise chains more than three levels deep

#### 1.2 Vue Components
- Use Composition API instead of Options API
- Use PascalCase for component names
- Single-file component order: `<script>`, `<template>`, `<style>`
- Component options order: name, components, props, emits, setup
- Props must declare types and default values
- Use kebab-case for event names (e.g., `@click-item`)
- Avoid complex expressions in templates, extract them as computed properties

#### 1.3 CSS/SCSS
- Use SCSS preprocessor
- Follow BEM naming convention: `.block__element--modifier`
- Use CSS variables for global theming
- Use `scoped` or CSS Modules for component styles
- Write media queries with a mobile-first approach
- Avoid using `!important`

### 2. Project Structure Guidelines

#### 2.1 File Organization
- Organize files by feature modules, not by file type
- Keep related functionality files in the same directory
- Place page components in the `views` directory and reusable components in the `components` directory
- Categorize utility functions in subfolders within the `utils` directory
- Organize API interfaces by business modules in the `api` directory

#### 2.2 Naming Conventions
- Use lowercase letters with hyphens for folders (e.g., `user-profile`)
- Use PascalCase for component files (e.g., `UserProfile.vue`)
- Use camelCase for utility files (e.g., `formatDate.ts`)
- Add `.spec.ts` or `.test.ts` suffix for test files
- Use `.d.ts` suffix or place type definition files in the `types` directory

### 3. Git Workflow Guidelines

#### 3.1 Branch Management
- Keep `main` branch stable and ready for release
- Use `develop` as the main development branch
- Use `feature/feature-name` branches for feature development
- Use `bugfix/issue-description` branches for bug fixes
- Use `hotfix/issue-description` branches for urgent fixes

#### 3.2 Commit Guidelines
- Use commitizen and cz-git for standardized commits
- Commit types:
  - `feat`: New features
  - `fix`: Bug fixes
  - `docs`: Documentation changes
  - `style`: Code formatting (no code logic changes)
  - `refactor`: Code refactoring (neither new features nor bug fixes)
  - `perf`: Performance improvements
  - `test`: Adding or modifying tests
  - `build`: Build system or external dependency changes
  - `ci`: CI configuration files and scripts changes
  - `chore`: Other changes not modifying source code or tests
- Commit message format: `type(scope): brief description`
- Make atomic commits that focus on a single task

### 4. Component Development Guidelines

#### 4.1 General Principles
- Follow the single responsibility principle for component design
- Prefer functional components
- Use `defineProps` and `defineEmits` to declare props and events
- Break down large components into smaller ones
- Avoid nesting components more than three levels deep

#### 4.2 State Management
- Use Pinia for state management
- Organize stores by business domains
- Use `ref` and `reactive` for simple component state
- Use VueUse's `useForm` or custom hooks for complex form states
- Avoid overusing global state, prioritize component communication

#### 4.3 Performance Optimization
- Use `computed` appropriately to cache calculation results
- Use virtual scrolling for large lists
- Use `v-once` or `v-memo` to reduce unnecessary rendering
- Use `shallowRef` and `shallowReactive` for large objects
- Load components on demand using async components

### 5. API Call Guidelines

#### 5.1 Request Encapsulation
- Use Axios for consistent HTTP request handling
- Organize request functions by business modules
- Configure request URLs using environment variables
- Use TypeScript type definitions for request parameters and response results

#### 5.2 Error Handling
- Handle common errors (e.g., 401, 404, 500) globally
- Handle business errors in respective business modules
- Use try-catch for handling asynchronous request exceptions
- Provide user-friendly error messages and recovery mechanisms

### 6. Testing Guidelines

#### 6.1 Unit Testing
- Core functionality of business components must have unit tests
- Utility functions must have unit tests
- Test coverage target: line coverage > 80%
- Use Vitest for unit testing
- Mock API calls and external dependencies

#### 6.2 Integration Testing
- Critical business flows need integration tests
- Test component interactions and state management
- Verify route navigation and page rendering
- Test form submission and data processing

### 7. Documentation Guidelines

#### 7.1 Code Comments
- Public functions, components, and types must have JSDoc comments
- Complex logic needs explanatory comments
- Temporary code needs TODO comments with processing plans
- Avoid meaningless comments, code should be self-explanatory

#### 7.2 Component Documentation
- Every reusable component needs usage examples and documentation
- Documentation includes: component description, props, events, slots
- Provide online demos for key components
- Update documentation when updating components

### 8. Security Guidelines

#### 8.1 Frontend Security
- Prevent XSS: Escape user input
- Prevent CSRF: Use CSRF Tokens
- Don't store sensitive data directly on the frontend
- Use HTTPS for data transmission
- Avoid passing sensitive information in URL parameters

#### 8.2 Authentication and Authorization
- Use JWT for authentication
- Implement fine-grained permission control
- Require confirmation for sensitive operations
- Automatically log out inactive sessions
- Log security-related operations

### 9. Performance Optimization Guidelines

#### 9.1 Loading Optimization
- Implement lazy loading for route components
- Use appropriate image sizes and formats (WebP/AVIF)
- Import third-party libraries on demand
- Use Tree-shaking to reduce bundle size
- Implement pagination for long lists

#### 9.2 Runtime Optimization
- Use Web Workers for complex calculations
- Cache repeated request data
- Avoid frequent DOM operations
- Reduce unnecessary calculations and rendering
- Display large forms in steps

### 10. Release and Deployment Guidelines

#### 10.1 Build Process
- Use environment variables to distinguish development, testing, and production environments
- Enable code compression and optimization for production builds
- Generate sourcemaps for issue locating
- Automatically generate build reports to analyze package size

#### 10.2 Deployment Process
- Use CI/CD for automated building and deployment
- Run automated tests to ensure quality
- Implement blue-green deployment or canary releases
- Maintain version rollback capability
- Monitor application performance and errors post-deployment