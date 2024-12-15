import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/buat_bimbingan_screen.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/lihat_bimbingan_screen.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/status_bimbingan_screen.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../05_pembimbingan/pembimbingan_controller.dart';


class PembimbinganScreen extends StatefulWidget {
  final String pembimbing;

  const PembimbinganScreen({required this.pembimbing, super.key});

  @override
  _PembimbinganScreenState createState() => _PembimbinganScreenState();
}

class _PembimbinganScreenState extends State<PembimbinganScreen> {
  List<Map<String, dynamic>> bimbinganList = [];

  // API fetch data
  String? mhsNama;
  int? mhsNim;
  int? pembimbing1_count;
  int? pembimbing2_count;
  int? pembimbing1_count_total;
  int? pembimbing2_count_total;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      setState(() {
        // Data mahasiswa dasar
        mhsNama = data['data']['mhs_nama'];
        mhsNim = data['data']['mhs_nim'];
        pembimbing1_count = data['pembimbing1_count'];
        pembimbing2_count = data['pembimbing2_count'];
        pembimbing1_count_total = data['pembimbing1_count_total'];
        pembimbing2_count_total = data['pembimbing2_count_total'];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
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
  }
  // End of API Code

  Future<bool> _onWillPop() async {
    // Menavigasi kembali jika tidak ada masalah
    Navigator.pop(context);
    GoRouter.of(context).pushReplacement('/home_mahasiswa');

    return true;  // Menandakan bahwa pop boleh terjadi
  }

  @override
  Widget build(BuildContext context) {
    bool isDosenNotPlotted = pembimbing1_count == null && pembimbing2_count == null;
    bool isLoadingDosen = isDosenNotPlotted && isLoading;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
        backgroundColor: const Color.fromRGBO(40, 42, 116, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        GoRouter.of(context).pushReplacement('/home_mahasiswa');
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
                    Container(
                      width: 150,
                      child: Text(
                        userName ?? "Loading...", // Ensure mhsNama is not null
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
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
            const SizedBox(height: 24),
            // Title and progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pembimbingan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                    '${(pembimbing1_count ?? 0) + (pembimbing2_count ?? 0)}/${(pembimbing1_count_total ?? 0) + (pembimbing2_count_total ?? 0)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoadingDosen)
              Center(
                child: CircularProgressIndicator(), // Show loading spinner
              )
            else if (isDosenNotPlotted)
              Center(
                child: Text(
                  'Dosen Belum Diplotting',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              )
            else ...[
            // Lihat Bimbingan Button
            Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: ListTile(
                title: const Text(
                  'Lihat Bimbingan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LihatBimbinganScreen(pembimbing: '',),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text(
                    "Lihat",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            // Status Bimbingan Button
            Container(
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
              child: ListTile(
                title: const Text(
                  'Status Bimbingan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatusBimbinganScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text(
                    "Lihat",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buat Bimbingan Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuatBimbinganScreen(onSave: (String title, String description, String? file, String? dosen) {  },),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      bimbinganList.add(result);
                    });
                  }
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white,),
                label: const Text(
                  'Buat Bimbingan',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
          ],
        ),
      ),
    )
    );
  }
}
