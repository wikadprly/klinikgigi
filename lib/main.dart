import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/screens/start.dart';
import 'features/auth/screens/masuk.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/daftar_pasien_lama.dart';
import 'features/auth/screens/daftar_pasien_baru.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ],
      child: const KlinikGigiApp(),
    ),
  );
}

class KlinikGigiApp extends StatelessWidget {
  const KlinikGigiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klinik Gigi',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFF0E0E10),
        fontFamily: 'Poppins',
      ),
      initialRoute: authProvider.isLoggedIn ? '/dashboard' : '/start',
      routes: {
        '/start': (context) => const StartScreen(),
        '/masuk': (context) => const LoginPage(),
        '/daftar_pasien_lama': (context) => const DaftarPasienLamaPage(),
        '/daftar_pasien_baru': (context) => const DaftarPasienBaruPage(),
        '/dashboard': (context) =>
            const Placeholder(), //kel 7 udah bisa dbuat home yang nampilin nama pengguna karna sudah pakai shared preference
      },
    );
  }
}
