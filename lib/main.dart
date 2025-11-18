import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/screens/start.dart';
import 'features/auth/screens/masuk.dart';
import 'features/home/screens/main_screen.dart';
import 'features/auth/screens/daftar_pasien_lama.dart';
import 'features/auth/screens/daftar_pasien_baru.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/riwayat/screens/riwayat_screens.dart';
import 'features/riwayat/screens/riwayat_screens_detail.dart';
import 'features/settings/screens/firstpage.dart';
import 'features/settings/screens/ubahsandi_one.dart';
import 'features/settings/screens/ubahsandi_two.dart';
import 'features/settings/screens/ubahsandi_three.dart';
import 'features/settings/screens/notifikasi.dart';

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

      initialRoute: authProvider.isLoggedIn ? '/main_screen' : '/start',

      routes: {
        // Rute '/start' akan memuat StartScreen
        '/start': (context) => const StartScreen(),
        // Rute '/masuk' akan memuat LoginPage (dari file masuk.dart)
        '/masuk': (context) => const LoginPage(),
        '/daftar_pasien_lama': (context) => const DaftarPasienLamaPage(),
        '/daftar_pasien_baru': (context) => const DaftarPasienBaruPage(),
        '/main_screen': (context) => const MainScreen(),
        '/riwayat': (context) => const RiwayatScreen(),
        '/riwayat_detail': (context) {
          final data =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return RiwayatDetailScreen(data: data ?? {});
        },
        '/firstpage': (context) => const ProfileScreen(),
        '/ubahsandi_one.dart': (context) => const UbahKataSandi2Page(),
        '/ubahsandi_two.dart': (context) => const UbahKataSandi3Page(),
        '/ubahsandi_three.dart': (context) =>
            const UbahKataSandiKonfirmasiPage(),
        '/notifikasi.dart': (context) => const NotificationSettingsPage(),
      },
    );
  }
}
