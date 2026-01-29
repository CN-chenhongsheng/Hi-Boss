package com.project.backend.repair.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.project.backend.repair.dto.RepairQueryDTO;
import com.project.backend.repair.dto.RepairSaveDTO;
import com.project.backend.repair.entity.Repair;
import com.project.backend.repair.mapper.RepairMapper;
import com.project.backend.repair.service.RepairService;
import com.project.backend.repair.vo.RepairVO;
import com.project.backend.util.DictUtils;
import com.project.core.context.UserContext;
import com.project.core.exception.BusinessException;
import com.project.core.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 报修管理Service实现
 *
 * @author 陈鸿昇
 * @since 2026-01-29
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RepairServiceImpl extends ServiceImpl<RepairMapper, Repair> implements RepairService {

    @Override
    public PageResult<RepairVO> pageList(RepairQueryDTO queryDTO) {
        LambdaQueryWrapper<Repair> wrapper = buildQueryWrapper(queryDTO);

        Page<Repair> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        page(page, wrapper);

        List<RepairVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        return PageResult.build(voList, page.getTotal(), page.getCurrent(), page.getSize());
    }

    @Override
    public RepairVO getDetailById(Long id) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }
        return convertToVO(repair);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean saveRepair(RepairSaveDTO saveDTO) {
        Repair repair = new Repair();
        BeanUtil.copyProperties(saveDTO, repair);

        // 处理图片列表
        if (saveDTO.getFaultImages() != null && !saveDTO.getFaultImages().isEmpty()) {
            repair.setFaultImages(JSONUtil.toJsonStr(saveDTO.getFaultImages()));
        }
        if (saveDTO.getRepairImages() != null && !saveDTO.getRepairImages().isEmpty()) {
            repair.setRepairImages(JSONUtil.toJsonStr(saveDTO.getRepairImages()));
        }

        return saveOrUpdate(repair);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteRepair(Long id) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }

        // 只能删除待接单或已取消的报修
        if (repair.getStatus() != 1 && repair.getStatus() != 5) {
            throw new BusinessException("只能删除待接单或已取消的报修记录");
        }

        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean batchDelete(Long[] ids) {
        if (ids == null || ids.length == 0) {
            throw new BusinessException("请选择要删除的记录");
        }

        // 检查所有记录的状态
        List<Repair> repairs = listByIds(Arrays.asList(ids));
        for (Repair repair : repairs) {
            if (repair.getStatus() != 1 && repair.getStatus() != 5) {
                throw new BusinessException("只能删除待接单或已取消的报修记录");
            }
        }

        return removeByIds(Arrays.asList(ids));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean submitRepair(RepairSaveDTO saveDTO) {
        // 设置默认状态为待接单
        saveDTO.setStatus(1);

        // 获取当前登录用户信息
        Long userId = UserContext.getUserId();
        if (userId != null) {
            saveDTO.setStudentId(userId);
        }

        return saveRepair(saveDTO);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelRepair(Long id) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }

        // 验证权限：只能取消自己的报修
        Long userId = UserContext.getUserId();
        if (userId != null && !userId.equals(repair.getStudentId())) {
            throw new BusinessException("无权取消该报修记录");
        }

        // 只能取消待接单或已接单的报修
        if (repair.getStatus() != 1 && repair.getStatus() != 2) {
            throw new BusinessException("只能取消待接单或已接单的报修记录");
        }

        repair.setStatus(5);
        return updateById(repair);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean acceptRepair(Long id) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }

        // 只能接单待接单状态的报修
        if (repair.getStatus() != 1) {
            throw new BusinessException("只能接单待接单状态的报修记录");
        }

        // 获取当前登录用户信息
        Long userId = UserContext.getUserId();
        String username = UserContext.getUsername();

        repair.setStatus(2);
        repair.setRepairPersonId(userId);
        repair.setRepairPersonName(username);

        return updateById(repair);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean completeRepair(Long id, String repairResult, String repairImages) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }

        // 验证权限：只能完成自己接单的报修
        Long userId = UserContext.getUserId();
        if (userId != null && !userId.equals(repair.getRepairPersonId())) {
            throw new BusinessException("无权完成该报修记录");
        }

        // 只能完成已接单或维修中的报修
        if (repair.getStatus() != 2 && repair.getStatus() != 3) {
            throw new BusinessException("只能完成已接单或维修中的报修记录");
        }

        repair.setStatus(4);
        repair.setRepairResult(repairResult);
        repair.setRepairImages(repairImages);
        repair.setCompleteTime(LocalDateTime.now());

        return updateById(repair);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean rateRepair(Long id, Integer rating, String ratingComment) {
        Repair repair = getById(id);
        if (repair == null) {
            throw new BusinessException("报修记录不存在");
        }

        // 验证权限：只能评价自己的报修
        Long userId = UserContext.getUserId();
        if (userId != null && !userId.equals(repair.getStudentId())) {
            throw new BusinessException("无权评价该报修记录");
        }

        // 只能评价已完成的报修
        if (repair.getStatus() != 4) {
            throw new BusinessException("只能评价已完成的报修记录");
        }

        // 验证评分范围
        if (rating == null || rating < 1 || rating > 5) {
            throw new BusinessException("评分必须在1-5星之间");
        }

        repair.setRating(rating);
        repair.setRatingComment(ratingComment);

        return updateById(repair);
    }

    @Override
    public PageResult<RepairVO> myRepairList(RepairQueryDTO queryDTO) {
        // 设置当前用户ID
        Long userId = UserContext.getUserId();
        if (userId != null) {
            queryDTO.setStudentId(userId);
        }

        return pageList(queryDTO);
    }

    /**
     * 构建查询条件
     */
    private LambdaQueryWrapper<Repair> buildQueryWrapper(RepairQueryDTO queryDTO) {
        LambdaQueryWrapper<Repair> wrapper = new LambdaQueryWrapper<>();

        wrapper.eq(queryDTO.getStudentId() != null, Repair::getStudentId, queryDTO.getStudentId())
                .like(StrUtil.isNotBlank(queryDTO.getStudentName()), Repair::getStudentName, queryDTO.getStudentName())
                .like(StrUtil.isNotBlank(queryDTO.getStudentNo()), Repair::getStudentNo, queryDTO.getStudentNo())
                .like(StrUtil.isNotBlank(queryDTO.getRoomCode()), Repair::getRoomCode, queryDTO.getRoomCode())
                .eq(queryDTO.getRepairType() != null, Repair::getRepairType, queryDTO.getRepairType())
                .eq(queryDTO.getUrgentLevel() != null, Repair::getUrgentLevel, queryDTO.getUrgentLevel())
                .eq(queryDTO.getStatus() != null, Repair::getStatus, queryDTO.getStatus())
                .eq(queryDTO.getRepairPersonId() != null, Repair::getRepairPersonId, queryDTO.getRepairPersonId())
                .like(StrUtil.isNotBlank(queryDTO.getRepairPersonName()), Repair::getRepairPersonName, queryDTO.getRepairPersonName())
                .ge(queryDTO.getStartTime() != null, Repair::getCreateTime, queryDTO.getStartTime())
                .le(queryDTO.getEndTime() != null, Repair::getCreateTime, queryDTO.getEndTime());

        // 关键词搜索
        if (StrUtil.isNotBlank(queryDTO.getKeyword())) {
            wrapper.and(w -> w
                    .like(Repair::getStudentName, queryDTO.getKeyword())
                    .or()
                    .like(Repair::getStudentNo, queryDTO.getKeyword())
                    .or()
                    .like(Repair::getRoomCode, queryDTO.getKeyword())
            );
        }

        wrapper.orderByDesc(Repair::getCreateTime);

        return wrapper;
    }

    /**
     * 实体转VO
     */
    private RepairVO convertToVO(Repair repair) {
        RepairVO vo = new RepairVO();
        BeanUtil.copyProperties(repair, vo);

        // 转换字典
        vo.setRepairTypeText(DictUtils.getLabel("repair_type", repair.getRepairType(), "未知"));
        vo.setUrgentLevelText(DictUtils.getLabel("repair_urgent_level", repair.getUrgentLevel(), "未知"));
        vo.setStatusText(DictUtils.getLabel("repair_status", repair.getStatus(), "未知"));
        vo.setRatingText(DictUtils.getLabel("repair_rating", repair.getRating()));

        // 转换图片JSON为列表
        if (StrUtil.isNotBlank(repair.getFaultImages())) {
            try {
                vo.setFaultImages(JSONUtil.toList(repair.getFaultImages(), String.class));
            } catch (Exception e) {
                log.warn("解析故障图片JSON失败: {}", repair.getFaultImages(), e);
            }
        }

        if (StrUtil.isNotBlank(repair.getRepairImages())) {
            try {
                vo.setRepairImages(JSONUtil.toList(repair.getRepairImages(), String.class));
            } catch (Exception e) {
                log.warn("解析维修图片JSON失败: {}", repair.getRepairImages(), e);
            }
        }

        return vo;
    }
}
