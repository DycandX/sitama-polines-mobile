import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/daftar_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen.dart';
import 'package:pbl_sitama/profile_header.dart';
import 'package:provider/provider.dart';

import '../../../services/api_service.dart';
import 'mahasiswa_bimbingan_controller.dart';

// Model untuk mewakili data mahasiswa
class Mahasiswa {
  final int? nim;
  final String? nama;
  final String? judulTugas;
  final int? progress;
  final int? taId;
  final int? verified;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.judulTugas,
    required this.progress,
    required this.taId,
    required this.verified,
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  // Daftar mahasiswa (data dummy)
  // final List<Mahasiswa> mahasiswas = [
  //   Mahasiswa(
  //       nim: 123,
  //       nama: 'Saifullah',
  //       judulTugas: 'Cara Mengirim Januar Tanpa Rusak Di Perjalanan',
  //       progress: 5),
  //   Mahasiswa(
  //       nim: 1234,
  //       nama: 'Nawasena',
  //       judulTugas: 'Menanam Mangrove Dengan Benar',
  //       progress: 8),
  //   Mahasiswa(
  //       nim: 12,
  //       nama: 'Nawasena',
  //       judulTugas: 'Menanam Mangrove Dengan Benar',
  //       progress: 8),
  //   Mahasiswa(
  //       nim: 1234,
  //       nama: 'Nawasena',
  //       judulTugas: 'Menanam Mangrove Dengan Benar',
  //       progress: 8),
  // ];

  // API fetch data
  bool isLoading = true;
  int? masterJumlah;
  final List<Mahasiswa> mahasiswas = [];
  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        // Initialize default values for the fields

        // Reset daftar mahasiswa sebelum diisi ulang
        mahasiswas.clear();

        // Ambil data log mahasiswa dari response API
        var logCollect = data['data']['ta_mahasiswa'] as List? ?? [];

        // Isi daftar mahasiswa dari data log
        for (var logItem in logCollect) {
          if (logItem is Map<String, dynamic>) {
            mahasiswas.add(Mahasiswa(
              nim: logItem['mhs_nim'],
              nama: logItem['mhs_nama'],
              judulTugas: logItem['ta_judul'],
              progress: int.parse(logItem['jml_bimbingan_valid']),
              taId: logItem['ta_id'],
              verified: logItem['verified'],
            ));
          }
        }
        masterJumlah = data['data']['masterJumlah'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
    print('API Response: ${mahasiswas}');
  }

  @override
  void initState() {
    super.initState();

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      loadMahasiswaData(token);
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 43, 116, 1),
        toolbarHeight: 0,
      ),
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      body: Stack(
        children: [
          ProfileHeader(), // Tetap di bagian atas
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 20, 0), // Beri ruang untuk ProfileHeader
            child: Column(
              children: [
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
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if(!isLoading)
                Expanded(
                  child: ListView.builder(
                    itemCount: mahasiswas.length,
                    itemBuilder: (context, index) {
                      final mahasiswa = mahasiswas[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "Nama : ${mahasiswa.nama}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "Judul  : ${mahasiswa.judulTugas}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Navigasi ke halaman DaftarBimbingan dan tunggu sampai halaman kembali
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DaftarBimbingan(
                                              taId: mahasiswa.taId!,
                                              verified: mahasiswa.verified!,
                                              progress: mahasiswa.progress!,
                                              masterJumlah: masterJumlah!,
                                            ),
                                          ),
                                        );

                                        // Periksa apakah data berhasil kembali dan lakukan refresh
                                        if (result != null) {
                                          setState(() {
                                            // Panggil kembali data mahasiswa setelah kembali
                                            final token = Provider.of<AuthProvider>(context, listen: false).token;
                                            if (token != null) {
                                              loadMahasiswaData(token);  // Memanggil ulang API untuk refresh data
                                            }
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        backgroundColor: const Color.fromARGB(255, 50, 111, 233),
                                      ),
                                      child: Text(
                                        "Lihat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
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
                                          color: (mahasiswa.progress != null && mahasiswa.progress! >= masterJumlah!)
                                              ? Colors.green
                                              : Colors.yellow,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${mahasiswa.progress}/${masterJumlah}',
                                          style: TextStyle(fontSize: 16),
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
              ],
            ),
          ),
        ],
      ),

      // Floating navigation bar
      // Positioned(
      //   left: 20,
      //   right: 20,
      //   bottom: 30,
      //   child: Container(
      //     height: 80, // Increase height to give more space
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(40), // More rounded edges
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.1),
      //           blurRadius: 10,
      //           offset: Offset(0, 5),
      //         ),
      //       ],
      //     ),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(40),
      //       child: BottomNavigationBar(
      //         backgroundColor: Colors.white,
      //         elevation: 0,
      //         type: BottomNavigationBarType.fixed,
      //         currentIndex: selectedIndex, // Set index of selected item
      //         selectedItemColor:
      //             Color.fromARGB(255, 55, 66, 230), // Selected icon color
      //         unselectedItemColor: Colors.grey, // Unselected icon color
      //         onTap: _onItemTapped,
      //         items: const [
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.home),
      //             label: 'Home',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.groups),
      //             label: 'Bimbingan',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.note_alt),
      //             label: 'Menguji',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.person),
      //             label: 'Profile',
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MahasiswaBimbingan()));
}
