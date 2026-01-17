package com.sushe.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.dto.approval.ApprovalFlowBindingDTO;
import com.sushe.backend.dto.approval.ApprovalFlowQueryDTO;
import com.sushe.backend.dto.approval.ApprovalFlowSaveDTO;
import com.sushe.backend.entity.SysApprovalFlow;
import com.sushe.backend.vo.ApprovalFlowBindingVO;
import com.sushe.backend.vo.ApprovalFlowVO;

import java.util.List;

/**
 * 审批流程Service
 * 
 * @author 系统生成
 * @since 2026-01-17
 */
public interface SysApprovalFlowService extends IService<SysApprovalFlow> {

    /**
     * 分页查询流程列表
     * 
     * @param queryDTO 查询条件
     * @return 流程分页列表
     */
    PageResult<ApprovalFlowVO> pageList(ApprovalFlowQueryDTO queryDTO);

    /**
     * 查询所有启用的流程列表
     * 
     * @param businessType 业务类型（可选）
     * @return 流程列表
     */
    List<ApprovalFlowVO> listAll(String businessType);

    /**
     * 根据ID获取流程详情（包含节点和审批人）
     * 
     * @param id 流程ID
     * @return 流程详情
     */
    ApprovalFlowVO getDetailById(Long id);

    /**
     * 保存流程（新增或编辑，包含节点和审批人）
     * 
     * @param saveDTO 流程保存DTO
     * @return 是否成功
     */
    boolean saveFlow(ApprovalFlowSaveDTO saveDTO);

    /**
     * 删除流程
     * 
     * @param id 流程ID
     * @return 是否成功
     */
    boolean deleteFlow(Long id);

    /**
     * 更新流程状态
     * 
     * @param id 流程ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateStatus(Long id, Integer status);

    /**
     * 获取业务类型绑定的流程
     * 
     * @param businessType 业务类型
     * @return 绑定信息
     */
    ApprovalFlowBindingVO getBindingByBusinessType(String businessType);

    /**
     * 获取所有流程绑定列表
     * 
     * @return 绑定列表
     */
    List<ApprovalFlowBindingVO> listAllBindings();

    /**
     * 绑定流程到业务类型
     * 
     * @param bindingDTO 绑定DTO
     * @return 是否成功
     */
    boolean bindFlow(ApprovalFlowBindingDTO bindingDTO);

    /**
     * 解绑流程
     * 
     * @param businessType 业务类型
     * @return 是否成功
     */
    boolean unbindFlow(String businessType);
}
