import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/features/home/screens/home_screen.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

// IMPORT HALAMAN YANG BENAR
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart'; //
import 'package:flutter_klinik_gigi/features/dentalhome/screens/dentalhome_screens.dart'; //
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens.dart'; //
import 'package:flutter_klinik_gigi/features/profil/screens/profil_screens.dart';

// GradientMask class (tetap ada seperti di file asli Anda)
class GradientMask extends StatelessWidget {
  // ... (kode GradientMask Anda)
  const GradientMask({
    required this.child,
    required this.gradient,
    this.blendMode = BlendMode.srcIn,
    super.key,
  });

  final Widget child;
  final Gradient gradient;
  final BlendMode blendMode;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: blendMode,
      child: child,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman TIDAK PERLU 'late final' jika diinisialisasi di initState
  late List<Widget> _pages;

  // Fungsi untuk mengubah state saat navbar ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman di sini
    _pages = <Widget>[
      // ✅ KOREKSI 1: Tambahkan parameter yang dibutuhkan HomeScreen
      HomeScreen(
        userId: '2', // Saya ambil '2' dari kode asli Anda
        onNavigate: _onItemTapped,
      ),
      // ✅ KOREKSI 2: Ganti ReservasiScreen dengan PendaftaranScreen
      PendaftaranScreen(),
      DentalHomeScreen(), //
      RiwayatScreen(), //
      ProfilScreen(), // Diambil dari kode asli Anda
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tubuh Scaffold sekarang hanya menampilkan halaman yang dipilih
      body: Stack(
        children: [
          _pages[_selectedIndex], // <-- Gunakan _pages
          // UI Navbar tetap di sini (seperti file asli Anda)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.navbarBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/home.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: GradientMask(
                        gradient: AppColors.goldGradient,
                        child: SvgPicture.asset(
                          'assets/icons/home.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Beranda',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/reservasi_navbar.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: GradientMask(
                        gradient: AppColors.goldGradient,
                        child: SvgPicture.asset(
                          'assets/icons/reservasi_navbar.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Pendaftaran',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/dentalhome_navbar.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: GradientMask(
                        gradient: AppColors.goldGradient,
                        child: SvgPicture.asset(
                          'assets/icons/dentalhome_navbar.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Dental Home',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/riwayat_navbar.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: GradientMask(
                        gradient: AppColors.goldGradient,
                        child: SvgPicture.asset(
                          'assets/icons/riwayat_navbar.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Riwayat',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/profil.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.textMuted,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: GradientMask(
                        gradient: AppColors.goldGradient,
                        child: SvgPicture.asset(
                          'assets/icons/profil.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Profil',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: AppColors.gold,
                  unselectedItemColor: AppColors.textMuted,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  onTap: _onItemTapped,
                  selectedLabelStyle: AppTextStyles.label.copyWith(
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: AppTextStyles.label.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
