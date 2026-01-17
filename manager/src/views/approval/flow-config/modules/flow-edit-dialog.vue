<!-- 流程编辑弹窗 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogType === 'add' ? '新增流程' : '编辑流程'"
    width="900px"
    :close-on-click-modal="false"
    destroy-on-close
    @closed="handleClosed"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElRow :gutter="20">
        <ElCol :span="12">
          <ElFormItem label="流程名称" prop="flowName">
            <ElInput v-model="formData.flowName" placeholder="请输入流程名称" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="流程编码" prop="flowCode">
            <ElInput
              v-model="formData.flowCode"
              placeholder="请输入流程编码"
              :disabled="dialogType === 'edit'"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="业务类型" prop="businessType">
            <ElSelect
              v-model="formData.businessType"
              placeholder="请选择业务类型"
              style="width: 100%"
            >
              <ElOption
                v-for="item in businessTypeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="状态" prop="status">
            <ElRadioGroup v-model="formData.status">
              <ElRadio :value="1">启用</ElRadio>
              <ElRadio :value="0">停用</ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
        <ElCol :span="24">
          <ElFormItem label="流程描述" prop="description">
            <ElInput
              v-model="formData.description"
              type="textarea"
              :rows="2"
              placeholder="请输入流程描述"
            />
          </ElFormItem>
        </ElCol>
      </ElRow>

      <!-- 流程节点配置 -->
      <ElDivider content-position="left">
        <span class="text-base font-medium">审批节点配置</span>
      </ElDivider>

      <div class="mb-4">
        <ElButton type="primary" size="small" @click="addNode" v-ripple>
          <i class="ri-add-line mr-1"></i>
          添加节点
        </ElButton>
      </div>

      <div v-if="formData.nodes && formData.nodes.length > 0" class="space-y-4">
        <ElCard
          v-for="(node, index) in formData.nodes"
          :key="index"
          shadow="never"
          class="node-card"
        >
          <template #header>
            <div class="flex items-center justify-between">
              <span class="font-medium">节点 {{ index + 1 }}</span>
              <div class="flex items-center gap-2">
                <ElButton v-if="index > 0" size="small" text @click="moveNode(index, -1)">
                  <i class="ri-arrow-up-line"></i>
                </ElButton>
                <ElButton
                  v-if="index < formData.nodes!.length - 1"
                  size="small"
                  text
                  @click="moveNode(index, 1)"
                >
                  <i class="ri-arrow-down-line"></i>
                </ElButton>
                <ElButton size="small" text type="danger" @click="removeNode(index)">
                  <i class="ri-delete-bin-line"></i>
                </ElButton>
              </div>
            </div>
          </template>

          <ElRow :gutter="16">
            <ElCol :span="8">
              <ElFormItem
                :label="'节点名称'"
                :prop="`nodes.${index}.nodeName`"
                :rules="[{ required: true, message: '请输入节点名称', trigger: 'blur' }]"
              >
                <ElInput v-model="node.nodeName" placeholder="请输入节点名称" />
              </ElFormItem>
            </ElCol>
            <ElCol :span="8">
              <ElFormItem :label="'节点类型'" :prop="`nodes.${index}.nodeType`">
                <ElSelect v-model="node.nodeType" style="width: 100%">
                  <ElOption label="串行（单人审批）" :value="1" />
                  <ElOption label="会签（所有人通过）" :value="2" />
                  <ElOption label="或签（任一人通过）" :value="3" />
                </ElSelect>
              </ElFormItem>
            </ElCol>
            <ElCol :span="8">
              <ElFormItem :label="'拒绝处理'" :prop="`nodes.${index}.rejectAction`">
                <ElSelect v-model="node.rejectAction" style="width: 100%">
                  <ElOption label="直接结束" :value="1" />
                  <ElOption label="退回申请人" :value="2" />
                  <ElOption label="退回上一节点" :value="3" />
                </ElSelect>
              </ElFormItem>
            </ElCol>
            <ElCol :span="24">
              <ElFormItem
                :label="'审批人'"
                :prop="`nodes.${index}.assignees`"
                :rules="[
                  {
                    required: true,
                    type: 'array',
                    min: 1,
                    message: '请添加审批人',
                    trigger: 'change'
                  }
                ]"
              >
                <div class="w-full">
                  <div class="flex flex-wrap gap-2 mb-2">
                    <ElTag
                      v-for="(assignee, aIndex) in node.assignees"
                      :key="aIndex"
                      closable
                      :type="assignee.assigneeType === 1 ? 'warning' : 'success'"
                      @close="removeAssignee(index, aIndex)"
                    >
                      {{ assignee.assigneeType === 1 ? '角色:' : '用户:'
                      }}{{ assignee.assigneeName }}
                    </ElTag>
                  </div>
                  <ElSpace>
                    <ElButton size="small" @click="openAssigneeSelect(index, 1)">
                      <i class="ri-user-settings-line mr-1"></i>
                      选择角色
                    </ElButton>
                    <ElButton size="small" @click="openAssigneeSelect(index, 2)">
                      <i class="ri-user-line mr-1"></i>
                      选择用户
                    </ElButton>
                  </ElSpace>
                </div>
              </ElFormItem>
            </ElCol>
          </ElRow>
        </ElCard>
      </div>

      <ElEmpty v-else description="暂无审批节点，请添加" :image-size="80" />
    </ElForm>

    <template #footer>
      <ElButton @click="dialogVisible = false" v-ripple>取消</ElButton>
      <ElButton type="primary" :loading="submitLoading" @click="handleSubmit" v-ripple>
        确定
      </ElButton>
    </template>

    <!-- 审批人选择弹窗 -->
    <AssigneeSelectDialog
      v-model="assigneeDialogVisible"
      :assignee-type="currentAssigneeType"
      :selected-ids="currentSelectedIds"
      @confirm="handleAssigneeConfirm"
    />
  </ElDialog>
</template>

<script setup lang="ts">
  import {
    fetchAddFlow,
    fetchUpdateFlow,
    fetchGetFlowDetail,
    type ApprovalFlow
  } from '@/api/approval-manage'
  import AssigneeSelectDialog from './assignee-select-dialog.vue'
  import { ElMessage } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'

  const props = defineProps<{
    modelValue: boolean
    dialogType: 'add' | 'edit'
    flowData: ApprovalFlow | null
  }>()

  const emit = defineEmits<{
    'update:modelValue': [value: boolean]
    success: []
  }>()

  const dialogVisible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })

  const formRef = ref<FormInstance>()
  const submitLoading = ref(false)
  const assigneeDialogVisible = ref(false)
  const currentNodeIndex = ref(0)
  const currentAssigneeType = ref<1 | 2>(1)
  const currentSelectedIds = ref<number[]>([])

  const businessTypeOptions = [
    { label: '入住申请', value: 'check_in' },
    { label: '调宿申请', value: 'transfer' },
    { label: '退宿申请', value: 'check_out' },
    { label: '留宿申请', value: 'stay' }
  ]

  const initialFormData = (): ApprovalFlow => ({
    flowName: '',
    flowCode: '',
    businessType: '',
    description: '',
    status: 1,
    nodes: []
  })

  const formData = reactive<ApprovalFlow>(initialFormData())

  const rules: FormRules = {
    flowName: [{ required: true, message: '请输入流程名称', trigger: 'blur' }],
    flowCode: [{ required: true, message: '请输入流程编码', trigger: 'blur' }],
    businessType: [{ required: true, message: '请选择业务类型', trigger: 'change' }]
  }

  // 监听弹窗打开
  watch(
    () => props.modelValue,
    async (val) => {
      if (val) {
        if (props.dialogType === 'edit' && props.flowData?.id) {
          // 加载流程详情
          try {
            const res = await fetchGetFlowDetail(props.flowData.id)
            Object.assign(formData, res)
          } catch (error) {
            console.error('加载流程详情失败:', error)
          }
        } else {
          Object.assign(formData, initialFormData())
        }
      }
    }
  )

  const handleClosed = () => {
    formRef.value?.resetFields()
    Object.assign(formData, initialFormData())
  }

  const addNode = () => {
    if (!formData.nodes) {
      formData.nodes = []
    }
    formData.nodes.push({
      nodeName: '',
      nodeOrder: formData.nodes.length + 1,
      nodeType: 1,
      rejectAction: 1,
      assignees: []
    })
  }

  const removeNode = (index: number) => {
    formData.nodes?.splice(index, 1)
    // 重新排序
    formData.nodes?.forEach((node, i) => {
      node.nodeOrder = i + 1
    })
  }

  const moveNode = (index: number, direction: number) => {
    const newIndex = index + direction
    if (newIndex < 0 || newIndex >= (formData.nodes?.length || 0)) return

    const nodes = formData.nodes!
    const temp = nodes[index]
    nodes[index] = nodes[newIndex]
    nodes[newIndex] = temp

    // 重新排序
    nodes.forEach((node, i) => {
      node.nodeOrder = i + 1
    })
  }

  const openAssigneeSelect = (nodeIndex: number, assigneeType: 1 | 2) => {
    currentNodeIndex.value = nodeIndex
    currentAssigneeType.value = assigneeType

    // 获取当前已选中的ID
    const node = formData.nodes![nodeIndex]
    currentSelectedIds.value = node.assignees
      .filter((a) => a.assigneeType === assigneeType)
      .map((a) => a.assigneeId)

    assigneeDialogVisible.value = true
  }

  const handleAssigneeConfirm = (selected: Array<{ id: number; name: string }>) => {
    const node = formData.nodes![currentNodeIndex.value]

    // 移除该类型的旧审批人
    node.assignees = node.assignees.filter((a) => a.assigneeType !== currentAssigneeType.value)

    // 添加新审批人
    selected.forEach((item) => {
      node.assignees.push({
        assigneeType: currentAssigneeType.value,
        assigneeId: item.id,
        assigneeName: item.name
      })
    })
  }

  const removeAssignee = (nodeIndex: number, assigneeIndex: number) => {
    formData.nodes![nodeIndex].assignees.splice(assigneeIndex, 1)
  }

  const handleSubmit = async () => {
    if (!formRef.value) return

    try {
      await formRef.value.validate()

      // 验证节点
      if (!formData.nodes || formData.nodes.length === 0) {
        ElMessage.warning('请至少添加一个审批节点')
        return
      }

      // 验证每个节点都有审批人
      for (let i = 0; i < formData.nodes.length; i++) {
        if (!formData.nodes[i].assignees || formData.nodes[i].assignees.length === 0) {
          ElMessage.warning(`节点 ${i + 1} 未配置审批人`)
          return
        }
      }

      submitLoading.value = true

      if (props.dialogType === 'add') {
        await fetchAddFlow(formData)
      } else {
        await fetchUpdateFlow(formData.id!, formData)
      }

      dialogVisible.value = false
      emit('success')
    } catch (error) {
      console.error('表单验证失败:', error)
    } finally {
      submitLoading.value = false
    }
  }
</script>

<style scoped lang="scss">
  .node-card {
    :deep(.el-card__header) {
      padding: 12px 16px;
      background-color: var(--el-fill-color-light);
    }
  }
</style>
