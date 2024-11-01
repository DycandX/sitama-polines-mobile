import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variabel untuk menandakan apakah plotting sudah dilakukan atau belum
  bool isPlottingDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RawMaterialButton and Row in the same line
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-25, 0), // Menggeser ke kiri sebesar 10 piksel
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
                // Avatar dan Nama User
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      'Adnan Bima Adhi N',
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
            SizedBox(height: 30),
            // Titles
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0), // Menggeser judul ke kanan
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Tugas Akhir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Expansion for Data Mahasiswa
            CustomExpansionCard(
              title: 'Data Mahasiswa',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          label: 'Nama', value: 'Adnan Bima Adhi Nugroho'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIM', value: '43323203'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Program Studi',
                          value: 'Teknologi Rekayasa Komputer'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Tahun Ajaran', value: '2024/2025'),
                      SizedBox(height: 10),
                      CustomTextField(
                          label: 'Judul Tugas Akhir',
                          value: 'Sitama Mobile',
                          maxLines: 2),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosen Pembimbing 1',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                          label: 'Nama Pembimbing',
                          value: 'Suko Tyas Pernanda, S.ST., M.Cs	'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP', value: '1987654321'),
                      SizedBox(height: 40),
                      Text(
                        'Dosen Pembimbing 2',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                          label: 'Nama Pembimbing',
                          value: 'Wiktasari, S.T., M.Kom.	'),
                      SizedBox(height: 10),
                      CustomTextField(label: 'NIP', value: '1987654322'),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Tampilkan peringatan jika plotting belum selesai
            if (!isPlottingDone)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // Jarak dari tepi layar
                child: Container(
                  width: double.infinity, // Lebar penuh sesuai layar
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow[500],
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Menempatkan konten di tengah vertikal
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Menempatkan konten di tengah horizontal
                    children: [
                      Text(
                        'DATA PEMBIMBING BELUM DI PLOTTING!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign
                            .center, // Pusatkan teks dalam `Text` widget
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sedang Proses Plotting Pembimbing',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign
                            .center, // Pusatkan teks dalam `Text` widget
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final int maxLines;

  const CustomTextField({
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Updated CustomExpansionCard
class CustomExpansionCard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionCard({required this.title, required this.children});

  @override
  _CustomExpansionCardState createState() => _CustomExpansionCardState();
}

class _CustomExpansionCardState extends State<CustomExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.black87),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
