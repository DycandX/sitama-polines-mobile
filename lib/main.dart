import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/01_launch/welcome_page.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
//import 'package:pbl_sitama/modules/02_login/login_page.dart';
//import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_screen.dart';
//import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';
//import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';
//import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
//import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/sidang_tugas_akhir/sidang_ta_screen.dart';
//import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
//import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dashboard_TA_tampilan.dart';
//import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: MahasiswaBimbingan(),
      //home: PembimbinganScreen(),
      //home: WelcomePage(),
      //home: SidangTaScreen(),
      //home: DaftarTaScreen(),
      //home: PembimbinganScreen(),
      //home: JadwalSidangPage(),
      //home: homeMahasiswaScreen(),
      //home: DashboardScreen(),
      //home: WelcomePage(),
    );
  }
}

