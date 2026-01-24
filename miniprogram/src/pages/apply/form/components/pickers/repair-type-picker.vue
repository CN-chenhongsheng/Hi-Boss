<template>
  <OptionPicker
    :model-value="modelValue"
    :options="options"
    label="报修类型"
    placeholder="请选择报修类型"
    icon="setting"
    :required="true"
    :can-modify="true"
    inject-key="openRepairTypePicker"
  />
</template>

<script setup lang="ts">
import { OptionPicker } from '../fields';

interface RepairTypeOption {
  label: string;
  value: number;
}

interface Props {
  modelValue: number | undefined;
  options: RepairTypeOption[];
}

defineProps<Props>();
</script>
