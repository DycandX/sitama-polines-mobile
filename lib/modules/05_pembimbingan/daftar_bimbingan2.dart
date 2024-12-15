import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../05_pembimbingan/daftar_bimbingan_controller.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PDF path to display: $pdfPath");
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}

String generateShortFileName(String url) {
  final bytes = utf8.encode(url); // Convert the URL to bytes
  final hash = sha1.convert(bytes); // Generate SHA1 hash
  return hash.toString().substring(0, 40); // Safely use the full length of SHA1 hash
}

Future<void> downloadAndOpenPdf(BuildContext context, String url, String fileName) async {
  final token = Provider.of<AuthProvider>(context, listen: false).token;

  try {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to download PDF. Status code: ${response.statusCode}");
    }

    final Directory directory = await getTemporaryDirectory();
    final String safeFileName = generateShortFileName(url) + '.pdf';
    final String filePath = '${directory.path}/$safeFileName';

    await File(filePath).writeAsBytes(response.bodyBytes);

    // Check if the file exists before navigating
    final File file = File(filePath);
    if (await file.exists()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(pdfPath: filePath),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF file could not be found.')),
      );
    }
  } catch (e, stackTrace) {
    print("Download Error: $e");
    print("Stack Trace: $stackTrace");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading PDF: ${e.toString()}'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}


String truncateFileName(String fileName, {int maxLength = 50}) {
  if (fileName.length > maxLength) {
    return fileName.substring(0, maxLength) + '.pdf';
  }
  return fileName;
}

class DaftarBimbingan2 extends StatefulWidget {
  final String pembimbing;

  const DaftarBimbingan2({required this.pembimbing, super.key});

  @override
  _DaftarBimbingan2State createState() => _DaftarBimbingan2State();
}

class _DaftarBimbingan2State extends State<DaftarBimbingan2> {
  List<Map<String, String?>> revisiList = [];
  int revisionCount = 0; // Counter for revisions

  void _addRevisi(
      String title, String description, String? file, String? dosen, String? verified) {
    setState(() {
      revisionCount += 1; // Increment revision count for each new entry
      revisiList.add({
        'title': title,
        'description': description,
        'file': file,
        'dosen': dosen,
        'revisionNumber': 'Bimbingan ke-$revisionCount',
        'verified': verified,
      });
    });
  }

  // API fetch data
  String? mhsNama;
  String? pembimbing1_nama;
  String? pembimbing1_nip;

  bool isLoading = true;

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);

      setState(() {
        // Initialize default values for the fields

        pembimbing1_nama = null;
        pembimbing1_nip = null;

        // Assuming the response contains a list under 'logCollect'
        var logCollect = data['logCollect'] as List? ?? []; // Safe access

        logCollect.forEach((logItem) {
          if (logItem is Map<String, dynamic> && logItem['urutan'] == 2) {
            String title = logItem['bimb_judul'] ?? "";
            String description = logItem['bimb_desc'] ?? "";
            String? file = logItem['download_url'] ?? null;
            String? dosen = logItem['dosen_nama'] ?? "";
            String? verified = (logItem['bimb_status'] ?? 0).toString();

            _addRevisi(title, description, file, dosen, verified);

            pembimbing1_nama = logItem['dosen_nama'] ?? pembimbing1_nama;
            pembimbing1_nip = logItem['dosen_nip'] ?? pembimbing1_nip;
          }
        });

        mhsNama = data['data']?['mhs_nama'] ?? "-";


        if (data['data']?['mahasiswa']?['dosen'] != null &&
            (data['data']['mahasiswa']['dosen'] as List).isNotEmpty) {
          pembimbing1_nama = data['data']['mahasiswa']['dosen'][0]['dosen_nama'] ?? "-";
          pembimbing1_nip = data['data']['mahasiswa']['dosen'][0]['dosen_nip'] ?? "-";
        } else {
          pembimbing1_nama = "-";
          pembimbing1_nip = "-";
        }

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

  @override
  Widget build(BuildContext context) {
    print(revisiList);
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
        backgroundColor: const Color.fromRGBO(40, 42, 116, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button, Name, and Profile Picture Row
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
                  const SizedBox(height: 20),
                  const Text(
                    'Daftar Bimbingan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Expanded List Container
                  Expanded(
                    child: revisiList.isEmpty
                        ? const Center(child: Text('Belum ada bimbingan yang dibuat.'))
                        : ListView.builder(
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
                                          color: revisi['verified'] == '1'
                                              ? Colors.green
                                              : Colors.yellow,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        revisi['verified'] == '1'
                                            ? 'Sudah Diverifikasi'
                                            : 'Belum Diverifikasi',
                                        style: TextStyle(
                                          color: revisi['verified'] == '1'
                                              ? Colors.green
                                              : Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (revisi['dosen'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dosen: ${revisi['dosen']}',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ],
                              ),
                              trailing: revisi['file'] != null
                                  ? ElevatedButton(
                                onPressed: () {
                                  print('${Config.baseUrl}${revisi['file']}');
                                  final String pdfUrl = '${Config.baseUrl}${revisi['file']}';
                                  final String fileName = revisi['file']?.split('/').last ?? 'document.pdf';

                                  if (revisi['file'] != null) {
                                    final String safeFileName = truncateFileName(fileName, maxLength: 50);
                                    downloadAndOpenPdf(context, pdfUrl, safeFileName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('File tidak tersedia')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'Lihat',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                                  : SizedBox.shrink(),  // This hides the button if revisi['file'] is null

                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) =>
                  //               BuatRevisiScreen(onSave: _addRevisi),
                  //         ),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color.fromRGBO(27, 175, 27, 1),
                  //       padding: const EdgeInsets.symmetric(vertical: 14.0),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       '+ Buat Revisi',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
