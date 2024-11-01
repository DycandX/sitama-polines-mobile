import 'package:flutter/material.dart';
import 'buat_revisi.dart';

class DaftarRevisiScreen extends StatefulWidget {
  const DaftarRevisiScreen({super.key});

  @override
  State<DaftarRevisiScreen> createState() => _DaftarRevisiScreenState();
}

class _DaftarRevisiScreenState extends State<DaftarRevisiScreen> {
  List<Map<String, String?>> revisiList = [];
  int revisionCount = 0; // Counter for revisions

  void _addRevisi(
      String title, String description, String? file, String? dosen) {
    setState(() {
      revisionCount += 1; // Increment revision count for each new entry
      revisiList.add({
        'title': title,
        'description': description,
        'file': file,
        'dosen': dosen,
        'revisionNumber': 'Revisi ke-$revisionCount',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue App Bar
          Container(
            color: Colors.indigo[900],
            height: 20,
            child: SafeArea(
              child: Container(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button, Name, and Profile Picture Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.blue),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 220),
                        const Text(
                          'Adnan Bima Adhi N',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Daftar Revisi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                // Main Form Container
                revisiList.isEmpty
                    ? const Text('Tidak ada revisi yang dibuat.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: revisiList.length,
                        itemBuilder: (context, index) {
                          final revisi = revisiList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  revisi['title'] ?? 'Judul Tidak Tersedia',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      revisi['revisionNumber'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.yellow,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('Belum Diverifikasi'),
                                      ],
                                    ),
                                    if (revisi['dosen'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Dosen: ${revisi['dosen']}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Define action when "Lihat" is clicked
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text('Lihat',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuatRevisiScreen(onSave: _addRevisi),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(27, 175, 27, 1),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      '+ Buat Revisi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
