<template>
  <OptionPicker
    :model-value="modelValue"
    :options="options"
    label="申请类型"
    placeholder="请选择类型"
    icon="list"
    :required="true"
    :can-modify="canModify"
    inject-key="openApplyTypePicker"
  />
</template>

<script setup lang="ts">
import { OptionPicker } from '../fields';

interface ApplyTypeOption {
  label: string;
  value: string;
}

interface Props {
  modelValue: string;
  options: ApplyTypeOption[];
  canModify?: boolean;
}

withDefaults(defineProps<Props>(), {
  canModify: true,
});
</script>
