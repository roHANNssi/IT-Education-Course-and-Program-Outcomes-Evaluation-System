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
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
  faculty_id: [String, Number],
  semester_id: [String, Number],
  course_id: [String, Number],
  mother_program_id: [String, Number],
  sem: String,
  semesters: Array,
  courses: Array,
  faculty_subjects: Array,
})

const selectedCourse = ref(props.course_id ?? '')
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code} ${v.id===props.mother_program_id ? ' (Mother Program)' : ''}` }))
)

watch(selectedCourse, (newCourse) => {
  if (newCourse && newCourse !== props.course_id) {
    router.get(route('assignedsubjects.assignedSubjects', { get_sem_id: props.semester_id, get_course_id: newCourse }), {}, { preserveScroll: true })
  }
})

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Active Sem)' : ''}` }))
)

watch(selectedSemester, (newSem) => {
  if (newSem && newSem !== props.semester_id) {
    router.get(route('assignedsubjects.assignedSubjects', { get_sem_id: newSem, get_course_id: props.course_id }), {}, { preserveScroll: true })
  }
})

const capitalize = (word) => {
    if (!word) return '';
    return word.charAt(0).toUpperCase() + word.slice(1);
}
</script>
<template>
    <Head title="Assigned Subjects" />

    <AdminLayout>
        <template #header>Assigned Subjects</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-2 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Assigned Subjects: </h2>
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                    <DropdownCustom
                        v-model="selectedSemester"
                        :options="semesterOptions"
                        label="Select Semester"
                        width="!w-full"
                    />
                    <DropdownCustom
                        v-model="selectedCourse"
                        :options="courseOptions"
                        label="Select Course"
                        width="!w-full"
                    />
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Major</th>
                        <th>Subject Title</th>
                        <th>Subject Code</th>
                        <th>Year Level</th>
                        <th>Section</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="faculty_subject in props.faculty_subjects" :key="faculty_subject.id">
                        <td>
                            <span v-if="faculty_subject.course_major!==null">{{ faculty_subject.course_major }}</span>
                            <span v-if="faculty_subject.course_major===null">n/a</span>
                        </td>
                        <td>{{ faculty_subject.subject_title }}</td>
                        <td>{{ faculty_subject.subject_code }}</td>
                        <td>{{ capitalize(faculty_subject.yr_level) + ' Year' }}</td>
                        <td>{{ faculty_subject.section }}</td>
                        <td>
                            <div class="flex">
                                <button type="button" class="flex justify-center mr-2 btn-green"
                                    @click="router.get(route('assignedsubjects.course-outcomes.index', { subject_id: faculty_subject.subject_id }))"
                                >
                                    <span>Course Outcomes</span>
                                </button>

                                <button type="button" class="flex justify-center mr-2 btn-outline-green"
                                    @click="router.get(route('assignedsubjects.students.index', { faculty_subject_id: faculty_subject.id }))"
                                >
                                    <span>Students</span>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="faculty_subjects.length === 0">
                        <td colspan="6">
                            <span class="flex justify-center text-red-500">No record found.</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>