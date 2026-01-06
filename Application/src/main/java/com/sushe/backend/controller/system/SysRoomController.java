package com.sushe.backend.controller.system;

import com.sushe.backend.common.result.PageResult;
import com.sushe.backend.controller.base.BaseCrudController;
import com.sushe.backend.controller.base.BatchDeleteController;
import com.sushe.backend.controller.base.StatusUpdateController;
import com.sushe.backend.common.result.R;
import com.sushe.backend.dto.room.RoomBatchCreateDTO;
import com.sushe.backend.dto.room.RoomQueryDTO;
import com.sushe.backend.dto.room.RoomSaveDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sushe.backend.service.SysRoomService;
import com.sushe.backend.vo.RoomVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 房间管理控制器
 * 
 * @author 陈鸿昇
 * @since 2026-01-03
 */
@Slf4j
@RestController
@RequestMapping("/v1/system/room")
@RequiredArgsConstructor
@Tag(name = "房间管理", description = "房间增删改查等")
public class SysRoomController extends BaseCrudController<RoomVO, RoomQueryDTO, RoomSaveDTO>
        implements BatchDeleteController, StatusUpdateController {

    private final SysRoomService roomService;

    @Override
    public String getEntityName() {
        return "房间";
    }

    @Override
    protected PageResult<RoomVO> callPageList(RoomQueryDTO queryDTO) {
        return roomService.pageList(queryDTO);
    }

    @Override
    protected RoomVO callGetDetailById(Long id) {
        return roomService.getDetailById(id);
    }

    @Override
    protected boolean callSave(RoomSaveDTO saveDTO) {
        return roomService.saveRoom(saveDTO);
    }

    @Override
    protected boolean callDelete(Long id) {
        return roomService.deleteRoom(id);
    }

    @Override
    public boolean callBatchDelete(Long[] ids) {
        return roomService.batchDelete(ids);
    }

    @Override
    public boolean callUpdateStatus(Long id, Integer status) {
        return roomService.updateStatus(id, status);
    }

    @PostMapping("/batch-create")
    @Operation(summary = "批量创建房间")
    public R<Integer> batchCreate(@RequestBody @Valid RoomBatchCreateDTO dto) {
        return R.ok(roomService.batchCreateRooms(dto));
    }

    /**
     * 检查房间是否被床位关联
     * 
     * @param id 房间ID
     * @return true-有床位关联，false-无床位关联
     */
    @GetMapping("/{id}/check-beds")
    @Operation(summary = "检查房间是否被床位关联")
    @Parameter(name = "id", description = "房间ID", required = true)
    public R<Boolean> checkRoomHasBeds(@PathVariable Long id) {
        boolean hasBeds = roomService.checkRoomHasBeds(id);
        return R.ok(hasBeds);
    }
}

