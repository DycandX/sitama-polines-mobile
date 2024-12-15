import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';

import '../04_dashboard_tugas_akhir/dashboard_ta_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // API fetch data
  String? mhsNama;
  int? mhsNim;
  String? program_studi;
  String? tahun_akademik;
  String? ta_judul;
  String? pembimbing1_nama;
  String? pembimbing2_nama;
  String? pembimbing1_nip;
  String? pembimbing2_nip;
  String? dosen_nama;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      setState(() {
        // Data mahasiswa dasar
        mhsNama = data['data']['mahasiswa']['mhs_nama'];
        mhsNim = data['data']['mahasiswa']['mhs_nim'];
        program_studi = data['data']['mahasiswa']['program_studi'];
        tahun_akademik = data['data']['mahasiswa']['tahun_akademik'];
        ta_judul = data['data']['mahasiswa']['ta_judul'];
        dosen_nama = data['data']['mahasiswa']['dosen_nama'];

        // Penanganan data dosen yang lebih aman
        if (data['data']['mahasiswa']['dosen'] != null &&
            (data['data']['mahasiswa']['dosen'] as List).isNotEmpty) {
          // Pembimbing 1
          pembimbing1_nama = data['data']['mahasiswa']['dosen'].length > 0
              ? data['data']['mahasiswa']['dosen'][0]['dosen_nama']
              : "-";
          pembimbing1_nip = data['data']['mahasiswa']['dosen'].length > 0
              ? data['data']['mahasiswa']['dosen'][0]['dosen_nip']
              : "-";

          // Pembimbing 2
          pembimbing2_nama = data['data']['mahasiswa']['dosen'].length > 1
              ? data['data']['mahasiswa']['dosen'][1]['dosen_nama']
              : "-";
          pembimbing2_nip = data['data']['mahasiswa']['dosen'].length > 1
              ? data['data']['mahasiswa']['dosen'][1]['dosen_nip']
              : "-";
        } else {
          // Default jika tidak ada data dosen
          pembimbing1_nama = "-";
          pembimbing1_nip = "-";
          pembimbing2_nama = "-";
          pembimbing2_nip = "-";
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;

        // Optional: Set default values on error
        pembimbing1_nama = "-";
        pembimbing1_nip = "-";
        pembimbing2_nama = "-";
        pembimbing2_nip = "-";
      });
      print('Error: $e');
    }
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

  // Variabel untuk menandakan apakah plotting sudah dilakukan atau belum
  bool isPlottingDone = false;

  Future<bool> _onWillPop() async {
    // Menavigasi kembali jika tidak ada masalah
    Navigator.pop(context);
    GoRouter.of(context).pushReplacement('/home_mahasiswa');

    return true;  // Menandakan bahwa pop boleh terjadi
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated;

    if (!isAuthenticated) {
      return Center(child: Text("You are not logged in."));
    }

    // Show loading indicator if data is still loading
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 10, // Adjusted for better alignment
          toolbarHeight: 10, // Adjusted height for better header presentation
          backgroundColor: Colors.indigo[900],
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Show loading spinner
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RawMaterialButton and Row in the same line
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
            SizedBox(height: 30),
            // Titles
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0), // Shift title to the right
              child: mhsNama == null
                  ? const Text(
                      'Failed to load data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mhsNama == null)
                          const Text(
                            'Failed to load data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        else ...[
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Tugas Akhir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          // Additional data fields
                        ],
                      ],
                    ),
            ),
            SizedBox(height: 20),

            // Expansion for Data Mahasiswa
            CustomExpansionCard(
              title: 'Data Mahasiswa',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(label: 'Nama', value: mhsNama!),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIM', value: mhsNim!.toString()),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Program Studi', value: program_studi!),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Tahun Ajaran', value: tahun_akademik!),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Judul Tugas Akhir',
                          value: ta_judul!,
                          maxLines: 2),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),
            // Expansion for Data Pembimbing
            
            CustomExpansionCard(
              title: 'Data Pembimbing',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosen Pembimbing 1',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                          label: 'Nama Pembimbing',
                          value: pembimbing1_nama!),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP', value: pembimbing1_nip!),
                      SizedBox(height: 40),
                      Text(
                        'Dosen Pembimbing 2',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                          label: 'Nama Pembimbing',
                          value: pembimbing2_nama!),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP', value: pembimbing2_nip!),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Tampilkan peringatan jika plotting belum selesai
            if (dosen_nama == null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // Jarak dari tepi layar
                child: Container(
                  width: double.infinity, // Lebar penuh sesuai layar
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow[500],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Menempatkan konten di tengah vertikal
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Menempatkan konten di tengah horizontal
                    children: [
                      Text(
                        'DATA PEMBIMBING BELUM DI PLOTTING!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign:
                            TextAlign.center, // Pusatkan teks dalam Text widget
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sedang Proses Plotting Pembimbing',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign:
                            TextAlign.center, // Pusatkan teks dalam Text widget
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    )
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final int maxLines;

  const CustomTextField({
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Updated CustomExpansionCard
class CustomExpansionCard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionCard({required this.title, required this.children});

  @override
  _CustomExpansionCardState createState() => _CustomExpansionCardState();
}

class _CustomExpansionCardState extends State<CustomExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.black87),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
