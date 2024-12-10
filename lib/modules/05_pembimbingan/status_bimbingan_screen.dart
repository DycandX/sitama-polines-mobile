import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import 'status_bimbingan_controller.dart';

class StatusBimbinganScreen extends StatefulWidget {
  const StatusBimbinganScreen({super.key});

  @override
  State<StatusBimbinganScreen> createState() => _StatusBimbinganScreenState();
}

class _StatusBimbinganScreenState extends State<StatusBimbinganScreen> {
  String? mhsNama;
  int? mhsNim;
  String? pembimbing1;
  String? pembimbing2;
  String? ta_judul;
  int? ta_id;
  String? pembimbing1_count;
  String? pembimbing2_count;
  String? pembimbing1_count_total;
  String? pembimbing2_count_total;
  String? dosen1_setuju;
  String? dosen2_setuju;
  String? dosen1Status;
  String? dosen2Status;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        mhsNama = data['data']['mhs_nama'];
        mhsNim = data['data']['mhs_nim'];
        ta_judul = data['data']['ta_judul'];
        ta_id = data['data']['ta_id'];
        pembimbing1_count = data['pembimbing1_count'].toString();
        pembimbing2_count = data['pembimbing2_count'].toString();
        pembimbing1_count_total = data['pembimbing1_count_total'].toString();
        pembimbing2_count_total = data['pembimbing2_count_total'].toString();
        dosen1_setuju = data['data']['dosen'][0]['verified'];
        dosen2_setuju = data['data']['dosen'][1]['verified'];

        if (dosen1_setuju != null) {
          dosen1Status = (dosen1_setuju == '1') ? "Disetujui" : "Tidak Disetujui";
        } else {
          dosen1Status = "Belum Disetujui";
        }

        if (dosen2_setuju != null) {
          dosen2Status = (dosen2_setuju == '1') ? "Disetujui" : "Tidak Disetujui";
        } else {
          dosen2Status = "Belum Disetujui";
        }

        if (data['data']['dosen'] != null) {
          pembimbing1 = data['data']['dosen'].length > 0
              ? data['data']['dosen'][0]['dosen_nama']
              : "Belum Diplotting";
          pembimbing2 = data['data']['dosen'].length > 1
              ? data['data']['dosen'][1]['dosen_nama']
              : "Belum Diplotting";
        } else {
          pembimbing1 = "Belum Diplotting";
          pembimbing2 = "Belum Diplotting";
        }
      });
    } catch (e) {
      print('Error: $e');
    };
  }

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

  @override
  void initState() {
    super.initState();

    final token = Provider
        .of<AuthProvider>(context, listen: false)
        .token;
    if (token != null) {
      loadMahasiswaData(token);
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Back Button, Name, and Avatar
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
            const SizedBox(height: 16),
            // Title
            const Text(
              'Status Bimbingan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Bimbingan Box 1
            BimbinganStatusBox(
              nama: pembimbing1 ?? 'Loading...',
              jumlahBimbingan: "${pembimbing1_count}/${pembimbing1_count_total}",
              persetujuan: dosen1Status ?? "Belum Disetujui",
              isPembimbingUtama: true,
              onCetakPressed: (dosen1_setuju == '0') // Check if dosen1_setuju is '0'
                  ? null // Disable the button if dosen1_setuju is 0
                  : () {
                // Action for Cetak Lembar Kontrol
                print("${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/1");
                downloadPdf(context, "${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/1", "Lembar Kontrol 1.pdf");
              },
            ),
            const SizedBox(height: 16),
            // Bimbingan Box 2
            BimbinganStatusBox(
              nama: pembimbing2 ?? 'Loading...',
              jumlahBimbingan: "${pembimbing2_count}/${pembimbing2_count_total}",
              persetujuan: dosen2Status ?? "Belum Disetujui",
              isPembimbingUtama: false,
              onCetakPressed: (dosen2_setuju == '0') // Check if dosen1_setuju is '0'
                  ? null // Disable the button if dosen1_setuju is 0
                  : () {
                // Action for Cetak Lembar Kontrol
                print("${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/2");
                downloadPdf(context, "${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/2", "Lembar Kontrol 2.pdf");
              },
            ),
            const SizedBox(height: 16),
            // Tombol Cetak Lembar Persetujuan di bawah semua
            Center(
              child: ElevatedButton(
                onPressed: (dosen1_setuju == '0' && dosen2_setuju == '0') // Check if dosen1_setuju is '0'
                    ? null // Disable the button if dosen1_setuju is 0
                    : ()
                {
                  print("${Config.baseUrl}bimbingan-mahasiswa/cetak-persetujuan-sidang");
                  downloadPdf(context, "${Config.baseUrl}bimbingan-mahasiswa/cetak-persetujuan-sidang", "Lembar Persetujuan.pdf");
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
                  "Cetak Lembar Persetujuan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BimbinganStatusBox extends StatelessWidget {
  final String nama;
  final String jumlahBimbingan;
  final String persetujuan;
  final bool isPembimbingUtama;
  final VoidCallback? onCetakPressed; // Make this nullable

  const BimbinganStatusBox({
    required this.nama,
    required this.jumlahBimbingan,
    required this.persetujuan,
    required this.isPembimbingUtama,
    this.onCetakPressed, // Make this parameter optional
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Nama", nama),
          _buildInfoRow("Jumlah Bimbingan", jumlahBimbingan),
          _buildInfoRow("Persetujuan Pendaftaran Sidang", persetujuan),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: isPembimbingUtama ? Colors.green : Colors.transparent,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                isPembimbingUtama ? "Pembimbing Utama" : "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: onCetakPressed,
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
                "Cetak Lembar Kontrol",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          Text(
            "$label :",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
