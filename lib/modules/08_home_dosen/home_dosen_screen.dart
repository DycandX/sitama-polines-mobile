import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen_pembimbing.dart';
import 'package:pbl_sitama/profile_header.dart';
class JadwalSidangPage extends StatefulWidget {
  const JadwalSidangPage({super.key});

  @override
  _JadwalSidangPageState createState() => _JadwalSidangPageState();
}

class _JadwalSidangPageState extends State<JadwalSidangPage> {
  int selectedIndex = 0;

  final List<Map<String, String>> jadwalSidang = [
    {'hari': 'Rabu', 'tanggal': '2 Oktober 2024'},
    {'hari': 'Kamis', 'tanggal': '3 Oktober 2024'},
    {'hari': 'Jum\'at', 'tanggal': '4 Oktober 2024'},
    {'hari': 'Senin', 'tanggal': '7 Oktober 2024'},
    {'hari': 'Selasa', 'tanggal': '8 Oktober 2024'},
    {'hari': 'Rabu', 'tanggal': '9 Oktober 2024'},
    {'hari': 'Kamis', 'tanggal': '10 Oktober 2024'},
    {'hari': 'Jum\'at', 'tanggal': '11 Oktober 2024'},
    {'hari': 'Senin', 'tanggal': '14 Oktober 2024'},
    {'hari': 'Selasa', 'tanggal': '15 Oktober 2024'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 43, 116, 1),
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          ProfileHeader(),
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 100, 20, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Jadwal Sidang Tugas Akhir',
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
  child: ListView.builder(
    itemCount: jadwalSidang.length,
    itemBuilder: (context, index) {
      final jadwal = jadwalSidang[index];
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${jadwal['hari']}, ${jadwal['tanggal']}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Aksi tombol "Lihat"
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: const Color(0xFF0068FF),
                  ),
                  child: const Text(
                    'Lihat',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),

              ],
            ),
          ),
          // Floating Bottom Navigation Bar
          
        ],
      ),
    );
  }
}
