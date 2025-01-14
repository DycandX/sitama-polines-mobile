import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/buat_revisi_screen.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';

class DaftarRevisiDosenScreen extends StatefulWidget {
  final int nim;

  const DaftarRevisiDosenScreen({super.key, required this.nim});

  @override
  State<DaftarRevisiDosenScreen> createState() => _DaftarRevisiDosenScreenState();
}

class _DaftarRevisiDosenScreenState extends State<DaftarRevisiDosenScreen> {
  List<Map<String, dynamic>> revisiList = [];
  int revisionCount = 0;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    final url = Uri.parse('${Config.baseUrl}revisi-dosen/${widget.nim}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          final data = jsonResponse['data'] as List;

          setState(() {
            revisiList = data.map((logItem) {
              return {
                'description': logItem['revisi_deskripsi'] ?? "",
                'dosen': logItem['dosen']['dosen_nama'] ?? "",
                'status': (logItem['revisi_status'] ?? 0).toString(),
                'revisionNumber': 'Revisi ke-${data.indexOf(logItem) + 1}',
                'revisi_id': logItem['id'],
              };
            }).toList();

            revisionCount = revisiList.length;
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading mahasiswa data: $e');
    }
  }

  Future<void> sendPostRequest(int revisiId) async {
    final String url = '${Config.baseUrl}setujui-revisi/$revisiId';
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    setState(() {
      isLoading = true; // Mulai loading
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        if (token != null) {
          await loadMahasiswaData(token);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisi berhasil disetujui')),
        );
      }
      else {
        print('Failed to send data: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisi gagal disetujui')),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // Selesai loading
      });
    }
  }

  Future<void> deleteRevisi(int revisiId) async {
    final String url = '${Config.baseUrl}revisi-dosen/$revisiId';
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    setState(() {
      isLoading = true; // Mulai loading
    });

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        if (token != null) {
          await loadMahasiswaData(token);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisi berhasil dihapus')),
        );
      }
      else {
        print('Failed to send data: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisi gagal hapus')),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // Selesai loading
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
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context,true);
    return false;  // Menandakan bahwa pop boleh terjadi
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color.fromARGB(250, 250, 250, 250),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
            child: Row(
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
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Container(
                      width: 150,
                      child: Text(
                        userName ?? "Loading...",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Revisi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  revisiList.isEmpty
                      ? const Text('Tidak ada revisi yang dibuat.')
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: revisiList.length,
                    itemBuilder: (context, index) {
                      final revisi = revisiList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              revisi['description'] ?? 'Judul Tidak Tersedia',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  revisi['revisionNumber'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: revisi['status'] == '1'
                                            ? Colors.green
                                            : Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(revisi['status'] == '1'
                                        ? 'Disetujui'
                                        : 'Belum Disetujui'),
                                  ],
                                ),
                                if (revisi['dosen'] != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dosen: ${revisi['dosen']}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (revisi['status'] != '1') ...[
                                        ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                            sendPostRequest(revisi['revisi_id']);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
                                          child: const Text(
                                            'Setujui',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: isLoading
                                            ? null
                                            : () {
                                            deleteRevisi(revisi['revisi_id']);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuatRevisiDosenScreen(
                                nim: widget.nim,
                              )),
                        );

                        if (result == true) {
                          final token = Provider.of<AuthProvider>(context, listen: false).token;
                          if (token != null) {
                            loadMahasiswaData(token); // Muat ulang data
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Tambah Revisi',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
