import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/api_service.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse(
        '${Config.baseUrl}bimbingan-mahasiswa');

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

class UploadController {
  Future<void> uploadFile(String filePath, String judul, String desk, String pembimbing, String tgl, BuildContext context) async {
    final String uploadUrl = '${Config.baseUrl}bimbingan-mahasiswa'; // Ganti dengan URL API upload
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['judul'] = judul.toString()
        ..fields['desk'] = desk.toString()
        ..fields['pembimbing'] = pembimbing.toString()
        ..fields['tgl'] = tgl.toString()
        ..files.add(await http.MultipartFile.fromPath('draft', filePath));

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