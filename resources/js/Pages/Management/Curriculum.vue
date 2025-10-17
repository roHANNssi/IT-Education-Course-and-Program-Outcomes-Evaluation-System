<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { ListBulletIcon, PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue';
import SelectField from '@/Components/SelectField.vue';
import TextareaField from '@/Components/TextareaField.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification';

const toast = useToast();
const page = usePage()

const props = defineProps({
    course_id: [Number, String],
    courses: Array,
    curriculums: Array,
})

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentCurriculum = ref(null)
const selectedCourse = ref(props.course_id ?? null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
})

const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_name} (${v.course_code})` }))
)

const form = useForm({
    course_id: selectedCourse,
    curr_name: '',
    curr_detail: '',
    //curr_stat: '',
})

const editForm = useForm({
    course_id: '',
    curr_name: '',
    curr_detail: '',
    curr_stat: '',
})

const openEditModal = (curriculum) => {
  currentCurriculum.value = curriculum
  editForm.course_id = curriculum.course_id
  editForm.curr_name = curriculum.curr_name
  editForm.curr_detail = curriculum.curr_detail
  editForm.curr_stat = curriculum.curr_stat
  showEditModal.value = true
}

const submit = () => {
    form.post(route('curriculums.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('curr_detail')
            toast.success('Curriculum successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

const update = () => {
    editForm.post(route('curriculums.update', currentCurriculum.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('curr_detail')
            toast.success('Curriculum successfully updated!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}
</script>
<template>
    <Head title="Curriculums" />

    <AdminLayout>
        <template #header>Curriculums</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                <!-- Title + Dropdown -->
                <div class="col-span-1 flex items-center space-x-3">
                    <h2 class="font-semibold text-lg text-gray-800">List of Curriculums</h2>
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
                        <th>Curriculum</th>
                        <th>Program</th>
                        <!-- <th>Status</th> -->
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="curriculum in props.curriculums" :key="curriculum.id">
                        <td class="w-[500px]">
                            <p>{{ curriculum.curr_name }}</p>
                            <p class="text-gray-700 leading-[15px]"><small><i>{{ curriculum.curr_detail }}</i></small></p>
                        </td>
                        <td>{{ curriculum.course_name + ' (' + curriculum.course_code + ')' }}</td>
                        <!-- <td :class="curriculum.curr_stat==='active' ? 'text-green-600' : 'text-red-500'">
                            {{ curriculum.curr_stat.toUpperCase() }}
                            <span v-if="curriculum.curr_stat==='active'"><i>(Current)</i></span>
                        </td> -->
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(curriculum)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                </button>
                                <button type="button" class="flex justify-center btn-outline-green"
                                    @click="router.get(route('curriculums.courses.index', {curriculum_id: curriculum.id}))"
                                >
                                    <ListBulletIcon class="w-4 h-4 shrink-0"/>
                                    <span>Courses</span>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="curriculums.length === 0">
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

    <!-- Create modal -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Add New Curriculum Details
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_id" value="Program" />
                        <SelectField
                            v-model="form.course_id"
                            :options="courseOptions"
                            placeholder="-- Please select Program --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.course_id" />
                    </div>

                    <div>
                        <InputLabel for="curr_name" value="Curriculum Name" />
                        <TextInput
                            id="curr_name"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.curr_name"
                            required
                        />
                        <InputError class="mt-2" :message="form.errors.curr_name" />
                    </div>

                    <div>
                        <InputLabel for="curr_detail" value="Curriculum Details" />
                        <TextareaField
                            id="curr_detail"
                            type="text"
                            class="mt-1 h-28 block w-full"
                            v-model="form.curr_detail"
                            required
                        />
                        <InputError class="mt-2" :message="form.errors.curr_detail" />
                    </div>
                </div>

                <!-- <div class="mt-4">
                    <InputLabel value="Status" />
                    <div class="flex items-center mt-2 space-x-4">
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="active" v-model="form.curr_stat" /> <span>Active (Current)</span>
                        </label>
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="inactive" v-model="form.curr_stat" /> <span>Inactive</span>
                        </label>
                    </div>
                    <InputError class="mt-2" :message="form.errors.curr_stat" />
                </div> -->

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
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Curriculum Details
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="course_id" value="Program" />
                        <SelectField
                            v-model="editForm.course_id"
                            :options="courseOptions"
                            placeholder="-- Please select Program --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_id" />
                    </div>

                    <div>
                        <InputLabel for="curr_name" value="Curriculum Name" />
                        <TextInput
                            id="curr_name"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="editForm.curr_name"
                            required
                        />
                        <InputError class="mt-2" :message="editForm.errors.curr_name" />
                    </div>

                    <div>
                        <InputLabel for="curr_detail" value="Curriculum Details" />
                        <TextareaField
                            id="curr_detail"
                            type="text"
                            class="mt-1 h-28 block w-full"
                            v-model="editForm.curr_detail"
                            required
                        />
                        <InputError class="mt-2" :message="editForm.errors.curr_detail" />
                    </div>
                </div>

                <div class="mt-4">
                    <InputLabel value="Status" />
                    <div class="flex items-center mt-2 space-x-4">
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="active" v-model="editForm.curr_stat" /> <span>Active (Current)</span>
                        </label>
                        <label class="flex items-center space-x-2">
                        <input type="radio" value="inactive" v-model="editForm.curr_stat" /> <span>Inactive</span>
                        </label>
                    </div>
                    <InputError class="mt-2" :message="editForm.errors.curr_stat" />
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