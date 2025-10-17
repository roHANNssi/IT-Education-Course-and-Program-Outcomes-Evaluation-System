<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ProgramOutcome extends Model
{
    protected $fillable = ['course_id', 'version', 'po_code', 'po_description', 'order_number', 'status'];

    public function outcome_links()
    {
        return $this->hasMany(OutcomeLink::class, 'program_outcome_id');
    }

    public function courseOutcomes()
    {
        return $this->hasManyThrough(
            CourseOutcome::class,
            OutcomeLink::class,
            'program_outcome_id', // foreign key on outcome_links
            'id',                 // foreign key on course_outcomes
            'id',                 // local key on program_outcomes
            'course_outcome_id'   // local key on outcome_links
        );
    }

    public function getVersion($course_id, $vtype = 'new')
    {
        $program_outcome = $this->select('version')->where('course_id', $course_id)->orderBy('version', 'DESC')->first();
        if ($vtype == 'latest') {
            if (!empty($program_outcome)) {
                return $program_outcome->version;
            } else {
                return null;
            }
        } else {
            if (!empty($program_outcome)) {
                return $program_outcome->version + 1;
            } else {
                return 1;
            }
        }
    }

    public function getVersions()
    {
        $po_versions = $this->select('course_id', 'version')->groupBy('course_id')->groupBy('version')->orderBy('version', 'ASC')->get();
        return $po_versions;
    }

    public static function generateAssessmentReport($semesterId, $courseId)
    {
        $programOutcomes = self::where('course_id', $courseId)
            ->with([
                'outcome_links.courseOutcome.evaluations' => function ($q) use ($semesterId) {
                    $q->where('semester_id', $semesterId);
                }
            ])
            ->get();

        $scales = \App\Models\Scale::orderByDesc('rating')->get();
        $results = [];

        foreach ($programOutcomes as $po) {
            $allRatings = collect();

            foreach ($po->outcome_links as $link) {
                if ($link->courseOutcome) {
                    $ratings = $link->courseOutcome->evaluations->pluck('rating');
                    $allRatings = $allRatings->merge($ratings);
                }
            }

            $distribution = [];
            foreach ($scales as $scale) {
                $distribution[$scale->descriptive_rating] = 0;
            }

            if ($allRatings->count() > 0) {
                $mean = round($allRatings->avg(), 2);

                // Count rating distribution
                foreach ($scales as $scale) {
                    $count = $allRatings->where(fn($r) => (int)$r === (int)$scale->rating)->count();
                    $percentage = round(($count / $allRatings->count()) * 100, 2);
                    $distribution[$scale->descriptive_rating] = $percentage;
                }

                // Determine adjectival
                $adjectival = $scales
                    ->first(fn($s) => $mean >= ($s->rating - 0.5))?->descriptive_rating ?? 'N/A';
            } else {
                $mean = 0;
                $adjectival = 'No Data Yet';
            }

            $results[] = [
                'po_code'        => $po->po_code,
                'po_description' => $po->po_description,
                'mean_rating'    => $mean,
                'adjectival'     => $adjectival,
                'responses'      => $allRatings->count(),
                'distribution'   => $distribution,
            ];
        }

        return collect($results)->sortBy('po_code')->values();
    }
    
}
