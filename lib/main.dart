import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/otp_provider.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/features/settings/providers/reset_password_provider.dart';

// Auth Screens
import 'package:flutter_klinik_gigi/features/auth/screens/start.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/masuk.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/daftar_pasien_lama.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/daftar_pasien_baru.dart';

// Home Screens
import 'package:flutter_klinik_gigi/features/home/screens/main_screen.dart';

// Reservasi
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';

// Riwayat
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens.dart';
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens_detail.dart';

// Settings
import 'package:flutter_klinik_gigi/features/settings/screens/firstpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_two.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/notifikasi.dart';
import 'features/settings/screens/panduanpage.dart';
import 'features/settings/screens/panduanlogin.dart';
import 'features/settings/screens/panduanhomedental.dart';
import 'features/settings/screens/panduanreservasi.dart';
import 'features/settings/screens/panduaneditprofil.dart';
import 'features/settings/screens/panduanubahsandi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider()),

        // ✅ FIX: Provider yang sebelumnya hilang
        ChangeNotifierProvider<ReservasiProvider>(
          create: (_) => ReservasiProvider(),
        ),
      ],
      child: const KlinikGigiApp(),
    ),
  );
}

class KlinikGigiApp extends StatelessWidget {
  const KlinikGigiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<AuthProvider>(context).user?.email ?? '';
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

      // Jika sudah login → langsung ke main_screen
      initialRoute: authProvider.isLoggedIn ? '/main_screen' : '/firstpage',

      routes: {
        '/start': (context) => const StartScreen(),
        '/masuk': (context) => const LoginPage(),
        '/daftar_pasien_lama': (context) => const DaftarPasienLamaPage(),
        '/daftar_pasien_baru': (context) => const DaftarPasienBaruPage(),

        // Home
        '/main_screen': (context) => const MainScreen(),

        // Reservasi
        '/reservasi': (context) => const ReservasiScreen(),

        // Riwayat
        '/riwayat': (context) => const RiwayatScreen(),
        '/riwayat_detail': (context) {
          final data =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return RiwayatDetailScreen(data: data ?? {});
        },

        // Settings
        '/firstpage': (context) => const ProfileScreen(),
        '/ubahsandi_one': (context) => UbahKataSandi1Page(email: userEmail),
        '/ubahsandi_two': (context) =>
            UbahKataSandi2Page(resetToken: resetToken),
        '/notifikasi': (context) => const NotificationSettingsPage(),
        '/panduanpage': (context) => const PanduanPage(),
        '/panduanlogin': (context) => const PanduanLoginPage(),
        '/panduanhomedental': (context) => const PanduanHomeDentalCarePage(),
        '/panduanreservasi': (context) => const PanduanReservasiPage(),
        '/panduaneditprofil': (context) => const PanduanEditProfilScreen(),
        '/panduanubahsandi': (context) => const PanduanUbahSandiScreen(),
      },
    );
  }
}
