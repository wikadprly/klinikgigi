import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'features/auth/screens/masuk.dart';
=======
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/daftar_pasien_lama.dart';
>>>>>>> main

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // tambahin biar environment stabil
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
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
        fontFamily: 'Poppins',
      ),
<<<<<<< HEAD

      initialRoute: '/masuk.dart',
      routes: {'/masuk.dart': (context) => const LoginScreen()},
=======
      home:
          const DaftarPasienLamaPage(), // ✅ pakai home biar lebih stabil di dev mode
>>>>>>> main
    );
  }
}
