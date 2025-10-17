<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Scale extends Model
{
    protected $fillable = ['version', 'rating', 'descriptive_rating'];

    public function getVersion($vtype = 'new')
    {
        $scale = $this->select('version')->orderBy('version', 'DESC')->first();
        if ($vtype == 'latest') {
            if (!empty($scale)) {
                return $scale->version;
            } else {
                return null;
            }
        } else {
            if (!empty($scale)) {
                return $scale->version + 1;
            } else {
                return 1;
            }
        }
    }
}
