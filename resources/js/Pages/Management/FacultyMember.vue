<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { PlusCircleIcon, PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import SelectField from '@/Components/SelectField.vue';
import SelectField2 from '@/Components/SelectField2.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
    semester_id: [String, Number],
    course_id: [String, Number],
    faculties: Array,
    semesters: Array,
    users: Array,
})

const selectedSemester = ref(props.semester_id)
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

watch(selectedSemester, (newSem) => {
    if (newSem && newSem !== props.semester_id) {
        router.get(route('faculty-members.index', { sem_id: newSem }), {}, { preserveScroll: true })
    }
})

const genders = [
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' },
]

// normalize users
const selectedUser = ref([])
const userOptions = computed(() =>
  props.users.map(v => ({ value: v.id, label: `${v.last_name.toUpperCase() + ', ' + v.first_name.toUpperCase() + ', ' + v.mid_name.toUpperCase()} ${v.name_ext!==null ? ' '+ v.name_ext.toUpperCase() : '' }` }))
)

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentFaculty = ref(null)
const showCreateModal2 = ref(false)

const form = useForm({
    role: 'faculty',
    last_name: '',
    first_name: '',
    mid_name: '',
    name_ext: '',
    gender: '',
    email: '',
    designation: 'faculty',
    course_id: props.course_id ?? null,
    semester_id: props.semester_id,
})

const editForm = useForm({
    role: 'faculty',
    last_name: '',
    first_name: '',
    mid_name: '',
    name_ext: '',
    gender: '',
    email: '',
    designation: 'faculty',
    course_id: props.course_id ?? null,
    semester_id: props.semester_id,
})

const form2 = useForm({
    designation: 'faculty',
    course_id: props.course_id ?? null,
    semester_id: props.semester_id,
    user_ids: selectedUser.value,
})

// open edit modal and fill form
const openEditModal = (faculty) => {
    currentFaculty.value = faculty
    editForm.last_name = faculty.last_name
    editForm.first_name = faculty.first_name
    editForm.mid_name = faculty.mid_name
    editForm.name_ext = faculty.name_ext
    editForm.gender = faculty.gender
    editForm.email = faculty.email
    showEditModal.value = true
}

const submit = () => {
    form.post(route('users.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('last_name', 'first_name', 'mid_name', 'name_ext', 'gender', 'email')
            toast.success('Faculty successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const update = () => {
    editForm.post(route('users.update', currentFaculty.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('last_name', 'first_name', 'mid_name', 'name_ext', 'gender', 'email')
            toast.success('Faculty successfully updated!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const submit2 = () => {
    form2.user_ids = selectedUser.value
    form2.post(route('faculty-members.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal2.value = false
            selectedUser.value = []
            toast.success('Faculty member(s) successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}
</script>
<template>
    <Head title="Faculty Members" />

    <AdminLayout>
        <template #header>Faculty Members</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-2 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Faculty Members</h2>
                        <DropdownCustom
                            v-model="selectedSemester"
                            :options="semesterOptions"
                            label="Select Semester"
                            width="max-w-md"
                        />
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <button
                            @click="showCreateModal = true"
                            class="btn-outline-green mr-2"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Add New</span>
                        </button>
                        <button
                            @click="showCreateModal2 = true"
                            class="btn-green"
                        >
                            <PlusCircleIcon class="w-4 h-4 shrink-0" />
                            <span>Add from Existing User</span>
                        </button>
                    </div>
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Gender</th>
                            <th>Email</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="faculty in props.faculties" :key="faculty.id">
                            <td>
                                {{ faculty.last_name.toUpperCase() + ', ' + faculty.first_name.toUpperCase() + ' ' + faculty.mid_name.toUpperCase() }}
                                <span v-if="faculty.name_ext">{{ faculty.name_ext.toUpperCase() }}</span>
                            </td>
                            <td>{{ faculty.gender.charAt(0).toUpperCase() + faculty.gender.slice(1) }}</td>
                            <td>{{ faculty.email }}</td>
                            <td>
                                <div class="flex">
                                    <button 
                                        v-if="faculty.user_id!==page.props?.auth.user?.id"
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="EDIT"
                                        @click="openEditModal(faculty)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                    <button type="button" class="flex justify-center mr-2 btn-green"
                                        @click="router.get(route('faculty-members.faculty-subjects.index', {faculty_id: faculty.id, semester_id: props.semester_id}))"
                                    >
                                        <span>Faculty Subjects</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="faculties.length === 0">
                            <td colspan="4">
                                <span class="flex justify-center text-red-500">No record found.</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>

    <!-- Modal add to current version -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Add New Faculty Member
                </h2>

                <div class="space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="last_name" value="LAST NAME" />
                            <TextInput
                                id="last_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="form.last_name"
                                required
                                autofocus
                                placeholder="enter last name here"
                            />
                            <InputError class="mt-2" :message="form.errors.last_name" />
                        </div>

                        <div>
                            <InputLabel for="first_name" value="First Name" />
                            <TextInput
                                id="first_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="form.first_name"
                                required
                                placeholder="enter first name here"
                            />
                            <InputError class="mt-2" :message="form.errors.first_name" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="mid_name" value="Middle Name" />
                            <TextInput
                                id="mid_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="form.mid_name"
                                required
                                placeholder="enter middle name here"
                            />
                            <InputError class="mt-2" :message="form.errors.mid_name" />
                        </div>

                        <div class="col-span-1">
                            <InputLabel for="name_ext" value="Name Extension (if applicable)" />
                            <TextInput
                                id="name_ext"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="form.name_ext"
                                placeholder="e.g. Jr, Sr, II"
                            />
                            <InputError class="mt-2" :message="form.errors.name_ext" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="gender" value="Gender" />
                            <SelectField
                                v-model="form.gender"
                                :options="genders"
                                placeholder="-Select gender-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="form.errors.gender" />
                        </div>

                        <div class="col-span-2">
                            <InputLabel for="email" value="Email address" />
                            <TextInput
                                id="email"
                                type="email"
                                class="mt-1 block w-full"
                                v-model="form.email"
                                placeholder="e.g. juandelacruz@gmail.com"
                                required
                            />
                            <InputError class="mt-2" :message="form.errors.email" />
                        </div>
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

    <!-- Modal Edit User -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Edit Faculty Member Details
                </h2>

                <div class="space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="last_name" value="LAST NAME" />
                            <TextInput
                                id="last_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="editForm.last_name"
                                required
                                autofocus
                                placeholder="enter last name here"
                            />
                            <InputError class="mt-2" :message="editForm.errors.last_name" />
                        </div>

                        <div>
                            <InputLabel for="first_name" value="First Name" />
                            <TextInput
                                id="first_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="editForm.first_name"
                                required
                                placeholder="enter first name here"
                            />
                            <InputError class="mt-2" :message="editForm.errors.first_name" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="mid_name" value="Middle Name" />
                            <TextInput
                                id="mid_name"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="editForm.mid_name"
                                required
                                placeholder="enter middle name here"
                            />
                            <InputError class="mt-2" :message="editForm.errors.mid_name" />
                        </div>

                        <div class="col-span-1">
                            <InputLabel for="name_ext" value="Name Extension (if applicable)" />
                            <TextInput
                                id="name_ext"
                                type="text"
                                class="mt-1 block w-full"
                                v-model="editForm.name_ext"
                                placeholder="e.g. Jr, Sr, II"
                            />
                            <InputError class="mt-2" :message="editForm.errors.name_ext" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                        <div class="col-span-1">
                            <InputLabel for="gender" value="Gender" />
                            <SelectField
                                v-model="editForm.gender"
                                :options="genders"
                                placeholder="-Select gender-"
                                class="mt-1 block w-full"
                            />
                            <InputError class="mt-2" :message="editForm.errors.gender" />
                        </div>

                        <div class="col-span-2">
                            <InputLabel for="email" value="Email address" />
                            <TextInput
                                id="email"
                                type="email"
                                class="mt-1 block w-full"
                                v-model="editForm.email"
                                placeholder="e.g. juandelacruz@gmail.com"
                                required
                            />
                            <InputError class="mt-2" :message="editForm.errors.email" />
                        </div>
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

    <!-- Add faculties from existing users -->
    <Modal2 :show="showCreateModal2" @close="showCreateModal2 = false">
        <form @submit.prevent="submit2">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Add New Faculty Member from existing users
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="user_ids" value="Select from existing users" />
                        <SelectField2
                            v-model="selectedUser"
                            :options="userOptions"
                            placeholder="-Select User-"
                            width="w-full"
                            multiple
                        />
                        <InputError class="mt-2" :message="form2.errors.user_ids" />
                    </div>
                </div>

                <div class="mt-6 flex justify-end space-x-2">
                    <SecondaryButton
                        type="button"
                        @click="showCreateModal2 = false"
                        >
                        Cancel
                    </SecondaryButton>
                    <PrimaryButton
                        class="ms-4"
                        :class="{ 'opacity-25': form2.processing }"
                        :disabled="form2.processing"
                    >
                        Save
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>