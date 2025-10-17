<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { CheckIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import SecondaryButton from '@/Components/SecondaryButton.vue'
import InputLabel from '@/Components/InputLabel.vue'
import TextareaField from '@/Components/TextareaField.vue'
import InputError from '@/Components/InputError.vue'
import Modal2 from '@/Components/Modal2.vue'
import { useToast } from 'vue-toastification'

const page = usePage()
const toast = useToast()

onMounted(() => {
    if (page.props.flash?.success) {
        toast.success(page.props.flash?.success, 'Success')
    }

    if (page.props.flash?.error) {
      toast.error(page.props.flash.error, 'Access Denied')
    }
});

const props = defineProps({
  enrollment_id: [String, Number],
  enrollment: Object,
  subjects: Array,
  scales: Array,
  active_schedule: Object,
})

const hasCourseOutcomes = computed(() => {
  return props.subjects.some(subject => subject.course_outcomes && subject.course_outcomes.length > 0)
})

const form = useForm({
  enrollment_id: props.enrollment_id,
  evaluations: [], // { subject_id, course_outcome_id, rating, rating_setting_id }
  comments: []
})

// Sync evaluations whenever subjects change
watch(
  () => props.subjects,
  (subjects) => {
    const newEvaluations = []
    const newComments = []

    subjects.forEach(subject => {
      subject.course_outcomes.forEach(co => {
        newEvaluations.push({
          subject_id: subject.id,
          course_outcome_id: co.id,
          enrolled_subject_id: subject.enrolled_subject_id,
          rating_setting_id: subject.rating_setting?.id ?? null,
          rating: form.evaluations.find(ev => ev.course_outcome_id === co.id)?.rating ?? null,
          comment: form.evaluations.find(ev => ev.course_outcome_id === co.id)?.comment ?? ''
        })
      })

      // comments
      newComments.push({
        subject_id: subject.id,
        enrolled_subject_id: subject.enrolled_subject_id,
        comment: form.comments.find(c => c.subject_id === subject.id)?.comment ?? ''
      })
    })

    form.evaluations = newEvaluations
    form.comments = newComments
  },
  { immediate: true, deep: true }
)

const getEvaluationIndex = (coId) => {
  return form.evaluations.findIndex(ev => ev.course_outcome_id === coId)
}

// helper to fetch correct evaluation
const getEvaluation = (coId) => {
  return form.evaluations.find(ev => ev.course_outcome_id === coId)
}

const getComment = (subjectId) => form.comments.find(c => c.subject_id === subjectId)

// const getComment = (subjectId) => {
//   const commentObj = form.comments.find(c => c.subject_id === subjectId)
//   if (!commentObj) {
//     const newComment = { subject_id: subjectId, comment: '' }
//     form.comments.push(newComment)
//     return newComment
//   }
//   return commentObj
// }

const hasError = (coId) => {
  const idx = getEvaluationIndex(coId)
  return form.errors[`evaluations.${idx}.rating`] !== undefined
}

const allRated = computed(() => {
  return form.evaluations.every(ev => ev.rating !== null)
})

const progressPercent = computed(() => {
  if (form.evaluations.length === 0) return 0
  const completed = form.evaluations.filter(ev => ev.rating !== null).length
  return Math.round((completed / form.evaluations.length) * 100)
})

const showCancelModal = ref(false)
const stayButton = ref(null)

const confirmCancel = () => {
  router.get(route('dashboard'))
}

watch(showCancelModal, (isOpen) => {
  if (isOpen) {
    // Delay a bit so modal renders before focusing
    setTimeout(() => {
      stayButton.value?.$el?.focus?.()
    }, 50)
  }
})

const submit = () => {
    form.post(route('evaluation.store'), {
        preserveScroll: true,
        onSuccess: () => {
            toast.success('Evaluation successfully submitted!', 'Success')
            form.reset('evaluations')
            router.get(
            route('dashboard'),
            {},
            { preserveScroll: true }
            )
        },
        onError: () => {
            toast.error('Please fix the errors and try again.', 'Validation Error')

            // Find first error field and scroll into view
            const firstErrorKey = Object.keys(form.errors)[0]
            if (firstErrorKey) {
              const el = document.querySelector(`[id*="${firstErrorKey.replace(/\./g, '_')}"]`)
              if (el) el.scrollIntoView({ behavior: 'smooth', block: 'center' })
            }
        }
    })
}

const handleKeyDown = (e) => {
  if (e.key === 'Escape' && showCancelModal.value) {
    showCancelModal.value = false
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeyDown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown)
})
</script>

<template>
  <Head title="Evaluate" />

  <AuthenticatedLayout>
    <template #header>
      Evaluate >
      <i class="text-green-700">
        {{ props.enrollment.sem + ' Semester, A.Y. ' + props.enrollment.acad_year }}
        - {{ props.enrollment.year_level.toUpperCase() + ' YEAR' }}
      </i>
    </template>

    <!-- Floating Progress Bar -->
    <div class="sticky top-0 z-10 bg-white shadow mb-4 p-3 rounded-md">
      <div class="flex justify-between items-center mb-1">
        <span class="text-sm font-medium text-gray-700">Evaluation Progress</span>
        <span class="text-sm text-gray-600">{{ progressPercent }}%</span>
      </div>
      <div class="w-full bg-gray-200 rounded-full h-2.5">
        <div
          class="bg-green-600 h-2.5 rounded-full transition-all duration-500"
          :style="{ width: progressPercent + '%' }"
        ></div>
      </div>
      <p class="text-sm text-gray-600">
        Progress: {{ form.evaluations.filter(ev => ev.rating !== null).length }}
        / {{ form.evaluations.length }} outcomes completed
      </p>
    </div>

    <div class="col-span-1 overflow-hidden bg-white shadow-sm sm:rounded-lg">
      <div class="p-6 text-gray-900">
        <h3 class="font-semibold text-xl mb-2 uppercase">Subjects:</h3>

        <div v-if="props.active_schedule" class="mb-4 p-3 rounded-md bg-green-50 border border-green-300">
          <p class="text-sm text-green-800">
            Evaluation is open from
            <b>{{ props.active_schedule.start_date }}</b> to
            <b>{{ props.active_schedule.end_date }}</b>.
          </p>
        </div>

        <form @submit.prevent="submit">
          <div class="space-y-4">
            <template v-for="subject in props.subjects" :key="subject.id">
              <div class="p-4 border shadow-md sm:rounded-md bg-green-50">
                <p class="font-semibold text-lg italic">
                  {{ subject.subject_title }} ({{ subject.subject_code }})
                  <span v-if="subject.course_major !== null">
                    | Major: {{ subject.course_major }}
                  </span>
                </p>

                <!-- Course Outcomes -->
                <template
                  v-if="subject.course_outcomes.length > 0"
                  v-for="course_outcome in subject.course_outcomes"
                  :key="course_outcome.id"
                >
                  <div
                    class="ml-6 mb-2 border-b"
                    :class="{ 'border-red-500 bg-red-50': hasError(course_outcome.id) }"
                    v-if="subject.rating_setting !== null
                      && subject.rating_setting.co_version === course_outcome.version"
                  >
                    <p>
                      <b>PO Links:</b>
                      <span v-if="course_outcome.outcome_links.length > 0">
                        &nbsp;{{ course_outcome.outcome_links.map(link => link.po_code).join(', ') }}
                      </span>
                    </p>
                    <p>
                      <b>Course Outcome {{ course_outcome.order_no }}:</b>
                      {{ course_outcome.course_outcome }}
                    </p>

                    <!-- Rating Scales -->
                    <div class="ml-6 mb-2">
                      <template v-for="scale in props.scales" :key="scale.id">
                        <div
                          class="text-[13px] !mt-2 !leading-3 text-justify"
                          v-if="scale.version === subject.rating_setting.scale_version"
                        >
                            <input
                                type="radio"
                                :id="`scale_${course_outcome.id}_${scale.id}`"
                                :value="scale.rating"
                                v-model="getEvaluation(course_outcome.id).rating"
                            />
                            <label
                                :for="`scale_${course_outcome.id}_${scale.id}`"
                                class="ml-1"
                            >
                                <b>{{ scale.rating }}</b> - {{ scale.descriptive_rating }}
                            </label>
                        </div>
                      </template>
                      <InputError class="mt-2" :message="form.errors[`evaluations.${getEvaluationIndex(course_outcome.id)}.rating`]" />
                    </div>
                    <!-- <div class="ml-6 mb-2">
                      <InputLabel :for="`comment_${course_outcome.id}`" value="Comments" />
                      <TextareaField
                        :id="`comment_${course_outcome.id}`"
                        class="mt-1 block w-full"
                        rows="3"
                        placeholder="Enter your comment here..."
                        v-model="getEvaluation(course_outcome.id).comment"
                      />
                      <InputError
                        class="mt-2"
                        :message="form.errors[`evaluations.${getEvaluationIndex(course_outcome.id)}.comment`]"
                      />
                    </div> -->
                  </div>
                </template>

                <!-- Subject-level comment -->
                <div class="mt-4 ml-4">
                  <InputLabel :for="`comment_${subject.id}`" value="Overall Comments" />
                  <TextareaField
                    :id="`comment_${subject.id}`"
                    class="mt-1 block w-full"
                    rows="3"
                    placeholder="Enter your overall comment for this subject..."
                    v-model="getComment(subject.id).comment"
                  />
                  <InputError
                    class="mt-2"
                    :message="form.errors[`comments.${props.subjects.findIndex(s => s.id === subject.id)}.comment`]"
                  />
                </div>

                <span
                  class="flex justify-left text-red-500"
                  v-if="subject.course_outcomes.length === 0"
                >
                  No course outcomes found.
                </span>
              </div>
            </template>

            <span
              class="flex justify-center text-red-500"
              v-if="subjects.length === 0"
            >
              No subjects enrolled found.
            </span>
          </div>

          <!-- Action Buttons -->
          <div class="mt-6 flex justify-end space-x-2">
            <SecondaryButton
              type="button"
              @click="showCancelModal = true"
            >
              <XMarkIcon class="w-4 h-4 shrink-0 mr-1" />
              Cancel
            </SecondaryButton>

            <PrimaryButton
              class="ms-4 disabled:opacity-50"
              :class="{ 'opacity-25': form.processing }"
              :disabled="form.processing || !allRated || !hasCourseOutcomes"
            >
              <CheckIcon class="w-4 h-4 shrink-0 mr-1" />
              Submit Evaluation
            </PrimaryButton>
          </div>
          <p v-if="!hasCourseOutcomes" class="text-red-500 text-sm mt-2 text-right">
            Cannot submit — no course outcomes available for evaluation.
          </p>
        </form>
      </div>
    </div>

    <Modal2 :show="showCancelModal" @close="showCancelModal = false">
      <div class="p-6">
        <h2 class="text-lg font-semibold text-gray-800 mb-4">
          Cancel Evaluation
        </h2>
        <p class="text-sm text-gray-600 mb-6">
          Are you sure you want to cancel? Your progress will be lost.
        </p>

        <div class="flex justify-end space-x-2">
          <SecondaryButton ref="stayButton" @click="showCancelModal = false">
            <XMarkIcon class="w-4 h-4 shrink-0 mr-1" />
            No, Stay
          </SecondaryButton>
          <PrimaryButton @click="confirmCancel">
            <CheckIcon class="w-4 h-4 shrink-0 mr-1" />
            Yes, Cancel
          </PrimaryButton>
        </div>
      </div>
    </Modal2>
  </AuthenticatedLayout>
</template>
