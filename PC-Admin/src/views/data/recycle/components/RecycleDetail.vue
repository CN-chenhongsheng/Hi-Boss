<template>
  <ArtDrawer v-model="modelValue" title="删除数据详情" direction="rtl" size="50%">
    <div v-if="data" class="data-detail">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="操作人">{{ data.operator }}</el-descriptions-item>
        <el-descriptions-item label="请求接口">{{ data.api }}</el-descriptions-item>
        <el-descriptions-item label="删除时间">{{ data.operateTime }}</el-descriptions-item>
        <el-descriptions-item label="删除条数">{{ data.deleteCount }}</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">请求参数</el-divider>
      <el-card shadow="never">
        <pre class="params-code">{{ formatJson(data.params) }}</pre>
      </el-card>

      <el-divider content-position="left">删除的数据</el-divider>
      <el-card shadow="never">
        <pre class="params-code">{{ formatJson(data.deletedData) }}</pre>
      </el-card>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
import ArtDrawer from '@/components/core/others/ArtDrawer.vue'

// 定义接口
export interface RecycleItem {
  id: number
  operator: string
  api: string
  params: any
  deletedData: any
  deleteCount: number
  operateTime: string
}

// 定义props
const props = defineProps<{
  modelValue: boolean
  data: RecycleItem | null
}>()

// 定义事件
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
}>()

// 双向绑定
const modelValue = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

// 格式化JSON字符串
const formatJson = (json: any) => {
  if (typeof json === 'string') {
    try {
      return JSON.stringify(JSON.parse(json), null, 2)
    } catch (e) {
      console.log(e)
      return json
    }
  }
  return JSON.stringify(json, null, 2)
}
</script>

<style lang="scss" scoped>
.data-detail {
  padding: 16px;

  .params-code {
    margin: 0;
    white-space: pre-wrap;
    word-break: break-all;
    font-family: Consolas, Monaco, monospace;
    font-size: 14px;
    line-height: 1.5;
    background-color: #f8f8f8;
    padding: 10px;
    border-radius: 4px;
    max-height: 300px;
    overflow: auto;
  }
}
</style>
