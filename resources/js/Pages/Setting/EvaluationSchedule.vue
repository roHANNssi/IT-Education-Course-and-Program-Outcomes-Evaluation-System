<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue';
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import SelectField from '@/Components/SelectField.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification';

const toast = useToast();

const props = defineProps({
  semester_id: [String, Number],
  sem: Object,
  semesters: Array,
  courses: Array,
  evaluation_schedules: Array,
})

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

watch(selectedSemester, (newSemester) => {
  if (newSemester && newSemester !== props.semester_id) {
    router.get(route('evaluation-schedules.index', { semester_id: newSemester }), {}, { preserveScroll: true })
  }
})

// normalize courses
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_name} (${v.course_code})` }))
)

// CREATE
const showCreateModal = ref(false)
// form state
const form = useForm({
  semester_id: props.semester_id,
  course_id: '',
  start_date: '',
  end_date: ''
})

const submit = () => {
    form.post(route('evaluation-schedules.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('course_id', 'start_date', 'end_date')
            toast.success('Evaluation Schedule successfully saved!', 'Success')
        },
        onError: (errors) => {
            if (errors.duplicate) {
                toast.warning(errors.duplicate)
            } else {
                // form.errors will already be populated and bound to <InputError>
                toast.error('Please fix the errors and try again.', 'Validation Error')
            } 
        }
    });
}

// EDIT
const showEditModal = ref(false)
const currentES = ref(null)
const editForm = useForm({
    course_id: '',
    start_date: '',
    end_date: ''
})

// open edit modal and fill form
const openEditModal = (evaluation_schedule) => {
    currentES.value = evaluation_schedule
    showEditModal.value = true
    editForm.course_id = evaluation_schedule.course_id
    editForm.start_date = evaluation_schedule.start_date
    editForm.end_date = evaluation_schedule.end_date
}

// handle update
const update = () => {
  editForm.post(route('evaluation-schedules.update', currentES.value.id), {
    preserveScroll: true,
    onSuccess: () => {
      showEditModal.value = false
      toast.success('Evaluation Schedule updated successfully!')
    },
    onError: (errors) => {
        console.log(errors)
        if (errors.duplicate) {
            toast.warning(errors.duplicate)
        } else {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        } 
    }
  })
}
</script>
<template>
    <Head title="Evaluation Schedules" />

    <AdminLayout>
        <template #header>Evaluation Schedules</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">Manage Evaluation Schedules</h2>
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
                    </div>

                    <div class="col-span-2 flex items-center space-x-3">
                        <DropdownCustom
                            v-model="selectedSemester"
                            :options="semesterOptions"
                            label="Select Semester"
                            width="!w-full"
                        />
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Program</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                            <template v-if="evaluation_schedules.length > 0">
                                <tr v-for="evaluation_schedule in evaluation_schedules" :key="evaluation_schedule.id">
                                    <td>{{ evaluation_schedule.course_name }} ({{ evaluation_schedule.course_code }})</td>
                                    <td>{{ evaluation_schedule.start_date }}</td>
                                    <td>{{ evaluation_schedule.end_date }}</td>
                                    <td>
                                        <button 
                                            type="button" 
                                            class="hover:text-green-600 mr-2" 
                                            title="EDIT"
                                            @click="openEditModal(evaluation_schedule)"
                                        >
                                            <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                        </button>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>

    <!-- Create -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">Add New Setting</h2>

                <div class="space-y-4">
                    <h3>Semester: <b>{{ props.sem.sem + ' Semester, A.Y. ' + props.sem.acad_year }}</b></h3>
                    <div>
                        <InputLabel for="course_id" value="Program" />
                        <SelectField
                            v-model="form.course_id"
                            :options="courseOptions"
                            placeholder="-- Please select program --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.course_id" />
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <div class="col-span-1">
                            <InputLabel for="start_date" value="Start Date" />
                            <TextInput
                                type="date"
                                class="mt-1 block w-full"
                                v-model="form.start_date"
                                required
                            />
                            <InputError class="mt-2" :message="form.errors.start_date" />
                        </div>

                        <div class="col-span-1">
                            <InputLabel for="end_date" value="End Date" />
                            <TextInput
                                type="date"
                                class="mt-1 block w-full"
                                v-model="form.end_date"
                                required
                            />
                            <InputError class="mt-2" :message="form.errors.end_date" />
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

    <!-- Edit -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">Add New Setting</h2>

                <div class="space-y-4">
                    <h3>Semester: <b>{{ currentES.sem + ' Semester, A.Y. ' + currentES.acad_year }}</b></h3>
                    <div>
                        <InputLabel for="course_id" value="Program" />
                        <SelectField
                            v-model="editForm.course_id"
                            :options="courseOptions"
                            placeholder="-- Please select program --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_id" />
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <div class="col-span-1">
                            <InputLabel for="start_date" value="Start Date" />
                            <TextInput
                                type="date"
                                class="mt-1 block w-full"
                                v-model="editForm.start_date"
                                required
                            />
                            <InputError class="mt-2" :message="editForm.errors.start_date" />
                        </div>

                        <div class="col-span-1">
                            <InputLabel for="end_date" value="End Date" />
                            <TextInput
                                type="date"
                                class="mt-1 block w-full"
                                v-model="editForm.end_date"
                                required
                            />
                            <InputError class="mt-2" :message="editForm.errors.end_date" />
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