import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

// Providers
import 'package:flutter_klinik_gigi/features/auth/providers/auth_provider.dart';
import 'package:flutter_klinik_gigi/features/auth/providers/otp_provider.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'package:flutter_klinik_gigi/providers/nota_provider.dart';

// Auth Screens
import 'package:flutter_klinik_gigi/features/auth/screens/start.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/masuk.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/daftar_pasien_lama.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/daftar_pasien_baru.dart';
import 'package:flutter_klinik_gigi/features/auth/screens/otp_screen.dart';

// Home Screens
import 'package:flutter_klinik_gigi/features/home/screens/main_screen.dart';
import 'package:flutter_klinik_gigi/features/dentalhome/screens/input_lokasi_screen.dart';
import 'package:flutter_klinik_gigi/features/dentalhome/screens/jadwal_kunjungan_screens.dart';
import 'package:flutter_klinik_gigi/features/dentalhome/screens/midtrans_booking_homecare_screen.dart';

// Reservasi
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';

// Riwayat
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens.dart';
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens_detail.dart';

// Reward
import 'package:flutter_klinik_gigi/features/reward/point_reward_screen.dart';

// Settings
import 'package:flutter_klinik_gigi/features/settings/screens/firstpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_one.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/ubahsandi_two.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/notifikasi.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduanpage.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduanlogin.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduanhomedental.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduanreservasi.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduaneditprofil.dart';
import 'package:flutter_klinik_gigi/features/settings/screens/panduanubahsandi.dart';

//Profile
import 'package:flutter_klinik_gigi/features/profile/screens/profil_screens.dart';
import 'package:flutter_klinik_gigi/features/profile/screens/two_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider()),
        ChangeNotifierProvider<ReservasiProvider>(
          create: (_) => ReservasiProvider(),
        ),
        ChangeNotifierProvider<ProfilProvider>(create: (_) => ProfilProvider()),
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
        '/start': (context) => const StartScreen(),
        '/masuk': (context) => const LoginPage(),
        '/daftar_pasien_lama': (context) => const DaftarPasienLamaPage(),
        '/daftar_pasien_baru': (context) => const DaftarPasienBaruPage(),
        '/otp_screen': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as String?;
          return OtpScreen(email: arguments);
        },

        // Home
        '/main_screen': (context) => const MainScreen(),

        // Dental Home Care
        '/dentalhome/jadwal': (context) => const SchedulePage(),
        '/dentalhome/input_lokasi': (context) => const InputLokasiScreen(),
        '/dentalhome/pembayaran': (context) {
          final arguments =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return MidtransHomeCareBookingScreen(
            masterJadwalId: arguments?['masterJadwalId'] ?? 0,
            tanggal: arguments?['tanggal'] ?? '',
            namaDokter: arguments?['namaDokter'] ?? '',
            jamPraktek: arguments?['jamPraktek'] ?? '',
            keluhan: arguments?['keluhan'] ?? '',
            alamat: arguments?['alamat'] ?? '',
            latitude: arguments?['latitude'] ?? 0.0,
            longitude: arguments?['longitude'] ?? 0.0,
            rincianBiaya: arguments?['rincianBiaya'] ?? {},
          );
        },

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

        // Reward
        '/point_reward': (context) => const PointRewardScreen(),

        // Settings
        '/firstpage': (context) => const ProfileScreen(),
        '/ubahsandi_one': (context) =>
            const UbahKataSandi1Page(email: "user@example.com"),
        '/ubahsandi_two': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as String?;
          return UbahKataSandi2Page(email: arguments ?? "user@example.com");
        },
        '/notifikasi': (context) => const NotificationSettingsPage(),
        '/panduanpage': (context) => const PanduanPage(),
        '/panduanlogin': (context) => const PanduanLoginPage(),
        '/panduanhomedental': (context) => const PanduanHomeDentalCarePage(),
        '/panduanreservasi': (context) => const PanduanReservasiPage(),
        '/panduaneditprofil': (context) => const PanduanEditProfilScreen(),
        '/panduanubahsandi': (context) => const PanduanUbahSandiScreen(),

        //Profile
        '/profil_screens': (context) {
          return FutureBuilder<String?>(
            future: SharedPrefsHelper.getToken(),
            builder: (context, snapshot) {
              String token = snapshot.data ?? '';
              return ProfilePage(token: token);
            },
          );
        },
        '/two_page': (context) => const EditProfilPage2(),
      },
    );
  }
}
