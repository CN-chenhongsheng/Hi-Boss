import pluginJs from '@eslint/js'
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended'
import pluginVue from 'eslint-plugin-vue'
import globals from 'globals'
import tseslint from 'typescript-eslint'

export default [
  // 指定文件匹配规则
  {
    files: ['**/*.{js,mjs,cjs,ts,vue}']
  },
  // 指定全局变量和环境
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        uni: 'readonly',
        plus: 'readonly',
        wx: 'readonly',
        getCurrentPages: 'readonly',
        getApp: 'readonly'
      }
    }
  },
  // 扩展配置
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
  ...pluginVue.configs['flat/essential'],
  // 自定义规则
  {
    files: ['**/*.{js,mjs,cjs,ts,vue}'],
    rules: {
      quotes: ['error', 'single'],
      semi: ['error', 'never'],
      'no-var': 'error',
      '@typescript-eslint/no-explicit-any': 'off',
      'vue/multi-word-component-names': 'off',
      'no-multiple-empty-lines': ['warn', { max: 1 }],
      'no-unexpected-multiline': 'error'
    }
  },
  // vue 规则
  {
    files: ['**/*.vue'],
    languageOptions: {
      parserOptions: {
        parser: tseslint.parser
      }
    }
  },
  // 忽略文件
  {
    ignores: ['node_modules', 'dist', 'unpackage', '.vscode/**', 'static/**']
  },
  // prettier 配置
  eslintPluginPrettierRecommended
]
