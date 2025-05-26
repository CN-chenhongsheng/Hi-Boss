# ArtDialog 对话框组件

`ArtDialog` 是一个基于 Element Plus 的 `el-dialog` 封装的对话框组件，提供了更便捷的使用方式和额外的功能。

## 特色功能

- **默认可拖拽**：对话框默认支持拖拽功能，提升用户体验
- **便捷的事件和属性**：提供开箱即用的事件处理机制和配置项
- **灵活的工具函数**：支持命令式调用，简化对话框使用方式

## 组件使用

### 基础用法

```vue
<template>
  <div>
    <el-button @click="dialogVisible = true">打开对话框</el-button>
    
    <ArtDialog v-model="dialogVisible" title="提示">
      这是一个对话框的内容
    </ArtDialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ArtDialog from '@/components/core/others/ArtDialog.vue'

const dialogVisible = ref(false)
</script>
```

### 自定义底部按钮

```vue
<template>
  <div>
    <el-button @click="dialogVisible = true">打开对话框</el-button>
    
    <ArtDialog 
      v-model="dialogVisible" 
      title="自定义底部" 
      cancel-text="关闭" 
      confirm-text="保存"
      @cancel="handleCancel"
      @confirm="handleConfirm"
    >
      这是一个对话框的内容
    </ArtDialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ArtDialog from '@/components/core/others/ArtDialog.vue'

const dialogVisible = ref(false)

const handleCancel = () => {
  console.log('点击了取消按钮')
}

const handleConfirm = () => {
  console.log('点击了确认按钮')
}
</script>
```

### 表单对话框

```vue
<template>
  <div>
    <el-button @click="dialogVisible = true">打开表单对话框</el-button>
    
    <ArtDialog 
      v-model="dialogVisible" 
      title="用户信息"
      @open="handleDialogOpen"
      @closed="handleDialogClosed"
    >
      <el-form :model="form" ref="formRef" :rules="rules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email"></el-input>
        </el-form-item>
      </el-form>
    </ArtDialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import ArtDialog from '@/components/core/others/ArtDialog.vue'

const dialogVisible = ref(false)
const formRef = ref(null)
const form = reactive({
  username: '',
  email: ''
})
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }]
}

// 对话框打开时清除表单验证
const handleDialogOpen = () => {
  formRef.value?.clearValidate()
}

// 对话框关闭时重置表单
const handleDialogClosed = () => {
  formRef.value?.resetFields()
}
</script>
```

### 自定义底部插槽

```vue
<template>
  <div>
    <el-button @click="dialogVisible = true">打开对话框</el-button>
    
    <ArtDialog v-model="dialogVisible" title="自定义底部">
      这是一个对话框的内容
      
      <template #footer>
        <div style="text-align: right;">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">提交</el-button>
          <el-button type="success" @click="handleSave">保存草稿</el-button>
        </div>
      </template>
    </ArtDialog>
  </div>
</template>
```

## 工具函数使用

除了组件方式使用外，`ArtDialog` 还提供了更便捷的工具函数方式使用。

### 导入工具函数

```js
import ArtDialog from '@/components/core/others/ArtDialogHelper'
// 或者按需导入
import { alert, confirm, open } from '@/components/core/others/ArtDialogHelper'
```

### 警告对话框

```js
// 基础用法
ArtDialog.alert('操作成功！').then(() => {
  console.log('用户点击了确定')
})

// 自定义标题
ArtDialog.alert('删除成功！', '提示').then(() => {
  // 处理用户点击确定后的逻辑
})

// 更多配置
ArtDialog.alert('操作成功！', '提示', {
  confirmText: '知道了',
  closeOnClickModal: true,
  customClass: 'my-dialog'
})
```

### 确认对话框

```js
// 基础用法
ArtDialog.confirm('确定要删除该记录吗？').then(() => {
  // 用户点击了确定
  deleteRecord()
}).catch(() => {
  // 用户点击了取消
})

// 自定义按钮文字
ArtDialog.confirm('确定要提交审核吗？', '确认', {
  confirmText: '提交',
  cancelText: '再看看'
})
```

### 打开自定义内容对话框

```js
// 定义一个自定义表单组件
const UserForm = defineComponent({
  props: ['id'],
  setup(props, { emit }) {
    const formData = ref({})
    
    onMounted(() => {
      // 如果有id则加载数据
      if (props.id) {
        loadUserData(props.id).then(data => {
          formData.value = data
        })
      }
    })
    
    const submitForm = () => {
      // 提交表单并传递结果
      emit('confirm', formData.value)
    }
    
    return { formData, submitForm }
  }
})

// 打开自定义对话框
ArtDialog.open(UserForm, { id: 100 }, {
  title: '编辑用户',
  width: '600px'
}).then(result => {
  // 获取用户提交的数据
  console.log('用户提交的数据：', result)
}).catch(() => {
  // 用户取消
})
```

## 属性

| 属性名 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| modelValue / v-model | 是否显示对话框 | boolean | false |
| title | 对话框标题 | string | '提示' |
| width | 对话框宽度 | string / number | '50%' |
| top | 对话框距离顶部的距离 | string | '15vh' |
| modal | 是否显示遮罩层 | boolean | true |
| append-to-body | 是否将对话框插入至body元素 | boolean | true |
| destroy-on-close | 关闭时是否销毁组件内的元素 | boolean | false |
| close-on-click-modal | 点击遮罩层是否关闭对话框 | boolean | true |
| close-on-press-escape | 按下ESC是否关闭对话框 | boolean | true |
| show-close | 是否显示关闭按钮 | boolean | true |
| draggable | 是否可拖拽 | boolean | true |
| center | 标题和底部是否居中 | boolean | false |
| align-center | 对话框是否垂直居中 | boolean | true |
| custom-class | 自定义类名 | string | '' |
| cancel-text | 取消按钮文本 | string | '取消' |
| confirm-text | 确认按钮文本 | string | '确定' |
| confirm-loading | 确认按钮加载状态 | boolean | false |
| hide-footer | 是否隐藏底部按钮 | boolean | false |
| auto-close | 是否在点击按钮后自动关闭 | boolean | true |
| before-close | 关闭前的回调 | function(done) | - |

## 事件

| 事件名 | 说明 | 回调参数 |
| --- | --- | --- |
| open | 对话框打开的回调 | - |
| opened | 对话框打开动画结束时的回调 | - |
| close | 对话框关闭的回调 | - |
| closed | 对话框关闭动画结束时的回调 | - |
| cancel | 点击取消按钮时的回调 | - |
| confirm | 点击确认按钮时的回调 | - |

## 插槽

| 插槽名 | 说明 |
| --- | --- |
| default | 对话框的内容 |
| header | 对话框头部内容 |
| footer | 对话框底部内容 |

## 注意事项

1. 对话框默认支持拖拽功能，如果需要禁用，可以设置 `:draggable="false"`

2. 如果需要在对话框内使用表单并处理表单验证和重置，请参考表单对话框示例，在 `open` 和 `closed` 事件中手动处理。

---

# ArtDrawer 抽屉组件

`ArtDrawer` 是一个基于 Element Plus 的 `el-drawer` 封装的抽屉组件，提供了更便捷的使用方式和统一的样式风格。

## 特色功能

- **统一的设计风格**：与系统其他组件保持一致的视觉效果
- **便捷的事件和属性**：提供开箱即用的事件处理机制和配置项
- **灵活的工具函数**：支持命令式调用，简化抽屉使用方式

## 组件使用

### 基础用法

```vue
<template>
  <div>
    <el-button @click="drawerVisible = true">打开抽屉</el-button>
    
    <ArtDrawer v-model="drawerVisible" title="基础抽屉">
      <p>这是抽屉的内容</p>
    </ArtDrawer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ArtDrawer from '@/components/core/others/ArtDrawer.vue'

const drawerVisible = ref(false)
</script>
```

### 自定义方向

```vue
<template>
  <div>
    <el-button @click="drawerVisible = true">打开抽屉</el-button>
    
    <ArtDrawer v-model="drawerVisible" title="自定义方向" direction="ltr" size="30%">
      <p>这是从左侧打开的抽屉</p>
    </ArtDrawer>
  </div>
</template>
```

### 表单抽屉

```vue
<template>
  <div>
    <el-button @click="drawerVisible = true">打开表单抽屉</el-button>
    
    <ArtDrawer 
      v-model="drawerVisible" 
      title="用户信息"
      size="500px"
      :destroy-on-close="true"
      @open="handleDrawerOpen"
      @closed="handleDrawerClosed"
    >
      <el-form :model="form" ref="formRef" :rules="rules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email"></el-input>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div style="text-align: right;">
          <el-button @click="drawerVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">提交</el-button>
        </div>
      </template>
    </ArtDrawer>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import ArtDrawer from '@/components/core/others/ArtDrawer.vue'

const drawerVisible = ref(false)
const formRef = ref(null)
const form = reactive({
  username: '',
  email: ''
})
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }]
}

// 抽屉打开时清除表单验证
const handleDrawerOpen = () => {
  formRef.value?.clearValidate()
}

// 抽屉关闭时重置表单
const handleDrawerClosed = () => {
  formRef.value?.resetFields()
}

// 提交表单
const handleSubmit = () => {
  formRef.value?.validate((valid) => {
    if (valid) {
      console.log('提交表单', form)
      drawerVisible.value = false
    }
  })
}
</script>
```

## 工具函数使用

除了组件方式使用外，`ArtDrawer` 还提供了更便捷的工具函数方式使用。

### 导入工具函数

```js
import ArtDrawerHelper from '@/components/core/others/ArtDrawerHelper'
```

### 打开自定义内容抽屉

```js
// 定义一个自定义详情组件
const UserDetail = defineComponent({
  props: ['userId'],
  setup(props) {
    const userInfo = ref({})
    
    onMounted(() => {
      // 加载用户详情数据
      loadUserDetail(props.userId).then(data => {
        userInfo.value = data
      })
    })
    
    return { userInfo }
  }
})

// 打开自定义抽屉
ArtDrawerHelper.open(UserDetail, {
  userId: 123,
  title: '用户详情',
  size: '500px',
  direction: 'rtl'
})
```

## 属性

| 属性名 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| modelValue / v-model | 是否显示抽屉 | boolean | false |
| title | 抽屉标题 | string | '' |
| direction | 抽屉打开方向 | 'rtl' / 'ltr' / 'ttb' / 'btt' | 'rtl' |
| size | 抽屉大小 | string / number | '30%' |
| destroy-on-close | 关闭时是否销毁组件内的元素 | boolean | false |
| close-on-click-modal | 点击遮罩层是否关闭抽屉 | boolean | true |
| show-close | 是否显示关闭按钮 | boolean | true |
| append-to-body | 是否将抽屉插入至body元素 | boolean | false |
| modal | 是否显示遮罩层 | boolean | true |
| modal-class | 遮罩层的自定义类名 | string | '' |
| drawer-class | 抽屉容器的自定义类名 | string | '' |
| custom-class | 抽屉内容区的自定义类名 | string | '' |
| z-index | 抽屉的层级 | number | 2000 |
| lock-scroll | 是否在抽屉出现时将body滚动锁定 | boolean | true |
| with-header | 是否显示抽屉的头部 | boolean | true |
| before-close | 关闭前的回调 | function(done) | - |

## 事件

| 事件名 | 说明 | 回调参数 |
| --- | --- | --- |
| open | 抽屉打开的回调 | - |
| opened | 抽屉打开动画结束时的回调 | - |
| close | 抽屉关闭的回调 | - |
| closed | 抽屉关闭动画结束时的回调 | - |

## 插槽

| 插槽名 | 说明 |
| --- | --- |
| default | 抽屉的内容 |
| header | 抽屉头部内容（需要设置 with-header 为 true） |
| footer | 抽屉底部内容 |

## 注意事项

1. 当设置 `direction` 为 'ttb' 或 'btt' 时，请确保 `size` 设置为高度值，如 '400px'。

2. 在表单场景中，建议设置 `:destroy-on-close="true"` 以确保表单在关闭后被重置。 