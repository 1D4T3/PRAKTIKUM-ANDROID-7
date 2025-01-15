import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../controllers/matakuliah_controller.dart';
import '../models/mata_kuliah.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MatakuliahView extends StatefulWidget {
  @override
  _MataKuliahListState createState() => _MataKuliahListState();
}

class _MataKuliahListState extends State<MatakuliahView> {
  late Future<List<MataKuliah>> futureMataKuliah;

  @override
  void initState() {
    super.initState();
    futureMataKuliah = ApiService().fetchMataKuliah();
  }

  Future<void> generatePdf(List<MataKuliah> mataKuliahs) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Laporan Mata Kuliah', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Kode', 'Mata Kuliah', 'SKS', 'Semester'],
                data: mataKuliahs.map((mataKuliah) {
                  return [
                    mataKuliah.kode,
                    mataKuliah.matakuliah,
                    mataKuliah.sks.toString(),
                    mataKuliah.semester.toString()
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _showForm(BuildContext context, {MataKuliah? mataKuliah}) async {
    final kodeController = TextEditingController(text: mataKuliah?.kode);
    final matakuliahController =
        TextEditingController(text: mataKuliah?.matakuliah);
    final sksController = TextEditingController(
        text: mataKuliah != null ? mataKuliah.sks.toString() : '');
    final semesterController = TextEditingController(
        text: mataKuliah != null ? mataKuliah.semester.toString() : '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              mataKuliah == null ? 'Tambah Mata Kuliah' : 'Ubah MataK uliah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kodeController,
                decoration: InputDecoration(labelText: 'Kode'),
              ),
              TextField(
                controller: matakuliahController,
                decoration: InputDecoration(labelText: 'Nama Mata Kuliah'),
              ),
              TextField(
                controller: sksController,
                decoration: InputDecoration(labelText: 'SKS'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: semesterController,
                decoration: InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Validasi input
                if (kodeController.text.isEmpty ||
                    matakuliahController.text.isEmpty ||
                    sksController.text.isEmpty ||
                    semesterController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                try {
                  // Parsing SKS dan Semester
                  int sks = int.parse(sksController.text);
                  int semester = int.parse(semesterController.text);

                  // Periksa koneksi jaringan
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tidak ada koneksi internet')),
                    );
                    return;
                  }

                  if (mataKuliah == null) {
                    // Tambah data
                    await ApiService().createMataKuliah(MataKuliah(
                      id: 0,
                      kode: kodeController.text,
                      matakuliah: matakuliahController.text,
                      sks: sks,
                      semester: semester,
                    ));
                  } else {
                    // Ubah data
                    await ApiService().updateMataKuliah(
                      mataKuliah.id,
                      MataKuliah(
                        id: mataKuliah.id,
                        kode: kodeController.text,
                        matakuliah: matakuliahController.text,
                        sks: sks,
                        semester: semester,
                      ),
                    );
                  }

                  Navigator.of(context).pop();
                  setState(() {
                    futureMataKuliah = ApiService().fetchMataKuliah();
                  });
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              },
              child: Text(mataKuliah == null ? 'Tambah' : 'Ubah'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMataKuliah(int id) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada koneksi internet')),
        );
        return;
      }
      await ApiService().deleteMataKuliah(id);
      setState(() {
        futureMataKuliah = ApiService().fetchMataKuliah(); // Refresh data
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mata Kuliah'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showForm(context),
          ),
          IconButton(
            icon: Icon(Icons.print), // Ikon untuk cetak PDF
            onPressed: () async {
              // Ambil data mata kuliah
              final mataKuliahs = await futureMataKuliah;
              if (mataKuliahs.isNotEmpty) {
                // Generate dan cetak PDF
                await generatePdf(mataKuliahs);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tidak ada data untuk dicetak')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MataKuliah>>(
        future: futureMataKuliah,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ID Mata Kuliah Kosong'));
          }
          List<MataKuliah> mataKuliahs = snapshot.data!;
          return ListView.builder(
            itemCount: mataKuliahs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(mataKuliahs[index].matakuliah),
                subtitle: Text(
                    'Kode: ${mataKuliahs[index].kode}, SKS: ${mataKuliahs[index].sks}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          _showForm(context, mataKuliah: mataKuliahs[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteMataKuliah(mataKuliahs[index].id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
