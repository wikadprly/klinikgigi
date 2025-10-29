import 'package:flutter/material.dart';
// Ini adalah path yang benar dari kode Anda
import 'package:flutter_klinik_gigi/core/models/pasien_model.dart';
import 'package:flutter_klinik_gigi/core/services/pasien_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Pasien> _pasien;
  final PasienService _pasienService =
      PasienService(); // Asumsi inisialisasi service

  @override
  void initState() {
    super.initState();
    // Memulai proses fetch data pasien saat halaman dimuat
    _pasien = _pasienService.getPasienByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // Kita gunakan Scaffold sebagai dasar halaman
    return Scaffold(
      // Menggunakan warna background dari theme
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Agar konten tidak terpotong oleh status bar/notch
        child: SingleChildScrollView(
          // Agar halaman bisa di-scroll jika kontennya panjang
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomAppBar(context),
                const SizedBox(height: 24),
                // Gunakan FutureBuilder untuk menampilkan data pasien
                _buildUserInfo(context),
                const SizedBox(height: 24),

                // --- PERUBAHAN DI SINI ---
                // Ganti pemanggilan _buildImageCarousel dengan _buildMainBanner
                // _buildImageCarousel(context), // <--- HAPUS ATAU KOMENTARI INI
                _buildMainBanner(context), // <--- PANGGIL BANNER UTAMA DI SINI

                const SizedBox(height: 24),
                _buildGridMenu(context), // <--- Ini 4 tombol ikon
                const SizedBox(height: 24),
                _buildPromoSection(context), // <--- Bagian Promo
                const SizedBox(height: 20), // Jarak di akhir
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER UNTUK SETIAP BAGIAN ---

  /// Bagian 1: AppBar Kustom
  Widget _buildCustomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TODO: Ganti dengan logo Anda dari assets
        Image.asset('assets/images/logo_klinik_kecil.png', height: 35),
        // Menggunakan style heading dari theme
        const Text('Home', style: AppTextStyles.heading),
        Row(
          children: [
            IconButton(
              // Ikon </> dari desain Anda
              icon: const Icon(Icons.code, color: Colors.greenAccent, size: 28),
              onPressed: () {
                // Aksi saat ikon di-tap
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.mail_outline,
                // Menggunakan warna textLight dari theme
                color: AppColors.textLight,
                size: 28,
              ),
              onPressed: () {
                // Aksi saat ikon di-tap
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Bagian 2: Info User (Menggunakan FutureBuilder)
  Widget _buildUserInfo(BuildContext context) {
    return FutureBuilder<Pasien>(
      future: _pasien, // Future yang kita panggil di initState
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading spinner selagi menunggu data
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Tampilkan pesan error jika gagal
          return Center(
            child: Text(
              'Gagal memuat data: ${snapshot.error}',
              // Error state tetap pakai warna merah
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData) {
          // Jika data berhasil didapat, tampilkan UI
          final pasien = snapshot.data!;

          return Column(
            children: [
              // Bagian Sapaan (Foto + Nama)
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    // TODO: Ganti dengan path foto profil Anda di assets
                    // 'profile.jpeg' ada di assets Anda berdasarkan screenshot
                    backgroundImage: const AssetImage(
                      'assets/images/profile.jpeg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pasien.nama, // Ambil dari data pasien
                        // Menggunakan style dari theme
                        style: AppTextStyles.heading.copyWith(fontSize: 20),
                      ),
                      Text(
                        'Halo, Selamat Datang',
                        // Menggunakan style label dari theme
                        style: AppTextStyles.label,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Bagian Kartu Kuning (Info Medis)
              _buildInfoCard(pasien),
            ],
          );
        }

        // Tampilan default jika data tidak ada
        return const Center(
          child: Text(
            'Data pasien tidak ditemukan',
            // Menggunakan style input dari theme
            style: AppTextStyles.input,
          ),
        );
      },
    );
  }

  /// Widget helper untuk Kartu Kuning
  Widget _buildInfoCard(Pasien pasien) {
    return Card(
      // Menggunakan warna goldDark dari theme
      color: AppColors.gold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn(
              'Umur',
              pasien.umur.toString(),
            ), // Asumsi field 'umur'
            _buildInfoColumn(
              'Jenis Kelamin',
              pasien.jenisKelamin,
            ), // Asumsi field 'jenisKelamin'
            _buildInfoColumn(
              'Nomor Rekam Medis',
              pasien.rekamMedis,
            ), // Asumsi field 'noRekamMedis'
          ],
        ),
      ),
    );
  }

  /// Widget helper untuk kolom di Kartu Kuning
  /// (Teks di sini berwarna hitam, jadi tidak memakai theme textLight)
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

  /// Bagian 3: Carousel Gambar (Ini untuk Promo, biarkan seperti adanya jika mau pakai carousel promo)
  Widget _buildImageCarousel(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0, // Sesuaikan tinggi jika perlu
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0, // Tampilkan 1 gambar penuh
      ),
      items:
          [
            // TODO: Ganti dengan gambar-gambar Anda
            'assets/images/poster.png', // <-- Pastikan nama file ini benar
            'assets/images/poster2.png', // <-- Pastikan nama file ini benar
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(i), // Memuat gambar dari path
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Beri jarak dari ikon di bawah
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gambar latar belakang utama
          ClipRRect(
            borderRadius: BorderRadius.circular(
              15.0,
            ), // Sesuaikan border radius
            child: Image.asset(
              'assets/images/poster.png', // <-- Pastikan nama file ini benar (untuk Gambar 3)
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 200, // Sesuaikan tinggi sesuai keinginan
            ),
          ),
          // HAPUS ATAU KOMENTARI CONTAINER INI UNTUK MENGHILANGKAN OVERLAY
          // Container(
          //   height: 200,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15.0),
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.black.withOpacity(0.3),
          //         Colors.black.withOpacity(0.5),
          //       ],
          //     ),
          //   ),
          // ),
          // HAPUS ATAU KOMENTARI COLUMN INI UNTUK MENGHILANGKAN TEKS DAN LOGO OVERLAY
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset(
          //       'assets/icons/logo_klinik_kecil.svg', // <-- Ganti dengan logo putih jika ada
          //       height: 50,
          //       colorFilter: ColorFilter.mode(
          //         AppColors.gold,
          //         BlendMode.srcIn,
          //       ), // Atau Colors.white
          //     ),
          //     const SizedBox(height: 10),
          //     Text(
          //       '3K DENTAL CARE',
          //       style: TextStyle(
          //         color: AppColors.gold, // Warna sesuai desain
          //         fontSize: 28,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const SizedBox(height: 5),
          //     Text(
          //       'Jl. Singosari Raya No.77A, Pleburan, Kec. Semarang Sel., Kota Semarang, Jawa Tengah 50241',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: AppColors.textLight, // Warna putih atau light
          //         fontSize: 12,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  /// Bagian 4: Menu Grid (VERSI SVG)
  Widget _buildGridMenu(BuildContext context) {
    return Card(
      // Menggunakan warna goldDark dari theme
      color: AppColors.gold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildGridItem(
                    'assets/icons/reservasi.svg', // <-- Ganti dengan Path SVG
                    'Reservasi',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGridItem(
                    'assets/icons/dentalcare.svg', // <-- Ganti dengan Path SVG
                    'Dental Care',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGridItem(
                    'assets/icons/jadwalpraktek.svg', // <-- Ganti dengan Path SVG
                    'Jadwal Praktek',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGridItem(
                    'assets/icons/dokter.svg', // <-- Ganti dengan Path SVG
                    'Dokter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper untuk 1 item di Grid Menu (VERSI SVG)
  Widget _buildGridItem(String svgAssetPath, String label) {
    return GestureDetector(
      onTap: () {
        // Aksi saat menu di-tap
        print('$label di-tap');
      },
      child: Card(
        // UBAH WARNA DI SINI
        color: const Color(0xFF0B0A0A), // Mengganti warna background ikon
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MENGGUNAKAN SvgPicture.asset
              SvgPicture.asset(
                svgAssetPath,
                height: 40,
                width: 40,
                // Memberi warna ikonnya sesuai desain (Emas)
                colorFilter: ColorFilter.mode(
                  AppColors.gold, // Menggunakan warna gold dari theme
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                // Menggunakan style dari theme
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

  /// Bagian 5: Promo Menarik
  Widget _buildPromoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Menarik',
          // Menggunakan style dari theme
          style: AppTextStyles.heading.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        // Ini adalah carousel kedua
        // TODO: Gunakan package `carousel_slider` seperti di atas
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
            // TODO: Ganti dengan gambar statis dari asset
            image: const DecorationImage(
              image: AssetImage('assets/images/poster2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              'Carousel Promo',
              // Menggunakan style input dari theme
              style: AppTextStyles.input,
            ),
          ),
        ),
      ],
    );
  }
}
