<template>
  <ArtDrawer
    v-model="dialogVisible"
    title="日志详情"
    direction="rtl"
    size="500px"
    :destroy-on-close="true"
    modal-class="setting-modal"
  >
    <div class="log-detail-drawer" v-if="logData">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="操作人姓名">{{ logData.username }}</el-descriptions-item>
        <el-descriptions-item label="操作人账号">{{ logData.account }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">{{ logData.operationType }}</el-descriptions-item>
        <el-descriptions-item label="操作内容">{{ logData.content }}</el-descriptions-item>
        <el-descriptions-item label="操作结果">{{ logData.result }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ logData.ip }}</el-descriptions-item>
        <el-descriptions-item label="浏览器">{{ logData.browser }}</el-descriptions-item>
        <el-descriptions-item label="请求耗时">{{ logData.status }}</el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ logData.create_time }}</el-descriptions-item>
      </el-descriptions>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import ArtDrawer from '@/components/core/others/ArtDrawer.vue'

// 日志项接口定义
export interface LogItem {
  username: string
  account: string
  operationType: string
  content: string
  result: string
  ip: string
  browser: string
  status: string
  create_time: string
}

// 定义组件属性
const props = defineProps<{
  modelValue: boolean
  data: LogItem | null
}>()

// 定义组件事件
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
}>()

// 双向绑定抽屉显示状态
const dialogVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

// 日志数据
const logData = computed(() => props.data)
</script>

<style lang="scss" scoped>
.log-detail-drawer {
  padding: 10px;
  
  :deep(.el-descriptions__label) {
    width: 120px;
    font-weight: bold;
  }
}
</style> 