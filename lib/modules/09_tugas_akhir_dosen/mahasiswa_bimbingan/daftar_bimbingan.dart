import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/dataMhs_ta.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';
import 'daftar_bimbingan_controller.dart';

class DaftarBimbingan extends StatefulWidget {
  final int taId;

  const DaftarBimbingan({Key? key, required this.taId}) : super(key: key);

  @override
  State<DaftarBimbingan> createState() => _DaftarBimbinganState();
}

class _DaftarBimbinganState extends State<DaftarBimbingan> {
  // final List<Map<String, dynamic>> guidanceList = [
  //   {"title": "Bimbingan 1", "status": "Diverifikasi", "isVerified": true},
  //   {"title": "Bimbingan 2", "status": "Diverifikasi", "isVerified": true},
  //   {"title": "Bimbingan 3", "status": "Diverifikasi", "isVerified": true},
  //   {"title": "Bimbingan 4", "status": "Diverifikasi", "isVerified": true},
  //   {"title": "Bimbingan 5", "status": "Diverifikasi", "isVerified": true},
  //   {
  //     "title": "Bimbingan 6",
  //     "status": "Belum Diverifikasi",
  //     "isVerified": false
  //   },
  //   {
  //     "title": "Bimbingan 7",
  //     "status": "Belum Diverifikasi",
  //     "isVerified": false
  //   },
  //   {
  //     "title": "Bimbingan 8",
  //     "status": "Belum Diverifikasi",
  //     "isVerified": false
  //   },
  // ];
  String? userName;
  String? urutan;
  bool isLoading = true;
  final List<Map<String, dynamic>> guidanceList = [];
  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token, widget.taId);
      setState(() {
        // Reset daftar mahasiswa sebelum diisi ulang
        // guidanceList.clear();

        // Ambil data log mahasiswa dari response API
        var logCollect = data['data']['bimbLog'] as List? ?? [];
        urutan = data['data']['mahasiswa']['urutan'] ?? 'default_value';
        for (var logItem in logCollect) {
          if (logItem is Map<String, dynamic>) {
            String title = logItem['bimb_judul'] ?? "Judul Tidak Ditemukan";
            String status = logItem['bimb_status'] == 1 ? "Diverifikasi" : "Belum Diverifikasi";
            bool isVerified = logItem['bimb_status'] == 1;

            // Tambahkan data ke guidanceList
            guidanceList.add({
              "title": title,
              "status": status,
              "isVerified": isVerified,
            });
          }
        }

        userName = Provider.of<AuthProvider>(context).userName;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
    print('urutan : ${urutan}');
    print('API Response: ${guidanceList}');
  }

  Future<void> sendPostRequest() async {
    final String url = '${Config.baseUrl}setujui-sidang-akhir/${widget.taId}';
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Pastikan token ada di sini
        },
        body: jsonEncode(<String, dynamic>{'urutan': urutan}),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Response data: ${response.body}');
      } else {
        // Handle error response
        print(urutan);
        print(url);
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Back Button, Name, and Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: const Color.fromRGBO(40, 42, 116, 1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MahasiswaBimbingan()),
                        );
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 150), // Atur lebar maksimum
                        child: Text(
                          userName!,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/xaviera.png'),
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            // Title Row for "Daftar Bimbingan" and count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daftar Bimbingan",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  Text("8/8", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // List of Bimbingan
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                itemCount: guidanceList.length,
                itemBuilder: (context, index) {
                  final guidance = guidanceList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        guidance["title"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: guidance["isVerified"]
                                ? Colors.green
                                : Colors.orange,
                          ),
                          SizedBox(width: 6),
                          Text(
                            guidance["status"],
                            style: TextStyle(
                              color: guidance["isVerified"]
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DatamhsTa()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Lihat",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Approve Button at the Bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  sendPostRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                    child: Text(
                  "Setujui Sidang",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
