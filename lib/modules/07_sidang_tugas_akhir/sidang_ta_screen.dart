import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/revisi_tugas_akhir/daftar_revisi.dart';

class SidangScreen extends StatefulWidget {
  const SidangScreen({super.key});
  @override
  _SidangScreenState createState() => _SidangScreenState();
}

class _SidangScreenState extends State<SidangScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.translate(
                  offset: Offset(-20, 0),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: Colors.indigo[900],
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      'Adnan Bima Adhi N',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            SizedBox(height: 30),
            Text(
              'Sidang',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Text(
              'Tugas Akhir',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 20),
            CustomExpansionCard(
              title: 'Data Sidang Tugas Akhir',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      CustomTextField(label: 'Pembimbing 1', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Pembimbing 2', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Penguji',
                          placeholderText: 'Belum Di Plotting'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Sekretaris',
                          placeholderText: 'Belum Di Plotting'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Tahun Akademik', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Judul Tugas Akhir',
                          maxLines: 2,
                          isEditable: false),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            CustomExpansionCard(
              title: 'Status',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      CustomTextField(label: 'Hari/Tanggal', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Ruangan', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Sesi', isEditable: false),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Status Sidang',
                          placeholderText: 'Belum melaksanakan sidang'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DaftarRevisiScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Revisi',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.menu, size: 24, color: Colors.black),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
          trailing: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
          children: children,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final String? placeholderText;
  final bool isEditable;

  const CustomTextField({super.key, 
    required this.label,
    this.maxLines = 1,
    this.placeholderText,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaceholder = placeholderText != null;
    return Container(
      margin: EdgeInsets.only(bottom: 8.0), // Adjust spacing between fields
      child: TextField(
        maxLines: maxLines,
        readOnly: true,
        controller:
            isPlaceholder ? TextEditingController(text: placeholderText) : null,
        style: isPlaceholder
            ? TextStyle(fontStyle: FontStyle.italic, color: Colors.red)
            : TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200], // Background color to match the image
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none, // Remove border
          ),
        ),
      ),
    );
  }
}
