import 'package:flutter/material.dart';
import 'features/auth/screens/masuk.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const KlinikGigiApp());
}

class KlinikGigiApp extends StatelessWidget {
  const KlinikGigiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // User ID contoh (sesuaikan nanti jika sudah login)
    const String userId = '2';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klinik Gigi',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFF0E0E10),
        fontFamily: 'poppins',
      ),

      // Halaman awal
      initialRoute: '/login',

      // Daftar route
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(userId: userId),
      },
    );
  }
}
