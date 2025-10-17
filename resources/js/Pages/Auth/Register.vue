<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import SelectField from '@/Components/SelectField.vue';
import { ref, computed } from 'vue'
import { Head, Link, useForm, router, usePage } from '@inertiajs/vue3';
import { RocketLaunchIcon, CheckCircleIcon  } from '@heroicons/vue/24/outline';
import { useToast } from 'vue-toastification';

const page = usePage()
const toast = useToast();

const props = defineProps({
    courses: Array,
})

const courseOptions = computed(() =>
  props.courses.map(v => ({ value: v.id, label: `${v.course_name} (${v.course_code})` }))
)

const form = useForm({
    id_number: '',
    course_id: '',
    last_name: '',
    first_name: '',
    mid_name: '',
    name_ext: '',
    email: '',
    password: '',
    password_confirmation: '',
});

const verified = ref(false);
const verifying = ref(false);

const verifyId = async () => {
    verifying.value = true;
    try {
        const { data } = await axios.post(route('verify-id'), {
            id_number: form.id_number,
        });

        if (data.success) {
            verified.value = true;
            const student = data.student;
            form.last_name = student.last_name;
            form.first_name = student.first_name;
            form.mid_name = student.mid_name;
            form.name_ext = student.name_ext;
            form.email = student.email;

            toast.success('ID Number verified successfully!');
        }
    } catch (error) {
        verified.value = false;
        toast.error(
            error.response?.data?.message || 'Invalid ID Number.'
        );
    } finally {
        verifying.value = false;
    }
};

const submit = () => {
    if (!verified.value) {
        toast.error('Please verify your ID number first.');
        return;
    }
    form.post(route('register'), {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Register" />

        <form @submit.prevent="submit">
            <div>
                <InputLabel for="id_number" value="ID Number (click Verify button after entering ID Number)" />

                <div class="flex gap-2">
                    <TextInput
                        id="id_number"
                        type="text"
                        class="mt-1 block w-full"
                        v-model="form.id_number"
                        required
                        autofocus
                        autocomplete="id_number"
                        placeholder="e.g. 25B0001"
                    />
                    <button
                        type="button"
                        class="btn-outline-green !py-2"
                        @click="verifyId"
                        :disabled="verifying || !form.id_number"
                    >
                        <CheckCircleIcon v-if="verified" class="w-4 h-4 mr-1 text-green-500"/>
                        {{ verified ? 'Verified' : verifying ? 'Verifying...' : 'Verify' }}
                    </button>
                </div>

                <InputError class="mt-2" :message="form.errors.id_number" />
            </div>

            <div class="mt-4">
                <InputLabel for="course_id" value="Program" />
                <SelectField
                    v-model="form.course_id"
                    :options="courseOptions"
                    placeholder="-Please select Program-"
                    class="mt-1 block w-full"
                    :disabled="!verified"
                />
                <InputError class="mt-2" :message="form.errors.course_id" />
            </div>

            <div class="mt-4">
                <InputLabel for="last_name" value="Last Name" />

                <TextInput
                    id="last_name"
                    type="text"
                    class="mt-1 block w-full"
                    v-model="form.last_name"
                    required
                    autocomplete="last_name"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.last_name" />
            </div>

            <div class="mt-4">
                <InputLabel for="first_name" value="First Name" />

                <TextInput
                    id="first_name"
                    type="text"
                    class="mt-1 block w-full"
                    v-model="form.first_name"
                    required
                    autocomplete="first_name"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.first_name" />
            </div>

            <div class="mt-4">
                <InputLabel for="mid_name" value="Middle Name/ M.I." />

                <TextInput
                    id="mid_name"
                    type="text"
                    class="mt-1 block w-full"
                    v-model="form.mid_name"
                    required
                    autocomplete="mid_name"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.mid_name" />
            </div>

            <div class="mt-4">
                <InputLabel for="name_ext" value="Name Extension (if applicable)" />

                <TextInput
                    id="name_ext"
                    type="text"
                    class="mt-1 block w-full"
                    v-model="form.name_ext"
                    autocomplete="name_ext"
                    placeholder="e.g. Jr, Sr, II"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.name_ext" />
            </div>

            <div class="mt-4">
                <InputLabel for="email" value="Email" />

                <TextInput
                    id="email"
                    type="email"
                    class="mt-1 block w-full"
                    v-model="form.email"
                    required
                    autocomplete="username"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.email" />
            </div>

            <div class="mt-4">
                <InputLabel for="password" value="Password" />

                <TextInput
                    id="password"
                    type="password"
                    class="mt-1 block w-full"
                    v-model="form.password"
                    required
                    autocomplete="new-password"
                    :disabled="!verified"
                />

                <InputError class="mt-2" :message="form.errors.password" />
            </div>

            <div class="mt-4">
                <InputLabel
                    for="password_confirmation"
                    value="Confirm Password"
                />

                <TextInput
                    id="password_confirmation"
                    type="password"
                    class="mt-1 block w-full"
                    v-model="form.password_confirmation"
                    required
                    autocomplete="new-password"
                    :disabled="!verified"
                />

                <InputError
                    class="mt-2"
                    :message="form.errors.password_confirmation"
                />
            </div>

            <div class="mt-4 flex items-center justify-end">
                <Link
                    :href="route('login')"
                    class="rounded-md text-sm text-gray-600 underline hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                >
                    Already registered?
                </Link>

                <PrimaryButton
                    class="ms-4"
                    :class="{ 'opacity-25': form.processing }"
                    :disabled="form.processing || !verified"
                >
                    <RocketLaunchIcon class="w-4 h-4 shrink-0 mr-1" />
                    Register
                </PrimaryButton>
            </div>
        </form>
    </GuestLayout>
</template>
