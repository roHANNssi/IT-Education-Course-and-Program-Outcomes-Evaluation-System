<script setup>
import { Head, router } from '@inertiajs/vue3';
import { EyeIcon } from '@heroicons/vue/24/outline'
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({
  programs: Array,
})

</script>
<template>
    <Head title="Rating Setting" />

    <AdminLayout>
        <template #header>Rating Setting</template>

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
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Program</th>
                            <th class="w-[400px]">Curriculum</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr valign="top" v-for="program in props.programs" :key="program.id">
                                <td>
                                    {{ program.course_name }} ({{ program.course_code }})
                                </td>
                                <td>
                                    <strong>{{ program.curr_name }}</strong>
                                    <p class="text-sm text-gray-700">{{ program.curr_detail }}</p>
                                </td>
                                <td>
                                    <div class="flex">
                                        <button type="button" class="flex justify-center btn-green"
                                            @click="router.get(route('rating-setting.show', {curriculum_id: program.curriculum_id}))"
                                        >
                                            <EyeIcon class="w-6 h-6 shrink-0 mr-0"></EyeIcon>
                                            <span>View Settings</span>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>