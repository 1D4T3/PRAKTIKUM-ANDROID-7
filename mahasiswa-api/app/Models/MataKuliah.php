<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MataKuliah extends Model
{
    use HasFactory;
    protected $table = 'mata_kuliahs'; // Nama tabel



    protected $fillable = [
        'kode',
        'matakuliah',
        'sks',
        'semester',
    ];
}
