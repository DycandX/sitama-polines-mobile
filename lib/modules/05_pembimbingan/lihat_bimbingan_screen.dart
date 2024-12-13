import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/daftar_bimbingan.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../05_pembimbingan/lihat_bimbingan_controller.dart';
import 'daftar_bimbingan2.dart';


class LihatBimbinganScreen extends StatefulWidget {
  const LihatBimbinganScreen({super.key, required String pembimbing});

  @override
  State<LihatBimbinganScreen> createState() => _LihatBimbinganScreenState();
}

class _LihatBimbinganScreenState extends State<LihatBimbinganScreen> {
  bool isDataPlotted = true; // This should come from the database
  String pembimbing1 = "Pembimbing 1";
  String pembimbing2 = "Pembimbing 2";

  // API fetch data
  String? mhsNama;
  String? pembimbing1_nama;
  String? pembimbing2_nama;
  int? mhsNim;
  int? countStatus1Pembimbing1;
  int? countStatus1Pembimbing2;
  int? countTotalPembimbing1;
  int? countTotalPembimbing2;
  int? masterJumlah;
  int? pembimbing_count_1;
  int? pembimbing_count_2;
  int? pembimbing_count_1_total;
  int? pembimbing_count_2_total;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      setState(() {
        // Data mahasiswa dasar
        mhsNama = data['data']['mhs_nama'];
        mhsNim = data['data']['mhs_nim'];
        pembimbing1_nama = data['data']['dosen'][0]['dosen_nama'];
        pembimbing2_nama = data['data']['dosen'][1]['dosen_nama'];
        masterJumlah = data['masterJumlah'];

        pembimbing_count_1 = data['pembimbing1_count'];
        pembimbing_count_2 = data['pembimbing2_count'];
        pembimbing_count_1_total = data['pembimbing1_count_total'];
        pembimbing_count_2_total = data['pembimbing2_count_total'];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }


  String getStatusText(int? pembimbingCount, int? pembimbingCountTotal) {
    if (pembimbingCount == null || pembimbingCountTotal == null) {
      return "Tidak Lengkap";
    }
    return pembimbingCount >= pembimbingCountTotal ? "Lengkap" : "Tidak Lengkap";
  }


  Color getStatusColor(int? pembimbingCount, int? pembimbingCountTotal) {
    if (pembimbingCount == null || pembimbingCountTotal == null) {
      return Colors.red;
    }
    return pembimbingCount >= pembimbingCountTotal ? Colors.green : Colors.red;
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
  // End of API Code

  @override
  Widget build(BuildContext context) {
    print(masterJumlah);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDataPlotted
            ? Column(
                children: [
                  // Header Row with Back Button, Name, and Avatar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromRGBO(40, 42, 116, 1),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer(),
                      // Avatar dan Nama User
                      Row(
                        children: [
                          SizedBox(width: 30),
                          Text(
                            mhsNama ?? "Loading...", // Ensure mhsNama is not null
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.person, size: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pembimbing 1 Box
                  PembimbingBox(
                    pembimbing: pembimbing1_nama ?? 'Loading . . .',
                    pembimbing_ke: "Pembimbing ke 1",
                    statusText: getStatusText(
                      pembimbing_count_1,
                      masterJumlah,
                    ),
                    statusColor: getStatusColor(
                      pembimbing_count_1,
                      masterJumlah,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarBimbinganScreen(pembimbing: pembimbing1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Pembimbing 2 Box
                  PembimbingBox(
                    pembimbing: pembimbing2_nama ?? "Loading . . .",
                    pembimbing_ke: "Pembimbing ke 2",
                    statusText: getStatusText(
                      pembimbing_count_2,
                      masterJumlah,
                    ),
                    statusColor: getStatusColor(
                      pembimbing_count_2,
                      masterJumlah,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarBimbingan2(pembimbing: pembimbing2),
                        ),
                      );
                    },
                  ),
                ],
              )
            : Container(
                color: Colors.yellow[100],
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Data Pembimbing belum di-plotting!',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
      ),
    );
  }
}

class PembimbingBox extends StatelessWidget {
  final String pembimbing;
  final String pembimbing_ke;
  final String statusText;
  final Color statusColor;
  final VoidCallback onTap;

  const PembimbingBox({super.key, 
    required this.pembimbing,
    required this.pembimbing_ke,
    required this.statusText,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pembimbing,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pembimbing_ke,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: statusColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: const Text(
                "Lihat",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}