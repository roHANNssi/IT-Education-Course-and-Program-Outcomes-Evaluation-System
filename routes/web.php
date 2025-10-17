<?php

use App\Http\Controllers\CollegeController;
use App\Http\Controllers\CourseController;
use App\Http\Controllers\CourseMajorController;
use App\Http\Controllers\CourseOutcomeController;
use App\Http\Controllers\CurriculumController;
use App\Http\Controllers\CurriculumCourseController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\EvaluationScheduleController;
use App\Http\Controllers\FacultyController;
use App\Http\Controllers\FacultySubjectController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\SemesterController;
use App\Http\Controllers\ScaleController;
use App\Http\Controllers\StudentController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProgramOutcomeController;
use App\Http\Controllers\RatingSettingController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\Report\EvaluationReponseController;
use App\Http\Controllers\Report\POAssessmentResultController;
use App\Http\Controllers\Student\EvaluationController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome2', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        // 'laravelVersion' => Application::VERSION,
        // 'phpVersion' => PHP_VERSION,
    ]);
});

Route::post('/verify-id', [StudentController::class, 'verifyIDNumber'])->name('verify-id');

Route::get('/dashboard', [DashboardController::class, 'index'])->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::prefix('colleges')->name('colleges.')->group(function (){
        Route::controller(CollegeController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::get('create', 'create')->name('create');
            Route::get('edit/{id}', 'edit')->name('edit');
        });
    });

    Route::prefix('curriculums')->name('curriculums.')->group(function (){
        Route::controller(CurriculumController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });

        Route::prefix('courses')->name('courses.')->group(function (){
            Route::controller(CurriculumCourseController::class)->group(function (){
                Route::get('/', 'index')->name('index');
                Route::post('store', 'store')->name('store');
                Route::post('update/{id}', 'update')->name('update');
            });

            Route::prefix('course-outcomes')->name('course-outcomes.')->group(function (){
                Route::controller(CourseOutcomeController::class)->group(function (){
                    Route::get('/', 'index')->name('index'); //{subject_id}/{version?}
                    Route::post('store', 'store')->name('store');
                    Route::post('update/{id}', 'update')->name('update');
                    Route::post('destroy/{id}', 'destroy')->name('destroy');
                });
            });
        });
    });

    // Labaled as Programs
    Route::prefix('courses')->name('courses.')->group(function (){
        Route::controller(CourseController::class)->group(function (){
            Route::get('/{course_id?}', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    Route::prefix('course-majors')->name('course-majors.')->group(function (){
        Route::controller(CourseMajorController::class)->group(function (){
            Route::get('/{get_course_id?}', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    // Labeled as Courses
    Route::prefix('subjects')->name('subjects.')->group(function (){
        Route::controller(SubjectController::class)->group(function (){
            Route::get('/', 'index')->name('index'); //{course_id?}/{yr_level?}
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    Route::prefix('semesters')->name('semesters.')->group(function (){
        Route::controller(SemesterController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    Route::prefix('scales')->name('scales.')->group(function (){
        Route::controller(ScaleController::class)->group(function (){
            Route::get('/{version?}', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    Route::prefix('users')->name('users.')->group(function (){
        Route::controller(UserController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');

            Route::prefix('faculties')->name('faculties.')->group(function (){
                Route::controller(FacultyController::class)->group(function (){
                    Route::get('/designation-logs/{user_id}', 'designationLogs')->name('designationLogs');
                    Route::post('store-designation', 'storeDesignation')->name('storeDesignation');
                    Route::post('update-designation/{id}', 'updateDesignation')->name('updateDesignation');
                });
            });
        });
    });

    Route::prefix('evaluation-schedules')->name('evaluation-schedules.')->group(function (){
        Route::controller(EvaluationScheduleController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    // Program Head Account
    Route::prefix('faculty-members')->name('faculty-members.')->group(function (){
        Route::controller(FacultyController::class)->group(function (){
            Route::get('/{sem_id?}', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('store2', 'store2')->name('store2');
        });

        Route::prefix('faculty-subjects')->name('faculty-subjects.')->group(function (){
            Route::controller(FacultySubjectController::class)->group(function (){
                Route::get('/{faculty_id}/{semester_id}/{mother_program?}/{yr_level?}', 'index')->name('index');
                Route::post('store', 'store')->name('store');
                Route::post('update/{id}', 'update')->name('update');
            });
        });
    });

    // Faculty Account
    Route::prefix('assignedsubjects')->name('assignedsubjects.')->group(function (){
        Route::get('/', [FacultySubjectController::class, 'assignedSubjects'])->name('assignedSubjects'); //{get_sem_id?}/{get_course_id?}

        Route::prefix('course-outcomes')->name('course-outcomes.')->group(function (){
            Route::get('/', [CourseOutcomeController::class, 'index'])->name('index'); //{subject_id}/{version?}
        });

        Route::prefix('students')->name('students.')->group(function (){
            Route::controller(StudentController::class)->group(function (){
                Route::get('/', 'index')->name('index'); //{faculty_subject_id}
                Route::post('store', 'store')->name('store');
            });
        });
    });

    Route::prefix('program-outcomes')->name('program-outcomes.')->group(function (){
        Route::controller(ProgramOutcomeController::class)->group(function (){
            Route::get('/{course_id?}/{version?}', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
            Route::post('destroy/{id}', 'destroy')->name('destroy');
        });
    });

    // Reports
    Route::prefix('reports')->name('reports.')->group(function (){
        Route::controller(POAssessmentResultController::class)->group(function (){
            Route::prefix('po-assessment-result')->name('po-assessment-result.')->group(function (){
                Route::get('/', 'index')->name('index');
                Route::post('export', 'exportPDF')->name('export');
            });
        });
        Route::prefix('evaluation-response')->name('evaluation-response.')->group(function (){
            Route::controller(EvaluationReponseController::class)->group(function (){
                Route::get('/', 'index')->name('index');
                Route::get('show/{curriculum_id}', 'show')->name('show');
            });
        });
    });

    // Settings
    Route::prefix('rating-setting')->name('rating-setting.')->group(function (){
        Route::controller(RatingSettingController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::get('show/{curriculum_id}', 'show')->name('show');
            Route::post('save', 'save')->name('save');
        });
    });

    Route::prefix('general-setting')->name('general-setting.')->group(function (){
        Route::controller(SettingController::class)->group(function (){
            Route::get('/', 'index')->name('index');
            Route::post('store', 'store')->name('store');
            Route::post('update/{id}', 'update')->name('update');
        });
    });

    // Student Evaluation
    Route::prefix('evaluation')->name('evaluation.')->group(function (){
        Route::controller(EvaluationController::class)->group(function (){
            Route::get('create/{enrollment_id}', 'create')->name('create');
            Route::post('store', 'store')->name('store');
            Route::get('show/{enrollment_id}', 'show')->name('show');
        });
    });

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
