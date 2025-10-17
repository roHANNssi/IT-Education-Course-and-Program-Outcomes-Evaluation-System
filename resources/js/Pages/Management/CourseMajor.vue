<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { ListBulletIcon, PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue'
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import SelectField from '@/Components/SelectField.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification'

const toast = useToast();

const props = defineProps({
  course_id: [String, Number],
  courses: Array,
  course_name: String,
  course_majors: Array,
})

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentMajor = ref(null)
const page = usePage()

const selectedYrLvl = ref('')
const selectedYrLvlEdit = ref('')
const yearlevels = [
  { value: 'first', label: 'First Year' },
  { value: 'second', label: 'Second Year' },
  { value: 'third', label: 'Third Year' },
  { value: 'fourth', label: 'Fourth Year' },
]

// normalize versions
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code}` }))
)

// track backend-provided version
const selectedCourse = ref(props.course_id ?? '')

// navigate when version changes
watch(selectedCourse, (newCourse) => {
  if (newCourse && newCourse !== props.course_id) {
    router.get(route('course-majors.index', { get_course_id: newCourse }), {}, { preserveScroll: true })
  }
})

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

const form = useForm({
    course_id: props.course_id,
    course_major: '',
    year_level: selectedYrLvl,
})

const editForm = useForm({
    course_major: '',
    year_level: selectedYrLvlEdit,
    status: '',
})

// open edit modal and fill form
const openEditModal = (course_major) => {
  currentMajor.value = course_major
  editForm.course_major = course_major.course_major
  editForm.year_level = course_major.year_level
  editForm.status = course_major.status
  showEditModal.value = true
}

const submit = () => {
    form.post(route('course-majors.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('course_major', 'year_level')
            toast.success('Major successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

// submit update
const update = () => {
    editForm.post(route('course-majors.update', currentMajor.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            currentMajor.value = null
            toast.success('Major successfully updated!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}
</script>
<template>
    <Head title="Course Majors" />
    <AdminLayout>
        <template #header>Course Majors</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                <!-- Title + Dropdown -->
                <div class="col-span-1 flex items-center space-x-3">
                    <h2 class="font-semibold text-lg text-gray-800">List of Course Majors for: </h2>
                    <DropdownCustom
                        v-model="selectedCourse"
                        :options="courseOptions"
                        label="Select Course"
                    />
                </div>

                <!-- Add New -->
                <div class="col-span-1 flex justify-end">
                    <button
                        v-if="props.course_id" 
                        @click="showCreateModal = true"
                        class="btn-outline-green"
                    >
                        <PlusIcon class="w-4 h-4 shrink-0" />
                        <span>Add New</span>
                    </button>
                </div>
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Major</th>
                        <th>Year Level</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="course_major in props.course_majors" :key="course_major.id">
                        <td>{{ course_major.course_major }}</td>
                        <td>{{ course_major.year_level + ' year' }}</td>
                        <td>
                            <span v-if="course_major.status==='active'" class="text-green-700">{{ course_major.status }}</span>
                            <span v-else class="text-red-700">{{ course_major.status }}</span>
                        </td>
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(course_major)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="course_majors.length === 0">
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
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Create New Course Major for <u>{{ props.course_name }}</u>
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_major" value="Course Major Name" />
                        <TextInput
                            id="course_major"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.course_major"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.course_major" />
                    </div>

                    <div>
                        <InputLabel for="year_level" value="Year Level" />
                        <SelectField
                            v-model="form.year_level"
                            :options="yearlevels"
                            placeholder="-- Please select year level --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.year_level" />
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
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Course Major for <u>{{ props.course_name }}</u>
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_major" value="Course Major Name" />
                        <TextInput
                            id="course_major"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="editForm.course_major"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_major" />
                    </div>

                    <div>
                        <InputLabel for="year_level" value="Year Level" />
                        <SelectField
                            v-model="editForm.year_level"
                            :options="yearlevels"
                            placeholder="-- Please select year level --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.year_level" />
                    </div>
                </div>

                <div class="mt-4">
                    <InputLabel value="Status" />
                    <div class="flex items-center mt-2 space-x-4">
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="active" v-model="editForm.status" /> <span>Active</span>
                        </label>
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="inactive" v-model="editForm.status" /> <span>Inactive</span>
                        </label>
                    </div>
                    <InputError class="mt-2" :message="editForm.errors.status" />
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
                        Update
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>