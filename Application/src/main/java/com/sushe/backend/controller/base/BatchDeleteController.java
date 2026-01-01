package com.sushe.backend.controller.base;

import com.sushe.backend.common.result.R;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * 批量删除控制器接口
 * 提供批量删除方法
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
public interface BatchDeleteController {

    /**
     * 获取实体名称（用于日志输出）
     * 
     * @return 实体名称，如"校区"、"院系"等
     */
    String getEntityName();

    /**
     * 调用Service的批量删除方法
     * 
     * @param ids 主键ID数组
     * @return 是否成功
     */
    boolean callBatchDelete(Long[] ids);

    /**
     * 批量删除
     */
    @DeleteMapping("/batch")
    @Operation(summary = "批量删除")
    default R<Void> batchDelete(@RequestBody Long[] ids) {
        boolean success = callBatchDelete(ids);
        return R.status(success);
    }
}

