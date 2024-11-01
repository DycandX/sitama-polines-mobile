import 'package:flutter/material.dart';

class StatusBimbinganScreen extends StatelessWidget {
  const StatusBimbinganScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Back Button, Name, and Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Adnan Bima Adhi N',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            const Text(
              'Status Bimbingan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Bimbingan Box 1
            BimbinganStatusBox(
              nama: "Nama",
              jumlahBimbingan: "8/8",
              persetujuan: "Telah Menyetujui Pendaftaran Sidang",
              isPembimbingUtama: true,
              onCetakPressed: () {
                // Action for Cetak Lembar Kontrol
              },
            ),
            const SizedBox(height: 16),
            // Bimbingan Box 2
            BimbinganStatusBox(
              nama: "Nama",
              jumlahBimbingan: "5/8",
              persetujuan: "Belum Menyetujui Pendaftaran Sidang",
              isPembimbingUtama: false,
              onCetakPressed: () {
                // Action for Cetak Lembar Kontrol
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BimbinganStatusBox extends StatelessWidget {
  final String nama;
  final String jumlahBimbingan;
  final String persetujuan;
  final bool isPembimbingUtama;
  final VoidCallback onCetakPressed;

  const BimbinganStatusBox({
    required this.nama,
    required this.jumlahBimbingan,
    required this.persetujuan,
    required this.isPembimbingUtama,
    required this.onCetakPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Nama", nama),
          _buildInfoRow("Jumlah Bimbingan", jumlahBimbingan),
          _buildInfoRow("Persetujuan Pendaftaran Sidang", persetujuan),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: isPembimbingUtama ? Colors.green : Colors.transparent,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                isPembimbingUtama ? "Pembimbing Utama" : "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isPembimbingUtama)
            Center(
              child: ElevatedButton(
                onPressed: onCetakPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Cetak Lembar Kontrol",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label :",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
