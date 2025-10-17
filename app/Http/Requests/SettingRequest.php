<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use App\Models\Setting;

class SettingRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize()
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $base = [
            'type' => 'required|string|max:255',
            'semester_id' => 'required|integer|exists:semesters,id',
        ];

        $type = $this->input('type');

        $typeRules = Setting::typeValidationRules()[$type] ?? [];

        return array_merge($base, $typeRules);
    }

    public function withValidator($validator)
    {
        $validator->after(function ($validator) {
            $query = Setting::where('type', $this->type)
                ->where('semester_id', $this->semester_id)
                ->where('course_id', $this->course_id);

            if ($this->type === 'curriculum') {
                $query->where('curriculum_id', $this->curriculum_id);
            } elseif ($this->type === 'program-outcome') {
                $query->where('version', $this->version);
            }

            // For update requests, exclude current record
            if ($this->route('id')) {
                $query->where('id', '!=', $this->route('id'));
            }

            if ($query->exists()) {
                $validator->errors()->add('duplicate', 'A setting with this combination already exists.');
            }
        });
    }

    public function messages()
    {
        return [
            'type.required' => 'Please select a setting type.',
            'semester_id.required' => 'Semester is required.',
            'course_id.required' => 'Course is required.',
            'curriculum_id.required' => 'Curriculum is required for this type.',
            'version.required' => 'Version is required for program outcomes.',
        ];
    }
}
