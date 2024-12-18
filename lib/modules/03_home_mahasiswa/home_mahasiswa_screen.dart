import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/app_navigation.dart';
import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';
import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dashboard_ta_input.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/sidang_tugas_akhir/sidang_ta_screen.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pbl_sitama/modules/02_login/login_page.dart';

import '../../services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigatorObserver navigatorObserver = NavigatorObserver();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeMahasiswaScreen(),
      navigatorObservers: [navigatorObserver],
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _refreshHomePage(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _refreshHomePage(previousRoute); // Memanggil refreshData saat kembali ke halaman sebelumnya
  }

  void _refreshHomePage(Route? route) {
    if (route?.settings.name == '/home_mahasiswa') { // Cek nama route
      final context = route?.navigator?.context;
      if (context != null) {
        final state = context.findAncestorStateOfType<_homeMahasiswaScreenState>();
        state?.refreshData(); // Panggil refreshData() untuk memuat ulang data
      }
    }
  }
}


class homeMahasiswaScreen extends StatefulWidget {
  @override
  _homeMahasiswaScreenState createState() => _homeMahasiswaScreenState();
}

class _homeMahasiswaScreenState extends State<homeMahasiswaScreen> {
  void refreshData() {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      loadMahasiswaData(token); // Memuat data ulang
    } else {
      print('User is not authenticated');
    }
  }

  // API Fetch
  String? mhsNama;
  int? mhsNim;
  String? pembimbing1;
  String? pembimbing2;
  String? ta_judul;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        mhsNama = data['data']['mahasiswa']['mhs_nama'];
        mhsNim = data['data']['mahasiswa']['mhs_nim'];
        ta_judul = data['data']['mahasiswa']['ta_judul'];

        if (data['data']['mahasiswa']['dosen'] != null) {
          pembimbing1 = data['data']['mahasiswa']['dosen'].length > 0
              ? data['data']['mahasiswa']['dosen'][0]['dosen_nama']
              : "Belum Diplotting";
          pembimbing2 = data['data']['mahasiswa']['dosen'].length > 1
              ? data['data']['mahasiswa']['dosen'][1]['dosen_nama']
              : "Belum Diplotting";
        } else {
          pembimbing1 = "Belum Diplotting";
          pembimbing2 = "Belum Diplotting";
        }
      });
    } catch (e) {
      print('Error: $e');

      setState(() {
        pembimbing1 = "Belum Diplotting";
        pembimbing2 = "Belum Diplotting";
      });
    }
  }

  String? userName;
  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userName = authProvider.userName;
    if (token != null) {
      loadMahasiswaData(token);
    } else {
      print('User is not authenticated');
    }

    // Refresh data setelah halaman muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        loadMahasiswaData(token); // Memuat data ulang setelah halaman muncul
      }
    });
  }

  // UI


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282A74),// Background warna #282A74
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
        backgroundColor: Color(0xFF282A74),
      ),
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
                        mhsNama != null && mhsNim != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      userName!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold, // Poppins Bold 15
                                        color: Colors.white,
                                      ),
                                    )
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    mhsNim!.toString(),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : CircularProgressIndicator(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.book, // Placeholder icon
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Pembimbing 1\n$pembimbing1',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500, // Poppins Medium 14
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40, // Tinggi garis vertikal
                          width: 1, // Lebar garis vertikal
                          color: Colors.white54, // Warna garis vertikal
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.book, // Placeholder icon
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Pembimbing 2\n$pembimbing2',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500, // Poppins Medium 14
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    margin: EdgeInsets.zero, // Fit ke layar tanpa ruang ekstra
                    elevation: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView( // Menggunakan SingleChildScrollView jika konten lebih panjang
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildMenuItem(
                              'Dashboard\nTugas Akhir',
                                  () {
                                if (ta_judul == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FinalProjectScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardScreen(),
                                    ),
                                  );
                                }

                                // Navigasi ke Dashboard Tugas Akhir
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
                                    builder: (context) => PembimbinganScreen(
                                      pembimbing: '',
                                    ),
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
                'assets/images/logout.png',
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
                    'assets/images/icon.png', // Gambar icon
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
                        'assets/images/no.png', // Gambar icon silang
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  // Tombol Centang
                  GestureDetector(
                    onTap: () {
                      _logout(
                          context); // Call the _logout function to clear the token and navigate to LoginPage
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green, // Background warna hijau
                        shape: BoxShape.circle, // Bentuk bulat
                      ),
                      padding: EdgeInsets.all(
                          12), // Padding untuk memberi ruang di sekitar gambar
                      child: Image.asset(
                        'assets/images/yes.png', // Gambar icon centang
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    // Clear token from SharedPreferences (or other storage)
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('token'); // assuming you stored the token under the key 'token'
    // Redirect to the login screen
    context.pushReplacement('/login');
  }
}
