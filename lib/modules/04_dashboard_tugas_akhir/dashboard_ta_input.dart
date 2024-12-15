import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_screen.dart';
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
  int? selectedMhsNim; // Menyimpan mhs_nim yang dipilih

  @override
  void dispose() {
    _taInputController.dispose();
    _mhsInputController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchAutocompleteData(String query) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) throw Exception("Token is missing");

      final response = await get(
        Uri.parse('${Config.baseUrl}dashboard-mahasiswa/autocomplete?term=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        // Pastikan untuk memfilter berdasarkan query jika perlu
        return data.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'],     // mhs_nim
            'value': item['value'] // mhs_nama
          };
        }).where((item) {
          // Filter tambahan di frontend
          return item['value'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        throw Exception('Failed to fetch autocomplete data');
      }
    } catch (e) {
      print("Error fetching autocomplete data: $e");
      return [];
    }
  }

  void _input() async {
    final taJudul = _taInputController.text.trim();

    // Validasi hanya pada judul TA
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
      if (token == null) throw Exception("Token is missing");

      // Payload untuk API
      final payload = {
        'judul_ta': taJudul,
        'tim-id': selectedMhsNim, // Tambahkan jika tidak null
      };

      // Kirim request ke API
      final response = await post(
        Uri.parse('${Config.baseUrl}dashboard-mahasiswa'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Judul Tugas Akhir berhasil disimpan."),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Tutup dialog dulu
                  await Future.delayed(Duration(milliseconds: 300)); // Beri jeda sebentar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        _taInputController.clear();
      } else {
        throw Exception("Error: ${response.body}");
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

  Future<bool> _onWillPop() async {
    // Menavigasi kembali jika tidak ada masalah
    Navigator.pop(context);
    GoRouter.of(context).pushReplacement('/home_mahasiswa');

    return true;  // Menandakan bahwa pop boleh terjadi
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  Autocomplete<Map<String, dynamic>>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Map<String, dynamic>>.empty();
                      }
                      return await fetchAutocompleteData(textEditingValue.text);
                    },
                    displayStringForOption: (Map<String, dynamic> option) => option['value'], // Menampilkan mhs_nama
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Sama seperti input "Judul TA"
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            hintText: 'Cari anggota...',
                          ),
                        ),
                      );
                    },
                    onSelected: (Map<String, dynamic> selection) {
                      setState(() {
                        selectedMhsNim = selection['id']; // Simpan mhs_nim yang dipilih
                      });
                      print('Selected mhs_nim: ${selection['id']}');
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _input,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15),
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
    )
    );
  }
}
