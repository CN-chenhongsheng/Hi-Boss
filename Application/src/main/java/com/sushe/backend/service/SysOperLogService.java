package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.operlog.OperLogQueryDTO;
import com.sushe.backend.entity.SysOperLog;
import com.sushe.backend.vo.OperLogVO;

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

    /**
     * 分页查询操作日志列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<OperLogVO> pageList(OperLogQueryDTO queryDTO);

    /**
     * 根据ID获取操作日志详情
     * 
     * @param id 日志ID
     * @return 日志详情
     */
    OperLogVO getDetailById(Long id);

    /**
     * 批量删除操作日志
     * 
     * @param ids 日志ID数组
     * @return 是否成功
     */
    boolean batchDelete(Long[] ids);

    /**
     * 清空操作日志
     * 
     * @return 是否成功
     */
    boolean clean();
}

