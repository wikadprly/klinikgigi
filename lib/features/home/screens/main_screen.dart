import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/features/home/screens/home_screen.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/reservasi_screens.dart'; //
import 'package:flutter_klinik_gigi/features/dentalhome/screens/dentalhome_screens.dart'; //
import 'package:flutter_klinik_gigi/features/riwayat/screens/riwayat_screens.dart'; //
import 'package:flutter_klinik_gigi/features/settings/screens/firstpage.dart';

class GradientMask extends StatelessWidget {
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

  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeScreen(onNavigate: _onItemTapped),
      ReservasiScreen(),
      DentalHomeScreen(),
      RiwayatScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FIX 1: Gunakan IndexedStack agar halaman tidak di-reset (State Preservation)
          IndexedStack(index: _selectedIndex, children: _pages),

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
                    _buildNavItem('assets/icons/home.svg', 'Beranda'),
                    _buildNavItem(
                      'assets/icons/reservasi_navbar.svg',
                      'Pendaftaran',
                    ),
                    _buildNavItem(
                      'assets/icons/dentalhome_navbar.svg',
                      'Dental Home',
                    ),
                    _buildNavItem('assets/icons/riwayat_navbar.svg', 'Riwayat'),
                    _buildNavItem('assets/icons/profil.svg', 'Profil'),
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

  // FIX 2: Helper Method untuk mengurangi Redundant Code
  BottomNavigationBarItem _buildNavItem(String assetPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        height: 24,
        width: 24,
        // ignore: deprecated_member_use
        colorFilter: ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn),
      ),
      activeIcon: GradientMask(
        gradient: AppColors.goldGradient,
        child: SvgPicture.asset(
          assetPath,
          height: 24,
          width: 24,
          // ignore: deprecated_member_use
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      label: label,
    );
  }
}
