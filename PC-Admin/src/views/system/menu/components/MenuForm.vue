<template>
  <ArtDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="700px"
    align-center
    :confirm="handleSubmit"
    :open="handleOpen"
  >
    <ElForm ref="localFormRef" :model="form" :rules="rules" label-width="85px">
      <ElFormItem label="菜单类型">
        <ElRadioGroup v-model="labelPosition" :disabled="disableMenuType">
          <ElRadioButton value="menu" label="menu">菜单</ElRadioButton>
          <ElRadioButton value="button" label="button">权限</ElRadioButton>
        </ElRadioGroup>
      </ElFormItem>

      <template v-if="labelPosition === 'menu'">
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="菜单名称" prop="name">
              <ElInput v-model="form.name" placeholder="菜单名称"></ElInput>
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="路由地址" prop="path">
              <ElInput v-model="form.path" placeholder="路由地址"></ElInput>
            </ElFormItem>
          </ElCol>
        </ElRow>
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="权限标识" prop="label">
              <ElInput v-model="form.label" placeholder="权限标识"></ElInput>
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="图标" prop="icon">
              <ArtIconSelector
                :iconType="iconType"
                :defaultIcon="form.icon"
                width="229px"
                @getIcon="handleIconChange"
              />
            </ElFormItem>
          </ElCol>
        </ElRow>

        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="菜单排序" prop="sort" style="width: 100%">
              <ElInputNumber
                v-model="form.sort"
                style="width: 100%"
                :min="1"
                controls-position="right"
              />
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="外部链接" prop="link">
              <ElInput
                v-model="form.link"
                placeholder="外部链接/内嵌地址(https://www.baidu.com)"
              ></ElInput>
            </ElFormItem>
          </ElCol>
        </ElRow>

        <ElRow :gutter="20">
          <ElCol :span="5">
            <ElFormItem label="是否启用" prop="isEnable">
              <ArtStatusSwitch v-model:modelValue="form.isEnable" :needConfirm="false" />
            </ElFormItem>
          </ElCol>
          <ElCol :span="5">
            <ElFormItem label="页面缓存" prop="keepAlive">
              <ArtStatusSwitch v-model:modelValue="form.keepAlive" :needConfirm="false" />
            </ElFormItem>
          </ElCol>
          <ElCol :span="5">
            <ElFormItem label="是否显示" prop="isHidden">
              <ArtStatusSwitch v-model:modelValue="form.isHidden" :needConfirm="false" />
            </ElFormItem>
          </ElCol>
          <ElCol :span="5">
            <ElFormItem label="是否内嵌" prop="isMenu">
              <ArtStatusSwitch v-model:modelValue="form.isIframe" :needConfirm="false" />
            </ElFormItem>
          </ElCol>
        </ElRow>
      </template>

      <template v-if="labelPosition === 'button'">
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="权限名称" prop="authName">
              <ElInput v-model="form.authName" placeholder="权限名称"></ElInput>
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="权限标识" prop="authLabel">
              <ElInput v-model="form.authLabel" placeholder="权限标识"></ElInput>
            </ElFormItem>
          </ElCol>
        </ElRow>
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="权限排序" prop="authSort" style="width: 100%">
              <ElInputNumber
                v-model="form.authSort"
                style="width: 100%"
                :min="1"
                controls-position="right"
              />
            </ElFormItem>
          </ElCol>
        </ElRow>
      </template>
    </ElForm>
  </ArtDialog>
</template>

<script setup lang="ts">
import { IconTypeEnum } from '@/enums/appEnum'
import { FormInstance, FormRules } from 'element-plus'
import ArtIconSelector from '@/components/core/base/ArtIconSelector.vue'
import ArtDialog from '@/components/core/others/ArtDialog.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'

// 菜单数据接口
interface MenuFormData {
  name: string
  path: string
  label: string
  icon: string
  isEnable: boolean
  sort: number
  isMenu: boolean
  keepAlive: boolean
  isHidden: boolean
  link: string
  isIframe: boolean
  authName: string
  authLabel: string
  authIcon: string
  authSort: number
}

// 对话框属性
const dialogVisible = defineModel<boolean>('modelValue', { required: true })
const labelPosition = defineModel<string>('labelPosition', { required: true })
const form = defineModel<MenuFormData>('form', { required: true })
const isEdit = defineModel<boolean>('isEdit', { required: true })
const lockMenuType = defineModel<boolean>('lockMenuType', { required: true })

// 定义本地表单ref
const localFormRef = ref<FormInstance | null>(null)

// 表单验证规则
const rules = reactive<FormRules>({
  name: [
    { required: true, message: '请输入菜单名称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  path: [{ required: true, message: '请输入路由地址', trigger: 'blur' }],
  label: [{ required: true, message: '输入权限标识', trigger: 'blur' }],
  authName: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
  authLabel: [{ required: true, message: '请输入权限权限标识', trigger: 'blur' }]
})

// 对话框标题计算
const dialogTitle = computed(() => {
  const type = labelPosition.value === 'menu' ? '菜单' : '权限'
  return isEdit.value ? `编辑${type}` : `添加${type}`
})

// 对话框打开处理
const handleOpen = () => {
  localFormRef.value?.clearValidate()
}

// 菜单类型是否禁用计算
const disableMenuType = computed(() => {
  // 编辑权限时锁定为权限类型
  if (isEdit.value && labelPosition.value === 'button') return true
  // 编辑菜单时锁定为菜单类型
  if (isEdit.value && labelPosition.value === 'menu') return true
  // 顶部添加菜单按钮时锁定为菜单类型
  if (!isEdit.value && labelPosition.value === 'menu' && lockMenuType.value) return true
  return false
})

// 图标类型
const iconType = ref(IconTypeEnum.UNICODE)

// 处理图标选择
const handleIconChange = (icon: string) => {
  form.value.icon = icon
}

// 提交表单
const handleSubmit = async () => {
  if (!localFormRef.value) return false

  return new Promise<boolean>((resolve) => {
    localFormRef.value?.validate((valid) => {
      if (valid) {
        try {
          // 这里可以加入实际的保存逻辑
          ElMessage.success(isEdit.value ? '编辑成功' : '新增成功')
          resolve(true) // 验证通过，返回true表示可以关闭对话框
        } catch {
          ElMessage.error(isEdit.value ? '编辑失败' : '新增失败')
          resolve(false) // 保存失败
        }
      } else {
        resolve(false) // 验证失败，返回false阻止关闭对话框
      }
    })
  })
}
</script>

<style scoped></style>
