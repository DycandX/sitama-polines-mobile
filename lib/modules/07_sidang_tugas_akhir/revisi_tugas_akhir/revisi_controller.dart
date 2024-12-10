import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';

class PembimbinganController {
  // Simulasi pengambilan data pembimbing dari database
  Future<bool> checkIfDataPlotted() async {
    // Implementasikan pengambilan data dari database
    await Future.delayed(const Duration(seconds: 1));
    // Ubah false menjadi true ketika data pembimbing ada di database
    return false; // Contoh awal, belum ada data
  }
}

class ApiService { static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse('${Config.baseUrl}revisi-mahasiswa');

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
