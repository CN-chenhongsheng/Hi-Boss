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
        <div v-if="data.phone" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:phone-line" class="label-icon" />
            <span>手机号</span>
          </div>
          <div class="row-value is-copyable">{{ data.phone }}</div>
        </div>
        <div v-if="data.email" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:mail-line" class="label-icon" />
            <span>邮箱</span>
          </div>
          <div class="row-value is-copyable">{{ data.email }}</div>
        </div>
        <div v-if="data.idCard" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:bank-card-line" class="label-icon" />
            <span>身份证号</span>
          </div>
          <div class="row-value is-mono">{{ data.idCard }}</div>
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
        <div v-if="data.birthDate" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:cake-2-line" class="label-icon" />
            <span>出生日期</span>
          </div>
          <div class="row-value">{{ data.birthDate }}</div>
        </div>
        <div v-if="data.nation" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:global-line" class="label-icon" />
            <span>民族</span>
          </div>
          <div class="row-value">{{ data.nation }}</div>
        </div>
        <div v-if="data.politicalStatus" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:flag-line" class="label-icon" />
            <span>政治面貌</span>
          </div>
          <div class="row-value">{{ data.politicalStatus }}</div>
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
        <div v-if="data.enrollmentYear" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:calendar-check-line" class="label-icon" />
            <span>入学年份</span>
          </div>
          <div class="row-value">{{ data.enrollmentYear }}</div>
        </div>
        <div v-if="data.schoolingLength" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:time-line" class="label-icon" />
            <span>学制</span>
          </div>
          <div class="row-value">{{ data.schoolingLength }}年</div>
        </div>
        <div v-if="data.currentGrade" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:graduation-cap-line" class="label-icon" />
            <span>当前年级</span>
          </div>
          <div class="row-value">{{ data.currentGrade }}</div>
        </div>
        <div v-if="data.academicStatusText" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:file-list-line" class="label-icon" />
            <span>学籍状态</span>
          </div>
          <div class="row-value" :class="getAcademicStatusClass(data.academicStatus)">
            <span class="value-dot"></span>
            {{ data.academicStatusText }}
          </div>
        </div>
        <div v-if="data.className" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:group-line" class="label-icon" />
            <span>班级</span>
          </div>
          <div class="row-value">{{ data.className }}</div>
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
          <ArtSvgIcon icon="ri:building-line" class="header-icon" />
          <span class="header-title">住宿信息</span>
        </div>
      </template>
      <div class="info-list">
        <div v-if="data.roomCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:door-open-line" class="label-icon" />
            <span>房间编码</span>
          </div>
          <div class="row-value is-code">{{ data.roomCode }}</div>
        </div>
        <div v-if="data.bedCode" class="info-row">
          <div class="row-label">
            <ArtSvgIcon icon="ri:hotel-bed-line" class="label-icon" />
            <span>床位编码</span>
          </div>
          <div class="row-value is-code">{{ data.bedCode }}</div>
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
  import { ElCard } from 'element-plus'
  import ArtSvgIcon from '@/components/core/base/art-svg-icon/index.vue'

  defineOptions({ name: 'StudentBasicInfo' })

  interface Props {
    /** 学生数据 */
    data: Partial<Api.AccommodationManage.StudentDetail>
  }

  withDefaults(defineProps<Props>(), {
    data: () => ({})
  })

  // 获取学籍状态样式类
  const getAcademicStatusClass = (status?: number): string => {
    if (status === 1) return 'is-good' // 在读
    if (status === 2) return 'is-warn' // 休学
    if (status === 3) return '' // 毕业
    if (status === 4) return 'is-danger' // 退学
    return ''
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
      padding: 12px 16px;
      background: linear-gradient(
        135deg,
        var(--el-fill-color-lighter) 0%,
        color-mix(in srgb, var(--el-color-primary) 6%, var(--el-bg-color)) 100%
      );
      border-bottom: 1px solid var(--el-border-color-lighter);
    }

    :deep(.el-card__body) {
      padding: 4px 16px;
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
      gap: 0;
    }

    .info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid var(--el-border-color-extra-light);

      &:last-of-type {
        border-bottom: none;
      }

      .row-label {
        display: flex;
        gap: 8px;
        align-items: center;
        font-size: 13px;
        color: var(--el-text-color-secondary);

        .label-icon {
          width: 16px;
          height: 16px;
          color: var(--el-text-color-placeholder);
        }
      }

      .row-value {
        display: flex;
        gap: 6px;
        align-items: center;
        font-size: 13px;
        font-weight: 500;
        color: var(--el-text-color-primary);

        .value-dot {
          width: 6px;
          height: 6px;
          background: var(--el-text-color-placeholder);
          border-radius: 50%;
        }

        &.is-good {
          color: var(--el-color-success);

          .value-dot {
            background: var(--el-color-success);
          }
        }

        &.is-warn {
          color: var(--el-color-warning-dark-2);

          .value-dot {
            background: var(--el-color-warning);
          }
        }

        &.is-danger {
          color: var(--el-color-danger);

          .value-dot {
            background: var(--el-color-danger);
          }
        }

        &.is-mono {
          font-family: 'SF Mono', Menlo, Consolas, monospace;
          letter-spacing: 0.5px;
        }

        &.is-copyable {
          color: var(--el-color-primary);
        }

        &.is-code {
          padding: 2px 8px;
          font-family: 'SF Mono', Menlo, Consolas, monospace;
          font-size: 12px;
          color: var(--el-color-primary);
          background: var(--el-color-primary-light-9);
          border-radius: 4px;
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
      padding: 12px 0;

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
