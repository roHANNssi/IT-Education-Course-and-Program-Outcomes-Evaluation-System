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
import DangerButton from '@/Components/DangerButton.vue'
import { useToast } from 'vue-toastification'

const page = usePage()
const toast = useToast();

const props = defineProps({
  curriculum_id: [String, Number],
  yr_level: [String, Number],
  curriculum: Object,
  subjects: Array,
  coursemajors: Array,
})

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentSubject = ref(null)

const selectedMajor = ref('')
const selectedYrLvl = ref(props.yr_level ?? '')
const yearlevels = [
  { value: 'first', label: 'First Year' },
  { value: 'second', label: 'Second Year' },
  { value: 'third', label: 'Third Year' },
  { value: 'fourth', label: 'Fourth Year' },
]

const getYrLevel = (yrLevel) => {
    const yrlevel = yearlevels.find(t => t.value === yrLevel)
    return yrlevel ? yrlevel.label : yrLevel
}

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

watch(selectedYrLvl, (newYrLvl) => {
  if (newYrLvl && newYrLvl !== props.yr_level) {
    router.get(route('curriculums.courses.index', { curriculum_id: props.curriculum_id, yr_level: newYrLvl }), {}, { preserveScroll: true })
  }
})

const subjectTypes = [
  { value: 'major', label: 'Major' },
  { value: 'gen-ed', label: 'General Education' },
]

const getSubjectTypeLabel = (type) => {
  const found = subjectTypes.find(t => t.value === type)
  return found ? found.label : type
}

const form = useForm({
    curriculum_id: props.curriculum_id,
    course_major_id: selectedMajor.value,
    subject_type: '',
    subject_code: '',
    subject_title: '',
    yr_level: selectedYrLvl,
})

const editForm = useForm({
    course_major_id: selectedMajor,
    subject_type: '',
    subject_code: '',
    subject_title: '',
    yr_level: selectedYrLvl,
    status: '',
})

const openEditModal = (subject) => {
    currentSubject.value = subject
    editForm.course_major_id = subject.course_major_id
    editForm.subject_type = subject.subject_type
    editForm.subject_code = subject.subject_code
    editForm.subject_title = subject.subject_title
    editForm.yr_level = subject.yr_level
    editForm.status = subject.status
    showEditModal.value = true
}

const submit = () => {
    form.post(route('curriculums.courses.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('course_major_id', 'subject_code', 'subject_title', 'yr_level')
            toast.success('Course successfully saved!', 'Success')
            router.get(
            route('curriculums.courses.index', { 
                curriculum_id: props.curriculum_id,
                yr_level: form.yr_level,
            }),
            {},
            { preserveScroll: true }
            )

        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const update = () => {
    editForm.post(route('curriculums.courses.update', currentSubject.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            currentSubject.value = null
            toast.success('Course successfully updated!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}
</script>
<template>
    <Head title="Curriculum Courses" />
    <AdminLayout>
        <template #header>Curriculum Courses</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                <!-- Title + Dropdown -->
                <div class="col-span-2 flex items-center space-x-3">
                    <h2 class="font-semibold text-lg text-gray-800">List of Courses: </h2>
                    <DropdownCustom
                        v-if="props.curriculum_id!==null"
                        v-model="selectedYrLvl"
                        :options="yearlevels"
                        label="Select Year Level"
                    />
                </div>

                <!-- Add New -->
                <div class="col-span-1 flex justify-end">
                    <button
                        v-if="props.curriculum_id" 
                        @click="showCreateModal = true"
                        class="btn-outline-green mr-1"
                    >
                        <PlusIcon class="w-4 h-4 shrink-0" />
                        <span>Add New</span>
                    </button>
                    <DangerButton
                        @click="router.get(route('curriculums.index'))"
                        class="!px-2 !py-0"
                    >
                        Back
                    </DangerButton>
                </div>
                </div>
                
                <div class="mb-2">
                    <h4>Curriculum: <b>{{ props.curriculum.curr_name }}</b> - <span class="text-sm"><i>{{ props.curriculum.curr_detail }}</i></span></h4>
                    <h4>Program: <b>{{ props.curriculum.course_name }} ({{ props.curriculum.course_code }})</b></h4>
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Major</th>
                        <th>Course Code</th>
                        <th>Course Title</th>
                        <th>Type</th>
                        <th>Year Level</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="subject in props.subjects" :key="subject.id">
                        <td>
                            <span v-if="subject.course_major!==null">{{ subject.course_major }}</span>
                            <span v-if="subject.course_major===null">n/a</span>
                        </td>
                        <td>{{ subject.subject_code }}</td>
                        <td>{{ subject.subject_title }}</td>
                        <td>{{ getSubjectTypeLabel(subject.subject_type) }}</td>
                        <td>{{ getYrLevel(subject.yr_level) }}</td>
                        <td>
                            <span v-if="subject.status==='active'" class="text-green-700">{{ subject.status }}</span>
                            <span v-else class="text-red-700">{{ subject.status }}</span>
                        </td>
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(subject)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                </button>
                                <button type="button" class="flex justify-center mr-2 btn-green"
                                    @click="router.get(route('curriculums.courses.course-outcomes.index', {subject_id: subject.id}))"
                                >
                                    <span>Course Outcomes</span>
                                    <span v-if="subject.course_outcomes.length > 0" class="px-2 bg-gray-100 rounded-md text-gray-900 lowercase"><small>{{ subject.course_outcomes.length }} version</small></span>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="subjects.length === 0">
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
                Create New Course: <u>{{ props.course_name }}</u>
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_major_id" value="Course Major (if applicable)" />
                        <SelectField
                            v-model="form.course_major_id"
                            :options="props.coursemajors"
                            placeholder="-- Select Major --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.course_major_id" />
                    </div>

                    <div>
                        <InputLabel for="yr_level" value="Year Level" />
                        <SelectField
                            v-model="form.yr_level"
                            :options="yearlevels"
                            placeholder="-- Please select year level --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.yr_level" />
                    </div>

                    <div>
                        <InputLabel for="subject_type" value="Type" />
                        <SelectField
                            v-model="form.subject_type"
                            :options="subjectTypes"
                            placeholder="-- Please select type --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.subject_type" />
                    </div>

                    <div>
                        <InputLabel for="subject_code" value="Course Code" />
                        <TextInput
                            id="subject_code"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.subject_code"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.subject_code" />
                    </div>

                    <div>
                        <InputLabel for="subject_title" value="Course Title" />
                        <TextInput
                            id="subject_title"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.subject_title"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.subject_title" />
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
                Edit Course Details
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_major_id" value="Course Major (if applicable)" />
                        <SelectField
                            v-model="editForm.course_major_id"
                            :options="props.coursemajors"
                            placeholder="-- Select Major --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_major_id" />
                    </div>

                    <div>
                        <InputLabel for="yr_level" value="Year Level" />
                        <SelectField
                            v-model="editForm.yr_level"
                            :options="yearlevels"
                            placeholder="-- Please select year level --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.yr_level" />
                    </div>

                    <div>
                        <InputLabel for="subject_type" value="Type" />
                        <SelectField
                            v-model="editForm.subject_type"
                            :options="subjectTypes"
                            placeholder="-- Please select type --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.subject_type" />
                    </div>

                    <div>
                        <InputLabel for="subject_code" value="Course Code" />
                        <TextInput
                            id="subject_code"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="editForm.subject_code"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.subject_code" />
                    </div>

                    <div>
                        <InputLabel for="subject_title" value="Course Title" />
                        <TextInput
                            id="subject_title"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="editForm.subject_title"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.subject_title" />
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