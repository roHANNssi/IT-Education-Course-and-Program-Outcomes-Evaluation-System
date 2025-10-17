<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { ClipboardDocumentListIcon, ListBulletIcon, PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Modal2 from '@/Components/Modal2.vue'
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification'

const toast = useToast();
const page = usePage()

const props = defineProps({
    courses: Array,
})

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentCourse = ref(null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
})

const form = useForm({
    course_name: '',
    course_code: '',
})

const editForm = useForm({
    course_name: '',
    course_code: '',
})

const openEditModal = (course) => {
  currentCourse.value = course
  editForm.course_name = course.course_name
  editForm.course_code = course.course_code
  showEditModal.value = true
}

const submit = () => {
    form.post(route('courses.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('course_name', 'course_code')
            toast.success('Course successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const submitEdit = () => {
    editForm.post(route('courses.update', currentCourse.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('course_name', 'course_code')
            toast.success('Course successfully updated!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

</script>
<!-- This page is for Courses labeled as Programs -->
<template>
    <Head title="Programs" />
    <AdminLayout>
        <template #header>Programs</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                <!-- Title + Dropdown -->
                <div class="col-span-1 flex items-center space-x-3">
                    <h2 class="font-semibold text-lg text-gray-800">List of Programs</h2>
                </div>

                <!-- Add New -->
                <div class="col-span-1 flex justify-end">
                    <button
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
                        <th>Program Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="course in props.courses" :key="course.id">
                        <td>{{ course.course_name }} ({{ course.course_code }})</td>
                        <td>
                            <span v-if="course.status==='active'" class="text-green-700">{{ course.status }}</span>
                            <span v-else class="text-red-700">{{ course.status }}</span>
                        </td>
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(course)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                </button>
                                <button type="button" class="flex justify-center mr-2 btn-green"
                                    @click="router.get(route('course-majors.index', course.id))"
                                >
                                    <ClipboardDocumentListIcon class="w-4 h-4 shrink-0"/>
                                    <span>Majors</span>
                                </button>
                                <!-- <button type="button" class="flex justify-center btn-outline-green"
                                    @click="router.get(route('subjects.index', {course_id: course.id}))"
                                >
                                    <ListBulletIcon class="w-4 h-4 shrink-0"/>
                                    <span>Subjects</span>
                                </button> -->
                            </div>
                        </td>
                    </tr>
                    <tr v-if="courses.length === 0">
                        <td colspan="3">
                            <span class="flex justify-center text-red-500">No record found.</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </AdminLayout>

    <!-- Create modal -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Create New Program
                </h2>

                <div class="space-y-4">
                <div>
                    <InputLabel for="course_name" value="Program Name" />
                    <TextInput
                        id="course_name"
                        type="text"
                        class="mt-1 block w-full"
                        v-model="form.course_name"
                        required
                        autofocus
                    />
                    <InputError class="mt-2" :message="form.errors.course_name" />
                </div>

                <div>
                    <InputLabel for="course_code" value="Program Code" />
                    <TextInput
                        id="course_code"
                        type="text"
                        class="mt-1 block w-full"
                        v-model="form.course_code"
                        required
                        placeholder="e.g. BSIS"
                    />
                    <InputError class="mt-2" :message="form.errors.course_code" />
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

    <!-- Edit modal -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="submitEdit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Program
                </h2>

                <div class="space-y-4">
                <div>
                    <InputLabel for="course_name" value="Program Name" />
                    <TextInput
                        id="course_name"
                        type="text"
                        class="mt-1 block w-full"
                        v-model="editForm.course_name"
                        required
                        autofocus
                    />
                    <InputError class="mt-2" :message="editForm.errors.course_name" />
                </div>

                <div>
                    <InputLabel for="course_code" value="Program Code" />
                    <TextInput
                        id="course_code"
                        type="text"
                        class="mt-1 block w-full"
                        v-model="editForm.course_code"
                        required
                        placeholder="e.g. BSIS"
                    />
                    <InputError class="mt-2" :message="editForm.errors.course_code" />
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
                        Update
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>