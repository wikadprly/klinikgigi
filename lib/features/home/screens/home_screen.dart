import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'package:flutter_klinik_gigi/features/jadwalpraktek/screens/jadwalpraktek_screens.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onNavigate});

  final void Function(int) onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfilProvider>(context, listen: false);

    // Fetch profile data via provider if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.user == null) {
        provider.fetchProfilFromToken();
      }
    });

    // Promo Fetch Logic Removed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 12.0,
              bottom: 120.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomAppBar(context),
                const SizedBox(height: 24),
                _buildUserInfo(context),
                const SizedBox(height: 24),
                _buildMainBanner(context),
                const SizedBox(height: 24),
                _buildGridMenu(context),
                const SizedBox(height: 24),
                // Promo Section Removed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/logo_klinik_kecil.png', height: 35),
        const Text('Home', style: AppTextStyles.heading),
        Row(
          children: [
            // ===============================================
            // ICON POIN DIHAPUS
            // ===============================================
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    // Gunakan Consumer atau Provider.of untuk mendengarkan perubahan
    return Consumer<ProfilProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: AppColors.gold),
          );
        }

        // Jika data kosong tapi tidak loading
        if (provider.user == null) {
          return Center(
            child: Column(
              children: [
                const Text(
                  'Data profil belum dimuat.',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => provider.fetchProfilFromToken(),
                  child: const Text(
                    'Muat Ulang',
                    style: TextStyle(color: AppColors.gold),
                  ),
                ),
              ],
            ),
          );
        }

        final photoUrl = provider.photoUrl;
        final name = provider.namaPengguna;

        return Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardDark,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(
                          "$photoUrl?v=${DateTime.now().millisecondsSinceEpoch}",
                        )
                      : const AssetImage('assets/images/profil.jpeg')
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.heading.copyWith(fontSize: 20),
                    ),
                    Text('Halo, Selamat Datang', style: AppTextStyles.label),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoCard(provider),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(ProfilProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('Umur', "${provider.umur} Thn"),
            _buildInfoColumn('Jenis Kelamin', provider.genderLabel),
            _buildInfoColumn('Nomor Rekam Medis', provider.noRekamMedis),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.asset(
        'assets/images/poster.png',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 180,
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientMask(
          gradient: AppColors.goldGradient,
          child: Text(
            'Layanan Kami',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildGridItem(
                        'assets/icons/reservasi.svg',
                        'Reservasi',
                        () => widget.onNavigate(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGridItem(
                        'assets/icons/dentalcare.svg',
                        'Home Dental Care',
                        () => widget.onNavigate(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridItem(
                        'assets/icons/jadwalpraktek.svg',
                        'Jadwal Praktek',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JadwalPraktekScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGridItem(
                        'assets/icons/dokter.svg',
                        'Dokter',
                        () {
                          Navigator.pushNamed(context, '/dokter');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(String svgAssetPath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientMask(
                gradient: AppColors.goldGradient,
                child: SvgPicture.asset(svgAssetPath, height: 40, width: 40),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Promo Helper Methods Removed
}
