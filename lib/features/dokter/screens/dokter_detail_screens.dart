import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart'; // PERUBAHAN: Menggunakan MasterDokterModel
import 'package:flutter_klinik_gigi/core/models/dokter_detail_model.dart'; // PERUBAHAN
import 'package:flutter_klinik_gigi/config/api.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/services/dokter_service.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class DokterDetailScreen extends StatefulWidget {
  final MasterDokterModel dokter; // PERUBAHAN: Menggunakan MasterDokterModel
  const DokterDetailScreen({super.key, required this.dokter}); // PERUBAHAN

  @override
  State<DokterDetailScreen> createState() => _DokterDetailScreenState();
}

class _DokterDetailScreenState extends State<DokterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DokterService _dokterService = DokterService();
  // PERBAIKAN: Menggunakan id dari widget.dokter untuk fetch data
  late Future<DokterDetailModel> _futureDetailDokter; // PERUBAHAN

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // 3 tabs: Tentang, Layanan, Jadwal
    _futureDetailDokter = _dokterService.fetchDokterDetail(
      widget.dokter.kodeDokter,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.dokter.nama,
          style: AppTextStyles.heading.copyWith(color: AppColors.gold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.gold,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<DokterDetailModel>(
        // PERUBAHAN
        future: _futureDetailDokter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat detail: ${snapshot.error}',
                style: AppTextStyles.label.copyWith(color: Colors.redAccent),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Data dokter tidak ditemukan.',
                style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
              ),
            );
          }

          final masterDokter = snapshot.data!;

          final poli = masterDokter.masterPoli?.namaPoli ?? 'N/A';
          final spesialis = masterDokter.spesialisasi ?? 'Dokter';
          final String fotoUrl = "$baseUrl/storage/${masterDokter.foto ?? ''}";

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppColors.background,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(fotoUrl),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Gagal memuat gambar: $fotoUrl');
                      },
                      backgroundColor: AppColors.cardDark,
                    ),
                    SizedBox(height: 16),
                    Text(
                      masterDokter.nama ?? 'Nama Dokter',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 22,
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      spesialis,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Fitur "Book Now" belum diimplementasikan.',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: AppTextStyles.button.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.cardDark),
              Container(
                color: AppColors.background,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: AppColors.gold,
                  tabs: [
                    Tab(text: 'Tentang'),
                    Tab(text: 'Layanan'),
                    Tab(text: 'Jadwal'),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: AppColors.cardDark.withAlpha(128),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTentangTab(masterDokter),
                      _buildLayananTab(poli),
                      _buildJadwalTab(
                        masterDokter.masterJadwal,
                      ), // PERBAIKAN: Memastikan data jadwal diteruskan
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET UNTUK TAB ---

  Widget _buildTentangTab(DokterDetailModel dokter) {
    // PERUBAHAN
    String biografi =
        "Informasi tentang dokter ini belum tersedia. Dokter ${dokter.nama} adalah seorang profesional di bidang ${dokter.spesialisasi ?? 'kesehatan gigi'} dengan pengalaman di ${dokter.masterPoli?.namaPoli ?? 'poli'}.";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        biografi,
        style: AppTextStyles.label.copyWith(
          fontSize: 15,
          height: 1.5,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  Widget _buildLayananTab(String poli) {
    String layanan =
        "Layanan utama yang ditangani oleh dokter ini adalah di $poli.";
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        layanan,
        style: AppTextStyles.label.copyWith(
          fontSize: 15,
          height: 1.5,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  Widget _buildJadwalTab(List<MasterJadwalModel>? jadwalList) {
    if (jadwalList == null || jadwalList.isEmpty) {
      return Center(
        child: Text(
          'Jadwal tidak tersedia.',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    // Mengelompokkan jadwal berdasarkan hari
    Map<String, List<MasterJadwalModel>> jadwalByHari = {};
    for (var jadwal in jadwalList) {
      String hari = jadwal.hari;
      if (jadwalByHari.containsKey(hari)) {
        jadwalByHari[hari]!.add(jadwal);
      } else {
        jadwalByHari[hari] = [jadwal];
      }
    }

    // Mengurutkan hari dari Senin sampai Minggu
    List<String> hariOrder = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    List<String> sortedHari = jadwalByHari.keys.toList()
      ..sort((a, b) => hariOrder.indexOf(a).compareTo(hariOrder.indexOf(b)));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: sortedHari.map((hari) {
        return Card(
          color: AppColors.cardDark,
          margin: EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hari,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 18,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(height: 8),
                ...jadwalByHari[hari]!.map((jadwal) {
                  return Text(
                    '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 16,
                      color: AppColors.textLight,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
