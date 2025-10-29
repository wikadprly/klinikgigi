import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/features/home/screens/home_screen.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

// --- PERBAIKI PATH IMPORT DI BAWAH INI ---
// Asumsi file Pendaftaran ada di dalam folder 'reservasi_screens' (sesuaikan jika salah)
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart';
// Nama foldernya 'dentalhome', bukan 'dental_home'
import 'package:flutter_klinik_gigi/features/dentalhome/screens/dentalhome_screens.dart';
// Nama foldernya 'riwayat_screens', bukan 'riwayat'
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens.dart';
// Nama foldernya 'profil_screens', bukan 'profil'
import 'package:flutter_klinik_gigi/features/profil/screens/profil_screens.dart';
// --- END PERBAIKAN PATH ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// --- CLASS _MainScreenState YANG LENGKAP ---
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Deklarasi _selectedIndex

  // Deklarasi _widgetOptions (Pastikan nama class-nya benar)
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(userId: '2'), // Ganti '1' dengan ID user valid Anda
    PendaftaranScreen(), // Ganti dengan nama Class Pendaftaran/Reservasi Anda
    DentalHomeScreen(), // Ganti dengan nama Class Dental Home Anda
    RiwayatScreen(), // Ganti dengan nama Class Riwayat Anda
    ProfilScreen(), // Ganti dengan nama Class Profil Anda
  ];

  // Deklarasi _onItemTapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // --- END CLASS DEFINITION ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ), // Sekarang dikenali
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg', // Pastikan nama file SVG benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/home.svg', // Pastikan nama file SVG benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
            label: 'Beranda',
          ),
          // ITEM KEDUA (PENDAFTARAN/RESERVASI)
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/reservasi_navbar.svg', // Pastikan nama file SVG pendaftaran benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/reservasi_navbar.svg', // Pastikan nama file SVG pendaftaran benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
            label: 'Pendaftaran',
          ),
          // ITEM KETIGA (DENTAL HOME)
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/dentalhome_navbar.svg', // Pastikan nama file SVG dental home benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/dentalhome_navbar.svg', // Pastikan nama file SVG dental home benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
            label: 'Dental Home',
          ),
          // ITEM KEEMPAT (RIWAYAT)
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/riwayat_navbar.svg', // Pastikan nama file SVG riwayat benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/riwayat_navbar.svg', // Pastikan nama file SVG riwayat benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
            label: 'Riwayat',
          ),
          // ITEM KELIMA (PROFIL)
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profil.svg', // Pastikan nama file SVG profil benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/profil.svg', // Pastikan nama file SVG profil benar
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Sekarang dikenali
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onItemTapped, // Sekarang dikenali
      ),
    );
  }
} // <--- Kurung kurawal penutup untuk _MainScreenState
