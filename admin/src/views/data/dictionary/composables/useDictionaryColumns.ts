import { useCheckedColumns } from '@/composables/useCheckedColumns'
import ArtButtonTable from '@/components/core/forms/ArtButtonTable.vue'
import ArtStatusSwitch from '@/components/core/forms/ArtStatusSwitch.vue'
import { updateDictType, updateDictData } from '@/api/dictionary'
import { ApiStatus } from '@/utils/http/status'

export function useDictionaryColumns(handleOperation: (type: string, row?: any) => void) {
  // 处理状态切换
  const handleStatusChange = async (value: string | number | boolean, row: any) => {
    try {
      // 构建更新数据
      const updateData = {
        dictId: row.dictId,
        dictName: row.dictName,
        dictType: row.dictType,
        status: Number(value), // 确保转换为数字
        remark: row.remark || ''
      }

      // 调用更新接口
      const res: any = await updateDictType(updateData)
      // 判断是否更新成功
      if (res.code !== ApiStatus.success) {
        ElMessage.error(res.msg || '状态更新失败')
        return
      }

      ElMessage.success('状态更新成功')
    } catch (error) {
      console.error('更新字典状态出错:', error)
      ElMessage.error('更新字典状态出错')
    }
  }

  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection', width: 55 }, // 勾选列
    { prop: 'dictName', label: '字典名称', minWidth: 150 },
    { prop: 'dictType', label: '字典类型', minWidth: 150 },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: any) => {
        return h(ArtStatusSwitch, {
          modelValue: row.status,
          onChange: (value: string | number | boolean) => handleStatusChange(value, row)
        })
      }
    },
    { prop: 'remark', label: '备注', minWidth: 180 },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      minWidth: 180
    },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'detail',
            onClick: () => handleOperation('detail', row)
          }),
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => handleOperation('edit', row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => handleOperation('delete', row)
          })
        ])
      }
    }
  ])

  return {
    columnChecks,
    columns
  }
}

// 字典数据列表表格列配置
export function useDictDataColumns(handleOperation: (type: string, row?: any) => void) {
  // 处理状态切换
  const handleDictDataStatusChange = async (value: string | number | boolean, row: any) => {
    try {
      // 构建更新数据，只包含必要的字段
      const updateData = {
        dictCode: row.dictCode,
        dictType: row.dictType,
        dictLabel: row.dictLabel,
        dictValue: row.dictValue,
        dictSort: row.dictSort,
        status: Number(value), // 确保转换为数字
        remark: row.remark || ''
      }

      // 调用API更新字典数据状态
      const res: any = await updateDictData(updateData)

      // 判断是否更新成功
      if (res.code !== ApiStatus.success) {
        ElMessage.error(res.msg || '状态更新失败')
        return
      }

      ElMessage.success('字典数据状态更新成功')
    } catch (error) {
      console.error('更新字典数据状态出错:', error)
      ElMessage.error('更新字典数据状态出错')
    }
  }

  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection', width: 55 },
    { prop: 'dictSort', label: '字典排序', width: 100 },
    { prop: 'dictLabel', label: '字典标签', width: 150 },
    { prop: 'dictValue', label: '字典键值', width: 150 },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row: any) => {
        return h(ArtStatusSwitch, {
          modelValue: row.status,
          onChange: (value: string | number | boolean) => handleDictDataStatusChange(value, row)
        })
      }
    },
    {
      prop: 'isDefault',
      label: '是否默认',
      width: 100,
      formatter: (row: any) => {
        return row.isDefault === 'Y' ? '是' : '否'
      }
    },
    { prop: 'createTime', label: '创建时间', sortable: true, width: 180 },
    { prop: 'remark', label: '备注' },
    {
      prop: 'operation',
      label: '操作',
      formatter: (row: any) => {
        return h('div', { class: 'operation-btns' }, [
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => handleOperation('edit', row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => handleOperation('delete', row)
          })
        ])
      }
    }
  ])

  return {
    columnChecks,
    columns
  }
}
