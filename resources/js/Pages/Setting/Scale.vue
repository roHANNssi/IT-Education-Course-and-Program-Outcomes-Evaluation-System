<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { PlusIcon, PlusCircleIcon, PencilSquareIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DropdownCustom from '@/Components/DropdownCustom.vue'
import Modal2 from '@/Components/Modal2.vue'
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import { useToast } from 'vue-toastification'

const page = usePage()
const toast = useToast();

const props = defineProps({
  version: [String, Number],
  versions: Array, // e.g. [{ id: 1, version: "2024" }]
  scales: Array,
  new_version: [String, Number],
})

// normalize versions
const versionOptions = computed(() =>
  props.versions.map(v => ({ value: v.version, label: `Version ${v.version}` }))
)

// track backend-provided version
const selectedVersion = ref(props.version ?? '')

// navigate when version changes
watch(selectedVersion, (newVersion) => {
  if (newVersion && newVersion !== props.version) {
    router.get(route('scales.index', { version: newVersion }), {}, { preserveScroll: true })
  }
})

// track modal visibility
const showCreateModal = ref(false)
const createMode = ref('current')
const showEditModal = ref(false)
const currentScale = ref(null)

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }
});

// form state
const form = useForm({
  version: props.version,
  rating: '',
  descriptive_rating: ''
})

const editForm = useForm({
  rating: '',
  descriptive_rating: '',
})

// open edit modal and fill form
const openEditModal = (scale) => {
  currentScale.value = scale
  editForm.rating = scale.rating
  editForm.descriptive_rating = scale.descriptive_rating
  showEditModal.value = true
}

// handle submit
const submit = () => {
    const sv = createMode.value === 'current' ? props.version : props.new_version
    form.version = sv
    form.post(route('scales.store'), {
        preserveScroll: true,
        onSuccess: () => {
            showCreateModal.value = false
            form.reset('rating', 'descriptive_rating')
            // success message comes from Laravel flash
            // if (page.props.flash?.success) {
                toast.success('Scale successfully saved!', 'Success')

                if (createMode.value === 'new') {
                    router.get(
                    route('scales.index', { 
                        version: sv
                    }),
                    {},
                    { preserveScroll: true }
                    )
                }
            // }
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
};

const submitEdit = () => {
    editForm.post(route('scales.update', currentScale.value.id), {
        preserveScroll: true,
        onSuccess: () => {
            showEditModal.value = false
            editForm.reset('rating', 'descriptive_rating')
            // success message comes from Laravel flash
            // if (page.props.flash?.success) {
                toast.success('Scale successfully updated!', 'Success')
            // }
        },
        onError: () => {
            // form.errors will already be populated and bound to <InputError>
            toast.error('Please fix the errors and try again.', 'Validation Error')
        }
    });
}
</script>

<template>
  <Head title="Scales" />
  <AdminLayout>
    <template #header>Scales</template>

    <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg">
      <div class="p-6 text-gray-900">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2">
          <!-- Title + Dropdown -->
          <div class="col-span-1 flex items-center space-x-3">
            <h2 class="font-semibold text-lg text-gray-800">List of Scales:</h2>
            <DropdownCustom
              v-model="selectedVersion"
              :options="versionOptions"
              label="Select Version"
            />
          </div>

          <!-- Add New -->
          <div class="col-span-1 flex justify-end">
            <!-- <UtilityLink :href="route('scales.create')">
              <PlusCircleIcon class="w-4 h-4 shrink-0" />
              <span>Add New</span>
            </UtilityLink> -->

            <button
                v-if="props.version && props.versions.length > 0" 
                @click="() => { createMode = 'current'; showCreateModal = true }"
                class="btn-outline-green mr-2"
            >
                <PlusIcon class="w-4 h-4 shrink-0" />
                <span>Add New</span>
            </button>

            <button
                v-if="props.new_version !== null" 
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
                <th>Rating</th>
                <th>Descriptive Rating</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="scale in props.scales" :key="scale.id">
                <td>{{ scale.rating }}</td>
                <td>{{ scale.descriptive_rating }}</td>
                <td>
                  <button 
                      type="button" 
                      class="hover:text-green-600" 
                      title="EDIT"
                      @click="openEditModal(scale)"
                  >
                      <PencilSquareIcon class="w-6 h-6 shrink-0"/>
                  </button>
                </td>
              </tr>
              <tr v-if="scales.length === 0">
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
            Create Scale for
            <u>
                {{ createMode === 'current'
                    ? `Version ${props.version}`
                    : `New Version ${props.new_version}`
                }}
            </u>
            </h2>

            <div class="space-y-4">
              <div>
                  <InputLabel for="rating" value="Rating" />
                  <TextInput
                      id="rating"
                      type="number"
                      class="mt-1 block w-full"
                      v-model.number="form.rating"
                      required
                      autofocus
                  />
                  <InputError class="mt-2" :message="form.errors.rating" />
              </div>

              <div>
                  <InputLabel for="descriptive_rating" value="Descriptive Rating" />
                  <TextInput
                      id="descriptive_rating"
                      type="text"
                      class="mt-1 block w-full"
                      v-model="form.descriptive_rating"
                      required
                      autofocus
                  />
                  <InputError class="mt-2" :message="form.errors.descriptive_rating" />
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

    <!-- Modal edit scale -->
    <Modal2 :show="showEditModal" @close="showEditModal = false">
      <form @submit.prevent="submitEdit">
        <div class="p-6">
            <h2 class="text-lg font-medium text-gray-900 mb-4">
            Edit Scale - Version: {{ props.version }}
            </h2>

            <div class="space-y-4">
              <div>
                  <InputLabel for="rating" value="Rating" />
                  <TextInput
                      id="rating"
                      type="number"
                      class="mt-1 block w-full"
                      v-model.number="editForm.rating"
                      readonly
                      autofocus
                  />
                  <InputError class="mt-2" :message="editForm.errors.rating" />
              </div>

              <div>
                  <InputLabel for="descriptive_rating" value="Descriptive Rating" />
                  <TextInput
                      id="descriptive_rating"
                      type="text"
                      class="mt-1 block w-full"
                      v-model="editForm.descriptive_rating"
                      required
                      autofocus
                  />
                  <InputError class="mt-2" :message="editForm.errors.descriptive_rating" />
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
                    Update
                </PrimaryButton>
            </div>
        </div>
      </form>
    </Modal2>
</template>
