<script setup>
import { ref, computed, watch, onMounted } from "vue"
import { Link, usePage } from "@inertiajs/vue3"
import { ChevronDownIcon } from "@heroicons/vue/24/outline"

const props = defineProps({
  label: String,
  href: {
    type: [String, Object],
    required: false,
  },
  icon: {
    type: [Object, Function], // Heroicon component
    required: false,
  },
  children: {
    type: Array,
    default: () => [],
  },
  roles: {
    type: Array,
    default: () => [], // allowed roles/designations
  },
  active: {
    type: Boolean,
    default: false,
  },
  collapsed: {
    type: Boolean,
    default: false,
  },
})

const page = usePage()

// Grab role + designation from inertia props (shared from Laravel)
const role = computed(() => page.props.auth?.user?.role)
const designation = computed(() => page.props.auth?.user?.designation)

// helper: check if this item is allowed
const isAllowed = (item) => {
  if (!item.roles || item.roles.length === 0) return true

  // admin/student: role directly
  if (role.value && role.value !== "faculty" && item.roles.includes(role.value)) {
    return true
  }

  // faculty: check based on designation
  if (role.value === "faculty" && designation.value) {
    return item.roles.includes(designation.value)
  }

  return false
}

// filter children recursively
const visibleChildren = computed(() =>
  (props.children || []).filter(child => isAllowed(child))
)

// true if any child matches current page url
const hasActiveChild = computed(() =>
  props.children.some(child => page.url.startsWith(child.href))
)

// dropdown state
const open = ref(false)

onMounted(() => {
  if (hasActiveChild.value) open.value = true
})
watch(hasActiveChild, (val) => {
  if (val) open.value = true
})
</script>

<template>
  <div>
    <!-- Only render if allowed -->
    <div v-if="isAllowed(props)">
      <!-- Plain link -->
      <template v-if="href">
        <Link
          :href="href"
          class="flex items-center gap-2 px-3 py-2 rounded-lg transition-colors"
          :class="[
            active
              ? 'bg-green-100 text-green-600 font-semibold'
              : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900',
            collapsed ? 'justify-center' : ''
          ]"
        >
          <component v-if="icon" :is="icon" class="w-5 h-5 shrink-0" />
          <span v-if="!collapsed" class="truncate">{{ label }}</span>
        </Link>
      </template>

      <!-- Dropdown toggle -->
      <template v-else>
        <button
          type="button"
          class="w-full flex items-center justify-between px-3 py-2 rounded-lg transition-colors"
          :class="[
            hasActiveChild
              ? 'bg-green-100 text-green-600 font-semibold'
              : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900',
            collapsed ? 'justify-center' : ''
          ]"
          @click="open = !open"
        >
          <div class="flex items-center gap-2">
            <component v-if="icon" :is="icon" class="w-5 h-5 shrink-0" />
            <span v-if="!collapsed" class="truncate">{{ label }}</span>
          </div>
          <!-- Only show chevron if not collapsed -->
          <ChevronDownIcon
            v-if="!collapsed"
            class="w-4 h-4 transition-transform"
            :class="{ 'rotate-180': open }"
          />
        </button>
      </template>
    </div>

    <!-- Dropdown children -->
    <transition
      enter-active-class="transition-all duration-300 ease-out"
      leave-active-class="transition-all duration-200 ease-in"
      enter-from-class="max-h-0 opacity-0"
      enter-to-class="max-h-40 opacity-100"
      leave-from-class="max-h-40 opacity-100"
      leave-to-class="max-h-0 opacity-0"
    >
      <div
        v-if="visibleChildren.length && open && !collapsed"
        class="ml-6 mt-1 space-y-1 overflow-hidden"
      >
        <SidebarLink
          v-for="child in visibleChildren"
          :key="child.label"
          v-bind="child"
          :active="page.url.startsWith(child.href)"
          class="block"
        />
      </div>
    </transition>
  </div>
</template>

<style scoped>
:deep(ul),
:deep(li) {
  list-style: none;
  margin: 0;
  padding: 0;
}
</style>
