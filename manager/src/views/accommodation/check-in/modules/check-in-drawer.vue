<!-- 入住申请详情 Drawer 抽屉 -->
<template>
  <ArtDrawer
    v-model="drawerVisible"
    title="入住申请详情"
    :loading="loading"
    :with-header="true"
    @close="handleClose"
  >
    <div class="check-in-detail-content">
      <!-- 顶部用户卡片 -->
      <ArtStudentHeaderCard :student="studentData" />

      <!-- 标签页内容 -->
      <ElTabs v-model="activeTab" class="check-in-detail-tabs">
        <!-- 学生信息标签页 -->
        <ElTabPane label="学生信息" name="student">
          <ArtBasicInfo :data="studentData" />
        </ElTabPane>

        <!-- 审批信息标签页 -->
        <ElTabPane label="审批信息" name="approval">
          <CheckInApprovalInfo
            business-type="check_in"
            :business-id="checkInId"
            :check-in-data="checkInDetail"
            @approval-success="handleApprovalSuccess"
          />
        </ElTabPane>
      </ElTabs>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
  import { ref, watch, computed } from 'vue'
  import { ElTabs, ElTabPane } from 'element-plus'
  import ArtDrawer from '@/components/core/layouts/art-drawer/index.vue'
  import ArtBasicInfo from '@/components/core/layouts/art-basic-info/index.vue'
  import ArtStudentHeaderCard from '@/components/core/cards/art-student-header-card/index.vue'
  import CheckInApprovalInfo from './check-in-approval-info.vue'
  import { fetchGetCheckInDetail, fetchGetStudentDetail } from '@/api/accommodation-manage'
  import { ElMessage } from 'element-plus'

  defineOptions({ name: 'CheckInDrawer' })

  type CheckInListItem = Api.AccommodationManage.CheckInListItem
  type StudentDetail = Api.AccommodationManage.StudentDetail

  interface Props {
    /** 是否显示 */
    visible: boolean
    /** 入住申请ID */
    checkInId: number | null
    /** 可选的入住申请数据（用于避免重复请求） */
    checkInData?: CheckInListItem | null
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'close'): void
    (e: 'approval-success'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    visible: false,
    checkInId: null,
    checkInData: null
  })

  const emit = defineEmits<Emits>()

  const drawerVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  const activeTab = ref('student')
  const loading = ref(false)
  const checkInDetail = ref<CheckInListItem | null>(null)
  const studentData = ref<Partial<StudentDetail>>({})

  // 加载入住申请详情和学生信息
  const loadData = async () => {
    if (!props.checkInId) {
      checkInDetail.value = null
      studentData.value = {}
      return
    }

    try {
      loading.value = true

      // 如果有传入的 checkInData，直接使用，否则请求详情
      if (props.checkInData) {
        checkInDetail.value = props.checkInData
      } else {
        const checkInRes = await fetchGetCheckInDetail(props.checkInId)
        checkInDetail.value = checkInRes || null
      }

      // 根据入住申请中的 studentId 获取学生详情
      if (checkInDetail.value) {
        const studentId = checkInDetail.value.studentId
        if (studentId) {
          const studentRes = await fetchGetStudentDetail(studentId)
          if (studentRes) {
            studentData.value = studentRes
          }
        } else {
          // 如果没有 studentId，使用入住申请中的学生基本信息
          studentData.value = {
            studentNo: checkInDetail.value.studentNo,
            studentName: checkInDetail.value.studentName
          }
        }
      }
    } catch (error) {
      ElMessage.error('获取详情失败')
      console.error('获取详情失败:', error)
    } finally {
      loading.value = false
    }
  }

  // 监听抽屉显示状态
  watch(
    () => props.visible,
    (newVal) => {
      if (newVal) {
        activeTab.value = 'student'
        loadData()
      }
    }
  )

  // 监听入住申请ID变化
  watch(
    () => props.checkInId,
    () => {
      if (props.visible) {
        loadData()
      }
    }
  )

  // 关闭抽屉
  const handleClose = () => {
    emit('update:visible', false)
    emit('close')
  }

  // 审批成功处理
  const handleApprovalSuccess = () => {
    emit('approval-success')
  }
</script>

<style lang="scss" scoped>
  .check-in-detail-content {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 0;
  }

  // 标签页样式
  .check-in-detail-tabs {
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
</style>
