import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/services/dokter_service.dart';
import '../../../core/models/dokter_model.dart';
import 'dart:async'; // Import untuk Timer (debounce)

// ------------------------------------
// 1. WIDGET KARTU DOKTER BARU (SESUAI DESAIN 1.png)
// ------------------------------------
class _DokterListCard extends StatelessWidget {
  final DokterModel dokter;

  const _DokterListCard({required this.dokter});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    // Logika menampilkan foto/placeholder
    if (dokter.fotoProfil != null &&
        Uri.tryParse(dokter.fotoProfil!)?.hasAbsolutePath == true) {
      imageWidget = CircleAvatar(
        radius: 30,
        backgroundColor:
            AppColors.cardDark, // background jika gambar gagal load
        backgroundImage: NetworkImage(dokter.fotoProfil!),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback ke icon jika network image error (dibuang agar tidak error)
        },
      );
    } else {
      // Placeholder
      imageWidget = CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.gold.withOpacity(0.2),
        child: Icon(Icons.person, color: AppColors.gold, size: 30),
      );
    }

    return Card(
      color: AppColors.cardDark,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: imageWidget,
        title: Text(
          dokter.namaDokter,
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            color: AppColors.gold,
          ),
        ),
        subtitle: Text(
          "Spesialisasi: ${dokter.spesialisasi}",
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

// ------------------------------------
// 2. MAIN SCREEN DOKTER (DIUBAH MENJADI STATEFUL)
// ------------------------------------
class DokterScreens extends StatefulWidget {
  const DokterScreens({Key? key}) : super(key: key);

  @override
  State<DokterScreens> createState() => _DokterScreensState();
}

class _DokterScreensState extends State<DokterScreens> {
  // State untuk mengelola daftar dokter
  late Future<List<DokterModel>> _futureDokter;
  final DokterService _dokterService = DokterService();

  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Ambil semua dokter saat pertama kali load
    _futureDokter = _dokterService.fetchDokter();

    // Tambahkan listener untuk live search dengan debounce
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Fungsi untuk fetch data (bisa dipanggil ulang)
  void _fetchData(String? query) {
    setState(() {
      _futureDokter = _dokterService.fetchDokter(query);
    });
  }

  // Fungsi Debounce untuk pencarian
  // Ini mencegah API dipanggil di setiap ketikan,
  // hanya akan memanggil 500ms setelah user berhenti mengetik.
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchData(_searchController.text.trim());
    });
  }

  // Fungsi refresh manual (tarik ke bawah)
  Future<void> _refreshDokterList() async {
    _searchController.clear(); // Hapus filter saat refresh
    _fetchData(null); // Ambil semua data lagi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Dokter', // Diubah dari 'Dokter Kami'
          style: AppTextStyles.heading.copyWith(color: AppColors.gold),
        ),
        backgroundColor: AppColors.background, // Ubah ke background
        elevation: 0,
        leading: IconButton(
          // Tombol back
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // --- Search Bar ---
            TextField(
              controller: _searchController,
              style: AppTextStyles.input,
              decoration: InputDecoration(
                hintText: 'Cari dokter...',
                hintStyle: AppTextStyles.label,
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.cardDark,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- List Dokter ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshDokterList,
                color: AppColors.gold,
                child: FutureBuilder<List<DokterModel>>(
                  future: _futureDokter,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Gagal memuat data: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _refreshDokterList,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                ),
                                child: Text(
                                  'Coba Lagi',
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Tidak ada data dokter saat ini.'
                              : 'Dokter tidak ditemukan.',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    } else {
                      // --- INI PERUBAHAN UTAMA: ListView.builder ---
                      final dokterList = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: dokterList.length,
                        itemBuilder: (context, index) {
                          return _DokterListCard(dokter: dokterList[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
