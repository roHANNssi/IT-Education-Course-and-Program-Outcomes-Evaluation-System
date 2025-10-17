<script setup>
import { ref, watch, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { Head, router } from '@inertiajs/vue3';
import { PrinterIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';
import DropdownCustom from '@/Components/DropdownCustom.vue'
import { Chart, registerables } from 'chart.js';
import SecondaryButton from '@/Components/SecondaryButton.vue';

Chart.register(...registerables)

const props = defineProps({
  semester_id: [Number, String],
  course_id: [Number, String],
  semesters: Array,
  courses: Array,
  report: Object,
})

const selectedSemester = ref(props.semester_id ?? '')
const semesterOptions = computed(() =>
  props.semesters.map(v => ({ value: v.id, label: `${v.sem} Semester, A.Y. ${v.acad_year} ${v.status==='active' ? ' (Current Sem)' : ''}` }))
)

const selectedCourse = ref(props.course_id ?? '')
const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_name} (${v.course_code})` }))
)

watch(selectedSemester, (newSemester) => {
  if (newSemester && newSemester !== props.semester_id) {
    router.get(route('reports.po-assessment-result.index', { semester_id: newSemester, course_id: props.course_id }), {}, { preserveScroll: true })
  }
})

watch(selectedCourse, (newCourse) => {
  if (newCourse && newCourse !== props.course_id) {
    router.get(route('reports.po-assessment-result.index', { semester_id: props.semester_id, course_id: newCourse }), {}, { preserveScroll: true })
  }
})

// Chart.js setup
const chartRefs = ref([])
let chartInstances = []

const setChartRef = (index) => (el) => {
  if (!chartRefs.value) chartRefs.value = []
  chartRefs.value[index] = el
}

// Colors for satisfaction categories
const satisfactionColors = {
  'Very Satisfied': '#2563eb', // blue
  'Satisfied': '#f97316', // orange
  'Neutral': '#9ca3af', // gray
  'Dissatisfied': '#facc15', // yellow
  'Very Dissatisfied': '#ef4444' // red
}

const renderCharts = async () => {
  await nextTick()

  // Destroy previous charts
  chartInstances.forEach(chart => chart.destroy())
  chartInstances = []

  // Create one pie per PO
  props.report.forEach((po, index) => {
    const canvas = chartRefs.value[index]
    if (!canvas) return

    const distribution = po.distribution ?? {}

    const labels = Object.keys(distribution)
    const data = Object.values(distribution)
    const backgroundColors = labels.map(l => satisfactionColors[l] || '#ccc')

    const chart = new Chart(canvas, {
      type: 'pie',
      data: {
        labels,
        datasets: [
          {
            data,
            backgroundColor: backgroundColors,
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'right',
          },
          title: {
            display: true,
            text: `${po.po_code}`,
            font: { size: 16 },
          },
          tooltip: {
            callbacks: {
              label: (context) => `${context.label}: ${context.raw}%`,
            },
          },
        },
      },
    })

    chartInstances.push(chart)
  })
}

onMounted(() => renderCharts())
watch(() => props.report, renderCharts, { deep: true })

const exportToPDF = async () => {
  // Capture each chart as base64 image
  const chartsData = props.report.map((po, i) => {
    const chartCanvas = chartRefs.value[i]
    const chartImage = chartCanvas ? chartCanvas.toDataURL('image/png') : null
    return { ...po, chart_image: chartImage }
  })

  const course = courseOptions.value.find(c => c.value === selectedCourse.value)?.label
  const semester = semesterOptions.value.find(s => s.value === selectedSemester.value)?.label

  await router.post(route('reports.po-assessment-result.export'), {
    report: chartsData,
    course_name: course,
    semester_name: semester,
  })
}
</script>
<template>
    <Head title="Reports - PO Assessment Results" />

    <AdminLayout>
        <template #header>Reports - PO Assessment Results</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                  <!-- Title + Dropdown -->
                  <div class="col-span-1 flex items-center space-x-3">
                      <h2 class="font-semibold text-lg text-gray-800">Program Outcome Assessment Results</h2>
                  </div>

                  <div class="col-span-1 flex justify-end">
                    <SecondaryButton
                        @click="exportToPDF"
                        class="!px-2 !py-1"
                    >
                        <PrinterIcon class="w-6 h-6 shrink-0 mr-1" />
                        Export to PDF
                    </SecondaryButton>
                  </div>

                  <div class="col-span-2 flex items-center space-x-3">
                      <DropdownCustom
                          v-model="selectedSemester"
                          :options="semesterOptions"
                          label="Select Semester"
                          width="!w-full"
                      />
                      <DropdownCustom
                          v-model="selectedCourse"
                          :options="courseOptions"
                          label="Select Course"
                          width="!w-full"
                      />
                  </div>

                  <div class="col-span-2 mt-8 space-y-10">
                    <template v-for="(po, index) in props.report" :key="po.po_code">
                      <div class="bg-white p-5 rounded-lg shadow-md">
                        <h3 class="text-lg font-semibold text-gray-800 mb-2">
                          {{ po.po_code }} — {{ po.po_description }}
                        </h3>
                        <p class="text-sm text-gray-600 mb-4">
                          Mean Rating: <b>{{ po.mean_rating }}</b> • Adjectival: <b>{{ po.adjectival }}</b> • Responses: {{ po.responses }}
                        </p>
                        <div class="flex flex-col md:flex-row items-center justify-between gap-6">
                          <div class="w-full md:w-1/2">
                            <div v-if="po.responses > 0">
                              <canvas :ref="setChartRef(index)" height="160"></canvas>
                            </div>
                            <p v-else class="text-gray-500 italic text-sm">No evaluations recorded for this Program Outcome yet.</p>
                          </div>
                          <div class="w-full md:w-1/2">
                            <table class="w-full text-sm border">
                              <thead class="bg-gray-100">
                                <tr>
                                  <th class="p-2 border">Satisfaction</th>
                                  <th class="p-2 border">Percentage</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr v-for="(percent, category) in po.distribution" :key="category">
                                  <td class="p-2 border">{{ category }}</td>
                                  <td class="p-2 border text-right">{{ percent }}%</td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        </div>
                        <p class="text-xs text-center text-gray-500 mt-3 italic">
                          Figure: Percentage of students’ satisfaction rating for {{ po.po_code }}
                        </p>
                      </div>
                    </template>
                    <div v-if="props.report.length == 0" >
                      <h4 class="flex items-center text-gray-500">No data found.</h4>
                    </div>
                  </div>
              </div>
            </div>
        </div>
    </AdminLayout>
</template>