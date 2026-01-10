<!-- 学生详情 Drawer 抽屉 -->
<template>
  <ArtDrawer
    v-model="drawerVisible"
    title="查看学生"
    :size="500"
    :loading="loading"
    :with-header="true"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="student-detail-content">
      <!-- 顶部用户卡片 -->
      <ElCard class="student-header-card" shadow="never">
        <div class="header-card-content">
          <!-- 头像区域 -->
          <div class="avatar-section">
            <div class="avatar-wrapper">
              <div class="avatar-placeholder">
                <ArtSvgIcon icon="ri:user-line" class="avatar-icon" />
              </div>
              <ElTag
                v-if="formData.status !== undefined"
                :type="formData.status === 1 ? 'success' : 'danger'"
                class="status-badge"
                effect="dark"
              >
                {{ formData.statusText || '未知' }}
              </ElTag>
            </div>
          </div>

          <!-- 基本信息区域 -->
          <div class="info-section">
            <h2 class="student-name">{{ formData.studentName || '-' }}</h2>
            <div class="student-meta">
              <span class="meta-item">
                <ArtSvgIcon icon="ri:id-card-line" class="meta-icon" />
                学号：{{ formData.studentNo || '-' }}
              </span>
              <ElTag v-if="formData.genderText" size="small" class="gender-tag">
                <ArtSvgIcon
                  :icon="formData.gender === 1 ? 'ri:men-line' : 'ri:women-line'"
                  class="gender-icon"
                />
                {{ formData.genderText }}
              </ElTag>
            </div>
            <div
              v-if="formData.campusName || formData.deptName || formData.majorName"
              class="school-info"
            >
              <span v-if="formData.campusName" class="school-item">
                <ArtSvgIcon icon="ri:community-line" class="school-icon" />
                {{ formData.campusName }}
              </span>
              <span v-if="formData.deptName" class="school-item">
                <ArtSvgIcon icon="ri:building-line" class="school-icon" />
                {{ formData.deptName }}
              </span>
              <span v-if="formData.majorName" class="school-item">
                <ArtSvgIcon icon="ri:book-open-line" class="school-icon" />
                {{ formData.majorName }}
              </span>
            </div>
          </div>
        </div>
      </ElCard>

      <!-- 标签页内容 -->
      <ElTabs v-model="activeTab" class="student-detail-tabs">
        <!-- 基本信息标签页 -->
        <ElTabPane label="基本信息" name="basic">
          <StudentBasicInfo :data="formData" />
        </ElTabPane>

        <!-- 生活习惯标签页 -->
        <ElTabPane label="生活习惯" name="lifestyle">
          <StudentLifestyleInfo :data="formData" />
        </ElTabPane>
      </ElTabs>
    </div>
  </ArtDrawer>
</template>

<script setup lang="ts">
  import { ref, watch, computed } from 'vue'
  import { ElTabs, ElTabPane, ElCard, ElTag } from 'element-plus'
  import ArtDrawer from '@/components/core/layouts/art-drawer/index.vue'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'
  import StudentBasicInfo from './student-basic-info.vue'
  import StudentLifestyleInfo from './student-lifestyle-info.vue'
  import { fetchGetStudentDetail } from '@/api/accommodation-manage'
  import { ElMessage } from 'element-plus'

  defineOptions({ name: 'StudentDrawer' })

  type StudentDetail = Api.AccommodationManage.StudentDetail

  interface Props {
    /** 是否显示 */
    visible: boolean
    /** 对话框类型 */
    dialogType: 'edit' | 'view'
    /** 学生ID */
    studentId?: number
    /** 学生数据 */
    studentData?: StudentDetail | null
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'close'): void
    (e: 'saved'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    visible: false,
    dialogType: 'view',
    studentId: undefined,
    studentData: null
  })

  const emit = defineEmits<Emits>()

  const drawerVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  const activeTab = ref('basic')
  const loading = ref(false)
  const formData = ref<Partial<StudentDetail>>({})

  // 获取学生详情
  const loadStudentDetail = async () => {
    if (!props.studentId) {
      formData.value = {}
      return
    }

    if (props.studentData) {
      formData.value = { ...props.studentData }
      return
    }

    try {
      loading.value = true
      const res = await fetchGetStudentDetail(props.studentId)
      if (res) {
        formData.value = res
      }
    } catch {
      ElMessage.error('获取学生详情失败')
    } finally {
      loading.value = false
    }
  }

  // 监听抽屉显示状态
  watch(
    () => props.visible,
    (newVal) => {
      if (newVal) {
        activeTab.value = 'basic'
        loadStudentDetail()
      }
    }
  )

  // 监听学生ID变化
  watch(
    () => props.studentId,
    () => {
      if (props.visible) {
        loadStudentDetail()
      }
    }
  )

  // 关闭抽屉
  const handleClose = () => {
    emit('update:visible', false)
    emit('close')
  }
</script>

<style lang="scss" scoped>
  .student-detail-content {
    display: flex;
    flex-direction: column;
    gap: 24px;
    padding: 0;
  }

  // 顶部用户卡片
  .student-header-card {
    margin-bottom: 0;
    background: var(--el-bg-color);
    border: 1px solid var(--el-border-color-lighter);
    border-radius: var(--el-border-radius-base);
    box-shadow: 0 2px 8px 0 rgb(0 0 0 / 6%);

    :deep(.el-card__body) {
      padding: 24px;
    }

    .header-card-content {
      display: flex;
      gap: 20px;
      align-items: center;
    }

    .avatar-section {
      flex-shrink: 0;

      .avatar-wrapper {
        position: relative;

        .avatar-placeholder {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 100px;
          height: 100px;
          color: var(--el-text-color-secondary);
          background: var(--el-fill-color-light);
          border: 2px solid var(--el-border-color-lighter);
          border-radius: 50%;

          .art-svg-icon {
            color: var(--el-text-color-secondary);
          }
        }

        .status-badge {
          position: absolute;
          right: 0;
          bottom: 0;
          transform: translate(25%, 25%);
        }
      }
    }

    .info-section {
      flex: 1;
      min-width: 0;

      .student-name {
        margin: 0 0 12px;
        font-size: 22px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }

      .student-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 16px;
        align-items: center;
        margin-bottom: 12px;

        .meta-item {
          display: flex;
          gap: 6px;
          align-items: center;
          font-size: 14px;
          color: var(--el-text-color-regular);

          .art-svg-icon {
            color: var(--el-text-color-secondary);
          }
        }

        .gender-tag {
          color: var(--el-text-color-regular);
          background: var(--el-fill-color-light);
          border-color: var(--el-border-color-lighter);

          .art-svg-icon {
            color: var(--el-text-color-secondary);
          }
        }
      }

      .school-info {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        align-items: center;

        .school-item {
          display: flex;
          gap: 6px;
          align-items: center;
          padding: 6px 12px;
          font-size: 13px;
          color: var(--el-text-color-regular);
          background: var(--el-fill-color-extra-light);
          border: 1px solid var(--el-border-color-lighter);
          border-radius: var(--el-border-radius-small);

          .art-svg-icon {
            color: var(--el-text-color-secondary);
          }
        }
      }
    }
  }

  // 标签页样式
  .student-detail-tabs {
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
    width: 48px;
    height: 48px;
    font-size: 48px;
  }

  .meta-icon,
  .school-icon {
    width: 16px;
    height: 16px;
    font-size: 16px;
  }

  .gender-icon {
    width: 14px;
    height: 14px;
    margin-right: 4px;
    font-size: 14px;
  }
</style>
