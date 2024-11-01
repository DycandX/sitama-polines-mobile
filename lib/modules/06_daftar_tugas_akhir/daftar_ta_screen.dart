import 'package:flutter/material.dart';
import 'daftar_ta_controller.dart';

class DaftarTaScreen extends StatefulWidget {
  const DaftarTaScreen({super.key});

  @override
  State<DaftarTaScreen> createState() => _DaftarTaScreenState();
}

class _DaftarTaScreenState extends State<DaftarTaScreen> {
  final DaftarTAController controller = DaftarTAController();

  @override
  Widget build(BuildContext context) {
    bool allVerified =
        controller.daftarTugas.every((item) => item.status == 'Diverifikasi');

    return Scaffold(
      backgroundColor: Colors.grey[200], // Ubah background menjadi abu-abu
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0, // Menghapus shadow
          backgroundColor: Colors.transparent, // Membuat AppBar transparan
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Adnan Bima Adhi N',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mahasiswa',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://example.com/path-to-your-image.jpg',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...controller.daftarTugas
                      .map((item) => buildTugasAkhirItem(item)),
                ],
              ),
            ),
            if (allVerified)
              ElevatedButton(
                onPressed: () {
                  controller.checkSyarat(context);
                },
                child: Text('Daftar Sidang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Ubah bentuk tombol menjadi kotak dengan edge
                  ),
                ),
              ),
            if (!allVerified)
              Container(
                color: Colors.yellow[700],
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'PERHATIAN:Anda belum bisa mendaftar sidang. Semua syarat wajib diverifikasi terlebih dahulu.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTugasAkhirItem(TugasAkhirItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white, // Ubah warna Card menjadi putih
      child: ListTile(
        title: Text(item.namaDokumen),
        subtitle: Text(item.status),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.isUploaded || item.status == 'Menunggu Divalidasi')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    print("${item.namaDokumen} clicked!");
                  });
                },
                child: Text('Lihat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Ubah bentuk tombol menjadi kotak dengan edge
                  ),
                ),
              ),
            if (item.isUploaded || item.status == 'Menunggu Divalidasi')
              SizedBox(width: 8),
            if (item.isUploaded || item.status == 'Menunggu Divalidasi')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    print("Edit ${item.namaDokumen} clicked!");
                  });
                },
                child: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Ubah bentuk tombol menjadi kotak dengan edge
                  ),
                ),
              ),
            if (!item.isUploaded && item.status == 'Belum Upload')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    item.status = 'Menunggu Divalidasi';
                    item.isUploaded = true;
                  });
                },
                child: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Ubah bentuk tombol menjadi kotak dengan edge
                  ),
                ),
              ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: item.getColorIndicator(),
          radius: 8,
        ),
      ),
    );
  }
}
