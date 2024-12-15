import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/sidang_tugas_akhir/sidang_ta_controller.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/revisi_tugas_akhir/daftar_revisi.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SidangTaScreen extends StatefulWidget {
  const SidangTaScreen({super.key});
  @override
  _SidangTaScreenState createState() => _SidangTaScreenState();
}

class _SidangTaScreenState extends State<SidangTaScreen> {
  String? mhsNama;
  String? pembimbing1;
  String? pembimbing2;
  String? penguji1;
  String? penguji2;
  String? penguji3;
  String? sekretaris;
  String? thnAkademik;
  String? judulTA;
  String? tglSidang;
  String? ruangSidang;
  String? sesiSidang;
  int? statusLulus;

  Future<String> getDownloadDirectoryPath() async {
    final directory = Directory('/storage/emulated/0/Download');
    if (await directory.exists()) {
      return directory.path;
    }
    throw Exception("Direktori tidak ditemukan");
  }

  // Fungsi untuk mengunduh PDF berdasarkan URL
  Future<void> downloadPdf(BuildContext context, String pdfUrl, String fileName) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      // Direktori untuk menyimpan file
      final directory = Directory('/storage/emulated/0/Download');
      final filePath = "${directory.path}/$fileName";

      // Mengunduh file dengan Dio
      Dio dio = Dio();
      Response response = await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/pdf',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File berhasil diunduh: $filePath")),
        );
      } else {
        throw Exception("Failed to download PDF. Status code: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file: $e")),
      );
    }
  }

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      print('Fetched data: $data');

      setState(() {
        mhsNama = data['data']['mahasiswa']['mhs_nama'];
        pembimbing1 = data['data']['mahasiswa']['dosen'].isNotEmpty ? data['data']['mahasiswa']['dosen'][0]['dosen_nama'] : 'Belum Di Plotting';
        pembimbing2 = data['data']['mahasiswa']['dosen'].length > 1 ? data['data']['mahasiswa']['dosen'][1]['dosen_nama'] : 'Belum Di Plotting';

        // Pastikan array penguji memiliki elemen sebelum mengaksesnya
        penguji1 = data['data']['mahasiswa']['penguji'].isNotEmpty ? data['data']['mahasiswa']['penguji'][0]['penguji_nama'] : 'Belum Di Plotting';
        penguji2 = data['data']['mahasiswa']['penguji'].length > 1 ? data['data']['mahasiswa']['penguji'][1]['penguji_nama'] : 'Belum Di Plotting';
        penguji3 = data['data']['mahasiswa']['penguji'].length > 2 ? data['data']['mahasiswa']['penguji'][2]['penguji_nama'] : 'Belum Di Plotting';

        sekretaris = data['data']['mahasiswa']['sekre'];
        thnAkademik = data['data']['mahasiswa']['tahun_akademik'];
        judulTA = data['data']['mahasiswa']['judul_final'];
        tglSidang = data['data']['mahasiswa']['tgl_sidang'];
        ruangSidang = data['data']['mahasiswa']['ruangan_nama'];
        sesiSidang = data['data']['mahasiswa']['sesi_nama'];

        statusLulus = data['data']['taSidang']['status_lulus'];
      });
    } catch (e) {
      print('Error: $e');
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      loadMahasiswaData(token);
    } else {
      print('User is not authenticated');
    }
  }

  String _getStatusText() {
    if (tglSidang == null) return 'Loading . . .';

    try {
      final DateTime sidangDate = DateFormat('yyyy-MM-dd').parse(tglSidang!);
      final DateTime currentDate = DateTime.now();

      if (currentDate.isAfter(sidangDate)) {
        return 'Sudah Sidang';
      } else {
        return 'Belum Sidang';
      }
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color _getStatusColor() {
    if (tglSidang == null) return Colors.grey;

    try {
      final DateTime sidangDate = DateFormat('yyyy-MM-dd').parse(tglSidang!);
      final DateTime currentDate = DateTime.now();

      if (currentDate.isAfter(sidangDate)) {
        return Colors.green; // Warna hijau untuk Sudah Sidang
      } else {
        return Colors.red; // Warna merah untuk Belum Sidang
      }
    } catch (e) {
      return Colors.grey; // Warna default untuk kesalahan parsing
    }
  }

  Future<bool> _onWillPop() async {
    // Menavigasi kembali jika tidak ada masalah
    Navigator.pop(context);
    GoRouter.of(context).pushReplacement('/home_mahasiswa');

    return true;  // Menandakan bahwa pop boleh terjadi
  }

  @override
  Widget build(BuildContext context) {
    print(statusLulus);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(40, 42, 116, 1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        GoRouter.of(context).pushReplacement('/home_mahasiswa');
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                // Avatar dan Nama User
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      mhsNama ?? "Loading...", // Ensure mhsNama is not null
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, size: 30, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Sidang',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Text(
              'Tugas Akhir',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 20),
            CustomExpansionCard(
              title: 'Data Sidang Tugas Akhir',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          label: 'Pembimbing 1',
                          placeholderText: pembimbing1 ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Pembimbing 2',
                          placeholderText: pembimbing2 ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Penguji 1',
                          placeholderText: penguji1 ?? 'Belum Di Plotting'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Penguji 2',
                          placeholderText: penguji2 ?? 'Belum Di Plotting'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Penguji 3',
                          placeholderText: penguji3 ?? 'Belum Di Plotting'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Sekretaris',
                          placeholderText: sekretaris ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Tahun Akademik',
                          placeholderText: thnAkademik ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Judul Tugas Akhir',
                          placeholderText: judulTA ?? 'Loading . . .',
                          ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            CustomExpansionCard(
              title: 'Status',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          label: 'Tanggal Sidang',
                          placeholderText: tglSidang ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Ruang Sidang',
                          placeholderText: ruangSidang ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Sesi Sidang',
                          placeholderText: sesiSidang ?? 'Loading . . .'),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: 'Status Sidang',
                        placeholderText: _getStatusText(),
                        isEditable: false,
                        style: TextStyle(
                          color:
                              _getStatusColor(), // Warna teks berdasarkan status
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (statusLulus == 2)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DaftarRevisiScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'Revisi',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            else if (statusLulus == 1)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("${Config.baseUrl}download-lembar-pengesahan");
                    downloadPdf(context, "${Config.baseUrl}download-lembar-pengesahan", "Lembar Pengesahan.pdf");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Cetak Lembar Pengesahan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    )
    );
  }
}

class CustomExpansionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionCard(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.menu, size: 24, color: Colors.black),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
          trailing: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
          children: children,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final String? placeholderText;
  final bool isEditable;
  final TextStyle? style; // Tambahkan parameter style

  const CustomTextField({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.placeholderText,
    this.isEditable = true,
    this.style, // Inisialisasi parameter style
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaceholder = placeholderText != null;
    return Container(
      margin: EdgeInsets.only(bottom: 8.0), // Adjust spacing between fields
      child: TextField(
        maxLines: maxLines,
        readOnly: true,
        controller:
            isPlaceholder ? TextEditingController(text: placeholderText) : null,
        style: style ??
            TextStyle(
              fontStyle: FontStyle.normal,
              color: Colors.black87,
            ), // Gunakan style jika tersedia
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200], // Background color to match the image
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none, // Remove border
          ),
        ),
      ),
    );
  }
}

