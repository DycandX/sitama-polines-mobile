import 'dart:ui';

import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to the "Menguji" section

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
      'isTerjadwal': false,
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
      'isTerjadwal': true,
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
      'isTerjadwal': false,
    },
    // Add more entries if needed for testing
  ];

  void _updateEntry(int index, Map<String, dynamic> updatedEntry) {
    setState(() {
      dataSidang[index] = updatedEntry;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;
    double fontSizeTitle = screenWidth * 0.06;
    double fontSizeSubtitle = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 43, 116, 1),
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: 80), // Space for BottomNavigationBar
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'WIKTASARI , S.T., M.KOM.',
                        style: TextStyle(
                          fontSize: fontSizeSubtitle,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: screenWidth * 0.045,
                        backgroundImage:
                            AssetImage('assets/images/welcome_image.png'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Data Ujian Sidang Tugas Akhir',
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 33, 37, 41),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(padding * 0.5),
                      child: ListView.builder(
                        itemCount: dataSidang.length,
                        itemBuilder: (context, index) {
                          final sidang = dataSidang[index];
                          return Card(
                            color: const Color.fromRGBO(221, 221, 221, 1),
                            margin:
                                EdgeInsets.symmetric(vertical: padding * 0.3),
                            child: ListTile(
                              title: Text(
                                sidang['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeSubtitle,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      'Nama: ${sidang['name']}',
                                      style: TextStyle(
                                          fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      'NIM: ${sidang['nim']}',
                                      style: TextStyle(
                                          fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      'Judul: ${sidang['judulTA']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      'Status: ${sidang['status']}',
                                      style: TextStyle(
                                          fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: screenWidth * 0.025,
                                        color: sidang['isTerjadwal']
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        sidang['isTerjadwal']
                                            ? 'Sudah Terjadwal'
                                            : 'Belum Terjadwal',
                                        style: TextStyle(
                                            fontSize: fontSizeSubtitle * 0.7),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: screenWidth * 0.025,
                                        color: sidang['isTerjadwal']
                                            ? Colors.green
                                            : Colors.teal,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        sidang['isTerjadwal']
                                            ? 'Sudah Melakukan Sidang'
                                            : 'Belum Melakukan Sidang',
                                        style: TextStyle(
                                            fontSize: fontSizeSubtitle * 0.7),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(50, 111, 233, 1),
                                ),
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
                                        isiBobotNaskah:
                                            sidang['isiBobotNaskah'],
                                        penguasaanMateri:
                                            sidang['penguasaanMateri'],
                                        isTerjadwal: sidang['isTerjadwal'],
                                        onSave: (updatedEntry) =>
                                            _updateEntry(index, updatedEntry),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Lihat',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSizeSubtitle * 0.9),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people),
                      label: 'Bimbingan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit_note),
                      label: 'Menguji',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blue,
                  onTap: _onItemTapped,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
