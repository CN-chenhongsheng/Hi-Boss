<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
    width="600px"
    align-center
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="90px">
      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="用户名" prop="username">
            <ElInput
              v-model="formData.username"
              placeholder="请输入用户名"
              :disabled="dialogType === 'edit'"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="昵称" prop="nickname">
            <ElInput v-model="formData.nickname" placeholder="请输入昵称" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="密码" prop="password">
            <ElInput
              v-model="formData.password"
              type="password"
              show-password
              :placeholder="dialogType === 'edit' ? '不填则不修改' : '请输入密码'"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="邮箱" prop="email">
            <ElInput v-model="formData.email" placeholder="请输入邮箱" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="手机号" prop="phone">
            <ElInput v-model="formData.phone" placeholder="请输入手机号" maxlength="11" />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="角色" prop="roleIds">
            <ElSelect
              v-model="formData.roleIds"
              multiple
              placeholder="请选择角色"
              style="width: 100%"
            >
              <ElOption
                v-for="role in roleList"
                :key="role.id"
                :value="role.id"
                :label="role.roleName"
              />
            </ElSelect>
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
  import { fetchAddUser, fetchUpdateUser } from '@/api/system-manage'
  import { useReferenceStore } from '@/store/modules/reference'
  import { ElMessage } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'

  interface Props {
    visible: boolean
    type: string
    userData?: Partial<Api.SystemManage.UserListItem>
  }

  interface Emits {
    (e: 'update:visible', value: boolean): void
    (e: 'submit'): void
  }

  const props = defineProps<Props>()
  const emit = defineEmits<Emits>()

  // 角色列表数据
  const roleList = ref<Api.SystemManage.RoleListItem[]>([])
  const submitLoading = ref(false)

  // 使用参考数据 store
  const referenceStore = useReferenceStore()

  // 对话框显示控制
  const dialogVisible = computed({
    get: () => props.visible,
    set: (value) => emit('update:visible', value)
  })

  const dialogType = computed(() => props.type)

  /**
   * 是否为超级管理员
   */
  const isSuperAdmin = computed(() => {
    return props.type === 'edit' && props.userData?.username === 'superAdmin'
  })

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive<Api.SystemManage.UserSaveParams>({
    username: '',
    nickname: '',
    password: '',
    email: '',
    phone: '',
    status: 1,
    roleIds: []
  })

  // 表单验证规则
  const rules: FormRules = {
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      {
        pattern: /^[a-zA-Z0-9_]{4,20}$/,
        message: '用户名只能包含字母、数字、下划线，长度4-20位',
        trigger: 'blur'
      }
    ],
    nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
    password: [
      {
        validator: (rule, value, callback) => {
          // 新增时密码必填
          if (props.type === 'add' && !value) {
            callback(new Error('请输入密码'))
          } else if (value && value.length < 6) {
            callback(new Error('密码长度不能少于6位'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
    email: [{ type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }],
    phone: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }]
  }

  /**
   * 加载角色列表（使用 store 缓存）
   */
  const loadRoles = async () => {
    try {
      roleList.value = await referenceStore.loadAllRoles()
    } catch (error) {
      console.error('加载角色列表失败:', error)
    }
  }

  /**
   * 初始化表单数据
   */
  const initFormData = () => {
    if (props.type === 'edit' && props.userData) {
      const row = props.userData
      Object.assign(formData, {
        id: row.id,
        username: row.username || '',
        nickname: row.nickname || '',
        password: '', // 编辑时密码为空
        email: row.email || '',
        phone: row.phone || '',
        status: row.status ?? 1,
        roleIds: row.roleIds || []
      })
    } else {
      // 重置表单
      Object.assign(formData, {
        id: undefined,
        username: '',
        nickname: '',
        password: '',
        email: '',
        phone: '',
        status: 1,
        roleIds: []
      })
    }
  }

  /**
   * 监听对话框状态变化
   */
  watch(
    () => [props.visible, props.type, props.userData],
    ([visible]) => {
      if (visible) {
        initFormData()
        loadRoles()
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
        // 超级管理员不允许设置为停用
        if (isSuperAdmin.value && formData.status === 0) {
          ElMessage.warning('超级管理员不允许停用')
          return
        }

        try {
          submitLoading.value = true

          // 准备提交数据
          const submitData: Api.SystemManage.UserSaveParams = {
            ...formData
          }

          // 如果是编辑且密码为空，则不传密码字段
          if (props.type === 'edit' && !submitData.password) {
            delete submitData.password
          }

          // 调用API
          if (props.type === 'add') {
            await fetchAddUser(submitData)
          } else {
            await fetchUpdateUser(formData.id!, submitData)
          }

          dialogVisible.value = false
          emit('submit')
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
