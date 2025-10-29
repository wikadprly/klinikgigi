// 🟢 main.dart (fix)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ penting untuk Provider
import 'features/auth/providers/auth_provider.dart'; // ✅ pastikan path benar
import 'features/auth/screens/daftar_pasien_lama.dart'; // ✅ untuk route tambahan nanti
import 'features/auth/screens/daftar_pasien_baru.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const KlinikGigiApp(),
    ),
  );
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
        fontFamily: 'Poppins', // 🟢 diseragamkan kapital awal
      ),

      // 🟢 perbaikan route name — Flutter tidak pakai ekstensi .dart
      initialRoute: '/daftar_pasien_lama',
      routes: {
        '/daftar_pasien_lama': (context) => const DaftarPasienLamaPage(),
        '/daftar_pasien_baru': (context) => const DaftarPasienBaruPage(),
      },
    );
  }
}
