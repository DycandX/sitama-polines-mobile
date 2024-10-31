import 'package:flutter/material.dart';
import 'buat_bimbingan_screen.dart';

class StatusBimbinganScreen extends StatelessWidget {
  final String pembimbing;

  const StatusBimbinganScreen({required this.pembimbing, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Bimbingan $pembimbing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bimbingan $pembimbing (0/8)',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuatBimbinganScreen()),
                );
              },
              child: const Text('Buat Bimbingan'),
            ),
          ],
        ),
      ),
    );
  }
}
