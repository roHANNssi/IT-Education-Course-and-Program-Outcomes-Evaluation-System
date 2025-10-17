<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, watch, computed, onMounted } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3';
import { EyeIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
    data_enrollments: Array,
    active_schedule: Object,
})

const isWithinSchedule = (start, end) => {
  if (!start || !end) return false
  const today = new Date().toISOString().slice(0, 10) // YYYY-MM-DD
  return today >= start && today <= end
}
</script>

<template>
    <Head title="Dashboard" />

    <AuthenticatedLayout>
        <template #header>Dashboard <span class="!text-sm tracking-wider text-gray-400 italic"> / Evaluation History</span></template>

        <template v-for="enrollment in data_enrollments" :key="enrollment.id">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div
                    class="col-span-1 overflow-hidden bg-white shadow-sm sm:rounded-lg hover:shadow-md"
                >
                    <div class="p-6 text-gray-900">
                        <h2 class="font-semibold tracking-widest">{{ enrollment.sem + ' Semester, A.Y. ' + enrollment.acad_year }}</h2>
                        <p class="tracking-wider py-1">{{ enrollment.year_level.toUpperCase() + ' YEAR' }}</p>
                        <p class="py-1">No. of Enrolled Subjects: <span class="px-2 py-0 bg-gray-200 font-semibold border border-gray-300 rounded-md text-green-800">{{ enrollment.es_count }}</span></p>
                        <p class="py-1">Evaluation Status: 
                            <span v-if="enrollment.ev_count <= 0" class="text-red-500 font-bold border border-red-400 rounded-md bg-red-50 px-2 py-1 uppercase tracking-wider">Incomplete</span>
                            <span v-if="enrollment.ev_count === enrollment.es_count" class="text-green-600 font-bold border border-green-400 rounded-md bg-green-50 px-2 py-1 uppercase tracking-wider">Completed</span>
                        </p>
                        <!-- <div class="flex justify-center mt-4">
                            <button type="button" 
                            class="flex justify-center btn-outline-green"
                            @click="router.get(route('evaluation.create', {enrollment_id: enrollment.id}))"
                            v-if="enrollment.ev_count <= 0 && props.active_schedule"
                            >
                                <PencilSquareIcon class="w-6 h-6 shrink-0 mr-0"></PencilSquareIcon>
                                <span>Evaluate Now</span>
                            </button>
                            
                            <button type="button" 
                            class="flex justify-center btn-green"
                            @click="router.get(route('evaluation.show', {enrollment_id: enrollment.id}))"
                            v-if="enrollment.ev_count === enrollment.es_count"
                            >
                                <EyeIcon class="w-6 h-6 shrink-0 mr-0"></EyeIcon>
                                <span>See Response</span>
                            </button>
                        </div> -->

                        <!-- ✅ Schedule Condition Logic -->
                        <div class="mt-4 text-sm">
                        <!-- 1️⃣ If both start_date and end_date are set -->
                        <template v-if="enrollment.start_date && enrollment.end_date">
                            <!-- Check if current date is within range -->
                            <template v-if="isWithinSchedule(enrollment.start_date, enrollment.end_date)">
                            <p class="text-green-600 font-medium">
                                Evaluation is open from
                                <b>{{ enrollment.start_date }}</b> to
                                <b>{{ enrollment.end_date }}</b>.
                            </p>

                            <div class="flex justify-center mt-3">
                                <button
                                type="button"
                                class="flex justify-center btn-outline-green"
                                @click="router.get(route('evaluation.create', { enrollment_id: enrollment.id }))"
                                v-if="enrollment.ev_count <= 0"
                                >
                                <PencilSquareIcon class="w-6 h-6 shrink-0 mr-0" />
                                <span>Evaluate Now</span>
                                </button>

                                <button
                                type="button"
                                class="flex justify-center btn-green"
                                @click="router.get(route('evaluation.show', { enrollment_id: enrollment.id }))"
                                v-if="enrollment.ev_count === enrollment.es_count"
                                >
                                <EyeIcon class="w-6 h-6 shrink-0 mr-0" />
                                <span>See Response</span>
                                </button>
                            </div>
                            </template>

                            <!-- 2️⃣ If schedule exists but today is outside range -->
                            <template v-else>
                            <p class="text-gray-500 italic">
                                Evaluation period closed.<br />
                                Schedule: <b>{{ enrollment.start_date }}</b> to <b>{{ enrollment.end_date }}</b>.
                            </p>
                            </template>
                        </template>

                        <!-- 3️⃣ If no schedule was set -->
                        <template v-else>
                            <p class="text-red-500 italic">
                            No evaluation schedule set for this semester.
                            </p>
                        </template>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </AuthenticatedLayout>
</template>
