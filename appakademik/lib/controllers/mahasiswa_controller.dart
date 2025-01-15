import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';

class MahasiswaController extends GetxController {
  var mahasiswaList = <Mahasiswa>[].obs;
  // IP dari laravel dijalankan pada flutter run
  final String apiUrl = 'http://127.0.0.1:8000/api/mahasiswa';
  // final String apiUrl = 'http://mahasiswa-api.test/api/mahasiswa';

  //  untuk emulator android studio gunakan IP dibawah ini
  // final String apiUrl = 'http://10.0.2.2:8000/api/mahasiswa';

  @override
  void onInit() {
    super.onInit();
    tangkapDataMahasiswa(); // Memanggil fetch data saat controller diinisialisasi
  }

  Future<void> tangkapDataMahasiswa() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        mahasiswaList.value =
            data.map((item) => Mahasiswa.fromJson(item)).toList();
      } else {
        Get.snackbar('Gagal', 'Gagal Ambil Data mahasiswa');
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal Ambil Data mahasiswa');
    }
  }

  Future<void> addMahasiswa(Mahasiswa mahasiswa) async {
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(mahasiswa.toJson()));

      if (response.statusCode == 201) {
        mahasiswaList.add(Mahasiswa.fromJson(json.decode(response.body)));
        Get.snackbar('Sukses', 'Data mahasiswa berhasil disimpan');
      } else {
        Get.snackbar('Gagal', 'Gagal Simpan Data mahasiswa');
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal Simpan Data mahasiswa');
    }
  }

  Future<bool> updateMahasiswa(int id, Mahasiswa mahasiswa) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(mahasiswa.toJson()),
      );

      if (response.statusCode == 200) {
        // Perbarui data di mahasiswaList
        final index = mahasiswaList.indexWhere((m) => m.id == id);
        if (index != -1) {
          mahasiswaList[index] = Mahasiswa.fromJson(json.decode(response.body));
        }
        Get.snackbar('Sukses', 'Data mahasiswa berhasil diubah',
            backgroundColor: Colors.green, colorText: Colors.white);
        return true; // Pembaruan berhasil
      } else {
        Get.snackbar('Gagal', 'Gagal Ubah Data mahasiswa',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false; // Pembaruan gagal
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false; // Terjadi kesalahan
    }
  }

  Future<void> deleteMahasiswa(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 204) {
        mahasiswaList.removeWhere((m) => m.id == id);
        Get.snackbar('Sukses', 'Data mahasiswa berhasil dihapus');
      } else {
        Get.snackbar('Gagal', 'Gagal Hapus Data mahasiswa');
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal Hapus Data mahasiswa');
    }
  }

}