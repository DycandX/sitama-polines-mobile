import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen.dart';
import 'package:pbl_sitama/profile_header.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import 'home_dosen_controller.dart';

class JadwalSidangPage extends StatefulWidget {
  const JadwalSidangPage({super.key});

  @override
  _JadwalSidangPageState createState() => _JadwalSidangPageState();
}

class _JadwalSidangPageState extends State<JadwalSidangPage> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> jadwalSidang = [];

  bool isLoading = true;

  Future<void> loadJadwalSidang(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        final jadwalData = data['jadwal'] as Map<String, dynamic>;

        jadwalSidang = jadwalData.entries.map((entry) {
          final String tanggal = entry.key;
          final DateTime parsedDate = DateTime.parse(tanggal);
          final String hari = _getDayName(parsedDate.weekday);

          // Ambil sesi dan ruangan
          Map<String, dynamic> sesiData = entry.value;
          List<Map<String, String>> sesiList = [];

          // Proses setiap sesi dan ruangan
          sesiData.forEach((sesiKey, ruanganData) {
            ruanganData.forEach((ruanganKey, mahasiswaList) {
              sesiList.add({
                'sesi': sesiKey,
                'ruangan': ruanganKey,
                // Tentukan status berdasarkan tanggal
                'status': parsedDate.isBefore(DateTime.now()) ? 'Tidak Tersedia' : 'Tersedia',
              });
            });
          });

          return {
            'hari': hari,
            'tanggal': tanggal,
            'sesi': sesiList,
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return "Jum'at";
      case 6: return 'Sabtu';
      case 7: return 'Minggu';
      default: return '';
    }
  }

  @override
  void initState() {
    super.initState();

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      loadJadwalSidang(token);
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: jadwalSidang.length,
                    itemBuilder: (context, index) {
                      final jadwal = jadwalSidang[index];
                      final DateTime tanggalSidang =
                      DateTime.parse(jadwal['tanggal']);
                      final bool isPast =
                      tanggalSidang.isBefore(DateTime.now());

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Card(
                          margin:
                          const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: ExpansionTile(
                            title: Text(
                              '${jadwal['hari']}, ${jadwal['tanggal']}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: isPast ? Colors.grey : Colors.blue,
                              ),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide.none, // Hilangkan garis
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide.none, // Hilangkan garis
                            ),
                            children: (jadwal['sesi'] as List<Map<String, String>>).map<Widget>((sesi) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sesi: ${sesi['sesi']}',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Ruangan: ${sesi['ruangan']}',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Status: ${sesi['status']}',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
    );
  }
}
