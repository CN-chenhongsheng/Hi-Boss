<!-- 报修详情 Drawer 抽屉 -->
<template>
  <ArtDrawer
    v-model="drawerVisible"
    title="报修详情"
    :loading="loading"
    :with-header="true"
    @close="handleClose"
  >
    <div class="repair-detail-content">
      <!-- 顶部报修卡片 -->
      <ArtRepairHeaderCard :repair="repairDetail" />

      <!-- 标签页内容 -->
      <ElTabs v-model="activeTab" class="repair-detail-tabs">
        <!-- 基本信息 -->
        <ElTabPane label="基本信息" name="basic">
          <ArtBasicInfo :data="repairDetail?.studentInfo ?? {}" />
        </ElTabPane>

        <!-- 故障描述 -->
        <ElTabPane label="故障描述" name="fault">
          <div class="fault-description">
            <p>{{ repairDetail.faultDescription || '暂无描述' }}</p>
            <div v-if="faultImages.length > 0" class="image-list">
              <ElImage
                v-for="(img, index) in faultImages"
                :key="index"
                :src="img"
                :preview-src-list="faultImages"
                fit="cover"
                class="fault-image"
              />
            </div>
          </div>
        </ElTabPane>

        <!-- 维修信息 -->
        <ElTabPane label="维修信息" name="repair">
          <template v-if="showRepairInfo">
            <el-descriptions :column="1" border>
              <el-descriptions-item label="维修人员">
                {{ repairDetail.repairPersonName || '-' }}
              </el-descriptions-item>
              <el-descriptions-item label="预约时间">
                {{ repairDetail.appointmentTime || '-' }}
              </el-descriptions-item>
              <el-descriptions-item v-if="repairDetail.repairResult" label="维修结果">
                {{ repairDetail.repairResult }}
              </el-descriptions-item>
              <el-descriptions-item v-if="repairImages.length > 0" label="维修后图片">
                <div class="image-list">
                  <ElImage
                    v-for="(img, index) in repairImages"
                    :key="index"
                    :src="img"
                    :preview-src-list="repairImages"
                    fit="cover"
                    class="fault-image"
                  />
                </div>
              </el-descriptions-item>
            </el-descriptions>
          </template>
          <p v-else class="empty-placeholder">暂无维修信息</p>
        </ElTabPane>

        <!-- 评价信息 -->
        <ElTabPane label="评价信息" name="rating">
          <template v-if="repairDetail.rating">
            <el-descriptions :column="1" border>
              <el-descriptions-item label="评分">
                <ElRate v-model="repairDetail.rating" disabled />
              </el-descriptions-item>
              <el-descriptions-item label="评价内容">
                {{ repairDetail.ratingComment || '暂无评价' }}
              </el-descriptions-item>
            </el-descriptions>
          </template>
          <p v-else class="empty-placeholder">暂无评价</p>
        </ElTabPane>
      </ElTabs>

      <!-- 操作按钮 -->
      <div v-if="showActions" class="action-buttons">
        <ElButton
          v-if="canAccept"
          type="primary"
          @click="handleAccept"
          v-ripple
          v-permission="'repair:accept'"
        >
          接单
        </ElButton>
        <ElButton
          v-if="canComplete"
          type="success"
          @click="handleComplete"
          v-ripple
          v-permission="'repair:complete'"
        >
          完成维修
        </ElButton>
      </div>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
  import { ref, computed, watch } from 'vue'
  import {
    ElButton,
    ElImage,
    ElRate,
    ElDescriptions,
    ElDescriptionsItem,
    ElMessage,
    ElMessageBox,
    ElTabs,
    ElTabPane
  } from 'element-plus'
  import ArtDrawer from '@/components/core/layouts/art-drawer/index.vue'
  import ArtBasicInfo from '@/components/core/layouts/art-basic-info/index.vue'
  import ArtRepairHeaderCard from '@/components/core/cards/art-repair-header-card/index.vue'
  import { fetchGetRepairDetail, fetchAcceptRepair, fetchCompleteRepair } from '@/api/repair-manage'

  defineOptions({ name: 'RepairDrawer' })

  type RepairListItem = {
    id: number
    studentId?: number
    studentName?: string
    studentNo?: string
    roomCode?: string
    bedCode?: string
    repairType: number
    repairTypeText?: string
    faultDescription?: string
    faultImages?: string | string[]
    urgentLevel: number
    urgentLevelText?: string
    status: number
    statusText?: string
    repairPersonId?: number
    repairPersonName?: string
    appointmentTime?: string
    completeTime?: string
    repairResult?: string
    repairImages?: string | string[]
    rating?: number
    ratingComment?: string
    createTime?: string
  }

  interface Props {
    visible: boolean
    repairId: number | null
    repairData?: RepairListItem | null
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'close'): void
    (e: 'refresh'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    visible: false,
    repairId: null,
    repairData: null
  })

  const emit = defineEmits<Emits>()

  const drawerVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  const activeTab = ref('basic')
  const loading = ref(false)
  const repairDetail = ref<Partial<RepairListItem>>({})

  // 故障图片
  const faultImages = computed(() => {
    if (repairDetail.value.faultImages) {
      return Array.isArray(repairDetail.value.faultImages)
        ? repairDetail.value.faultImages
        : JSON.parse(repairDetail.value.faultImages as unknown as string)
    }
    return []
  })

  // 维修后图片
  const repairImages = computed(() => {
    if (repairDetail.value.repairImages) {
      return Array.isArray(repairDetail.value.repairImages)
        ? repairDetail.value.repairImages
        : JSON.parse(repairDetail.value.repairImages as unknown as string)
    }
    return []
  })

  // 是否显示维修信息
  const showRepairInfo = computed(() => {
    const status = repairDetail.value.status
    return status && status >= 2
  })

  // 是否显示操作按钮
  const showActions = computed(() => {
    const status = repairDetail.value.status
    return status && [1, 2, 3].includes(status)
  })

  // 是否可以接单
  const canAccept = computed(() => {
    return repairDetail.value.status === 1
  })

  // 是否可以完成
  const canComplete = computed(() => {
    const status = repairDetail.value.status
    return status === 2 || status === 3
  })

  // 加载报修详情
  const loadData = async () => {
    if (!props.repairId) {
      repairDetail.value = props.repairData || {}
      return
    }

    try {
      loading.value = true
      const res = await fetchGetRepairDetail(props.repairId)
      repairDetail.value = res || null
    } catch (error) {
      if (props.repairData) {
        repairDetail.value = props.repairData
      }
      ElMessage.error('获取详情失败')
      console.error('获取详情失败:', error)
    } finally {
      loading.value = false
    }
  }

  // 接单
  const handleAccept = async () => {
    if (!props.repairId) return

    try {
      await ElMessageBox.confirm('确定要接单吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      loading.value = true
      await fetchAcceptRepair(props.repairId)
      ElMessage.success('接单成功')
      emit('refresh')
      loadData()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error('接单失败')
        console.error('接单失败:', error)
      }
    } finally {
      loading.value = false
    }
  }

  // 完成维修
  const handleComplete = async () => {
    if (!props.repairId) return

    try {
      await ElMessageBox.confirm('确定要完成维修吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      loading.value = true
      await fetchCompleteRepair(props.repairId, {
        repairResult: '已完成维修',
        repairImages: []
      })
      ElMessage.success('操作成功')
      emit('refresh')
      loadData()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error('操作失败')
        console.error('完成维修失败:', error)
      }
    } finally {
      loading.value = false
    }
  }

  // 关闭抽屉
  const handleClose = () => {
    emit('update:visible', false)
    emit('close')
  }

  // 监听抽屉显示状态
  watch(
    () => props.visible,
    (newVal) => {
      if (newVal) {
        activeTab.value = 'basic'
        loadData()
      }
    }
  )

  // 监听报修ID变化
  watch(
    () => props.repairId,
    () => {
      if (props.visible) {
        loadData()
      }
    }
  )

  // 监听 repairData 变化
  watch(
    () => props.repairData,
    (newVal) => {
      if (props.visible && newVal && !props.repairId) {
        repairDetail.value = newVal
      }
    }
  )
</script>

<style lang="scss" scoped>
  .repair-detail-content {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 0;
  }

  .repair-detail-tabs {
    :deep(.el-tabs__header) {
      padding: 0;
      margin: 0 0 24px;
    }

    :deep(.el-tabs__nav-wrap::after) {
      background-color: var(--el-border-color-lighter);
    }

    :deep(.el-tabs__item) {
      height: 48px;
      padding: 0 20px;
      font-size: 15px;
      font-weight: 500;
      line-height: 48px;

      &.is-active {
        font-weight: 600;
        color: var(--el-color-primary);
      }
    }

    :deep(.el-tabs__content) {
      padding: 0;
    }

    :deep(.el-tab-pane) {
      padding: 0;
    }
  }

  .empty-placeholder {
    padding: 16px 0;
    margin: 0;
    font-size: 14px;
    color: var(--el-text-color-secondary);
  }

  .fault-description {
    p {
      margin: 0 0 12px;
      line-height: 1.6;
      color: var(--el-text-color-primary);
    }
  }

  .image-list {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .fault-image {
    width: 80px;
    height: 80px;
    cursor: pointer;
    border-radius: 4px;
  }

  .action-buttons {
    display: flex;
    gap: 16px;
    justify-content: center;
    padding-top: 16px;
    border-top: 1px solid var(--el-border-color-lighter);
  }
</style>
