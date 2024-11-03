import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/01_launch/welcome_page.dart';
import 'package:pbl_sitama/modules/05_pembimbingan/pembimbingan_screen.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: PembimbinganScreen(pembimbing: '',),
      //home: HomeScreen(),
      //home: MahasiswaBimbingan(),
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

