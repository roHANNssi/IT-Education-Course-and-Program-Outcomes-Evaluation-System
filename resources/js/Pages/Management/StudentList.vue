<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import { PlusIcon, CloudArrowDownIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import SelectField from '@/Components/SelectField.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import DangerButton from '@/Components/DangerButton.vue';
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
    faculty_subject_id: [String, Number],
    faculty_subject: Object,
    enrolled_subjects: Array,
})

const downloadTemplate = () => {
    window.open('/storage/templates/StudentListTemplate.xlsx', '_blank');
}

const showCreateModal = ref(false)

const form = useForm({
    faculty_subject_id: props.faculty_subject_id,
    csv_file: '',
})

const submit = () => {
    form.post(route('assignedsubjects.students.store'), {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('csv_file')
            toast.success('Students imported successfully!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}

</script>
<template>
    <Head title="Students List" />

    <AdminLayout>
        <template #header>Students List</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">List of Enrolled Students: <u>{{ props.faculty_subject.sem + 'Semester, A.Y. ' + props.faculty_subject.acad_year }}</u></h2>
                    </div>

                    <div class="col-span-1 flex justify-end">
                        <button
                            @click="showCreateModal = true"
                            class="btn-outline-green mr-1"
                        >
                            <PlusIcon class="w-4 h-4 shrink-0" />
                            <span>Import Students</span>
                        </button>

                        <DangerButton
                            @click="router.get(route('assignedsubjects.assignedSubjects'))"
                            class="!px-2 !py-0"
                        >
                            Back
                        </DangerButton>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
                    <div>
                        <h4>Subject: <b>{{ props.faculty_subject.subject_title + ' (' + props.faculty_subject.subject_code + ')' }}</b></h4>
                    </div>
                    <div>
                        <h4>Section: <b>{{ props.faculty_subject.section }}</b></h4>
                    </div>
                </div>

                <div class="overflow-x-auto">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Student ID Number</th>
                        <th>Student Name</th>
                        <th>Gender</th>
                        <!-- <th>Actions</th> -->
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="enrolled_subject in props.enrolled_subjects" :key="enrolled_subject.id">
                        <td>{{ enrolled_subject.id_number }}</td>
                        <td>
                            <span>{{ enrolled_subject.last_name.toUpperCase() + ', ' + enrolled_subject.first_name.toUpperCase() + ' ' + enrolled_subject.mid_name.toUpperCase() }}</span>
                            <span v-if="enrolled_subject.name_ext!==null">{{ enrolled_subject.name_ext.toUpperCase() }}</span>
                        </td>
                        <td>{{ enrolled_subject.gender.toUpperCase() }}</td>
                        <!-- <td>

                        </td> -->
                    </tr>
                    <tr v-if="enrolled_subjects.length === 0">
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

    <!-- Create MODAL -->
    <Modal2 :show="showCreateModal" @close="showCreateModal = false">
        <form @submit.prevent="submit">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 mb-4">
                Import Enrolled Students on this Subject
                </h2>

                <div class="space-y-4 mb-4">
                    <button type="button" class="flex justify-center btn-outline-green" @click="downloadTemplate">
                        <CloudArrowDownIcon class="w-6 h-6 shrink-0 mr-1"/>
                        <span>Download Template</span>
                    </button>
                </div>
                <div class="space-y-4">
                    <div>
                        <InputLabel for="csv_file" value="Select Excel/CSV File" />
                        <TextInput
                            id="csv_file"
                            type="file"
                            class="mt-1 block w-full"
                            @change="e => form.csv_file = e.target.files[0]"
                            required
                        />
                        <InputError class="mt-2" :message="form.errors.csv_file" />
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
</template>