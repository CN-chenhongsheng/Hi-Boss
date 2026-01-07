<template>
  <view class="apply-page">
    <view class="apply-tabs">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="tab-item"
        :class="{ active: activeTab === tab.value }"
        @click="activeTab = tab.value"
      >
        {{ tab.label }}
        <view v-if="tab.count > 0" class="badge">
          {{ tab.count }}
        </view>
      </view>
    </view>

    <scroll-view class="apply-list" scroll-y>
      <view v-if="loading" class="loading">
        <view class="loading-spinner" />
        <view class="loading-text">
          加载中...
        </view>
      </view>

      <view v-else-if="list.length === 0" class="empty">
        <u-empty mode="list" text="暂无申请记录" />
      </view>

      <view v-else class="list-content">
        <view
          v-for="item in list"
          :key="item.id"
          class="apply-item"
          @click="handleViewDetail(item)"
        >
          <view class="item-header">
            <view class="title">
              {{ getApplyTypeName(item.type) }}
            </view>
            <view class="status" :style="{ color: getStatusColor(item.status) }">
              {{ getStatusText(item.status) }}
            </view>
          </view>
          <view class="item-content">
            <view class="info-row">
              <text class="label">
                申请日期：
              </text>
              <text class="value">
                {{ item.applyDate }}
              </text>
            </view>
            <view v-if="item.approveTime" class="info-row">
              <text class="label">
                审批时间：
              </text>
              <text class="value">
                {{ item.approveTime }}
              </text>
            </view>
          </view>
          <view class="item-footer">
            <text class="time">
              {{ item.createTime }}
            </text>
            <u-icon name="arrow-right" size="16" color="#999" />
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { ApplyStatus, ApplyStatusColor, ApplyStatusText } from '@/types';
import useUserStore from '@/store/modules/user';

const userStore = useUserStore();

// Tab选项
const tabs = ref([
  { label: '全部', value: 'all', count: 0 },
  { label: '待审核', value: ApplyStatus.PENDING, count: 0 },
  { label: '已通过', value: ApplyStatus.APPROVED, count: 0 },
  { label: '已拒绝', value: ApplyStatus.REJECTED, count: 0 },
]);

const activeTab = ref('all');
const loading = ref(false);
const list = ref<any[]>([]);

// 根据角色显示不同的标题
const pageTitle = computed(() => {
  return userStore.hasManagePermission ? '审批中心' : '申请中心';
});

// 获取申请类型名称
function getApplyTypeName(type: string) {
  const typeMap: Record<string, string> = {
    checkIn: '入住申请',
    transfer: '调宿申请',
    checkOut: '退宿申请',
    stay: '留宿申请',
  };
  return typeMap[type] || '申请';
}

// 获取状态文本
function getStatusText(status: ApplyStatus) {
  return ApplyStatusText[status] || '未知';
}

// 获取状态颜色
function getStatusColor(status: ApplyStatus) {
  return ApplyStatusColor[status] || '#999';
}

// 查看详情
function handleViewDetail(item: any) {
  const url = userStore.hasManagePermission
    ? `/pages/admin/approval-detail/index?id=${item.id}&type=${item.type}`
    : `/pages/apply/detail/index?id=${item.id}&type=${item.type}`;

  uni.navigateTo({ url });
}

// 加载数据
async function loadData() {
  loading.value = true;
  try {
    // TODO: 调用API加载数据
    await new Promise(resolve => setTimeout(resolve, 1000));
    list.value = [];
  }
  catch (error) {
    console.error('加载失败:', error);
    uni.showToast({
      title: '加载失败',
      icon: 'none',
    });
  }
  finally {
    loading.value = false;
  }
}

onMounted(() => {
  // 设置导航栏标题
  uni.setNavigationBarTitle({
    title: pageTitle.value,
  });
  loadData();
});
</script>

<style lang="scss" scoped>
.apply-page {
  display: flex;
  height: 100vh;
  background-color: #f5f5f5;
  flex-direction: column;
}

.apply-tabs {
  display: flex;
  padding: 20rpx 0;
  background-color: #fff;
  box-shadow: 0 2rpx 8rpx rgb(0 0 0 / 5%);

  .tab-item {
    position: relative;
    padding: 16rpx 0;
    font-size: 28rpx;
    text-align: center;
    color: #666;
    transition: all 0.3s;
    flex: 1;

    &.active {
      color: #2196F3;
      font-weight: 600;

      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 60rpx;
        height: 4rpx;
        background-color: #2196F3;
        border-radius: 2rpx;
      }
    }

    .badge {
      position: absolute;
      top: 8rpx;
      right: 20%;
      padding: 2rpx 8rpx;
      min-width: 32rpx;
      font-size: 20rpx;
      text-align: center;
      color: #fff;
      background-color: #f44336;
      border-radius: 20rpx;
    }
  }
}

.apply-list {
  flex: 1;
  padding: 20rpx;
}

.loading,
.empty {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 100rpx 0;
  font-size: 28rpx;
  color: #999;
  flex-direction: column;

  .loading-spinner {
    width: 60rpx;
    height: 60rpx;
    border: 4rpx solid #f3f3f3;
    border-top: 4rpx solid #2196F3;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  .loading-text {
    margin-top: 20rpx;
  }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.list-content {
  .apply-item {
    padding: 24rpx;
    margin-bottom: 20rpx;
    background-color: #fff;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgb(0 0 0 / 5%);

    .item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16rpx;

      .title {
        font-size: 32rpx;
        font-weight: 600;
        color: #333;
      }

      .status {
        font-size: 26rpx;
        font-weight: 500;
      }
    }

    .item-content {
      .info-row {
        display: flex;
        margin-bottom: 8rpx;
        font-size: 26rpx;
        color: #666;

        .label {
          color: #999;
        }

        .value {
          flex: 1;
        }
      }
    }

    .item-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 16rpx;
      margin-top: 16rpx;
      border-top: 1rpx solid #f0f0f0;

      .time {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}
</style>
