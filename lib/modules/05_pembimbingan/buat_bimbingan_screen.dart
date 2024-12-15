import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../05_pembimbingan/buat_bimbingan_controller.dart';

class BuatBimbinganScreen extends StatefulWidget {
  final Function(String title, String description, String? file, String? dosen)
      onSave;

  const BuatBimbinganScreen({super.key, required this.onSave});

  @override
  State<BuatBimbinganScreen> createState() => _BuatBimbinganScreenState();
}

class _BuatBimbinganScreenState extends State<BuatBimbinganScreen> {
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

  Future<void> loadMahasiswaData(String token) async {
    try {
      final data = await ApiService.fetchMahasiswa(token);
      setState(() {
        // Data mahasiswa dasar
        mhsNama = data['data']['mhs_nama'];
        mhsNim = data['data']['mhs_nim'];
        ta_judul = data['data']['ta_judul'];

        isLoading = false;
      });

      if (data['data']['dosen'] != null) {
        setState(() {
          dosenList = (data['data']['dosen'] as List<dynamic>)
              .map((value) => {
            'bimbingan_id': value['bimbingan_id'].toString(),
            'dosen_nama': value['dosen_nama'],
          })
              .toList();
        });
      } else {
        print('Jadwal data is null');
      }
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = result.files.single.path; // Simpan path file
      });
    } else {
      print('File picking canceled or failed');
    }
  }


  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tglController = TextEditingController();


  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _tglController.dispose();
    super.dispose();
  }

  void _input() async {
    final judul = _judulController.text.trim();
    final desk = _deskripsiController.text.trim();
    final tgl = _tglController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        final token = Provider.of<AuthProvider>(context, listen: false).token;
        if (token == null) {
          print('Token is missing');
          return;
        }

        var request = MultipartRequest(
          'POST',
          Uri.parse('${Config.baseUrl}bimbingan-mahasiswa'),
        );
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });

        request.fields['judul'] = judul;
        request.fields['desk'] = desk;
        request.fields['pembimbing'] = selectedDosen ?? '';
        request.fields['tgl'] = tgl;

        if (selectedFile != null) {
          request.files.add(await MultipartFile.fromPath(
            'draft',
            selectedFile!, // Pastikan ini adalah path file
          ));
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          _formKey.currentState?.reset();
          setState(() {
            selectedDosen = null;
            selectedFile = null;
          });
          _showDialog('Berhasil', 'Judul Tugas Akhir berhasil disimpan.');

          Navigator.pop(context);
        } else {
          final respStr = await response.stream.bytesToString();
          _showDialog('Gagal', 'Error: $respStr');
        }
      } catch (e) {
        _showDialog('Error', 'Terjadi kesalahan: ${e.toString()}');
      }
    }
  }


  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tglController.text = DateFormat('yyyy-MM-dd').format(picked); // Format ke 'yyyy-MM-dd'
      });
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
  // End of API Code
  
  get pembimbing => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
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
                        Text(
                          userName ?? "Loading...", // Ensure mhsNama is not null
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
                const SizedBox(height: 20),
                const Text(
                  'Buat Bimbingan',
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
                    TextFormField(
                      controller: _judulController,
                      decoration: InputDecoration(
                        labelText: 'Judul Bimbingan',
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
                      onSaved: (value) => title = value!,
                    ),
                    const SizedBox(height: 10),

                    // Dropdown untuk memilih dosen
                    DropdownButtonFormField<String>(
                      value: selectedDosen,
                      decoration: InputDecoration(
                        labelText: 'Pilih Pembimbing',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: dosenList.map((dosen) {
                        return DropdownMenuItem<String>(
                          value: dosen['bimbingan_id'],
                          child: Text(dosen['dosen_nama']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDosen = value;
                        });
                      },
                      validator: (value) {
                        return value == null ? 'Silahkan pilih dosen' : null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Tombol untuk memilih file
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedFile ?? 'File Lampiran',
                              style: TextStyle(
                                color: selectedFile != null
                                    ? Colors.black87
                                    : Colors.grey,
                                fontStyle: selectedFile == null
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                            const Icon(Icons.upload_file, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Field untuk tanggal
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _tglController,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Bimbingan',
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Field untuk deskripsi
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
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
    );
  }
}
