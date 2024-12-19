import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../services/api_service.dart';
import '../../05_pembimbingan/daftar_bimbingan.dart';

class DatamhsTa extends StatefulWidget {
  final String title;
  final String desc;
  final String downloadUrl;
  final String status;
  final int bimbLogId;

  const DatamhsTa({super.key,
    required this.title,
    required this.desc,
    required this.downloadUrl,
    required this.status,
    required this.bimbLogId});

  @override
  State<DatamhsTa> createState() => _DatamhsTaState();
}

class _DatamhsTaState extends State<DatamhsTa> {
  // Api Code
  Future<void> sendPostRequest() async {
    final String url = '${Config.baseUrl}setujui-pembimbingan/${widget.bimbLogId}';
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil disetujui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal disetujui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String? userName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<AuthProvider>(context);
    userName = authProvider.userName;
  }
  // End of API Code

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
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
                        Navigator.pop(context, true);
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
                          userName ?? "Loading...",
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
            // Title Text
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                child: Text(
                  "Data Mahasiswa Bimbingan Tugas Akhir",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Student Info Card
            SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoRow("Judul", widget.title),
                          _buildInfoRow("Deskripsi", widget.desc),
                          SizedBox(height: 10),
                          // File Button Row
                          widget.downloadUrl == ""
                              ? SizedBox()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("File"),
                              ElevatedButton(
                                onPressed: () {
                                  print('${Config.baseUrl}${widget.downloadUrl}');
                                  final String pdfUrl = '${Config.baseUrl}${widget.downloadUrl}';
                                  final String fileName = widget.downloadUrl?.split('/').last ?? 'document.pdf';

                                  if (widget.downloadUrl != null) {
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Lihat File",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Approval Buttons
                          widget.status == "Diverifikasi"
                          ? SizedBox()
                          :Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Center the Row content
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(20),
                                      //       ),
                                      //       backgroundColor: Color.fromRGBO(40, 42, 116, 1), // Custom background color
                                      //       content: Column(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           Text(
                                      //             "Apakah Anda Yakin Ingin Menyetujui Bimbingan?",
                                      //             textAlign: TextAlign.center,
                                      //             style: TextStyle(
                                      //               color: Colors.white, // Text color
                                      //               fontWeight: FontWeight.bold,
                                      //               fontSize: 16,
                                      //             ),
                                      //           ),
                                      //           SizedBox(height: 20),
                                      //           Row(
                                      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      //             children: [
                                      //               // Cancel Button
                                      //               ElevatedButton(
                                      //                 onPressed: () {
                                      //                   Navigator.of(context).pop(); // Close the dialog
                                      //                 },
                                      //                 style: ElevatedButton.styleFrom(
                                      //                   backgroundColor: Colors.red,
                                      //                   shape: CircleBorder(),
                                      //                   padding: EdgeInsets.all(16),
                                      //                 ),
                                      //                 child: Icon(
                                      //                   Icons.close,
                                      //                   color: Colors.white,
                                      //                 ),
                                      //               ),
                                      //               // Confirm Button
                                      //               ElevatedButton(
                                      //                 onPressed: () {
                                      //                   Navigator.pop(context, true);
                                      //                   sendPostRequest();
                                      //                 },
                                      //                 style: ElevatedButton.styleFrom(
                                      //                   backgroundColor: Colors.green,
                                      //                   shape: CircleBorder(),
                                      //                   padding: EdgeInsets.all(16),
                                      //                 ),
                                      //                 child: Icon(
                                      //                   Icons.check,
                                      //                   color: Colors.white,
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   },
                                      // );
                                      await sendPostRequest(); // Pastikan operasi selesai
                                      if (mounted) {
                                        Navigator.pop(context, true); // Navigasi setelah operasi berhasil
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    ),
                                    child: Text(
                                      "Setuju",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    )
    );
  }

  // Helper method to build rows of student information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
