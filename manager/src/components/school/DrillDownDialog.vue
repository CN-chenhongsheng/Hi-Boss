<!-- 数据下钻弹框组件 -->
<template>
  <ElDialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="90%"
    append-to-body
    :close-on-click-modal="false"
    destroy-on-close
    @close="handleClose"
  >
    <div class="drill-down-dialog-content">
      <!-- 院系表格 -->
      <template v-if="drillType === 'department'">
        <ArtTable
          ref="tableRef"
          row-key="id"
          :loading="loading"
          :columns="departmentColumns"
          :data="data"
          :pagination="pagination"
          :stripe="false"
          height="400px"
          @pagination:size-change="handleSizeChange"
          @pagination:current-change="handleCurrentChange"
        />
      </template>

      <!-- 专业表格 -->
      <template v-else-if="drillType === 'major'">
        <ArtTable
          :loading="loading"
          :data="data"
          :columns="majorColumns"
          :pagination="pagination"
          height="400px"
          @pagination:size-change="handleSizeChange"
          @pagination:current-change="handleCurrentChange"
        />
      </template>

      <!-- 班级表格 -->
      <template v-else-if="drillType === 'class'">
        <ArtTable
          :loading="loading"
          :data="data"
          :columns="classColumns"
          :pagination="pagination"
          height="400px"
          @pagination:size-change="handleSizeChange"
          @pagination:current-change="handleCurrentChange"
        />
      </template>
    </div>
  </ElDialog>
</template>

<script setup lang="ts">
  import ArtTable from '@/components/core/tables/art-table/index.vue'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { useTable } from '@/hooks/core/useTable'
  import { fetchGetDepartmentPage, fetchGetMajorPage, fetchGetClassPage } from '@/api/school-manage'
  import { defaultResponseAdapter } from '@/utils/table/tableUtils'
  import { h } from 'vue'

  defineOptions({ name: 'DrillDownDialog' })

  type DrillDownType = 'department' | 'major' | 'class'

  interface Props {
    visible: boolean
    drillType: DrillDownType
    parentName: string
    filterParams: Record<string, any>
  }

  const props = withDefaults(defineProps<Props>(), {
    visible: false,
    drillType: 'department',
    parentName: '',
    filterParams: () => ({})
  })

  const emit = defineEmits<{
    'update:visible': [value: boolean]
    'drill-down': [type: DrillDownType, row: any]
  }>()

  const dialogVisible = computed({
    get: () => props.visible,
    set: (val) => emit('update:visible', val)
  })

  const dialogTitle = computed(() => {
    const typeMap = {
      department: '查看院系',
      major: '查看专业',
      class: '查看班级'
    }
    const title = typeMap[props.drillType] || '查看数据'
    return props.parentName ? `${title} - ${props.parentName}` : title
  })

  const tableRef = ref()

  // 院系列表项类型
  type DepartmentListItem = Api.SystemManage.DepartmentListItem
  // 专业列表项类型
  type MajorListItem = Api.SystemManage.MajorListItem
  // 班级列表项类型
  type ClassListItem = Api.SystemManage.ClassListItem

  /**
   * 处理下钻
   */
  const handleDrillDown = (type: DrillDownType, row: any): void => {
    // 触发事件，让父组件处理嵌套下钻
    emit('drill-down', type, row)
  }

  /**
   * 获取院系表格列配置
   */
  const getDepartmentColumns = () => [
    {
      prop: 'deptCode',
      label: '院系编码',
      minWidth: 120
    },
    {
      prop: 'deptName',
      label: '院系名称',
      minWidth: 150
    },
    {
      prop: 'campusName',
      label: '所属校区',
      minWidth: 120
    },
    {
      prop: 'leader',
      label: '院系领导',
      minWidth: 100
    },
    {
      prop: 'phone',
      label: '联系电话',
      minWidth: 120
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: DepartmentListItem) => {
        return row.status === 1 ? '启用' : '停用'
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      width: 180
    },
    {
      prop: 'action',
      label: '操作',
      width: 120,
      fixed: 'right' as const,
      formatter: (row: DepartmentListItem) => {
        return h('div', { class: 'flex gap-1' }, [
          h(ArtButtonTable, {
            type: 'view',
            onClick: () => handleDrillDown('major', row)
          })
        ])
      }
    }
  ]

  /**
   * 获取专业表格列配置
   */
  const getMajorColumns = () => [
    {
      prop: 'majorCode',
      label: '专业编码',
      minWidth: 120
    },
    {
      prop: 'majorName',
      label: '专业名称',
      minWidth: 150
    },
    {
      prop: 'deptName',
      label: '所属院系',
      minWidth: 150
    },
    {
      prop: 'director',
      label: '专业负责人',
      minWidth: 120
    },
    {
      prop: 'typeText',
      label: '类型',
      width: 100
    },
    {
      prop: 'duration',
      label: '学制',
      width: 100
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: MajorListItem) => {
        return row.status === 1 ? '启用' : '停用'
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      width: 180
    },
    {
      prop: 'action',
      label: '操作',
      width: 120,
      fixed: 'right' as const,
      formatter: (row: MajorListItem) => {
        return h('div', { class: 'flex gap-1' }, [
          h(ArtButtonTable, {
            type: 'view',
            onClick: () => handleDrillDown('class', row)
          })
        ])
      }
    }
  ]

  /**
   * 获取班级表格列配置
   */
  const getClassColumns = () => [
    {
      prop: 'classCode',
      label: '班级编码',
      minWidth: 120
    },
    {
      prop: 'className',
      label: '班级名称',
      minWidth: 150
    },
    {
      prop: 'majorName',
      label: '所属专业',
      minWidth: 150
    },
    {
      prop: 'grade',
      label: '年级',
      width: 100
    },
    {
      prop: 'enrollmentYear',
      label: '入学年份',
      width: 100
    },
    {
      prop: 'teacher',
      label: '负责人',
      minWidth: 120
    },
    {
      prop: 'currentCount',
      label: '当前人数',
      width: 100
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: ClassListItem) => {
        return row.status === 1 ? '启用' : '停用'
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      width: 180
    }
  ]

  // 根据类型选择API和配置
  const getApiConfig = () => {
    switch (props.drillType) {
      case 'department':
        return {
          apiFn: fetchGetDepartmentPage,
          apiParams: computed(
            () =>
              ({
                ...props.filterParams
              }) as Partial<Api.SystemManage.DepartmentSearchParams>
          ),
          paginationKey: {
            current: 'pageNum',
            size: 'pageSize'
          },
          columnsFactory: () => getDepartmentColumns()
        }
      case 'major':
        return {
          apiFn: fetchGetMajorPage,
          apiParams: computed(
            () =>
              ({
                ...props.filterParams
              }) as Partial<Api.SystemManage.MajorSearchParams>
          ),
          paginationKey: {
            current: 'pageNum',
            size: 'pageSize'
          },
          columnsFactory: () => getMajorColumns()
        }
      case 'class':
        return {
          apiFn: fetchGetClassPage,
          apiParams: computed(
            () =>
              ({
                ...props.filterParams
              }) as Partial<Api.SystemManage.ClassSearchParams>
          ),
          paginationKey: {
            current: 'pageNum',
            size: 'pageSize'
          },
          columnsFactory: () => getClassColumns()
        }
      default:
        throw new Error(`Unknown drill type: ${props.drillType}`)
    }
  }

  const { data, loading, pagination, getData, handleSizeChange, handleCurrentChange } =
    useTable<any>({
      core: getApiConfig() as any,
      transform: {
        responseAdapter: (response: any) => {
          // 处理可能的嵌套 data 字段
          const actualResponse = response?.data || response

          // 院系分页响应
          if (props.drillType === 'department') {
            const list = actualResponse?.list || response?.list || []
            return {
              records: list,
              total: actualResponse?.total || response?.total || 0,
              current:
                actualResponse?.current ||
                actualResponse?.pageNum ||
                response?.current ||
                response?.pageNum ||
                1,
              size:
                actualResponse?.size ||
                actualResponse?.pageSize ||
                response?.size ||
                response?.pageSize ||
                20
            }
          }
          // 专业分页响应使用 list 字段
          if (props.drillType === 'major') {
            const list = actualResponse?.list || response?.list || []
            return {
              records: list,
              total: actualResponse?.total || response?.total || 0,
              current:
                actualResponse?.current ||
                actualResponse?.pageNum ||
                response?.current ||
                response?.pageNum ||
                1,
              size:
                actualResponse?.size ||
                actualResponse?.pageSize ||
                response?.size ||
                response?.pageSize ||
                20
            }
          }
          // 班级分页响应使用 list 字段
          if (props.drillType === 'class') {
            const list = actualResponse?.list || response?.list || []
            return {
              records: list,
              total: actualResponse?.total || response?.total || 0,
              current:
                actualResponse?.current ||
                actualResponse?.pageNum ||
                response?.current ||
                response?.pageNum ||
                1,
              size:
                actualResponse?.size ||
                actualResponse?.pageSize ||
                response?.size ||
                response?.pageSize ||
                20
            }
          }
          // 默认使用标准适配器
          return defaultResponseAdapter(response)
        }
      }
    })

  // 院系表格列配置
  const departmentColumns = computed(() => {
    if (props.drillType !== 'department') return []
    return getDepartmentColumns()
  })

  // 专业表格列配置
  const majorColumns = computed(() => {
    if (props.drillType !== 'major') return []
    return getMajorColumns()
  })

  // 班级表格列配置
  const classColumns = computed(() => {
    if (props.drillType !== 'class') return []
    return getClassColumns()
  })

  /**
   * 关闭弹框
   */
  const handleClose = (): void => {
    emit('update:visible', false)
  }

  // 监听visible和filterParams变化，重新加载数据
  watch(
    () => [props.visible, props.filterParams],
    ([newVisible, newParams], oldValue) => {
      const [oldVisible, oldParams] = oldValue || [undefined, undefined]
      if (newVisible && (!oldVisible || JSON.stringify(newParams) !== JSON.stringify(oldParams))) {
        nextTick(() => {
          getData()
        })
      }
    },
    { immediate: true, deep: true }
  )
</script>

<style scoped lang="scss">
  .drill-down-dialog-content {
    min-height: 400px;
  }
</style>
