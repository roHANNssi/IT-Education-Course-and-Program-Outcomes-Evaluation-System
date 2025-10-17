<script setup>
import { ref, onMounted, onBeforeUnmount, computed, nextTick } from 'vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  label: { type: String, default: 'Select' },
  options: { type: Array, default: () => [] }, // ["1"] or [{ value: 1, label: "One" }]
  modelValue: { type: [String, Number], default: '' },
  width: { type: String, default: 'w-40' },
})

const emit = defineEmits(['update:modelValue'])

const isOpen = ref(false)
const dropdownRef = ref(null)
const dropdownPos = ref({ top: 0, left: 0, width: 0, openAbove: false })
const highlightedIndex = ref(-1)
const searchQuery = ref('')

const displayLabel = (option) =>
  typeof option === 'object' ? option.label : option

// Filtered options based on search
const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  return props.options.filter((o) => {
    const label = displayLabel(o).toLowerCase()
    return label.includes(searchQuery.value.toLowerCase())
  })
})

// Show selected or fallback label
const selectedLabel = computed(() => {
  if (!props.modelValue) return props.label

  const found = props.options.find((o) => {
    const value = typeof o === 'object' ? o.value : o
    return String(value) === String(props.modelValue)
  })
  return found ? displayLabel(found) : props.label
})

const selectOption = (option) => {
  const value = typeof option === 'object' ? option.value : option
  emit('update:modelValue', value)
  isOpen.value = false
  highlightedIndex.value = -1
  searchQuery.value = ''
}

// Position dropdown under or above button
const updateDropdownPos = () => {
  if (!dropdownRef.value) return
  const rect = dropdownRef.value.getBoundingClientRect()
  const dropdownHeight = 240 // max-h-60

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

// Handle keyboard navigation
const handleKeydown = (e) => {
  if (!isOpen.value) return

  if (e.key === 'ArrowDown') {
    e.preventDefault()
    highlightedIndex.value =
      highlightedIndex.value < filteredOptions.value.length - 1
        ? highlightedIndex.value + 1
        : 0
    scrollIntoView()
  } else if (e.key === 'ArrowUp') {
    e.preventDefault()
    highlightedIndex.value =
      highlightedIndex.value > 0
        ? highlightedIndex.value - 1
        : filteredOptions.value.length - 1
    scrollIntoView()
  } else if (e.key === 'Enter') {
    e.preventDefault()
    if (highlightedIndex.value >= 0) {
      selectOption(filteredOptions.value[highlightedIndex.value])
    }
  } else if (e.key === 'Escape') {
    isOpen.value = false
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

// Close on outside click
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
  document.addEventListener('keydown', handleKeydown)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<template>
  <div class="relative inline-block text-left" ref="dropdownRef">
    <!-- Trigger -->
    <button
      @click="() => { isOpen = !isOpen; nextTick(updateDropdownPos) }"
      type="button"
      :class="[
        'inline-flex justify-between items-center rounded-md border border-gray-300 bg-white px-3 py-1 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-green-500',
        width
      ]"
    >
      <span>{{ selectedLabel }}</span>
      <ChevronDownIcon class="w-4 h-4 ml-2" />
    </button>

    <!-- Dropdown menu (teleported to body) -->
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
          <!-- Search box -->
          <div class="p-2 border-b border-gray-200">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search..."
              class="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-green-500"
              @keydown.stop
            />
          </div>

          <!-- Options -->
          <ul class="py-1 text-sm text-gray-700 max-h-60 overflow-auto">
            <li
              v-for="(option, idx) in filteredOptions"
              :key="typeof option === 'object' ? option.value : option"
              :data-index="idx"
              @click="selectOption(option)"
              :class="[
                'cursor-pointer px-4 py-2',
                idx === highlightedIndex
                  ? 'bg-green-500 text-white'
                  : 'hover:bg-gray-100'
              ]"
            >
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
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.15s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
