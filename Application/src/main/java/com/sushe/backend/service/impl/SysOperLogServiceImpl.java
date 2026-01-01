package com.sushe.backend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sushe.backend.entity.SysOperLog;
import com.sushe.backend.mapper.SysOperLogMapper;
import com.sushe.backend.service.SysOperLogService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 操作日志Service实现
 * 
 * @author 陈鸿昇
 * @since 2025-01-01
 */
@Slf4j
@Service
public class SysOperLogServiceImpl extends ServiceImpl<SysOperLogMapper, SysOperLog> implements SysOperLogService {

    /**
     * 异步保存操作日志
     */
    @Override
    @Async
    public void saveOperLog(SysOperLog operLog) {
        try {
            save(operLog);
        } catch (Exception e) {
            log.error("保存操作日志失败", e);
        }
    }
}

