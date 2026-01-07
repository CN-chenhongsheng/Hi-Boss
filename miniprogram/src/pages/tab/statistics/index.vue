<template>
  <view class="statistics-page">
    <!-- 顶部筛选 -->
    <view class="filter-bar">
      <u-button size="small" :type="timeRange === 'week' ? 'primary' : 'default'" @click="timeRange = 'week'">
        本周
      </u-button>
      <u-button size="small" :type="timeRange === 'month' ? 'primary' : 'default'" @click="timeRange = 'month'">
        本月
      </u-button>
      <u-button size="small" :type="timeRange === 'year' ? 'primary' : 'default'" @click="timeRange = 'year'">
        本年
      </u-button>
    </view>

    <!-- 数据概览卡片 -->
    <view class="overview-cards">
      <view v-for="item in overviewData" :key="item.id" class="card-item">
        <view class="card-icon" :style="{ background: item.color }">
          <u-icon :name="item.icon" size="24" color="#fff" />
        </view>
        <view class="card-info">
          <view class="value">
            {{ item.value }}
          </view>
          <view class="label">
            {{ item.label }}
          </view>
        </view>
      </view>
    </view>

    <!-- 申请类型分布 - 饼图 -->
    <view class="chart-card">
      <view class="card-title">
        申请类型分布
      </view>
      <view class="chart-container">
        <qiun-ucharts
          type="pie"
          :opts="pieChartOpts"
          :chart-data="pieChartData"
          canvas-id="pie-chart"
        />
      </view>
    </view>

    <!-- 申请趋势 - 折线图 -->
    <view class="chart-card">
      <view class="card-title">
        申请趋势
      </view>
      <view class="chart-container">
        <qiun-ucharts
          type="line"
          :opts="lineChartOpts"
          :chart-data="lineChartData"
          canvas-id="line-chart"
        />
      </view>
    </view>

    <!-- 审批状态 - 柱状图 -->
    <view class="chart-card">
      <view class="card-title">
        审批状态统计
      </view>
      <view class="chart-container">
        <qiun-ucharts
          type="column"
          :opts="columnChartOpts"
          :chart-data="columnChartData"
          canvas-id="column-chart"
        />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue';
import { getComprehensiveStatisticsAPI } from '@/api';

const timeRange = ref('month');
const statisticsData = ref<any>(null);

// 概览数据
const overviewData = computed(() => [
  {
    id: 1,
    label: '总申请数',
    value: statisticsData.value?.totalApply || 0,
    icon: 'file-text',
    color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  },
  {
    id: 2,
    label: '待审批',
    value: statisticsData.value?.pendingApply || 0,
    icon: 'clock',
    color: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
  },
  {
    id: 3,
    label: '已通过',
    value: statisticsData.value?.approvedApply || 0,
    icon: 'checkmark-circle',
    color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
  },
  {
    id: 4,
    label: '已拒绝',
    value: statisticsData.value?.rejectedApply || 0,
    icon: 'close-circle',
    color: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
  },
]);

// 饼图配置
const pieChartOpts = ref({
  color: ['#5470c6', '#91cc75', '#fac858', '#ee6666'],
  padding: [15, 15, 0, 15],
  enableScroll: false,
  legend: {
    show: true,
    position: 'bottom',
  },
  dataLabel: {
    show: true,
  },
  extra: {
    pie: {
      activeOpacity: 0.5,
      activeRadius: 10,
      offsetAngle: 0,
      labelWidth: 15,
      ringWidth: 0,
      border: true,
      borderWidth: 3,
      borderColor: '#FFFFFF',
    },
  },
});

const pieChartData = computed(() => {
  if (!statisticsData.value?.applyTypeDistribution) {
    return { series: [] };
  }

  return {
    series: [
      {
        data: statisticsData.value.applyTypeDistribution.map((item: any) => ({
          name: item.name,
          value: item.value,
        })),
      },
    ],
  };
});

// 折线图配置
const lineChartOpts = ref({
  color: ['#1890FF', '#91CC75', '#FAC858', '#EE6666'],
  padding: [15, 15, 0, 15],
  enableScroll: false,
  legend: {
    show: true,
  },
  xAxis: {
    disableGrid: true,
  },
  yAxis: {
    gridType: 'dash',
    dashLength: 2,
  },
  extra: {
    line: {
      type: 'curve',
      width: 2,
      activeType: 'hollow',
    },
  },
});

const lineChartData = computed(() => {
  if (!statisticsData.value?.applyTrend) {
    return { categories: [], series: [] };
  }

  return {
    categories: statisticsData.value.applyTrend.dates,
    series: [
      {
        name: '入住申请',
        data: statisticsData.value.applyTrend.checkIn,
      },
      {
        name: '调宿申请',
        data: statisticsData.value.applyTrend.transfer,
      },
      {
        name: '退宿申请',
        data: statisticsData.value.applyTrend.checkOut,
      },
      {
        name: '留宿申请',
        data: statisticsData.value.applyTrend.stay,
      },
    ],
  };
});

// 柱状图配置
const columnChartOpts = ref({
  color: ['#1890FF', '#52C41A', '#FF4D4F'],
  padding: [15, 15, 0, 5],
  enableScroll: false,
  legend: {
    show: false,
  },
  xAxis: {
    disableGrid: true,
  },
  yAxis: {
    gridType: 'dash',
    dashLength: 2,
  },
  extra: {
    column: {
      type: 'group',
      width: 30,
      activeBgColor: '#000000',
      activeBgOpacity: 0.08,
    },
  },
});

const columnChartData = computed(() => {
  if (!statisticsData.value?.statusDistribution) {
    return { categories: [], series: [] };
  }

  return {
    categories: ['待审批', '已通过', '已拒绝'],
    series: [
      {
        name: '数量',
        data: [
          statisticsData.value.statusDistribution.pending || 0,
          statisticsData.value.statusDistribution.approved || 0,
          statisticsData.value.statusDistribution.rejected || 0,
        ],
      },
    ],
  };
});

// 加载统计数据
async function loadStatistics() {
  try {
    statisticsData.value = await getComprehensiveStatisticsAPI({ timeRange: timeRange.value });
  }
  catch (error) {
    console.error('加载统计数据失败:', error);
    uni.showToast({ title: '加载失败', icon: 'none' });
  }
}

watch(timeRange, () => {
  loadStatistics();
});

onMounted(() => {
  loadStatistics();
});
</script>

<style lang="scss" scoped>
.statistics-page {
  padding: 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.filter-bar {
  display: flex;
  gap: 20rpx;
  margin-bottom: 20rpx;

  :deep(.u-button) {
    flex: 1;
  }
}

.overview-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20rpx;
  margin-bottom: 20rpx;

  .card-item {
    display: flex;
    align-items: center;
    padding: 30rpx;
    background: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .card-icon {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 20rpx;
      width: 80rpx;
      height: 80rpx;
      border-radius: 12rpx;
    }

    .card-info {
      flex: 1;

      .value {
        margin-bottom: 8rpx;
        font-size: 40rpx;
        color: #333;
        font-weight: 600;
      }

      .label {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}

.chart-card {
  padding: 30rpx;
  margin-bottom: 20rpx;
  background: #fff;
  border-radius: 16rpx;
  box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

  .card-title {
    margin-bottom: 24rpx;
    font-size: 32rpx;
    color: #333;
    font-weight: 600;
  }

  .chart-container {
    width: 100%;
    height: 500rpx;
  }
}
</style>
