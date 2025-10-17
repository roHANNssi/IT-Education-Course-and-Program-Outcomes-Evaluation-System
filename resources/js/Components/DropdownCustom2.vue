<script setup>
import { ref, onMounted, onBeforeUnmount, computed, nextTick } from 'vue'
import { ChevronDownIcon, XMarkIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  label: { type: String, default: 'Select' },
  options: { type: Array, default: () => [] }, // ["1"] or [{ value: 1, label: "One" }]
  modelValue: { type: Array, default: () => [] }, // now an array for multi-select
  width: { type: String, default: 'w-64' },
})

const emit = defineEmits(['update:modelValue'])

const isOpen = ref(false)
const dropdownRef = ref(null)
const dropdownPos = ref({ top: 0, left: 0, width: 0, openAbove: false })
const searchQuery = ref('')

const displayLabel = (option) =>
  typeof option === 'object' ? option.label : option

const optionValue = (option) =>
  typeof option === 'object' ? option.value : option

// Filtered options based on search
const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  return props.options.filter((o) => {
    const label = displayLabel(o).toLowerCase()
    return label.includes(searchQuery.value.toLowerCase())
  })
})

// Selected options (objects)
const selectedOptions = computed(() => {
  return props.options.filter((o) =>
    props.modelValue.includes(optionValue(o))
  )
})

const toggleOption = (option) => {
  const value = optionValue(option)
  let newValues = [...props.modelValue]

  if (newValues.includes(value)) {
    newValues = newValues.filter((v) => v !== value)
  } else {
    newValues.push(value)
  }

  emit('update:modelValue', newValues)
}

const removeOption = (value) => {
  emit(
    'update:modelValue',
    props.modelValue.filter((v) => v !== value)
  )
}

// Select all visible options
const selectAll = () => {
  const allValues = filteredOptions.value.map(optionValue)
  emit('update:modelValue', Array.from(new Set([...props.modelValue, ...allValues])))
}

// Clear all selections
const clearAll = () => {
  emit('update:modelValue', [])
}

const updateDropdownPos = () => {
  if (!dropdownRef.value) return
  const rect = dropdownRef.value.getBoundingClientRect()
  const dropdownHeight = 280

  const spaceBelow = window.innerHeight - rect.bottom
  const spaceAbove = rect.top

  const openAbove = spaceBelow < dropdownHeight && spaceAbove > spaceBelow

  dropdownPos.value = {
    top: openAbove
      ? rect.top + window.scrollY - dropdownHeight
      : rect.bottom + window.scrollY,
    left: rect.left + window.scrollX,
    width: rect.width,
    openAbove,
  }
}

const handleClickOutside = (e) => {
  if (
    dropdownRef.value &&
    !dropdownRef.value.contains(e.target) &&
    !e.target.closest('.custom-dropdown-menu')
  ) {
    isOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<template>
  <div class="relative inline-block text-left" ref="dropdownRef">
    <!-- Trigger -->
    <button
      @click="() => { isOpen = !isOpen; nextTick(updateDropdownPos) }"
      type="button"
      :class="[
        'inline-flex flex-wrap gap-1 items-center rounded-md border border-gray-300 bg-white px-2 py-1 text-sm text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-green-500',
        width
      ]"
    >
      <!-- Selected tags -->
      <template v-if="selectedOptions.length > 0">
        <span
          v-for="opt in selectedOptions"
          :key="optionValue(opt)"
          class="flex items-center gap-1 rounded bg-green-100 px-2 py-0.5 text-green-700 text-xs"
        >
          {{ displayLabel(opt) }}
          <XMarkIcon
            class="w-3 h-3 cursor-pointer"
            @click.stop="removeOption(optionValue(opt))"
          />
        </span>
      </template>

      <span v-else class="text-gray-400">{{ label }}</span>

      <ChevronDownIcon class="w-4 h-4 ml-auto" />
    </button>

    <!-- Dropdown menu -->
    <teleport to="body">
      <transition name="fade">
        <div
          v-if="isOpen"
          class="custom-dropdown-menu absolute z-[9999] rounded-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5"
          :style="{
            top: dropdownPos.top + 'px',
            left: dropdownPos.left + 'px',
            width: dropdownPos.width + 'px',
            position: 'absolute'
          }"
        >
          <!-- Select all / Clear all -->
          <div class="flex justify-between items-center px-2 py-1 border-b border-gray-200 bg-gray-50">
            <button
              @click.stop="selectAll"
              class="text-xs text-green-600 hover:underline"
            >
              Select All
            </button>
            <button
              @click.stop="clearAll"
              class="text-xs text-red-500 hover:underline"
            >
              Clear All
            </button>
          </div>

          <!-- Search box -->
          <div class="p-2 border-b border-gray-200">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search..."
              class="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-green-500"
            />
          </div>

          <!-- Options -->
          <ul class="py-1 text-sm text-gray-700 max-h-60 overflow-auto">
            <li
              v-for="(option, idx) in filteredOptions"
              :key="optionValue(option)"
              class="flex items-center gap-2 cursor-pointer px-4 py-2 hover:bg-gray-100"
              @click="toggleOption(option)"
            >
              <input
                type="checkbox"
                class="rounded text-green-500 focus:ring-green-500"
                :checked="props.modelValue.includes(optionValue(option))"
              />
              {{ displayLabel(option) }}
            </li>

            <li v-if="filteredOptions.length === 0" class="px-4 py-2 text-gray-400">
              No results found
            </li>
          </ul>
        </div>
      </transition>
    </teleport>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
