import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Figtree', ...defaultTheme.fontFamily.sans],
            },
            zIndex: {
                'dropdown': 1000,
                'sticky': 1020,
                'fixed': 1030,
                'modal-backdrop': 1040,
                'modal': 1050,
                'offcanvas': 1060,
                'toast': 1100,
                'tooltip': 1200,
            },
        },
    },

    plugins: [forms],
};
