import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'detail_screen.dart';
import 'package:pbl_sitama/profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate to different pages based on the index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JadwalSidangPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MahasiswaBimbingan()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  final List<Map<String, dynamic>> dataSidang = [
    {
      'nim': '4.33.23.218',
      'name': 'Godilam',
      'tahunAkademik': '2024',
      'judulTA': 'Cara Mengirim Januar Tanpa Rusak Di Perjalanan',
      'status': 'Belum Melakukan Sidang',
      'ruangan': '2',
      'sebagai': 'Pembimbing 1',
      'kedisiplinanBimbingan': '80',
      'kreativitasPemecahanMasalah': '90',
      'penguasaanMateri': '85',
      'kelengkapanReferensi': '95',
      'isTerjadwal': false,
    },
    {
      'nim': '4.33.23.210',
      'name': 'Ridwan Lewandowski',
      'tahunAkademik': '2024',
      'judulTA': 'Pendapat Utama Tentang Mengonsumsi Januar',
      'status': 'Sudah Melakukan Sidang',
      'ruangan': '3',
      'sebagai': 'Pembimbing 2',
      'kedisiplinanBimbingan': '75',
      'kreativitasPemecahanMasalah': '85',
      'penguasaanMateri': '90',
      'kelengkapanReferensi': '80',
      'isTerjadwal': true,
    },
    {
      'nim': '4.33.23.204',
      'name': 'Kayes',
      'tahunAkademik': '2024',
      'judulTA': 'Cara Menghilangkan Januar Yang Membandel',
      'status': 'Sudah Melakukan Sidang',
      'ruangan': '1',
      'sebagai': 'Penguji 1',
      'kedisiplinanBimbingan': '88',
      'kreativitasPemecahanMasalah': '80',
      'penguasaanMateri': '78',
      'kelengkapanReferensi': '85',
      'isTerjadwal': true,
    },
  ];

  void _updateEntry(int index, Map<String, dynamic> updatedEntry) {
    setState(() {
      dataSidang[index] = updatedEntry;
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
          ProfileHeader(),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, 100, 20, 0), // Space for BottomNavigationBar
            child: Column(
              children: [
                // SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Data ujian sidang tugas akhir',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: ListView.builder(
                        itemCount: dataSidang.length,
                        itemBuilder: (context, index) {
                          final sidang = dataSidang[index];
                          return Card(
                            color: const Color.fromRGBO(255, 246, 245, 245),
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: sidang['isTerjadwal']
                                              ? Colors.green
                                              : Colors.yellow,
                                          size: fontSizeSubtitle * 0.9,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sidang['status'],
                                          style: TextStyle(
                                              fontSize: fontSizeSubtitle * 0.9),
                                        ),
                                      ],
                                    ),
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
                                        kedisiplinanBimbingan:
                                            sidang['kedisiplinanBimbingan'],
                                        kreativitasPemecahanMasalah: sidang[
                                            'kreativitasPemecahanMasalah'],
                                        penguasaanMateri:
                                            sidang['penguasaanMateri'],
                                        kelengkapanReferensi:
                                            sidang['kelengkapanReferensi'],
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
        ],
      ),
    );
  }
}
