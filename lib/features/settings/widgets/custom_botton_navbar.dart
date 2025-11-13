import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.background,
        unselectedItemColor: Colors.black87,
        selectedLabelStyle: AppTextStyles.label.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.background,
        ),
        unselectedLabelStyle: AppTextStyles.label.copyWith(
          color: Colors.black87,
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex == 0 ? AppColors.background : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/daftar.svg',
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex == 1 ? AppColors.background : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/gigi.svg',
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex == 2 ? AppColors.background : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            label: 'Gigi',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/riwayat.svg',
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex == 3 ? AppColors.background : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profil.svg',
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex == 4 ? AppColors.background : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
