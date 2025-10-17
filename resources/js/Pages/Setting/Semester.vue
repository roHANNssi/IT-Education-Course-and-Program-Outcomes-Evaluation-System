<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
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
  semesters: Array,
})

const selected = ref('')
const semesters = [
  { value: '1st', label: 'First Semester' },
  { value: '2nd', label: 'Second Semester' },
]

const showCreateModal = ref(false)
const showEditModal = ref(false)
const currentSemester = ref(null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

// form state
const form = useForm({
  sem: selected,
  acad_year: '',
  order_num: '',
  status: 'inactive'
})

const editForm = useForm({
  sem: '',
  acad_year: '',
  order_num: '',
  status: 'inactive',
})

// Reusable validator: accepts any form object
const validateAcademicYear = (formData) => {
    if (!formData.acad_year.includes('-')) return true; // skip if not properly formatted

    const [start, end] = formData.acad_year.split('-').map(y => parseInt(y.trim()));

    if (isNaN(start) || isNaN(end)) return true; // skip if invalid input

    if (end <= start) {
        toast.error("Invalid Academic Year: End year must be greater than start year.", "Validation Error");
        return false;
    }

    return true;
}

// open edit modal and fill form
const openEditModal = (semester) => {
  currentSemester.value = semester
  editForm.sem = semester.sem
  editForm.acad_year = semester.acad_year
  editForm.order_num = semester.order_num
  editForm.status = semester.status
  showEditModal.value = true
}

// submit create
const submit = () => {
    if (!validateAcademicYear(form)) return;

    form.post(route('semesters.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('sem', 'acad_year')
            // success message comes from Laravel flash
            // if (page.props.flash?.success) {
                toast.success('Semester successfully saved!', 'Success')
            // }
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
};

// submit update
const update = () => {
    if (!currentSemester.value) return
    if (!validateAcademicYear(editForm)) return;

    editForm.post(route('semesters.update', currentSemester.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            currentSemester.value = null
            toast.success('Semester successfully updated!', 'Success')
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')
        },
    })
}
</script>

<template>
    <Head title="Semesters" />

    <AdminLayout>
        <template #header>Semesters</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Semesters</h2>
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
                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Sem</th>
                                <th>Academic Year</th>
                                <th>Order No.</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="semester in props.semesters" :key="semesters.id">
                                <td>{{ semester.sem }}</td>
                                <td>{{ semester.acad_year }}</td>
                                <td>{{ semester.order_num }}</td>
                                <td>
                                    <span v-if="semester.status==='active'" class="text-green-700">{{ semester.status }}</span>
                                    <span v-else class="text-red-700">{{ semester.status }}</span>
                                </td>
                                <td>
                                    <button 
                                        type="button" 
                                        class="hover:text-green-600" 
                                        title="EDIT"
                                        @click="openEditModal(semester)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="semesters.length === 0">
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

    <!-- Modal ADD -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
      <form @submit.prevent="submit">
        <div class="p-6">
            <h2 class="text-lg font-medium text-gray-900 mb-4">
            Create New Semester
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <InputLabel for="sem" value="Semester" />
                    <SelectField
                        v-model="form.sem"
                        :options="semesters"
                        placeholder="-- Please select semester --"
                        class="mt-1 block w-full"
                    />
                    <InputError class="mt-2" :message="form.errors.sem" />
                </div>

              <div>
                  <InputLabel for="acad_year" value="Academic Year" />
                  <TextInput
                      id="acad_year"
                      type="text"
                      class="mt-1 block w-full"
                      v-model="form.acad_year"
                      required
                      autofocus
                      placeholder="e.g. 2025-2026"
                  />
                  <InputError class="mt-2" :message="form.errors.acad_year" />
              </div>
            </div>

            <div class="mt-4">
                <InputLabel for="status" value="Set as Current Semester?" />
                <div class="flex items-center mt-2 space-x-4">
                    <label class="flex items-center space-x-2">
                    <input
                        type="radio"
                        value="active"
                        v-model="form.status"
                        class="text-green-600 border-gray-300 focus:ring-green-500"
                    />
                    <span>YES</span>
                    </label>

                    <label class="flex items-center space-x-2">
                    <input
                        type="radio"
                        value="inactive"
                        v-model="form.status"
                        class="text-green-600 border-gray-300 focus:ring-green-500"
                    />
                    <span>NO</span>
                    </label>
                </div>
                <InputError class="mt-2" :message="form.errors.status" />
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

    <!-- EDIT MODAL -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
        <form @submit.prevent="update">
        <div class="p-6">
            <h2 class="text-lg font-medium text-gray-900 mb-4">Edit Semester</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <InputLabel for="sem" value="Semester" />
                <SelectField v-model="editForm.sem" :options="semesters" class="mt-1 block w-full" />
                <InputError class="mt-2" :message="editForm.errors.sem" />
            </div>

            <div>
                <InputLabel for="acad_year" value="Academic Year" />
                <TextInput v-model="editForm.acad_year" type="text" class="mt-1 block w-full" />
                <InputError class="mt-2" :message="editForm.errors.acad_year" />
            </div>
            </div>

            <div class="mt-4">
                <InputLabel value="Set as Current Semester?" />
                <div class="flex items-center mt-2 space-x-4">
                    <label class="flex items-center space-x-2">
                    <input type="radio" value="active" v-model="editForm.status" /> <span>YES</span>
                    </label>
                    <label class="flex items-center space-x-2">
                    <input type="radio" value="inactive" v-model="editForm.status" /> <span>NO</span>
                    </label>
                </div>
                <InputError class="mt-2" :message="editForm.errors.status" />
            </div>

            <div class="mt-6 flex justify-end space-x-2">
            <SecondaryButton type="button" @click="showEditModal = false">Cancel</SecondaryButton>
            <PrimaryButton :class="{ 'opacity-25': editForm.processing }" :disabled="editForm.processing">Update</PrimaryButton>
            </div>
        </div>
        </form>
    </Modal2>
</template>