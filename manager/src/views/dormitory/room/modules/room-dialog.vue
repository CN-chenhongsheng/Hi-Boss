<!-- 房间编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="720px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="form" :rules="rules" label-width="120px" label-position="right">
      <ElFormItem label="房间编码" prop="roomCode">
        <ElInput
          v-model="form.roomCode"
          placeholder="请输入房间编码（如：101、102）"
          :disabled="isEdit"
        />
      </ElFormItem>

      <ElFormItem label="房间号" prop="roomNumber">
        <ElInput v-model="form.roomNumber" placeholder="请输入房间号（如：101、102）" />
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="所属校区" prop="campusCode">
            <ElSelect
              v-model="selectedCampusCode"
              placeholder="请选择校区"
              filterable
              clearable
              @change="handleCampusChange"
            >
              <ElOption
                v-for="item in campusList"
                :key="item.campusCode"
                :label="item.campusName"
                :value="item.campusCode"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="所属楼层" prop="floorId">
            <ElSelect
              v-model="form.floorId"
              placeholder="请选择楼层"
              filterable
              clearable
              :disabled="!selectedCampusCode"
            >
              <ElOption
                v-for="item in floorList"
                :key="item.id"
                :label="item.floorName || item.floorCode"
                :value="item.id"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="房间类型" prop="roomType">
            <ElSelect v-model="form.roomType" placeholder="请选择房间类型" filterable clearable>
              <ElOption
                v-for="item in roomTypeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="房间状态" prop="roomStatus">
            <ElSelect v-model="form.roomStatus" placeholder="请选择房间状态" filterable clearable>
              <ElOption
                v-for="item in roomStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem label="床位数" prop="bedCount">
            <ElInputNumber
              v-model="form.bedCount"
              :min="1"
              :max="20"
              placeholder="请输入床位数"
              class="w-full"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="最大入住人数" prop="maxOccupancy">
            <ElInputNumber
              v-model="form.maxOccupancy"
              :min="1"
              :max="form.bedCount || 1"
              placeholder="请输入最大入住人数"
              class="w-full"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>
      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem label="房间面积(㎡)" prop="area">
            <ElInputNumber
              v-model="form.area"
              :min="0"
              :precision="2"
              placeholder="请输入房间面积"
              class="w-full"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="排序序号" prop="sort">
            <ElInputNumber v-model="form.sort" :min="0" :max="9999" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="房间设施">
        <ElCheckboxGroup v-model="facilityValues">
          <ElCheckbox v-for="item in facilityOptions" :key="item.value" :label="Number(item.value)">
            {{ item.label }}
          </ElCheckbox>
        </ElCheckboxGroup>
      </ElFormItem>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="状态" prop="status">
            <ElRadioGroup v-model="form.status">
              <ElRadio :label="1">启用</ElRadio>
              <ElRadio :label="0">停用</ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
      </ElFormItem>
    </ElForm>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="loading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { fetchGetCampusTree } from '@/api/school-manage'
  import { fetchAddRoom, fetchUpdateRoom, fetchGetFloorPage } from '@/api/dormitory-manage'
  import { useDictStore } from '@/store/modules/dict'
  import { ElMessage } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: 'add' | 'edit'
    editData?: Api.SystemManage.RoomListItem | null
  }

  interface Emits {
    (e: 'update:visible', visible: boolean): void
    (e: 'submit'): void
  }

  const props = withDefaults(defineProps<Props>(), {
    editData: null
  })

  const emit = defineEmits<Emits>()

  const formRef = ref<FormInstance>()
  const loading = ref(false)
  const campusList = ref<Api.SystemManage.CampusListItem[]>([])
  const floorList = ref<Api.SystemManage.FloorListItem[]>([])
  const selectedCampusCode = ref<string>('')
  const roomTypeOptions = ref<Array<{ label: string; value: string }>>([])
  const roomStatusOptions = ref<Array<{ label: string; value: number }>>([])
  const facilityOptions = ref<Array<{ label: string; value: string }>>([])
  const facilityValues = ref<number[]>([])

  // 使用字典 store
  const dictStore = useDictStore()

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const isEdit = computed(() => props.type === 'edit')

  const dialogTitle = computed(() => {
    if (isEdit.value) return '编辑房间'
    return '新增房间'
  })

  const form = reactive<Partial<Api.SystemManage.RoomSaveParams>>({
    roomCode: '',
    roomNumber: '',
    floorId: undefined,
    roomType: undefined,
    bedCount: 4,
    maxOccupancy: undefined,
    area: undefined,
    hasAirConditioner: 0,
    hasBathroom: 0,
    hasBalcony: 0,
    roomStatus: 1,
    sort: 0,
    status: 1,
    remark: undefined
  })

  const rules = reactive<FormRules>({
    roomCode: [{ required: true, message: '请输入房间编码', trigger: 'blur' }],
    roomNumber: [{ required: true, message: '请输入房间号', trigger: 'blur' }],
    floorId: [{ required: true, message: '请选择所属楼层', trigger: 'change' }]
  })

  /**
   * 加载校区列表
   */
  const loadCampusList = async (): Promise<void> => {
    try {
      const res = await fetchGetCampusTree()
      campusList.value = res || []
    } catch (error) {
      console.error('加载校区列表失败:', error)
    }
  }

  /**
   * 加载楼层列表
   */
  const loadFloorList = async (campusCode?: string): Promise<void> => {
    if (!campusCode) {
      floorList.value = []
      return
    }
    try {
      const res = await fetchGetFloorPage({ campusCode, pageNum: 1, pageSize: 1000 })
      floorList.value = res?.list || []
    } catch (error) {
      console.error('加载楼层列表失败:', error)
    }
  }

  /**
   * 加载字典数据
   */
  const loadDictData = async (): Promise<void> => {
    try {
      // 使用 store 批量加载字典数据（一个接口请求）
      const dictRes = await dictStore.loadDictDataBatch([
        'dormitory_room_type',
        'dormitory_room_status',
        'dormitory_room_facility'
      ])

      // 解析房间类型字典
      roomTypeOptions.value = (dictRes.dormitory_room_type || []).map(
        (item: Api.SystemManage.DictDataListItem) => ({
          label: item.label,
          value: item.value
        })
      )

      // 解析房间状态字典
      roomStatusOptions.value = (dictRes.dormitory_room_status || []).map(
        (item: Api.SystemManage.DictDataListItem) => ({
          label: item.label,
          value: Number(item.value)
        })
      )

      // 解析房间设施字典
      facilityOptions.value = (dictRes.dormitory_room_facility || []).map(
        (item: Api.SystemManage.DictDataListItem) => ({
          label: item.label,
          value: item.value
        })
      )
    } catch (error) {
      console.error('加载字典数据失败:', error)
    }
  }

  /**
   * 校区变更处理
   */
  const handleCampusChange = (campusCode: string): void => {
    selectedCampusCode.value = campusCode
    form.floorId = undefined
    loadFloorList(campusCode)
  }

  /**
   * 加载表单数据
   */
  const loadFormData = async (): Promise<void> => {
    if (isEdit.value && props.editData) {
      selectedCampusCode.value = props.editData.campusCode || ''
      await loadFloorList(props.editData.campusCode)

      Object.assign(form, {
        id: props.editData.id,
        roomCode: props.editData.roomCode,
        roomNumber: props.editData.roomNumber,
        floorId: props.editData.floorId,
        roomType: props.editData.roomType || undefined,
        bedCount: props.editData.bedCount || 4,
        maxOccupancy: props.editData.maxOccupancy || undefined,
        area: props.editData.area || undefined,
        hasAirConditioner: props.editData.hasAirConditioner || 0,
        hasBathroom: props.editData.hasBathroom || 0,
        hasBalcony: props.editData.hasBalcony || 0,
        roomStatus: props.editData.roomStatus || 1,
        sort: props.editData.sort || 0,
        status: props.editData.status,
        remark: props.editData.remark || undefined
      })

      // 设置设施复选框
      facilityValues.value = []
      if (form.hasAirConditioner === 1) facilityValues.value.push(1)
      if (form.hasBathroom === 1) facilityValues.value.push(2)
      if (form.hasBalcony === 1) facilityValues.value.push(3)
    } else {
      resetForm()
    }
  }

  /**
   * 重置表单
   */
  const resetForm = (): void => {
    Object.assign(form, {
      roomCode: '',
      roomNumber: '',
      floorId: undefined,
      roomType: undefined,
      bedCount: 4,
      maxOccupancy: undefined,
      area: undefined,
      hasAirConditioner: 0,
      hasBathroom: 0,
      hasBalcony: 0,
      roomStatus: 1,
      sort: 0,
      status: 1,
      remark: undefined
    })
    selectedCampusCode.value = ''
    facilityValues.value = []
    floorList.value = []
    formRef.value?.clearValidate()
  }

  /**
   * 提交表单
   */
  const handleSubmit = async (): Promise<void> => {
    if (!formRef.value) return

    const valid = await formRef.value.validate().catch(() => false)
    if (!valid) return

    // 确保 floorId 不为 undefined
    if (form.floorId === undefined) {
      ElMessage.error('请选择所属楼层')
      return
    }

    // 同步设施复选框到表单
    form.hasAirConditioner = facilityValues.value.includes(1) ? 1 : 0
    form.hasBathroom = facilityValues.value.includes(2) ? 1 : 0
    form.hasBalcony = facilityValues.value.includes(3) ? 1 : 0

    loading.value = true
    try {
      if (isEdit.value) {
        await fetchUpdateRoom(form.id!, form as Api.SystemManage.RoomSaveParams)
      } else {
        await fetchAddRoom(form as Api.SystemManage.RoomSaveParams)
      }
      emit('submit')
      handleClose()
    } catch (error) {
      console.error('提交失败:', error)
    } finally {
      loading.value = false
    }
  }

  /**
   * 关闭弹窗
   */
  const handleClose = (): void => {
    resetForm()
    emit('update:visible', false)
  }

  watch(
    () => props.visible,
    (val) => {
      if (val) {
        loadCampusList()
        loadDictData()
        loadFormData()
      }
    },
    { immediate: true }
  )

  /**
   * 监听床位数变化，自动调整最大入住人数
   */
  watch(
    () => form.bedCount,
    (newBedCount) => {
      if (newBedCount && form.maxOccupancy && form.maxOccupancy > newBedCount) {
        form.maxOccupancy = newBedCount
      }
    }
  )
</script>
