<?php

use App\Http\Controllers\JadwalController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MahasiswaController;
use App\Http\Controllers\MataKuliahController;

Route::apiResource('mahasiswa',MahasiswaController::class);
Route::apiResource('mata-kuliah',MataKuliahController::class);
Route::get('/jadwal',[JadwalController::class, 'index']);
Route::post('/jadwal',[JadwalController::class,'store']);
Route::get('/jadwal/{id}',[JadwalController::class,'show']);
Route::put('/jadwal/{id}',[JadwalController::class,'update']);
Route::delete('/jadwal/{id}',[JadwalController::class,'delete']);
// Route::apiResource('jadwal',MataKuliahController::class);
// Route::put('/mahasiswa/{id}', [MahasiswaController::class, 'update']);
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
