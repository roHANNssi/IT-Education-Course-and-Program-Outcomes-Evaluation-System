<script setup>
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <div
        class="relative flex min-h-screen flex-col items-center bg-gray-100 pt-6 sm:justify-center sm:pt-0 pb-5"
    >
        <!-- Background image -->
        <img
            src="/images/marsu-bg.jpg"
            alt="Background"
            class="absolute inset-0 h-full w-full object-cover"
        />

        <!-- Gradient overlay -->
        <div class="absolute inset-0 bg-gradient-to-br from-green-700 via-green-600 to-green-500 opacity-80"></div>

        <!-- Content (unchanged sizing) -->
        <div class="relative z-10 flex flex-col items-center w-full sm:max-w-md">
            <div>
                <Link href="/">
                    <ApplicationLogo class="h-20 w-20 fill-current text-gray-500" />
                </Link>
            </div>
            <p class="mt-2 text-center text-sm sm:text-base font-bold text-white dark:text-white">
                IT Education Course and Program Outcomes Evaluation System
                </p>
            <div
                class="mt-4 w-full overflow-hidden bg-white px-6 py-4 shadow-md sm:max-w-md sm:rounded-lg"
            >
                <slot />
            </div>
        </div>
    </div>
</template>
