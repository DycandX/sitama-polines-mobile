import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';


class HomeScreenController {
  // To track the selected bottom navigation index
  int selectedIndex = 0;

  // List of pages to navigate within the bottom navigation
  final List<Widget> pages = [
    HomeScreen(), // Replace with your actual screen implementations
    Scaffold(
        body:
            Center(child: Text('Bimbingan'))), // Dummy screens for illustration
    Scaffold(body: Center(child: Text('Menguji'))),
    Scaffold(body: Center(child: Text('Profile'))),
  ];

  // Handle bottom navigation tap
  void onTabTapped(int index, Function callback) {
    selectedIndex = index;
    callback(); // Triggers the callback to rebuild the widget
  }

  // Handle view item action
  void onViewItem(BuildContext context, Map<String, dynamic> sidangData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(sidangData['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NIM: ${sidangData['nim']}'),
              Text('Judul: ${sidangData['title']}'),
              Text('Status: ${sidangData['status']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ApiService {
  static Future<Map<String, dynamic>> fetchMahasiswa(String token) async {
    final url = Uri.parse('${Config.baseUrl}ujian-sidang'); // Replace with your endpoint
    print('Fetching data from URL: $url'); // Print UR

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the token
          'Content-Type': 'application/json', // Optional but recommended
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return parsed JSON data
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
