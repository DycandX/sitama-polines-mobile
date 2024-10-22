import 'package:flutter/material.dart';
import 'package:pbl_sitama/main.dart';

class DashboardTaTampilan extends StatefulWidget {
  const DashboardTaTampilan({super.key});

  @override
  State<DashboardTaTampilan> createState() => _DashboardTaTampilanState();
}

class _DashboardTaTampilanState extends State<DashboardTaTampilan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 10,
        backgroundColor: Colors.indigo[900],
        title: Text('', style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan RawMaterialButton dan Row dalam satu baris
            Row(
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.indigo[900],
                  child: Icon(
                    Icons.arrow_back,
                    size: 15.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                // Avatar dan Nama User
                Row(
                  children: [
                    SizedBox(width: 160),
                    Text(
                      'Adnan Bima Adhi N',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            // Judul
            Text(
              'Dashboard Tugas Akhir',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            // Text(
            //   'Tugas Akhir',
            //   style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black87),
            // ),
            SizedBox(height: 20),
            // Expansion for Data Mahasiswa
            CustomExpansionCard(
              title: 'Data Mahasiswa',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      CustomTextField(label: 'Nama'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIM'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Program Studi'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Tahun Ajaran'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Judul Tugas Akhir', maxLines: 2),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Expansion for Data Pembimbing
            CustomExpansionCard(
              title: 'Data Pembimbing',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'Dosen Pembimbing 1',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Nama Pembimbing'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP'),
                      SizedBox(height: 10),
                      Text(
                        'Dosen Pembimbing 2',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(label: 'Nama Pembimbing'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP'),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
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

  CustomExpansionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(Icons.menu, size: 30, color: Colors.black),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: children,
        trailing: Icon(Icons.arrow_drop_down, size: 30, color: Colors.black),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;

  CustomTextField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
