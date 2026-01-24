/**
 * 签名 Canvas 管理组合式函数
 */

import { nextTick, ref } from 'vue';

interface SignatureCanvasConfig {
  canvasWidth: number;
  canvasHeight: number;
}

export function useSignatureCanvas(config: SignatureCanvasConfig) {
  let signatureCtx: any = null;
  const isDrawing = ref(false);
  let lastX = 0;
  let lastY = 0;

  /**
   * 初始化签名画布
   */
  function initSignatureCanvas() {
    // #ifdef MP-WEIXIN
    nextTick(() => {
      setTimeout(() => {
        const query = uni.createSelectorQuery();
        query.select('#signatureCanvas').node((res: any) => {
          const canvas = res.node;
          if (canvas) {
            signatureCtx = canvas.getContext('2d');
            if (signatureCtx) {
              const canvasWidthPx = config.canvasWidth / 2;
              const canvasHeightPx = config.canvasHeight / 2;
              const dpr = uni.getSystemInfoSync().pixelRatio || 2;

              canvas.width = canvasWidthPx * dpr;
              canvas.height = canvasHeightPx * dpr;

              signatureCtx.scale(dpr, dpr);
              signatureCtx.strokeStyle = '#111817';
              signatureCtx.lineWidth = 3;
              signatureCtx.lineCap = 'round';
              signatureCtx.lineJoin = 'round';
            }
          }
        }).exec();
      }, 100);
    });
    // #endif

    // #ifdef H5
    nextTick(() => {
      setTimeout(() => {
        const canvas = document.getElementById('signatureCanvas') as HTMLCanvasElement;
        if (canvas && canvas instanceof HTMLCanvasElement) {
          signatureCtx = canvas.getContext('2d');
          if (signatureCtx) {
            canvas.width = config.canvasWidth;
            canvas.height = config.canvasHeight;
            signatureCtx.strokeStyle = '#111817';
            signatureCtx.lineWidth = 3;
            signatureCtx.lineCap = 'round';
            signatureCtx.lineJoin = 'round';
          }
        }
      }, 100);
    });
    // #endif
  }

  /**
   * 处理触摸开始
   */
  function handleTouchStart(e: TouchEvent) {
    isDrawing.value = true;
    const touch = e.touches[0];

    // #ifdef MP-WEIXIN
    const query = uni.createSelectorQuery();
    query.select('#signatureCanvas').boundingClientRect((rect: any) => {
      if (rect) {
        const touchWithXY = touch as any;
        lastX = (touch.clientX || touchWithXY.x) - rect.left;
        lastY = (touch.clientY || touchWithXY.y) - rect.top;
        if (signatureCtx) {
          signatureCtx.beginPath();
          signatureCtx.moveTo(lastX, lastY);
        }
      }
    }).exec();
    // #endif

    // #ifdef H5
    const rect = (e.target as HTMLElement).getBoundingClientRect();
    lastX = e.touches[0].clientX - rect.left;
    lastY = e.touches[0].clientY - rect.top;
    if (signatureCtx) {
      signatureCtx.beginPath();
      signatureCtx.moveTo(lastX, lastY);
    }
    // #endif
  }

  /**
   * 处理触摸移动
   */
  function handleTouchMove(e: TouchEvent) {
    if (!isDrawing.value || !signatureCtx) return;
    e.preventDefault();
    const touch = e.touches[0];

    // #ifdef MP-WEIXIN
    const query = uni.createSelectorQuery();
    query.select('#signatureCanvas').boundingClientRect((data: any) => {
      if (data) {
        const touchWithXY = touch as any;
        const currentX = (touch.clientX || touchWithXY.x) - data.left;
        const currentY = (touch.clientY || touchWithXY.y) - data.top;
        signatureCtx.lineTo(currentX, currentY);
        signatureCtx.stroke();
        lastX = currentX;
        lastY = currentY;
      }
    }).exec();
    // #endif

    // #ifdef H5
    const rect = (e.target as HTMLElement).getBoundingClientRect();
    const currentX = e.touches[0].clientX - rect.left;
    const currentY = e.touches[0].clientY - rect.top;
    signatureCtx.lineTo(currentX, currentY);
    signatureCtx.stroke();
    lastX = currentX;
    lastY = currentY;
    // #endif
  }

  /**
   * 处理触摸结束
   */
  function handleTouchEnd() {
    isDrawing.value = false;
  }

  /**
   * 清除签名
   */
  function clearSignature() {
    if (!signatureCtx) return;
    const canvasWidthPx = config.canvasWidth / 2;
    const canvasHeightPx = config.canvasHeight / 2;
    signatureCtx.clearRect(0, 0, canvasWidthPx, canvasHeightPx);
  }

  /**
   * 导出签名
   */
  function exportSignature(): Promise<string> {
    return new Promise((resolve, reject) => {
      // #ifdef MP-WEIXIN
      nextTick(() => {
        const query = uni.createSelectorQuery();
        query.select('#signatureCanvas').node((res: any) => {
          const canvas = res.node;
          if (canvas) {
            const canvasWidthPx = config.canvasWidth / 2;
            const canvasHeightPx = config.canvasHeight / 2;

            uni.canvasToTempFilePath({
              canvas: canvas as any,
              width: canvasWidthPx,
              height: canvasHeightPx,
              destWidth: canvasWidthPx,
              destHeight: canvasHeightPx,
              success: (res: any) => {
                resolve(res.tempFilePath);
              },
              fail: (err: any) => {
                console.error('导出签名失败:', err);
                reject(err);
              },
            } as any);
          }
          else {
            reject(new Error('Canvas not found'));
          }
        }).exec();
      });
      // #endif

      // #ifdef H5
      setTimeout(() => {
        const canvas = document.getElementById('signatureCanvas') as HTMLCanvasElement;
        if (canvas && canvas instanceof HTMLCanvasElement) {
          try {
            const dataUrl = canvas.toDataURL('image/png');
            resolve(dataUrl);
          }
          catch (error) {
            console.error('导出签名失败:', error);
            reject(error);
          }
        }
        else {
          reject(new Error('Canvas not found'));
        }
      }, 100);
      // #endif
    });
  }

  return {
    isDrawing,
    initSignatureCanvas,
    handleTouchStart,
    handleTouchMove,
    handleTouchEnd,
    clearSignature,
    exportSignature,
  };
}
