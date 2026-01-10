<!-- 学生生活习惯模块 -->
<template>
  <div class="student-lifestyle-info">
    <!-- 作息习惯卡片 -->
    <ElCard class="lifestyle-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:moon-line" class="header-icon" />
          <span class="header-title">作息习惯</span>
        </div>
      </template>
      <div class="lifestyle-content">
        <div v-if="data.sleepScheduleText" class="tag-item">
          <span class="tag-label">作息时间</span>
          <ElTag type="info" size="default" effect="plain">{{ data.sleepScheduleText }}</ElTag>
        </div>
        <div v-if="data.sleepQualityText" class="tag-item">
          <span class="tag-label">睡眠质量</span>
          <ElTag type="success" size="default" effect="plain">{{ data.sleepQualityText }}</ElTag>
        </div>
        <div v-if="data.snores !== undefined && data.snores !== null" class="tag-item">
          <span class="tag-label">是否打呼噜</span>
          <ElTag :type="data.snores === 1 ? 'warning' : 'success'" size="default" effect="dark">
            {{ data.snoresText || '-' }}
          </ElTag>
        </div>
        <div
          v-if="data.sensitiveToLight !== undefined && data.sensitiveToLight !== null"
          class="tag-item"
        >
          <span class="tag-label">光线敏感</span>
          <ElTag
            :type="data.sensitiveToLight === 1 ? 'warning' : 'success'"
            size="default"
            effect="plain"
          >
            {{ data.sensitiveToLightText || '-' }}
          </ElTag>
        </div>
        <div
          v-if="data.sensitiveToSound !== undefined && data.sensitiveToSound !== null"
          class="tag-item"
        >
          <span class="tag-label">声音敏感</span>
          <ElTag
            :type="data.sensitiveToSound === 1 ? 'warning' : 'success'"
            size="default"
            effect="plain"
          >
            {{ data.sensitiveToSoundText || '-' }}
          </ElTag>
        </div>
        <div
          v-if="
            !data.sleepScheduleText &&
            data.snores === undefined &&
            data.sensitiveToLight === undefined &&
            data.sensitiveToSound === undefined
          "
          class="empty-state"
        >
          <span class="empty-text">暂无作息习惯信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 生活习惯卡片 -->
    <ElCard class="lifestyle-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:heart-line" class="header-icon" />
          <span class="header-title">生活习惯</span>
        </div>
      </template>
      <div class="lifestyle-content">
        <div
          v-if="data.smokingStatus !== undefined && data.smokingStatus !== null"
          class="tag-item"
        >
          <span class="tag-label">吸烟状态</span>
          <ElTag
            :type="data.smokingStatus === 1 ? 'warning' : 'success'"
            size="default"
            effect="dark"
          >
            {{ data.smokingStatusText || '-' }}
          </ElTag>
        </div>
        <div
          v-if="data.smokingTolerance !== undefined && data.smokingTolerance !== null"
          class="tag-item"
        >
          <span class="tag-label">接受室友吸烟</span>
          <ElTag
            :type="data.smokingTolerance === 1 ? 'success' : 'info'"
            size="default"
            effect="plain"
          >
            {{ data.smokingToleranceText || '-' }}
          </ElTag>
        </div>
        <div v-if="data.cleanlinessLevelText" class="tag-item">
          <span class="tag-label">整洁程度</span>
          <ElTag :type="getCleanlinessType(data.cleanlinessLevel)" size="default" effect="plain">
            {{ data.cleanlinessLevelText }}
          </ElTag>
        </div>
        <div v-if="data.bedtimeCleanupText" class="tag-item">
          <span class="tag-label">睡前整理</span>
          <ElTag type="primary" size="default" effect="plain">{{ data.bedtimeCleanupText }}</ElTag>
        </div>
        <div
          v-if="
            data.smokingStatus === undefined &&
            data.smokingTolerance === undefined &&
            !data.cleanlinessLevelText &&
            !data.bedtimeCleanupText
          "
          class="empty-state"
        >
          <span class="empty-text">暂无生活习惯信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 社交偏好卡片 -->
    <ElCard class="lifestyle-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:team-line" class="header-icon" />
          <span class="header-title">社交偏好</span>
        </div>
      </template>
      <div class="lifestyle-content">
        <div v-if="data.socialPreferenceText" class="tag-item">
          <span class="tag-label">社交偏好</span>
          <ElTag :type="getSocialType(data.socialPreference)" size="default" effect="plain">
            {{ data.socialPreferenceText }}
          </ElTag>
        </div>
        <div v-if="data.allowVisitorsText" class="tag-item">
          <span class="tag-label">允许访客</span>
          <ElTag :type="getVisitorType(data.allowVisitors)" size="default" effect="plain">
            {{ data.allowVisitorsText }}
          </ElTag>
        </div>
        <div v-if="data.phoneCallTimeText" class="tag-item">
          <span class="tag-label">电话时间偏好</span>
          <ElTag type="info" size="default" effect="plain">{{ data.phoneCallTimeText }}</ElTag>
        </div>
        <div
          v-if="!data.socialPreferenceText && !data.allowVisitorsText && !data.phoneCallTimeText"
          class="empty-state"
        >
          <span class="empty-text">暂无社交偏好信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 学习习惯卡片 -->
    <ElCard class="lifestyle-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:book-read-line" class="header-icon" />
          <span class="header-title">学习习惯</span>
        </div>
      </template>
      <div class="lifestyle-content">
        <div v-if="data.studyInRoomText" class="tag-item">
          <span class="tag-label">宿舍学习</span>
          <ElTag type="primary" size="default" effect="plain">{{ data.studyInRoomText }}</ElTag>
        </div>
        <div v-if="data.studyEnvironmentText" class="tag-item">
          <span class="tag-label">学习环境偏好</span>
          <ElTag type="success" size="default" effect="plain">{{
            data.studyEnvironmentText
          }}</ElTag>
        </div>
        <div v-if="data.computerUsageTimeText" class="tag-item">
          <span class="tag-label">电脑使用时间</span>
          <ElTag type="info" size="default" effect="plain">{{ data.computerUsageTimeText }}</ElTag>
        </div>
        <div
          v-if="!data.studyInRoomText && !data.studyEnvironmentText && !data.computerUsageTimeText"
          class="empty-state"
        >
          <span class="empty-text">暂无学习习惯信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 娱乐习惯卡片 -->
    <ElCard class="lifestyle-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:gamepad-line" class="header-icon" />
          <span class="header-title">娱乐习惯</span>
        </div>
      </template>
      <div class="lifestyle-content">
        <div v-if="data.gamingPreferenceText" class="tag-item">
          <span class="tag-label">游戏偏好</span>
          <ElTag type="warning" size="default" effect="plain">{{
            data.gamingPreferenceText
          }}</ElTag>
        </div>
        <div v-if="data.musicPreferenceText" class="tag-item">
          <span class="tag-label">听音乐偏好</span>
          <ElTag type="primary" size="default" effect="plain">{{ data.musicPreferenceText }}</ElTag>
        </div>
        <div v-if="data.musicVolumeText" class="tag-item">
          <span class="tag-label">音乐音量偏好</span>
          <ElTag type="info" size="default" effect="plain">{{ data.musicVolumeText }}</ElTag>
        </div>
        <div v-if="data.eatInRoomText" class="tag-item">
          <span class="tag-label">宿舍饮食</span>
          <ElTag type="success" size="default" effect="plain">{{ data.eatInRoomText }}</ElTag>
        </div>
        <div
          v-if="
            !data.gamingPreferenceText &&
            !data.musicPreferenceText &&
            !data.musicVolumeText &&
            !data.eatInRoomText
          "
          class="empty-state"
        >
          <span class="empty-text">暂无娱乐习惯信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 特殊需求卡片 -->
    <ElCard
      v-if="data.specialNeeds || data.roommatePreference"
      class="lifestyle-card"
      shadow="hover"
    >
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:information-line" class="header-icon" />
          <span class="header-title">特殊需求</span>
        </div>
      </template>
      <div class="special-content">
        <div v-if="data.specialNeeds" class="special-item">
          <span class="special-label">特殊需求</span>
          <p class="special-text">{{ data.specialNeeds }}</p>
        </div>
        <div v-if="data.roommatePreference" class="special-item">
          <span class="special-label">室友偏好</span>
          <p class="special-text">{{ data.roommatePreference }}</p>
        </div>
      </div>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { ElCard, ElTag } from 'element-plus'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'

  defineOptions({ name: 'StudentLifestyleInfo' })

  interface Props {
    /** 学生数据 */
    data: Partial<Api.AccommodationManage.StudentDetail>
  }

  withDefaults(defineProps<Props>(), {
    data: () => ({})
  })

  // 获取整洁程度标签类型
  const getCleanlinessType = (level?: number): 'success' | 'warning' | 'danger' | 'info' => {
    if (level === 1 || level === 2) return 'success' // 非常整洁、整洁
    if (level === 3) return 'info' // 一般
    if (level === 4 || level === 5) return 'warning' // 随意、不整洁
    return 'info'
  }

  // 获取社交偏好标签类型
  const getSocialType = (preference?: number): 'success' | 'warning' | 'info' => {
    if (preference === 1) return 'success' // 喜欢安静
    if (preference === 2) return 'info' // 中等
    if (preference === 3) return 'warning' // 喜欢热闹
    return 'info'
  }

  // 获取访客偏好标签类型
  const getVisitorType = (allow?: number): 'success' | 'warning' | 'danger' => {
    if (allow === 0) return 'danger' // 不允许
    if (allow === 1) return 'warning' // 偶尔可以
    if (allow === 2) return 'success' // 可以
    return 'info' as any
  }
</script>

<style lang="scss" scoped>
  .student-lifestyle-info {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .lifestyle-card {
    border: 1px solid var(--el-border-color-lighter);
    border-radius: var(--el-border-radius-base);
    transition: all 0.3s;

    &:hover {
      border-color: var(--el-color-primary-light-7);
      box-shadow: 0 2px 12px 0 rgb(0 0 0 / 10%);
    }

    :deep(.el-card__header) {
      padding: 16px 20px;
      background: var(--el-fill-color-lighter);
      border-bottom: 1px solid var(--el-border-color-lighter);
    }

    :deep(.el-card__body) {
      padding: 20px;
    }

    .card-header {
      display: flex;
      gap: 8px;
      align-items: center;

      .header-icon {
        font-size: 18px;
        color: var(--el-color-primary);
      }

      .header-title {
        font-size: 15px;
        font-weight: 600;
        color: var(--el-text-color-primary);
      }
    }

    .lifestyle-content {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .tag-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px;
      background: var(--el-fill-color-extra-light);
      border-radius: var(--el-border-radius-small);
      transition: all 0.2s;

      &:hover {
        background: var(--el-fill-color-light);
      }

      .tag-label {
        min-width: 120px;
        font-size: 14px;
        font-weight: 500;
        color: var(--el-text-color-regular);
      }
    }

    .empty-state {
      padding: 24px;
      text-align: center;

      .empty-text {
        font-size: 14px;
        color: var(--el-text-color-placeholder);
      }
    }

    .special-content {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .special-item {
      display: flex;
      flex-direction: column;
      gap: 8px;

      .special-label {
        font-size: 13px;
        font-weight: 600;
        color: var(--el-text-color-secondary);
      }

      .special-text {
        padding: 12px;
        margin: 0;
        font-size: 14px;
        line-height: 1.6;
        color: var(--el-text-color-regular);
        word-break: break-word;
        background: var(--el-fill-color-extra-light);
        border-radius: var(--el-border-radius-small);
      }
    }
  }
</style>
