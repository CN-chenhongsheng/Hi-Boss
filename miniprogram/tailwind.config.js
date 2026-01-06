/**
 * Tailwind CSS 配置
 * 使用 weapp-tailwindcss 适配小程序环境
 * 注意：PostCSS 需要 CommonJS 格式
 */
const { uniPreset } = require('weapp-tailwindcss')

module.exports = {
  presets: [uniPreset()],
  content: [
    './pages/**/*.{vue,js,ts,jsx,tsx}',
    './components/**/*.{vue,js,ts,jsx,tsx}',
    './App.vue'
  ],
  corePlugins: {
    // 禁用 preflight，避免与小程序默认样式冲突
    preflight: false
  },
  theme: {
    extend: {
      // 自定义主题扩展
      colors: {
        // 主题色（与后端管理系统保持一致）
        primary: {
          DEFAULT: '#5D87FF',
          light: '#7B9FFF',
          dark: '#4A6FE6'
        },
        // 功能色
        success: {
          DEFAULT: '#4cd964',
          light: '#6EE085',
          dark: '#3CB853'
        },
        warning: {
          DEFAULT: '#f0ad4e',
          light: '#F5C478',
          dark: '#E09A3A'
        },
        error: {
          DEFAULT: '#dd524d',
          light: '#E67672',
          dark: '#C9403B'
        },
        // 灰度色
        gray: {
          50: '#fafafa',
          100: '#f5f5f5',
          200: '#eeeeee',
          300: '#e0e0e0',
          400: '#bdbdbd',
          500: '#9e9e9e',
          600: '#757575',
          700: '#616161',
          800: '#424242',
          900: '#212121'
        },
        // 背景色
        bg: {
          DEFAULT: '#f5f5f5',
          card: '#ffffff',
          mask: 'rgba(0, 0, 0, 0.4)'
        }
      },
      // 圆角
      borderRadius: {
        card: '16rpx',
        btn: '8rpx'
      },
      // 间距
      spacing: {
        page: '32rpx',
        card: '24rpx'
      },
      // 字体大小
      fontSize: {
        xs: '24rpx',
        sm: '26rpx',
        base: '28rpx',
        lg: '32rpx',
        xl: '36rpx',
        '2xl': '40rpx'
      }
    }
  },
  plugins: []
}
