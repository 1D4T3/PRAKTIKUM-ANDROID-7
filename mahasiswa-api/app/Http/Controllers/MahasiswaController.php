<?php

namespace App\Http\Controllers;

use App\Models\mahasiswa;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class MahasiswaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return mahasiswa::all();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'npm'=>'required|string|unique:mahasiswas',
            'nama'=>'required|string',
            'tempat_lahir'=>'required|string',
            'tgl_lahir'=>'required|date',
            'sex'=>'required|in:L,P',
            'alamat'=>'required|string',
            'telp'=>'required|string',
            'email'=>'required|string|email|unique:mahasiswas',
            'photo'=>'nullable|string',
        ]);
        return mahasiswa::create($request->all());
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        return mahasiswa::findOrFail($id);
    }

    /**
     * Update the specified resource in storage.
     */
    // public function update(Request $request, string $id)
    // {
    //     $mahasiswa = mahasiswa::findOrFail($id);
    //     $request -> validate([
    //         'npm'=>'sometimes|required|string|unique:mahasiswas, npm,' .$mahasiswa->id,
    //         'email'=>'sometimes|required|string|email|unique:mahasiswas, email,' .$mahasiswa->id,
    //     ]);
    //     $mahasiswa->update($request->all());
    //     return $mahasiswa;
    // }
    public function update(Request $request, $id)
{

    $mahasiswa = mahasiswa::findOrFail($id);

    // // Debug data yang diterima
    Log::info('Data yang diterima:', $request->all());

    // // Log data mahasiswa yang ditemukan
    Log::info('Data mahasiswa:', $mahasiswa->toArray());

    $mahasiswa->update($request->all());
    return $mahasiswa;


    // if ($request->has('npm')) {
    //     $request->validate([
    //         'npm' => 'required|string|unique:mahasiswas,npm,' . $mahasiswa->id,
    //     ]);
    // }

    // if ($request->has('email')) {
    //     $request->validate([
    //         'email' => 'required|string|email|unique:mahasiswas,email,' . $mahasiswa->id,
    //     ]);
    // }

}

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $mahasiswa = mahasiswa::findOrFail($id);
        $mahasiswa->delete();
        return response()->noContent();
    }
}
