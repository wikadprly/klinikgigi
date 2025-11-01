import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/pasien_model.dart';
import 'package:flutter_klinik_gigi/core/services/pasien_service.dart';
import 'package:flutter_klinik_gigi/features/dokter/screens/dokter_screens.dart';
import 'package:flutter_klinik_gigi/features/jadwalpraktek/screens/jadwalpraktek_screens.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/jadwalpraktek/screens/jadwalpraktek_screens.dart';
import 'package:flutter_klinik_gigi/features/dokter/screens/dokter_screens.dart';
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
  final String userId;
  final void Function(int) onNavigate;

  const HomeScreen({super.key, required this.userId, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Pasien> _pasien;
  final PasienService _pasienService = PasienService();

  @override
  void initState() {
    super.initState();
    _pasien = _pasienService.getPasienByUserId(widget.userId);
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
              bottom: 100.0,
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
                _buildPromoSection(context),
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
            IconButton(
              icon: GradientMask(
                gradient: AppColors.goldGradient,
                child: const Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return FutureBuilder<Pasien>(
      future: _pasien,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat data: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData) {
          final pasien = snapshot.data!;
          return Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: const AssetImage(
                      'assets/images/profile.jpeg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pasien.nama,
                        style: AppTextStyles.heading.copyWith(fontSize: 20),
                      ),
                      Text('Halo, Selamat Datang', style: AppTextStyles.label),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoCard(pasien),
            ],
          );
        }
        return const Center(
          child: Text(
            'Data pasien tidak ditemukan',
            style: AppTextStyles.input,
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(Pasien pasien) {
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
            _buildInfoColumn('Umur', pasien.umur.toString()),
            _buildInfoColumn('Jenis Kelamin', pasien.jenisKelamin),
            _buildInfoColumn('Nomor Rekam Medis', pasien.rekamMedis),
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
                              builder: (context) => const JadwalScreen(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DokterScreen(),
                            ),
                          );
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

  Widget _buildPromoSection(BuildContext context) {
    final List<Map<String, String>> promos = [
      {
        "image": "assets/images/poster2.png",
        "title": "Promo Bleaching",
        "subtitle": "Diskon 50% untuk perawatan bleaching",
      },
      {
        "image": "assets/images/poster.png",
        "title": "Scaling Hemat",
        "subtitle": "Pembersihan karang gigi mulai 150rb",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientMask(
          gradient: AppColors.goldGradient,
          child: Text(
            'Promo Menarik',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == promos.length - 1 ? 0 : 16,
                ),
                child: _buildPromoCard(
                  imagePath: promo['image']!,
                  title: promo['title']!,
                  subtitle: promo['subtitle']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: AppColors.cardDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.label.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
