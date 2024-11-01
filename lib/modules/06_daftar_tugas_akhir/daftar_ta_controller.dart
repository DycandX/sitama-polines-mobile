import 'package:flutter/material.dart';

class DaftarTAController {
  List<TugasAkhirItem> daftarTugas = [
    TugasAkhirItem(
      namaDokumen: 'Surat Keterangan Magang',
      status: 'Menunggu Divalidasi',
      isUploaded: true,
    ),
    TugasAkhirItem(
      namaDokumen: 'Surat Keterangan KKL',
      status: 'Belum Upload',
      isUploaded: false,
    ),
    TugasAkhirItem(
      namaDokumen: 'Sertifikat TOEIC',
      status: 'Menunggu Divalidasi',
      isUploaded: true,
    ),
    TugasAkhirItem(
      namaDokumen: 'Naskah Tugas Akhir/Skripsi',
      status: 'Menunggu Divalidasi',
      isUploaded: true,
    ),
    TugasAkhirItem(
      namaDokumen: 'Surat Keterangan Selesai Bimbingan',
      status: 'Diverifikasi',
      isUploaded: true,
    ),
    TugasAkhirItem(
      namaDokumen: 'Form Keterangan Siap Ujian',
      status: 'Diverifikasi',
      isUploaded: true,
    ),
    TugasAkhirItem(
      namaDokumen: 'Sertifikasi Kompetisi (Oracle, Mtcna, Dll)',
      status: 'Diverifikasi',
      isUploaded: true,
    ),
    // Tambahkan item lain sesuai kebutuhan
  ];

  // Logic to check if all requirements are verified
  void checkSyarat(BuildContext context) {
    bool allVerified = daftarTugas.every((item) => item.status == 'Diverifikasi');

    if (allVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua syarat telah diverifikasi, Anda bisa mendaftar sidang')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua syarat belum terpenuhi')),
      );
    }
  }
}

class TugasAkhirItem {
  String namaDokumen;
  String status;
  bool isUploaded;

  TugasAkhirItem({
    required this.namaDokumen,
    required this.status,
    required this.isUploaded,
  });

  // Function to get color based on status
  Color getColorIndicator() {
    if (status == 'Diverifikasi') return Colors.green;
    if (status == 'Menunggu Divalidasi') return Colors.yellow;
    return Colors.red; // For 'Belum Upload'
  }
}
