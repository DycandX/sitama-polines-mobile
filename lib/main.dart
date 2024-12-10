import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/01_launch/welcome_page.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
import 'package:pbl_sitama/modules/07_sidang_tugas_akhir/sidang_tugas_akhir/sidang_ta_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/daftar_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/dataMhs_ta.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen_pembimbing.dart';
import 'package:pbl_sitama/services/api_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
        //home: JadwalSidangPage(),
        // home: PembimbinganScreen(pembimbing: '',),
        //home: HomeScreen(),
        // home: MahasiswaBimbingan(),
        // home: PembimbinganScreen(),
        // home: WelcomePage(),
        // home: SidangTaScreen(),
        // home: PembimbinganScreen(),
        // home: JadwalSidangPage(),
        // home: homeMahasiswaScreen(),
        // home: DashboardScreen(),
        // home: PembimbinganScreen(),
      ),
    );
  }
}
