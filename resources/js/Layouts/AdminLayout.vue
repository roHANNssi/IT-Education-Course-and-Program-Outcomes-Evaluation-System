<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { usePage, router, Link } from '@inertiajs/vue3'
import ApplicationLogo from '@/Components/ApplicationLogo.vue'
import SidebarLink from '@/Components/SidebarLink.vue'
import {
  UsersIcon,
  Cog6ToothIcon,
  CogIcon,
  Squares2X2Icon,
  Bars3Icon,
  BellIcon,
  CalendarIcon,
  ChevronDoubleLeftIcon,
  ChevronDoubleRightIcon,
  ChevronDownIcon,
  ClipboardDocumentListIcon,
  AdjustmentsHorizontalIcon,
  ArrowRightStartOnRectangleIcon,
  ChartBarIcon, // optional (example for Reports)
  ChartPieIcon,
  NumberedListIcon,
  ListBulletIcon,
  XMarkIcon
} from "@heroicons/vue/24/outline"

// state
const sidebarOpen = ref(false)
const collapsed = ref(false)
const dropdownOpen = ref(false)
const notifOpen = ref(false)
const notifCount = ref(3)
const notifications = ref([
  { message: "New user registered" },
  { message: "System update completed" },
  { message: "Reminder: Meeting at 3PM" },
])

// current page info
const page = usePage()
const userName = computed(() => page.props?.auth?.user?.name ?? 'User')
const userInitials = computed(() =>
  userName.value
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
)
const currentUrl = computed(() => page.url || window.location.pathname)

// active helper
const isActive = (path) => currentUrl.value.startsWith(path)

// ── NAV SECTIONS ──────────────────────────────────────────────────────────────
// Rename titles however you like. Add more sections as needed.
const nav = [
  {
    title: 'MAIN',
    items: [
      { label: 'Dashboard', href: '/dashboard', icon: Squares2X2Icon, roles: ['admin', 'dean', 'faculty', 'program-head'] },
      { label: 'Assigned Subjects', href: '/assignedsubjects', icon: ListBulletIcon, roles: ['faculty', 'dean', 'program-head'] },
      {
        label: 'Management',
        icon: AdjustmentsHorizontalIcon,
        roles: ['admin','dean','program-head'],
        children: [
          { label: 'Users',  href: '/users',  icon: UsersIcon, roles: ['admin'] },
          { label: 'Faculty Members',  href: '/faculty-members',  icon: UsersIcon, roles: ['program-head'] },
          { label: 'Programs',  href: '/courses',  icon: ListBulletIcon, roles: ['admin', 'dean'] },
          { label: 'Curriculums',  href: '/curriculums',  icon: ListBulletIcon, roles: ['admin', 'dean', 'program-head'] },
          { label: 'Course Majors',  href: '/course-majors',  icon: ClipboardDocumentListIcon, roles: ['admin', 'dean', 'program-head'] },
          // { label: 'Subjects',  href: '/subjects',  icon: ListBulletIcon, roles: ['admin', 'dean', 'program-head'] },
          { label: 'Program Outcomes',  href: '/program-outcomes',  icon: CogIcon, roles: ['admin', 'dean', 'program-head'] },
        ]
      },
    ]
  },
  {
    title: 'REPORTS',
    items: [
      { label: 'Evaluation Response', href: '/reports/evaluation-response', icon: ListBulletIcon, roles: ['admin', 'dean', 'program-head'] },
      { label: 'P.O. Assessment Results', href: '/reports/po-assessment-result', icon: ChartPieIcon, roles: ['admin', 'dean', 'program-head'] },
    ]
  },
  {
    title: 'SYSTEM',
    items: [
      {
        label: 'Settings',
        icon: Cog6ToothIcon,
        roles: ['admin', 'dean', 'program-head'],
        children: [
          { label: 'Semesters',  href: '/semesters',  icon: NumberedListIcon, roles: ['admin', 'dean'] },
          { label: 'Scales', href: '/scales', icon: NumberedListIcon, roles: ['admin', 'dean'] },
          { label: 'Rating Setting',  href: '/rating-setting',  icon: NumberedListIcon, roles: ['admin', 'dean', 'program-head'] },
          { label: 'Evaluation Schedules',  href: '/evaluation-schedules',  icon: CalendarIcon, roles: ['admin', 'dean'] },
          { label: 'General Settings',  href: '/general-setting',  icon: CogIcon, roles: ['admin', 'dean'] },
        ]
      },
    ]
  },
]

// ── SECTION VISIBILITY HELPER ──────────────────────────────────────────────
const pageUser = computed(() => page.props?.auth?.user ?? null)
const userRole = computed(() => pageUser.value?.role ?? null)
const userDesignation = computed(() => pageUser.value?.designation ?? null)

function isAllowed(item) {
  if (!item.roles?.length) return true
  if (userRole.value && item.roles.includes(userRole.value)) return true
  if (userRole.value === "faculty" && userDesignation.value && item.roles.includes(userDesignation.value)) {
    return true
  }
  return false
}

function sectionHasAllowedItems(section) {
  if (!section || !Array.isArray(section.items)) {
    return false
  }

  return section.items.some(item => {
    if (isAllowed(item)) return true
    if (item.children?.length) {
      return item.children.some(child => isAllowed(child))
    }
    return false
  })
}

// Filtered nav
const allowedNav = computed(() =>
  nav.filter(section => sectionHasAllowedItems(section))
)

// logout
const doLogout = () => router.post('/logout')

// close dropdown on outside click
function closeDropdown(e) {
  if (!e.target.closest('#user-dropdown')) {
    dropdownOpen.value = false
  }
}

// close notification dropdown on outside click
function closeNotifDropdown(e) {
  if (!e.target.closest('#notif-dropdown')) {
    notifOpen.value = false
  }
}

onMounted(() => document.addEventListener('click', closeDropdown))
onBeforeUnmount(() => document.removeEventListener('click', closeDropdown))

onMounted(() => {
  document.addEventListener('click', closeNotifDropdown)
})
onBeforeUnmount(() => {
  document.removeEventListener('click', closeNotifDropdown)
})
</script>

<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Off-canvas (mobile) -->
    <div v-show="sidebarOpen" class="fixed inset-0 z-40 flex md:hidden" role="dialog" aria-modal="true">
      <div class="fixed inset-0 bg-black/50" @click="sidebarOpen = false"></div>

      <transition
        enter-active-class="transition transform duration-300 ease-out"
        enter-from-class="-translate-x-full opacity-0"
        enter-to-class="translate-x-0 opacity-100"
        leave-active-class="transition transform duration-200 ease-in"
        leave-from-class="translate-x-0 opacity-100"
        leave-to-class="-translate-x-full opacity-0"
      >
        <aside
          v-if="sidebarOpen"
          class="relative z-50 flex w-64 flex-col bg-white shadow-xl max-h-screen"
        >
          <!-- Sticky header -->
          <div class="sticky top-0 z-10 flex items-center justify-between px-4 py-3 border-b bg-green-500">
            <ApplicationLogo class="h-10 w-auto fill-current text-gray-800" />
            <h1 class="text-lg font-bold text-gray-100">IT Ed. Evaluation</h1>
            <button
              class="rounded text-gray-600 hover:bg-green-600"
              @click="sidebarOpen = false"
              aria-label="Close sidebar"
            >
              <XMarkIcon class="w-6 h-6 shrink-0 text-white" />
            </button>
          </div>

          <!-- Scrollable nav -->
          <div class="mt-2 px-4 text-[12px] font-semibold tracking-wider text-gray-500">
            <p>{{ $page.props.auth.user.email }}</p>
            <p v-if="$page.props.auth.user.role === 'faculty'">Logged-in as {{ $page.props.auth.user.designation.toUpperCase() }}</p>
            <p v-if="$page.props.auth.user.role === 'admin'">Logged-in as {{ $page.props.auth.user.role.toUpperCase() }}</p>
          </div>
          <nav class="mt-2 flex-1 overflow-y-auto sidebar-scroll">
            <div v-for="section in allowedNav" :key="section.title" class="mt-4 first:mt-2">
              <p class="px-4 text-[10px] font-semibold tracking-wider text-gray-400">
                {{ section.title }}
              </p>
              <div class="mt-1 px-2">
                <SidebarLink
                  v-for="item in section.items"
                  :key="item.label"
                  v-bind="item"
                  :active="item.href ? isActive(item.href) : (item.children?.some(c => isActive(c.href)))"
                />
              </div>
            </div>
          </nav>
        </aside>
      </transition>
    </div>

    <!-- Desktop sidebar -->
    <aside class="hidden md:flex md:w-64 md:flex-col bg-white shadow-lg max-h-screen">
      <!-- Sticky header -->
      <div class="sticky top-0 z-10 flex items-center gap-2 px-4 py-3 border-b bg-green-500">
        <ApplicationLogo class="h-10 w-auto fill-current text-gray-800" />
        <h1 class="text-lg font-bold text-gray-100 whitespace-nowrap">
          IT Ed. Evaluation
        </h1>
      </div>

      <!-- Scrollable nav -->
      <div class="mt-2 px-4 text-[12px] font-semibold tracking-wider text-gray-500">
        <p>{{ $page.props.auth.user.email }}</p>
        <p v-if="$page.props.auth.user.role === 'faculty'">Logged-in as {{ $page.props.auth.user.designation.toUpperCase() }}</p>
        <p v-if="$page.props.auth.user.role === 'admin'">Logged-in as {{ $page.props.auth.user.role.toUpperCase() }}</p>
      </div>
      <nav class="mt-2 flex-1 overflow-y-auto sidebar-scroll">
        <div v-for="section in allowedNav" :key="section.title" class="mt-4 first:mt-2">
          <p class="px-4 text-[10px] font-semibold tracking-wider text-gray-400">
            {{ section.title }}
          </p>
          <div class="mt-1 px-2">
            <SidebarLink
              v-for="item in section.items"
              :key="item.label"
              v-bind="item"
              :active="item.href ? isActive(item.href) : (item.children?.some(c => isActive(c.href)))"
            />
          </div>
        </div>
      </nav>
    </aside>

    <!-- Main -->
    <div class="flex flex-1 flex-col min-w-0">
      <!-- Header -->
      <header class="bg-green-500 shadow z-10">
        <div class="flex items-center justify-between px-4 py-3 md:px-6">
          <!-- Mobile menu button -->
          <button
            class="md:hidden rounded p-2 text-gray-600 hover:bg-green-600"
            @click="sidebarOpen = true"
            aria-label="Open sidebar"
          >
            <Bars3Icon class="w-6 h-6 text-gray-100" />
          </button>

          <!-- Page title -->
          <h2 class="text-base md:text-lg font-semibold text-gray-100">
            <slot name="header" />
          </h2>

          <!-- Right side: Notifications + User -->
          <div class="flex items-center gap-4 relative">
            <!-- Notification Bell -->
            <div id="notif-dropdown" class="relative">
              <button
                @click="notifOpen = !notifOpen"
                class="relative rounded-full p-2 text-gray-600 hover:text-gray-600 hover:bg-green-600 focus:outline-none"
              >
                <BellIcon class="w-6 h-6 text-gray-100" />
                <!-- Badge -->
                <!-- <span
                  v-if="notifCount > 0"
                  class="absolute -top-0.5 -right-0.5 inline-flex items-center justify-center
                        px-1.5 py-0.5 text-xs font-bold leading-none text-white bg-red-600 rounded-full"
                >
                  {{ notifCount }}
                </span> -->
              </button>

              <!-- Notification dropdown -->
              <transition
                enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95"
                enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75"
                leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95"
              >
                <div
                  v-show="notifOpen"
                  class="absolute right-0 mt-2 w-72 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 z-50"
                >
                  <div class="py-2 px-4 border-b font-semibold text-gray-700">
                    Notifications
                  </div>
                  <div class="max-h-60 overflow-y-auto">
                    <div v-if="notifications.length === 0" class="px-4 py-3 text-sm text-gray-500">
                      No new notifications
                    </div>
                    <div
                      v-for="(notif, index) in notifications"
                      :key="index"
                      class="px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 cursor-pointer"
                    >
                      {{ notif.message }}
                    </div>
                  </div>
                </div>
              </transition>
            </div>

            <!-- User dropdown -->
            <div id="user-dropdown" class="relative">
              <button
                @click="dropdownOpen = !dropdownOpen"
                class="flex items-center gap-2 rounded-full bg-gray-100 px-3 py-1 text-sm font-medium text-gray-700 hover:bg-gray-200 focus:outline-none"
              >
                <div class="flex h-8 w-8 items-center justify-center rounded-full bg-green-600 text-white font-bold">
                  <!-- {{ userInitials }} -->
                    Me
                </div>
                <ChevronDownIcon class="w-4 h-4 text-gray-600" />
              </button>

              <transition
                enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95"
                enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75"
                leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95"
              >
                <div
                  v-show="dropdownOpen"
                  class="absolute right-0 mt-2 w-44 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 z-50"
                >
                  <div class="py-1">
                    <!-- Profile Link -->
                    <Link
                      href="/profile"
                      class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    >
                      Profile
                    </Link>

                    <!-- Logout Link -->
                    <Link
                      href="/logout"
                      method="post"
                      as="button"
                      class="w-full text-left block px-4 py-2 text-sm text-red-600 hover:bg-gray-100"
                    >
                      Log Out
                    </Link>
                  </div>
                </div>
              </transition>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 overflow-y-auto p-4 md:p-6">
        <slot />
      </main>
    </div>
  </div>
</template>

<style scoped>
/* Smooth custom scrollbar */
.sidebar-scroll::-webkit-scrollbar {
  width: 6px;
}
.sidebar-scroll::-webkit-scrollbar-track {
  background: transparent;
}
.sidebar-scroll::-webkit-scrollbar-thumb {
  background-color: rgba(100, 116, 139, 0.4); /* gray-500/40 */
  border-radius: 9999px;
}
.sidebar-scroll:hover::-webkit-scrollbar-thumb {
  background-color: rgba(100, 116, 139, 0.6); /* darker on hover */
}

/* Firefox scrollbar */
.sidebar-scroll {
  scrollbar-width: thin;
  scrollbar-color: rgba(100, 116, 139, 0.4) transparent;
}
</style>
