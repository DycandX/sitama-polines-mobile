import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
import 'daftar_ta_controller.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';

class DaftarTaInput extends StatefulWidget {
  const DaftarTaInput({super.key});

  @override
  State<DaftarTaInput> createState() => _DaftarInputScreenState();
}

class _DaftarInputScreenState extends State<DaftarTaInput> {
  String? MhsNama;
  String? ta_judul;
  String? selectedJadwal;
  List<Map<String, dynamic>> jadwalList = [];

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      if (data != null) {
        setState(() {
          MhsNama = data['mahasiswa']['mhs_nama'];
          ta_judul = data['mahasiswa']['ta_judul'];
          _taInputController.text = ta_judul!;
        });

        if (data['jadwal'] != null) {
          setState(() {
            // Simplified jadwal list conversion
            jadwalList = (data['jadwal'] as Map<String, dynamic>)
                .values
                .map((value) => {
              'id': value['jadwal_id'].toString(),
              'sesi_nama': value['sesi_nama'],
              'tgl_sidang': value['tgl_sidang'],
              'hari_sidang': value['hari_sidang'],
            })
                .toList();
          });
        } else {
          print('Jadwal data is null');
        }
      } else {
        print('Data is null');
      }
    } catch (e) {
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

  final TextEditingController _taInputController = TextEditingController();

  @override
  void dispose() {
    _taInputController.dispose();
    super.dispose();
  }

  void _input(String string) async {
    final taJudul = _taInputController.text.trim();

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

    if (selectedJadwal == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Jadwal Sidang belum dipilih."),
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

      final response = await post(
        Uri.parse('${Config.baseUrl}daftar-tugas-akhir/daftar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'judulFinal': taJudul,
          'jadwal': selectedJadwal,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Judul Tugas Akhir berhasil disimpan."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        _taInputController.clear();
        setState(() {
          selectedJadwal = null; // Reset selectedJadwal after successful submission
        });
      } else {
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
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
        backgroundColor: const Color.fromRGBO(40, 42, 116, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and user information section
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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Sidang Tugas Akhir',
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _taInputController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Pilih Jadwal Sidang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10), // Tambahkan padding horizontal
                        child: Text('Pilih Jadwal'),
                      ),
                      value: selectedJadwal,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedJadwal = newValue;
                        });
                      },
                      items: jadwalList.map((jadwal) {
                        return DropdownMenuItem<String>(
                          value: jadwal['id'],
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              child: Text(
                              '${jadwal['sesi_nama']} - ${jadwal['tgl_sidang']} (${jadwal['hari_sidang']})',
                            ),
                          )
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _input(_taInputController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Daftar Sidang',
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
