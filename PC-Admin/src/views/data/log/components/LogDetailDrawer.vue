<template>
  <ArtDrawer v-model="dialogVisible" title="日志详情" size="400px" :destroy-on-close="true">
    <div class="log-detail-drawer" v-if="logData">
      <!-- 头部信息区域 -->
      <div class="detail-header">
        <div
          class="operation-type"
          :class="{ success: logData.result === '成功', error: logData.result === '失败' }"
        >
          <el-icon><component :is="getOperationIcon(logData.operationType)"></component></el-icon>
          <span>{{ logData.operationType }}</span>
        </div>
        <div class="operation-time">
          <el-icon><Calendar /></el-icon>
          <span>{{ logData.create_time }}</span>
        </div>
      </div>

      <!-- 操作结果状态 -->
      <div
        class="result-badge"
        :class="{ success: logData.result === '成功', error: logData.result === '失败' }"
      >
        {{ logData.result }}
        <el-icon v-if="logData.result === '成功'"><CircleCheckFilled /></el-icon>
        <el-icon v-else><CircleCloseFilled /></el-icon>
      </div>

      <!-- 用户信息卡片 -->
      <el-card class="info-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <el-icon><User /></el-icon>
            <span>用户信息</span>
          </div>
        </template>
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="info-item">
              <span class="label">姓名</span>
              <span class="value">{{ logData.username }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="info-item">
              <span class="label">账号</span>
              <span class="value">{{ logData.account }}</span>
            </div>
          </el-col>
        </el-row>
      </el-card>

      <!-- 操作详情卡片 -->
      <el-card class="info-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <el-icon><Document /></el-icon>
            <span>操作详情</span>
          </div>
        </template>
        <div class="content-box">
          <span class="label">操作内容</span>
          <div class="content-value">{{ logData.content }}</div>
        </div>
      </el-card>

      <!-- 系统信息卡片 -->
      <el-card class="info-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <el-icon><Monitor /></el-icon>
            <span>系统信息</span>
          </div>
        </template>
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="info-item">
              <span class="label">IP地址</span>
              <div class="value-with-action">
                <span>{{ logData.ip }}</span>
                <el-tooltip content="复制IP地址" placement="top">
                  <el-icon class="copy-icon" @click="copyToClipboard(logData.ip)">
                    <CopyDocument />
                  </el-icon>
                </el-tooltip>
              </div>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="info-item">
              <span class="label">浏览器</span>
              <span class="value">{{ logData.browser }}</span>
            </div>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <div class="info-item">
          <span class="label">请求耗时</span>
          <span class="value performance" :class="getPerformanceClass(logData.status)">
            {{ logData.status }}
          </span>
        </div>
      </el-card>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import ArtDrawer from '@/components/core/others/ArtDrawer.vue'
import { ElMessage } from 'element-plus'
import {
  User,
  Document,
  Monitor,
  Calendar,
  CopyDocument,
  CircleCheckFilled,
  CircleCloseFilled
} from '@element-plus/icons-vue'

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

// 根据操作类型返回对应图标
const getOperationIcon = (type: string) => {
  const iconMap: Record<string, string> = {
    登录: 'Lock',
    查询: 'Search',
    新增: 'Document',
    修改: 'EditPen',
    删除: 'Delete',
    导出: 'Download',
    导入: 'Upload',
    刷新: 'RefreshRight'
  }
  return iconMap[type] || 'Document'
}

// 获取性能类别
const getPerformanceClass = (status: string) => {
  const time = parseInt(status)
  if (isNaN(time)) return ''

  if (time < 100) return 'fast'
  if (time < 200) return 'normal'
  return 'slow'
}

// 复制到剪贴板
const copyToClipboard = (text: string) => {
  navigator.clipboard
    .writeText(text)
    .then(() => {
      ElMessage.success('IP地址已复制到剪贴板')
    })
    .catch(() => {
      ElMessage.error('复制失败')
    })
}
</script>

<style lang="scss" scoped>
.log-detail-drawer {
  padding: 16px;

  .detail-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;

    .operation-type {
      font-size: 18px;
      font-weight: bold;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 6px 12px;
      border-radius: 4px;
      background-color: #f0f2f5;

      &.success {
        color: #67c23a;
      }

      &.error {
        color: #f56c6c;
      }
    }

    .operation-time {
      color: #909399;
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }

  .result-badge {
    display: inline-flex;
    align-items: center;
    padding: 4px 12px;
    border-radius: 16px;
    margin-bottom: 20px;
    font-weight: 500;
    gap: 4px;

    &.success {
      background-color: #f0f9eb;
      color: #67c23a;
      border: 1px solid #e1f3d8;
    }

    &.error {
      background-color: #fef0f0;
      color: #f56c6c;
      border: 1px solid #fde2e2;
    }
  }

  .info-card {
    margin-bottom: 16px;
    border-radius: 8px;
    overflow: hidden;

    .card-header {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 16px;
      font-weight: bold;
    }

    .info-item {
      margin-bottom: 12px;

      &:last-child {
        margin-bottom: 0;
      }

      .label {
        display: block;
        margin-bottom: 4px;
        color: #606266;
        font-size: 13px;
      }

      .value {
        font-size: 14px;
        color: #303133;
        word-break: break-all;

        &.performance {
          font-weight: bold;
          &.fast {
            color: #67c23a;
          }
          &.normal {
            color: #e6a23c;
          }
          &.slow {
            color: #f56c6c;
          }
        }
      }

      .value-with-action {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;

        .copy-icon {
          cursor: pointer;
          color: #909399;
          transition: color 0.3s;

          &:hover {
            color: #409eff;
          }
        }
      }
    }

    .content-box {
      .label {
        display: block;
        margin-bottom: 8px;
        color: #606266;
        font-size: 13px;
      }

      .content-value {
        font-size: 15px;
        line-height: 1.6;
        padding: 10px;
        background-color: #f9f9f9;
        border-radius: 4px;
        border-left: 3px solid #409eff;
      }
    }
  }
}
</style>
