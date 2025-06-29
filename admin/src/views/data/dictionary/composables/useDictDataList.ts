import { getDictDataList } from '@/api/dictionary'
import { DictDataItem } from '@/api/dictionary/model'
import { ApiStatus } from '@/utils/http/status'

export function useDictDataList() {
  // 响应式状态
  const loading = ref(false)
  const dictDataList = ref<DictDataItem[]>([])

  // 分页参数
  const pagination = reactive({
    pageNum: 1,
    pageSize: 10,
    total: 0
  })

  // 获取字典数据列表
  const getDictData = async (dictType: string, searchParams?: any) => {
    loading.value = true
    try {
      const params = {
        pageNum: pagination.pageNum,
        pageSize: pagination.pageSize,
        dictType,
        ...(searchParams || {}) // 合并搜索参数
      }

      const res = await getDictDataList(params)
      if (res.code !== ApiStatus.success) {
        ElMessage.error(res.msg || '获取字典数据失败')
        return
      }
      dictDataList.value = res.rows.map((item) => ({
        ...item,
        status: Number(item.status) // 确保status格式正确
      }))
      pagination.total = res.total
    } catch (error) {
      console.error('获取字典数据出错:', error)
      ElMessage.error('获取字典数据出错')
    } finally {
      loading.value = false
    }
  }

  // 处理页码变化
  const handleCurrentChange = (page: number, dictType: string, searchParams?: any) => {
    pagination.pageNum = page
    getDictData(dictType, searchParams)
  }

  // 处理每页条数变化
  const handleSizeChange = (size: number, dictType: string, searchParams?: any) => {
    pagination.pageSize = size
    pagination.pageNum = 1
    getDictData(dictType, searchParams)
  }

  return {
    loading,
    dictDataList,
    pagination,
    getDictData,
    handleCurrentChange,
    handleSizeChange
  }
}
