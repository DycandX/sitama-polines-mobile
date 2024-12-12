import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dashboard_ta_input.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FinalProjectScreen(),
    );
  }
}

class ApiService {
  static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse('${Config.baseUrl}dashboard-mahasiswa');

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
