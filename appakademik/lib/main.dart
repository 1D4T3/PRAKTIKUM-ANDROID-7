// import 'package:appakademik/views/mahasiswa_view.dart';
// import 'package:appakademik/views/mahasiswa_view01.dart';
// import 'package:appakademik/views/matakuliah_view.dart';
// import 'package:appakademik/views/tambah_mahasiswa.dart';
// import 'package:appakademik/views/ubah_mahasiswa.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:appakademik/views/homescreen.dart';

void main() {
runApp(const MyApp());
}
class MyApp extends StatelessWidget {
const MyApp({super.key});
@override
Widget build(BuildContext context) {
return GetMaterialApp(
title: 'Mahasiswa App',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: HomeScreen(),
);
}
}