import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import 'buat_revisi_controller.dart';
import 'package:provider/provider.dart';


class BuatRevisiDosenScreen extends StatefulWidget {
  final int nim;

  const BuatRevisiDosenScreen({super.key, required this.nim});

  @override
  State<BuatRevisiDosenScreen> createState() => _BuatRevisiDosenScreenState();
}

class _BuatRevisiDosenScreenState extends State<BuatRevisiDosenScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> dosenList = [];

  String? selectedFile;
  String title = '';
  String description = '';
  String? selectedDosen;
  String? userName;

  // API fetch data
  String? mhsNama;
  int? mhsNim;
  String? ta_judul;
  String? pembimbing1_nama;
  String? pembimbing2_nama;
  String? pembimbing1_nip;
  String? pembimbing2_nip;

  bool isLoading = true;

  final TextEditingController _deskripsiController = TextEditingController();


  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  void _input() async {
    final revisi_deskripsi = _deskripsiController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        final token = Provider.of<AuthProvider>(context, listen: false).token;
        if (token == null) {
          print('Token is missing');
          return;
        }

        var request = MultipartRequest(
          'POST',
          Uri.parse('${Config.baseUrl}revisi-dosen/${widget.nim}/store'),
        );
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });

        request.fields['revisi_deskripsi'] = revisi_deskripsi;

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          final respStr = await response.stream.bytesToString();
          final responseData = jsonDecode(respStr);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Revisi Berhasil Ditambahkan')),
            );
            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')),
            );
          }
        } else {
          final respStr = await response.stream.bytesToString();
          print('Error Response: $respStr');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Revisi Gagal Disimpan')),
          );
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userName = authProvider.userName;
  }
  // End of API Code
  
  get pembimbing => null;

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
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
        backgroundColor: const Color.fromRGBO(40, 42, 116, 1),
      ),
      body: Column(
        children: [
          // Bagian header (tetap fixed)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            Navigator.pop(context, true);
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
                  'Buat Revisi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Bagian form (scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Field untuk deskripsi
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Revisi',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Field ini harus diisi'
                            : null;
                      },
                      onSaved: (value) => description = value!,
                    ),
                    const SizedBox(height: 20),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _input,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(27, 175, 27, 1),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
