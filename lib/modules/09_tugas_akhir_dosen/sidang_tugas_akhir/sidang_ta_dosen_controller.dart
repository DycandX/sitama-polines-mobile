import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen.dart';

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
