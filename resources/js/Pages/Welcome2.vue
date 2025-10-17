<script setup>
import { Head, Link } from '@inertiajs/vue3'

defineProps({
  canLogin: { type: Boolean },
  canRegister: { type: Boolean },
})

// Set your assets here (or move to props if you prefer)
const leftLogo  = '/images/logo/marsu_logo.png'   // <- replace
const rightLogo = '/images/logo/cics_logo.png'  // <- replace
const heroImage = '/images/marsu-bg.jpg'     // <- replace (any wide campus/bg photo)
</script>

<template>
  <Head title="Welcome" />

  <div class="min-h-screen bg-gray-50 text-gray-900 dark:bg-white dark:text-black/90">

    <!-- Header with logos + university name -->
    <header class="relative z-20 pt-5 sm:pt-5 pb-5 sm:pb-5">
      <div class="mx-auto max-w-6xl px-6">
        <div class="flex items-center justify-center gap-5 sm:gap-8">
          <img :src="leftLogo" alt="Left Logo" class="h-12 w-12 sm:h-14 sm:w-14 object-contain" />
          <div class="text-center">
            <h1 class="text-base sm:text-lg font-semibold tracking-wide uppercase text-red-800">
              MARINDUQUE STATE UNIVERSITY
            </h1>
            <p class="text-xs sm:text-sm opacity-80">
              College of Information and Computing Sciences
            </p>
          </div>
          <img :src="rightLogo" alt="Right Logo" class="h-12 w-12 sm:h-14 sm:w-14 object-contain" />
        </div>

        <p class="mt-4 text-center text-xl sm:text-xl font-bold text-green-500 dark:text-green-500">
          IT Education Course and Program Outcomes Evaluation System
        </p>
      </div>
    </header>

    <!-- HERO section -->
    <section class="relative mt-4">
    <!-- Background image -->
    <img
        :src="heroImage"
        alt="Campus background"
        class="absolute inset-0 h-[520px] w-full object-cover"
    />
    <!-- Green gradient overlay -->
    <div class="absolute inset-0 h-[520px] w-full bg-gradient-to-r from-green-800/85 via-green-600/80 to-green-500/75"></div>

    <!-- Content -->
    <div class="relative z-10">
        <div class="mx-auto flex h-[520px] max-w-6xl items-center px-6">
        <div class="mx-auto text-center text-white">
            <h2 class="text-2xl sm:text-3xl md:text-4xl font-extrabold">
            Welcome to Our Evaluation System
            </h2>
            <p class="mx-auto mt-4 max-w-3xl text-sm sm:text-base text-emerald-50/90">
            A comprehensive platform designed to assess and enhance course and program
            outcomes for Information Technology and Information Systems Programs.
            </p>

            <!-- ✅ Auth buttons inside Hero -->
            <div class="mt-8 flex items-center justify-center gap-3">
            <Link
                v-if="$page.props.auth.user"
                :href="route('dashboard')"
                class="rounded-md bg-white/95 px-5 py-2 text-sm font-semibold text-emerald-700 shadow hover:bg-white"
            >
                Dashboard
            </Link>

            <template v-else>
                <Link
                :href="route('login')"
                class="rounded-md bg-white/95 px-5 py-2 text-sm font-semibold text-emerald-700 shadow hover:bg-white"
                >
                Log in
                </Link>
                <Link
                v-if="canRegister"
                :href="route('register')"
                class="rounded-md border border-white/80 px-5 py-2 text-sm font-semibold text-white hover:bg-white/10"
                >
                Register
                </Link>
            </template>
            </div>
        </div>
        </div>
    </div>
    </section>

    <!-- (Optional) Content below hero -->
    <main id="learn-more" class="mx-auto max-w-6xl px-6 py-12">
      <!-- Put anything you like here or leave empty -->
    </main>

    <footer class="py-10 text-center text-sm text-gray-600 dark:text-gray-600/70">
      <p>© 2025 Marinduque State University. All rights reserved.</p>
      <p>IT Education Course and Program Outcomes Evaluation System v1.0</p>
    </footer>
  </div>
</template>
