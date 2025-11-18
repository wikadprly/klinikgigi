import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart'; // <-- File Anda

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil warna dari file colors.dart Anda
    const Color activeColor = AppColors.gold;
    const Color inactiveColor = AppColors.textMuted;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: activeColor, // <-- DIGANTI
      unselectedItemColor: inactiveColor, // <-- DIGANTI
      showUnselectedLabels: true,
      backgroundColor: AppColors
          .navbarBackground, // <-- Saya tambahkan dari main_screen.dart lama Anda
      elevation: 0, // <-- Saya tambahkan dari main_screen.dart lama Anda
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            colorFilter: ColorFilter.mode(
              inactiveColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/home.svg',
            colorFilter: ColorFilter.mode(
              activeColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/reservasi_navbar.svg',
            colorFilter: ColorFilter.mode(
              inactiveColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/reservasi_navbar.svg',
            colorFilter: ColorFilter.mode(
              activeColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          label: 'Reservasi',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/riwayat_navbar.svg',
            colorFilter: ColorFilter.mode(
              inactiveColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/riwayat_navbar.svg',
            colorFilter: ColorFilter.mode(
              activeColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/dentalhome_navbar.svg',
            colorFilter: ColorFilter.mode(
              inactiveColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/dentalhome_navbar.svg',
            colorFilter: ColorFilter.mode(
              activeColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          label: 'Dental Home',
        ),
        // Saya lihat di main_screen.dart Anda ada 5 item, jadi saya tambahkan Profil
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/profil.svg',
            colorFilter: ColorFilter.mode(
              inactiveColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/profil.svg',
            colorFilter: ColorFilter.mode(
              activeColor, // <-- DIGANTI
              BlendMode.srcIn,
            ),
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
