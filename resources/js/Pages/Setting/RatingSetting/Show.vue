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
import DangerButton from '@/Components/DangerButton.vue';
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
  curriculum_id: [Number, String],
  semester_id: [Number, String],
  yr_level: [Number, String],
  semesters: Array,
  curriculum: Object,
  subjects: Array,
  scales: Array,
})

const showCreateModal = ref(false)
const currentSubject = ref(null)

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

const selectedYrLvl = ref(props.yr_level ?? '')
const yearlevels = [
  { value: 'first', label: 'First Year' },
  { value: 'second', label: 'Second Year' },
  { value: 'third', label: 'Third Year' },
  { value: 'fourth', label: 'Fourth Year' },
]

watch(selectedSemester, (newSemester) => {
  if (newSemester && newSemester !== props.semester_id) {
    router.get(route('rating-setting.show', { curriculum_id: props.curriculum_id, semester_id: newSemester, yr_level: props.yr_level }), {}, { preserveScroll: true })
  }
})

watch(selectedYrLvl, (newYrLvl) => {
  if (newYrLvl && newYrLvl !== props.yr_level) {
    router.get(route('rating-setting.show', { curriculum_id: props.curriculum_id, semester_id: props.semester_id, yr_level: newYrLvl }), {}, { preserveScroll: true })
  }
})

const scaleVersions = computed(() =>
  props.scales.map(v => ({ value: v.version, label: `Version ${v.version}` }))
)

const coVersions = ref([])

const openCreateModal = (subject) => {
    currentSubject.value = subject
    form.subject_id = subject.id
    coVersions.value = subject.course_outcomes.map(v => ({
        value: v.version,
        label: `Version ${v.version}`
    }))
    if (subject.rating_setting !== null) {
        form.scale_version = subject.rating_setting.scale_version
        form.co_version = subject.rating_setting.co_version
    } else {
        form.scale_version = ''
        form.co_version = '' // reset or keep current
        // Auto-select the highest version (latest)
        // if (coVersions.value.length > 0) {
        //     const latest = Math.max(...coVersions.value.map(v => Number(v.value)))
        //     form.co_version = latest
        // } else {
        //     form.co_version = ''
        // }
    }
    showCreateModal.value = true
}

const form = useForm({
    semester_id: props.semester_id,
    subject_id: '',
    scale_version: '',
    co_version: '',
})

const submit = () => {
    form.post(route('rating-setting.save'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('subject_id', 'scale_version', 'co_version')
            toast.success('Rating Setting successfully saved!', 'Success')
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}
</script>

<template>
    <Head title="Rating Setting Details" />

    <AdminLayout>
        <template #header>Rating Setting Details</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">Evaluation Rating Setting</h2>
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                        <DangerButton
                            @click="router.get(route('rating-setting.index'))"
                            class="!px-2 !py-0"
                        >
                            Back
                        </DangerButton>
                    </div>

                    <div class="col-span-2">
                        <h4>Curriculum: <b>{{ props.curriculum.curr_name }}</b> - <span class="text-sm"><i>{{ props.curriculum.curr_detail }}</i></span></h4>
                        <h4>Program: <b>{{ props.curriculum.course_name }} ({{ props.curriculum.course_code }})</b></h4>
                    </div>

                    <div class="col-span-2 flex items-center space-x-3">
                        <DropdownCustom
                            v-model="selectedSemester"
                            :options="semesterOptions"
                            label="Select Semester"
                            width="!w-full"
                        />
                        <DropdownCustom
                            v-model="selectedYrLvl"
                            :options="yearlevels"
                            label="Select Year Level"
                        />
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Course Title</th>
                            <th>Scale Version</th>
                            <th>Course Outcome Version</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr v-if="props.semester_id!==null" v-for="subject in props.subjects" :key="subject.id">
                                <td>{{ subject.subject_title }}</td>
                                <td>
                                    <span v-if="subject.rating_setting!==null">{{ subject.rating_setting.scale_version }}</span>
                                    <span v-if="subject.rating_setting===null">n/a</span>
                                </td>
                                <td>
                                    <span v-if="subject.rating_setting!==null">{{ subject.rating_setting.co_version }}</span>
                                    <span v-if="subject.rating_setting===null">n/a</span>
                                </td>
                                <td>
                                    <button 
                                        type="button" 
                                        class="hover:text-green-600 mr-2" 
                                        title="UPDATE"
                                        @click="openCreateModal(subject)"
                                    >
                                        <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="props.semester_id===null">
                                <td colspan="4">
                                    <p class="text-gray-500 text-center">Please select semester to show data</p>
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
                Add Rating Setting
                </h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="scale_version" value="Scale Version" />
                        <SelectField
                            v-model="form.scale_version"
                            :options="scaleVersions"
                            placeholder="-- Select Scale Version --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.scale_version" />
                    </div>
                    <div>
                        <InputLabel for="co_version" value="Course Outcome Version" />
                        <SelectField
                            v-model="form.co_version"
                            :options="coVersions"
                            placeholder="-- Select Course Outcome Version --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.co_version" />
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