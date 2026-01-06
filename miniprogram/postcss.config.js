/**
 * PostCSS 配置
 * 使用 weapp-tailwindcss 处理小程序环境
 */
module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    require('weapp-tailwindcss/css/postcss')
  ]
}
