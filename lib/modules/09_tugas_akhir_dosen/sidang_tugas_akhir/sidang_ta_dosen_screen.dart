import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> dataSidang = [
    {
      'nim': '4.33.23.218',
      'name': 'Godilam',
      'tahunAkademik': '2024',
      'judulTA': 'Cara Mengirim Januar Tanpa Rusak Di Perjalanan',
      'status': 'Belum Terjadwal',
      'ruangan': '2',
      'sebagai': 'Pembimbing 1',
      'isiBobotNaskah': '100',
      'penguasaanMateri': '100',
      'isTerjadwal': false,  // Pastikan isTerjadwal diisi dengan benar
    },
    {
      'nim': '4.33.23.210',
      'name': 'Ridwan Lewandowski',
      'tahunAkademik': '2024',
      'judulTA': 'Pendapat Utama Tentang Mengonsumsi Januar',
      'status': 'Sudah Terjadwal',
      'ruangan': '3',
      'sebagai': 'Penguji 1',
      'isiBobotNaskah': '90',
      'penguasaanMateri': '95',
      'isTerjadwal': true,  // Pastikan isTerjadwal diisi dengan benar
    },
    {
      'nim': '4.33.23.204',
      'name': 'Kayes',
      'tahunAkademik': '2024',
      'judulTA': 'Cara Menghilangkan Januar Yang Membandel',
      'status': 'Sudah Terjadwal',
      'ruangan': '1',
      'sebagai': 'Penguji 2',
      'isiBobotNaskah': '85',
      'penguasaanMateri': '80',
      'isTerjadwal': false,  // Pastikan isTerjadwal diisi dengan benar
    },
  ];

  void _updateEntry(int index, Map<String, dynamic> updatedEntry) {
    setState(() {
      dataSidang[index] = updatedEntry; // Update the existing entry
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text(
                  'WIKTASARI, S.T., M.KOM. ',
                  style: TextStyle(
                    fontSize: 16, // Font size for the name
                  ),
                ),
                const SizedBox(width: 8), // Space between name and image
                CircleAvatar(
                  radius: 16, // Radius of the avatar
                  backgroundImage: AssetImage('assets/images/welcome_image.png'), // Replace with your image URL
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
          children: [
            const Text(
              'Data Ujian Sidang Akhir',
              style: TextStyle(
                fontSize: 24, // Set the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            const SizedBox(height: 16), // Add space below the title
            Expanded(
              child: ListView.builder(
                itemCount: dataSidang.length,
                itemBuilder: (context, index) {
                  final sidang = dataSidang[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0), // Vertical margin between cards
                    child: ListTile(
                      title: Text(sidang['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NIM: ${sidang['nim']}'),
                          Text('Judul: ${sidang['judulTA']}'),
                          Text('Status: ${sidang['status']}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                nim: sidang['nim'],
                                name: sidang['name'],
                                tahunAkademik: sidang['tahunAkademik'],
                                judulTA: sidang['judulTA'],
                                ruangan: sidang['ruangan'],
                                sebagai: sidang['sebagai'],
                                isiBobotNaskah: sidang['isiBobotNaskah'],
                                penguasaanMateri: sidang['penguasaanMateri'],
                                isTerjadwal: sidang['isTerjadwal'], // Kirim status terjadwal
                                onSave: (updatedEntry) => _updateEntry(index, updatedEntry),
                              ),
                            ),
                          );
                        },
                        child: const Text('Lihat'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}