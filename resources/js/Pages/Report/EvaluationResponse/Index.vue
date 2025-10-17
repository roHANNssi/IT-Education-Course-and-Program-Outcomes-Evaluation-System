<script setup>
import { Head, router } from '@inertiajs/vue3';
import { EyeIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({
  programs: Array,
})
</script>
<template>
    <Head title="Reports - Evaluation Response" />

    <AdminLayout>
        <template #header>Reports - Evaluation Response</template>

        <div
            class="overflow-hidden bg-white shadow-sm sm:rounded-lg"
        >
            <div class="p-6 text-gray-900">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Title + Dropdown -->
                    <div class="col-span-1 flex items-center space-x-3">
                        <h2 class="font-semibold text-lg text-gray-800">Evaluation Reponse per Curriculum</h2>
                    </div>

                    <!-- Add New -->
                    <div class="col-span-1 flex justify-end">
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <template v-for="program in props.programs" :key="program.id">
                            <thead>
                                <tr>
                                    <th colspan="2">Program: <i>{{ program.course_name }} ({{ program.course_code }})</i></th>
                                </tr>
                                <tr>
                                    <th class="!py-1 uppercase">Curriculums:</th>
                                    <th class="!py-1 w-[200px]">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="program.curricula.length > 0" v-for="curriculum in program.curricula" :key="curriculum.id">
                                    <td>
                                        <strong>{{ curriculum.curr_name }}</strong>
                                        <p class="text-sm text-gray-700">{{ curriculum.curr_detail }}</p>
                                    </td>
                                    <td>
                                        <div class="flex">
                                            <button type="button" class="flex justify-center btn-green"
                                                @click="router.get(route('reports.evaluation-response.show', {curriculum_id: curriculum.id}))"
                                            >
                                                <EyeIcon class="w-6 h-6 shrink-0 mr-0"></EyeIcon>
                                                <span>View Reponse</span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr v-if="program.curricula.length === 0">
                                    <td colspan="2" class="flex justify-center text-gray-500"><i>No curriculums found at the moment.</i></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="!py-1 bg-green-200"></td>
                                </tr>
                            </tbody>
                        </template>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>