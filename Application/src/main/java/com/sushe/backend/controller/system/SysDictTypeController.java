package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.dto.dict.DictTypeQueryDTO;
import com.sushe.backend.dto.dict.DictTypeSaveDTO;
import com.sushe.backend.service.SysDictTypeService;
import com.sushe.backend.vo.DictTypeVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 字典类型控制器
 * 
 * @author 陈鸿昇
 * @since 2025-12-30
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/dict/type")
@RequiredArgsConstructor
@Tag(name = "字典类型管理", description = "字典类型的增删改查")
public class SysDictTypeController extends BaseCrudController<DictTypeVO, DictTypeQueryDTO, DictTypeSaveDTO> {

    private final SysDictTypeService dictTypeService;

    @Override
    public String getEntityName() {
        return "字典类型";
    }

    @Override
    protected PageResult<DictTypeVO> callPageList(DictTypeQueryDTO queryDTO) {
        return dictTypeService.pageList(queryDTO);
    }

    @Override
    protected DictTypeVO callGetDetailById(Long id) {
        return dictTypeService.getDetailById(id);
    }

    @Override
    protected boolean callSave(DictTypeSaveDTO saveDTO) {
        return dictTypeService.saveDictType(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return dictTypeService.deleteDictType(id);
    }
}
