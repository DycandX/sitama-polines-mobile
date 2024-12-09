import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/01_launch/welcome_page.dart';
import 'package:pbl_sitama/main_wrapper.dart';
import 'package:pbl_sitama/app_navigation.dart';
import 'package:pbl_sitama/profile_provider.dart';
import 'package:provider/provider.dart'; 

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Router Example',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
