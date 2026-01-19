<!-- 入住申请详情 Drawer 抽屉 -->
<template>
  <ArtDrawer
    v-model="drawerVisible"
    title="入住申请详情"
    :size="500"
    :loading="loading"
    :with-header="true"
    @close="handleClose"
  >
    <div class="check-in-detail-content">
      <!-- 顶部用户卡片 -->
      <div class="student-header-card">
        <!-- 主信息区 -->
        <div class="main-info">
          <!-- 头像 -->
          <div class="avatar-wrapper">
            <div class="avatar-ring">
              <div class="avatar-box">
                <ArtSvgIcon icon="ri:user-line" class="avatar-icon" />
              </div>
            </div>
            <span
              v-if="studentData.status !== undefined"
              class="status-badge"
              :class="studentData.status === 1 ? 'is-active' : 'is-inactive'"
            >
              {{ studentData.status === 1 ? '在校' : '离校' }}
            </span>
          </div>

          <!-- 核心信息 -->
          <div class="core-info">
            <div class="name-line">
              <h3 class="student-name">{{ studentData.studentName || '-' }}</h3>
              <span
                v-if="studentData.genderText"
                class="gender-badge"
                :class="studentData.gender === 1 ? 'is-male' : 'is-female'"
              >
                <ArtSvgIcon
                  :icon="studentData.gender === 1 ? 'ri:men-line' : 'ri:women-line'"
                  class="gender-icon"
                />
              </span>
            </div>
            <div class="student-no">
              <ArtSvgIcon icon="ri:hashtag" class="no-icon" />
              <span class="student-no-text">{{ studentData.studentNo || '-' }}</span>
            </div>
          </div>
        </div>

        <!-- 扩展信息 -->
        <div class="extra-info">
          <div v-if="studentData.campusName" class="info-chip">
            <ArtSvgIcon icon="ri:map-pin-line" class="chip-icon" />
            <span>{{ studentData.campusName }}</span>
          </div>
          <div v-if="studentData.deptName" class="info-chip">
            <ArtSvgIcon icon="ri:building-line" class="chip-icon" />
            <span>{{ studentData.deptName }}</span>
          </div>
          <div v-if="studentData.majorName" class="info-chip">
            <ArtSvgIcon icon="ri:book-open-line" class="chip-icon" />
            <span>{{ studentData.majorName }}</span>
          </div>
        </div>
      </div>

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
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import ArtBasicInfo from '@/components/core/layouts/art-basic-info/index.vue'
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

  // 顶部用户卡片
  .student-header-card {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 20px;
    background: linear-gradient(to bottom, var(--el-color-primary-light-9) 0%, transparent 100%);
    border: 1px solid var(--el-border-color-lighter);
    border-radius: var(--el-border-radius-base);
    transition:
      border-color 0.2s ease,
      box-shadow 0.2s ease;

    &:hover {
      border-color: var(--el-color-primary-light-7);
      box-shadow: 0 2px 5px rgb(0 0 0 / 4%);
    }

    // 主信息区
    .main-info {
      display: flex;
      gap: 16px;
      align-items: center;
    }

    // 头像
    .avatar-wrapper {
      position: relative;
      flex-shrink: 0;

      .avatar-ring {
        padding: 3px;
        background: linear-gradient(
          135deg,
          var(--el-color-primary-light-5),
          var(--el-color-primary-light-8)
        );
        border-radius: 50%;
      }

      .avatar-box {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 64px;
        height: 64px;
        background: var(--el-bg-color);
        border-radius: 50%;
      }

      .status-badge {
        position: absolute;
        right: 50%;
        bottom: -6px;
        padding: 2px 8px;
        font-size: 11px;
        font-weight: 500;
        white-space: nowrap;
        border-radius: 10px;
        transform: translateX(50%);

        &.is-active {
          color: var(--el-color-success);
          background: var(--el-color-success-light-9);
        }

        &.is-inactive {
          color: var(--el-text-color-secondary);
          background: var(--el-fill-color);
        }
      }
    }

    // 核心信息
    .core-info {
      flex: 1;
      min-width: 0;

      .name-line {
        display: flex;
        gap: 8px;
        align-items: center;
        margin-bottom: 3px;
      }

      .student-name {
        margin: 0;
        font-size: 20px;
        font-weight: 600;
        line-height: 1.3;
        color: var(--el-text-color-primary);
      }

      .gender-badge {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 22px;
        height: 22px;
        border-radius: 50%;

        &.is-male {
          color: var(--el-color-primary);
          background: var(--el-color-primary-light-9);
        }

        &.is-female {
          color: var(--el-color-danger);
          background: var(--el-color-danger-light-9);
        }

        .gender-icon {
          width: 14px;
          height: 14px;
        }
      }

      .student-no {
        display: inline-flex;
        align-items: center;
        padding-left: 4px;
        font-family: 'SF Mono', Menlo, monospace;
        font-size: 13px;
        font-weight: 500;
        color: var(--el-text-color-regular);
        background: linear-gradient(135deg, rgba(var(--el-color-primary-rgb), 0.1), transparent);
        border-top-left-radius: var(--el-border-radius-base);

        .no-icon {
          width: 12px;
          height: 12px;
          padding-right: 2px;
          color: var(--el-text-color-placeholder);
        }

        .student-no-text {
          display: inline-block;
          padding-left: 2px;
          font-size: 13px;
          font-weight: 500;
          background: linear-gradient(45deg, rgba(var(--el-color-primary-rgb), 0.1), transparent);
          border-top-left-radius: var(--el-border-radius-base);
        }
      }
    }

    // 扩展信息
    .extra-info {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      padding-top: 12px;
      border-top: 1px dashed var(--el-border-color-lighter);

      .info-chip {
        display: inline-flex;
        gap: 6px;
        align-items: center;
        padding: 6px 12px;
        font-size: 13px;
        color: var(--el-text-color-regular);
        background: var(--el-bg-color);
        border: 1px solid var(--el-border-color-lighter);
        border-radius: 16px;
        transition: all 0.15s ease;

        &:hover {
          background: var(--el-color-primary-light-9);
          border-color: var(--el-color-primary-light-7);
        }

        .chip-icon {
          width: 14px;
          height: 14px;
          color: var(--el-color-primary);
        }
      }
    }
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

  // 图标大小样式
  .avatar-icon {
    width: 32px;
    height: 32px;
    font-size: 32px;
    color: var(--el-color-primary-light-3);
  }
</style>
