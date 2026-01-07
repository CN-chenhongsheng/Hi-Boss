<template>
  <view class="statistics-page">
    <view class="tip">
      数据统计功能请在 TabBar 的"统计"页面查看
    </view>
  </view>
</template>

<script setup lang="ts">
// 这个页面已经移到 pages/tab/statistics/index.vue
// 保留此文件仅为兼容 pages.json 配置
</script>

<style lang="scss" scoped>
.statistics-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f5f5;

  .tip {
    font-size: 28rpx;
    text-align: center;
    color: #999;
  }
}
</style>
