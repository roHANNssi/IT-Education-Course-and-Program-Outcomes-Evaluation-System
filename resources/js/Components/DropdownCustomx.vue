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

const displayLabel = (option) =>
  typeof option === 'object' ? option.label : option

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
}

// Position dropdown under or above button
const updateDropdownPos = () => {
  if (!dropdownRef.value) return
  const rect = dropdownRef.value.getBoundingClientRect()
  const dropdownHeight = Math.min(props.options.length * 40, 240) // estimate: 40px/item, max 240px

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

// Close on Esc
const handleEsc = (e) => {
  if (e.key === 'Escape') isOpen.value = false
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
  document.addEventListener('keydown', handleEsc)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
  document.removeEventListener('keydown', handleEsc)
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
          <ul class="py-1 text-sm text-gray-700 max-h-60 overflow-auto">
            <li
              v-for="option in options"
              :key="typeof option === 'object' ? option.value : option"
              @click="selectOption(option)"
              class="cursor-pointer px-4 py-2 hover:bg-gray-100"
            >
              {{ displayLabel(option) }}
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
