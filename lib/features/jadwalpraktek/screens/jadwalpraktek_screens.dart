import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_klinik_gigi/config/api.dart'; // for baseUrl
import 'package:flutter_klinik_gigi/core/models/dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/jadwal_praktek_model.dart';
import 'package:flutter_klinik_gigi/core/services/jadwal_praktek_service.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class JadwalPraktekScreen extends StatefulWidget {
  const JadwalPraktekScreen({super.key});

  @override
  State<JadwalPraktekScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalPraktekScreen> {
  // Inisialisasi service
  final JadwalPraktekService _service = JadwalPraktekService();

  // Future untuk menyimpan data jadwal
  late Future<List<DokterModel>> _jadwal;

  // Menyimpan status toggle jadwal detail
  final Map<int, bool> _isJadwalDetailVisible = {};

  @override
  void initState() {
    super.initState();
    // Memuat data saat widget dibuat
    _jadwal = _service.getJadwalPraktek();
  }

  // --- Widget Bantuan untuk Detail Jadwal ---

  /// Detail jadwal dokter saat Expand ditekan.
  Widget _buildJadwalDetail(List<JadwalPraktek> jadwal) {
    if (jadwal.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          "Tidak ada jadwal detail yang tersedia.",
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: jadwal.map((j) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Getter 'hari' sekarang diakui
                  j.hari,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  // Getter 'jamMulai' dan 'jamSelesai' sekarang diakui
                  "${j.jamMulai} - ${j.jamSelesai}",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Widget Utama ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Jadwal Praktek",
          style: AppTextStyles.heading.copyWith(
            fontSize: 24,
            color: AppColors.gold,
          ),
        ),
      ),
      body: FutureBuilder<List<DokterModel>>(
        future: _jadwal,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Gagal memuat jadwal: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(color: Colors.redAccent),
                ),
              ),
            );
          }

          // 3. Empty Data State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada jadwal yang tersedia.",
                style: AppTextStyles.label.copyWith(color: AppColors.textLight),
              ),
            );
          }

          // 4. Data Loaded State
          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final d = data[index];
              final isVisible = _isJadwalDetailVisible[index] ?? false;

              // Tentukan teks hari praktek, ambil hari dari jadwal pertama
              final String hariPraktek = d.jadwal.isNotEmpty
                  ? d.jadwal.first.hari
                  : "-";

              // --- PERBAIKAN FOTO DOKTER: Logika Lengkap ---
              String photoUrl = "";
              if (d.fotoProfil != null && d.fotoProfil!.isNotEmpty) {
                String filename = d.fotoProfil!.split('/').last;
                photoUrl = "$baseUrl/dokter-image/$filename";

                if (!kIsWeb) {
                  if (photoUrl.contains('localhost')) {
                    photoUrl = photoUrl.replaceAll(
                      'localhost',
                      'pbl250116.informatikapolines.id',
                    );
                  } else if (photoUrl.contains('127.0.0.1')) {
                    photoUrl = photoUrl.replaceAll(
                      '127.0.0.1',
                      'pbl250116.informatikapolines.id',
                    );
                  }
                }
              }

              // 2. Tentukan ImageProvider. NetworkImage hanya jika URL tersedia.
              final ImageProvider? imageProvider = photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : null; // null jika tidak ada foto

              // --- AKHIR PERBAIKAN ---

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.goldDark.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FOTO DOKTER
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.goldDark, // Warna latar default
                              borderRadius: BorderRadius.circular(8),
                              // Hanya sediakan DecorationImage jika imageProvider tidak null
                              image: imageProvider != null
                                  ? DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // Tambahkan onError untuk debug, tidak akan crash jika gagal
                                      onError: (exception, stackTrace) {
                                        debugPrint(
                                          "Error loading image from network: $exception",
                                        );
                                      },
                                    )
                                  : null, // Jika null, Container hanya akan menampilkan warna latar
                            ),
                            // Jika tidak ada NetworkImage yang dimuat (imageProvider == null), tampilkan ikon/inisial
                            child: imageProvider == null
                                ? const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.cardDark,
                                      size: 40,
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(width: 16),

                          // DETAIL DOKTER
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama Dokter
                                Text(
                                  d.namaDokter.startsWith('Drg.')
                                      ? d.namaDokter
                                      : 'Drg. ${d.namaDokter}',
                                  style: AppTextStyles.heading.copyWith(
                                    fontSize: 16,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                // Divider
                                const Divider(
                                  color: AppColors.textMuted,
                                  height: 10,
                                  thickness: 0.5,
                                ),

                                // Hari Praktek Singkat
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 16,
                                          color: AppColors.gold,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Hari Praktek",
                                          style: AppTextStyles.label.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      hariPraktek,
                                      style: AppTextStyles.label.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // TOMBOL LIHAT / SEMBUNYIKAN
                                if (d.jadwal.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isJadwalDetailVisible[index] =
                                            !isVisible;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          isVisible
                                              ? "Tutup Jadwal"
                                              : "Lihat Jadwal",
                                          style: AppTextStyles.label.copyWith(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          isVisible
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          size: 20,
                                          color: AppColors.gold,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // DETAIL JADWAL EXPANDED
                      if (isVisible) _buildJadwalDetail(d.jadwal),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
