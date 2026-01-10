<!-- 学生新增/编辑 Dialog 弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '新增学生' : '编辑学生'"
    width="800px"
    align-center
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="学号" prop="studentNo">
            <ElInput
              v-model="formData.studentNo"
              placeholder="请输入学号"
              :disabled="dialogType === 'edit'"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="姓名" prop="studentName">
            <ElInput v-model="formData.studentName" placeholder="请输入姓名" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="性别" prop="gender">
            <ElSelect v-model="formData.gender" placeholder="请选择性别" style="width: 100%">
              <ElOption label="男" :value="1" />
              <ElOption label="女" :value="2" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="手机号" prop="phone">
            <ElInput v-model="formData.phone" placeholder="请输入手机号" maxlength="11" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="邮箱" prop="email">
            <ElInput v-model="formData.email" placeholder="请输入邮箱" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="身份证号" prop="idCard">
            <ElInput v-model="formData.idCard" placeholder="请输入身份证号" maxlength="18" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="出生日期" prop="birthDate">
            <ElDatePicker
              v-model="formData.birthDate"
              type="date"
              placeholder="请选择出生日期"
              style="width: 100%"
              value-format="YYYY-MM-DD"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="民族" prop="nation">
            <ElSelect
              v-model="formData.nation"
              placeholder="请选择或搜索民族"
              filterable
              style="width: 100%"
            >
              <ElOption
                v-for="item in nationOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="政治面貌" prop="politicalStatus">
            <ElSelect
              v-model="formData.politicalStatus"
              placeholder="请选择政治面貌"
              style="width: 100%"
            >
              <ElOption
                v-for="item in politicalStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="入学年份" prop="enrollmentYear">
            <ElDatePicker
              v-model="formData.enrollmentYear"
              type="year"
              placeholder="请选择入学年份"
              style="width: 100%"
              value-format="YYYY"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="学制" prop="schoolingLength">
            <ElInputNumber
              v-model="formData.schoolingLength"
              placeholder="请输入学制（年）"
              :min="1"
              :max="10"
              style="width: 100%"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="学籍状态" prop="academicStatus">
            <ElSelect
              v-model="formData.academicStatus"
              placeholder="请选择学籍状态"
              style="width: 100%"
            >
              <ElOption
                v-for="item in academicStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="Number(item.value)"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="家长姓名" prop="parentName">
            <ElInput v-model="formData.parentName" placeholder="请输入家长姓名" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="家长电话" prop="parentPhone">
            <ElInput v-model="formData.parentPhone" placeholder="请输入家长电话" maxlength="11" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="紧急联系人" prop="emergencyContact">
            <ElInput v-model="formData.emergencyContact" placeholder="请输入紧急联系人" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="紧急联系电话" prop="emergencyPhone">
            <ElInput
              v-model="formData.emergencyPhone"
              placeholder="请输入紧急联系电话"
              maxlength="11"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="24">
          <ElFormItem label="家庭地址" prop="homeAddress">
            <ElInput
              v-model="formData.homeAddress"
              type="textarea"
              :rows="2"
              placeholder="请输入家庭地址"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="24">
          <ElFormItem label="备注" prop="remark">
            <ElInput v-model="formData.remark" type="textarea" :rows="3" placeholder="请输入备注" />
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>

    <template #footer>
      <div class="dialog-footer">
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" :loading="submitLoading" @click="handleSubmit">
          {{ submitLoading ? '提交中...' : '确定' }}
        </ElButton>
      </div>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
  import { ref, watch, computed, reactive, nextTick } from 'vue'
  import {
    ElDialog,
    ElForm,
    ElFormItem,
    ElInput,
    ElInputNumber,
    ElSelect,
    ElOption,
    ElDatePicker,
    ElButton,
    ElRow,
    ElCol,
    ElMessage
  } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import {
    fetchAddStudent,
    fetchUpdateStudent,
    fetchGetStudentDetail
  } from '@/api/accommodation-manage'
  import { useDictStore } from '@/store/modules/dict'

  defineOptions({ name: 'StudentDialog' })

  interface Props {
    /** 是否显示 */
    visible: boolean
    /** 对话框类型 */
    dialogType: 'add' | 'edit'
    /** 学生ID */
    studentId?: number
    /** 学生数据 */
    studentData?: Api.AccommodationManage.StudentDetail | null
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'close'): void
    (e: 'saved'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  const submitLoading = ref(false)

  // 字典 store
  const dictStore = useDictStore()

  // 字典选项
  const nationOptions = ref<Array<{ label: string; value: string }>>([])
  const politicalStatusOptions = ref<Array<{ label: string; value: string }>>([])
  const academicStatusOptions = ref<Array<{ label: string; value: string }>>([])

  // 对话框显示控制
  const dialogVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive<Api.AccommodationManage.StudentSaveParams>({
    studentNo: '',
    studentName: '',
    gender: undefined,
    idCard: '',
    phone: '',
    email: '',
    birthDate: '',
    nation: '',
    politicalStatus: '',
    enrollmentYear: undefined,
    schoolingLength: undefined,
    academicStatus: undefined,
    homeAddress: '',
    emergencyContact: '',
    emergencyPhone: '',
    parentName: '',
    parentPhone: '',
    remark: ''
  })

  // 表单验证规则
  const rules: FormRules = {
    studentNo: [{ required: true, message: '请输入学号', trigger: 'blur' }],
    studentName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
    phone: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }],
    email: [{ type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }],
    idCard: [
      {
        pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
        message: '请输入正确的身份证号格式',
        trigger: 'blur'
      }
    ],
    emergencyPhone: [
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
    ],
    parentPhone: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }]
  }

  /**
   * 加载字典数据
   */
  const loadDictData = async (): Promise<void> => {
    try {
      // 使用 store 批量加载字典数据（一个接口请求）
      const dictRes = await dictStore.loadDictDataBatch([
        'student_nation',
        'student_political_status',
        'academic_status'
      ])

      // 解析民族字典
      nationOptions.value = (dictRes.student_nation || []).map(
        (item: Api.SystemManage.DictDataListItem) => ({
          label: item.label,
          value: item.value
        })
      )

      // 解析政治面貌字典
      politicalStatusOptions.value = (dictRes.student_political_status || []).map(
        (item: Api.SystemManage.DictDataListItem) => ({
          label: item.label,
          value: item.value
        })
      )

      // 解析学籍状态字典
      academicStatusOptions.value = (dictRes.academic_status || []).map(
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
   * 初始化表单数据
   */
  const initFormData = async () => {
    if (props.dialogType === 'edit') {
      // 编辑模式：优先使用传入的数据，否则通过ID获取
      if (props.studentData) {
        const row = props.studentData
        Object.assign(formData, {
          id: row.id,
          studentNo: row.studentNo || '',
          studentName: row.studentName || '',
          gender: row.gender,
          idCard: row.idCard || '',
          phone: row.phone || '',
          email: row.email || '',
          birthDate: row.birthDate || '',
          nation: row.nation || '',
          politicalStatus: row.politicalStatus || '',
          enrollmentYear: row.enrollmentYear,
          schoolingLength: row.schoolingLength,
          academicStatus: row.academicStatus,
          homeAddress: row.homeAddress || '',
          emergencyContact: row.emergencyContact || '',
          emergencyPhone: row.emergencyPhone || '',
          parentName: row.parentName || '',
          parentPhone: row.parentPhone || '',
          remark: row.remark || ''
        })
      } else if (props.studentId) {
        // 通过ID获取详情
        try {
          const res = await fetchGetStudentDetail(props.studentId)
          if (res) {
            Object.assign(formData, {
              id: res.id,
              studentNo: res.studentNo || '',
              studentName: res.studentName || '',
              gender: res.gender,
              idCard: res.idCard || '',
              phone: res.phone || '',
              email: res.email || '',
              birthDate: res.birthDate || '',
              nation: res.nation || '',
              politicalStatus: res.politicalStatus || '',
              enrollmentYear: res.enrollmentYear,
              schoolingLength: res.schoolingLength,
              academicStatus: res.academicStatus,
              homeAddress: res.homeAddress || '',
              emergencyContact: res.emergencyContact || '',
              emergencyPhone: res.emergencyPhone || '',
              parentName: res.parentName || '',
              parentPhone: res.parentPhone || '',
              remark: res.remark || ''
            })
          }
        } catch (error) {
          ElMessage.error('获取学生详情失败')
          console.error('获取学生详情失败:', error)
        }
      }
    } else {
      // 新增模式：重置表单
      Object.assign(formData, {
        id: undefined,
        studentNo: '',
        studentName: '',
        gender: undefined,
        idCard: '',
        phone: '',
        email: '',
        birthDate: '',
        nation: '',
        politicalStatus: '',
        enrollmentYear: undefined,
        schoolingLength: undefined,
        academicStatus: undefined,
        homeAddress: '',
        emergencyContact: '',
        emergencyPhone: '',
        parentName: '',
        parentPhone: '',
        remark: ''
      })
    }
  }

  /**
   * 监听对话框状态变化
   */
  watch(
    () => [props.visible, props.dialogType, props.studentId, props.studentData],
    ([visible]) => {
      if (visible) {
        loadDictData()
        initFormData()
        nextTick(() => {
          formRef.value?.clearValidate()
        })
      }
    },
    { immediate: true }
  )

  /**
   * 提交表单
   */
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          submitLoading.value = true

          // 准备提交数据
          const submitData: Api.AccommodationManage.StudentSaveParams = {
            ...formData
          }

          // 处理入学年份：如果是字符串，转换为数字
          if (submitData.enrollmentYear && typeof submitData.enrollmentYear === 'string') {
            submitData.enrollmentYear = parseInt(submitData.enrollmentYear)
          }

          // 调用API
          if (props.dialogType === 'add') {
            await fetchAddStudent(submitData)
          } else {
            await fetchUpdateStudent(submitData)
          }

          dialogVisible.value = false
          emit('saved')
        } catch (error) {
          console.error('提交失败:', error)
        } finally {
          submitLoading.value = false
        }
      }
    })
  }

  /**
   * 关闭对话框
   */
  const handleClose = () => {
    formRef.value?.resetFields()
  }
</script>

<style scoped lang="scss">
  .dialog-footer {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
  }
</style>
