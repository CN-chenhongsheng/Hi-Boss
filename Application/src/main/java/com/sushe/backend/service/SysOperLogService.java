package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.entity.SysOperLog;

/**
 * 操作日志Service
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
public interface SysOperLogService extends IService<SysOperLog> {

    /**
     * 异步保存操作日志
     * 
     * @param operLog 操作日志
     */
    void saveOperLog(SysOperLog operLog);
}

