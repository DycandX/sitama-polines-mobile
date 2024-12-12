import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/api_service.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse('${Config.baseUrl}daftar-tugas-akhir');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

class TugasAkhirItem {
  String namaDokumen;
  String status;
  bool isUploaded;
  int dokumen_id;

  TugasAkhirItem({
    required this.namaDokumen,
    required this.status,
    required this.isUploaded,
    required this.dokumen_id,
  });

  Color getColorIndicator() {
    if (status == 'Diverifikasi') return Colors.green;
    if (status == 'Menunggu Divalidasi') return Colors.yellow;
    return Colors.red; // Untuk 'Belum Upload'
  }
}

class DaftarTAController {
  List<TugasAkhirItem> daftarTugas = [];

  Future<List<TugasAkhirItem>> fetchDaftarTugas(String token) async {
    final url = Uri.parse('${Config.baseUrl}daftar-tugas-akhir');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> dokumentList = responseBody['dokumenSyaratTa'];

        daftarTugas = dokumentList.map((dok) {
          return TugasAkhirItem(
            namaDokumen: dok['dokumen_syarat'] ?? '',
            status: _convertVerifiedStatus(dok['verified']),
            isUploaded: dok['dokumen_file'] != null,
            dokumen_id: dok['dokumen_id'],
          );
        }).toList();

        return daftarTugas;
      } else {
        throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  String _convertVerifiedStatus(dynamic verified) {
    if (verified == 1) return 'Diverifikasi';
    if (verified == 0) return 'Menunggu Divalidasi';
    return 'Belum Upload';
  }

  void checkSyarat(BuildContext context) {
    bool allVerified = daftarTugas.every((item) => item.status == 'Diverifikasi');

    if (allVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda sudah mendaftar Sidang')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua syarat belum terpenuhi')),
      );
    }
  }
}

class UploadController {
  Future<void> uploadFile(String filePath, int dokumenId, BuildContext context) async {
    final String uploadUrl = '${Config.baseUrl}daftar-tugas-akhir/upload'; // Ganti dengan URL API upload
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['dokumen_id'] = dokumenId.toString()
        ..files.add(await http.MultipartFile.fromPath('draft_syarat', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File berhasil diunggah!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah file. Kode status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengunggah file: $e')),
      );
    }
  }
}