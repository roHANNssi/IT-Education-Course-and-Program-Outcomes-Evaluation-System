<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { ChevronDownIcon, XMarkIcon, CheckIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  modelValue: {
    type: [String, Number, Array],
    default: ''
  },
  options: {
    type: Array,
    default: () => []
  },
  placeholder: {
    type: String,
    default: '-Select-'
  },
  disabled: {
    type: Boolean,
    default: false
  },
  width: {
    type: String,
    default: 'w-64'
  },
  multiple: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

const isOpen = ref(false)
const dropdownRef = ref(null)
const dropdownPos = ref({ top: 0, left: 0, width: 0 })
const searchQuery = ref('')
const highlightedIndex = ref(-1) // for keyboard nav

// Helpers
const displayLabel = (opt) => typeof opt === 'object' ? opt.label : opt
const optionValue = (opt) => typeof opt === 'object' ? opt.value : opt

// Filtered options
const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  return props.options.filter((o) =>
    displayLabel(o).toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

// Selected
const selectedOptions = computed(() => {
  if (props.multiple) {
    if (!Array.isArray(props.modelValue)) return []
    return props.options.filter((o) => props.modelValue.includes(optionValue(o)))
  } else {
    const found = props.options.find(
      (o) => String(optionValue(o)) === String(props.modelValue)
    )
    return found ? [found] : []
  }
})

// --- Actions ---
const toggleOption = (opt) => {
  const value = optionValue(opt)

  if (props.multiple) {
    let newValues = Array.isArray(props.modelValue) ? [...props.modelValue] : []
    if (newValues.includes(value)) {
      newValues = newValues.filter((v) => v !== value)
    } else {
      newValues.push(value)
    }
    emit('update:modelValue', newValues)
  } else {
    emit('update:modelValue', value)
    isOpen.value = false
  }
}

const removeOption = (value) => {
  if (props.multiple) {
    emit('update:modelValue', props.modelValue.filter((v) => v !== value))
  }
}

const selectAll = () => {
  if (!props.multiple) return
  const allValues = filteredOptions.value.map(optionValue)
  emit('update:modelValue', Array.from(new Set([...props.modelValue, ...allValues])))
}

const clearAll = () => {
  emit('update:modelValue', props.multiple ? [] : '')
}

// --- Dropdown positioning ---
const updateDropdownPos = () => {
  if (!dropdownRef.value) return
  const rect = dropdownRef.value.getBoundingClientRect()
  dropdownPos.value = {
    top: rect.bottom + window.scrollY,
    left: rect.left + window.scrollX,
    width: rect.width
  }
}

// Close on outside click
const handleClickOutside = (e) => {
  if (
    dropdownRef.value &&
    !dropdownRef.value.contains(e.target) &&
    !e.target.closest('.custom-dropdown-menu')
  ) {
    isOpen.value = false
    highlightedIndex.value = -1
  }
}

// Keyboard navigation
const handleKeydown = (e) => {
  if (!isOpen.value) return

  if (e.key === 'ArrowDown') {
    e.preventDefault()
    highlightedIndex.value =
      (highlightedIndex.value + 1) % filteredOptions.value.length
    scrollIntoView()
  } else if (e.key === 'ArrowUp') {
    e.preventDefault()
    highlightedIndex.value =
      (highlightedIndex.value - 1 + filteredOptions.value.length) %
      filteredOptions.value.length
    scrollIntoView()
  } else if (e.key === 'Enter' || e.key === ' ') {
    e.preventDefault()
    const opt = filteredOptions.value[highlightedIndex.value]
    if (opt) toggleOption(opt)
  } else if (e.key === 'Escape') {
    isOpen.value = false
    highlightedIndex.value = -1
  }
}

const scrollIntoView = () => {
  nextTick(() => {
    const el = document.querySelector(
      `.custom-dropdown-menu li[data-index="${highlightedIndex.value}"]`
    )
    if (el) el.scrollIntoView({ block: 'nearest' })
  })
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
  document.addEventListener('keydown', handleKeydown)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<template>
  <div class="relative" ref="dropdownRef">
    <!-- Trigger -->
    <button
      v-if="!disabled"
      @click="() => { isOpen = !isOpen; highlightedIndex = -1; nextTick(updateDropdownPos) }"
      type="button"
      :class="[
        'inline-flex flex-wrap gap-1 items-center rounded-md border border-gray-300 bg-white px-2 py-1 text-sm text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-green-500',
        width
      ]"
    >
      <!-- Multiple: show tags -->
      <template v-if="multiple && selectedOptions.length > 0">
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

      <!-- Single: show label -->
      <template v-else-if="!multiple && selectedOptions.length > 0">
        <span>{{ displayLabel(selectedOptions[0]) }}</span>
      </template>

      <!-- Placeholder -->
      <span v-else class="text-gray-400">{{ placeholder }}</span>

      <ChevronDownIcon class="w-4 h-4 ml-auto" />
    </button>

    <!-- Disabled -->
    <div
      v-else
      :class="[
        'inline-flex justify-between items-center rounded-md border border-gray-300 bg-gray-100 px-2 py-1 text-sm text-gray-400 cursor-not-allowed',
        width
      ]"
    >
      {{ placeholder }}
    </div>

    <!-- Dropdown -->
    <teleport to="body">
      <transition name="fade">
        <div
          v-if="isOpen"
          class="custom-dropdown-menu absolute z-[9999] rounded-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5"
          :style="{ top: dropdownPos.top + 'px', left: dropdownPos.left + 'px', width: dropdownPos.width + 'px' }"
        >
          <!-- Multi-select actions -->
          <template v-if="multiple">
            <div class="flex justify-between items-center px-2 py-1 border-b border-gray-200 bg-gray-50">
              <button @click.stop="selectAll" class="text-xs text-green-600 hover:underline">Select All</button>
              <button @click.stop="clearAll" class="text-xs text-red-500 hover:underline">Clear All</button>
            </div>
          </template>

          <!-- Search -->
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
              v-for="(opt, i) in filteredOptions"
              :key="optionValue(opt)"
              :data-index="i"
              @click="toggleOption(opt)"
              class="flex items-center gap-2 cursor-pointer px-4 py-2"
              :class="{
                'bg-gray-100': highlightedIndex === i,
                'bg-green-50': !multiple && optionValue(opt) === props.modelValue
              }"
            >
              <template v-if="multiple">
                <input
                  type="checkbox"
                  class="rounded text-green-500 focus:ring-green-500"
                  :checked="props.modelValue.includes(optionValue(opt))"
                />
              </template>
              <template v-else>
                <CheckIcon
                  v-if="optionValue(opt) === props.modelValue"
                  class="w-4 h-4 text-green-600"
                />
              </template>
              {{ displayLabel(opt) }}
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
