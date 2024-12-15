import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/revisi_tugas_akhir/revisi_controller.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class DaftarRevisiScreen extends StatefulWidget {
  const DaftarRevisiScreen({super.key});

  @override
  State<DaftarRevisiScreen> createState() => _DaftarRevisiScreenState();
}

class _DaftarRevisiScreenState extends State<DaftarRevisiScreen> {
  List<Map<String, dynamic>> revisiList = [];
  int revisionCount = 0;

  String? mhsNama;
  String? pembimbing1Nama;
  String? pembimbing2Nama;
  String? ta_id;
  String? penguji1;
  String? penguji2;
  String? penguji3;
  String? nipPenguji1;
  String? nipPenguji2;
  String? nipPenguji3;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        // Populate student name
        mhsNama = data['data']['dosen']['mhs_nama'] ?? "-";
        penguji1 = data['data']['dosen']['penguji'][0]['penguji_nama'];
        penguji2 = data['data']['dosen']['penguji'][1]['penguji_nama'];
        penguji3 = data['data']['dosen']['penguji'][2]['penguji_nama'];
        nipPenguji1 = data['data']['dosen']['penguji'][0]['dosen_nip_penguji'];
        nipPenguji2 = data['data']['dosen']['penguji'][1]['dosen_nip_penguji'];
        nipPenguji3 = data['data']['dosen']['penguji'][2]['dosen_nip_penguji'];

        // Populate revision list
        var logCollect = data['data']['revisi'] as List? ?? [];
        revisiList = logCollect.mapIndexed((index, logItem) {
          return {
            'title': logItem['revisi_deskripsi'] ?? "",
            'description': logItem['revisi_deskripsi'] ?? "",
            'dosen': logItem['dosen']['dosen_nama'] ?? "",
            'status': (logItem['revisi_status'] ?? 0).toString(),
            'revisionNumber': 'Revisi ke-${index + 1}', // Use index to create unique revision number
            'revisiFile': logItem['revisi_file'],
            'revisiFileOriginal': logItem['revisi_file_original']
          };
        }).toList();

        revisionCount = revisiList.length;

        // Populate advisor names
        if (data['data']['dosen']['dosen'] != null &&
            (data['data']['dosen']['dosen'] as List).isNotEmpty) {
          pembimbing1Nama =
              data['data']['dosen']['dosen'][0]['dosen_nama'] ?? "-";
          if ((data['data']['dosen']['dosen'] as List).length > 1) {
            pembimbing2Nama =
                data['data']['dosen']['dosen'][1]['dosen_nama'] ?? "-";
          }
        }

        // Get TA ID
        ta_id = data['data']['dosen']['ta_id']?.toString() ?? "";

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading mahasiswa data: $e');
    }
  }

Future<void> downloadPdf(
      BuildContext context, String pdfUrl, String fileName) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      // Direktori untuk menyimpan file
      final directory = Directory('/storage/emulated/0/Download');
      final filePath = "${directory.path}/$fileName";

      // Mengunduh file dengan Dio
      Dio dio = Dio();
      Response response = await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/pdf',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File berhasil diunduh: $filePath")),
        );
      } else {
        throw Exception(
            "Failed to download PDF. Status code: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file: $e")),
      );
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

  @override
  Widget buildAdvisorBox(
    String advisorName,
    VoidCallback onCetakPressed,
  ) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            advisorName,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: onCetakPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Cetak Lembar Revisi',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0, // Menghapus shadow
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
                // Main Form Container
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
                              revisi['title'] ?? 'Judul Tidak Tersedia',
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
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Status Revisi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
  children: [
    buildAdvisorBox(
      penguji1 ?? 'Loading. . .',
      () {
        // Handle Cetak Lembar Revisi logic for Pembimbing Utama
        downloadPdf(context, "${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji1", "Lembar Revisi 1.pdf");
        // Navigator.pushNamed(context, '${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji1');
      },
    ),
    SizedBox(height: 16.0),
    buildAdvisorBox(
      penguji2 ?? 'Loading. . .',
      () {
        // Handle Cetak Lembar Revisi logic for Pembimbing 2
        downloadPdf(context, "${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji2", "Lembar Revisi 2.pdf");
        // Navigator.pushNamed(context, '${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji2');
      },
    ),
    SizedBox(height: 16.0),
      buildAdvisorBox(
        penguji3 ?? 'Loading. . .',
        () {
          // Handle Cetak Lembar Revisi logic for Pembimbing 2
          downloadPdf(context, "${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji3", "Lembar Revisi 3.pdf");
          // Navigator.pushNamed(context, '${Config.baseUrl}revisi-mahasiswa/cetak_lembar_revisi/$nipPenguji3');
        },
      ),
  ],
)
            // Bimbingan Status Boxes with dynamic data
            // BimbinganStatusBox(
            //   nama: pembimbing1Nama ?? 'Loading...',
            //   jumlahBimbingan:
            //       "0/0", // You'll need to add logic to get actual bimbingan count
            //   persetujuan: "Belum Disetujui",
            //   isPembimbingUtama: true,
            //   onCetakPressed: () {
            //     downloadPdf(
            //         context,
            //         "${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/1",
            //         "Lembar Kontrol 1.pdf");
            //   },
            // ),
            // const SizedBox(height: 10),
            // if (pembimbing2Nama != null)
            //   BimbinganStatusBox(
            //     nama: pembimbing2Nama!,
            //     jumlahBimbingan:
            //         "0/0", // You'll need to add logic to get actual bimbingan count
            //     persetujuan: "Belum Disetujui",
            //     isPembimbingUtama: false,
            //     onCetakPressed: () {
            //       downloadPdf(
            //           context,
            //           "${Config.baseUrl}bimbingan-mahasiswa/cetak_lembar_kontrol/$ta_id/2",
            //           "Lembar Kontrol 2.pdf");
            //     },
            //   ),
          ],
        ),
      ),
    ]
    )
    )
    );
  }

}
