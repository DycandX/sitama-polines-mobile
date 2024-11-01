import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/daftar_bimbingan_screen.dart';
import 'package:file_picker/file_picker.dart';

class BuatBimbinganScreen extends StatefulWidget {
  @override
  _BuatBimbinganScreenState createState() => _BuatBimbinganScreenState();
}

class _BuatBimbinganScreenState extends State<BuatBimbinganScreen> {
  String? selectedFileName;
  String? selectedPembimbing;
  String title = '';
  String schedule = '';
  String description = '';

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(40, 42, 116, 1),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Adnan Bima Adhi N',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/xaviera.png'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buat Bimbingan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Judul Bimbingan',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => title = value,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Pembimbing',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: selectedPembimbing,
                        items: [
                          DropdownMenuItem(
                            value: 'Pembimbing 1',
                            child: Text('Pembimbing 1'),
                          ),
                          DropdownMenuItem(
                            value: 'Pembimbing 2',
                            child: Text('Pembimbing 2'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPembimbing = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Jadwal Bimbingan',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => schedule = value,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: pickFile,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedFileName ?? 'Pilih File Lampiran',
                                style: TextStyle(
                                  color: selectedFileName == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(Icons.attach_file, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => description = value,
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              {
                                'title': title,
                                'pembimbing': selectedPembimbing,
                                'schedule': schedule,
                                'file': selectedFileName,
                                'description': description,
                              },
                            );
                          },
                          child: Text('Simpan', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
