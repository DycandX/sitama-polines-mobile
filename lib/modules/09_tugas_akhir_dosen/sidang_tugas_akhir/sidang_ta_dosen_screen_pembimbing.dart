import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'detail_screen.dart';

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
      // case 3:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProfilePage()),
      //   );
      //   break;
    }
  }


  final List<Map<String, dynamic>> dataSidang = [
    {
      'nim': '4.33.23.218',
      'name': 'Godilam',
      'tahunAkademik': '2024',
      'judulTA': 'Cara Mengirim Januar Tanpa Rusak Di Perjalanan',
      'status': 'Belum Terjadwal',
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
      'status': 'Sudah Terjadwal',
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
      'status': 'Sudah Terjadwal',
      'ruangan': '1',
      'sebagai': 'Pembimbing 1',
      'kedisiplinanBimbingan': '88',
      'kreativitasPemecahanMasalah': '80',
      'penguasaanMateri': '78',
      'kelengkapanReferensi': '85',
      'isTerjadwal': false,
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
          Padding(
            padding: EdgeInsets.only(bottom: 100), // Space for BottomNavigationBar
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
                        backgroundImage: AssetImage('assets/images/welcome_image.png'),
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
                            margin: EdgeInsets.symmetric(vertical: padding * 0.3),
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
                                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                                    child: Text(
                                      'Nama: ${sidang['name']}',
                                      style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                                    child: Text(
                                      'NIM: ${sidang['nim']}',
                                      style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                                    child: Text(
                                      'Judul: ${sidang['judulTA']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: sidang['isTerjadwal'] ? Colors.green : Colors.yellow,
                                          size: fontSizeSubtitle * 0.9,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sidang['status'],
                                          style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(50, 111, 233, 1),
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
                                        kedisiplinanBimbingan: sidang['kedisiplinanBimbingan'],
                                        kreativitasPemecahanMasalah: sidang['kreativitasPemecahanMasalah'],
                                        penguasaanMateri: sidang['penguasaanMateri'],
                                        kelengkapanReferensi: sidang['kelengkapanReferensi'],
                                        onSave: (updatedEntry) => _updateEntry(index, updatedEntry),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Lihat',
                                  style: TextStyle(color: Colors.white, fontSize: fontSizeSubtitle * 0.9),
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
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
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
                  currentIndex: selectedIndex,
                  selectedItemColor: const Color.fromARGB(255, 55, 66, 230),
                  unselectedItemColor: Colors.grey,
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
