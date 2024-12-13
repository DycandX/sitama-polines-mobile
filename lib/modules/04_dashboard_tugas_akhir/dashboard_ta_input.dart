import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';
import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dashboard_ta_controller.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';

class FinalProjectScreen extends StatefulWidget {
  const FinalProjectScreen({super.key}); // Added key parameter

  @override
  State<FinalProjectScreen> createState() => _FinalProjectScreenState();
}

class _FinalProjectScreenState extends State<FinalProjectScreen> {
  String? MhsNama;
  String? ta_judul;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      setState(() {
        // Data mahasiswa dasar
        MhsNama = data['data']['mahasiswa']['mhs_nama'];
        ta_judul = data['data']['mahasiswa']['ta_judul'];

      });
    } catch (e) {
      setState;
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
  
  final TextEditingController _taInputController = TextEditingController();
  final TextEditingController _mhsInputController = TextEditingController();

  @override
  void dispose() {
    _taInputController.dispose();
    _mhsInputController.dispose();
    super.dispose();
  }

  void _input(String string) async {
    final taJudul = _taInputController.text.trim();
    final mhs_nim = _mhsInputController.text.trim();

    if (taJudul.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Judul Tugas Akhir tidak boleh kosong."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) {
        print('Token is missing');
        return;
      }

      // Kirim data ke API
      final response = await post(
        Uri.parse('${Config.baseUrl}dashboard-mahasiswa'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token
        },
        body: jsonEncode({
          'judul_ta': taJudul,
          'mhs_nim': mhs_nim,
        }),
      );

      if (response.statusCode == 200) {
        // Data berhasil disimpan di API
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Judul Tugas Akhir berhasil disimpan."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardScreen(), // Navigasi ke DashboardScreen
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        _taInputController.clear(); // Reset input field
      }else {
        // Gagal menyimpan data
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Gagal"),
            content: Text("Error: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error during API call: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("An error occurred: ${e.toString()}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan RawMaterialButton dan Row dalam satu baris
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-25, 0), // Menggeser ke kiri sebesar 10 piksel
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: Colors.indigo[900],
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                // Avatar dan Nama User
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      MhsNama ??
                          'Loading...', // Tampilkan 'Loading...' jika MhsNama masih null
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
            // Judul
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0), // Menggeser judul ke kanan
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan Judul Tugas Akhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[
                          200], // Light grey background to match the image
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _taInputController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nama Anggota Kelompok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[
                          200], // Light grey background to match the image
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      maxLines: 5,
                      controller: _mhsInputController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _input(
                          _taInputController.toString()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                            vertical: 15), // To match button height
                      ),
                      child: Text(
                        'Ajukan Judul',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
