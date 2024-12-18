import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';
import 'detail_screen.dart';
import 'package:pbl_sitama/profile_header.dart';
import 'sidang_ta_dosen_controller.dart';

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

  List<Map<String, dynamic>> dataSidang = [];

  // API fetch data
  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    setState(() {
      isLoading = true; // Set loading state before starting the API call
    });
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        // Initialize default values for the fields
        dataSidang.clear();

        var logCollect = data['data']['ta_mahasiswa'] as List? ?? [];
        print('Log Collect: $logCollect');

        for (var logItem in logCollect) {
          if (logItem is Map<String, dynamic>) {
            // Parsing tanggal dari string
            String formatTanggal = logItem['tgl_sidang'];
            DateTime tanggal = DateFormat("yyy-MM-dd").parse(formatTanggal);
            // Membandingkan dengan tanggal saat ini
            // String status = DateTime.now().isAfter(tanggal) ? "Sudah Melakukan Sidang" : "Belum Melakukan Sidang";

            String sebagai;
            if (logItem['isPembimbing'] == true) {
              sebagai = "Pembimbing";
            } else if (logItem['isPenguji'] == true) {
              sebagai = "Penguji";
            } else if (logItem['isSekre'] == true) {
              sebagai = "Sekretaris";
            } else {
              sebagai = "Tidak Ditentukan";
            }

            dataSidang.add({
              'ta_id': logItem['ta_id'],
              'nim': logItem['mhs_nim'],
              'name': logItem['mhs_nama'],
              'tahunAkademik': logItem['tahun_akademik'],
              'judulTA': logItem['ta_judul'],
              'status': logItem['nilai_akhir'] ?? "", // Menggunakan status yang ditentukan
              'ruangan': logItem['ruangan_nama'],
              'sebagai': sebagai,
              'ta_sidang_id': logItem['ta_sidang_id'],
            });
          }
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      // Initialize the locale data for 'id_ID'
        loadMahasiswaData(token);
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;
    double fontSizeTitle = screenWidth * 0.06;
    double fontSizeSubtitle = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 43, 116, 1),
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          ProfileHeader(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 20, 0),
            child: Column(
              children: [
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
                if(isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child :ListView.builder(
                      itemCount: dataSidang.length,
                      itemBuilder: (context, index) {
                        final sidang = dataSidang[index];
                        return Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                                        color: sidang['status'] != "" ? Colors.green : Colors.yellow, // Green if status is not empty, yellow if empty
                                        size: fontSizeSubtitle * 0.9,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        sidang['status'] != "" ? "Sudah Melakukan Sidang" : "Belum Melakukan Sidang", // Conditional text based on status
                                        style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
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
                                      ta_id: sidang['ta_id'],
                                      nim: sidang['nim'].toString(), // Ensure it's a string
                                      name: sidang['name'],
                                      tahunAkademik: sidang['tahunAkademik'].toString(), // Ensure it's a string
                                      judulTA: sidang['judulTA'],
                                      ruangan: sidang['ruangan'],
                                      sebagai: sidang['sebagai'],
                                      ta_sidang_id: sidang['ta_sidang_id'],
                                      onSave: (updatedEntry) => _updateEntry(index, updatedEntry),
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

  void _updateEntry(int index, Map<String, dynamic> updatedEntry) {
    setState(() {
      dataSidang[index] = updatedEntry;
    });
  }
}
