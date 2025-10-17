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
  role: String,
  users: Array,
  sem_id: [String, Number],
  current_sem: String,
  courses: Array,
})

const selectedRole = ref(props.role ?? '')
const roles = [
  { value: 'faculty', label: 'Faculty' },
  { value: 'student', label: 'Student' },
]
// navigate when role changes
watch(selectedRole, (newRole) => {
  if (newRole && newRole !== props.role) {
    router.get(route('users.index', { role: newRole }), {}, { preserveScroll: true })
  }
})

const selectedCourse = ref('')
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code}` }))
)

const genders = [
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' },
]

const selectedDesignation = ref('faculty')
const designations = [
  { value: 'faculty', label: 'Faculty' },
  { value: 'program-head', label: 'Program Head' },
  { value: 'dean', label: 'Dean' },
]

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentUser = ref(null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

// form state
const form = useForm({
    role: props.role,
    last_name: '',
    first_name: '',
    mid_name: '',
    name_ext: '',
    gender: '',
    email: '',
    designation: selectedDesignation,
    course_id: selectedCourse ?? null,
    semester_id: props.sem_id,
})

const editForm = useForm({
    role: 'faculty',
    last_name: '',
    first_name: '',
    mid_name: '',
    name_ext: '',
    gender: '',
    email: '',
})

// open edit modal and fill form
const openEditModal = (user) => {
    currentUser.value = user
    editForm.last_name = user.last_name
    editForm.first_name = user.first_name
    editForm.mid_name = user.mid_name
    editForm.name_ext = user.name_ext
    editForm.gender = user.gender
    editForm.email = user.email
    showEditModal.value = true
}

const submit = () => {
    form.post(route('users.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('last_name', 'first_name', 'mid_name', 'name_ext', 'gender', 'email', 'designation', 'course_id')
            toast.success('User successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

watch(() => form.designation, (newVal) => {
  if (newVal !== 'program-head' || newVal !== 'faculty') {
    form.course_id = '' // reset if not program-head
  }
})

const update = () => {
    editForm.post(route('users.update', currentUser.value.id), {
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
</script>
<template>
    <Head title="Users" />

    <AdminLayout>
        <template #header>Users</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Users</h2>
                        <DropdownCustom
                            v-model="selectedRole"
                            :options="roles"
                            label="Select Role"
                        />
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <button
                            @click="showCreateModal = true"
                            class="btn-outline-green"
                            v-if="props.role === 'faculty'"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Add New</span>
                        </button>
                    </div>
                </div>

                <div class="mb-2">
                    <h5 class="text-blue-600">* For existing users with new assigned designation, please use the designation logs page of the user.</h5>
                </div>
                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Gender</th>
                            <th>Current Designation</th>
                            <th>Email</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="user in props.users" :key="user.id">
                            <td>{{ user.name }}</td>
                            <td>{{ user.gender.charAt(0).toUpperCase() + user.gender.slice(1) }}</td>
                            <td><span v-if="user.faculty">{{ user.faculty.designation.charAt(0).toUpperCase() + user.faculty.designation.slice(1) }}</span></td>
                            <td>{{ user.email }}</td>
                            <td>
                                <div class="flex">
                                    <button 
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="EDIT"
                                        @click="openEditModal(user)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                    <button type="button" class="flex justify-center mr-2 btn-green"
                                        @click="router.get(route('users.faculties.designationLogs', user.id))"
                                    >
                                        <span>Designation Logs</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="users.length === 0">
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

    <!-- Modal add to current version -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Add New User (<strong class="text-green-700">{{ props.role.toUpperCase() }}</strong>)
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
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
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
                        <div class="col-span-2" v-if="form.designation === 'program-head' || form.designation === 'faculty'">
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
                    <small class="mt-2 text-blue-700">Selected designation will apply on the current active semester ({{ props.current_sem }}).</small>
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
</template>