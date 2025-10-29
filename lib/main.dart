import 'package:flutter/material.dart';

import 'features/profile/screens/Masukkansandi.dart';

void main() {
  runApp(const KlinikGigiApp());
}

class KlinikGigiApp extends StatelessWidget {
  const KlinikGigiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klinik Gigi',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFF0E0E10),
        fontFamily: 'poppins',
      ),

      initialRoute: '/Masukkansandi.dart',
      routes: {'/Masukkansandi.dart': (context) => const MasukKataSandiPage()},
    );
  }
}
