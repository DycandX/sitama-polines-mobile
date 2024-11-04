import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/daftar_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen_pembimbing.dart';

// Model untuk mewakili data mahasiswa
class Mahasiswa {
  final int nim;
  final String nama;
  final String judulTugas;
  final int progress;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.judulTugas,
    required this.progress,
  });
}

class MahasiswaBimbingan extends StatefulWidget {
  const MahasiswaBimbingan({super.key});

  @override
  State<MahasiswaBimbingan> createState() => _MahasiswaBimbinganState();
}


// Function to handle navigation item selection

class _MahasiswaBimbinganState extends State<MahasiswaBimbingan> {
  int selectedIndex = 1;
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
      // case 3:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProfilePage()),
      //   );
      //   break;
    }
  }

  // Daftar mahasiswa (data dummy)
  final List<Mahasiswa> mahasiswas = [
    Mahasiswa(
        nim: 123,
        nama: 'Saifullah',
        judulTugas: 'Cara Mengirim Januar Tanpa Rusak Di Perjalanan',
        progress: 5),
    Mahasiswa(
        nim: 1234,
        nama: 'Nawasena',
        judulTugas: 'Menanam Mangrove Dengan Benar',
        progress: 8),
    Mahasiswa(
        nim: 12,
        nama: 'Nawasena',
        judulTugas: 'Menanam Mangrove Dengan Benar',
        progress: 8),
    Mahasiswa(
        nim: 1234,
        nama: 'Nawasena',
        judulTugas: 'Menanam Mangrove Dengan Benar',
        progress: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // Konten utama (List Mahasiswa dan lainnya)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                      child: Text(
                        'XAVIERA PUTRI S.T, M.Kom.',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/xaviera.png'),
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      // Judul expanded atas
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 30, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Daftar Mahasiswa Bimbingan',
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom:
                                  90), // Add bottom padding to prevent overlap
                          child: ListView.builder(
                            itemCount: mahasiswas.length,
                            itemBuilder: (context, index) {
                              final mahasiswa = mahasiswas[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 230, 228, 228),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "NIM    : ${mahasiswa.nim}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    "Nama : ${mahasiswa.nama}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    "Judul  : ${mahasiswa.judulTugas}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DaftarBimbingan()));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 50, 111, 233),
                                              ),
                                              child: Text(
                                                "Lihat",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: mahasiswa.progress == 8
                                                      ? Colors.green
                                                      : Colors.yellow,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '${mahasiswa.progress}/8',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
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
          ),
          // Floating navigation bar
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

void main() {
  runApp(MaterialApp(home: MahasiswaBimbingan()));
}
