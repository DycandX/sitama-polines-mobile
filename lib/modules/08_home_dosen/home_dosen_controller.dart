import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse(
        '${Config.baseUrl}home');

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
