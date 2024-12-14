import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String nim;
  final String name;
  final String tahunAkademik;
  final String judulTA;
  final String ruangan;
  final String sebagai;
  final int ta_sidang_id;
  final String kedisiplinanBimbingan;
  final String kreativitasPemecahanMasalah;
  final String penguasaanMateri;
  final String kelengkapanReferensi;
  final Function(Map<String, dynamic>) onSave;

  const DetailScreen({
    super.key,
    required this.nim,
    required this.name,
    required this.tahunAkademik,
    required this.judulTA,
    required this.ruangan,
    required this.sebagai,
    required this.kedisiplinanBimbingan,
    required this.kreativitasPemecahanMasalah,
    required this.penguasaanMateri,
    required this.kelengkapanReferensi,
    required this.ta_sidang_id,
    required this.onSave,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController nimController;
  late TextEditingController nameController;
  late TextEditingController tahunAkademikController;
  late TextEditingController judulTAController;
  late TextEditingController ruanganController;
  late TextEditingController sebagaiController;
  late TextEditingController taSidangIdController;
  late TextEditingController kedisiplinanBimbinganController;
  late TextEditingController kreativitasPemecahanMasalahController;
  late TextEditingController penguasaanMateriController;
  late TextEditingController kelengkapanReferensiController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nimController = TextEditingController(text: widget.nim);
    nameController = TextEditingController(text: widget.name);
    tahunAkademikController = TextEditingController(text: widget.tahunAkademik);
    judulTAController = TextEditingController(text: widget.judulTA);
    ruanganController = TextEditingController(text: widget.ruangan);
    sebagaiController = TextEditingController(text: widget.sebagai);
    taSidangIdController = TextEditingController(text: widget.ta_sidang_id.toString());
    kedisiplinanBimbinganController =
        TextEditingController(text: widget.kedisiplinanBimbingan);
    kreativitasPemecahanMasalahController =
        TextEditingController(text: widget.kreativitasPemecahanMasalah);
    penguasaanMateriController =
        TextEditingController(text: widget.penguasaanMateri);
    kelengkapanReferensiController =
        TextEditingController(text: widget.kelengkapanReferensi);
  }

  @override
  void dispose() {
    nimController.dispose();
    nameController.dispose();
    tahunAkademikController.dispose();
    judulTAController.dispose();
    ruanganController.dispose();
    sebagaiController.dispose();
    taSidangIdController.dispose();
    kedisiplinanBimbinganController.dispose();
    kreativitasPemecahanMasalahController.dispose();
    penguasaanMateriController.dispose();
    kelengkapanReferensiController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    int taSidangId = int.parse(taSidangIdController.text);

    // Menentukan URL berdasarkan nilai widget.sebagai
    final String urlPath = widget.sebagai.toLowerCase() == 'pembimbing'
        ? 'ujian-sidang/kelayakan'
        : 'ujian-sidang/penguji';

    final url = Uri.parse('${Config.baseUrl}$urlPath/${taSidangId}');

    final body = {
      'nilaiId': ['1', '2', '3', '4'], // Array sesuai format server
      'unsur': {
        '1': kedisiplinanBimbinganController.text,
        '2': kreativitasPemecahanMasalahController.text,
        '3': penguasaanMateriController.text,
        '4': kelengkapanReferensiController.text,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Data saved successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data successfully saved!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save data')),
        );
        print('Failed to save data: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration readOnlyDecoration(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    // Kondisi untuk menyembunyikan form dan tombol
    bool hideFields = widget.sebagai.toLowerCase() == 'sekretaris';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Nilai Ujian Sidang Tugas Akhir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          const CircleAvatar(
            backgroundImage:
            NetworkImage('https://example.com/profile_image.jpg'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nimController,
                  decoration: readOnlyDecoration('NIM'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: readOnlyDecoration('Nama'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tahunAkademikController,
                  decoration: readOnlyDecoration('Tahun Akademik'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: judulTAController,
                  decoration: readOnlyDecoration('Judul TA'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ruanganController,
                  decoration: readOnlyDecoration('Ruangan'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: sebagaiController,
                  decoration: readOnlyDecoration('Sebagai'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                if (!hideFields) ...[
                  TextFormField(
                    controller: kedisiplinanBimbinganController,
                    decoration: const InputDecoration(
                      labelText: 'Kedisiplinan dalam Bimbingan',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: kreativitasPemecahanMasalahController,
                    decoration: const InputDecoration(
                      labelText: 'Kreativitas Pemecahan Masalah',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: penguasaanMateriController,
                    decoration: const InputDecoration(
                      labelText: 'Penguasaan Materi',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: kelengkapanReferensiController,
                    decoration: const InputDecoration(
                      labelText: 'Kelengkapan dan Referensi',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: saveData,
                    child: const Text('Simpan'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

}
