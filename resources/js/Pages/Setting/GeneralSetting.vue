<script setup>
import { ref, watch, computed, nextTick } from 'vue'
import { Head, router, useForm } from '@inertiajs/vue3';
import { PlusIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue';
import Modal2 from '@/Components/Modal2.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import SelectField from '@/Components/SelectField.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification';

const toast = useToast();

const props = defineProps({
  semester_id: [String, Number],
  semesters: Array,
  setting_types: Object,
  courses: Array,
  curriculums: Array,
  po_versions: Array,
  settings: Array,
})

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

watch(selectedSemester, (newSemester) => {
  if (newSemester && newSemester !== props.semester_id) {
    router.get(route('general-setting.index', { semester_id: newSemester }), {}, { preserveScroll: true })
  }
})

const settingType = (key) => {
    return props.setting_types[key] ?? key
}

// normalize setting types { value, label } pairs
const settingTypeOptions = computed(() =>
  Object.entries(props.setting_types).map(([key, label]) => ({
    value: key,
    label: label,
  }))
)

// normalize courses
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_name} (${v.course_code})` }))
)

// CREATE
const showCreateModal = ref(false)
// form state
const form = useForm({
  semester_id: props.semester_id,
  type: '',
  course_id: '',
  curriculum_id: '',
  version: ''
})

// filter curriculums by selected course_id
const filteredCurriculumOptions = computed(() => {
  if (!form.course_id) return []
  return props.curriculums
    .filter(c => Number(c.course_id) === Number(form.course_id))
    .map(c => ({
      value: c.id,
      label: c.curr_name,
    }))
})

// filter PO versions by selected course_id
const filteredVersionOptions = computed(() => {
  if (!form.course_id) return []
  return props.po_versions
    .filter(v => Number(v.course_id) === Number(form.course_id))
    .map(v => ({
      value: v.version,
      label: `Version ${v.version}`,
    }))
})

// visibility controls
const showCurriculumSelect = computed(() => form.type === 'curriculum')
const showVersionSelect = computed(() => form.type === 'program-outcome')

watch(() => form.course_id, () => {
  form.curriculum_id = ''
  form.version = ''
})
watch(() => form.type, () => {
  form.curriculum_id = ''
  form.version = ''
})

watch(() => form.type, (newType) => {
  form.clearErrors('curriculum_id', 'version')

  form.curriculum_id = ''
  form.version = ''

  if (newType === 'curriculum') {
    // Curriculum-specific reset
    form.version = ''
  } else if (newType === 'program-outcome') {
    // Program Outcome-specific reset
    form.curriculum_id = ''
  }
})

const submit = () => {
    form.post(route('general-setting.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('type', 'course_id', 'curriculum_id', 'version')
            toast.success('Setting successfully saved!', 'Success')
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
const currentSetting = ref(null)
const editForm = useForm({
    semester_id: props.semester_id,
    id: '',
    type: '',
    course_id: '',
    curriculum_id: '',
    version: ''
})

// filters for EDIT modal
const filteredEditCurriculumOptions = computed(() => {
  if (!editForm.course_id) return []
  return props.curriculums
    .filter(c => Number(c.course_id) === Number(editForm.course_id))
    .map(c => ({ value: c.id, label: c.curr_name }))
})

const filteredEditVersionOptions = computed(() => {
  if (!editForm.course_id) return []
  return props.po_versions
    .filter(v => Number(v.course_id) === Number(editForm.course_id))
    .map(v => ({ value: v.version, label: `Version ${v.version}` }))
})

const showEditCurriculumSelect = computed(() => editForm.type === 'curriculum')
const showEditVersionSelect = computed(() => editForm.type === 'program-outcome')

// watch(() => editForm.course_id, () => {
//   editForm.curriculum_id = ''
//   editForm.version = ''
// })
// watch(() => editForm.type, () => {
//   editForm.curriculum_id = ''
//   editForm.version = ''
// })

// watch(() => editForm.type, (newType) => {
//   editForm.clearErrors('curriculum_id', 'version')

//   editForm.curriculum_id = ''
//   editForm.version = ''

//   if (newType === 'curriculum') {
//     editForm.version = ''
//   } else if (newType === 'program-outcome') {
//     editForm.curriculum_id = ''
//   }
// })

// open edit modal and fill form
const openEditModal = (setting) => {
    currentSetting.value = setting
    showEditModal.value = true
    nextTick(() => {
        editForm.semester_id = setting.semester_id
        editForm.type = setting.type
        editForm.course_id = setting.course_id
        editForm.curriculum_id = setting.curriculum_id
        editForm.version = setting.version
    })
}

// handle update
const update = () => {
  editForm.post(route('general-setting.update', currentSetting.value.id), {
    preserveScroll: true,
    onSuccess: () => {
      showEditModal.value = false
      toast.success('Setting updated successfully!')
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
    <Head title="General Setting" />

    <AdminLayout>
        <template #header>General Setting</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">Manage General Setting</h2>
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
                            <th>Type</th>
                            <th>Cirruculum</th>
                            <th>Version</th>
                            <th>Program</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                            <template v-if="settings.length > 0">
                                <tr v-for="setting in settings" :key="setting.id">
                                    <td>{{ settingType(setting.type) }}</td>
                                    <td>
                                        <span v-if="setting.type==='curriculum'">{{ setting.curr_name }}</span>
                                        <span v-else>-x-</span>
                                    </td>
                                    <td>
                                        <span v-if="setting.type==='program-outcome'">{{ setting.version }}</span>
                                        <span v-else>-x-</span>
                                    </td>
                                    <td>{{ setting.course_name }} ({{ setting.course_code }})</td>
                                    <td>
                                        <button 
                                            type="button" 
                                            class="hover:text-green-600 mr-2" 
                                            title="EDIT"
                                            @click="openEditModal(setting)"
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
                    <div>
                        <InputLabel for="type" value="Setting Type" />
                        <SelectField
                            v-model="form.type"
                            :options="settingTypeOptions"
                            placeholder="-- Please select type --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.type" />
                    </div>

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

                    <!-- Curriculum -->
                    <div v-if="showCurriculumSelect">
                        <InputLabel for="curriculum_id" value="Curriculum" />
                        <SelectField
                            v-model="form.curriculum_id"
                            :options="filteredCurriculumOptions"
                            placeholder="-- Please select curriculum --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.curriculum_id" />
                    </div>

                    <!-- Program Outcome Version -->
                    <div v-if="showVersionSelect">
                        <InputLabel for="version" value="P.O. Version" />
                        <SelectField
                            v-model="form.version"
                            :options="filteredVersionOptions"
                            placeholder="-- Please select version --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="form.errors.version" />
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
                <h2 class="text-lg font-medium text-gray-900 mb-4">Edit Setting</h2>

                <div class="space-y-4">
                    <div>
                        <InputLabel for="type" value="Setting Type" />
                        <SelectField
                            v-model="editForm.type"
                            :options="settingTypeOptions"
                            placeholder="-- Please select type --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.type" />
                    </div>

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

                    <!-- Curriculum -->
                    <div v-if="showEditCurriculumSelect">
                        <InputLabel for="curriculum_id" value="Curriculum" />
                        <SelectField
                            v-model="editForm.curriculum_id"
                            :options="filteredEditCurriculumOptions"
                            placeholder="-- Please select curriculum --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.curriculum_id" />
                    </div>

                    <!-- Program Outcome Version -->
                    <div v-if="showEditVersionSelect">
                        <InputLabel for="version" value="P.O. Version" />
                        <SelectField
                            v-model="editForm.version"
                            :options="filteredEditVersionOptions"
                            placeholder="-- Please select version --"
                            class="mt-1 block w-full"
                        />
                        <InputError class="mt-2" :message="editForm.errors.version" />
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