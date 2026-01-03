<!-- 床位管理页面 -->
<template>
  <div class="bed-page art-full-height">
    <ElCard class="art-table-card" shadow="never">
      <ElEmpty description="功能开发中..." />
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  defineOptions({ name: 'Bed' })
</script>

<style scoped lang="scss">
  .bed-page {
    :deep(.el-empty) {
      padding: 60px 0;
    }
  }
</style>
