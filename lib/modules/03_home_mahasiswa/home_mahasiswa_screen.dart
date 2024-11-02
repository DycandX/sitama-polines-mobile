import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/sidang_tugas_akhir/sidang_ta_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeMahasiswaScreen(),
    );
  }
}

class homeMahasiswaScreen extends StatefulWidget {
  @override
  _homeMahasiswaScreenState createState() => _homeMahasiswaScreenState();
}

class _homeMahasiswaScreenState extends State<homeMahasiswaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282A74), // Background warna #282A74
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45, // Icon profile lebih besar
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person, // Placeholder icon
                            size: 60, // Icon lebih besar
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adnan Bima Adhi N',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold, // Poppins Bold 15
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '4.33.23.2.03',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.book, // Placeholder icon
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pembimbing 1\nJanuar St. MT.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500, // Poppins Medium 14
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Container(
                          height: 40, // Tinggi garis vertikal
                          width: 1, // Lebar garis vertikal
                          color: Colors.white54, // Warna garis vertikal
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.book, // Placeholder icon
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pembimbing 2\nIlham  St. MT.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500, // Poppins Medium 14
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              // Single Box for all items
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: 0), // Menghilangkan padding kiri, kanan, bawah
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    margin: EdgeInsets.zero, // Fit ke layar tanpa ruang ekstra
                    elevation: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildMenuItem(
                            'Dashboard Tugas\nAkhir',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ),
                              );

                              // Navig asi ke Dashboard Tugas Akhir
                              print('Navigasi ke Dashboard Tugas Akhir');
                            },
                          ),
                          SizedBox(height: 16),
                          buildMenuItem(
                            'Bimbingan',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PembimbinganScreen(),
                                ),
                              );
                              // Navigasi ke Bimbingan
                              print('Navigasi ke Bimbingan');
                            },
                          ),
                          SizedBox(height: 16),
                          buildMenuItem(
                            'Daftar Tugas\nAkhir',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarTaScreen(),
                                ),
                              );
                              // Navigasi ke Daftar Tugas Akhir
                              print('Navigasi ke Daftar Tugas Akhir');
                            },
                          ),
                          SizedBox(height: 16),
                          buildMenuItem(
                            'Sidang Tugas\nAkhir',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SidangTaScreen(),
                                ),
                              );
                              // Navigasi ke Sidang Tugas Akhir
                              print('Navigasi ke Sidang Tugas Akhir');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Aligning the logout button to top right
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _showLogoutDialog(context); // Panggil fungsi dialog
              },
              child: Image.asset(
                'images/logout.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(String title, VoidCallback onPressed) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              // Container dengan background color berbentuk persegi panjang dengan sisi rounded
              Container(
                width: 62, // Lebar container (rectangle)
                height: 62, // Tinggi container (rectangle)
                decoration: BoxDecoration(
                  color: Color(0xFF0068FF), // Background color #0068FF
                  borderRadius: BorderRadius.circular(
                      12), // Sisi rounded dengan radius 12
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Padding untuk memberi ruang di sekitar gambar
                  child: Image.asset(
                    'images/icon.png', // Gambar icon
                    width: 32, // Ukuran gambar tetap
                    height: 32, // Ukuran gambar tetap
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        // Garis vertikal di tengah
        Container(
          height: 32, // Tinggi garis vertikal
          width: 1, // Lebar garis vertikal
          color: Colors.blue, // Warna garis vertikal
        ),
        // Tombol "Lihat"
        Expanded(
          child: Align(
            alignment: Alignment.center, // Menempatkan tombol di kanan
            child: TextButton(
              onPressed: onPressed, // Panggil callback yang sesuai
              child: Text('Lihat'),
            ),
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi log out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Apakah anda yakin ingin keluar?'),
              SizedBox(height: 20), // Jarak antara teks dan tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tombol Silang
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Menutup dialog
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red, // Background warna merah
                        shape: BoxShape.circle, // Bentuk bulat
                      ),
                      padding: EdgeInsets.all(
                          12), // Padding untuk memberi ruang di sekitar gambar
                      child: Image.asset(
                        'images/no.png', // Gambar icon silang
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  // Tombol Centang
                  GestureDetector(
                    onTap: () {
                      // Tambahkan logika untuk melakukan log out di sini
                      Navigator.of(context)
                          .pop(); // Menutup dialog setelah log out
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green, // Background warna hijau
                        shape: BoxShape.circle, // Bentuk bulat
                      ),
                      padding: EdgeInsets.all(
                          12), // Padding untuk memberi ruang di sekitar gambar
                      child: Image.asset(
                        'images/yes.png', // Gambar icon centang
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Tambahkan jika Anda ingin tombol lain di bawah dialog
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Menutup dialog
            //   },
            //   child: Text('Batal'),
            // ),
          ],
        );
      },
    );
  }
}
