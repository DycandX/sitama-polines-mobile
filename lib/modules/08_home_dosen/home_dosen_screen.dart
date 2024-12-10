import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen_pembimbing.dart';

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
        backgroundColor: Colors.white30,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0068FF),
                shape: BoxShape.circle,
              ),
            ),
            Row(
              children: [
                Text(
                  'WIKTASARI , S.T., M.Kom.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Sidang Tugas Akhir',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: jadwalSidang.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            '${jadwalSidang[index]['hari']}, ${jadwalSidang[index]['tanggal']}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0068FF),
                            ),
                            child: Text(
                              'Lihat',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 13,
                              ),
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
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              height: 80, // Increase height to give more space
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40), // More rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: selectedIndex, // Set index of selected item
                  selectedItemColor:
                      Color.fromARGB(255, 55, 66, 230), // Selected icon color
                  unselectedItemColor: Colors.grey, // Unselected icon color
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.groups),
                      label: 'Bimbingan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.note_alt),
                      label: 'Menguji',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
