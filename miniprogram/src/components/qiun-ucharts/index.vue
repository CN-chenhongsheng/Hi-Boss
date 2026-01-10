<template>
  <view class="qiun-charts" :style="{ width: containerWidth, height: containerHeight }">
    <canvas
      :id="canvasId"
      :canvas-id="canvasId"
      :type="canvasType"
      class="qiun-charts-canvas"
      :style="{ width: canvasWidth, height: canvasHeight }"
    />
  </view>
</template>

<script setup lang="ts">
import { getCurrentInstance, nextTick, onMounted, onUnmounted, ref, watch } from 'vue';
import uCharts from '@qiun/ucharts/u-charts.js';

const props = withDefaults(defineProps<Props>(), {
  canvasType: '2d',
  opts: () => ({}),
  chartData: () => ({}),
});
// #region agent log - helper function
function logDebug(location: string, message: string, data: any, hypothesisId: string) {
  const logData = {
    location,
    message,
    data,
    timestamp: Date.now(),
    sessionId: 'debug-session',
    runId: 'run1',
    hypothesisId,
  };
  // 同时在控制台打印，方便调试
  console.log(`[qiun-ucharts] ${location}: ${message}`, data);
  // #ifdef H5
  fetch('http://127.0.0.1:7242/ingest/6fa62834-1501-4e3e-b8bb-3a5f99a4c748', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(logData) }).catch((err) => {
    console.error('[qiun-ucharts] Failed to send log:', err);
  });
  // #endif
  // #ifdef MP-WEIXIN
  uni.request({ url: 'http://127.0.0.1:7242/ingest/6fa62834-1501-4e3e-b8bb-3a5f99a4c748', method: 'POST', header: { 'Content-Type': 'application/json' }, data: logData, fail: (err) => {
    console.error('[qiun-ucharts] Failed to send log:', err);
  } });
  // #endif
}
// #endregion

interface Props {
  type: 'line' | 'area' | 'column' | 'bar' | 'pie' | 'ring' | 'radar' | 'gauge' | 'candle' | 'mix';
  opts?: any;
  chartData?: any;
  canvasId: string;
  canvasType?: string;
}

// #region agent log
logDebug('qiun-ucharts/index.vue:16', 'uCharts imported', { hasUCharts: !!uCharts, type: typeof uCharts }, 'A');
// #endregion

let chartInstance: any = null;
let ctx: any = null;

// 保存组件实例，用于 uni.createSelectorQuery().in()
const instance = getCurrentInstance();

const containerWidth = ref('100%');
const containerHeight = ref('100%');
const canvasWidth = ref('750');
const canvasHeight = ref('500');

// 获取容器尺寸（用于计算 canvas 尺寸）
function _getContainerSize() {
  // #ifdef H5
  try {
    const container = document.querySelector('.qiun-charts');
    if (container) {
      const rect = container.getBoundingClientRect();
      return { width: rect.width, height: rect.height };
    }
  }
  catch (error) {
    // ignore
  }
  // #endif
  return { width: 375, height: 250 };
}

// 初始化图�?
function initChart() {
  // #region agent log
  logDebug('qiun-ucharts/index.vue:45', 'initChart called', { canvasId: props.canvasId, hasChartData: !!props.chartData, hasCategories: !!props.chartData?.categories, hasSeries: !!props.chartData?.series, chartData: props.chartData }, 'D,G');
  // #endregion
  if (!props.chartData || !props.chartData.categories || !props.chartData.series) {
    // #region agent log
    logDebug('qiun-ucharts/index.vue:48', 'initChart early return - missing data', {}, 'D');
    // #endregion
    return;
  }

  nextTick(() => {
    try {
      // #ifdef MP-WEIXIN
      // #region agent log
      logDebug('qiun-ucharts/index.vue:53', 'MP-WEIXIN: starting query', { canvasId: props.canvasId, selector: `#${props.canvasId}`, canvasType: props.canvasType, hasInstance: !!instance }, 'B,F');
      // #endregion
      // 在 Vue 3 组合式 API 中，需要指定组件实例作用域
      // 注意：instance 必须在 setup 顶层获取，不能在异步回调中调用 getCurrentInstance()
      const query = instance ? uni.createSelectorQuery().in(instance) : uni.createSelectorQuery();
      // 对于 type="2d" 的 canvas，需要使用 .node() 方法获取 canvas 节点
      query.select(`#${props.canvasId}`).node((canvasRes: any) => {
        // #region agent log
        logDebug('qiun-ucharts/index.vue:101', 'MP-WEIXIN: node query result', { hasCanvasRes: !!canvasRes, hasNode: !!canvasRes?.node, canvasResType: typeof canvasRes }, 'B,C');
        // #endregion
        // 再次查询获取尺寸（需要在同一个组件实例作用域内）
        const sizeQuery = instance ? uni.createSelectorQuery().in(instance) : uni.createSelectorQuery();
        sizeQuery.select(`#${props.canvasId}`).boundingClientRect((sizeRes: any) => {
          // #region agent log
          logDebug('qiun-ucharts/index.vue:57', 'MP-WEIXIN: query result', { hasCanvasRes: !!canvasRes, hasCanvasNode: !!canvasRes?.node, hasSizeRes: !!sizeRes, width: sizeRes?.width, height: sizeRes?.height }, 'B,C');
          // #endregion
          if (canvasRes && canvasRes.node) {
            const canvas = canvasRes.node;
            const dpr = uni.getSystemInfoSync().pixelRatio || 2;

            // #region agent log
            logDebug('qiun-ucharts/index.vue:62', 'MP-WEIXIN: before getContext', { hasCanvas: !!canvas, dpr, width: sizeRes?.width, height: sizeRes?.height }, 'C,E');
            // #endregion
            ctx = canvas.getContext('2d', {});
            // #region agent log
            logDebug('qiun-ucharts/index.vue:63', 'MP-WEIXIN: after getContext', { hasCtx: !!ctx }, 'E');
            // #endregion
            // 从尺寸查询结果获取宽高
            const width = sizeRes?.width || 375;
            let height = sizeRes?.height || 250;

            // 如果高度为 0，尝试从容器计算
            if (height === 0 || height < 10) {
              // #region agent log
              logDebug('qiun-ucharts/index.vue:126', 'MP-WEIXIN: height is 0, calculating from container', { width, height: sizeRes?.height, containerHeight: containerHeight.value }, 'C');
              // #endregion
              if (containerHeight.value.includes('rpx')) {
                height = Number.parseInt(containerHeight.value) / 2;
              }
              else {
                height = Number.parseInt(containerHeight.value) || 250;
              }
            }

            // 如果高度仍然无效，延迟重新获取
            if (height === 0 || height < 10) {
              // 延迟获取父容器实际高度
              setTimeout(() => {
                // 使用保存的实例，而不是在异步回调中调用 getCurrentInstance()
                const parentQuery = instance ? uni.createSelectorQuery().in(instance) : uni.createSelectorQuery();
                parentQuery.select(`#${props.canvasId}`).boundingClientRect((rect: any) => {
                  if (rect && rect.height > 0) {
                    const actualHeight = rect.height;
                    canvas.width = (width || 375) * dpr;
                    canvas.height = actualHeight * dpr;
                    ctx.scale(dpr, dpr);

                    const config = {
                      type: props.type,
                      context: ctx,
                      width: width || 375,
                      height: actualHeight,
                      categories: props.chartData.categories || [],
                      series: props.chartData.series || [],
                      ...props.opts,
                    };

                    if (chartInstance) {
                      chartInstance = null;
                    }
                    chartInstance = new (uCharts as any)(config);
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:162', 'MP-WEIXIN: after delayed uCharts instantiation', { hasInstance: !!chartInstance }, 'A,D');
                    // #endregion
                    if (chartInstance && typeof chartInstance.update === 'function') {
                      chartInstance.update();
                    }
                  }
                  else {
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:168', 'MP-WEIXIN: delayed height query failed', { hasRect: !!rect, rectHeight: rect?.height }, 'C');
                    // #endregion
                  }
                }).exec();
              }, 200);
              return;
            }

            // 确保 canvas 有有效的尺寸
            canvas.width = (width || 375) * dpr;
            canvas.height = (height || 250) * dpr;
            ctx.scale(dpr, dpr);

            const config = {
              type: props.type,
              context: ctx,
              width,
              height,
              categories: props.chartData.categories || [],
              series: props.chartData.series || [],
              ...props.opts,
            };

            // #region agent log
            logDebug('qiun-ucharts/index.vue:186', 'MP-WEIXIN: before uCharts instantiation', { hasUCharts: !!uCharts, configType: config.type, configWidth: config.width, configHeight: config.height, categoriesLen: config.categories?.length, seriesLen: config.series?.length }, 'A,D');
            // #endregion
            if (chartInstance) {
              chartInstance = null;
            }
            chartInstance = new (uCharts as any)(config);
            // #region agent log
            logDebug('qiun-ucharts/index.vue:194', 'MP-WEIXIN: after uCharts instantiation', { hasInstance: !!chartInstance, chartWidth: canvas.width, chartHeight: canvas.height, configWidth: config.width, configHeight: config.height }, 'A,D');
            // #endregion

            // 确保图表立即渲染
            if (chartInstance && typeof chartInstance.update === 'function') {
              // #region agent log
              logDebug('qiun-ucharts/index.vue:199', 'MP-WEIXIN: calling chart update', { hasUpdateMethod: typeof chartInstance.update === 'function' }, 'D');
              // #endregion
              chartInstance.update();
            }
          }
          else {
            // #region agent log
            logDebug('qiun-ucharts/index.vue:207', 'MP-WEIXIN: canvas not found or invalid', { hasCanvasRes: !!canvasRes, hasCanvasNode: !!canvasRes?.node, hasSizeRes: !!sizeRes }, 'B');
            // #endregion
          }
        }).exec();
      }).exec();
      // #endif

      // #ifdef H5
      // H5 中增加延迟，确保容器尺寸已经渲染完成
      setTimeout(() => {
        // #region agent log
        logDebug('qiun-ucharts/index.vue:88', 'H5: starting canvas lookup', { canvasId: props.canvasId }, 'B,F');
        // #endregion
        // 在 H5 中，先尝试使用 uni.createSelectorQuery 获取 canvas（与 MP-WEIXIN 保持一致）
        const query = uni.createSelectorQuery();
        query.select(`#${props.canvasId}`)
          .fields({ node: true, size: true })
          .exec((res: any) => {
            // #region agent log
            logDebug('qiun-ucharts/index.vue:90', 'H5: query result', { hasRes: !!res, resLength: res?.length, hasRes0: !!res?.[0], hasNode: !!res?.[0]?.node, width: res?.[0]?.width, height: res?.[0]?.height }, 'B,C');
            // #endregion
            if (res && res[0] !== null && res[0] !== undefined && res[0].node) {
              // 使用 query 返回的 canvas node
              const canvas = res[0].node;
              // 如果 height 为 0，使用容器高度或默认值
              let width = res[0].width || 375;
              let height = res[0].height || 250;

              // 如果高度为 0，尝试从容器获取或使用默认值
              if (height === 0 || height < 10) {
                // #region agent log
                logDebug('qiun-ucharts/index.vue:173', 'H5: height is 0, calculating from container', { width, height: res[0].height, containerHeight: containerHeight.value }, 'C');
                // #endregion
                // 如果 containerHeight 是 100%，尝试从父容器获取实际高度
                if (containerHeight.value === '100%') {
                  try {
                    // 优先使用 canvas 的父容器获取尺寸
                    // canvas 的父容器是 .qiun-charts，其父容器是 .chart-container
                    const canvas = document.getElementById(props.canvasId) as HTMLElement;
                    if (canvas) {
                      // 先查找 .qiun-charts 容器
                      const container = canvas.parentElement;
                      if (container && container.classList.contains('qiun-charts')) {
                        // 如果 .qiun-charts 的高度为 0，尝试查找其父容器 .chart-container
                        const qiunRect = container.getBoundingClientRect();
                        // #region agent log
                        logDebug('qiun-ucharts/index.vue:260', 'H5: .qiun-charts rect', { rectHeight: qiunRect.height, rectWidth: qiunRect.width, canvasId: props.canvasId }, 'C');
                        // #endregion
                        if (qiunRect.height > 0) {
                          height = qiunRect.height;
                        }
                        else {
                          // 尝试从 .chart-container 获取高度
                          const chartContainer = container.parentElement;
                          if (chartContainer) {
                            const chartRect = chartContainer.getBoundingClientRect();
                            // #region agent log
                            logDebug('qiun-ucharts/index.vue:272', 'H5: .chart-container rect', { rectHeight: chartRect.height, rectWidth: chartRect.width }, 'C');
                            // #endregion
                            if (chartRect.height > 0) {
                              height = chartRect.height;
                            }
                            else {
                              // 如果父容器高度也为 0，尝试从 canvas 自身获取
                              const canvasRect = canvas.getBoundingClientRect();
                              if (canvasRect.height > 0) {
                                height = canvasRect.height;
                              }
                              else {
                                height = 250; // 默认值
                              }
                            }
                          }
                          else {
                            height = 250; // 默认值
                          }
                        }
                      }
                      else {
                        // canvas 的父容器不是 .qiun-charts，尝试直接从 canvas 获取
                        const canvasRect = canvas.getBoundingClientRect();
                        if (canvasRect.height > 0) {
                          height = canvasRect.height;
                        }
                        else {
                          height = 250; // 默认值
                        }
                      }
                    }
                    else {
                      // 回退到查找 .qiun-charts
                      const fallbackContainer = document.querySelector('.qiun-charts') as HTMLElement;
                      if (fallbackContainer) {
                        const rect = fallbackContainer.getBoundingClientRect();
                        if (rect.height > 0) {
                          height = rect.height;
                        }
                        else {
                          height = 250; // 默认值
                        }
                      }
                      else {
                        height = 250; // 默认值
                      }
                    }
                  }
                  catch (error) {
                    height = 250; // 默认值
                  }
                }
                else if (containerHeight.value.includes('rpx')) {
                  height = Number.parseInt(containerHeight.value) / 2;
                }
                else {
                  height = Number.parseInt(containerHeight.value) || 250;
                }
                // 如果宽度也为 0，也使用默认值
                if (width === 0 || width < 10) {
                  if (containerWidth.value.includes('rpx')) {
                    width = Number.parseInt(containerWidth.value) / 2;
                  }
                  else if (containerWidth.value === '100%') {
                    // 100% 宽度，尝试从窗口获取
                    const systemInfo = uni.getSystemInfoSync();
                    width = systemInfo.windowWidth || 375;
                  }
                  else {
                    width = Number.parseInt(containerWidth.value) || 375;
                  }
                }
              }

              // #region agent log
              logDebug('qiun-ucharts/index.vue:98', 'H5: before getContext', { hasCanvas: !!canvas, width, height, hasGetContext: typeof canvas?.getContext }, 'E');
              // #endregion
              try {
                ctx = canvas.getContext('2d', {});
                // #region agent log
                logDebug('qiun-ucharts/index.vue:100', 'H5: after getContext', { hasCtx: !!ctx }, 'E');
                // #endregion
              }
              catch (error: any) {
                // #region agent log
                logDebug('qiun-ucharts/index.vue:103', 'H5: getContext error', { error: error?.message, stack: error?.stack }, 'E');
                // #endregion
                console.error('获取 canvas context 失败:', error);
                return;
              }

              if (ctx) {
                // 确保 canvas 有有效的尺寸
                // 在 H5 中，canvas 的实际像素尺寸需要考虑设备像素比（DPR）
                // 获取 canvas 元素的 CSS 显示尺寸
                const canvasElement = canvas as HTMLElement;
                const computedStyle = window.getComputedStyle(canvasElement);
                const cssWidth = Number.parseFloat(computedStyle.width) || width || 375;
                const cssHeight = Number.parseFloat(computedStyle.height) || height || 250;

                // 获取设备像素比
                const dpr = window.devicePixelRatio || 1;

                // 在移动设备上，为了确保图表完整显示，我们需要考虑 DPR
                // 但是 uCharts 可能不能正确处理 DPR 缩放，所以我们需要调整策略
                // 方案：不缩放 context，直接使用 CSS 尺寸作为 canvas 的实际像素尺寸
                // 这样可以避免缩放导致的坐标系统问题
                // 使用 Math.round 确保 canvas 尺寸是整数，避免小数导致的渲染问题
                canvas.width = Math.round(cssWidth);
                canvas.height = Math.round(cssHeight);

                // 不缩放 context，直接使用 CSS 尺寸
                // ctx.scale(dpr, dpr); // 注释掉，避免坐标系统问题

                // #region agent log
                logDebug('qiun-ucharts/index.vue:318', 'H5: canvas dimensions set', { canvasWidth: canvas.width, canvasHeight: canvas.height, cssWidth, cssHeight, dpr, width, height }, 'C');
                // #endregion

                // uCharts 会自动处理 padding，所以直接传递完整的 CSS 尺寸
                // 使用 Math.round 确保传递给 uCharts 的尺寸是整数，避免小数导致的渲染问题
                // 在移动设备上，为了确保图表不被裁剪，我们稍微减少传递给 uCharts 的尺寸（减去 4px 作为安全边距）
                const safeMargin = 4; // 安全边距，避免图表被裁剪
                const configWidth = Math.max(1, Math.round(cssWidth) - safeMargin * 2);
                const configHeight = Math.max(1, Math.round(cssHeight));
                const config = {
                  type: props.type,
                  context: ctx,
                  width: configWidth, // uCharts 使用逻辑尺寸（CSS 尺寸），会自动减去 padding
                  height: configHeight,
                  categories: props.chartData.categories || [],
                  series: props.chartData.series || [],
                  ...props.opts,
                };

                // #region agent log
                logDebug('qiun-ucharts/index.vue:114', 'H5: before uCharts instantiation', { hasUCharts: !!uCharts, configType: config.type, configWidth: config.width, configHeight: config.height, cssWidth, cssHeight, canvasWidth: canvas.width, canvasHeight: canvas.height, padding: props.opts?.padding, dpr, safeMargin }, 'A,D');
                // #endregion
                if (chartInstance) {
                  chartInstance = null;
                }
                chartInstance = new (uCharts as any)(config);
                // #region agent log
                const instanceMethods = chartInstance ? Object.keys(chartInstance).filter(key => typeof chartInstance[key] === 'function').slice(0, 15) : [];
                logDebug('qiun-ucharts/index.vue:120', 'H5: after uCharts instantiation', { hasInstance: !!chartInstance, hasUpdate: typeof chartInstance?.update === 'function', hasUpdateData: typeof chartInstance?.updateData === 'function', methods: instanceMethods }, 'A,D');
                // #endregion

                // 确保图表立即渲染
                // #region agent log
                logDebug('qiun-ucharts/index.vue:430', 'H5: before checking update method', { hasInstance: !!chartInstance, hasUpdate: typeof chartInstance?.update === 'function' }, 'D');
                // #endregion
                if (chartInstance) {
                  // #region agent log
                  logDebug('qiun-ucharts/index.vue:433', 'H5: chartInstance exists, checking methods', { hasUpdate: typeof chartInstance.update === 'function', hasUpdateData: typeof chartInstance.updateData === 'function', hasRender: typeof chartInstance.render === 'function', hasDraw: typeof chartInstance.draw === 'function' }, 'D');
                  // #endregion
                  // uCharts 可能在构造函数中已经渲染，或者需要调用 updateData 而不是 update
                  if (typeof chartInstance.update === 'function') {
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:340', 'H5: calling chart update', { hasUpdateMethod: typeof chartInstance.update === 'function' }, 'D');
                    // #endregion
                    chartInstance.update();

                    // #region agent log
                    // 检查图表绘制区域
                    setTimeout(() => {
                      const canvasElement = canvas as HTMLElement;
                      const rect = canvasElement.getBoundingClientRect();
                      const computedStyle = window.getComputedStyle(canvasElement);
                      logDebug('qiun-ucharts/index.vue:350', 'H5: after chart update - canvas dimensions check', {
                        canvasWidth: canvas.width,
                        canvasHeight: canvas.height,
                        canvasCSSWidth: computedStyle.width,
                        canvasCSSHeight: computedStyle.height,
                        canvasRectWidth: rect.width,
                        canvasRectHeight: rect.height,
                        configWidth: config.width,
                        configHeight: config.height,
                        padding: props.opts?.padding,
                        dpr: window.devicePixelRatio || 1,
                      }, 'C');
                    }, 100);
                    // #endregion
                  }
                  else if (typeof chartInstance.updateData === 'function') {
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:443', 'H5: calling chart updateData instead', { hasUpdateDataMethod: typeof chartInstance.updateData === 'function' }, 'D');
                    // #endregion
                    chartInstance.updateData({
                      categories: props.chartData.categories || [],
                      series: props.chartData.series || [],
                    });

                    // #region agent log
                    // 检查图表绘制区域
                    setTimeout(() => {
                      const canvasElement = canvas as HTMLElement;
                      const rect = canvasElement.getBoundingClientRect();
                      const computedStyle = window.getComputedStyle(canvasElement);
                      logDebug('qiun-ucharts/index.vue:460', 'H5: after chart updateData - canvas dimensions check', {
                        canvasWidth: canvas.width,
                        canvasHeight: canvas.height,
                        canvasCSSWidth: computedStyle.width,
                        canvasCSSHeight: computedStyle.height,
                        canvasRectWidth: rect.width,
                        canvasRectHeight: rect.height,
                        configWidth: config.width,
                        configHeight: config.height,
                        padding: props.opts?.padding,
                        dpr: window.devicePixelRatio || 1,
                      }, 'C');
                    }, 100);
                    // #endregion
                  }
                  else {
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:475', 'H5: no update method found, chart may render automatically', { hasInstance: !!chartInstance, methods: instanceMethods }, 'D');
                    // #endregion
                  }

                  // #region agent log
                  // 检查图表绘制区域
                  setTimeout(() => {
                    const canvasElement = canvas as HTMLElement;
                    const rect = canvasElement.getBoundingClientRect();
                    const computedStyle = window.getComputedStyle(canvasElement);
                    logDebug('qiun-ucharts/index.vue:350', 'H5: after chart update - canvas dimensions check', {
                      canvasWidth: canvas.width,
                      canvasHeight: canvas.height,
                      canvasCSSWidth: computedStyle.width,
                      canvasCSSHeight: computedStyle.height,
                      canvasRectWidth: rect.width,
                      canvasRectHeight: rect.height,
                      configWidth: config.width,
                      configHeight: config.height,
                      padding: props.opts?.padding,
                      dpr: window.devicePixelRatio || 1,
                    }, 'C');
                  }, 100);
                  // #endregion
                }
              }
            }
            else {
              // 如果 query 失败，回退到 document.getElementById
              // #region agent log
              logDebug('qiun-ucharts/index.vue:125', 'H5: query failed, trying document.getElementById', { canvasId: props.canvasId }, 'B');
              // #endregion
              const canvas = document.getElementById(props.canvasId) as HTMLCanvasElement;
              // #region agent log
              logDebug('qiun-ucharts/index.vue:128', 'H5: document.getElementById result', { hasCanvas: !!canvas, isCanvas: canvas instanceof HTMLCanvasElement, hasGetContext: typeof canvas?.getContext }, 'B');
              // #endregion
              if (canvas && canvas instanceof HTMLCanvasElement && typeof canvas.getContext === 'function') {
                try {
                  ctx = canvas.getContext('2d');
                  // #region agent log
                  logDebug('qiun-ucharts/index.vue:132', 'H5: getContext result (fallback)', { hasCtx: !!ctx }, 'E');
                  // #endregion
                }
                catch (error: any) {
                  // #region agent log
                  logDebug('qiun-ucharts/index.vue:135', 'H5: getContext error (fallback)', { error: error?.message }, 'E');
                  // #endregion
                  console.error('获取 canvas context 失败 (fallback):', error);
                  return;
                }

                if (ctx) {
                  const rect = canvas.getBoundingClientRect();
                  const cssWidth = rect.width || 375;
                  const cssHeight = rect.height || 250;

                  // 获取设备像素比
                  const dpr = window.devicePixelRatio || 1;

                  // 在移动设备上，为了确保图表完整显示，我们需要考虑 DPR
                  // 但是 uCharts 可能不能正确处理 DPR 缩放，所以我们需要调整策略
                  // 方案：不缩放 context，直接使用 CSS 尺寸作为 canvas 的实际像素尺寸
                  // 这样可以避免缩放导致的坐标系统问题
                  // 使用 Math.round 确保 canvas 尺寸是整数，避免小数导致的渲染问题
                  const canvasWidthInt = Math.round(cssWidth);
                  const canvasHeightInt = Math.round(cssHeight);
                  canvas.width = canvasWidthInt;
                  canvas.height = canvasHeightInt;

                  // 不缩放 context，直接使用 CSS 尺寸
                  // ctx.scale(dpr, dpr); // 注释掉，避免坐标系统问题

                  // #region agent log
                  logDebug('qiun-ucharts/index.vue:442', 'H5: canvas dimensions set (fallback)', { canvasWidth: canvas.width, canvasHeight: canvas.height, cssWidth, cssHeight, canvasWidthInt, canvasHeightInt, dpr }, 'C');
                  // #endregion

                  // uCharts 会自动处理 padding，所以直接传递完整的 CSS 尺寸
                  // 使用 Math.round 确保传递给 uCharts 的尺寸是整数，避免小数导致的渲染问题
                  // 在移动设备上，为了确保图表不被裁剪，我们稍微减少传递给 uCharts 的尺寸（减去 4px 作为安全边距）
                  const safeMargin = 4; // 安全边距，避免图表被裁剪
                  const configWidth = Math.max(1, Math.round(cssWidth) - safeMargin * 2);
                  const configHeight = Math.max(1, Math.round(cssHeight));
                  const config = {
                    type: props.type,
                    context: ctx,
                    width: configWidth, // uCharts 使用逻辑尺寸（CSS 尺寸），会自动减去 padding
                    height: configHeight,
                    categories: props.chartData.categories || [],
                    series: props.chartData.series || [],
                    ...props.opts,
                  };

                  // #region agent log
                  logDebug('qiun-ucharts/index.vue:153', 'H5: before uCharts instantiation (fallback)', { hasUCharts: !!uCharts, configType: config.type, configWidth: config.width, configHeight: config.height, cssWidth, cssHeight, canvasWidth: canvas.width, canvasHeight: canvas.height, padding: props.opts?.padding, dpr }, 'A,D');
                  // #endregion
                  if (chartInstance) {
                    chartInstance = null;
                  }
                  chartInstance = new (uCharts as any)(config);
                  // #region agent log
                  const instanceMethodsFallback = chartInstance ? Object.keys(chartInstance).filter(key => typeof chartInstance[key] === 'function').slice(0, 15) : [];
                  logDebug('qiun-ucharts/index.vue:159', 'H5: after uCharts instantiation (fallback)', { hasInstance: !!chartInstance, hasUpdate: typeof chartInstance?.update === 'function', hasUpdateData: typeof chartInstance?.updateData === 'function', methods: instanceMethodsFallback }, 'A,D');
                  // #endregion

                  // 确保图表立即渲染
                  if (chartInstance) {
                    // #region agent log
                    logDebug('qiun-ucharts/index.vue:540', 'H5: chartInstance exists (fallback), checking methods', { hasUpdate: typeof chartInstance.update === 'function', hasUpdateData: typeof chartInstance.updateData === 'function' }, 'D');
                    // #endregion
                    // uCharts 可能在构造函数中已经渲染，或者需要调用 updateData 而不是 update
                    if (typeof chartInstance.update === 'function') {
                      // #region agent log
                      logDebug('qiun-ucharts/index.vue:401', 'H5: calling chart update (fallback)', { hasUpdateMethod: typeof chartInstance.update === 'function' }, 'D');
                      // #endregion
                      chartInstance.update();

                      // #region agent log
                      // 检查图表绘制区域
                      setTimeout(() => {
                        const rect = canvas.getBoundingClientRect();
                        logDebug('qiun-ucharts/index.vue:510', 'H5: after chart update (fallback) - canvas dimensions check', {
                          canvasWidth: canvas.width,
                          canvasHeight: canvas.height,
                          canvasRectWidth: rect.width,
                          canvasRectHeight: rect.height,
                          configWidth: config.width,
                          configHeight: config.height,
                          padding: props.opts?.padding,
                          dpr: window.devicePixelRatio || 1,
                        }, 'C');
                      }, 100);
                      // #endregion
                    }
                    else if (typeof chartInstance.updateData === 'function') {
                      // #region agent log
                      logDebug('qiun-ucharts/index.vue:547', 'H5: calling chart updateData (fallback) instead', { hasUpdateDataMethod: typeof chartInstance.updateData === 'function' }, 'D');
                      // #endregion
                      chartInstance.updateData({
                        categories: props.chartData.categories || [],
                        series: props.chartData.series || [],
                      });

                      // #region agent log
                      // 检查图表绘制区域
                      setTimeout(() => {
                        const rect = canvas.getBoundingClientRect();
                        logDebug('qiun-ucharts/index.vue:565', 'H5: after chart updateData (fallback) - canvas dimensions check', {
                          canvasWidth: canvas.width,
                          canvasHeight: canvas.height,
                          canvasRectWidth: rect.width,
                          canvasRectHeight: rect.height,
                          configWidth: config.width,
                          configHeight: config.height,
                          padding: props.opts?.padding,
                          dpr: window.devicePixelRatio || 1,
                        }, 'C');
                      }, 100);
                      // #endregion
                    }
                    else {
                      // #region agent log
                      logDebug('qiun-ucharts/index.vue:580', 'H5: no update method found (fallback), chart may render automatically', { hasInstance: !!chartInstance, methods: instanceMethodsFallback }, 'D');
                      // #endregion
                    }
                  }
                }
              }
            }
          });
      }, 500);
      // #endif
    }
    catch (error: any) {
      // #region agent log
      logDebug('qiun-ucharts/index.vue:126', 'initChart catch error', { error: error?.message, stack: error?.stack, name: error?.name }, 'A,D');
      // #endregion
      console.error('图表初始化失�?', error);
    }
  });
}

// 更新图表
function updateChart() {
  if (chartInstance && props.chartData) {
    try {
      chartInstance.updateData({
        categories: props.chartData.categories || [],
        series: props.chartData.series || [],
      });
    }
    catch (error) {
      console.error('图表更新失败:', error);
    }
  }
}

// 销毁图�?
function destroyChart() {
  if (chartInstance) {
    try {
      chartInstance = null;
    }
    catch (error) {
      console.error('图表销毁失�?', error);
    }
  }
  ctx = null;
}

// 监听数据变化
watch(
  () => [props.chartData, props.opts],
  () => {
    if (chartInstance) {
      updateChart();
    }
    else {
      initChart();
    }
  },
  { deep: true },
);

onMounted(() => {
  // #region agent log
  logDebug('qiun-ucharts/index.vue:164', 'onMounted called', { canvasId: props.canvasId }, 'F');
  // #endregion
  // #ifdef MP-WEIXIN
  // 微信小程序中 canvas 渲染需要更多时间，延迟更久
  setTimeout(() => {
    initChart();
  }, 500);
  // #endif
  // #ifdef H5
  // H5 中增加延迟，确保 DOM 和容器尺寸都已渲染完成
  setTimeout(() => {
    initChart();
  }, 800);
  // #endif
});

onUnmounted(() => {
  destroyChart();
});
</script>

<style scoped lang="scss">
.qiun-charts {
  position: relative;
  overflow: visible;
  width: 100%;
  height: 100%;
}

.qiun-charts-canvas {
  display: block;
  width: 100%;
  height: 100%;
}
</style>
