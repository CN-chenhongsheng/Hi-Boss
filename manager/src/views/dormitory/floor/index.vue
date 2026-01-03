<!-- 楼层管理页面 -->
<template>
  <div class="floor-page art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <ElEmpty description="功能开发中..." />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  defineOptions({ name: 'Floor' })
</script>

<style scoped lang="scss">
  .floor-page {
    :deep(.el-empty) {
      padding: 60px 0;
    }
  }
</style>
