import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/daftar_bimbingan.dart';

class BuatBimbinganScreen extends StatefulWidget {
  final Function(String title, String description, String? file, String? dosen)
      onSave;

  const BuatBimbinganScreen({super.key, required this.onSave});

  @override
  State<BuatBimbinganScreen> createState() => _BuatBimbinganScreenState();
}

class _BuatBimbinganScreenState extends State<BuatBimbinganScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedFile;
  String title = '';
  String description = '';
  String? selectedDosen;

  // List of available dosen (lecturers)
  final List<String> dosenList = ['Azka', 'Zulvikar', 'Dewa'];
  
  get pembimbing => null;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = result.files.single.name;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(title, description, selectedFile, selectedDosen);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.indigo[900],
            height: 20,
            child: SafeArea(child: Container()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.blue),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 220),
                          const Text(
                            'Adnan Bima Adhi N',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, color: Colors.black),
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
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Judul Revisi',
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

                        // Dropdown for selecting Dosen
                        DropdownButtonFormField<String>(
                          value: selectedDosen,
                          decoration: InputDecoration(
                            labelText: 'Pilih Dosen',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: dosenList.map((dosen) {
                            return DropdownMenuItem(
                              value: dosen,
                              child: Text(dosen),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDosen = value;
                            });
                          },
                          validator: (value) {
                            return value == null
                                ? 'Silahkan pilih dosen'
                                : null;
                          },
                        ),

                        const SizedBox(height: 10),
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
                                const Icon(Icons.upload_file,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(27, 175, 27, 1),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
