import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dashboard_ta_input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FinalProjectScreen(),
    );
  }
}
