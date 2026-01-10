<!-- 学生基本信息模块 -->
<template>
  <div class="student-basic-info">
    <!-- 联系信息卡片 -->
    <ElCard class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:contacts-line" class="header-icon" />
          <span class="header-title">联系信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="data.phone" class="info-item">
          <ArtSvgIcon icon="ri:phone-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">手机号</span>
            <span class="item-value">{{ data.phone }}</span>
          </div>
        </div>
        <div v-if="data.email" class="info-item">
          <ArtSvgIcon icon="ri:mail-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">邮箱</span>
            <span class="item-value">{{ data.email }}</span>
          </div>
        </div>
        <div v-if="data.idCard" class="info-item">
          <ArtSvgIcon icon="ri:id-card-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">身份证号</span>
            <span class="item-value">{{ data.idCard }}</span>
          </div>
        </div>
        <div v-if="!data.phone && !data.email && !data.idCard" class="empty-state">
          <span class="empty-text">暂无联系信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 身份信息卡片 -->
    <ElCard class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:user-settings-line" class="header-icon" />
          <span class="header-title">身份信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="data.birthDate" class="info-item">
          <ArtSvgIcon icon="ri:calendar-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">出生日期</span>
            <span class="item-value">{{ data.birthDate }}</span>
          </div>
        </div>
        <div v-if="data.nation" class="info-item">
          <ArtSvgIcon icon="ri:global-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">民族</span>
            <span class="item-value">{{ data.nation }}</span>
          </div>
        </div>
        <div v-if="data.politicalStatus" class="info-item">
          <ArtSvgIcon icon="ri:government-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">政治面貌</span>
            <span class="item-value">{{ data.politicalStatus }}</span>
          </div>
        </div>
        <div v-if="!data.birthDate && !data.nation && !data.politicalStatus" class="empty-state">
          <span class="empty-text">暂无身份信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 学校信息卡片 -->
    <ElCard class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:school-line" class="header-icon" />
          <span class="header-title">学校信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="data.enrollmentYear" class="info-item">
          <ArtSvgIcon icon="ri:calendar-event-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">入学年份</span>
            <span class="item-value">{{ data.enrollmentYear }}</span>
          </div>
        </div>
        <div v-if="data.schoolingLength" class="info-item">
          <ArtSvgIcon icon="ri:time-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">学制</span>
            <span class="item-value">{{ data.schoolingLength }}年</span>
          </div>
        </div>
        <div v-if="data.currentGrade" class="info-item">
          <ArtSvgIcon icon="ri:graduation-cap-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">当前年级</span>
            <span class="item-value">{{ data.currentGrade }}</span>
          </div>
        </div>
        <div v-if="data.academicStatusText" class="info-item">
          <ArtSvgIcon icon="ri:file-list-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">学籍状态</span>
            <ElTag :type="getAcademicStatusType(data.academicStatus)" size="small">
              {{ data.academicStatusText }}
            </ElTag>
          </div>
        </div>
        <div v-if="data.className" class="info-item">
          <ArtSvgIcon icon="ri:group-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">班级</span>
            <span class="item-value">{{ data.className }}</span>
          </div>
        </div>
        <div
          v-if="
            !data.enrollmentYear &&
            !data.schoolingLength &&
            !data.currentGrade &&
            !data.academicStatusText &&
            !data.className
          "
          class="empty-state"
        >
          <span class="empty-text">暂无学校信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 住宿信息卡片 -->
    <ElCard class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:home-line" class="header-icon" />
          <span class="header-title">住宿信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="data.roomCode" class="info-item">
          <ArtSvgIcon icon="ri:door-open-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">房间编码</span>
            <ElTag type="primary" size="small">{{ data.roomCode }}</ElTag>
          </div>
        </div>
        <div v-if="data.bedCode" class="info-item">
          <ArtSvgIcon icon="ri:bed-line" class="item-icon" />
          <div class="item-content">
            <span class="item-label">床位编码</span>
            <ElTag type="success" size="small">{{ data.bedCode }}</ElTag>
          </div>
        </div>
        <div v-if="!data.roomCode && !data.bedCode" class="empty-state">
          <span class="empty-text">暂无住宿信息</span>
        </div>
      </div>
    </ElCard>

    <!-- 备注信息 -->
    <ElCard v-if="data.remark" class="info-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <ArtSvgIcon icon="ri:file-text-line" class="header-icon" />
          <span class="header-title">备注</span>
        </div>
      </template>
      <div class="remark-content">
        <p class="remark-text">{{ data.remark }}</p>
      </div>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { ElCard, ElTag } from 'element-plus'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'

  defineOptions({ name: 'StudentBasicInfo' })

  interface Props {
    /** 学生数据 */
    data: Partial<Api.AccommodationManage.StudentDetail>
  }

  withDefaults(defineProps<Props>(), {
    data: () => ({})
  })

  // 获取学籍状态标签类型
  const getAcademicStatusType = (status?: number): 'success' | 'warning' | 'danger' | 'info' => {
    if (status === 1) return 'success' // 在读
    if (status === 2) return 'warning' // 休学
    if (status === 3) return 'info' // 毕业
    if (status === 4) return 'danger' // 退学
    return 'info'
  }
</script>

<style lang="scss" scoped>
  .student-basic-info {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .info-card {
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

    .info-list {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .info-item {
      display: flex;
      gap: 12px;
      align-items: flex-start;
      padding: 12px;
      background: var(--el-fill-color-extra-light);
      border-radius: var(--el-border-radius-small);
      transition: all 0.2s;

      &:hover {
        background: var(--el-fill-color-light);
      }

      .item-icon {
        flex-shrink: 0;
        margin-top: 2px;
        font-size: 20px;
        color: var(--el-color-primary);
      }

      .item-content {
        display: flex;
        flex: 1;
        flex-direction: column;
        gap: 4px;
        min-width: 0;

        .item-label {
          font-size: 12px;
          font-weight: 500;
          color: var(--el-text-color-secondary);
        }

        .item-value {
          font-size: 14px;
          color: var(--el-text-color-primary);
          word-break: break-all;
        }
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

    .remark-content {
      padding: 8px 0;

      .remark-text {
        margin: 0;
        font-size: 14px;
        line-height: 1.6;
        color: var(--el-text-color-regular);
        word-break: break-word;
      }
    }
  }
</style>
