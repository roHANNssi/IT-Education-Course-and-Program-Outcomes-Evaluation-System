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
  faculty_id: [String, Number],
  semester_id: [String, Number],
  course_id: [String, Number],
  yr_level: [String, Number],
  mother_program_id: [String, Number],
  faculty_name: String,
  sem: String,
  courses: Array,
  subjects: Array,
  faculty_subjects: Array,
})

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentFS = ref(null)

const selectedFaculty = ref(props.faculty_id ?? '')
const selectedSemester = ref(props.semester_id ?? '')
const selectedCourse = ref(props.course_id ?? '')
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code} ${v.id===props.mother_program_id ? ' (Mother Program)' : ''}` }))
)

const selectedYrLvl = ref(props.yr_level ?? '')
const yearlevels = [
  { value: 'first', label: 'First Year' },
  { value: 'second', label: 'Second Year' },
  { value: 'third', label: 'Third Year' },
  { value: 'fourth', label: 'Fourth Year' },
]

watch(selectedCourse, (newCourse) => {
  if (newCourse && newCourse !== props.course_id) {
    router.get(route('faculty-members.faculty-subjects.index', { faculty_id: props.faculty_id, semester_id: props.semester_id, mother_program: newCourse, yr_level: props.yr_level }), {}, { preserveScroll: true })
  }
})

watch(selectedYrLvl, (newYrLvl) => {
  if (newYrLvl && newYrLvl !== props.yr_level) {
    router.get(route('faculty-members.faculty-subjects.index', { faculty_id: props.faculty_id, semester_id: props.semester_id, mother_program: props.course_id, yr_level: newYrLvl }), {}, { preserveScroll: true })
  }
})

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

const selectedSubject = ref('')
const subjectOptions = computed(() =>
  props.subjects.map(v => ({ value: v.id, label: `${v.subject_code} - ${v.subject_title}` }))
)

const form = useForm({
    faculty_id: props.faculty_id,
    semester_id: props.semester_id,
    subject_id: '',
    section: '',
})

const editForm = useForm({
    subject_id: '',
    section: '',
})

const openEditModal = (faculty_subject) => {
    currentFS.value = faculty_subject
    editForm.subject_id = faculty_subject.subject_id
    editForm.section = faculty_subject.section
    showEditModal.value = true

}
const submit = () => {
    form.post(route('faculty-members.faculty-subjects.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('subject_id', 'section')
            toast.success('Assigned Subject successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const update = () => {
    editForm.post(route('faculty-members.faculty-subjects.update', currentFS.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('subject_id', 'section')
            toast.success('Assigned Subject successfully updated!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
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
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-2 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Assigned Subjects: </h2>
                        <DropdownCustom
                            v-model="selectedCourse"
                            :options="courseOptions"
                            label="Select Course"
                            width="!w-60"
                        />
                        <DropdownCustom
                        v-if="props.course_id!==null"
                        v-model="selectedYrLvl"
                        :options="yearlevels"
                        label="Select Year Level"
                    />
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <button
                            @click="showCreateModal = true"
                            class="btn-outline-green mr-1"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Add New</span>
                        </button>
                        <DangerButton
                            @click="router.get(route('faculty-members.index'))"
                        >
                            Back
                        </DangerButton>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <h4>Faculty Name: <strong><u>{{ props.faculty_name.toUpperCase() }}</u></strong></h4>
                    <h4>Academic Period: <strong><u>{{ props.sem }}</u></strong></h4>
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
                        <td>{{ faculty_subject.yr_level + ' year' }}</td>
                        <td>{{ faculty_subject.section }}</td>
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(faculty_subject)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
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

    <!-- Create MODAL -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Add New Assigned Subject
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="subject_id" value="Subject" />
                        <SelectField
                            v-model="form.subject_id"
                            :options="subjectOptions"
                            placeholder="-- Select Subject --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.subject_id" />
                    </div>
                    <div>
                        <InputLabel for="section" value="Section" />
                        <TextInput
                            id="section"
                            type="text"
                            class="mt-1 block w-full uppercase"
                            v-model="form.section"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.section" />
                    </div>
                </div>

                <div class="mt-6 flex justify-end space-x-2">
                    <SecondaryButton
                        type="button"
                        @click="showCreateModal = false"
                        >
                        Cancel
                    </SecondaryButton>
                    <PrimaryButton
                        class="ms-4"
                        :class="{ 'opacity-25': form.processing }"
                        :disabled="form.processing"
                    >
                        Save
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>

    <!-- Edit MODAL -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Assigned Subject
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="subject_id" value="Subject" />
                        <SelectField
                            v-model="editForm.subject_id"
                            :options="subjectOptions"
                            placeholder="-- Select Subject --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.subject_id" />
                    </div>
                    <div>
                        <InputLabel for="section" value="Section" />
                        <TextInput
                            id="section"
                            type="text"
                            class="mt-1 block w-full uppercase"
                            v-model="editForm.section"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.section" />
                    </div>
                </div>

                <div class="mt-6 flex justify-end space-x-2">
                    <SecondaryButton
                        type="button"
                        @click="showEditModal = false"
                        >
                        Cancel
                    </SecondaryButton>
                    <PrimaryButton
                        class="ms-4"
                        :class="{ 'opacity-25': editForm.processing }"
                        :disabled="editForm.processing"
                    >
                        Save
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>