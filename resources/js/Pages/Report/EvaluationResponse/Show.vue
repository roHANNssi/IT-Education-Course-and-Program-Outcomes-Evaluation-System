<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import SelectField from '@/Components/SelectField.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import DangerButton from '@/Components/DangerButton.vue';
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
  curriculum_id: [Number, String],
  semester_id: [Number, String],
  yr_level: [Number, String],
  semesters: Array,
  curriculum: Object,
  subjects: Array,
  scales: Array,
})

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

const selectedYrLvl = ref(props.yr_level ?? '')
const yearlevels = [
  { value: 'first', label: 'First Year' },
  { value: 'second', label: 'Second Year' },
  { value: 'third', label: 'Third Year' },
  { value: 'fourth', label: 'Fourth Year' },
]

watch(selectedSemester, (newSemester) => {
  if (newSemester && newSemester !== props.semester_id) {
    router.get(route('reports.evaluation-response.show', { curriculum_id: props.curriculum_id, semester_id: newSemester, yr_level: props.yr_level }), {}, { preserveScroll: true })
  }
})

watch(selectedYrLvl, (newYrLvl) => {
  if (newYrLvl && newYrLvl !== props.yr_level) {
    router.get(route('reports.evaluation-response.show', { curriculum_id: props.curriculum_id, semester_id: props.semester_id, yr_level: newYrLvl }), {}, { preserveScroll: true })
  }
})
</script>
<template>
    <Head title="Reports - Evaluation Response Details" />

    <AdminLayout>
        <template #header>Reports - Evaluation Response Details</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">Evaluation Response Details</h2>
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <DangerButton
                            @click="router.get(route('reports.evaluation-response.index'))"
                            class="!px-2 !py-0"
                        >
                            Back
                        </DangerButton>
                    </div>

                    <div class="col-span-2">
                        <h4>Program: <b>{{ props.curriculum.course_name }} ({{ props.curriculum.course_code }})</b></h4>
                        <h4>Curriculum: <b>{{ props.curriculum.curr_name }}</b> - <span class="text-sm"><i>{{ props.curriculum.curr_detail }}</i></span></h4>
                    </div>

                    <div class="col-span-2 flex items-center space-x-3">
                        <DropdownCustom
                            v-model="selectedSemester"
                            :options="semesterOptions"
                            label="Select Semester"
                            width="!w-full"
                        />
                        <DropdownCustom
                            v-model="selectedYrLvl"
                            :options="yearlevels"
                            label="Select Year Level"
                        />
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Course Title</th>
                            <th class="w-[250px]">No. of Enrolled Students</th>
                            <th class="w-[200px]">Evaluation Response</th>
                            <!-- <th>Actions</th> -->
                        </tr>
                        </thead>
                        <tbody>
                            <tr v-if="props.semester_id!==null" v-for="subject in props.subjects" :key="subject.id">
                                <td>{{ subject.subject_title }}</td>
                                <td>
                                    {{subject.faculty_subjects.length}}
                                </td>
                                <td>
                                    {{subject.evaluations.length}}
                                </td>
                                <!-- <td> -->
                                    <!-- <button 
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="UPDATE"
                                        @click="openCreateModal(subject)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button> -->
                                <!-- </td> -->
                            </tr>
                            <tr v-if="props.semester_id===null">
                                <td colspan="3">
                                    <p class="text-gray-500 text-center">Please select semester to show data</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>