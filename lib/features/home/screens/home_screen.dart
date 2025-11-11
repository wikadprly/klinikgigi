import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/pasien_model.dart';
import 'package:flutter_klinik_gigi/core/services/pasien_service.dart';
import 'package:flutter_klinik_gigi/features/dokter/screens/dokter_screens.dart';
import 'package:flutter_klinik_gigi/features/jadwalpraktek/screens/jadwalpraktek_screens.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
// import 'package:flutter_klinik_gigi/features/jadwalpraktek/screens/jadwalpraktek_screens.dart'; // Duplikat, bisa dihapus
// import 'package:flutter_klinik_gigi/features/dokter/screens/dokter_screens.dart'; // Duplikat, bisa dihapus
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_klinik_gigi/core/models/promo_model.dart';
import 'package:flutter_klinik_gigi/core/services/promo_service.dart';

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

  // ✅ 1. TAMBAHKAN 2 BARIS DEKLARASI INI
  late Future<List<PromoModel>> _futurePromos;
  final PromoService _promoService = PromoService();

  @override
  void initState() {
    super.initState();
    _pasien = _pasienService.getPasienLogin();

    // ✅ 2. TAMBAHKAN 1 BARIS INISIALISASI INI
    _futurePromos = _promoService.fetchPromos();
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
                // Hapus 'const' dari sini
                gradient: AppColors.goldGradient,
                child: SvgPicture.asset(
                  'assets/icons/poin.svg',
                  height: 28, // Sesuaikan ukuran
                  width: 28, // Sesuaikan ukuran
                ),
              ),
              onPressed: () {
                // Tambahkan aksi saat ikon poin ditekan
              },
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
                              builder: (context) => const DokterScreens(),
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
    // ❌ Data dummy sudah dihapus

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Promo Menarik',
            style: AppTextStyles.heading.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220, // Tetapkan tinggi untuk list horizontal
          // ✅ GANTI DENGAN FutureBuilder
          child: FutureBuilder<List<PromoModel>>(
            future: _futurePromos, // ✅ SEKARANG VARIABEL INI SUDAH ADA
            builder: (context, snapshot) {
              // 1. Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // 2. Error State
              else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat promo: ${snapshot.error}',
                    style: AppTextStyles.label,
                  ),
                );
              }
              // 3. Empty State
              else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada promo saat ini',
                    style: AppTextStyles.label,
                  ),
                );
              }

              // 4. Success State (Data ada)
              final promos = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: promos.length,
                // Beri padding di list agar tidak mepet layar
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemBuilder: (context, index) {
                  final promo = promos[index];
                  return Padding(
                    // Beri jarak antar kartu
                    padding: EdgeInsets.only(
                      right: index == promos.length - 1 ? 0 : 16,
                    ),
                    // ✅ UBAH _buildPromoCard agar menggunakan PromoModel
                    child: _buildPromoCard(
                      // Gunakan URL dari server, atau gambar placeholder jika null
                      imagePath:
                          promo.gambarBanner ??
                          'assets/images/poster.png', // Gambar fallback
                      title: promo.judulPromo,
                      subtitle: promo.deskripsi,
                      isNetworkImage:
                          promo.gambarBanner != null, // Tanda untuk widget Card
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24), // Beri jarak di bawah
      ],
    );
  }

  Widget _buildPromoCard({
    required String imagePath,
    required String title,
    required String subtitle,
    bool isNetworkImage = false, // ✅ Tambahkan parameter ini
  }) {
    return SizedBox(
      width: 280, // Lebar kartu promo
      child: Card(
        elevation: 3,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior:
            Clip.antiAlias, // Penting untuk rounded corners pada Image
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ BUAT LOGIKA UNTUK MENAMPILKAN GAMBAR DARI JARINGAN (NETWORK)
            isNetworkImage
                ? Image.network(
                    imagePath,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Error builder jika gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/poster.png', // Gambar fallback
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                    // Loading builder
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 130,
                        width: double.infinity,
                        color: AppColors.background,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        ),
                      );
                    },
                  )
                : Image.asset(
                    imagePath, // Tetap gunakan aset lokal jika bukan network
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
