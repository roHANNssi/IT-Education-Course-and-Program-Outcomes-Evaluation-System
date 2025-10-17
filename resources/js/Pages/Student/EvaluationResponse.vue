<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, watch, computed, onMounted } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3';
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { ChevronLeftIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
    enrollment_id: [String, Number],
    enrollment: Object,
    enrolled_subjects: Array,
})
</script>
<template>
    <Head title="Evaluation Response" />

    <AuthenticatedLayout>
        <template #header>
            Evaluation Response >
            <i class="text-green-700">
                {{ props.enrollment.sem + ' Semester, A.Y. ' + props.enrollment.acad_year }}
                - {{ props.enrollment.year_level.toUpperCase() + ' YEAR' }}
            </i>
        </template>

        <div class="col-span-1 overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <div class="col-span-2">
                        <h3 class="font-semibold text-xl mb-2 uppercase">Subjects:</h3>
                    </div>
                    <div class="col-span-1 flex justify-end">
                        <SecondaryButton
                        type="button"
                        @click="router.get(route('dashboard'))"
                        >
                        <ChevronLeftIcon class="w-4 h-4 shrink-0 mr-0" />
                        Back
                        </SecondaryButton>
                    </div>
                </div>

                <template v-for="subject in props.enrolled_subjects" :key="subject.id">
                    <div class="p-4 border shadow-md sm:rounded-md bg-green-50">
                        <p class="font-semibold text-lg italic">
                            {{ subject.subject_title }} ({{ subject.subject_code }})
                            <span v-if="subject.course_major !== null">
                                | Major: {{ subject.course_major }}
                            </span>
                        </p>

                        <!-- Course Outcomes -->
                        <template
                            v-if="subject.evaluations.length > 0"
                            v-for="evaluation in subject.evaluations"
                            :key="evaluation.id"
                        >
                            <div class="ml-6 mb-2 pb-2 border-b">
                                <p>
                                    <b>PO Links:</b>
                                    <span v-if="evaluation.outcome_links.length > 0">
                                        &nbsp;{{ evaluation.outcome_links.map(link => link.po_code).join(', ') }}
                                    </span>
                                </p>
                                <p>
                                    <b>Course Outcome {{ evaluation.order_no }}:</b>
                                    {{ evaluation.course_outcome }}
                                </p>
                                <p><b>Rating:</b> <span class="px-2 py-0 bg-gray-200 border border-gray-300 rounded-md text-red-600 text-md font-semibold">{{ evaluation.rating }}</span></p>
                            </div>
                        </template>

                        <p v-if="subject.evaluation_comment!=null" class="ml-6"><b>Comment:</b> {{ subject.evaluation_comment.comment }}</p>
                    </div>
                </template>
            </div>
        </div>
    </AuthenticatedLayout>
</template>