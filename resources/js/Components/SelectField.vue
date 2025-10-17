<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  modelValue: {
    type: [String, Number],
    default: ''
  },
  options: {
    type: Array,
    default: () => [] // [{ value: '1', label: 'Option 1' }]
  },
  placeholder: {
    type: String,
    default: '-Select-'
  },
  disabled: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <div class="flex flex-col gap-1">
    <select
      :disabled="disabled"
      class="rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 disabled:bg-gray-100 disabled:text-gray-500 disabled:cursor-not-allowed
               readonly:bg-gray-100 readonly:text-gray-500 relative z-[9999]"
      :value="modelValue"
      @change="emit('update:modelValue', $event.target.value)"
    >
      <!-- Placeholder -->
      <option value="">{{ placeholder }}</option>

      <!-- Dynamic options -->
      <option
        v-for="(opt, i) in options"
        :key="i"
        :value="opt.value"
      >
        {{ opt.label }}
      </option>
    </select>
  </div>
</template>
