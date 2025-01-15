import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jadwal.dart';

class JadwalService {
  final String baseUrl = 'http://127.0.0.1:8000/api/jadwal';

  Future<List<Jadwal>> getJadwal() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Jadwal.fromJson(data)).toList();
    } else {
      throw Exception('Gagal Load Data ');
    }
  }

  Future<Jadwal> createJadwal(Jadwal jadwal) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jadwal.toJson()),
    );

    if (response.statusCode == 201) {
      return Jadwal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Membuat Jadwal');
    }
  }

  Future<Jadwal> updateJadwal(int id, Jadwal jadwal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jadwal.toJson()),
    );
    if (response.statusCode == 200) {
      return Jadwal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Update Jadwal');
    }
  }

  Future<void> deleteJadwal(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Gagal Hapus Data');
    }
  }
}
