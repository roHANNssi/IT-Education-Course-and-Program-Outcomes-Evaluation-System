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
import SelectField from '@/Components/SelectField.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification'

const page = usePage()
const toast = useToast();

const props = defineProps({
    course_id: [String, Number],
    courses: Array,
    version: [String, Number],
    versions: Array,
    new_version: [String, Number],
    course_name: String,
    program_outcomes: Array,
})

const showCreateModal = ref(false)
const createMode = ref('current')
const showEditModal = ref(false)
const currentPO = ref(null)
const showConfirmDelModal = ref(false)

// normalize courses
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_code}` }))
)

// normalize versions
const versionOptions = computed(() =>
  props.versions.map(v => ({ value: v.version, label: `Version ${v.version}` }))
)

// track backend-provided course
const selectedCourse = ref(props.course_id ?? '')
// track backend-provided version
const selectedVersion = ref(props.version ?? '')

// navigate when course changes
watch(selectedCourse, (newCourse) => {
  if (newCourse && newCourse !== props.course_id) {
    router.get(route('program-outcomes.index', { course_id: newCourse, version: selectedVersion.value || props.version }), {}, { preserveScroll: true })
  }
})

// navigate when version changes
watch(selectedVersion, (newVersion) => {
  if (newVersion && newVersion !== props.version) {
    router.get(route('program-outcomes.index', { course_id: selectedCourse.value || props.course_id, version: newVersion }), {}, { preserveScroll: true })
  }
})

watch(
  () => props.version,
  (newVal) => {
    selectedVersion.value = newVal
  },
  { immediate: true }
)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

const form = useForm({
    course_id: props.course_id,
    version: props.version,
    po_code: '',
    po_description: '',
    order_number: '',
})

const editForm = useForm({
    po_code: '',
    po_description: '',
    order_number: '',
    status: '',
})

const deleteForm = useForm({
    program_outcome_id: '',
})

// open edit modal and fill form
const openEditModal = (program_outcome) => {
    currentPO.value = program_outcome
    editForm.po_code = program_outcome.po_code
    editForm.po_description = program_outcome.po_description
    editForm.order_number = program_outcome.order_number
    editForm.status = program_outcome.status
    showEditModal.value = true
}

const openConfirmDelModal = (program_outcome) => {
    currentPO.value = program_outcome
    deleteForm.program_outcome_id = program_outcome.program_outcome_id
    showConfirmDelModal.value = true
}

const submit = () => {
    form.version = createMode.value === 'current' ? props.version : props.new_version
    form.course_id = props.course_id

    form.post(route('program-outcomes.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('po_code', 'po_description')
            toast.success('Program Outcome successfully saved!', 'Success')

            if (createMode.value === 'new') {
                router.get(
                route('program-outcomes.index', { 
                    course_id: props.course_id
                }),
                {},
                { preserveScroll: true }
                )
            }
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

// submit update
const update = () => {
    editForm.post(route('program-outcomes.update', currentPO.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            currentPO.value = null
            toast.success('Program Outcome successfully updated!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}

// submit delete
const destroy = () => {
    deleteForm.post(route('program-outcomes.destroy', currentPO.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showConfirmDelModal.value = false
            currentPO.value = null
            toast.success('Program Outcome successfully deleted!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}
</script>
<template>
    <Head title="Program Outcomes" />
    <AdminLayout>
        <template #header>Program Outcomes</template>

        <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-2 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Program Outcomes for: </h2>
                        <DropdownCustom
                            v-model="selectedCourse"
                            :options="courseOptions"
                            label="Select Course"
                        />
                        <DropdownCustom
                            v-model="selectedVersion"
                            :options="versionOptions"
                            label="Select Version"
                        />
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <button
                            v-if="props.course_id && props.versions.length > 0" 
                            @click="() => { createMode = 'current'; showCreateModal = true }"
                            class="btn-outline-green mr-2"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Add New</span>
                        </button>
                        <button
                            v-if="props.course_id && props.new_version !== null" 
                            @click="() => { createMode = 'new'; showCreateModal = true }"
                            class="btn-green"
                        >
                            <PlusCircleIcon class="w-4 h-4 shrink-0" />
                            <span>Add with New Version</span>
                        </button>
                    </div>
                </div>

                <!-- Table -->
                <div class="overflow-x-auto">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>PO Code</th>
                        <th>Program Outcomes</th>
                        <th>Order No.</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="program_outcome in props.program_outcomes" :key="program_outcome.id">
                        <td>{{ program_outcome.po_code }}</td>
                        <td>{{ program_outcome.po_description }}</td>
                        <td>{{ program_outcome.order_number }}</td>
                        <td>
                            <span v-if="program_outcome.status==='active'" class="text-green-700">{{ program_outcome.status }}</span>
                            <span v-else class="text-red-700">{{ program_outcome.status }}</span>
                        </td>
                        <td>
                            <div class="flex">
                                <button 
                                    type="button" 
                                    class="hover:text-green-600 mr-2" 
                                    title="EDIT"
                                    @click="openEditModal(program_outcome)"
                                >
                                    <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                </button>
                                <button 
                                    type="button" 
                                    class="hover:text-red-600 mr-2 disabled:text-gray-500" 
                                    title="DELETE"
                                    @click="openConfirmDelModal(program_outcome)"
                                    :disabled="program_outcome.outcome_links.length > 0"
                                >
                                    <TrashIcon class="w-6 h-6 shrink-0"/>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="program_outcomes.length === 0">
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
    <!-- Create Modal -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                    Create new Program Outcome for 
                    <u>
                        {{ createMode === 'current'
                            ? `${props.course_name} (Version ${props.version})`
                            : `${props.course_name} (New Version ${props.new_version})`
                        }}
                    </u>
                    
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="po_code" value="P.O. Code" />
                        <TextInput
                            id="po_code"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="form.po_code"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.po_code" />
                    </div>

                    <div>
                        <InputLabel for="po_description" value="Program Outcome" />
                        <TextareaField
                            id="po_description"
                            class="mt-1 block w-full"
                            rows="4"
                            v-model="form.po_description"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.po_description" />
                    </div>

                    <div>
                        <InputLabel for="order_number" value="Order Number" />
                        <TextInput
                            id="order_number"
                            type="number"
                            class="mt-1 block w-full"
                            v-model="form.order_number"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="form.errors.order_number" />
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
    <!-- Edit Modal -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Edit Program Outcome for <u>{{ props.course_name }}</u>
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="po_code" value="P.O. Code" />
                        <TextInput
                            id="po_code"
                            type="text"
                            class="mt-1 block w-full"
                            v-model="editForm.po_code"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.po_code" />
                    </div>

                    <div>
                        <InputLabel for="po_description" value="Program Outcome" />
                        <TextareaField
                            id="po_description"
                            class="mt-1 block w-full"
                            rows="4"
                            v-model="editForm.po_description"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.po_description" />
                    </div>

                    <div>
                        <InputLabel for="order_number" value="Order Number" />
                        <TextInput
                            id="order_number"
                            type="number"
                            class="mt-1 block w-full"
                            v-model="editForm.order_number"
                            required
                            autofocus
                        />
                        <InputError class="mt-2" :message="editForm.errors.order_number" />
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
    <!-- Delete Confirm Modal -->
    <Modal2 :show="showConfirmDelModal" @close="showConfirmDelModal = false">
        <form @submit.prevent="destroy">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Delete Confirmation
                </h2>

                <div class="space-y-4">
                    <h3>Are you sure you want to Delete this Program Outcome?</h3>
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