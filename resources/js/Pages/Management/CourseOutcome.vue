<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { PlusCircleIcon, PlusIcon, PencilSquareIcon, TrashIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue'
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import TextareaField from '@/Components/TextareaField.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import DangerButton from '@/Components/DangerButton.vue'
import { useToast } from 'vue-toastification'

const page = usePage()
const toast = useToast();

const props = defineProps({
    subject_id: [String, Number],
    curriculum_id: [String, Number],
    subject_name: String,
    version: [String, Number],
    versions: Array,
    new_version: [String, Number],
    course_name: String,
    course_outcomes: Array,
    program_outcomes: Array,
    new_order_no_cv: [String, Number],
    designation: String,
})

const showCreateModal = ref(false)
const createMode = ref('current')
const showEditModal = ref(false)
const currentCO = ref(null)
const showConfirmDelModal = ref(false)

// normalize versions
const versionOptions = computed(() =>
  props.versions.map(v => ({ value: v.version, label: `Version ${v.version}` }))
)

// track backend-provided version
const selectedVersion = ref(props.version ?? '')

// navigate when version changes
watch(selectedVersion, (newVersion) => {
  if (newVersion && newVersion !== props.version) {
    router.get(route('curriculums.courses.course-outcomes.index', { subject_id: props.subject_id, version: newVersion }), {}, { preserveScroll: true })
  }
})

// watch(
//   () => props.version,
//   (newVal) => {
//     selectedVersion.value = newVal
//   },
//   { immediate: true }
// )

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

const lastOrderNo = ref(props.course_outcomes.length > 0 
    ? Math.max(...props.course_outcomes.map(co => co.order_no)) 
    : 0
)

const openCreateModal = (mode) => {
  createMode.value = mode
  form.reset('course_outcome', 'program_outcomes')

  if (mode === 'current') {
    form.order_no = lastOrderNo.value + 1
    form.version = props.version
  } else {
    form.order_no = 1
    form.version = props.new_version
  }

  showCreateModal.value = true
}

const form = useForm({
    subject_id: props.subject_id,
    version: props.version,
    order_no: createMode.value === 'current' ? props.new_order_no_cv : 1,
    course_outcome: '',
    program_outcomes: [],
})

const editForm = useForm({
    order_no: '',
    course_outcome: '',
    status: '',
    program_outcomes: [],
})

const deleteForm = useForm({
    course_outcome_id: '',
})

// open edit modal and fill form
const openEditModal = (course_outcome) => {
    currentCO.value = course_outcome
    editForm.order_no = course_outcome.order_no
    editForm.course_outcome = course_outcome.course_outcome
    editForm.status = course_outcome.status
    editForm.program_outcomes = course_outcome.outcome_links.map(link => link.program_outcome_id)
    showEditModal.value = true
}

const openConfirmDelModal = (course_outcome) => {
    currentCO.value = course_outcome
    deleteForm.course_outcome_id = course_outcome.course_outcome_id
    showConfirmDelModal.value = true
}

const submit = () => {
    form.subject_id = props.subject_id

    form.post(route('curriculums.courses.course-outcomes.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            toast.success('Course Outcome successfully saved!', 'Success')
            
            if (createMode.value === 'new') {
                router.get(
                    route('curriculums.courses.course-outcomes.index', { 
                        subject_id: props.subject_id
                    }),
                    {},
                    { preserveScroll: true }
                )
            }
            // Increment locally if it's current version
            if (createMode.value === 'current') {
                lastOrderNo.value++
            } else {
                // If it's a new version, reset to 1
                lastOrderNo.value = 1
            }
            form.reset('course_outcome', 'program_outcomes')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

// submit update
const update = () => {
    editForm.post(route('curriculums.courses.course-outcomes.update', currentCO.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            currentCO.value = null
            toast.success('Course Outcome successfully updated!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}

// submit delete
const destroy = () => {
    deleteForm.post(route('curriculums.courses.course-outcomes.destroy', currentCO.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showConfirmDelModal.value = false
            currentCO.value = null
            toast.success('Course Outcome successfully deleted!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}

watch(showCreateModal, (val) => {
  if (val) form.clearErrors()
})
</script>
<template>
    <Head title="Course Outcomes" />
    <AdminLayout>
        <template #header>Course Outcomes</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Course Outcomes:</h2>
                        <DropdownCustom
                            v-model="selectedVersion"
                            :options="versionOptions"
                            label="Select Version"
                        />
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <button
                            v-if="props.versions.length > 0" 
                            @click="openCreateModal('current')"
                            class="btn-outline-green mr-1"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Add New</span>
                        </button>
                        <button
                            v-if="props.new_version !== null" 
                           @click="openCreateModal('new')"
                            class="btn-green mr-1"
                        >
                            <PlusCircleIcon class="w-4 h-4 shrink-0" />
                            <span>Add with New Version</span>
                        </button>
                        <DangerButton
                            @click="router.get(route('curriculums.courses.index', {curriculum_id: props.curriculum_id}))"
                            class="!px-2 !py-0"
                            v-if="props.designation!=='faculty'"
                        >
                            Back
                        </DangerButton>
                        <DangerButton
                            @click="router.get(route('assignedsubjects.assignedSubjects'))"
                            class="!px-2 !py-0"
                            v-if="props.designation==='faculty'"
                        >
                            Back
                        </DangerButton>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <h5 class="">Subject: <u><b>{{ props.subject_name }}</b></u></h5>
                    <h5 class="">Course: <u><b>{{ props.course_name }}</b></u></h5>
                </div>
                <!-- Table -->
                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Order No.</th>
                            <th>Course Outcome</th>
                            <th>P.O. Links</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="course_outcome in props.course_outcomes" :key="course_outcome.id">
                            <td>Course Outcome {{ course_outcome.order_no }}</td>
                            <td>{{ course_outcome.course_outcome }}</td>
                            <td>
                                <span v-if="course_outcome.outcome_links.length > 0">{{ course_outcome.outcome_links.map(link => link.po_code).join(', ') }}</span>
                            </td>
                            <td>
                                <span v-if="course_outcome.status==='active'" class="text-green-700">{{ course_outcome.status }}</span>
                                <span v-else class="text-red-700">{{ course_outcome.status }}</span>
                            </td>
                            <td>
                                <div class="flex">
                                    <button 
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="EDIT"
                                        @click="openEditModal(course_outcome)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                    <button 
                                        type="button" 
                                        class="hover:text-red-600 mr-2 disabled:text-gray-500" 
                                        title="DELETE"
                                        @click="openConfirmDelModal(course_outcome)"
                                        :disabled="course_outcome.evaluations.length > 0"
                                    >
                                        <TrashIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="course_outcomes.length === 0">
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

    <!-- Create Modal -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Create new Course Outcome for 
                    <u>
                        {{ createMode === 'current'
                            ? `${props.subject_name} (Version ${props.version})`
                            : `${props.subject_name} (New Version ${props.new_version})`
                        }}
                    </u>
                    
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="order_no" value="Order No." />
                        <TextInput
                            id="order_no"
                            type="text"
                            class="mt-1 block w-full input-readonly"
                            v-model="form.order_no"
                            required
                            readonly
                        />
                        <InputError class="mt-2" :message="form.errors.order_no" />
                    </div>

                    <div>
                        <InputLabel for="course_outcome" value="Course Outcome" />
                        <TextareaField
                            id="course_outcome"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.course_outcome"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.course_outcome" />
                    </div>

                    <p class="mb-0 text-[14px]">Please select applicable P.O. Links</p>
                    <template v-for="program_outcome in program_outcomes" :key="program_outcome.id">
                    <div class="text-[13px] !mt-2 !leading-3 text-justify">
                        <input
                        type="checkbox"
                        :id="`program_outcome_${program_outcome.id}`"
                        :value="program_outcome.id"
                        v-model="form.program_outcomes"
                        />
                        <label :for="`program_outcome_${program_outcome.id}`" class="ml-1">
                            <b>{{ program_outcome.po_code }}</b>
                            {{ ' - ' + program_outcome.po_description }}
                        </label>
                    </div>
                    </template>

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

    <!-- Edit Modal -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Course Outcome for <u>{{ props.subject_name }}</u>
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="order_no" value="Order No." />
                        <TextInput
                            id="order_no"
                            type="text"
                            class="mt-1 block w-full input-readonly"
                            v-model="editForm.order_no"
                            required
                            readonly
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.order_no" />
                    </div>

                    <div>
                        <InputLabel for="course_outcome" value="Course Outcome" />
                        <TextareaField
                            id="course_outcome"
                            class="mt-1 block w-full"
                            v-model="editForm.course_outcome"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.course_outcome" />
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

                <div class="mt-4">
                <p class="mb-0 text-[14px]">Update applicable P.O. Links</p>
                <template v-for="program_outcome in program_outcomes" :key="program_outcome.id">
                    <div class="text-[13px] !mt-2 !leading-3 text-justify">
                    <input
                        type="checkbox"
                        :id="`edit_program_outcome_${program_outcome.id}`"
                        :value="program_outcome.id"
                        v-model="editForm.program_outcomes"
                    />
                    <label :for="`edit_program_outcome_${program_outcome.id}`" class="ml-1">
                        <b>{{ program_outcome.po_code }}</b>
                        {{ ' - ' + program_outcome.po_description }}
                    </label>
                    </div>
                </template>
                <InputError class="mt-2" :message="editForm.errors.program_outcomes" />
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
    <!-- Delete Confirm Modal -->
    <Modal2 :show="showConfirmDelModal" @close="showConfirmDelModal = false">
        <form @submit.prevent="destroy">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Delete Confirmation
                </h2>

                <div class="space-y-4">
                    <h3>Are you sure you want to Delete this Course Outcome?</h3>
                </div>

                <div class="mt-6 flex justify-end space-x-2">
                    <SecondaryButton
                        type="button"
                        @click="showConfirmDelModal = false"
                        >
                        No
                    </SecondaryButton>
                    <PrimaryButton
                        class="ms-4"
                        :class="{ 'opacity-25': deleteForm.processing }"
                        :disabled="deleteForm.processing"
                    >
                        Yes
                    </PrimaryButton>
                </div>
            </div>
        </form>
    </Modal2>
</template>