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
  user: Object,
  faculties: Array,
  user_id: [String, Number],
  faculty_name: String,
  semesters: Array,
  courses: Array,
})

const selectedSemester = ref('')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year}` }))
)

const selectedCourse = ref('')
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code}` }))
)

const selectedDesignation = ref('faculty')
const designations = [
  { value: 'dean', label: 'Dean' },
  { value: 'faculty', label: 'Faculty' },
  { value: 'program-head', label: 'Program Head' },
]

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentFD = ref(null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

// form state
const form = useForm({
    user_id: props.user_id,
    semester_id: selectedSemester,
    designation: selectedDesignation,
    course_id: selectedCourse ?? null,
})

const editForm = useForm({
    semester_id: '',
    designation: '',
    course_id: selectedCourse ?? null,
})

const openEditModal = (faculty) => {
  currentFD.value = faculty
  editForm.semester_id = faculty.semester_id
  editForm.designation = faculty.designation
  editForm.course_id = faculty.course_id
  showEditModal.value = true
}

const submit = () => {
    form.post(route('users.faculties.storeDesignation'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('semester_id', 'designation', 'course_id')
            toast.success('Designation successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

watch(() => form.designation, (newVal) => {
  if (newVal !== 'program-head') {
    form.course_id = '' // reset if not program-head
  }
})

const update = () => {
    editForm.post(route('users.faculties.updateDesignation', currentFD.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('semester_id', 'designation', 'course_id')
            toast.success('Designation successfully updated!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}
</script>
<template>
    <Head title="Faculty Designation Logs" />

    <AdminLayout>
        <template #header>Faculty Designation</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Faculty Designation Logs</h2>
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
                            @click="router.get(route('users.index', { role: 'faculty' }))"
                            class="!px-2 !py-1"
                        >
                            <span>Back</span>
                        </DangerButton>
                    </div>
                </div>

                <div class="mb-2">
                    <h4>Name: <strong><u>{{ props.faculty_name.toLocaleUpperCase() }}</u></strong></h4>
                </div>
                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Semester</th>
                            <th>Designation</th>
                            <th>Course</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="faculty in props.faculties" :key="faculty.id">
                            <td>{{ faculty.sem + ' Semester, A.Y. ' + faculty.acad_year }}</td>
                            <td>{{ faculty.designation.charAt(0).toUpperCase() + faculty.designation.slice(1) }}</td>
                            <td>{{ faculty.course_name ?? 'n/a' }}</td>
                            <td>
                                <span v-if="faculty.status==='active'" class="text-green-700">{{ faculty.status }}</span>
                                <span v-else class="text-red-700">{{ faculty.status }}</span>
                            </td>
                            <td>
                                <div class="flex">
                                    <button 
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="EDIT"
                                        @click="openEditModal(faculty)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="faculties.length === 0">
                            <td colspan="5">
                                <span class="flex justify-center text-red-500">No record found.</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>

    <!-- Modal add designation -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Add new designation
                </h2>

                <div class="space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                        <div class="col-span-2">
                            <InputLabel for="semester_id" value="Semester" />
                            <SelectField
                                v-model="form.semester_id"
                                :options="semesterOptions"
                                placeholder="-Select Semester-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="form.errors.semester_id" />
                        </div>
                        <div class="col-span-1">
                            <InputLabel for="designation" value="Designation" />
                            <SelectField
                                v-model="form.designation"
                                :options="designations"
                                placeholder="-Select Designation-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="form.errors.designation" />
                        </div>
                    </div>
                    <div v-if="form.designation === 'program-head' || form.designation === 'faculty'">
                        <InputLabel for="course_id" value="Course (Mother Program)" />
                        <SelectField
                            v-model="form.course_id"
                            :options="courseOptions"
                            placeholder="-Select Course (Program)-"
                            class="mt-1 block w-full"
                            :required="form.designation === 'program-head' || form.designation === 'faculty'"
                        />
                        <InputError class="mt-2" :message="form.errors.course_id" />
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

    <!-- Modal edit designation -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Add new designation
                </h2>

                <div class="space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                        <div class="col-span-2">
                            <InputLabel for="semester_id" value="Semester" />
                            <SelectField
                                v-model="editForm.semester_id"
                                :options="semesterOptions"
                                placeholder="-Select Semester-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="editForm.errors.semester_id" />
                        </div>
                        <div class="col-span-1">
                            <InputLabel for="designation" value="Designation" />
                            <SelectField
                                v-model="editForm.designation"
                                :options="designations"
                                placeholder="-Select Designation-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="form.errors.designation" />
                        </div>
                    </div>
                    <div v-if="editForm.designation === 'program-head' || editForm.designation === 'faculty'">
                        <InputLabel for="course_id" value="Course (Mother Program)" />
                        <SelectField
                            v-model="editForm.course_id"
                            :options="courseOptions"
                            placeholder="-Select Course (Program)-"
                            class="mt-1 block w-full"
                            :required="editForm.designation === 'program-head' || editForm.designation === 'faculty'"
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_id" />
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
                        Save Changes
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>